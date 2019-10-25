Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6759E4B3F
	for <lists+linux-xfs@lfdr.de>; Fri, 25 Oct 2019 14:40:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440270AbfJYMk3 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 25 Oct 2019 08:40:29 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:54162 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2440242AbfJYMk3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Oct 2019 08:40:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=QtbhhbPXb7QjQM/pkz1Co8VX4tHxAMpHwYyYr8QpVww=; b=q6efMJKbUsP8xdZGTjRZsRky8
        IKe0GkRC34BUkU2ompHy0w6H9BOBSkyIX6+fvker1QuH2ts72vfClCAiZBp9tmqM5geDxvH2odHji
        IbST7IK871q4PJj65fItM4zwppzHrwbrIKSAGP1aDGvqm5f2ZSdnlrvS2epQMfTCX4NuB/QLmA3Lz
        CC4G6hY08hdvcllEe64ml/GGuxI0TXJ8bvk0Nrt8d9jG7HfJTVP2WO2w7AZWxKC78asTwweSOp5dw
        HWfOVtq68cPcPZkIETUMm9AQHpJtKtzVI9uyj+wabfBbKS39u11FK/WZE6jF+7RwXjU9TQG5RrWmb
        Tvx06w4UQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iNytI-0006AE-Rf; Fri, 25 Oct 2019 12:40:28 +0000
Date:   Fri, 25 Oct 2019 05:40:28 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: refactor xfs_bmap_count_blocks using newer
 btree helpers
Message-ID: <20191025124028.GA16251@infradead.org>
References: <157198051549.2873576.10430329078588571923.stgit@magnolia>
 <157198052157.2873576.11427854428031607748.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157198052157.2873576.11427854428031607748.stgit@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> +		error = xfs_btree_count_blocks(cur, &btblocks);
> +		xfs_btree_del_cursor(cur, error);
> +		if (error)
> +			return error;
> +
> +		*count += btblocks - 1;

Can you throw in a comment explaining the -1 here?  Without doing
extra research I can't think of a reason why it would be there.

> +		/* fall through */
> +	case XFS_DINODE_FMT_EXTENTS:
> +		*nextents = xfs_bmap_count_leaves(ifp, count);
>  		return 0;

I don't think you need the return statement here as there is a return 0
just below it.
