Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E639BBC5F8
	for <lists+linux-xfs@lfdr.de>; Tue, 24 Sep 2019 12:56:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393203AbfIXK4S (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 24 Sep 2019 06:56:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40408 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388652AbfIXK4R (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 24 Sep 2019 06:56:17 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 24E4C30821A3;
        Tue, 24 Sep 2019 10:56:17 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 71B9A5C1B2;
        Tue, 24 Sep 2019 10:56:16 +0000 (UTC)
Date:   Tue, 24 Sep 2019 06:56:14 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Ian Kent <raven@themaw.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH v3 07/16] xfs: mount-api - move xfs_parseargs()
 validation to a helper
Message-ID: <20190924105614.GI13820@bfoster>
References: <156897321789.20210.339237101446767141.stgit@fedora-28>
 <156897336977.20210.76910391411183299.stgit@fedora-28>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <156897336977.20210.76910391411183299.stgit@fedora-28>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Tue, 24 Sep 2019 10:56:17 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Sep 20, 2019 at 05:56:09PM +0800, Ian Kent wrote:
> Move the validation code of xfs_parseargs() into a helper for later
> use within the mount context methods.
> 
> Signed-off-by: Ian Kent <raven@themaw.net>
> ---

More compile issues:

$ make -j 8 M=fs/xfs
  CC [M]  fs/xfs/xfs_super.o
...
fs/xfs/xfs_super.c:543:7: note: each undeclared identifier is reported only once for each function it appears in
fs/xfs/xfs_super.c:569:2: error: ‘ret’ undeclared (first use in this function); did you mean ‘net’?
  ret = xfs_validate_params(mp, &context, false);
  ^~~
  net
fs/xfs/xfs_super.c:572:1: warning: control reaches end of non-void function [-Wreturn-type]
 }
 ^
make[1]: *** [scripts/Makefile.build:280: fs/xfs/xfs_super.o] Error 1
make: *** [Makefile:1624: _module_fs/xfs] Error 2

I'll probably stop here for now since clearly this and the previous
patch need some tweaks and I'd rather not review around compile errors.

Brian

>  fs/xfs/xfs_super.c |  148 +++++++++++++++++++++++++++++++++-------------------
>  1 file changed, 94 insertions(+), 54 deletions(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 041ab8b52a7d..5cb9a9fd1a15 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -356,6 +356,97 @@ xfs_parse_param(
>  	return 0;
>  }
>  
> +STATIC int
> +xfs_validate_params(
> +	struct xfs_mount        *mp,
> +	struct xfs_fs_context   *ctx,
> +	bool			nooptions)
> +{
> +	if (nooptions)
> +		goto noopts;
> +
> +	/*
> +	 * no recovery flag requires a read-only mount
> +	 */
> +	if ((mp->m_flags & XFS_MOUNT_NORECOVERY) &&
> +	    !(mp->m_flags & XFS_MOUNT_RDONLY)) {
> +		xfs_warn(mp, "no-recovery mounts must be read-only.");
> +		return -EINVAL;
> +	}
> +
> +	if ((mp->m_flags & XFS_MOUNT_NOALIGN) && (ctx->dsunit || ctx->dswidth)) {
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
> +noopts:
> +	if (ctx->dsunit && !(mp->m_flags & XFS_MOUNT_NOALIGN)) {
> +		/*
> +		 * At this point the superblock has not been read
> +		 * in, therefore we do not know the block size.
> +		 * Before the mount call ends we will convert
> +		 * these to FSBs.
> +		 */
> +		mp->m_dalign = ctx->dsunit;
> +		mp->m_swidth = ctx->dswidth;
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
> +		mp->m_flags |= XFS_MOUNT_DFLT_IOSIZE;
> +		mp->m_readio_log = ctx->iosizelog;
> +		mp->m_writeio_log = ctx->iosizelog;
> +	}
> +
> +	return 0;
> +}
> +
>  /*
>   * This function fills in xfs_mount_t fields based on mount args.
>   * Note: the superblock has _not_ yet been read in.
> @@ -445,16 +536,7 @@ xfs_parseargs(
>  		ret = xfs_parse_param(&fc, &param);
>  		kfree(param.string);
>  		if (ret < 0)
> -			return ret;
> -	}
> -
> -	/*
> -	 * no recovery flag requires a read-only mount
> -	 */
> -	if ((mp->m_flags & XFS_MOUNT_NORECOVERY) &&
> -	    !(mp->m_flags & XFS_MOUNT_RDONLY)) {
> -		xfs_warn(mp, "no-recovery mounts must be read-only.");
> -		return -EINVAL;
> +			goto done;
>  	}
>  
>  	if ((mp->m_flags & XFS_MOUNT_NOALIGN) &&
> @@ -484,51 +566,9 @@ xfs_parseargs(
>  	}
>  
>  done:
> -	if (ctx->dsunit && !(mp->m_flags & XFS_MOUNT_NOALIGN)) {
> -		/*
> -		 * At this point the superblock has not been read
> -		 * in, therefore we do not know the block size.
> -		 * Before the mount call ends we will convert
> -		 * these to FSBs.
> -		 */
> -		mp->m_dalign = ctx->dsunit;
> -		mp->m_swidth = ctx->dswidth;
> -	}
> -
> -	if (mp->m_logbufs != -1 &&
> -	    mp->m_logbufs != 0 &&
> -	    (mp->m_logbufs < XLOG_MIN_ICLOGS ||
> -	     mp->m_logbufs > XLOG_MAX_ICLOGS)) {
> -		xfs_warn(mp, "invalid logbufs value: %d [not %d-%d]",
> -			mp->m_logbufs, XLOG_MIN_ICLOGS, XLOG_MAX_ICLOGS);
> -		return -EINVAL;
> -	}
> -	if (mp->m_logbsize != -1 &&
> -	    mp->m_logbsize !=  0 &&
> -	    (mp->m_logbsize < XLOG_MIN_RECORD_BSIZE ||
> -	     mp->m_logbsize > XLOG_MAX_RECORD_BSIZE ||
> -	     !is_power_of_2(mp->m_logbsize))) {
> -		xfs_warn(mp,
> -			"invalid logbufsize: %d [not 16k,32k,64k,128k or 256k]",
> -			mp->m_logbsize);
> -		return -EINVAL;
> -	}
> +	ret = xfs_validate_params(mp, &context, false);
>  
> -	if (ctx->iosizelog) {
> -		if (ctx->iosizelog > XFS_MAX_IO_LOG ||
> -		    ctx->iosizelog < XFS_MIN_IO_LOG) {
> -			xfs_warn(mp, "invalid log iosize: %d [not %d-%d]",
> -				ctx->iosizelog, XFS_MIN_IO_LOG,
> -				XFS_MAX_IO_LOG);
> -			return -EINVAL;
> -		}
> -
> -		mp->m_flags |= XFS_MOUNT_DFLT_IOSIZE;
> -		mp->m_readio_log = ctx->iosizelog;
> -		mp->m_writeio_log = ctx->iosizelog;
> -	}
> -
> -	return 0;
> +	return ret;
>  }
>  
>  struct proc_xfs_info {
> 
