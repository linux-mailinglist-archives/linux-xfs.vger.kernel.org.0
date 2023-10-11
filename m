Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC3637C5D40
	for <lists+linux-xfs@lfdr.de>; Wed, 11 Oct 2023 20:57:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232525AbjJKS5u (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 11 Oct 2023 14:57:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232224AbjJKS5t (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Oct 2023 14:57:49 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B90BA4
        for <linux-xfs@vger.kernel.org>; Wed, 11 Oct 2023 11:57:48 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 197CEC433C8;
        Wed, 11 Oct 2023 18:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697050668;
        bh=md0eAwO2RuaKpKYfnZmt11duYrC/TEOWdDZV4LBa+WU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TfbAhjgevfygUci+sVF7H8c5w91Dc5kwewpjg1iuhsCM5JDmo/09s5Cth+28vGrVD
         +p0GS1zNy2+NrBMZOW7rhifVk5zBH5WeD01Q5voS8I22uhc1ANdGIivh40YWYW958C
         GPJW/VuX9P03ddcYeqaL3TETgsH9EAu54socjMA1OFzhWz/2TRrPy1C91SvZOFIlWC
         oJ+jsud5dF1yArEpAjp7nn54SSnQevgTxG3GLIhDOxCRM6bZ5qcQniGuvRxBloMJHq
         DHm29xNWum5H8/MWLLSEEPpPKK+yO9JEPLNjBYpgQ3HmpJ/rl0nujYURA52BbkG3VQ
         X79HF/krNwpng==
Date:   Wed, 11 Oct 2023 11:57:47 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Andrey Albershteyn <aalbersh@redhat.com>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        fsverity@lists.linux.dev, ebiggers@kernel.org, david@fromorbit.com,
        dchinner@redhat.com
Subject: Re: [PATCH v3 21/28] xfs: add inode on-disk VERITY flag
Message-ID: <20231011185747.GU21298@frogsfrogsfrogs>
References: <20231006184922.252188-1-aalbersh@redhat.com>
 <20231006184922.252188-22-aalbersh@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231006184922.252188-22-aalbersh@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 06, 2023 at 08:49:15PM +0200, Andrey Albershteyn wrote:
> Add flag to mark inodes which have fs-verity enabled on them (i.e.
> descriptor exist and tree is built).
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
> ---
>  fs/ioctl.c                 | 4 ++++
>  fs/xfs/libxfs/xfs_format.h | 4 +++-
>  fs/xfs/xfs_inode.c         | 2 ++
>  fs/xfs/xfs_iops.c          | 2 ++
>  4 files changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ioctl.c b/fs/ioctl.c
> index f5fd99d6b0d4..81a69cb8016b 100644
> --- a/fs/ioctl.c
> +++ b/fs/ioctl.c
> @@ -481,6 +481,8 @@ void fileattr_fill_xflags(struct fileattr *fa, u32 xflags)
>  		fa->flags |= FS_DAX_FL;
>  	if (fa->fsx_xflags & FS_XFLAG_PROJINHERIT)
>  		fa->flags |= FS_PROJINHERIT_FL;
> +	if (fa->fsx_xflags & FS_XFLAG_VERITY)
> +		fa->flags |= FS_VERITY_FL;
>  }
>  EXPORT_SYMBOL(fileattr_fill_xflags);
>  
> @@ -511,6 +513,8 @@ void fileattr_fill_flags(struct fileattr *fa, u32 flags)
>  		fa->fsx_xflags |= FS_XFLAG_DAX;
>  	if (fa->flags & FS_PROJINHERIT_FL)
>  		fa->fsx_xflags |= FS_XFLAG_PROJINHERIT;
> +	if (fa->flags & FS_VERITY_FL)
> +		fa->fsx_xflags |= FS_XFLAG_VERITY;
>  }
>  EXPORT_SYMBOL(fileattr_fill_flags);
>  
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index ef617be2839c..ccb2ae5c2c93 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -1070,16 +1070,18 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
>  #define XFS_DIFLAG2_COWEXTSIZE_BIT   2  /* copy on write extent size hint */
>  #define XFS_DIFLAG2_BIGTIME_BIT	3	/* big timestamps */
>  #define XFS_DIFLAG2_NREXT64_BIT 4	/* large extent counters */
> +#define XFS_DIFLAG2_VERITY_BIT	5	/* inode sealed by fsverity */
>  
>  #define XFS_DIFLAG2_DAX		(1 << XFS_DIFLAG2_DAX_BIT)
>  #define XFS_DIFLAG2_REFLINK     (1 << XFS_DIFLAG2_REFLINK_BIT)
>  #define XFS_DIFLAG2_COWEXTSIZE  (1 << XFS_DIFLAG2_COWEXTSIZE_BIT)
>  #define XFS_DIFLAG2_BIGTIME	(1 << XFS_DIFLAG2_BIGTIME_BIT)
>  #define XFS_DIFLAG2_NREXT64	(1 << XFS_DIFLAG2_NREXT64_BIT)
> +#define XFS_DIFLAG2_VERITY	(1 << XFS_DIFLAG2_VERITY_BIT)
>  
>  #define XFS_DIFLAG2_ANY \
>  	(XFS_DIFLAG2_DAX | XFS_DIFLAG2_REFLINK | XFS_DIFLAG2_COWEXTSIZE | \
> -	 XFS_DIFLAG2_BIGTIME | XFS_DIFLAG2_NREXT64)
> +	 XFS_DIFLAG2_BIGTIME | XFS_DIFLAG2_NREXT64 | XFS_DIFLAG2_VERITY)
>  
>  static inline bool xfs_dinode_has_bigtime(const struct xfs_dinode *dip)
>  {
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 4d55f58d99b7..94eb33abcb8f 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -634,6 +634,8 @@ xfs_ip2xflags(
>  			flags |= FS_XFLAG_DAX;
>  		if (ip->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE)
>  			flags |= FS_XFLAG_COWEXTSIZE;
> +		if (ip->i_diflags2 & XFS_DIFLAG2_VERITY)
> +			flags |= FS_XFLAG_VERITY;
>  	}
>  
>  	if (xfs_inode_has_attr_fork(ip))
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 1c1e6171209d..9f2d5c2505ae 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -1237,6 +1237,8 @@ xfs_diflags_to_iflags(
>  		flags |= S_NOATIME;
>  	if (init && xfs_inode_should_enable_dax(ip))
>  		flags |= S_DAX;
> +	if (xflags & FS_XFLAG_VERITY)
> +		flags |= S_VERITY;
>  
>  	/*
>  	 * S_DAX can only be set during inode initialization and is never set by

I think Eric Biggers already covered this, but I don't think you can let
the FSSETXATTR ioctl set FS_XFLAG_VERITY.

--D

> -- 
> 2.40.1
> 
