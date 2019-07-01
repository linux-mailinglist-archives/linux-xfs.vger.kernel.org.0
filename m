Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B948D3D03C
	for <lists+linux-xfs@lfdr.de>; Tue, 11 Jun 2019 17:08:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389502AbfFKPHP (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 11 Jun 2019 11:07:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41736 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389125AbfFKPHO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 11 Jun 2019 11:07:14 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8AA595D5E6;
        Tue, 11 Jun 2019 15:07:14 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3386760925;
        Tue, 11 Jun 2019 15:07:14 +0000 (UTC)
Date:   Tue, 11 Jun 2019 11:07:12 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/10] xfs: poll waiting for quotacheck
Message-ID: <20190611150712.GB10942@bfoster>
References: <155968496814.1657646.13743491598480818627.stgit@magnolia>
 <155968502703.1657646.17911228005649046316.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <155968502703.1657646.17911228005649046316.stgit@magnolia>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Tue, 11 Jun 2019 15:07:14 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 04, 2019 at 02:50:27PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Create a pwork destroy function that uses polling instead of
> uninterruptible sleep to wait for work items to finish so that we can
> touch the softlockup watchdog.  IOWs, gross hack.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Seems reasonable given the quirky circumstances of quotacheck. Just a
couple nits..

>  fs/xfs/xfs_iwalk.c |    3 +++
>  fs/xfs/xfs_iwalk.h |    3 ++-
>  fs/xfs/xfs_pwork.c |   21 +++++++++++++++++++++
>  fs/xfs/xfs_pwork.h |    2 ++
>  fs/xfs/xfs_qm.c    |    2 +-
>  5 files changed, 29 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_iwalk.c b/fs/xfs/xfs_iwalk.c
> index 71ee1628aa70..c4a9c4c246b7 100644
> --- a/fs/xfs/xfs_iwalk.c
> +++ b/fs/xfs/xfs_iwalk.c
> @@ -526,6 +526,7 @@ xfs_iwalk_threaded(
>  	xfs_ino_t		startino,
>  	xfs_iwalk_fn		iwalk_fn,
>  	unsigned int		max_prefetch,
> +	bool			polled,
>  	void			*data)
>  {
>  	struct xfs_pwork_ctl	pctl;
> @@ -556,5 +557,7 @@ xfs_iwalk_threaded(
>  		startino = XFS_AGINO_TO_INO(mp, agno + 1, 0);
>  	}
>  
> +	if (polled)
> +		return xfs_pwork_destroy_poll(&pctl);
>  	return xfs_pwork_destroy(&pctl);

Rather than have duplicate destruction paths, could we rework
xfs_pwork_destroy_poll() to something like xfs_pwork_poll() that just
does the polling and returns, then the caller can fall back into the
current xfs_pwork_destroy()? I.e., this ends up looking like:

	...
	/* poll to keep soft lockup watchdog quiet */
	if (polled)
		xfs_pwork_poll(&pctl);
	return xfs_pwork_destroy(&pctl);

>  }
...
> diff --git a/fs/xfs/xfs_pwork.c b/fs/xfs/xfs_pwork.c
> index 19605a3a2482..3b885e0b52ac 100644
> --- a/fs/xfs/xfs_pwork.c
> +++ b/fs/xfs/xfs_pwork.c
...
> @@ -97,6 +101,23 @@ xfs_pwork_destroy(
>  	return pctl->error;
>  }
>  
> +/*
> + * Wait for the work to finish and tear down the control structure.
> + * Continually poll completion status and touch the soft lockup watchdog.
> + * This is for things like mount that hold locks.
> + */
> +int
> +xfs_pwork_destroy_poll(
> +	struct xfs_pwork_ctl	*pctl)
> +{
> +	while (atomic_read(&pctl->nr_work) > 0) {
> +		msleep(1);
> +		touch_softlockup_watchdog();
> +	}

Any idea what the typical watchdog timeout is? I'm curious where the 1ms
comes from and whether we could get away with anything larger. I realize
that might introduce mount latency with the current sleep based
implementation, but we could also consider a waitqueue and using
something like wait_event_timeout() to schedule out for longer time
periods and still wake up immediately when the count drops to 0.

Brian

> +
> +	return xfs_pwork_destroy(pctl);
> +}
> +
>  /*
>   * Return the amount of parallelism that the data device can handle, or 0 for
>   * no limit.
> diff --git a/fs/xfs/xfs_pwork.h b/fs/xfs/xfs_pwork.h
> index e0c1354a2d8c..08da723a8dc9 100644
> --- a/fs/xfs/xfs_pwork.h
> +++ b/fs/xfs/xfs_pwork.h
> @@ -18,6 +18,7 @@ struct xfs_pwork_ctl {
>  	struct workqueue_struct	*wq;
>  	struct xfs_mount	*mp;
>  	xfs_pwork_work_fn	work_fn;
> +	atomic_t		nr_work;
>  	int			error;
>  };
>  
> @@ -45,6 +46,7 @@ int xfs_pwork_init(struct xfs_mount *mp, struct xfs_pwork_ctl *pctl,
>  		unsigned int nr_threads);
>  void xfs_pwork_queue(struct xfs_pwork_ctl *pctl, struct xfs_pwork *pwork);
>  int xfs_pwork_destroy(struct xfs_pwork_ctl *pctl);
> +int xfs_pwork_destroy_poll(struct xfs_pwork_ctl *pctl);
>  unsigned int xfs_pwork_guess_datadev_parallelism(struct xfs_mount *mp);
>  
>  #endif /* __XFS_PWORK_H__ */
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index e4f3785f7a64..de6a623ada02 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -1305,7 +1305,7 @@ xfs_qm_quotacheck(
>  		flags |= XFS_PQUOTA_CHKD;
>  	}
>  
> -	error = xfs_iwalk_threaded(mp, 0, xfs_qm_dqusage_adjust, 0, NULL);
> +	error = xfs_iwalk_threaded(mp, 0, xfs_qm_dqusage_adjust, 0, true, NULL);
>  	if (error)
>  		goto error_return;
>  
> 
