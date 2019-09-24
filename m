Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5706DBC5CE
	for <lists+linux-xfs@lfdr.de>; Tue, 24 Sep 2019 12:46:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438489AbfIXKqX (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 24 Sep 2019 06:46:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47078 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438486AbfIXKqX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 24 Sep 2019 06:46:23 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B393F81F07;
        Tue, 24 Sep 2019 10:46:22 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EA462600C8;
        Tue, 24 Sep 2019 10:46:21 +0000 (UTC)
Date:   Tue, 24 Sep 2019 06:46:20 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Ian Kent <raven@themaw.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH v3 05/16] xfs: mount-api - refactor xfs_parseags()
Message-ID: <20190924104620.GG13820@bfoster>
References: <156897321789.20210.339237101446767141.stgit@fedora-28>
 <156897335938.20210.4456134010246885528.stgit@fedora-28>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156897335938.20210.4456134010246885528.stgit@fedora-28>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Tue, 24 Sep 2019 10:46:22 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Sep 20, 2019 at 05:55:59PM +0800, Ian Kent wrote:
> Refactor xfs_parseags(), move the entire token case block to a
> separate function in an attempt to highlight the code that
> actually changes in converting to use the new mount api.
> 
> The only changes are what's needed to communicate the variables
> dsunit, dswidth and iosizelog back to xfs_parseags().
> 
> Signed-off-by: Ian Kent <raven@themaw.net>
> ---

No changes from the previous version except for the lack of the bio size
options. There's probably no need to drop the r-b tag for that:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_super.c |  290 ++++++++++++++++++++++++++++------------------------
>  1 file changed, 155 insertions(+), 135 deletions(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 6a16750b1314..b04aebab69ab 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -205,6 +205,156 @@ match_kstrtoint(const substring_t *s, unsigned int base, int *res)
>  	return ret;
>  }
>  
> +STATIC int
> +xfs_parse_param(
> +	int			token,
> +	char			*p,
> +	substring_t		*args,
> +	struct xfs_mount	*mp,
> +	int			*dsunit,
> +	int			*dswidth,
> +	uint8_t			*iosizelog)
> +{
> +	int			iosize = 0;
> +
> +	switch (token) {
> +	case Opt_logbufs:
> +		if (match_int(args, &mp->m_logbufs))
> +			return -EINVAL;
> +		break;
> +	case Opt_logbsize:
> +		if (match_kstrtoint(args, 10, &mp->m_logbsize))
> +			return -EINVAL;
> +		break;
> +	case Opt_logdev:
> +		kfree(mp->m_logname);
> +		mp->m_logname = match_strdup(args);
> +		if (!mp->m_logname)
> +			return -ENOMEM;
> +		break;
> +	case Opt_rtdev:
> +		kfree(mp->m_rtname);
> +		mp->m_rtname = match_strdup(args);
> +		if (!mp->m_rtname)
> +			return -ENOMEM;
> +		break;
> +	case Opt_allocsize:
> +		if (match_kstrtoint(args, 10, &iosize))
> +			return -EINVAL;
> +		*iosizelog = ffs(iosize) - 1;
> +		break;
> +	case Opt_grpid:
> +	case Opt_bsdgroups:
> +		mp->m_flags |= XFS_MOUNT_GRPID;
> +		break;
> +	case Opt_nogrpid:
> +	case Opt_sysvgroups:
> +		mp->m_flags &= ~XFS_MOUNT_GRPID;
> +		break;
> +	case Opt_wsync:
> +		mp->m_flags |= XFS_MOUNT_WSYNC;
> +		break;
> +	case Opt_norecovery:
> +		mp->m_flags |= XFS_MOUNT_NORECOVERY;
> +		break;
> +	case Opt_noalign:
> +		mp->m_flags |= XFS_MOUNT_NOALIGN;
> +		break;
> +	case Opt_swalloc:
> +		mp->m_flags |= XFS_MOUNT_SWALLOC;
> +		break;
> +	case Opt_sunit:
> +		if (match_int(args, dsunit))
> +			return -EINVAL;
> +		break;
> +	case Opt_swidth:
> +		if (match_int(args, dswidth))
> +			return -EINVAL;
> +		break;
> +	case Opt_inode32:
> +		mp->m_flags |= XFS_MOUNT_SMALL_INUMS;
> +		break;
> +	case Opt_inode64:
> +		mp->m_flags &= ~XFS_MOUNT_SMALL_INUMS;
> +		break;
> +	case Opt_nouuid:
> +		mp->m_flags |= XFS_MOUNT_NOUUID;
> +		break;
> +	case Opt_ikeep:
> +		mp->m_flags |= XFS_MOUNT_IKEEP;
> +		break;
> +	case Opt_noikeep:
> +		mp->m_flags &= ~XFS_MOUNT_IKEEP;
> +		break;
> +	case Opt_largeio:
> +		mp->m_flags &= ~XFS_MOUNT_COMPAT_IOSIZE;
> +		break;
> +	case Opt_nolargeio:
> +		mp->m_flags |= XFS_MOUNT_COMPAT_IOSIZE;
> +		break;
> +	case Opt_attr2:
> +		mp->m_flags |= XFS_MOUNT_ATTR2;
> +		break;
> +	case Opt_noattr2:
> +		mp->m_flags &= ~XFS_MOUNT_ATTR2;
> +		mp->m_flags |= XFS_MOUNT_NOATTR2;
> +		break;
> +	case Opt_filestreams:
> +		mp->m_flags |= XFS_MOUNT_FILESTREAMS;
> +		break;
> +	case Opt_noquota:
> +		mp->m_qflags &= ~XFS_ALL_QUOTA_ACCT;
> +		mp->m_qflags &= ~XFS_ALL_QUOTA_ENFD;
> +		mp->m_qflags &= ~XFS_ALL_QUOTA_ACTIVE;
> +		break;
> +	case Opt_quota:
> +	case Opt_uquota:
> +	case Opt_usrquota:
> +		mp->m_qflags |= (XFS_UQUOTA_ACCT | XFS_UQUOTA_ACTIVE |
> +				 XFS_UQUOTA_ENFD);
> +		break;
> +	case Opt_qnoenforce:
> +	case Opt_uqnoenforce:
> +		mp->m_qflags |= (XFS_UQUOTA_ACCT | XFS_UQUOTA_ACTIVE);
> +		mp->m_qflags &= ~XFS_UQUOTA_ENFD;
> +		break;
> +	case Opt_pquota:
> +	case Opt_prjquota:
> +		mp->m_qflags |= (XFS_PQUOTA_ACCT | XFS_PQUOTA_ACTIVE |
> +				 XFS_PQUOTA_ENFD);
> +		break;
> +	case Opt_pqnoenforce:
> +		mp->m_qflags |= (XFS_PQUOTA_ACCT | XFS_PQUOTA_ACTIVE);
> +		mp->m_qflags &= ~XFS_PQUOTA_ENFD;
> +		break;
> +	case Opt_gquota:
> +	case Opt_grpquota:
> +		mp->m_qflags |= (XFS_GQUOTA_ACCT | XFS_GQUOTA_ACTIVE |
> +				 XFS_GQUOTA_ENFD);
> +		break;
> +	case Opt_gqnoenforce:
> +		mp->m_qflags |= (XFS_GQUOTA_ACCT | XFS_GQUOTA_ACTIVE);
> +		mp->m_qflags &= ~XFS_GQUOTA_ENFD;
> +		break;
> +	case Opt_discard:
> +		mp->m_flags |= XFS_MOUNT_DISCARD;
> +		break;
> +	case Opt_nodiscard:
> +		mp->m_flags &= ~XFS_MOUNT_DISCARD;
> +		break;
> +#ifdef CONFIG_FS_DAX
> +	case Opt_dax:
> +		mp->m_flags |= XFS_MOUNT_DAX;
> +		break;
> +#endif
> +	default:
> +		xfs_warn(mp, "unknown mount option [%s].", p);
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
>  /*
>   * This function fills in xfs_mount_t fields based on mount args.
>   * Note: the superblock has _not_ yet been read in.
> @@ -226,7 +376,6 @@ xfs_parseargs(
>  	substring_t		args[MAX_OPT_ARGS];
>  	int			dsunit = 0;
>  	int			dswidth = 0;
> -	int			iosize = 0;
>  	uint8_t			iosizelog = 0;
>  
>  	/*
> @@ -265,145 +414,16 @@ xfs_parseargs(
>  
>  	while ((p = strsep(&options, ",")) != NULL) {
>  		int		token;
> +		int		ret;
>  
>  		if (!*p)
>  			continue;
>  
>  		token = match_token(p, tokens, args);
> -		switch (token) {
> -		case Opt_logbufs:
> -			if (match_int(args, &mp->m_logbufs))
> -				return -EINVAL;
> -			break;
> -		case Opt_logbsize:
> -			if (match_kstrtoint(args, 10, &mp->m_logbsize))
> -				return -EINVAL;
> -			break;
> -		case Opt_logdev:
> -			kfree(mp->m_logname);
> -			mp->m_logname = match_strdup(args);
> -			if (!mp->m_logname)
> -				return -ENOMEM;
> -			break;
> -		case Opt_rtdev:
> -			kfree(mp->m_rtname);
> -			mp->m_rtname = match_strdup(args);
> -			if (!mp->m_rtname)
> -				return -ENOMEM;
> -			break;
> -		case Opt_allocsize:
> -			if (match_kstrtoint(args, 10, &iosize))
> -				return -EINVAL;
> -			iosizelog = ffs(iosize) - 1;
> -			break;
> -		case Opt_grpid:
> -		case Opt_bsdgroups:
> -			mp->m_flags |= XFS_MOUNT_GRPID;
> -			break;
> -		case Opt_nogrpid:
> -		case Opt_sysvgroups:
> -			mp->m_flags &= ~XFS_MOUNT_GRPID;
> -			break;
> -		case Opt_wsync:
> -			mp->m_flags |= XFS_MOUNT_WSYNC;
> -			break;
> -		case Opt_norecovery:
> -			mp->m_flags |= XFS_MOUNT_NORECOVERY;
> -			break;
> -		case Opt_noalign:
> -			mp->m_flags |= XFS_MOUNT_NOALIGN;
> -			break;
> -		case Opt_swalloc:
> -			mp->m_flags |= XFS_MOUNT_SWALLOC;
> -			break;
> -		case Opt_sunit:
> -			if (match_int(args, &dsunit))
> -				return -EINVAL;
> -			break;
> -		case Opt_swidth:
> -			if (match_int(args, &dswidth))
> -				return -EINVAL;
> -			break;
> -		case Opt_inode32:
> -			mp->m_flags |= XFS_MOUNT_SMALL_INUMS;
> -			break;
> -		case Opt_inode64:
> -			mp->m_flags &= ~XFS_MOUNT_SMALL_INUMS;
> -			break;
> -		case Opt_nouuid:
> -			mp->m_flags |= XFS_MOUNT_NOUUID;
> -			break;
> -		case Opt_ikeep:
> -			mp->m_flags |= XFS_MOUNT_IKEEP;
> -			break;
> -		case Opt_noikeep:
> -			mp->m_flags &= ~XFS_MOUNT_IKEEP;
> -			break;
> -		case Opt_largeio:
> -			mp->m_flags &= ~XFS_MOUNT_COMPAT_IOSIZE;
> -			break;
> -		case Opt_nolargeio:
> -			mp->m_flags |= XFS_MOUNT_COMPAT_IOSIZE;
> -			break;
> -		case Opt_attr2:
> -			mp->m_flags |= XFS_MOUNT_ATTR2;
> -			break;
> -		case Opt_noattr2:
> -			mp->m_flags &= ~XFS_MOUNT_ATTR2;
> -			mp->m_flags |= XFS_MOUNT_NOATTR2;
> -			break;
> -		case Opt_filestreams:
> -			mp->m_flags |= XFS_MOUNT_FILESTREAMS;
> -			break;
> -		case Opt_noquota:
> -			mp->m_qflags &= ~XFS_ALL_QUOTA_ACCT;
> -			mp->m_qflags &= ~XFS_ALL_QUOTA_ENFD;
> -			mp->m_qflags &= ~XFS_ALL_QUOTA_ACTIVE;
> -			break;
> -		case Opt_quota:
> -		case Opt_uquota:
> -		case Opt_usrquota:
> -			mp->m_qflags |= (XFS_UQUOTA_ACCT | XFS_UQUOTA_ACTIVE |
> -					 XFS_UQUOTA_ENFD);
> -			break;
> -		case Opt_qnoenforce:
> -		case Opt_uqnoenforce:
> -			mp->m_qflags |= (XFS_UQUOTA_ACCT | XFS_UQUOTA_ACTIVE);
> -			mp->m_qflags &= ~XFS_UQUOTA_ENFD;
> -			break;
> -		case Opt_pquota:
> -		case Opt_prjquota:
> -			mp->m_qflags |= (XFS_PQUOTA_ACCT | XFS_PQUOTA_ACTIVE |
> -					 XFS_PQUOTA_ENFD);
> -			break;
> -		case Opt_pqnoenforce:
> -			mp->m_qflags |= (XFS_PQUOTA_ACCT | XFS_PQUOTA_ACTIVE);
> -			mp->m_qflags &= ~XFS_PQUOTA_ENFD;
> -			break;
> -		case Opt_gquota:
> -		case Opt_grpquota:
> -			mp->m_qflags |= (XFS_GQUOTA_ACCT | XFS_GQUOTA_ACTIVE |
> -					 XFS_GQUOTA_ENFD);
> -			break;
> -		case Opt_gqnoenforce:
> -			mp->m_qflags |= (XFS_GQUOTA_ACCT | XFS_GQUOTA_ACTIVE);
> -			mp->m_qflags &= ~XFS_GQUOTA_ENFD;
> -			break;
> -		case Opt_discard:
> -			mp->m_flags |= XFS_MOUNT_DISCARD;
> -			break;
> -		case Opt_nodiscard:
> -			mp->m_flags &= ~XFS_MOUNT_DISCARD;
> -			break;
> -#ifdef CONFIG_FS_DAX
> -		case Opt_dax:
> -			mp->m_flags |= XFS_MOUNT_DAX;
> -			break;
> -#endif
> -		default:
> -			xfs_warn(mp, "unknown mount option [%s].", p);
> -			return -EINVAL;
> -		}
> +		ret = xfs_parse_param(token, p, args, mp,
> +				      &dsunit, &dswidth, &iosizelog);
> +		if (ret)
> +			return ret;
>  	}
>  
>  	/*
> 
