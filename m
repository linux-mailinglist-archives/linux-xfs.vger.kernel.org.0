Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75D0146009
	for <lists+linux-xfs@lfdr.de>; Fri, 14 Jun 2019 16:07:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728268AbfFNOHH (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 14 Jun 2019 10:07:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59374 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727587AbfFNOHH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 14 Jun 2019 10:07:07 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E9AAEC18B2F5;
        Fri, 14 Jun 2019 14:07:06 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9271019C67;
        Fri, 14 Jun 2019 14:07:06 +0000 (UTC)
Date:   Fri, 14 Jun 2019 10:07:04 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 14/14] xfs: poll waiting for quotacheck
Message-ID: <20190614140704.GF26586@bfoster>
References: <156032205136.3774243.15725828509940520561.stgit@magnolia>
 <156032214200.3774243.5594376006892480443.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156032214200.3774243.5594376006892480443.stgit@magnolia>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Fri, 14 Jun 2019 14:07:06 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 11, 2019 at 11:49:02PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Create a pwork destroy function that uses polling instead of
> uninterruptible sleep to wait for work items to finish so that we can
> touch the softlockup watchdog.  IOWs, gross hack.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_iwalk.c |    3 +++
>  fs/xfs/xfs_iwalk.h |    3 ++-
>  fs/xfs/xfs_pwork.c |   19 +++++++++++++++++++
>  fs/xfs/xfs_pwork.h |    3 +++
>  fs/xfs/xfs_qm.c    |    2 +-
>  5 files changed, 28 insertions(+), 2 deletions(-)
> 
> 
...
> diff --git a/fs/xfs/xfs_pwork.c b/fs/xfs/xfs_pwork.c
> index 8d0d5f130252..c2f02b710b8c 100644
> --- a/fs/xfs/xfs_pwork.c
> +++ b/fs/xfs/xfs_pwork.c
> @@ -13,6 +13,7 @@
>  #include "xfs_trace.h"
>  #include "xfs_sysctl.h"
>  #include "xfs_pwork.h"
> +#include <linux/nmi.h>
>  
>  /*
>   * Parallel Work Queue
> @@ -46,6 +47,8 @@ xfs_pwork_work(
>  	error = pctl->work_fn(pctl->mp, pwork);
>  	if (error && !pctl->error)
>  		pctl->error = error;
> +	atomic_dec(&pctl->nr_work);
> +	wake_up(&pctl->poll_wait);

We could use atomic_dec_and_test() here to avoid some unnecessary
wakeups. With that fixed up:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  }
>  
>  /*
> @@ -76,6 +79,8 @@ xfs_pwork_init(
>  	pctl->work_fn = work_fn;
>  	pctl->error = 0;
>  	pctl->mp = mp;
> +	atomic_set(&pctl->nr_work, 0);
> +	init_waitqueue_head(&pctl->poll_wait);
>  
>  	return 0;
>  }
> @@ -88,6 +93,7 @@ xfs_pwork_queue(
>  {
>  	INIT_WORK(&pwork->work, xfs_pwork_work);
>  	pwork->pctl = pctl;
> +	atomic_inc(&pctl->nr_work);
>  	queue_work(pctl->wq, &pwork->work);
>  }
>  
> @@ -101,6 +107,19 @@ xfs_pwork_destroy(
>  	return pctl->error;
>  }
>  
> +/*
> + * Wait for the work to finish by polling completion status and touch the soft
> + * lockup watchdog.  This is for callers such as mount which hold locks.
> + */
> +void
> +xfs_pwork_poll(
> +	struct xfs_pwork_ctl	*pctl)
> +{
> +	while (wait_event_timeout(pctl->poll_wait,
> +				atomic_read(&pctl->nr_work) == 0, HZ) == 0)
> +		touch_softlockup_watchdog();
> +}
> +
>  /*
>   * Return the amount of parallelism that the data device can handle, or 0 for
>   * no limit.
> diff --git a/fs/xfs/xfs_pwork.h b/fs/xfs/xfs_pwork.h
> index 4cf1a6f48237..ff93873df8d3 100644
> --- a/fs/xfs/xfs_pwork.h
> +++ b/fs/xfs/xfs_pwork.h
> @@ -18,6 +18,8 @@ struct xfs_pwork_ctl {
>  	struct workqueue_struct	*wq;
>  	struct xfs_mount	*mp;
>  	xfs_pwork_work_fn	work_fn;
> +	struct wait_queue_head	poll_wait;
> +	atomic_t		nr_work;
>  	int			error;
>  };
>  
> @@ -53,6 +55,7 @@ int xfs_pwork_init(struct xfs_mount *mp, struct xfs_pwork_ctl *pctl,
>  		unsigned int nr_threads);
>  void xfs_pwork_queue(struct xfs_pwork_ctl *pctl, struct xfs_pwork *pwork);
>  int xfs_pwork_destroy(struct xfs_pwork_ctl *pctl);
> +void xfs_pwork_poll(struct xfs_pwork_ctl *pctl);
>  unsigned int xfs_pwork_guess_datadev_parallelism(struct xfs_mount *mp);
>  
>  #endif /* __XFS_PWORK_H__ */
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index 8004c931c86e..8bb902125403 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -1304,7 +1304,7 @@ xfs_qm_quotacheck(
>  		flags |= XFS_PQUOTA_CHKD;
>  	}
>  
> -	error = xfs_iwalk_threaded(mp, 0, xfs_qm_dqusage_adjust, 0, NULL);
> +	error = xfs_iwalk_threaded(mp, 0, xfs_qm_dqusage_adjust, 0, true, NULL);
>  	if (error)
>  		goto error_return;
>  
> 
