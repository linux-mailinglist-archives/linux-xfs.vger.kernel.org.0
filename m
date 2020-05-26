Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AA711B00CA
	for <lists+linux-xfs@lfdr.de>; Mon, 20 Apr 2020 06:36:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725815AbgDTEgD (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 20 Apr 2020 00:36:03 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:63536 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725710AbgDTEgC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Apr 2020 00:36:02 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03K4Y3FK123058
        for <linux-xfs@vger.kernel.org>; Mon, 20 Apr 2020 00:36:01 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30ggxnce6n-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Mon, 20 Apr 2020 00:36:01 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.ibm.com>;
        Mon, 20 Apr 2020 05:35:15 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 20 Apr 2020 05:35:12 +0100
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03K4Zttq55509034
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Apr 2020 04:35:55 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5C9844204C;
        Mon, 20 Apr 2020 04:35:55 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E1D4442045;
        Mon, 20 Apr 2020 04:35:53 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.85.68.184])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 20 Apr 2020 04:35:53 +0000 (GMT)
From:   Chandan Rajendra <chandan@linux.ibm.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Dave Chinner <david@fromorbit.com>,
        Chandan Rajendra <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, bfoster@redhat.com
Subject: Re: [PATCH 2/2] xfs: Extend xattr extent counter to 32-bits
Date:   Mon, 20 Apr 2020 10:08:58 +0530
Organization: IBM
In-Reply-To: <20200413185547.GF6749@magnolia>
References: <20200404085203.1908-1-chandanrlinux@gmail.com> <3077601.x7mL1aTcQV@localhost.localdomain> <20200413185547.GF6749@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-TM-AS-GCONF: 00
x-cbid: 20042004-0016-0000-0000-00000307B08F
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20042004-0017-0000-0000-0000336BC01E
Message-Id: <3846384.T6aiutkDcA@localhost.localdomain>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-20_01:2020-04-17,2020-04-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 suspectscore=1 lowpriorityscore=0 mlxlogscore=999 bulkscore=0
 priorityscore=1501 spamscore=0 malwarescore=0 adultscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004200039
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tuesday, April 14, 2020 12:25 AM Darrick J. Wong wrote: 
> On Sun, Apr 12, 2020 at 12:04:13PM +0530, Chandan Rajendra wrote:
> > On Friday, April 10, 2020 1:16 PM Chandan Rajendra wrote: 
> > > On Tuesday, April 7, 2020 6:50 AM Dave Chinner wrote: 
> > > > On Sat, Apr 04, 2020 at 02:22:03PM +0530, Chandan Rajendra wrote:
> > > > > XFS has a per-inode xattr extent counter which is 16 bits wide. A workload
> > > > > which
> > > > > 1. Creates 1,000,000 255-byte sized xattrs,
> > > > > 2. Deletes 50% of these xattrs in an alternating manner,
> > > > > 3. Tries to create 400,000 new 255-byte sized xattrs
> > > > > causes the following message to be printed on the console,
> > > > > 
> > > > > XFS (loop0): xfs_iflush_int: detected corrupt incore inode 131, total extents = -19916, nblocks = 102937, ptr ffff9ce33b098c00
> > > > > XFS (loop0): xfs_do_force_shutdown(0x8) called from line 3739 of file fs/xfs/xfs_inode.c. Return address = ffffffffa4a94173
> > > > > 
> > > > > This indicates that we overflowed the 16-bits wide xattr extent counter.
> > > > > 
> > > > > I have been informed that there are instances where a single file has
> > > > >  > 100 million hardlinks. With parent pointers being stored in xattr,
> > > > > we will overflow the 16-bits wide xattr extent counter when large
> > > > > number of hardlinks are created.
> > > > > 
> > > > > Hence this commit extends xattr extent counter to 32-bits. It also introduces
> > > > > an incompat flag to prevent older kernels from mounting newer filesystems with
> > > > > 32-bit wide xattr extent counter.
> > > > > 
> > > > > Signed-off-by: Chandan Rajendra <chandanrlinux@gmail.com>
> > > > > ---
> > > > >  fs/xfs/libxfs/xfs_format.h     | 28 +++++++++++++++++++++-------
> > > > >  fs/xfs/libxfs/xfs_inode_buf.c  | 27 +++++++++++++++++++--------
> > > > >  fs/xfs/libxfs/xfs_inode_fork.c |  3 ++-
> > > > >  fs/xfs/libxfs/xfs_log_format.h |  5 +++--
> > > > >  fs/xfs/libxfs/xfs_types.h      |  4 ++--
> > > > >  fs/xfs/scrub/inode.c           |  7 ++++---
> > > > >  fs/xfs/xfs_inode_item.c        |  3 ++-
> > > > >  fs/xfs/xfs_log_recover.c       | 13 ++++++++++---
> > > > >  8 files changed, 63 insertions(+), 27 deletions(-)
> > > > > 
> > > > > diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> > > > > index 045556e78ee2c..0a4266b0d46e1 100644
> > > > > --- a/fs/xfs/libxfs/xfs_format.h
> > > > > +++ b/fs/xfs/libxfs/xfs_format.h
> > > > > @@ -465,10 +465,12 @@ xfs_sb_has_ro_compat_feature(
> > > > >  #define XFS_SB_FEAT_INCOMPAT_FTYPE	(1 << 0)	/* filetype in dirent */
> > > > >  #define XFS_SB_FEAT_INCOMPAT_SPINODES	(1 << 1)	/* sparse inode chunks */
> > > > >  #define XFS_SB_FEAT_INCOMPAT_META_UUID	(1 << 2)	/* metadata UUID */
> > > > > +#define XFS_SB_FEAT_INCOMPAT_32BIT_AEXT_CNTR (1 << 3)
> > > > >  #define XFS_SB_FEAT_INCOMPAT_ALL \
> > > > >  		(XFS_SB_FEAT_INCOMPAT_FTYPE|	\
> > > > >  		 XFS_SB_FEAT_INCOMPAT_SPINODES|	\
> > > > > -		 XFS_SB_FEAT_INCOMPAT_META_UUID)
> > > > > +		 XFS_SB_FEAT_INCOMPAT_META_UUID| \
> > > > > +		 XFS_SB_FEAT_INCOMPAT_32BIT_AEXT_CNTR)
> > > > >  
> > > > >  #define XFS_SB_FEAT_INCOMPAT_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_ALL
> > > > >  static inline bool
> > > > > @@ -874,7 +876,7 @@ typedef struct xfs_dinode {
> > > > >  	__be64		di_nblocks;	/* # of direct & btree blocks used */
> > > > >  	__be32		di_extsize;	/* basic/minimum extent size for file */
> > > > >  	__be32		di_nextents;	/* number of extents in data fork */
> > > > > -	__be16		di_anextents;	/* number of extents in attribute fork*/
> > > > > +	__be16		di_anextents_lo;/* lower part of xattr extent count */
> > > > >  	__u8		di_forkoff;	/* attr fork offs, <<3 for 64b align */
> > > > >  	__s8		di_aformat;	/* format of attr fork's data */
> > > > >  	__be32		di_dmevmask;	/* DMIG event mask */
> > > > > @@ -891,7 +893,8 @@ typedef struct xfs_dinode {
> > > > >  	__be64		di_lsn;		/* flush sequence */
> > > > >  	__be64		di_flags2;	/* more random flags */
> > > > >  	__be32		di_cowextsize;	/* basic cow extent size for file */
> > > > > -	__u8		di_pad2[12];	/* more padding for future expansion */
> > > > > +	__be16		di_anextents_hi;/* higher part of xattr extent count */
> > > > > +	__u8		di_pad2[10];	/* more padding for future expansion */
> > > > 
> > > > Ok, I think you've limited what we can do here by using this "fill
> > > > holes" variable split. I've never liked doing this, and we've only
> > > > done it in the past when we haven't had space in the inode to create
> > > > a new 32 bit variable.
> > > > 
> > > > IOWs, this is a v5 format feature only, so we should just create a
> > > > new variable:
> > > > 
> > > > 	__be32		di_attr_nextents;
> > > > 
> > > > With that in place, we can now do what we did extending the v1 inode
> > > > link count (16 bits) to the v2 inode link count (32 bits).
> > > > 
> > > > That is, when the attribute count is going to overflow, we set a
> > > > inode flag on disk to indicate that it now has a 32 bit extent count
> > > > and uses that field in the inode, and we set a RO-compat feature
> > > > flag in the superblock to indicate that there are 32 bit attr fork
> > > > extent counts in use.
> > > > 
> > > > Old kernels can still read the filesystem, but see the extent count
> > > > as "max" (65535) but can't modify the attr fork and hence corrupt
> > > > the 32 bit count it knows nothing about.
> > > > 
> > > > If the kernel sees the RO feature bit set, it can set the inode flag
> > > > on inodes it is modifying and update both the old and new counters
> > > > appropriately when flushing the inode to disk (i.e. transparent
> > > > conversion).
> > > > 
> > > > In future, mkfs can then set the RO feature flag by default so all
> > > > new filesystems use the 32 bit counter.
> > > > 
> > > > >  	/* fields only written to during inode creation */
> > > > >  	xfs_timestamp_t	di_crtime;	/* time created */
> > > > > @@ -993,10 +996,21 @@ enum xfs_dinode_fmt {
> > > > >  	((w) == XFS_DATA_FORK ? \
> > > > >  		(dip)->di_format : \
> > > > >  		(dip)->di_aformat)
> > > > > -#define XFS_DFORK_NEXTENTS(dip,w) \
> > > > > -	((w) == XFS_DATA_FORK ? \
> > > > > -		be32_to_cpu((dip)->di_nextents) : \
> > > > > -		be16_to_cpu((dip)->di_anextents))
> > > > > +
> > > > > +static inline int32_t XFS_DFORK_NEXTENTS(struct xfs_sb *sbp,
> > > > 
> > > > If you are converting a macro to static inline, then all the caller
> > > > sites should be converted to lower case at the same time.
> > > > 
> > > > > +					struct xfs_dinode *dip, int whichfork)
> > > > > +{
> > > > > +	int32_t anextents;
> > > > 
> > > > Extent counts should be unsigned, as they are on disk.
> > > > 
> > > > > +
> > > > > +	if (whichfork == XFS_DATA_FORK)
> > > > > +		return be32_to_cpu((dip)->di_nextents);
> > > > > +
> > > > > +	anextents = be16_to_cpu((dip)->di_anextents_lo);
> > > > > +	if (xfs_sb_version_has_v3inode(sbp))
> > > > > +		anextents |= ((u32)(be16_to_cpu((dip)->di_anextents_hi)) << 16);
> > > > > +
> > > > > +	return anextents;
> > > > > +}
> > > > 
> > > > No feature bit to indicate that 32 bit attribute extent counts are
> > > > valid?
> > > > 
> > > > >  
> > > > >  /*
> > > > >   * For block and character special files the 32bit dev_t is stored at the
> > > > > diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> > > > > index 39c5a6e24915c..ced8195bd8c22 100644
> > > > > --- a/fs/xfs/libxfs/xfs_inode_buf.c
> > > > > +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> > > > > @@ -232,7 +232,8 @@ xfs_inode_from_disk(
> > > > >  	to->di_nblocks = be64_to_cpu(from->di_nblocks);
> > > > >  	to->di_extsize = be32_to_cpu(from->di_extsize);
> > > > >  	to->di_nextents = be32_to_cpu(from->di_nextents);
> > > > > -	to->di_anextents = be16_to_cpu(from->di_anextents);
> > > > > +	to->di_anextents = XFS_DFORK_NEXTENTS(&ip->i_mount->m_sb, from,
> > > > > +				XFS_ATTR_FORK);
> > > > 
> > > > This should open code, but I'd prefer a compeltely separate
> > > > variable...
> > > > 
> > > > >  	to->di_forkoff = from->di_forkoff;
> > > > >  	to->di_aformat	= from->di_aformat;
> > > > >  	to->di_dmevmask	= be32_to_cpu(from->di_dmevmask);
> > > > > @@ -282,7 +283,7 @@ xfs_inode_to_disk(
> > > > >  	to->di_nblocks = cpu_to_be64(from->di_nblocks);
> > > > >  	to->di_extsize = cpu_to_be32(from->di_extsize);
> > > > >  	to->di_nextents = cpu_to_be32(from->di_nextents);
> > > > > -	to->di_anextents = cpu_to_be16(from->di_anextents);
> > > > > +	to->di_anextents_lo = cpu_to_be16((u32)(from->di_anextents) & 0xffff);
> > > > >  	to->di_forkoff = from->di_forkoff;
> > > > >  	to->di_aformat = from->di_aformat;
> > > > >  	to->di_dmevmask = cpu_to_be32(from->di_dmevmask);
> > > > > @@ -296,6 +297,8 @@ xfs_inode_to_disk(
> > > > >  		to->di_crtime.t_nsec = cpu_to_be32(from->di_crtime.tv_nsec);
> > > > >  		to->di_flags2 = cpu_to_be64(from->di_flags2);
> > > > >  		to->di_cowextsize = cpu_to_be32(from->di_cowextsize);
> > > > > +		to->di_anextents_hi
> > > > > +			= cpu_to_be16((u32)(from->di_anextents) >> 16);
> > > > 
> > > > Again, feature bit for on-disk format modifications needed...
> > > > 
> > > > >  		to->di_ino = cpu_to_be64(ip->i_ino);
> > > > >  		to->di_lsn = cpu_to_be64(lsn);
> > > > >  		memset(to->di_pad2, 0, sizeof(to->di_pad2));
> > > > > @@ -335,7 +338,7 @@ xfs_log_dinode_to_disk(
> > > > >  	to->di_nblocks = cpu_to_be64(from->di_nblocks);
> > > > >  	to->di_extsize = cpu_to_be32(from->di_extsize);
> > > > >  	to->di_nextents = cpu_to_be32(from->di_nextents);
> > > > > -	to->di_anextents = cpu_to_be16(from->di_anextents);
> > > > > +	to->di_anextents_lo = cpu_to_be16(from->di_anextents_lo);
> > > > >  	to->di_forkoff = from->di_forkoff;
> > > > >  	to->di_aformat = from->di_aformat;
> > > > >  	to->di_dmevmask = cpu_to_be32(from->di_dmevmask);
> > > > > @@ -349,6 +352,7 @@ xfs_log_dinode_to_disk(
> > > > >  		to->di_crtime.t_nsec = cpu_to_be32(from->di_crtime.t_nsec);
> > > > >  		to->di_flags2 = cpu_to_be64(from->di_flags2);
> > > > >  		to->di_cowextsize = cpu_to_be32(from->di_cowextsize);
> > > > > +		to->di_anextents_hi = cpu_to_be16(from->di_anextents_hi);
> > > > >  		to->di_ino = cpu_to_be64(from->di_ino);
> > > > >  		to->di_lsn = cpu_to_be64(from->di_lsn);
> > > > >  		memcpy(to->di_pad2, from->di_pad2, sizeof(to->di_pad2));
> > > > > @@ -365,7 +369,9 @@ xfs_dinode_verify_fork(
> > > > >  	struct xfs_mount	*mp,
> > > > >  	int			whichfork)
> > > > >  {
> > > > > -	uint32_t		di_nextents = XFS_DFORK_NEXTENTS(dip, whichfork);
> > > > > +	uint32_t		di_nextents;
> > > > > +
> > > > > +	di_nextents = XFS_DFORK_NEXTENTS(&mp->m_sb, dip, whichfork);
> > > > >  
> > > > >  	switch (XFS_DFORK_FORMAT(dip, whichfork)) {
> > > > >  	case XFS_DINODE_FMT_LOCAL:
> > > > > @@ -436,6 +442,9 @@ xfs_dinode_verify(
> > > > >  	uint16_t		flags;
> > > > >  	uint64_t		flags2;
> > > > >  	uint64_t		di_size;
> > > > > +	int32_t			nextents;
> > > > > +	int32_t			anextents;
> > > > > +	int64_t			nblocks;
> > > > 
> > > > Extent counts need to be converted to unsigned in memory - they are
> > > > unsigned on disk....
> > > 
> > > In the current code, we have,
> > > 
> > > #define MAXEXTNUM       ((xfs_extnum_t)0x7fffffff)      /* signed int */                                                                                                      
> > > #define MAXAEXTNUM      ((xfs_aextnum_t)0x7fff)         /* signed short */
> > > 
> > > i.e. the maximum allowed data extent counter and xattr extent counter are
> > > maximum possible values w.r.t signed int and signed short.
> > > 
> > > Can you please explain as to why signed maximum values were considered when
> > > the corresponding on-disk data types are unsigned?
> > > 
> > > 
> > 
> > Ok. So the reason I asked that question was because I was wondering if
> > changing the maximum number of extents for data and attr would cause a change
> > the height of the corresponding bmbt trees (which in-turn could change the log
> > reservation values). The following calculations prove otherwise,
> > 
> > - 5 levels deep data bmbt tree.
> >   |-------+------------------------+-------------------------------|
> >   | level | number of nodes/leaves | Total Nr recs                 |
> >   |-------+------------------------+-------------------------------|
> >   |     0 |                      1 | 3 (max root recs)             |
> >   |     1 |                      3 | 125 * 3 = 375                 |
> >   |     2 |                    375 | 125 * 375 = 46875             |
> >   |     3 |                  46875 | 125 * 46875 = 5859375         |
> >   |     4 |                5859375 | 125 * 5859375 = 732421875     |
> >   |     5 |              732421875 | 125 * 732421875 = 91552734375 |
> >   |-------+------------------------+-------------------------------|
> > 
> > - 3 levels deep attr bmbt tree.
> >   |-------+------------------------+-----------------------|
> >   | level | number of nodes/leaves | Total Nr recs         |
> >   |-------+------------------------+-----------------------|
> >   |     0 |                      1 | 2 (max root recs)     |
> >   |     1 |                      2 | 125 * 2 = 250         |
> >   |     2 |                    250 | 125 * 250 = 31250     |
> >   |     3 |                  31250 | 125 * 31250 = 3906250 |
> >   |-------+------------------------+-----------------------|
> > 
> > - Data type to number of records
> >   |-----------+-------------+-----------------|
> >   | data type | max extents | max leaf blocks |
> >   |-----------+-------------+-----------------|
> >   | int32     |  2147483647 |        17179870 |
> >   | uint32    |  4294967295 |        34359739 |
> >   | int16     |       32767 |             263 |
> >   | uint16    |       65535 |             525 |                                                                                                                  
> >   |-----------+-------------+-----------------|
> > 
> > So data bmbt will still have a height of 5 and attr bmbt will continue to have
> > a height of 3.
> 
> I think extent count variables should be unsigned because there's no
> meaning for a negative extent count.  ("You have -3 extents." "Ehh???")
> 
> That said, it was very helpful to point out that the current MAXEXTNUM /
> MAXAEXTNUM symbols stop short of using all 32 (or 16) bits.
> 
> Can we use this new feature flag + inode flag to allow 4294967295
> extents in either fork?

Sure.

I have already tested that having 4294967295 as the maximum data extent count
does not cause any regressions.

Also, Dave was of the opinion that data extent counter be increased to
64-bit. I think I should include that change along with this feature flag
rather than adding a new one in the near future.

-- 
chandan



