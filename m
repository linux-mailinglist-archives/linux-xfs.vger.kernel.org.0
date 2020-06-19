Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A359200A91
	for <lists+linux-xfs@lfdr.de>; Fri, 19 Jun 2020 15:46:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732785AbgFSNqL (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 19 Jun 2020 09:46:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732695AbgFSNqL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 19 Jun 2020 09:46:11 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AD94C06174E;
        Fri, 19 Jun 2020 06:46:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=mBr2Dog35BqG+RyTNPha2esLGVpTLQRGG3cv7MWSe60=; b=soVACX5yYdkb7jdgKOmo6zfik5
        Jv2cxNQEL5SZgExWNYoWzXPVE4vzg5/Fmano1VHg6I1Jm+hIGkjgYY6w0ozdHzl8szyQioZnzuMMq
        hyxD4WgR5o1dzYTIFlcBTTsoJ+18t9KDnwbAr4vrg4zYVGF/T2THmjRU/FdwXdcq0msVmsyWiMa8w
        P2ivUKcPAyoi3iwGmDvwsM8LvDGOPu5sSoX2+UsiHjnBWo+gyZQrRrNjEiagUV2XbU+OfMA9zuE7l
        th7SQ/TWy8ee4vke7kIl9K3O32LvGlWCBxi33WQh7fHWFW7wKJyCEs8ttyoWHCk4wy9QQd/u+PcVU
        O6jz0y3w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jmHLM-0002ts-Tm; Fri, 19 Jun 2020 13:46:08 +0000
Date:   Fri, 19 Jun 2020 06:46:08 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Yu Kuai <yukuai3@huawei.com>, darrick.wong@oracle.com,
        linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        yi.zhang@huawei.com
Subject: Re: [PATCH] xfs: fix use-after-free on CIL context on shutdown
Message-ID: <20200619134608.GA32599@infradead.org>
References: <20200611013952.2589997-1-yukuai3@huawei.com>
 <20200611022848.GQ2040@dread.disaster.area>
 <20200611024503.GR2040@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200611024503.GR2040@dread.disaster.area>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 11, 2020 at 12:45:03PM +1000, Dave Chinner wrote:
> 
> From: Dave Chinner <dchinner@redhat.com>
> 
> xlog_wait() on the CIL context can reference a freed context if the
> waiter doesn't get scheduled before the CIL context is freed. This
> can happen when a task is on the hard throttle and the CIL push
> aborts due to a shutdown. This was detected by generic/019:
> 
> thread 1			thread 2
> 
> __xfs_trans_commit
>  xfs_log_commit_cil
>   <CIL size over hard throttle limit>
>   xlog_wait
>    schedule
> 				xlog_cil_push_work
> 				wake_up_all
> 				<shutdown aborts commit>
> 				xlog_cil_committed
> 				kmem_free
> 
>    remove_wait_queue
>     spin_lock_irqsave --> UAF
> 
> Fix it by moving the wait queue to the CIL rather than keeping it in
> in the CIL context that gets freed on push completion. Because the
> wait queue is now independent of the CIL context and we might have
> multiple contexts in flight at once, only wake the waiters on the
> push throttle when the context we are pushing is over the hard
> throttle size threshold.
> 
> Fixes: 0e7ab7efe7745 ("xfs: Throttle commits on delayed background CIL push")
> Reported-by: Yu Kuai <yukuai3@huawei.com>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
