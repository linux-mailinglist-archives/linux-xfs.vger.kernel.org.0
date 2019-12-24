Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EBB212A14B
	for <lists+linux-xfs@lfdr.de>; Tue, 24 Dec 2019 13:28:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726222AbfLXM2C (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 24 Dec 2019 07:28:02 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:40288 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726195AbfLXM2B (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Dec 2019 07:28:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=nlmPzzqDYf/HA5CP+DJ2A8DkcPhPYFEogiMf6y5Gxks=; b=ewF3pn62PXYTBrrKoWw63RyO2
        9OaN3+xH7ZRyscB95auofXykuD/HFzgSmBHdWaxuZGCUyrqwJddC7OZOCkwBFB0ooyCR4vbHv5J9D
        NcZNnE3EKAKMcDGFjngcT9+sZgWALJ3dzxL/lqLb3koACgxxUzsSIikCKJknAg2KN6ctfPEtID8Xc
        ysyL9gPP1c/pAnlGqInu3yX0aEPYBk2VhoXAZcQRPTekVaJA4jxitmbYLGLnaKC7Pj2i4YDJ0aILF
        UIm7iHUb0dTH3WFV4BJwZNuWx+8mgmx8KdhIMMFc7EOJueyJGRhoh8wty+VBrYPVTZoG03pe5n4cN
        g7DZhoYhA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ijjI9-0006xs-L1; Tue, 24 Dec 2019 12:28:01 +0000
Date:   Tue, 24 Dec 2019 04:28:01 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v5 11/14] xfs: Factor up trans roll in
 xfs_attr3_leaf_clearflag
Message-ID: <20191224122801.GH18379@infradead.org>
References: <20191212041513.13855-1-allison.henderson@oracle.com>
 <20191212041513.13855-12-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191212041513.13855-12-allison.henderson@oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index 343fb5e..483fb5a 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -2803,10 +2803,7 @@ xfs_attr3_leaf_clearflag(
>  			 XFS_DA_LOGRANGE(leaf, name_rmt, sizeof(*name_rmt)));
>  	}
>  
> -	/*
> -	 * Commit the flag value change and start the next trans in series.
> -	 */
> -	return xfs_trans_roll_inode(&args->trans, args->dp);
> +	return error;

error is always 0 here.
