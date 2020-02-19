Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5423C1660BB
	for <lists+linux-xfs@lfdr.de>; Thu, 20 Feb 2020 16:16:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728339AbgBTPQA (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 20 Feb 2020 10:16:00 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:53910 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728338AbgBTPQA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Feb 2020 10:16:00 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01KFF5og087146
        for <linux-xfs@vger.kernel.org>; Thu, 20 Feb 2020 10:15:58 -0500
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2y8ubtmnqj-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Thu, 20 Feb 2020 10:15:57 -0500
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.ibm.com>;
        Thu, 20 Feb 2020 15:15:56 -0000
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 20 Feb 2020 15:15:53 -0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01KFDekn40763856
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 15:13:40 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6574C11C04C;
        Thu, 20 Feb 2020 15:14:36 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 44FEE11C06C;
        Thu, 20 Feb 2020 15:14:35 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.199.61.89])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 20 Feb 2020 15:14:35 +0000 (GMT)
From:   Chandan Rajendra <chandan@linux.ibm.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: remove the icdinode di_uid/di_gid members
Date:   Wed, 19 Feb 2020 21:55:23 +0530
Organization: IBM
In-Reply-To: <20200218210020.40846-3-hch@lst.de>
References: <20200218210020.40846-1-hch@lst.de> <20200218210020.40846-3-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-TM-AS-GCONF: 00
x-cbid: 20022015-4275-0000-0000-000003A3D570
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20022015-4276-0000-0000-000038B7E27C
Message-Id: <1956555.uNXsGdn92h@localhost.localdomain>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-20_04:2020-02-19,2020-02-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 lowpriorityscore=0 clxscore=1015 adultscore=0 bulkscore=0
 priorityscore=1501 mlxscore=0 impostorscore=0 suspectscore=1 spamscore=0
 mlxlogscore=999 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2001150001 definitions=main-2002200113
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wednesday, February 19, 2020 2:30 AM Christoph Hellwig wrote: 
> Use the Linux inode i_uid/i_gid members everywhere and just convert
> from/to the scalar value when reading or writing the on-disk inode.
>

The conversion b/w kuid and on-disk uid is correct.

Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_inode_buf.c | 10 ++++-----
>  fs/xfs/libxfs/xfs_inode_buf.h |  2 --
>  fs/xfs/xfs_dquot.c            |  4 ++--
>  fs/xfs/xfs_inode.c            | 14 ++++--------
>  fs/xfs/xfs_inode_item.c       |  4 ++--
>  fs/xfs/xfs_ioctl.c            |  6 +++---
>  fs/xfs/xfs_iops.c             |  6 +-----
>  fs/xfs/xfs_itable.c           |  4 ++--
>  fs/xfs/xfs_qm.c               | 40 ++++++++++++++++++++++-------------
>  fs/xfs/xfs_quota.h            |  4 ++--
>  fs/xfs/xfs_symlink.c          |  4 +---
>  11 files changed, 46 insertions(+), 52 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index cc4efd34843a..bc72b575ceed 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -222,10 +222,8 @@ xfs_inode_from_disk(
>  	}
> 
>  	to->di_format = from->di_format;
> -	to->di_uid = be32_to_cpu(from->di_uid);
> -	inode->i_uid = xfs_uid_to_kuid(to->di_uid);
> -	to->di_gid = be32_to_cpu(from->di_gid);
> -	inode->i_gid = xfs_gid_to_kgid(to->di_gid);
> +	inode->i_uid = xfs_uid_to_kuid(be32_to_cpu(from->di_uid));
> +	inode->i_gid = xfs_gid_to_kgid(be32_to_cpu(from->di_gid));
>  	to->di_flushiter = be16_to_cpu(from->di_flushiter);
> 
>  	/*
> @@ -278,8 +276,8 @@ xfs_inode_to_disk(
> 
>  	to->di_version = from->di_version;
>  	to->di_format = from->di_format;
> -	to->di_uid = cpu_to_be32(from->di_uid);
> -	to->di_gid = cpu_to_be32(from->di_gid);
> +	to->di_uid = cpu_to_be32(xfs_kuid_to_uid(inode->i_uid));
> +	to->di_gid = cpu_to_be32(xfs_kgid_to_gid(inode->i_gid));
>  	to->di_projid_lo = cpu_to_be16(from->di_projid & 0xffff);
>  	to->di_projid_hi = cpu_to_be16(from->di_projid >> 16);
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
> index fd94b1078722..2683e1e2c4a6 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.h
> +++ b/fs/xfs/libxfs/xfs_inode_buf.h
> @@ -19,8 +19,6 @@ struct xfs_icdinode {
>  	int8_t		di_version;	/* inode version */
>  	int8_t		di_format;	/* format of di_c data */
>  	uint16_t	di_flushiter;	/* incremented on flush */
> -	uint32_t	di_uid;		/* owner's user id */
> -	uint32_t	di_gid;		/* owner's group id */
>  	uint32_t	di_projid;	/* owner's project id */
>  	xfs_fsize_t	di_size;	/* number of bytes in file */
>  	xfs_rfsblock_t	di_nblocks;	/* # of direct & btree blocks used */
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index d223e1ae90a6..3579de9306c1 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -829,9 +829,9 @@ xfs_qm_id_for_quotatype(
>  {
>  	switch (type) {
>  	case XFS_DQ_USER:
> -		return ip->i_d.di_uid;
> +		return xfs_kuid_to_uid(VFS_I(ip)->i_uid);
>  	case XFS_DQ_GROUP:
> -		return ip->i_d.di_gid;
> +		return xfs_kgid_to_gid(VFS_I(ip)->i_gid);
>  	case XFS_DQ_PROJ:
>  		return ip->i_d.di_projid;
>  	}
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 938b0943bd95..3324e1696354 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -813,18 +813,15 @@ xfs_ialloc(
>  	inode->i_mode = mode;
>  	set_nlink(inode, nlink);
>  	inode->i_uid = current_fsuid();
> -	ip->i_d.di_uid = xfs_kuid_to_uid(inode->i_uid);
>  	inode->i_rdev = rdev;
>  	ip->i_d.di_projid = prid;
> 
>  	if (pip && XFS_INHERIT_GID(pip)) {
>  		inode->i_gid = VFS_I(pip)->i_gid;
> -		ip->i_d.di_gid = pip->i_d.di_gid;
>  		if ((VFS_I(pip)->i_mode & S_ISGID) && S_ISDIR(mode))
>  			inode->i_mode |= S_ISGID;
>  	} else {
>  		inode->i_gid = current_fsgid();
> -		ip->i_d.di_gid = xfs_kgid_to_gid(inode->i_gid);
>  	}
> 
>  	/*
> @@ -832,9 +829,8 @@ xfs_ialloc(
>  	 * ID or one of the supplementary group IDs, the S_ISGID bit is cleared
>  	 * (and only if the irix_sgid_inherit compatibility variable is set).
>  	 */
> -	if ((irix_sgid_inherit) &&
> -	    (inode->i_mode & S_ISGID) &&
> -	    (!in_group_p(xfs_gid_to_kgid(ip->i_d.di_gid))))
> +	if (irix_sgid_inherit &&
> +	    (inode->i_mode & S_ISGID) && !in_group_p(inode->i_gid))
>  		inode->i_mode &= ~S_ISGID;
> 
>  	ip->i_d.di_size = 0;
> @@ -1162,8 +1158,7 @@ xfs_create(
>  	/*
>  	 * Make sure that we have allocated dquot(s) on disk.
>  	 */
> -	error = xfs_qm_vop_dqalloc(dp, xfs_kuid_to_uid(current_fsuid()),
> -					xfs_kgid_to_gid(current_fsgid()), prid,
> +	error = xfs_qm_vop_dqalloc(dp, current_fsuid(), current_fsgid(), prid,
>  					XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT,
>  					&udqp, &gdqp, &pdqp);
>  	if (error)
> @@ -1313,8 +1308,7 @@ xfs_create_tmpfile(
>  	/*
>  	 * Make sure that we have allocated dquot(s) on disk.
>  	 */
> -	error = xfs_qm_vop_dqalloc(dp, xfs_kuid_to_uid(current_fsuid()),
> -				xfs_kgid_to_gid(current_fsgid()), prid,
> +	error = xfs_qm_vop_dqalloc(dp, current_fsuid(), current_fsgid(), prid,
>  				XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT,
>  				&udqp, &gdqp, &pdqp);
>  	if (error)
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index 8bd5d0de6321..83d7914556ef 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -308,8 +308,8 @@ xfs_inode_to_log_dinode(
> 
>  	to->di_version = from->di_version;
>  	to->di_format = from->di_format;
> -	to->di_uid = from->di_uid;
> -	to->di_gid = from->di_gid;
> +	to->di_uid = xfs_kuid_to_uid(inode->i_uid);
> +	to->di_gid = xfs_kgid_to_gid(inode->i_gid);
>  	to->di_projid_lo = from->di_projid & 0xffff;
>  	to->di_projid_hi = from->di_projid >> 16;
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index d42de92cb283..0f85bedc5977 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1434,9 +1434,9 @@ xfs_ioctl_setattr(
>  	 * because the i_*dquot fields will get updated anyway.
>  	 */
>  	if (XFS_IS_QUOTA_ON(mp)) {
> -		code = xfs_qm_vop_dqalloc(ip, ip->i_d.di_uid,
> -					 ip->i_d.di_gid, fa->fsx_projid,
> -					 XFS_QMOPT_PQUOTA, &udqp, NULL, &pdqp);
> +		code = xfs_qm_vop_dqalloc(ip, VFS_I(ip)->i_uid,
> +				VFS_I(ip)->i_gid, fa->fsx_projid,
> +				XFS_QMOPT_PQUOTA, &udqp, NULL, &pdqp);
>  		if (code)
>  			return code;
>  	}
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index b818b261918f..a5b7c3100a2f 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -692,9 +692,7 @@ xfs_setattr_nonsize(
>  		 */
>  		ASSERT(udqp == NULL);
>  		ASSERT(gdqp == NULL);
> -		error = xfs_qm_vop_dqalloc(ip, xfs_kuid_to_uid(uid),
> -					   xfs_kgid_to_gid(gid),
> -					   ip->i_d.di_projid,
> +		error = xfs_qm_vop_dqalloc(ip, uid, gid, ip->i_d.di_projid,
>  					   qflags, &udqp, &gdqp, NULL);
>  		if (error)
>  			return error;
> @@ -763,7 +761,6 @@ xfs_setattr_nonsize(
>  				olddquot1 = xfs_qm_vop_chown(tp, ip,
>  							&ip->i_udquot, udqp);
>  			}
> -			ip->i_d.di_uid = xfs_kuid_to_uid(uid);
>  			inode->i_uid = uid;
>  		}
>  		if (!gid_eq(igid, gid)) {
> @@ -775,7 +772,6 @@ xfs_setattr_nonsize(
>  				olddquot2 = xfs_qm_vop_chown(tp, ip,
>  							&ip->i_gdquot, gdqp);
>  			}
> -			ip->i_d.di_gid = xfs_kgid_to_gid(gid);
>  			inode->i_gid = gid;
>  		}
>  	}
> diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
> index 4b31c29b7e6b..497db4160283 100644
> --- a/fs/xfs/xfs_itable.c
> +++ b/fs/xfs/xfs_itable.c
> @@ -86,8 +86,8 @@ xfs_bulkstat_one_int(
>  	 */
>  	buf->bs_projectid = ip->i_d.di_projid;
>  	buf->bs_ino = ino;
> -	buf->bs_uid = dic->di_uid;
> -	buf->bs_gid = dic->di_gid;
> +	buf->bs_uid = xfs_kuid_to_uid(inode->i_uid);
> +	buf->bs_gid = xfs_kgid_to_gid(inode->i_gid);
>  	buf->bs_size = dic->di_size;
> 
>  	buf->bs_nlink = inode->i_nlink;
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index 0b0909657bad..54dda7d982c9 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -326,16 +326,18 @@ xfs_qm_dqattach_locked(
>  	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
> 
>  	if (XFS_IS_UQUOTA_ON(mp) && !ip->i_udquot) {
> -		error = xfs_qm_dqattach_one(ip, ip->i_d.di_uid, XFS_DQ_USER,
> -				doalloc, &ip->i_udquot);
> +		error = xfs_qm_dqattach_one(ip,
> +				xfs_kuid_to_uid(VFS_I(ip)->i_uid),
> +				XFS_DQ_USER, doalloc, &ip->i_udquot);
>  		if (error)
>  			goto done;
>  		ASSERT(ip->i_udquot);
>  	}
> 
>  	if (XFS_IS_GQUOTA_ON(mp) && !ip->i_gdquot) {
> -		error = xfs_qm_dqattach_one(ip, ip->i_d.di_gid, XFS_DQ_GROUP,
> -				doalloc, &ip->i_gdquot);
> +		error = xfs_qm_dqattach_one(ip,
> +				xfs_kgid_to_gid(VFS_I(ip)->i_gid),
> +				XFS_DQ_GROUP, doalloc, &ip->i_gdquot);
>  		if (error)
>  			goto done;
>  		ASSERT(ip->i_gdquot);
> @@ -1613,8 +1615,8 @@ xfs_qm_dqfree_one(
>  int
>  xfs_qm_vop_dqalloc(
>  	struct xfs_inode	*ip,
> -	xfs_dqid_t		uid,
> -	xfs_dqid_t		gid,
> +	kuid_t			uid,
> +	kgid_t			gid,
>  	prid_t			prid,
>  	uint			flags,
>  	struct xfs_dquot	**O_udqpp,
> @@ -1622,6 +1624,7 @@ xfs_qm_vop_dqalloc(
>  	struct xfs_dquot	**O_pdqpp)
>  {
>  	struct xfs_mount	*mp = ip->i_mount;
> +	struct inode		*inode = VFS_I(ip);
>  	struct xfs_dquot	*uq = NULL;
>  	struct xfs_dquot	*gq = NULL;
>  	struct xfs_dquot	*pq = NULL;
> @@ -1635,7 +1638,7 @@ xfs_qm_vop_dqalloc(
>  	xfs_ilock(ip, lockflags);
> 
>  	if ((flags & XFS_QMOPT_INHERIT) && XFS_INHERIT_GID(ip))
> -		gid = ip->i_d.di_gid;
> +		gid = inode->i_gid;
> 
>  	/*
>  	 * Attach the dquot(s) to this inode, doing a dquot allocation
> @@ -1650,7 +1653,7 @@ xfs_qm_vop_dqalloc(
>  	}
> 
>  	if ((flags & XFS_QMOPT_UQUOTA) && XFS_IS_UQUOTA_ON(mp)) {
> -		if (ip->i_d.di_uid != uid) {
> +		if (!uid_eq(inode->i_uid, uid)) {
>  			/*
>  			 * What we need is the dquot that has this uid, and
>  			 * if we send the inode to dqget, the uid of the inode
> @@ -1661,7 +1664,8 @@ xfs_qm_vop_dqalloc(
>  			 * holding ilock.
>  			 */
>  			xfs_iunlock(ip, lockflags);
> -			error = xfs_qm_dqget(mp, uid, XFS_DQ_USER, true, &uq);
> +			error = xfs_qm_dqget(mp, xfs_kuid_to_uid(uid),
> +					XFS_DQ_USER, true, &uq);
>  			if (error) {
>  				ASSERT(error != -ENOENT);
>  				return error;
> @@ -1682,9 +1686,10 @@ xfs_qm_vop_dqalloc(
>  		}
>  	}
>  	if ((flags & XFS_QMOPT_GQUOTA) && XFS_IS_GQUOTA_ON(mp)) {
> -		if (ip->i_d.di_gid != gid) {
> +		if (!gid_eq(inode->i_gid, gid)) {
>  			xfs_iunlock(ip, lockflags);
> -			error = xfs_qm_dqget(mp, gid, XFS_DQ_GROUP, true, &gq);
> +			error = xfs_qm_dqget(mp, xfs_kgid_to_gid(gid),
> +					XFS_DQ_GROUP, true, &gq);
>  			if (error) {
>  				ASSERT(error != -ENOENT);
>  				goto error_rele;
> @@ -1810,7 +1815,8 @@ xfs_qm_vop_chown_reserve(
>  			XFS_QMOPT_RES_RTBLKS : XFS_QMOPT_RES_REGBLKS;
> 
>  	if (XFS_IS_UQUOTA_ON(mp) && udqp &&
> -	    ip->i_d.di_uid != be32_to_cpu(udqp->q_core.d_id)) {
> +	    xfs_kuid_to_uid(VFS_I(ip)->i_uid) !=
> +			be32_to_cpu(udqp->q_core.d_id)) {
>  		udq_delblks = udqp;
>  		/*
>  		 * If there are delayed allocation blocks, then we have to
> @@ -1823,7 +1829,8 @@ xfs_qm_vop_chown_reserve(
>  		}
>  	}
>  	if (XFS_IS_GQUOTA_ON(ip->i_mount) && gdqp &&
> -	    ip->i_d.di_gid != be32_to_cpu(gdqp->q_core.d_id)) {
> +	    xfs_kgid_to_gid(VFS_I(ip)->i_gid) !=
> +			be32_to_cpu(gdqp->q_core.d_id)) {
>  		gdq_delblks = gdqp;
>  		if (delblks) {
>  			ASSERT(ip->i_gdquot);
> @@ -1920,14 +1927,17 @@ xfs_qm_vop_create_dqattach(
> 
>  	if (udqp && XFS_IS_UQUOTA_ON(mp)) {
>  		ASSERT(ip->i_udquot == NULL);
> -		ASSERT(ip->i_d.di_uid == be32_to_cpu(udqp->q_core.d_id));
> +		ASSERT(xfs_kuid_to_uid(VFS_I(ip)->i_uid) ==
> +			be32_to_cpu(udqp->q_core.d_id));
> 
>  		ip->i_udquot = xfs_qm_dqhold(udqp);
>  		xfs_trans_mod_dquot(tp, udqp, XFS_TRANS_DQ_ICOUNT, 1);
>  	}
>  	if (gdqp && XFS_IS_GQUOTA_ON(mp)) {
>  		ASSERT(ip->i_gdquot == NULL);
> -		ASSERT(ip->i_d.di_gid == be32_to_cpu(gdqp->q_core.d_id));
> +		ASSERT(xfs_kgid_to_gid(VFS_I(ip)->i_gid) ==
> +			be32_to_cpu(gdqp->q_core.d_id));
> +
>  		ip->i_gdquot = xfs_qm_dqhold(gdqp);
>  		xfs_trans_mod_dquot(tp, gdqp, XFS_TRANS_DQ_ICOUNT, 1);
>  	}
> diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
> index efe42ae7a2f3..aa8fc1f55fbd 100644
> --- a/fs/xfs/xfs_quota.h
> +++ b/fs/xfs/xfs_quota.h
> @@ -86,7 +86,7 @@ extern int xfs_trans_reserve_quota_bydquots(struct xfs_trans *,
>  		struct xfs_mount *, struct xfs_dquot *,
>  		struct xfs_dquot *, struct xfs_dquot *, int64_t, long, uint);
> 
> -extern int xfs_qm_vop_dqalloc(struct xfs_inode *, xfs_dqid_t, xfs_dqid_t,
> +extern int xfs_qm_vop_dqalloc(struct xfs_inode *, kuid_t, kgid_t,
>  		prid_t, uint, struct xfs_dquot **, struct xfs_dquot **,
>  		struct xfs_dquot **);
>  extern void xfs_qm_vop_create_dqattach(struct xfs_trans *, struct xfs_inode *,
> @@ -109,7 +109,7 @@ extern void xfs_qm_unmount_quotas(struct xfs_mount *);
> 
>  #else
>  static inline int
> -xfs_qm_vop_dqalloc(struct xfs_inode *ip, xfs_dqid_t uid, xfs_dqid_t gid,
> +xfs_qm_vop_dqalloc(struct xfs_inode *ip, kuid_t kuid, kgid_t kgid,
>  		prid_t prid, uint flags, struct xfs_dquot **udqp,
>  		struct xfs_dquot **gdqp, struct xfs_dquot **pdqp)
>  {
> diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
> index d762d42ed0ff..ea42e25ec1bf 100644
> --- a/fs/xfs/xfs_symlink.c
> +++ b/fs/xfs/xfs_symlink.c
> @@ -182,9 +182,7 @@ xfs_symlink(
>  	/*
>  	 * Make sure that we have allocated dquot(s) on disk.
>  	 */
> -	error = xfs_qm_vop_dqalloc(dp,
> -			xfs_kuid_to_uid(current_fsuid()),
> -			xfs_kgid_to_gid(current_fsgid()), prid,
> +	error = xfs_qm_vop_dqalloc(dp, current_fsuid(), current_fsgid(), prid,
>  			XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT,
>  			&udqp, &gdqp, &pdqp);
>  	if (error)
> 


-- 
chandan



