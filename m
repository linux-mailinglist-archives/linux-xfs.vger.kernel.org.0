Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E727586F7E
	for <lists+linux-xfs@lfdr.de>; Mon,  1 Aug 2022 19:24:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232143AbiHARYa (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 1 Aug 2022 13:24:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231779AbiHARY3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Aug 2022 13:24:29 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D5F9626D
        for <linux-xfs@vger.kernel.org>; Mon,  1 Aug 2022 10:24:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=cS6fHTHvi8yIcGZUq/TWwAxeS6wt6GNtgRluFqmkQ+Q=; b=OHE+Vj7qT3KyW7BykyR7ORZHlr
        pE+SHN7q6xYCn0IucH7ara6Fir5WcVdAX2jSkmOQijv5nLCcWXxfNAu5V8Jv/nxMQ19ngPvsOSw00
        AbBIno1391ub+epru5NyLYe9HjHcgP7/XXkdNyOYpzdV9K7q5LUlpRBOmL/g7ardKSVyNfU0JJVCg
        OzjxYuabP9M1w6ZJyg8En9cD1cmLVPRERsimRR18s0UHf8cC1rZ4z7hwqCKfW9Y0ffD9V7fphppmG
        BODPsaiVIbi2p+yL1d6DZZPrb6vAmbU3+a/S4u0n4undWcYHdgko00gH0MFmiF5l+1MVMdoHLx+kD
        ajgyXLQA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oIZ9X-008DgJ-Qo; Mon, 01 Aug 2022 17:24:27 +0000
Date:   Mon, 1 Aug 2022 10:24:27 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: check return codes when flushing block devices
Message-ID: <YugMS4G9p+JduBmq@infradead.org>
References: <YuasRCKeYsKlCgPM@magnolia>
 <20220801000641.GZ3600936@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220801000641.GZ3600936@dread.disaster.area>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 01, 2022 at 10:06:41AM +1000, Dave Chinner wrote:
> > @@ -173,8 +175,11 @@ xfs_file_fsync(
> >  	 * that happen concurrently to the fsync call, but fsync semantics
> >  	 * only require to sync previously completed I/O.
> >  	 */
> > -	if (xfs_ipincount(ip))
> > +	if (xfs_ipincount(ip)) {
> >  		error = xfs_fsync_flush_log(ip, datasync, &log_flushed);
> > +		if (error)
> > +			return error;
> > +	}
> 
> Shouldn't we still try to flush the data device if necessary, even
> if the log flush failed?

xfs_fsync_flush_log ails only if the log it shut down.  Does it really
make sense to flush the data cache for a pure overwrite of a data
block when the fs is toast?  I can't really see any benefit in that.

> > +		if (log->l_targ != log->l_mp->m_ddev_targp &&
> > +		    blkdev_issue_flush(log->l_mp->m_ddev_targp->bt_bdev)) {
> > +			xlog_force_shutdown(log, SHUTDOWN_LOG_IO_ERROR);
> > +			return;
> > +		}
> 
> That seems pretty drastic, though I'm not sure what else apart from
> ignoring the data device flush error can be done here. Also, it's
> not actually a log IO error - it's a data device IO error so it's a
> really a metadata writeback problem. Hence the use of
> SHUTDOWN_LOG_IO_ERROR probably needs a comment to explain why it
> needs to be used here...

Yes, the comment would be useful.  But if a cache flush fails data
integrity of the device must at this point be considered as fucked
up beyond belief, so shutting down the log and thus the file system
is the right thing to do.

So modulo a comment here the patch looks good to me.
