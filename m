Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77C6B519E6
	for <lists+linux-xfs@lfdr.de>; Mon, 24 Jun 2019 19:44:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727436AbfFXRov (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 24 Jun 2019 13:44:51 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:52390 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727236AbfFXRov (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jun 2019 13:44:51 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5OHiCqB195940;
        Mon, 24 Jun 2019 17:44:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=p9gnaqYqman0NcHoYA/r1qA51KBy4VdV76Oi2VUxnwo=;
 b=L8WqQnhwRGLwizyrmv0f0ulrwnjK1/MTGOu2XSY7hf8iHoyW8+vYfcvQejGzBDZ/keaT
 YpohA9P8jD+yNYy4qdzeULAc8cQwqmQtC0v1sNijueQk2C8dwrHgICK6c5wbhCfh/SzO
 YqeqYaHfGLMFX0MYnxhF96pg2exB6EviZeEW4joQbBuey2DLOM1KW+3rsx+SaMqKUrm0
 xR3u3YjDlmZLy/Fj4kWwf++Rowksuci8lvvcYSRd6g2gdz1c2NLl40cG+vbSaRsvqsJr
 QUvAORr7j9iroBh1T2EMXFEdZCjMq2uZ1rE0hl65nXs1KqvwnWwaGwHjXe768eNdFIW3 gg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2t9cyq7qwc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Jun 2019 17:44:32 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5OHgg1r077335;
        Mon, 24 Jun 2019 17:44:31 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2t9p6tqasx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Jun 2019 17:44:31 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5OHiUIq027437;
        Mon, 24 Jun 2019 17:44:30 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 24 Jun 2019 10:44:30 -0700
Date:   Mon, 24 Jun 2019 10:44:29 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Ian Kent <raven@themaw.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 05/10] xfs: mount-api - add xfs_get_tree()
Message-ID: <20190624174429.GW5387@magnolia>
References: <156134510205.2519.16185588460828778620.stgit@fedora-28>
 <156134513061.2519.15444193018279732348.stgit@fedora-28>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156134513061.2519.15444193018279732348.stgit@fedora-28>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9298 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906240141
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9298 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906240141
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 24, 2019 at 10:58:50AM +0800, Ian Kent wrote:
> Add the fs_context_operations method .get_tree that validates
> mount options and fills the super block as previously done
> by the file_system_type .mount method.
> 
> Signed-off-by: Ian Kent <raven@themaw.net>
> ---
>  fs/xfs/xfs_super.c |  139 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 139 insertions(+)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index cf8efb465969..0ec0142b94e1 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1629,6 +1629,98 @@ xfs_fs_remount(
>  	return 0;
>  }
>  
> +STATIC int
> +xfs_validate_params(
> +	struct xfs_mount *mp,
> +	struct xfs_fs_context *ctx,
> +	enum fs_context_purpose purpose)

Tabs here, please:

	struct xfs_mount	*mp,
	struct xfs_fs_context	*ctx,
	enum fs_context_purpose	purpose)

> +{
> +	/*
> +	 * no recovery flag requires a read-only mount
> +	 */
> +	if ((mp->m_flags & XFS_MOUNT_NORECOVERY) &&
> +	    !(mp->m_flags & XFS_MOUNT_RDONLY)) {
> +		xfs_warn(mp, "no-recovery mounts must be read-only.");
> +		return -EINVAL;
> +	}
> +
> +	if ((mp->m_flags & XFS_MOUNT_NOALIGN) &&
> +	    (ctx->dsunit || ctx->dswidth)) {
> +		xfs_warn(mp,
> +	"sunit and swidth options incompatible with the noalign option");
> +		return -EINVAL;
> +	}
> +
> +#ifndef CONFIG_XFS_QUOTA
> +	if (XFS_IS_QUOTA_RUNNING(mp)) {
> +		xfs_warn(mp, "quota support not available in this kernel.");
> +		return -EINVAL;
> +	}
> +#endif
> +
> +	if ((ctx->dsunit && !ctx->dswidth) || (!ctx->dsunit && ctx->dswidth)) {
> +		xfs_warn(mp, "sunit and swidth must be specified together");
> +		return -EINVAL;
> +	}
> +
> +	if (ctx->dsunit && (ctx->dswidth % ctx->dsunit != 0)) {
> +		xfs_warn(mp,
> +	"stripe width (%d) must be a multiple of the stripe unit (%d)",
> +			ctx->dswidth, ctx->dsunit);
> +		return -EINVAL;
> +	}
> +
> +	if (ctx->dsunit && !(mp->m_flags & XFS_MOUNT_NOALIGN)) {
> +		/*
> +		 * At this point the superblock has not been read
> +		 * in, therefore we do not know the block size.
> +		 * Before the mount call ends we will convert
> +		 * these to FSBs.
> +		 */
> +		if (purpose == FS_CONTEXT_FOR_MOUNT) {
> +			mp->m_dalign = ctx->dsunit;
> +			mp->m_swidth = ctx->dswidth;
> +		}
> +	}
> +
> +	if (mp->m_logbufs != -1 &&
> +	    mp->m_logbufs != 0 &&
> +	    (mp->m_logbufs < XLOG_MIN_ICLOGS ||
> +	     mp->m_logbufs > XLOG_MAX_ICLOGS)) {
> +		xfs_warn(mp, "invalid logbufs value: %d [not %d-%d]",
> +			mp->m_logbufs, XLOG_MIN_ICLOGS, XLOG_MAX_ICLOGS);
> +		return -EINVAL;
> +	}
> +	if (mp->m_logbsize != -1 &&
> +	    mp->m_logbsize !=  0 &&
> +	    (mp->m_logbsize < XLOG_MIN_RECORD_BSIZE ||
> +	     mp->m_logbsize > XLOG_MAX_RECORD_BSIZE ||
> +	     !is_power_of_2(mp->m_logbsize))) {
> +		xfs_warn(mp,
> +			"invalid logbufsize: %d [not 16k,32k,64k,128k or 256k]",
> +			mp->m_logbsize);
> +		return -EINVAL;
> +	}
> +
> +	if (ctx->iosizelog) {
> +		if (ctx->iosizelog > XFS_MAX_IO_LOG ||
> +		    ctx->iosizelog < XFS_MIN_IO_LOG) {
> +			xfs_warn(mp, "invalid log iosize: %d [not %d-%d]",
> +				ctx->iosizelog, XFS_MIN_IO_LOG,
> +				XFS_MAX_IO_LOG);
> +			return -EINVAL;
> +		}
> +
> +		if (purpose == FS_CONTEXT_FOR_MOUNT) {
> +			mp->m_flags |= XFS_MOUNT_DFLT_IOSIZE;
> +			mp->m_readio_log = ctx->iosizelog;
> +			mp->m_writeio_log = ctx->iosizelog;
> +		}
> +	}

Ugggh, I don't wanna have to compare the old xfs_parseargs code with
this new xfs_validate_params code to make sure nothing got screwed up.
:)

Can this code be broken out of the existing parseargs (instead of added
further down in the file) to minimize the diff?  You're getting rid of
the old option processing code at the end of the series anyway so I
don't mind creating temporary struct xfs_fs_context structures in
xfs_parseargs if that makes it much more obvious that the validation
code itself isn't changing.

--D

> +
> +	return 0;
> +}
> +
>  /*
>   * Second stage of a freeze. The data is already frozen so we only
>   * need to take care of the metadata. Once that's done sync the superblock
> @@ -2035,6 +2127,52 @@ xfs_fs_fill_super(
>  	return error;
>  }
>  
> +STATIC int
> +xfs_fill_super(
> +	struct super_block	*sb,
> +	struct fs_context	*fc)
> +{
> +	struct xfs_fs_context	*ctx = fc->fs_private;
> +	struct xfs_mount	*mp = sb->s_fs_info;
> +	int			silent = fc->sb_flags & SB_SILENT;
> +	int			error = -ENOMEM;
> +
> +	mp->m_super = sb;
> +
> +	/*
> +	 * set up the mount name first so all the errors will refer to the
> +	 * correct device.
> +	 */
> +	mp->m_fsname = kstrndup(sb->s_id, MAXNAMELEN, GFP_KERNEL);
> +	if (!mp->m_fsname)
> +		return -ENOMEM;
> +	mp->m_fsname_len = strlen(mp->m_fsname) + 1;
> +
> +	error = xfs_validate_params(mp, ctx, fc->purpose);
> +	if (error)
> +		goto out_free_fsname;
> +
> +	error = __xfs_fs_fill_super(mp, silent);
> +	if (error)
> +		goto out_free_fsname;
> +
> +	return 0;
> +
> + out_free_fsname:
> +	sb->s_fs_info = NULL;
> +	xfs_free_fsname(mp);
> +	kfree(mp);
> +
> +	return error;
> +}
> +
> +STATIC int
> +xfs_get_tree(
> +	struct fs_context	*fc)
> +{
> +	return vfs_get_block_super(fc, xfs_fill_super);
> +}
> +
>  STATIC void
>  xfs_fs_put_super(
>  	struct super_block	*sb)
> @@ -2107,6 +2245,7 @@ static const struct super_operations xfs_super_operations = {
>  
>  static const struct fs_context_operations xfs_context_ops = {
>  	.parse_param = xfs_parse_param,
> +	.get_tree    = xfs_get_tree,
>  };
>  
>  static struct file_system_type xfs_fs_type = {
> 
