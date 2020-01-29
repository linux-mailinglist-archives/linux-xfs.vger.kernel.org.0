Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87D6114D022
	for <lists+linux-xfs@lfdr.de>; Wed, 29 Jan 2020 19:09:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727025AbgA2SJz (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 29 Jan 2020 13:09:55 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:58176 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726245AbgA2SJz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jan 2020 13:09:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=6xVGstCJbgz4ufIPRfcSM0+t1XnXH+CYkzZQGoAlCtw=; b=o6GNKbB3Y5s8jszOIdxzJcDsM
        RTSPf4yTZvzIjO/2GGJ1uIyUGqG2Zck13Z4GTJ2Ds5BHMmzhUQevbXC8u+izLcq5B7bd31naXpxnQ
        /EfZWsKYu9jzoQgcgA6AOQ7wK51BNDQuLDk/Ry+9ux/OBh490VsO6i6wE9UCHcz7UyAds7pz9zOOY
        P4G6nqOENzXYfK3oKr61U/21oCfUljT+dZYMmJtiX5lCK0YWIsgk8cbfOUOb2myHOKqjlVBHFrgm2
        4ewqwRInuc/HT7fQGQphNRh5z57lW1ixub2QP4gaPBuy7bilpSsaEknjEHPDmS/zMx72vGMcRHwzi
        +KENBtuqw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iwrmk-0005iO-UN; Wed, 29 Jan 2020 18:09:54 +0000
Date:   Wed, 29 Jan 2020 10:09:54 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 1/2] xfs: don't take addresses of packed xfs_agfl_t member
Message-ID: <20200129180954.GC14855@infradead.org>
References: <65e48930-96ae-7307-ba65-6b7528bb2fb5@redhat.com>
 <09382ee9-8539-2f1d-bd4d-7256daf38a40@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <09382ee9-8539-2f1d-bd4d-7256daf38a40@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 29, 2020 at 11:43:13AM -0600, Eric Sandeen wrote:
> gcc now warns about taking an address of a packed structure member.
> 
> Work around this by using offsetof() instead.
> 
> Thanks to bfoster for the suggestion and djwong for reiterating it.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index 1b7dcbae051c..7bfc8e2437e9 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -787,7 +787,8 @@ typedef struct xfs_agi {
>  
>  #define XFS_BUF_TO_AGFL_BNO(mp, bp) \
>  	(xfs_sb_version_hascrc(&((mp)->m_sb)) ? \
> -		&(XFS_BUF_TO_AGFL(bp)->agfl_bno[0]) : \
> +		(__be32 *)((char *)(bp)->b_addr + \
> +			offsetof(struct xfs_agfl, agfl_bno)) : \
>  		(__be32 *)(bp)->b_addr)

Yikes.  If we want to go down this route this really needs to become
an inline function (and fiven that it touches buffer is has no business
in xfs_format.h).

But I absolutely do not see the point.  If agfl_bno was unalgined
so is adding the offsetoff.  The warnings makes no sense, and there is
a good reason the kernel build turned it off.
