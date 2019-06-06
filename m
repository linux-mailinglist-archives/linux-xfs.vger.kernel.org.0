Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7001937F7E
	for <lists+linux-xfs@lfdr.de>; Thu,  6 Jun 2019 23:23:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728350AbfFFVXx (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 6 Jun 2019 17:23:53 -0400
Received: from sandeen.net ([63.231.237.45]:57174 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727024AbfFFVXx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 6 Jun 2019 17:23:53 -0400
Received: from Liberator-6.local (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 5EF9F2ADF;
        Thu,  6 Jun 2019 16:23:28 -0500 (CDT)
Subject: Re: [PATCH v2] xfs_restore: detect rtinherit on destination
To:     Sheena Artrip <sheenobu@fb.com>
Cc:     sheena.artrip@gmail.com, linux-xfs@vger.kernel.org
References: <e6968aa2-a5ad-4964-2966-589486e4a251@sandeen.net>
 <20190606195724.2975689-1-sheenobu@fb.com>
From:   Eric Sandeen <sandeen@sandeen.net>
Openpgp: preference=signencrypt
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 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 pA==
Message-ID: <f89a09b5-8a91-51e0-d869-039dbe9a7349@sandeen.net>
Date:   Thu, 6 Jun 2019 16:23:51 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190606195724.2975689-1-sheenobu@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 6/6/19 2:57 PM, Sheena Artrip wrote:
> When running xfs_restore with a non-rtdev dump,
> it will ignore any rtinherit flags on the destination
> and send I/O to the metadata region.
> 
> Instead, detect rtinherit on the destination XFS fileystem root inode
> and use that to override the incoming inode flags.
> 
> Original version of this patch missed some branches so multiple
> invocations of xfsrestore onto the same fs caused
> the rtinherit bit to get re-removed. There could be some
> additional edge cases in non-realtime to realtime workflows so
> the outstanding question would be: is it worth supporting?
> 
> Changes in v2:
> * Changed root inode bulkstat to just ioctl to the destdir inode

Thanks for that fixup (though comment still says "root" FWIW)

Thinking about this some more, I'm really kind of wondering how this
should all be expected to work.  There are several scenarios here,
and "is this file rt?" is prescribed in different ways - either in
the dump itself, or on the target fs via inheritance flags...

(NB: rt is not the only inheritable flag, so would we need to handle
the others?)

non-rt fs dump, restored onto non-rt fs
	- obviously this is fine

rt fs dump, restored onto rt fs
	- obviously this is fine as well

rt fs dump, restored onto non-rt fs
	- this works, with errors - all rt files become non-rt
	- nothing else to do here other than fail outright

non-rt fs dump, restored into rt fs dir/fs with "rtinherit" set
	- this one is your case
	- today it's ignored, files stay non-rt
	- you're suggesting it be honored and files turned into rt

the one case that's not handled here is "what if I want to have my
realtime dump with realtime files restored onto an rt-capable fs, but
turned into regular files?" 

So your patch gives us one mechanism (restore non-rt files as
rt files) but not the converse (restore rt files as non-rt files) -
I'm not sure if that matters, but the symmetry bugs me a little.

I'm trying to decide if dump/restore is truly the right way to
migrate files from non-rt to rt or vice versa, TBH.  Maybe dchinner
or djwong will have thoughts as well...

I'll worry more about the details of the patch after we decide if this
is the right behavior in the first place...

-Eric

> Signed-off-by: Sheena Artrip <sheenobu@fb.com>
> ---
>  restore/content.c | 51 +++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 51 insertions(+)
> 
> diff --git a/restore/content.c b/restore/content.c
> index 6b22965..4822d1c 100644
> --- a/restore/content.c
> +++ b/restore/content.c
> @@ -670,6 +670,9 @@ struct tran {
>  		/* to establish critical regions while updating pers
>  		 * inventory
>  		 */
> +	bool_t t_dstisrealtime;
> +		/* to force the realtime flag on incoming inodes
> +		 */
>  };
>  
>  typedef struct tran tran_t;
> @@ -1803,6 +1806,37 @@ content_init(int argc, char *argv[], size64_t vmsz)
>  		free_handle(fshanp, fshlen);
>  	}
>  
> +	/* determine if destination root inode has rtinherit.
> +	 * If so, we should force XFS_REALTIME on the incoming inodes.
> +	 */
> +	if (persp->a.dstdirisxfspr) {
> +		struct fsxattr dstxattr;
> +
> +		int dstfd = open(persp->a.dstdir, O_RDONLY);
> +		if (dstfd < 0) {
> +			mlog(MLOG_NORMAL | MLOG_WARNING,
> +					_("open of %s failed: %s\n"),
> +					persp->a.dstdir,
> +					strerror(errno));
> +			return BOOL_FALSE;
> +		}
> +
> +		/* Get the xattr details for the destination folder */
> +		if (ioctl(dstfd, XFS_IOC_FSGETXATTR, &dstxattr) < 0) {
> +			(void)close(dstfd);
> +			mlog(MLOG_ERROR,
> +			      _("failed to get xattr information for dst inode\n"));
> +			return BOOL_FALSE;
> +		}
> +
> +		(void)close(dstfd);
> +
> +		/* test against rtinherit */
> +		if((dstxattr.fsx_xflags & XFS_XFLAG_RTINHERIT) != 0) {
> +			tranp->t_dstisrealtime = true;
> +		}
> +	}
> +
>  	/* map in pers. inv. descriptors, if any. NOTE: this ptr is to be
>  	 * referenced ONLY via the macros provided; the descriptors will be
>  	 * occasionally remapped, causing the ptr to change.
> @@ -7270,6 +7304,10 @@ restore_file_cb(void *cp, bool_t linkpr, char *path1, char *path2)
>  	bool_t ahcs = contextp->cb_ahcs;
>  	stream_context_t *strctxp = (stream_context_t *)drivep->d_strmcontextp;
>  
> +	if (tranp->t_dstisrealtime) {
> +		bstatp->bs_xflags |= XFS_XFLAG_REALTIME;
> +	}
> +
>  	int rval;
>  	bool_t ok;
>  
> @@ -7480,6 +7518,10 @@ restore_reg(drive_t *drivep,
>  	if (tranp->t_toconlypr)
>  		return BOOL_TRUE;
>  
> +	if (tranp->t_dstisrealtime) {
> +	      bstatp->bs_xflags |= XFS_XFLAG_REALTIME;
> +	}
> +
>  	oflags = O_CREAT | O_RDWR;
>  	if (persp->a.dstdirisxfspr && bstatp->bs_xflags & XFS_XFLAG_REALTIME)
>  		oflags |= O_DIRECT;
> @@ -8470,6 +8512,11 @@ restore_extent(filehdr_t *fhdrp,
>  		}
>  		assert(new_off == off);
>  	}
> +
> +	if (tranp->t_dstisrealtime) {
> +	      bstatp->bs_xflags |= XFS_XFLAG_REALTIME;
> +	}
> +
>  	if ((fd != -1) && (bstatp->bs_xflags & XFS_XFLAG_REALTIME)) {
>  		if ((ioctl(fd, XFS_IOC_DIOINFO, &da) < 0)) {
>  			mlog(MLOG_NORMAL | MLOG_WARNING, _(
> @@ -8729,6 +8776,10 @@ restore_extattr(drive_t *drivep,
>  
>  	assert(extattrbufp);
>  
> +	if (tranp->t_dstisrealtime) {
> +		bstatp->bs_xflags |= XFS_XFLAG_REALTIME;
> +	}
> +
>  	if (!isdirpr)
>  		isfilerestored = partial_check(bstatp->bs_ino,  bstatp->bs_size);
>  
> 
