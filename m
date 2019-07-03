Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC5215E90F
	for <lists+linux-xfs@lfdr.de>; Wed,  3 Jul 2019 18:31:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727092AbfGCQbb (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 3 Jul 2019 12:31:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53512 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727144AbfGCQba (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 3 Jul 2019 12:31:30 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0E19F30872C6;
        Wed,  3 Jul 2019 16:31:30 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 84C1F508E5;
        Wed,  3 Jul 2019 16:31:29 +0000 (UTC)
Date:   Wed, 3 Jul 2019 12:31:27 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com
Subject: Re: [PATCH v2 3/9] xfs: introduce new v5 bulkstat structure
Message-ID: <20190703163127.GM26057@bfoster>
References: <156158193320.495715.6675123051075804739.stgit@magnolia>
 <156158195258.495715.3305107510637882010.stgit@magnolia>
 <20190703153246.GW1404256@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190703153246.GW1404256@magnolia>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Wed, 03 Jul 2019 16:31:30 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 03, 2019 at 08:32:46AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Introduce a new version of the in-core bulkstat structure that supports
> our new v5 format features.  This structure also fills the gaps in the
> previous structure.  We leave wiring up the ioctls for the next patch.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Allison Collins <allison.henderson@oracle.com>
> ---
> v2: memset the v1 structure when converting from v5
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_fs.h     |   48 +++++++++++++++++++++++++++-
>  fs/xfs/libxfs/xfs_health.h |    2 +
>  fs/xfs/xfs_health.c        |    2 +
>  fs/xfs/xfs_ioctl.c         |    9 +++--
>  fs/xfs/xfs_ioctl.h         |    2 +
>  fs/xfs/xfs_ioctl32.c       |   10 ++++--
>  fs/xfs/xfs_itable.c        |   76 +++++++++++++++++++++++++++++++++-----------
>  fs/xfs/xfs_itable.h        |    4 ++
>  fs/xfs/xfs_ondisk.h        |    2 +
>  9 files changed, 125 insertions(+), 30 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> index ef0dce229fa4..132e364eb141 100644
> --- a/fs/xfs/libxfs/xfs_fs.h
> +++ b/fs/xfs/libxfs/xfs_fs.h
> @@ -358,6 +358,52 @@ struct xfs_bstat {
>  	__u16		bs_aextents;	/* attribute number of extents	*/
>  };
>  
> +/* New bulkstat structure that reports v5 features and fixes padding issues */
> +struct xfs_bulkstat {
> +	uint64_t	bs_ino;		/* inode number			*/
> +	uint64_t	bs_size;	/* file size			*/
> +
> +	uint64_t	bs_blocks;	/* number of blocks		*/
> +	uint64_t	bs_xflags;	/* extended flags		*/
> +
> +	uint64_t	bs_atime;	/* access time, seconds		*/
> +	uint64_t	bs_mtime;	/* modify time, seconds		*/
> +
> +	uint64_t	bs_ctime;	/* inode change time, seconds	*/
> +	uint64_t	bs_btime;	/* creation time, seconds	*/
> +
> +	uint32_t	bs_gen;		/* generation count		*/
> +	uint32_t	bs_uid;		/* user id			*/
> +	uint32_t	bs_gid;		/* group id			*/
> +	uint32_t	bs_projectid;	/* project id			*/
> +
> +	uint32_t	bs_atime_nsec;	/* access time, nanoseconds	*/
> +	uint32_t	bs_mtime_nsec;	/* modify time, nanoseconds	*/
> +	uint32_t	bs_ctime_nsec;	/* inode change time, nanoseconds */
> +	uint32_t	bs_btime_nsec;	/* creation time, nanoseconds	*/
> +
> +	uint32_t	bs_blksize;	/* block size			*/
> +	uint32_t	bs_rdev;	/* device value			*/
> +	uint32_t	bs_cowextsize_blks; /* cow extent size hint, blocks */
> +	uint32_t	bs_extsize_blks; /* extent size hint, blocks	*/
> +
> +	uint32_t	bs_nlink;	/* number of links		*/
> +	uint32_t	bs_extents;	/* number of extents		*/
> +	uint32_t	bs_aextents;	/* attribute number of extents	*/
> +	uint16_t	bs_version;	/* structure version		*/
> +	uint16_t	bs_forkoff;	/* inode fork offset in bytes	*/
> +
> +	uint16_t	bs_sick;	/* sick inode metadata		*/
> +	uint16_t	bs_checked;	/* checked inode metadata	*/
> +	uint16_t	bs_mode;	/* type and mode		*/
> +	uint16_t	bs_pad2;	/* zeroed			*/
> +
> +	uint64_t	bs_pad[7];	/* zeroed			*/
> +};
> +
> +#define XFS_BULKSTAT_VERSION_V1	(1)
> +#define XFS_BULKSTAT_VERSION_V5	(5)
> +
>  /* bs_sick flags */
>  #define XFS_BS_SICK_INODE	(1 << 0)  /* inode core */
>  #define XFS_BS_SICK_BMBTD	(1 << 1)  /* data fork */
> @@ -374,7 +420,7 @@ struct xfs_bstat {
>   * to retain compatibility with "old" filesystems).
>   */
>  static inline uint32_t
> -bstat_get_projid(struct xfs_bstat *bs)
> +bstat_get_projid(const struct xfs_bstat *bs)
>  {
>  	return (uint32_t)bs->bs_projid_hi << 16 | bs->bs_projid_lo;
>  }
> diff --git a/fs/xfs/libxfs/xfs_health.h b/fs/xfs/libxfs/xfs_health.h
> index 49ddfeac19f2..272005ac8c88 100644
> --- a/fs/xfs/libxfs/xfs_health.h
> +++ b/fs/xfs/libxfs/xfs_health.h
> @@ -185,6 +185,6 @@ xfs_inode_is_healthy(struct xfs_inode *ip)
>  
>  void xfs_fsop_geom_health(struct xfs_mount *mp, struct xfs_fsop_geom *geo);
>  void xfs_ag_geom_health(struct xfs_perag *pag, struct xfs_ag_geometry *ageo);
> -void xfs_bulkstat_health(struct xfs_inode *ip, struct xfs_bstat *bs);
> +void xfs_bulkstat_health(struct xfs_inode *ip, struct xfs_bulkstat *bs);
>  
>  #endif	/* __XFS_HEALTH_H__ */
> diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
> index ca66c314a928..8e0cb05a7142 100644
> --- a/fs/xfs/xfs_health.c
> +++ b/fs/xfs/xfs_health.c
> @@ -369,7 +369,7 @@ static const struct ioctl_sick_map ino_map[] = {
>  void
>  xfs_bulkstat_health(
>  	struct xfs_inode		*ip,
> -	struct xfs_bstat		*bs)
> +	struct xfs_bulkstat		*bs)
>  {
>  	const struct ioctl_sick_map	*m;
>  	unsigned int			sick;
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 0bfee8a05454..9f1984c31ba2 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -716,10 +716,13 @@ xfs_ioc_space(
>  /* Return 0 on success or positive error */
>  int
>  xfs_fsbulkstat_one_fmt(
> -	struct xfs_ibulk	*breq,
> -	const struct xfs_bstat	*bstat)
> +	struct xfs_ibulk		*breq,
> +	const struct xfs_bulkstat	*bstat)
>  {
> -	if (copy_to_user(breq->ubuffer, bstat, sizeof(*bstat)))
> +	struct xfs_bstat		bs1;
> +
> +	xfs_bulkstat_to_bstat(breq->mp, &bs1, bstat);
> +	if (copy_to_user(breq->ubuffer, &bs1, sizeof(bs1)))
>  		return -EFAULT;
>  	return xfs_ibulk_advance(breq, sizeof(struct xfs_bstat));
>  }
> diff --git a/fs/xfs/xfs_ioctl.h b/fs/xfs/xfs_ioctl.h
> index cb34bc821201..514d3028a134 100644
> --- a/fs/xfs/xfs_ioctl.h
> +++ b/fs/xfs/xfs_ioctl.h
> @@ -82,7 +82,7 @@ struct xfs_bstat;
>  struct xfs_inogrp;
>  
>  int xfs_fsbulkstat_one_fmt(struct xfs_ibulk *breq,
> -			   const struct xfs_bstat *bstat);
> +			   const struct xfs_bulkstat *bstat);
>  int xfs_fsinumbers_fmt(struct xfs_ibulk *breq, const struct xfs_inogrp *igrp);
>  
>  #endif
> diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
> index 084b44a026a7..ed8e012dabbb 100644
> --- a/fs/xfs/xfs_ioctl32.c
> +++ b/fs/xfs/xfs_ioctl32.c
> @@ -166,10 +166,14 @@ xfs_bstime_store_compat(
>  /* Return 0 on success or positive error (to xfs_bulkstat()) */
>  STATIC int
>  xfs_fsbulkstat_one_fmt_compat(
> -	struct xfs_ibulk	*breq,
> -	const struct xfs_bstat	*buffer)
> +	struct xfs_ibulk		*breq,
> +	const struct xfs_bulkstat	*bstat)
>  {
> -	struct compat_xfs_bstat	__user *p32 = breq->ubuffer;
> +	struct compat_xfs_bstat	__user	*p32 = breq->ubuffer;
> +	struct xfs_bstat		bs1;
> +	struct xfs_bstat		*buffer = &bs1;
> +
> +	xfs_bulkstat_to_bstat(breq->mp, &bs1, bstat);
>  
>  	if (put_user(buffer->bs_ino,	  &p32->bs_ino)		||
>  	    put_user(buffer->bs_mode,	  &p32->bs_mode)	||
> diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
> index 8be4f8edbcad..5d406915144d 100644
> --- a/fs/xfs/xfs_itable.c
> +++ b/fs/xfs/xfs_itable.c
> @@ -24,7 +24,7 @@
>   * Bulk Stat
>   * =========
>   *
> - * Use the inode walking functions to fill out struct xfs_bstat for every
> + * Use the inode walking functions to fill out struct xfs_bulkstat for every
>   * allocated inode, then pass the stat information to some externally provided
>   * iteration function.
>   */
> @@ -32,7 +32,7 @@
>  struct xfs_bstat_chunk {
>  	bulkstat_one_fmt_pf	formatter;
>  	struct xfs_ibulk	*breq;
> -	struct xfs_bstat	*buf;
> +	struct xfs_bulkstat	*buf;
>  };
>  
>  /*
> @@ -61,7 +61,7 @@ xfs_bulkstat_one_int(
>  	struct xfs_icdinode	*dic;		/* dinode core info pointer */
>  	struct xfs_inode	*ip;		/* incore inode pointer */
>  	struct inode		*inode;
> -	struct xfs_bstat	*buf = bc->buf;
> +	struct xfs_bulkstat	*buf = bc->buf;
>  	int			error = -EINVAL;
>  
>  	if (xfs_internal_inum(mp, ino))
> @@ -84,37 +84,35 @@ xfs_bulkstat_one_int(
>  	/* xfs_iget returns the following without needing
>  	 * further change.
>  	 */
> -	buf->bs_projid_lo = dic->di_projid_lo;
> -	buf->bs_projid_hi = dic->di_projid_hi;
> +	buf->bs_projectid = xfs_get_projid(ip);
>  	buf->bs_ino = ino;
>  	buf->bs_uid = dic->di_uid;
>  	buf->bs_gid = dic->di_gid;
>  	buf->bs_size = dic->di_size;
>  
>  	buf->bs_nlink = inode->i_nlink;
> -	buf->bs_atime.tv_sec = inode->i_atime.tv_sec;
> -	buf->bs_atime.tv_nsec = inode->i_atime.tv_nsec;
> -	buf->bs_mtime.tv_sec = inode->i_mtime.tv_sec;
> -	buf->bs_mtime.tv_nsec = inode->i_mtime.tv_nsec;
> -	buf->bs_ctime.tv_sec = inode->i_ctime.tv_sec;
> -	buf->bs_ctime.tv_nsec = inode->i_ctime.tv_nsec;
> +	buf->bs_atime = inode->i_atime.tv_sec;
> +	buf->bs_atime_nsec = inode->i_atime.tv_nsec;
> +	buf->bs_mtime = inode->i_mtime.tv_sec;
> +	buf->bs_mtime_nsec = inode->i_mtime.tv_nsec;
> +	buf->bs_ctime = inode->i_ctime.tv_sec;
> +	buf->bs_ctime_nsec = inode->i_ctime.tv_nsec;
> +	buf->bs_btime = dic->di_crtime.t_sec;
> +	buf->bs_btime_nsec = dic->di_crtime.t_nsec;
>  	buf->bs_gen = inode->i_generation;
>  	buf->bs_mode = inode->i_mode;
>  
>  	buf->bs_xflags = xfs_ip2xflags(ip);
> -	buf->bs_extsize = dic->di_extsize << mp->m_sb.sb_blocklog;
> +	buf->bs_extsize_blks = dic->di_extsize;
>  	buf->bs_extents = dic->di_nextents;
> -	memset(buf->bs_pad, 0, sizeof(buf->bs_pad));
>  	xfs_bulkstat_health(ip, buf);
> -	buf->bs_dmevmask = dic->di_dmevmask;
> -	buf->bs_dmstate = dic->di_dmstate;
>  	buf->bs_aextents = dic->di_anextents;
>  	buf->bs_forkoff = XFS_IFORK_BOFF(ip);
> +	buf->bs_version = XFS_BULKSTAT_VERSION_V5;
>  
>  	if (dic->di_version == 3) {
>  		if (dic->di_flags2 & XFS_DIFLAG2_COWEXTSIZE)
> -			buf->bs_cowextsize = dic->di_cowextsize <<
> -					mp->m_sb.sb_blocklog;
> +			buf->bs_cowextsize_blks = dic->di_cowextsize;
>  	}
>  
>  	switch (dic->di_format) {
> @@ -170,7 +168,8 @@ xfs_bulkstat_one(
>  
>  	ASSERT(breq->icount == 1);
>  
> -	bc.buf = kmem_zalloc(sizeof(struct xfs_bstat), KM_SLEEP | KM_MAYFAIL);
> +	bc.buf = kmem_zalloc(sizeof(struct xfs_bulkstat),
> +			KM_SLEEP | KM_MAYFAIL);
>  	if (!bc.buf)
>  		return -ENOMEM;
>  
> @@ -243,7 +242,8 @@ xfs_bulkstat(
>  	if (xfs_bulkstat_already_done(breq->mp, breq->startino))
>  		return 0;
>  
> -	bc.buf = kmem_zalloc(sizeof(struct xfs_bstat), KM_SLEEP | KM_MAYFAIL);
> +	bc.buf = kmem_zalloc(sizeof(struct xfs_bulkstat),
> +			KM_SLEEP | KM_MAYFAIL);
>  	if (!bc.buf)
>  		return -ENOMEM;
>  
> @@ -265,6 +265,44 @@ xfs_bulkstat(
>  	return error;
>  }
>  
> +/* Convert bulkstat (v5) to bstat (v1). */
> +void
> +xfs_bulkstat_to_bstat(
> +	struct xfs_mount		*mp,
> +	struct xfs_bstat		*bs1,
> +	const struct xfs_bulkstat	*bstat)
> +{
> +	memset(bs1, 0, sizeof(struct xfs_bstat));
> +	bs1->bs_ino = bstat->bs_ino;
> +	bs1->bs_mode = bstat->bs_mode;
> +	bs1->bs_nlink = bstat->bs_nlink;
> +	bs1->bs_uid = bstat->bs_uid;
> +	bs1->bs_gid = bstat->bs_gid;
> +	bs1->bs_rdev = bstat->bs_rdev;
> +	bs1->bs_blksize = bstat->bs_blksize;
> +	bs1->bs_size = bstat->bs_size;
> +	bs1->bs_atime.tv_sec = bstat->bs_atime;
> +	bs1->bs_mtime.tv_sec = bstat->bs_mtime;
> +	bs1->bs_ctime.tv_sec = bstat->bs_ctime;
> +	bs1->bs_atime.tv_nsec = bstat->bs_atime_nsec;
> +	bs1->bs_mtime.tv_nsec = bstat->bs_mtime_nsec;
> +	bs1->bs_ctime.tv_nsec = bstat->bs_ctime_nsec;
> +	bs1->bs_blocks = bstat->bs_blocks;
> +	bs1->bs_xflags = bstat->bs_xflags;
> +	bs1->bs_extsize = XFS_FSB_TO_B(mp, bstat->bs_extsize_blks);
> +	bs1->bs_extents = bstat->bs_extents;
> +	bs1->bs_gen = bstat->bs_gen;
> +	bs1->bs_projid_lo = bstat->bs_projectid & 0xFFFF;
> +	bs1->bs_forkoff = bstat->bs_forkoff;
> +	bs1->bs_projid_hi = bstat->bs_projectid >> 16;
> +	bs1->bs_sick = bstat->bs_sick;
> +	bs1->bs_checked = bstat->bs_checked;
> +	bs1->bs_cowextsize = XFS_FSB_TO_B(mp, bstat->bs_cowextsize_blks);
> +	bs1->bs_dmevmask = 0;
> +	bs1->bs_dmstate = 0;
> +	bs1->bs_aextents = bstat->bs_aextents;
> +}
> +
>  struct xfs_inumbers_chunk {
>  	inumbers_fmt_pf		formatter;
>  	struct xfs_ibulk	*breq;
> diff --git a/fs/xfs/xfs_itable.h b/fs/xfs/xfs_itable.h
> index cfd3c93226f3..60e259192056 100644
> --- a/fs/xfs/xfs_itable.h
> +++ b/fs/xfs/xfs_itable.h
> @@ -38,10 +38,12 @@ xfs_ibulk_advance(
>   */
>  
>  typedef int (*bulkstat_one_fmt_pf)(struct xfs_ibulk *breq,
> -		const struct xfs_bstat *bstat);
> +		const struct xfs_bulkstat *bstat);
>  
>  int xfs_bulkstat_one(struct xfs_ibulk *breq, bulkstat_one_fmt_pf formatter);
>  int xfs_bulkstat(struct xfs_ibulk *breq, bulkstat_one_fmt_pf formatter);
> +void xfs_bulkstat_to_bstat(struct xfs_mount *mp, struct xfs_bstat *bs1,
> +		const struct xfs_bulkstat *bstat);
>  
>  typedef int (*inumbers_fmt_pf)(struct xfs_ibulk *breq,
>  		const struct xfs_inogrp *igrp);
> diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
> index c8ba98fae30a..0b4cdda68524 100644
> --- a/fs/xfs/xfs_ondisk.h
> +++ b/fs/xfs/xfs_ondisk.h
> @@ -146,6 +146,8 @@ xfs_check_ondisk_structs(void)
>  	XFS_CHECK_OFFSET(struct xfs_dir3_data_hdr, hdr.magic,	0);
>  	XFS_CHECK_OFFSET(struct xfs_dir3_free, hdr.hdr.magic,	0);
>  	XFS_CHECK_OFFSET(struct xfs_attr3_leafblock, hdr.info.hdr, 0);
> +
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_bulkstat,		192);
>  }
>  
>  #endif /* __XFS_ONDISK_H */
