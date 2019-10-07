Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FF0FCE0E7
	for <lists+linux-xfs@lfdr.de>; Mon,  7 Oct 2019 13:52:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727675AbfJGLwR (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 7 Oct 2019 07:52:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53154 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727490AbfJGLwR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 7 Oct 2019 07:52:17 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DAFA530833C1;
        Mon,  7 Oct 2019 11:52:16 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1D9D45C1D4;
        Mon,  7 Oct 2019 11:52:16 +0000 (UTC)
Date:   Mon, 7 Oct 2019 07:52:14 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Ian Kent <raven@themaw.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v4 16/17] xfs: mount-api - switch to new mount-api
Message-ID: <20191007115214.GD22140@bfoster>
References: <157009817203.13858.7783767645177567968.stgit@fedora-28>
 <157009840329.13858.8492534094783012202.stgit@fedora-28>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157009840329.13858.8492534094783012202.stgit@fedora-28>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Mon, 07 Oct 2019 11:52:16 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 03, 2019 at 06:26:43PM +0800, Ian Kent wrote:
> The infrastructure needed to use the new mount api is now
> in place, switch over to use it.
> 
> Signed-off-by: Ian Kent <raven@themaw.net>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_super.c |  321 ++++++++--------------------------------------------
>  1 file changed, 49 insertions(+), 272 deletions(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 919afd7082b7..93f42160aa6f 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -439,132 +439,6 @@ xfs_validate_params(
>  	return 0;
>  }
>  
> -/*
> - * This function fills in xfs_mount_t fields based on mount args.
> - * Note: the superblock has _not_ yet been read in.
> - *
> - * Note that this function leaks the various device name allocations on
> - * failure.  The caller takes care of them.
> - *
> - * *sb is const because this is also used to test options on the remount
> - * path, and we don't want this to have any side effects at remount time.
> - * Today this function does not change *sb, but just to future-proof...
> - */
> -STATIC int
> -xfs_parseargs(
> -	struct xfs_mount	*mp,
> -	char			*options)
> -{
> -	const struct super_block *sb = mp->m_super;
> -	char			*p;
> -	struct fs_context	fc;
> -	struct xfs_fs_context	context;
> -	struct xfs_fs_context	*ctx;
> -	int			ret;
> -
> -	memset(&fc, 0, sizeof(fc));
> -	memset(&context, 0, sizeof(context));
> -	fc.fs_private = &context;
> -	ctx = &context;
> -	fc.s_fs_info = mp;
> -
> -	/*
> -	 * set up the mount name first so all the errors will refer to the
> -	 * correct device.
> -	 */
> -	mp->m_fsname = kstrndup(sb->s_id, MAXNAMELEN, GFP_KERNEL);
> -	if (!mp->m_fsname)
> -		return -ENOMEM;
> -	mp->m_fsname_len = strlen(mp->m_fsname) + 1;
> -
> -	/*
> -	 * Copy binary VFS mount flags we are interested in.
> -	 */
> -	if (sb_rdonly(sb))
> -		mp->m_flags |= XFS_MOUNT_RDONLY;
> -	if (sb->s_flags & SB_DIRSYNC)
> -		mp->m_flags |= XFS_MOUNT_DIRSYNC;
> -	if (sb->s_flags & SB_SYNCHRONOUS)
> -		mp->m_flags |= XFS_MOUNT_WSYNC;
> -
> -	/*
> -	 * Set some default flags that could be cleared by the mount option
> -	 * parsing.
> -	 */
> -	mp->m_flags |= XFS_MOUNT_COMPAT_IOSIZE;
> -
> -	/*
> -	 * These can be overridden by the mount option parsing.
> -	 */
> -	mp->m_logbufs = -1;
> -	mp->m_logbsize = -1;
> -
> -	if (!options)
> -		goto done;
> -
> -	while ((p = strsep(&options, ",")) != NULL) {
> -		struct fs_parameter	param;
> -		char			*value;
> -
> -		if (!*p)
> -			continue;
> -
> -		param.key = p;
> -		param.type = fs_value_is_string;
> -		param.string = NULL;
> -		param.size = 0;
> -
> -		value = strchr(p, '=');
> -		if (value) {
> -			*value++ = 0;
> -			param.size = strlen(value);
> -			if (param.size > 0) {
> -				param.string = kmemdup_nul(value,
> -							   param.size,
> -							   GFP_KERNEL);
> -				if (!param.string)
> -					return -ENOMEM;
> -			}
> -		}
> -
> -		ret = xfs_parse_param(&fc, &param);
> -		kfree(param.string);
> -		if (ret < 0)
> -			return ret;
> -	}
> -
> -	if ((mp->m_flags & XFS_MOUNT_NOALIGN) &&
> -	    (ctx->dsunit || ctx->dswidth)) {
> -		xfs_warn(mp,
> -	"sunit and swidth options incompatible with the noalign option");
> -		return -EINVAL;
> -	}
> -
> -#ifndef CONFIG_XFS_QUOTA
> -	if (XFS_IS_QUOTA_RUNNING(mp)) {
> -		xfs_warn(mp, "quota support not available in this kernel.");
> -		return -EINVAL;
> -	}
> -#endif
> -
> -	if ((ctx->dsunit && !ctx->dswidth) || (!ctx->dsunit && ctx->dswidth)) {
> -		xfs_warn(mp, "sunit and swidth must be specified together");
> -		return -EINVAL;
> -	}
> -
> -	if (ctx->dsunit && (ctx->dswidth % ctx->dsunit != 0)) {
> -		xfs_warn(mp,
> -	"stripe width (%d) must be a multiple of the stripe unit (%d)",
> -			ctx->dswidth, ctx->dsunit);
> -		return -EINVAL;
> -	}
> -
> -done:
> -	ret = xfs_validate_params(mp, &context, false);
> -
> -	return ret;
> -}
> -
>  struct proc_xfs_info {
>  	uint64_t	flag;
>  	char		*str;
> @@ -1343,26 +1217,6 @@ xfs_quiesce_attr(
>  	xfs_log_quiesce(mp);
>  }
>  
> -STATIC int
> -xfs_test_remount_options(
> -	struct super_block	*sb,
> -	char			*options)
> -{
> -	int			error = 0;
> -	struct xfs_mount	*tmp_mp;
> -
> -	tmp_mp = kmem_zalloc(sizeof(*tmp_mp), KM_MAYFAIL);
> -	if (!tmp_mp)
> -		return -ENOMEM;
> -
> -	tmp_mp->m_super = sb;
> -	error = xfs_parseargs(tmp_mp, options);
> -	xfs_free_fsname(tmp_mp);
> -	kmem_free(tmp_mp);
> -
> -	return error;
> -}
> -
>  STATIC int
>  xfs_remount_rw(
>  	struct xfs_mount	*mp)
> @@ -1466,84 +1320,6 @@ xfs_remount_ro(
>  	return 0;
>  }
>  
> -STATIC int
> -xfs_fs_remount(
> -	struct super_block	*sb,
> -	int			*flags,
> -	char			*options)
> -{
> -	struct xfs_mount	*mp = XFS_M(sb);
> -	xfs_sb_t		*sbp = &mp->m_sb;
> -	substring_t		args[MAX_OPT_ARGS];
> -	char			*p;
> -	int			error;
> -
> -	/* First, check for complete junk; i.e. invalid options */
> -	error = xfs_test_remount_options(sb, options);
> -	if (error)
> -		return error;
> -
> -	sync_filesystem(sb);
> -	while ((p = strsep(&options, ",")) != NULL) {
> -		int token;
> -
> -		if (!*p)
> -			continue;
> -
> -		token = match_token(p, tokens, args);
> -		switch (token) {
> -		case Opt_inode64:
> -			mp->m_flags &= ~XFS_MOUNT_SMALL_INUMS;
> -			mp->m_maxagi = xfs_set_inode_alloc(mp, sbp->sb_agcount);
> -			break;
> -		case Opt_inode32:
> -			mp->m_flags |= XFS_MOUNT_SMALL_INUMS;
> -			mp->m_maxagi = xfs_set_inode_alloc(mp, sbp->sb_agcount);
> -			break;
> -		default:
> -			/*
> -			 * Logically we would return an error here to prevent
> -			 * users from believing they might have changed
> -			 * mount options using remount which can't be changed.
> -			 *
> -			 * But unfortunately mount(8) adds all options from
> -			 * mtab and fstab to the mount arguments in some cases
> -			 * so we can't blindly reject options, but have to
> -			 * check for each specified option if it actually
> -			 * differs from the currently set option and only
> -			 * reject it if that's the case.
> -			 *
> -			 * Until that is implemented we return success for
> -			 * every remount request, and silently ignore all
> -			 * options that we can't actually change.
> -			 */
> -#if 0
> -			xfs_info(mp,
> -		"mount option \"%s\" not supported for remount", p);
> -			return -EINVAL;
> -#else
> -			break;
> -#endif
> -		}
> -	}
> -
> -	/* ro -> rw */
> -	if ((mp->m_flags & XFS_MOUNT_RDONLY) && !(*flags & SB_RDONLY)) {
> -		error = xfs_remount_rw(mp);
> -		if (error)
> -			return error;
> -	}
> -
> -	/* rw -> ro */
> -	if (!(mp->m_flags & XFS_MOUNT_RDONLY) && (*flags & SB_RDONLY)) {
> -		error = xfs_remount_ro(mp);
> -		if (error)
> -			return error;
> -	}
> -
> -	return 0;
> -}
> -
>  /*
>   * There can be problems with options passed from mount(8) when
>   * only the mount point path is given. The options are a merge
> @@ -1981,42 +1757,6 @@ __xfs_fs_fill_super(
>  	goto out_free_sb;
>  }
>  
> -STATIC int
> -xfs_fs_fill_super(
> -	struct super_block	*sb,
> -	void			*data,
> -	int			silent)
> -{
> -	struct xfs_mount	*mp;
> -	int			error;
> -
> -	/*
> -	 * allocate mp and do all low-level struct initializations before we
> -	 * attach it to the super
> -	 */
> -	mp = xfs_mount_alloc();
> -	if (!mp)
> -		return -ENOMEM;
> -	mp->m_super = sb;
> -	sb->s_fs_info = mp;
> -
> -	error = xfs_parseargs(mp, (char *)data);
> -	if (error)
> -		goto out_free_fsname;
> -
> -	error = __xfs_fs_fill_super(mp, silent);
> -	if (error)
> -		goto out_free_fsname;
> -
> -	return 0;
> -
> - out_free_fsname:
> -	sb->s_fs_info = NULL;
> -	xfs_free_fsname(mp);
> -	kfree(mp);
> -	return error;
> -}
> -
>  STATIC int
>  xfs_fill_super(
>  	struct super_block	*sb,
> @@ -2087,16 +1827,6 @@ xfs_fs_put_super(
>  	kfree(mp);
>  }
>  
> -STATIC struct dentry *
> -xfs_fs_mount(
> -	struct file_system_type	*fs_type,
> -	int			flags,
> -	const char		*dev_name,
> -	void			*data)
> -{
> -	return mount_bdev(fs_type, flags, dev_name, data, xfs_fs_fill_super);
> -}
> -
>  static long
>  xfs_fs_nr_cached_objects(
>  	struct super_block	*sb,
> @@ -2126,7 +1856,6 @@ static const struct super_operations xfs_super_operations = {
>  	.freeze_fs		= xfs_fs_freeze,
>  	.unfreeze_fs		= xfs_fs_unfreeze,
>  	.statfs			= xfs_fs_statfs,
> -	.remount_fs		= xfs_fs_remount,
>  	.show_options		= xfs_fs_show_options,
>  	.nr_cached_objects	= xfs_fs_nr_cached_objects,
>  	.free_cached_objects	= xfs_fs_free_cached_objects,
> @@ -2164,10 +1893,58 @@ static const struct fs_context_operations xfs_context_ops = {
>  	.free        = xfs_fc_free,
>  };
>  
> +/*
> + * Set up the filesystem mount context.
> + */
> +int xfs_init_fs_context(struct fs_context *fc)
> +{
> +	struct xfs_fs_context	*ctx;
> +	struct xfs_mount	*mp;
> +
> +	ctx = kzalloc(sizeof(struct xfs_fs_context), GFP_KERNEL);
> +	if (!ctx)
> +		return -ENOMEM;
> +
> +	mp = xfs_mount_alloc();
> +	if (!mp) {
> +		kfree(ctx);
> +		return -ENOMEM;
> +	}
> +
> +	/*
> +	 * Set some default flags that could be cleared by the mount option
> +	 * parsing.
> +	 */
> +	mp->m_flags |= XFS_MOUNT_COMPAT_IOSIZE;
> +
> +	/*
> +	 * These can be overridden by the mount option parsing.
> +	 */
> +	mp->m_logbufs = -1;
> +	mp->m_logbsize = -1;
> +
> +	/*
> +	 * Copy binary VFS mount flags we are interested in.
> +	 */
> +	if (fc->sb_flags & SB_RDONLY)
> +		mp->m_flags |= XFS_MOUNT_RDONLY;
> +	if (fc->sb_flags & SB_DIRSYNC)
> +		mp->m_flags |= XFS_MOUNT_DIRSYNC;
> +	if (fc->sb_flags & SB_SYNCHRONOUS)
> +		mp->m_flags |= XFS_MOUNT_WSYNC;
> +
> +	fc->fs_private = ctx;
> +	fc->s_fs_info = mp;
> +	fc->ops = &xfs_context_ops;
> +
> +	return 0;
> +}
> +
>  static struct file_system_type xfs_fs_type = {
>  	.owner			= THIS_MODULE,
>  	.name			= "xfs",
> -	.mount			= xfs_fs_mount,
> +	.init_fs_context	= xfs_init_fs_context,
> +	.parameters		= &xfs_fs_parameters,
>  	.kill_sb		= kill_block_super,
>  	.fs_flags		= FS_REQUIRES_DEV,
>  };
> 
