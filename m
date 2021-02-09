Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E81E3154F2
	for <lists+linux-xfs@lfdr.de>; Tue,  9 Feb 2021 18:24:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232788AbhBIRXn (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 9 Feb 2021 12:23:43 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:49282 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233099AbhBIRWd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Feb 2021 12:22:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612891266;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VnLpjYl6kCWDmVVuoI2aeBfflO6j4qRMXL4G/BWak1c=;
        b=MpEYNvq9Gu+eQ+Gm/NlCgtjmldaKPFY6Fx7t2vgAKP5gQEshhKz9bL3hFTiZhWQRRVv9L+
        LLEk6tBo19dlU9m7dDJDD4SmJpxAJ+inewzifLkLj4/jzqgatFSe2A0nM1uTMRrYQFjO0u
        84XxYtDNDhXkWzHjX0t0O/SWzGYghxg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-410-9BWvuBkcN7CkJwFGtbh7Cg-1; Tue, 09 Feb 2021 12:21:04 -0500
X-MC-Unique: 9BWvuBkcN7CkJwFGtbh7Cg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 12063AFA84;
        Tue,  9 Feb 2021 17:21:03 +0000 (UTC)
Received: from bfoster (ovpn-113-234.rdu2.redhat.com [10.10.113.234])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A323D5C3E6;
        Tue,  9 Feb 2021 17:21:02 +0000 (UTC)
Date:   Tue, 9 Feb 2021 12:20:59 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/10] xfs_repair: set NEEDSREPAIR when we deliberately
 corrupt directories
Message-ID: <20210209172059.GE14273@bfoster>
References: <161284380403.3057868.11153586180065627226.stgit@magnolia>
 <161284384405.3057868.8114203697655713495.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161284384405.3057868.8114203697655713495.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 08, 2021 at 08:10:44PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> There are a few places in xfs_repair's directory checking code where we
> deliberately corrupt a directory entry as a sentinel to trigger a
> correction in later repair phase.  In the mean time, the filesystem is
> inconsistent, so set the needsrepair flag to force a re-run of repair if
> the system goes down.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

Hmm.. this seems orthogonal to the rest of the series. I'm sure we can
come up with various additional uses for the bit, but it seems a little
odd to me that repair might set it in some cases after a crash but not
others (if the filesystem happens to already be corrupt, for example).

Brian

>  repair/agheader.h   |    2 ++
>  repair/dir2.c       |    3 +++
>  repair/phase6.c     |    7 +++++++
>  repair/xfs_repair.c |   37 +++++++++++++++++++++++++++++++++++++
>  4 files changed, 49 insertions(+)
> 
> 
> diff --git a/repair/agheader.h b/repair/agheader.h
> index a63827c8..fa6fe596 100644
> --- a/repair/agheader.h
> +++ b/repair/agheader.h
> @@ -82,3 +82,5 @@ typedef struct fs_geo_list  {
>  #define XR_AG_AGF	0x2
>  #define XR_AG_AGI	0x4
>  #define XR_AG_SB_SEC	0x8
> +
> +void force_needsrepair(struct xfs_mount *mp);
> diff --git a/repair/dir2.c b/repair/dir2.c
> index eabdb4f2..922b8a3e 100644
> --- a/repair/dir2.c
> +++ b/repair/dir2.c
> @@ -15,6 +15,7 @@
>  #include "da_util.h"
>  #include "prefetch.h"
>  #include "progress.h"
> +#include "agheader.h"
>  
>  /*
>   * Known bad inode list.  These are seen when the leaf and node
> @@ -774,6 +775,7 @@ _("entry at block %u offset %" PRIdPTR " in directory inode %" PRIu64
>  				do_warn(
>  _("\tclearing inode number in entry at offset %" PRIdPTR "...\n"),
>  					(intptr_t)ptr - (intptr_t)d);
> +				force_needsrepair(mp);
>  				dep->name[0] = '/';
>  				*dirty = 1;
>  			} else {
> @@ -914,6 +916,7 @@ _("entry \"%*.*s\" in directory inode %" PRIu64 " points to self: "),
>  		 */
>  		if (junkit) {
>  			if (!no_modify) {
> +				force_needsrepair(mp);
>  				dep->name[0] = '/';
>  				*dirty = 1;
>  				do_warn(_("clearing entry\n"));
> diff --git a/repair/phase6.c b/repair/phase6.c
> index 14464bef..5ecbe9b2 100644
> --- a/repair/phase6.c
> +++ b/repair/phase6.c
> @@ -1649,6 +1649,7 @@ longform_dir2_entry_check_data(
>  			if (entry_junked(
>  	_("entry \"%s\" in directory inode %" PRIu64 " points to non-existent inode %" PRIu64 ""),
>  					fname, ip->i_ino, inum)) {
> +				force_needsrepair(mp);
>  				dep->name[0] = '/';
>  				libxfs_dir2_data_log_entry(&da, bp, dep);
>  			}
> @@ -1666,6 +1667,7 @@ longform_dir2_entry_check_data(
>  			if (entry_junked(
>  	_("entry \"%s\" in directory inode %" PRIu64 " points to free inode %" PRIu64),
>  					fname, ip->i_ino, inum)) {
> +				force_needsrepair(mp);
>  				dep->name[0] = '/';
>  				libxfs_dir2_data_log_entry(&da, bp, dep);
>  			}
> @@ -1684,6 +1686,7 @@ longform_dir2_entry_check_data(
>  				if (entry_junked(
>  	_("%s (ino %" PRIu64 ") in root (%" PRIu64 ") is not a directory"),
>  						ORPHANAGE, inum, ip->i_ino)) {
> +					force_needsrepair(mp);
>  					dep->name[0] = '/';
>  					libxfs_dir2_data_log_entry(&da, bp, dep);
>  				}
> @@ -1706,6 +1709,7 @@ longform_dir2_entry_check_data(
>  			if (entry_junked(
>  	_("entry \"%s\" (ino %" PRIu64 ") in dir %" PRIu64 " is a duplicate name"),
>  					fname, inum, ip->i_ino)) {
> +				force_needsrepair(mp);
>  				dep->name[0] = '/';
>  				libxfs_dir2_data_log_entry(&da, bp, dep);
>  			}
> @@ -1737,6 +1741,7 @@ longform_dir2_entry_check_data(
>  				if (entry_junked(
>  	_("entry \"%s\" (ino %" PRIu64 ") in dir %" PRIu64 " is not in the the first block"), fname,
>  						inum, ip->i_ino)) {
> +					force_needsrepair(mp);
>  					dep->name[0] = '/';
>  					libxfs_dir2_data_log_entry(&da, bp, dep);
>  				}
> @@ -1764,6 +1769,7 @@ longform_dir2_entry_check_data(
>  				if (entry_junked(
>  	_("entry \"%s\" in dir %" PRIu64 " is not the first entry"),
>  						fname, inum, ip->i_ino)) {
> +					force_needsrepair(mp);
>  					dep->name[0] = '/';
>  					libxfs_dir2_data_log_entry(&da, bp, dep);
>  				}
> @@ -1852,6 +1858,7 @@ _("entry \"%s\" in dir inode %" PRIu64 " inconsistent with .. value (%" PRIu64 "
>  				orphanage_ino = 0;
>  			nbad++;
>  			if (!no_modify)  {
> +				force_needsrepair(mp);
>  				dep->name[0] = '/';
>  				libxfs_dir2_data_log_entry(&da, bp, dep);
>  				if (verbose)
> diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
> index f607afcb..9dc73854 100644
> --- a/repair/xfs_repair.c
> +++ b/repair/xfs_repair.c
> @@ -754,6 +754,43 @@ clear_needsrepair(
>  		libxfs_buf_relse(bp);
>  }
>  
> +/*
> + * Mark the filesystem as needing repair.  This should only be called by code
> + * that deliberately sets invalid sentinel values in the on-disk metadata to
> + * trigger a later reconstruction, and only after we've settled the primary
> + * super contents (i.e. after phase 1).
> + */
> +void
> +force_needsrepair(
> +	struct xfs_mount	*mp)
> +{
> +	struct xfs_buf		*bp;
> +	int			error;
> +
> +	if (!xfs_sb_version_hascrc(&mp->m_sb) ||
> +	    xfs_sb_version_needsrepair(&mp->m_sb))
> +		return;
> +
> +	bp = libxfs_getsb(mp);
> +	if (!bp || bp->b_error) {
> +		do_log(
> +	_("couldn't get superblock to set needsrepair, err=%d\n"),
> +				bp ? bp->b_error : ENOMEM);
> +		return;
> +	} else {
> +		mp->m_sb.sb_features_incompat |=
> +				XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
> +		libxfs_sb_to_disk(bp->b_addr, &mp->m_sb);
> +
> +		/* Force the primary super to disk immediately. */
> +		error = -libxfs_bwrite(bp);
> +		if (error)
> +			do_log(_("couldn't force needsrepair, err=%d\n"), error);
> +	}
> +	if (bp)
> +		libxfs_buf_relse(bp);
> +}
> +
>  int
>  main(int argc, char **argv)
>  {
> 

