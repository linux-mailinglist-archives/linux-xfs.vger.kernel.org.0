Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A93F4F5285
	for <lists+linux-xfs@lfdr.de>; Wed,  6 Apr 2022 04:54:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233606AbiDFCyj (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 5 Apr 2022 22:54:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1452415AbiDEPyx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Apr 2022 11:54:53 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46F67344E3
        for <linux-xfs@vger.kernel.org>; Tue,  5 Apr 2022 07:55:13 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 2510168AFE; Tue,  5 Apr 2022 16:55:10 +0200 (CEST)
Date:   Tue, 5 Apr 2022 16:55:09 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/5] xfs: replace xfs_buf_incore with an XBF_NOALLOC
 flag to xfs_buf_get*
Message-ID: <20220405145509.GA15992@lst.de>
References: <20220403120119.235457-1-hch@lst.de> <20220403120119.235457-3-hch@lst.de> <20220403215443.GO1544202@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220403215443.GO1544202@dread.disaster.area>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 04, 2022 at 07:54:43AM +1000, Dave Chinner wrote:
> /*
>  * Lock and return the buffer that matches the requested range if
>  * and only if it is present in the cache already.
>  */
> static inline struct xfs_buf *
> xfs_buf_incore(
> 	struct xfs_buftarg	*target,
> 	xfs_daddr_t		blkno,
> 	size_t			numblks,
> 	xfs_buf_flags_t		flags)
> {
> 	struct xfs_buf		*bp;
> 	int			error;
> 	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
> 
> 	error = xfs_buf_get_map(target, &map, 1, _XBF_NOALLOC | flags,
> 				NULL, &bp);
> 	if (error)
> 		return NULL;
> 	return bp;
> }
> 
> Then none of the external callers need to be changed, and we don't
> introduce new external xfs_buf_get() callers.

I had that earlier, but having xfs_buf_incore as the odd one out that
still returns a buffer (like most XFS buffer cache routines did back
a long time ago) just did seem pretty odd compared tothe rest.
