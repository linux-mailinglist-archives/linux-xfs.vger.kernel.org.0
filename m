Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C48F4674101
	for <lists+linux-xfs@lfdr.de>; Thu, 19 Jan 2023 19:31:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230146AbjASSb0 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 19 Jan 2023 13:31:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230303AbjASSbU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Jan 2023 13:31:20 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33C318F6D7
        for <linux-xfs@vger.kernel.org>; Thu, 19 Jan 2023 10:31:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=t9UxbpHDy8B2CWxwrUYy6MminNG7B/Y2phrwOxHkKcI=; b=Y6HiqFpKBrowhHTLbKemf8vguV
        ax/4DT+VY2FsB0Co/l2II+1DQfIobcY/aua7wUJ2cr5B8dYvpxycGOIgGudaGOCArsWeY5y1HPu+l
        PiOzYCGqDiXESSeC5tHE4Cb9ymCskikbbYhiLiJ4Tgs/tLaTiZmd/8clrFdOZRkTrKUROTTuPo6fR
        rhzv/ldDD5sGfeklLNgQUU2hAFdq1uckg89SpU87+1azSXdydxgvk3NnCY2gE/AxTJxF0ROCLHWQR
        GaaMWv/nxHm4khFm47b2J6dM2Ai5vNAOJBbPjPd6a58tHlbIrQ4glNUzF587sXuPVfLylZVdbqEvE
        u+5LrifA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pIZgo-006Zmu-4y; Thu, 19 Jan 2023 18:31:06 +0000
Date:   Thu, 19 Jan 2023 10:31:06 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: recheck appropriateness of map_shared lock
Message-ID: <Y8mMailEevUSZkG+@infradead.org>
References: <Y8ib6ls32e/pJezE@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y8ib6ls32e/pJezE@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 18, 2023 at 05:24:58PM -0800, Darrick J. Wong wrote:
>  	xfs_ilock(ip, lock_mode);
> +
> +	/*
> +	 * It's possible that the unlocked access of the data fork to determine
> +	 * the lock mode could have raced with another thread that was failing
> +	 * to load the bmbt but hadn't yet torn down the iext tree.  Recheck
> +	 * the lock mode and upgrade to an exclusive lock if we need to.
> +	 */
> +	if (lock_mode == XFS_ILOCK_SHARED &&
> +	    xfs_need_iread_extents(&ip->i_df)) {

Eww.  I think the proper fix here is to make sure
xfs_need_iread_extents does not return false until we're actually
read the extents.  So I think we'll need a new inode flag
XFS_INEED_READ - gets set when reading inode in btree format,
and gets cleared at the very end of xfs_iread_extents once we know
the read succeeded.
