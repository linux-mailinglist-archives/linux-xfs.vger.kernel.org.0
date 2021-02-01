Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 735F330A7AD
	for <lists+linux-xfs@lfdr.de>; Mon,  1 Feb 2021 13:33:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229593AbhBAMd3 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 1 Feb 2021 07:33:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbhBAMd3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Feb 2021 07:33:29 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F39DC061573
        for <linux-xfs@vger.kernel.org>; Mon,  1 Feb 2021 04:32:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Y9iaR7dkDS85itum1Q578ljEPc+tqHvJU+mw7kK5gdM=; b=TAgCZj9/obN0QCYxyQ0i9n3rx5
        18odxOHJZvvWnCNDq4UgvUCQy7kO8zZM1/I6tf9Szbhm+H4jFTlqnfE7ZSIBdVdHQdE7Rh/UZtPaU
        6RssISC64SWz2T7L9PLhN1KRI2btX2VRlTm9C2pHoR6YV3Nqseg9A61S+cTZXNXdu1djHlXeWlaBG
        J3WDI3kR+r6Z5jiq5qDL6e787PCqdQGN31eTBXhyjf4hxpG4PQh3YJgTl+1Rf3Op+ABn29XjsEajK
        iMcVaLMmsgLg6WB1d1Kje+kp5FzdIUOs9u+n9vhB6DbEOgBzve3oBMdLCsLW4P415AHxaaTIXTQXp
        aejJlUJw==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l6YNp-00DlKu-54; Mon, 01 Feb 2021 12:32:45 +0000
Date:   Mon, 1 Feb 2021 12:32:45 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com,
        bfoster@redhat.com
Subject: Re: [PATCH 07/12] xfs: flush eof/cowblocks if we can't reserve quota
 for file blocks
Message-ID: <20210201123245.GA3279223@infradead.org>
References: <161214512641.140945.11651856181122264773.stgit@magnolia>
 <161214516600.140945.4401509001858536727.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161214516600.140945.4401509001858536727.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jan 31, 2021 at 06:06:06PM -0800, Darrick J. Wong wrote:
> @@ -1046,8 +1047,10 @@ xfs_trans_alloc_inode(
>  {
>  	struct xfs_trans	*tp;
>  	struct xfs_mount	*mp = ip->i_mount;
> +	bool			retried = false;
>  	int			error;
>  
> +retry:
>  	error = xfs_trans_alloc(mp, resv, dblocks,
>  			rblocks / mp->m_sb.sb_rextsize,
>  			force ? XFS_TRANS_RESERVE : 0, &tp);
> @@ -1065,6 +1068,13 @@ xfs_trans_alloc_inode(
>  	}
>  
>  	error = xfs_trans_reserve_quota_nblks(tp, ip, dblocks, rblocks, force);
> +	if (!retried && (error == -EDQUOT || error == -ENOSPC)) {

Nit: writing this as

	if ((error == -EDQUOT || error == -ENOSPC) && !retried) {

would make reading the line a little bit easier at least to me because
it checks the variable assigned in the line above first.

Otherwise this looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
