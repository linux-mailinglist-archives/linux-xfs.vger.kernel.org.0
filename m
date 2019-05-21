Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 294292581A
	for <lists+linux-xfs@lfdr.de>; Tue, 21 May 2019 21:16:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726466AbfEUTQL (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 21 May 2019 15:16:11 -0400
Received: from sandeen.net ([63.231.237.45]:43432 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726419AbfEUTQL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 21 May 2019 15:16:11 -0400
Received: from Liberator-6.local (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id E9F7A15D6E;
        Tue, 21 May 2019 14:16:06 -0500 (CDT)
Subject: Re: [PATCH 08/12] xfs_repair: refactor namecheck functions
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <155839420081.68606.4573219764134939943.stgit@magnolia>
 <155839425128.68606.14448412166622032502.stgit@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Openpgp: preference=signencrypt
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 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 pA==
Message-ID: <17704dc3-09a8-6013-7cbb-bb1b0be6911b@sandeen.net>
Date:   Tue, 21 May 2019 14:16:09 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <155839425128.68606.14448412166622032502.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 5/20/19 6:17 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Now that we have name check functions in libxfs, use them instead of our
> custom versions.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

I dig it.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  libxfs/libxfs_api_defs.h |    2 ++
>  repair/attr_repair.c     |   32 +++++++++++++-------------------
>  repair/da_util.c         |   27 ---------------------------
>  repair/da_util.h         |    6 ------
>  repair/dir2.c            |   12 ++----------
>  5 files changed, 17 insertions(+), 62 deletions(-)
> 
> 
> diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
> index 34bb552d..71a7ef53 100644
> --- a/libxfs/libxfs_api_defs.h
> +++ b/libxfs/libxfs_api_defs.h
> @@ -143,6 +143,8 @@
>  #define xfs_default_ifork_ops		libxfs_default_ifork_ops
>  #define xfs_fs_geometry			libxfs_fs_geometry
>  #define xfs_init_local_fork		libxfs_init_local_fork
> +#define xfs_dir2_namecheck		libxfs_dir2_namecheck
> +#define xfs_attr_namecheck		libxfs_attr_namecheck
>  
>  #define LIBXFS_ATTR_ROOT		ATTR_ROOT
>  #define LIBXFS_ATTR_SECURE		ATTR_SECURE
> diff --git a/repair/attr_repair.c b/repair/attr_repair.c
> index 5ad81c09..9a44f610 100644
> --- a/repair/attr_repair.c
> +++ b/repair/attr_repair.c
> @@ -122,14 +122,6 @@ set_da_freemap(xfs_mount_t *mp, da_freemap_t *map, int start, int stop)
>   * fork being emptied and put in shortform format.
>   */
>  
> -static int
> -attr_namecheck(
> -	uint8_t	*name,
> -	int	length)
> -{
> -	return namecheck((char *)name, length, false);
> -}
> -
>  /*
>   * This routine just checks what security needs are for attribute values
>   * only called when root flag is set, otherwise these names could exist in
> @@ -301,8 +293,8 @@ process_shortform_attr(
>  		}
>  
>  		/* namecheck checks for null chars in attr names. */
> -		if (attr_namecheck(currententry->nameval,
> -						currententry->namelen)) {
> +		if (!libxfs_attr_namecheck(currententry->nameval,
> +					   currententry->namelen)) {
>  			do_warn(
>  	_("entry contains illegal character in shortform attribute name\n"));
>  			junkit = 1;
> @@ -464,8 +456,9 @@ process_leaf_attr_local(
>  	xfs_attr_leaf_name_local_t *local;
>  
>  	local = xfs_attr3_leaf_name_local(leaf, i);
> -	if (local->namelen == 0 || attr_namecheck(local->nameval,
> -							local->namelen)) {
> +	if (local->namelen == 0 ||
> +	    !libxfs_attr_namecheck(local->nameval,
> +				   local->namelen)) {
>  		do_warn(
>  	_("attribute entry %d in attr block %u, inode %" PRIu64 " has bad name (namelen = %d)\n"),
>  			i, da_bno, ino, local->namelen);
> @@ -519,13 +512,14 @@ process_leaf_attr_remote(
>  
>  	remotep = xfs_attr3_leaf_name_remote(leaf, i);
>  
> -	if (remotep->namelen == 0 || attr_namecheck(remotep->name,
> -						remotep->namelen) ||
> -			be32_to_cpu(entry->hashval) !=
> -				libxfs_da_hashname((unsigned char *)&remotep->name[0],
> -						remotep->namelen) ||
> -			be32_to_cpu(entry->hashval) < last_hashval ||
> -			be32_to_cpu(remotep->valueblk) == 0) {
> +	if (remotep->namelen == 0 ||
> +	    !libxfs_attr_namecheck(remotep->name,
> +				   remotep->namelen) ||
> +	    be32_to_cpu(entry->hashval) !=
> +			libxfs_da_hashname((unsigned char *)&remotep->name[0],
> +					   remotep->namelen) ||
> +	    be32_to_cpu(entry->hashval) < last_hashval ||
> +	    be32_to_cpu(remotep->valueblk) == 0) {
>  		do_warn(
>  	_("inconsistent remote attribute entry %d in attr block %u, ino %" PRIu64 "\n"), i, da_bno, ino);
>  		return -1;
> diff --git a/repair/da_util.c b/repair/da_util.c
> index 4a258e58..8c818ea1 100644
> --- a/repair/da_util.c
> +++ b/repair/da_util.c
> @@ -12,33 +12,6 @@
>  #include "bmap.h"
>  #include "da_util.h"
>  
> -/*
> - * Takes a name and length (name need not be null-terminated) and whether
> - * we are checking a dir (as opposed to an attr).
> - * Returns 1 if the name contains a NUL or if a directory entry contains a '/'.
> - * Returns 0 if the name checks out.
> - */
> -int
> -namecheck(
> -	char	*name,
> -	int	length,
> -	bool	isadir)
> -{
> -	char	*c;
> -	int	i;
> -
> -	ASSERT(length < MAXNAMELEN);
> -
> -	for (c = name, i = 0; i < length; i++, c++) {
> -		if (isadir && *c == '/')
> -			return 1;
> -		if (*c == '\0')
> -			return 1;
> -	}
> -
> -	return 0;
> -}
> -
>  /*
>   * the cursor gets passed up and down the da btree processing
>   * routines.  The interior block processing routines use the
> diff --git a/repair/da_util.h b/repair/da_util.h
> index 041dff74..90fec00c 100644
> --- a/repair/da_util.h
> +++ b/repair/da_util.h
> @@ -24,12 +24,6 @@ typedef struct da_bt_cursor {
>  	struct blkmap		*blkmap;
>  } da_bt_cursor_t;
>  
> -int
> -namecheck(
> -	char		*name,
> -	int		length,
> -	bool		isadir);
> -
>  struct xfs_buf *
>  da_read_buf(
>  	xfs_mount_t	*mp,
> diff --git a/repair/dir2.c b/repair/dir2.c
> index 094ecb3d..4ac0084e 100644
> --- a/repair/dir2.c
> +++ b/repair/dir2.c
> @@ -44,14 +44,6 @@ _("malloc failed (%zu bytes) dir2_add_badlist:ino %" PRIu64 "\n"),
>  	l->ino = ino;
>  }
>  
> -static int
> -dir_namecheck(
> -	uint8_t	*name,
> -	int	length)
> -{
> -	return namecheck((char *)name, length, true);
> -}
> -
>  int
>  dir2_is_badino(
>  	xfs_ino_t	ino)
> @@ -318,7 +310,7 @@ _("entry #%d %s in shortform dir %" PRIu64),
>  		 * the length value is stored in a byte
>  		 * so it can't be too big, it can only wrap
>  		 */
> -		if (dir_namecheck(sfep->name, namelen)) {
> +		if (!libxfs_dir2_namecheck(sfep->name, namelen)) {
>  			/*
>  			 * junk entry
>  			 */
> @@ -789,7 +781,7 @@ _("\twould clear inode number in entry at offset %" PRIdPTR "...\n"),
>  		 * during phase 4.
>  		 */
>  		junkit = dep->name[0] == '/';
> -		nm_illegal = dir_namecheck(dep->name, dep->namelen);
> +		nm_illegal = !libxfs_dir2_namecheck(dep->name, dep->namelen);
>  		if (ino_discovery && nm_illegal) {
>  			do_warn(
>  _("entry at block %u offset %" PRIdPTR " in directory inode %" PRIu64 " has illegal name \"%*.*s\": "),
> 
