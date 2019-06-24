Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BEB351F47
	for <lists+linux-xfs@lfdr.de>; Tue, 25 Jun 2019 01:52:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728573AbfFXXw1 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 24 Jun 2019 19:52:27 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:37157 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728547AbfFXXw0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jun 2019 19:52:26 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 85C5022243;
        Mon, 24 Jun 2019 19:52:25 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 24 Jun 2019 19:52:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=
        message-id:subject:from:to:cc:date:in-reply-to:references
        :content-type:mime-version:content-transfer-encoding; s=fm3; bh=
        c6/rVlTUPB+ZX9RU0YtzzJRvPr5VdnPPRmlHiGrJr/U=; b=c40xLQyWHf25B41g
        Dd7aVxX4mlaTj0ac6YzOBLGKTXIcHroYvhmDBuvS77YhbkbwFEvl0i1HIHWu42mK
        Gm0sf+oVmgmk8G1UNcLagnNKBWlegMNAMEOh9BipCMPPO4MCT71eDwusMH9q9cWF
        ojbo+pc4XeoQL7ZT3t5tlHq3cWIA2AG8YjFIdP7hSlZs390hN2GJtDNJuC1gC21R
        Vfu434Mh33WtRJ8EEh9dNvAfu8CRTZROf9wivEBtjuE3UujVVr0hOpUkorKIzxv1
        835y9avJCXYNe//Qd9krR2svTWTy1Cb7q7rtrFJcamGJpV6D4BShzZF9vHfnrnUw
        pk8yIw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=c6/rVlTUPB+ZX9RU0YtzzJRvPr5VdnPPRmlHiGrJr
        /U=; b=Lf+2DJuO2i33lSQFHqFL5FNH1fVQTA2ycCom+KbYUfDaM3p1cbK1cok0g
        wtdTE4+AU9Q4zMAd9LRoDJsO/TZbK8pyL3YPJ9tJltuSpaLP5HETz4sxi4Ti2Xhy
        AY8q9wduHzHX488qvWflSnr2X/eg5L34O5v5Mj0L7v9eNq0xbnPlxIEMtzagFVn8
        8YgyNPpxVpyfOOtt7wKTI6uEelHb4OwZSErnSZJ4l4wUlQ+oTQRuAXPXjWHm63rM
        r/W2FnA7qA26Io4k17IoyQiMQpuKBGx8yUSk+GQp9bOwcZ4ZFld52zYw5Nza9L+6
        xo6fCsHaadBEzaeMzrpTgojrHmjpQ==
X-ME-Sender: <xms:OGIRXf4i73ct7NVqZJiEnQyktB6fS86qlbw8dLfVpMq5vc4Af7s_3Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudefgdeftdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefkuffhvfffjghftggfggfgsehtjeertddtreejnecuhfhrohhmpefkrghnucfm
    vghnthcuoehrrghvvghnsehthhgvmhgrfidrnhgvtheqnecukfhppeduudekrddvtdekrd
    dujeefrdehfeenucfrrghrrghmpehmrghilhhfrhhomheprhgrvhgvnhesthhhvghmrgif
    rdhnvghtnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:OGIRXWKOPxxGeEZCjUKCWX07Jc33BQil9ZS41OMvJ5oEKeXXz8rHyA>
    <xmx:OGIRXTgJZvpBnWZrazGeA5qc6y--CYJPvyUhVRPsPZR_rfwuJLugXA>
    <xmx:OGIRXTI_fixjp7r5rfkNotjTzriachc6rgomXtUPJeQWD4NxBfKNaQ>
    <xmx:OWIRXeRJ7sL9_VLgMIyo7dZc3uNOxDLxRaY4bL6p-C4W3LK6usfalg>
Received: from pluto.themaw.net (unknown [118.208.173.53])
        by mail.messagingengine.com (Postfix) with ESMTPA id 547E18005A;
        Mon, 24 Jun 2019 19:52:24 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by pluto.themaw.net (Postfix) with ESMTP id 493CB1C0114;
        Tue, 25 Jun 2019 07:52:21 +0800 (AWST)
Message-ID: <c2768567de3c54cd23eba5dfe5b6421c32ba6def.camel@themaw.net>
Subject: Re: [PATCH 05/10] xfs: mount-api - add xfs_get_tree()
From:   Ian Kent <raven@themaw.net>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Date:   Tue, 25 Jun 2019 07:52:21 +0800
In-Reply-To: <20190624174429.GW5387@magnolia>
References: <156134510205.2519.16185588460828778620.stgit@fedora-28>
         <156134513061.2519.15444193018279732348.stgit@fedora-28>
         <20190624174429.GW5387@magnolia>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, 2019-06-24 at 10:44 -0700, Darrick J. Wong wrote:
> On Mon, Jun 24, 2019 at 10:58:50AM +0800, Ian Kent wrote:
> > Add the fs_context_operations method .get_tree that validates
> > mount options and fills the super block as previously done
> > by the file_system_type .mount method.
> > 
> > Signed-off-by: Ian Kent <raven@themaw.net>
> > ---
> >  fs/xfs/xfs_super.c |  139
> > ++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 139 insertions(+)
> > 
> > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > index cf8efb465969..0ec0142b94e1 100644
> > --- a/fs/xfs/xfs_super.c
> > +++ b/fs/xfs/xfs_super.c
> > @@ -1629,6 +1629,98 @@ xfs_fs_remount(
> >  	return 0;
> >  }
> >  
> > +STATIC int
> > +xfs_validate_params(
> > +	struct xfs_mount *mp,
> > +	struct xfs_fs_context *ctx,
> > +	enum fs_context_purpose purpose)
> 
> Tabs here, please:
> 
> 	struct xfs_mount	*mp,
> 	struct xfs_fs_context	*ctx,
> 	enum fs_context_purpose	purpose)

Oops, my bad, will fix.

> 
> > +{
> > +	/*
> > +	 * no recovery flag requires a read-only mount
> > +	 */
> > +	if ((mp->m_flags & XFS_MOUNT_NORECOVERY) &&
> > +	    !(mp->m_flags & XFS_MOUNT_RDONLY)) {
> > +		xfs_warn(mp, "no-recovery mounts must be read-only.");
> > +		return -EINVAL;
> > +	}
> > +
> > +	if ((mp->m_flags & XFS_MOUNT_NOALIGN) &&
> > +	    (ctx->dsunit || ctx->dswidth)) {
> > +		xfs_warn(mp,
> > +	"sunit and swidth options incompatible with the noalign option");
> > +		return -EINVAL;
> > +	}
> > +
> > +#ifndef CONFIG_XFS_QUOTA
> > +	if (XFS_IS_QUOTA_RUNNING(mp)) {
> > +		xfs_warn(mp, "quota support not available in this kernel.");
> > +		return -EINVAL;
> > +	}
> > +#endif
> > +
> > +	if ((ctx->dsunit && !ctx->dswidth) || (!ctx->dsunit && ctx->dswidth)) {
> > +		xfs_warn(mp, "sunit and swidth must be specified together");
> > +		return -EINVAL;
> > +	}
> > +
> > +	if (ctx->dsunit && (ctx->dswidth % ctx->dsunit != 0)) {
> > +		xfs_warn(mp,
> > +	"stripe width (%d) must be a multiple of the stripe unit (%d)",
> > +			ctx->dswidth, ctx->dsunit);
> > +		return -EINVAL;
> > +	}
> > +
> > +	if (ctx->dsunit && !(mp->m_flags & XFS_MOUNT_NOALIGN)) {
> > +		/*
> > +		 * At this point the superblock has not been read
> > +		 * in, therefore we do not know the block size.
> > +		 * Before the mount call ends we will convert
> > +		 * these to FSBs.
> > +		 */
> > +		if (purpose == FS_CONTEXT_FOR_MOUNT) {
> > +			mp->m_dalign = ctx->dsunit;
> > +			mp->m_swidth = ctx->dswidth;
> > +		}
> > +	}
> > +
> > +	if (mp->m_logbufs != -1 &&
> > +	    mp->m_logbufs != 0 &&
> > +	    (mp->m_logbufs < XLOG_MIN_ICLOGS ||
> > +	     mp->m_logbufs > XLOG_MAX_ICLOGS)) {
> > +		xfs_warn(mp, "invalid logbufs value: %d [not %d-%d]",
> > +			mp->m_logbufs, XLOG_MIN_ICLOGS, XLOG_MAX_ICLOGS);
> > +		return -EINVAL;
> > +	}
> > +	if (mp->m_logbsize != -1 &&
> > +	    mp->m_logbsize !=  0 &&
> > +	    (mp->m_logbsize < XLOG_MIN_RECORD_BSIZE ||
> > +	     mp->m_logbsize > XLOG_MAX_RECORD_BSIZE ||
> > +	     !is_power_of_2(mp->m_logbsize))) {
> > +		xfs_warn(mp,
> > +			"invalid logbufsize: %d [not 16k,32k,64k,128k or 256k]",
> > +			mp->m_logbsize);
> > +		return -EINVAL;
> > +	}
> > +
> > +	if (ctx->iosizelog) {
> > +		if (ctx->iosizelog > XFS_MAX_IO_LOG ||
> > +		    ctx->iosizelog < XFS_MIN_IO_LOG) {
> > +			xfs_warn(mp, "invalid log iosize: %d [not %d-%d]",
> > +				ctx->iosizelog, XFS_MIN_IO_LOG,
> > +				XFS_MAX_IO_LOG);
> > +			return -EINVAL;
> > +		}
> > +
> > +		if (purpose == FS_CONTEXT_FOR_MOUNT) {
> > +			mp->m_flags |= XFS_MOUNT_DFLT_IOSIZE;
> > +			mp->m_readio_log = ctx->iosizelog;
> > +			mp->m_writeio_log = ctx->iosizelog;
> > +		}
> > +	}
> 
> Ugggh, I don't wanna have to compare the old xfs_parseargs code with
> this new xfs_validate_params code to make sure nothing got screwed up.
> :)
> 
> Can this code be broken out of the existing parseargs (instead of added
> further down in the file) to minimize the diff?  You're getting rid of
> the old option processing code at the end of the series anyway so I
> don't mind creating temporary struct xfs_fs_context structures in
> xfs_parseargs if that makes it much more obvious that the validation
> code itself isn't changing.

Both you, Dave, and myself agree but ...

The indentation is different between the two functions resulting
in an even harder to understand patch.

I will have another go at it and see if I can come up with a
re-factoring that helps.

> 
> --D
> 
> > +
> > +	return 0;
> > +}
> > +
> >  /*
> >   * Second stage of a freeze. The data is already frozen so we only
> >   * need to take care of the metadata. Once that's done sync the superblock
> > @@ -2035,6 +2127,52 @@ xfs_fs_fill_super(
> >  	return error;
> >  }
> >  
> > +STATIC int
> > +xfs_fill_super(
> > +	struct super_block	*sb,
> > +	struct fs_context	*fc)
> > +{
> > +	struct xfs_fs_context	*ctx = fc->fs_private;
> > +	struct xfs_mount	*mp = sb->s_fs_info;
> > +	int			silent = fc->sb_flags & SB_SILENT;
> > +	int			error = -ENOMEM;
> > +
> > +	mp->m_super = sb;
> > +
> > +	/*
> > +	 * set up the mount name first so all the errors will refer to the
> > +	 * correct device.
> > +	 */
> > +	mp->m_fsname = kstrndup(sb->s_id, MAXNAMELEN, GFP_KERNEL);
> > +	if (!mp->m_fsname)
> > +		return -ENOMEM;
> > +	mp->m_fsname_len = strlen(mp->m_fsname) + 1;
> > +
> > +	error = xfs_validate_params(mp, ctx, fc->purpose);
> > +	if (error)
> > +		goto out_free_fsname;
> > +
> > +	error = __xfs_fs_fill_super(mp, silent);
> > +	if (error)
> > +		goto out_free_fsname;
> > +
> > +	return 0;
> > +
> > + out_free_fsname:
> > +	sb->s_fs_info = NULL;
> > +	xfs_free_fsname(mp);
> > +	kfree(mp);
> > +
> > +	return error;
> > +}
> > +
> > +STATIC int
> > +xfs_get_tree(
> > +	struct fs_context	*fc)
> > +{
> > +	return vfs_get_block_super(fc, xfs_fill_super);
> > +}
> > +
> >  STATIC void
> >  xfs_fs_put_super(
> >  	struct super_block	*sb)
> > @@ -2107,6 +2245,7 @@ static const struct super_operations
> > xfs_super_operations = {
> >  
> >  static const struct fs_context_operations xfs_context_ops = {
> >  	.parse_param = xfs_parse_param,
> > +	.get_tree    = xfs_get_tree,
> >  };
> >  
> >  static struct file_system_type xfs_fs_type = {
> > 

