Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB806EB033
	for <lists+linux-xfs@lfdr.de>; Thu, 31 Oct 2019 13:27:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726506AbfJaM1J (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 31 Oct 2019 08:27:09 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:39709 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726462AbfJaM1J (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Oct 2019 08:27:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572524828;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nIqfT+/2vYRoC2kpKMJcg/VaMJmUPm0KgXk3jTKbJ4w=;
        b=SPEI5UtBzYK/9gApsSpCrUkg1NvSuBzYeqZGcQgZCF4dE2BGdPjfbGb2u7KEvO8VuFC2oN
        0j4G25/UgCxkyNwBFj+qtFrezMuUhFFT4lIn93eH3fNfuRMyJeRRnAQ36tuFQa8sPY74/x
        MmNMy3Dj1+9HDVMu2nJLGEUPNmuaguQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-374-ML98GbvwNAKEta7AGETO9w-1; Thu, 31 Oct 2019 08:27:05 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0D0168017E0;
        Thu, 31 Oct 2019 12:27:04 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4810B5D6A3;
        Thu, 31 Oct 2019 12:27:03 +0000 (UTC)
Date:   Thu, 31 Oct 2019 08:27:01 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     kaixuxia <xiakaixu1987@gmail.com>
Cc:     linux-xfs@vger.kernel.org, darrick.wong@oracle.com,
        newtongao@tencent.com, jasperwang@tencent.com
Subject: Re: [PATCH RFC] xfs: Fix deadlock between AGI and AGF when target_ip
 exists in xfs_rename()
Message-ID: <20191031122701.GB54006@bfoster>
References: <1572428974-8657-1-git-send-email-kaixuxia@tencent.com>
MIME-Version: 1.0
In-Reply-To: <1572428974-8657-1-git-send-email-kaixuxia@tencent.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: ML98GbvwNAKEta7AGETO9w-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 30, 2019 at 05:49:34PM +0800, kaixuxia wrote:
> When target_ip exists in xfs_rename(), the xfs_dir_replace() call may
> need to hold the AGF lock to allocate more blocks, and then invoking
> the xfs_droplink() call to hold AGI lock to drop target_ip onto the
> unlinked list, so we get the lock order AGF->AGI. This would break the
> ordering constraint on AGI and AGF locking - inode allocation locks
> the AGI, then can allocate a new extent for new inodes, locking the
> AGF after the AGI.
>=20
> In this patch we check whether the replace operation need more
> blocks firstly. If so, acquire the agi lock firstly to preserve
> locking order(AGI/AGF). Actually, the locking order problem only
> occurs when we are locking the AGI/AGF of the same AG. For multiple
> AGs the AGI lock will be released after the transaction committed.
>=20
> Signed-off-by: kaixuxia <kaixuxia@tencent.com>
> ---
>  fs/xfs/libxfs/xfs_dir2.c | 30 ++++++++++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_dir2.h |  2 ++
>  fs/xfs/xfs_inode.c       | 14 ++++++++++++++
>  3 files changed, 46 insertions(+)
>=20
> diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
> index 867c5de..9d9ae16 100644
> --- a/fs/xfs/libxfs/xfs_dir2.c
> +++ b/fs/xfs/libxfs/xfs_dir2.c
> @@ -463,6 +463,36 @@
>  }
> =20
>  /*
> + * Check whether the replace operation need more blocks. Ignore
> + * the parameters check since the real replace() call below will
> + * do that.
> + */
> +bool
> +xfs_dir_replace_needblock(
> +=09struct xfs_inode=09*dp,
> +=09xfs_ino_t=09=09inum)
> +{
> +=09int=09=09=09newsize;
> +=09xfs_dir2_sf_hdr_t=09*sfp;
> +
> +=09/*
> +=09 * Only convert the shortform directory to block form maybe need
> +=09 * more blocks.
> +=09 */
> +=09if (dp->i_d.di_format !=3D XFS_DINODE_FMT_LOCAL)
> +=09=09return false;
> +
> +=09sfp =3D (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
> +=09newsize =3D dp->i_df.if_bytes + (sfp->count + 1) * XFS_INO64_DIFF;
> +
> +=09if (inum > XFS_DIR2_MAX_SHORT_INUM &&
> +=09    sfp->i8count =3D=3D 0 && newsize > XFS_IFORK_DSIZE(dp))
> +=09=09return true;
> +=09else
> +=09=09return false;
> +}
> +

It's slightly unfortunate we need to do these kind of double checks, but
it seems reasonable enough as an isolated fix. From a factoring
standpoint, it might be a little cleaner to move this down in
xfs_dir2_sf.c as an xfs_dir2_sf_replace_needblock() helper, actually use
it in the xfs_dir2_sf_replace() function where these checks are
currently open coded and then export it so we can call it in the higher
level function as well for the locking fix.

Brian

> +/*
>   * Replace the inode number of a directory entry.
>   */
>  int
> diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
> index f542447..e436c14 100644
> --- a/fs/xfs/libxfs/xfs_dir2.h
> +++ b/fs/xfs/libxfs/xfs_dir2.h
> @@ -124,6 +124,8 @@ extern int xfs_dir_lookup(struct xfs_trans *tp, struc=
t xfs_inode *dp,
>  extern int xfs_dir_removename(struct xfs_trans *tp, struct xfs_inode *dp=
,
>  =09=09=09=09struct xfs_name *name, xfs_ino_t ino,
>  =09=09=09=09xfs_extlen_t tot);
> +extern bool xfs_dir_replace_needblock(struct xfs_inode *dp,
> +=09=09=09=09xfs_ino_t inum);
>  extern int xfs_dir_replace(struct xfs_trans *tp, struct xfs_inode *dp,
>  =09=09=09=09struct xfs_name *name, xfs_ino_t inum,
>  =09=09=09=09xfs_extlen_t tot);
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 18f4b26..c239070 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -3196,6 +3196,7 @@ struct xfs_iunlink {
>  =09struct xfs_trans=09*tp;
>  =09struct xfs_inode=09*wip =3D NULL;=09=09/* whiteout inode */
>  =09struct xfs_inode=09*inodes[__XFS_SORT_INODES];
> +=09struct xfs_buf=09=09*agibp;
>  =09int=09=09=09num_inodes =3D __XFS_SORT_INODES;
>  =09bool=09=09=09new_parent =3D (src_dp !=3D target_dp);
>  =09bool=09=09=09src_is_directory =3D S_ISDIR(VFS_I(src_ip)->i_mode);
> @@ -3361,6 +3362,19 @@ struct xfs_iunlink {
>  =09=09 * In case there is already an entry with the same
>  =09=09 * name at the destination directory, remove it first.
>  =09=09 */
> +
> +=09=09/*
> +=09=09 * Check whether the replace operation need more blocks.
> +=09=09 * If so, acquire the agi lock firstly to preserve locking
> +=09=09 * order(AGI/AGF).
> +=09=09 */
> +=09=09if (xfs_dir_replace_needblock(target_dp, src_ip->i_ino)) {
> +=09=09=09error =3D xfs_read_agi(mp, tp,
> +=09=09=09=09=09XFS_INO_TO_AGNO(mp, target_ip->i_ino), &agibp);
> +=09=09=09if (error)
> +=09=09=09=09goto out_trans_cancel;
> +=09=09}
> +
>  =09=09error =3D xfs_dir_replace(tp, target_dp, target_name,
>  =09=09=09=09=09src_ip->i_ino, spaceres);
>  =09=09if (error)
> --=20
> 1.8.3.1
>=20

