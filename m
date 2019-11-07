Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70F80F2922
	for <lists+linux-xfs@lfdr.de>; Thu,  7 Nov 2019 09:32:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727265AbfKGIb7 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 7 Nov 2019 03:31:59 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:58154 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726734AbfKGIb7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Nov 2019 03:31:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=WW6jGGidg+wVvM110IxonUdnYAV1PH+DBVoY5IU/6co=; b=Xgxfy0Q+yChJGTaJXLFuGtnfB
        kW34elUjuRZ41ZbnhclEkMJvYs+5qC1U0I6rbKTrfn9SJ9bEqaG/4O9BqGwx5ET+FPRITJQD61D2r
        ssvKjr40BIfC3z3509A/8948Lt4GxbL1We2M8QT/SPd2oZxCnUPqaBQzNpn98rUR840EFjvRjNOHv
        T8lS6VwQ3QFyHIUYD1uvuCmwcVm3U9my4s70X/K3MBLPMSJoyhk0FuloFKOAJ/6VuPl3u6mLmsWow
        FbqNusOUQMhlsjBwth5+D7oJaVkKo+76kCEQdiWQlSwp+XXCoweBpVzzHfPXE7wTBFf4SeCmO/EE8
        yVp0gy/6g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iSdCw-0003Ql-Kb; Thu, 07 Nov 2019 08:31:58 +0000
Date:   Thu, 7 Nov 2019 00:31:58 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/6] xfs: annotate functions that trip static checker
 locking checks
Message-ID: <20191107083158.GA6729@infradead.org>
References: <157309573874.46520.18107298984141751739.stgit@magnolia>
 <157309574505.46520.7461860244690955225.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157309574505.46520.7461860244690955225.stgit@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 06, 2019 at 07:02:25PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add some lock annotations to helper functions that seem to have
> unbalanced locking that confuses the static analyzers.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_log.c      |    1 +
>  fs/xfs/xfs_log_priv.h |    5 ++++-
>  2 files changed, 5 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index d7d3bfd6a920..1b4e37bbce53 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -2808,6 +2808,7 @@ xlog_state_do_iclog_callbacks(
>  	struct xlog		*log,
>  	struct xlog_in_core	*iclog,
>  	bool			aborted)
> +	__releases(&log->l_icloglock) __acquires(&log->l_icloglock)

The indentation looks really awkward.  I think this should be be:

	bool                    aborted)
		__releases(&log->l_icloglock)
		__acquires(&log->l_icloglock)

> +static inline void
> +xlog_wait(
> +	struct wait_queue_head	*wq,
> +	struct spinlock		*lock) __releases(lock)
>  {
>  	DECLARE_WAITQUEUE(wait, current);

Same here.
