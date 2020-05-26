Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A68621C0E70
	for <lists+linux-xfs@lfdr.de>; Fri,  1 May 2020 09:05:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728246AbgEAHFh (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 1 May 2020 03:05:37 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:13156 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726452AbgEAHFh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 May 2020 03:05:37 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04172FeP093046;
        Fri, 1 May 2020 03:05:34 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30r81esx41-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 May 2020 03:05:34 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 04172vKg095542;
        Fri, 1 May 2020 03:05:33 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30r81esx2s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 May 2020 03:05:33 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 04171MLv012209;
        Fri, 1 May 2020 07:05:31 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 30mcu7489m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 May 2020 07:05:31 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 04175SK963504582
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 1 May 2020 07:05:29 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CE6B911C064;
        Fri,  1 May 2020 07:05:28 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 74E0211C05B;
        Fri,  1 May 2020 07:05:27 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.85.72.180])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  1 May 2020 07:05:27 +0000 (GMT)
From:   Chandan Rajendra <chandan@linux.ibm.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Chandan Rajendra <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, bfoster@redhat.com
Subject: Re: [PATCH 2/2] xfs: Extend xattr extent counter to 32-bits
Date:   Fri, 01 May 2020 12:38:30 +0530
Message-ID: <1605922.TduNPZZDZ2@localhost.localdomain>
Organization: IBM
In-Reply-To: <2685908.IIZSzdRcA6@localhost.localdomain>
References: <20200404085203.1908-1-chandanrlinux@gmail.com> <20200426220805.GE2040@dread.disaster.area> <2685908.IIZSzdRcA6@localhost.localdomain>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-01_02:2020-04-30,2020-05-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 phishscore=0 malwarescore=0 adultscore=0 mlxlogscore=999 impostorscore=0
 lowpriorityscore=0 bulkscore=0 clxscore=1015 priorityscore=1501
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005010047
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wednesday, April 29, 2020 9:05 PM Chandan Rajendra wrote: 
> On Monday, April 27, 2020 3:38 AM Dave Chinner wrote: 
> > On Sat, Apr 25, 2020 at 05:37:39PM +0530, Chandan Rajendra wrote:
> > > On Thursday, April 23, 2020 4:00 AM Dave Chinner wrote: 
> > > > On Wed, Apr 22, 2020 at 03:08:00PM +0530, Chandan Rajendra wrote:
> > > > > Attr bmbt tree height (MINABTPTRS == 2)
> > > > > |-------+------------------------+-------------------------|
> > > > > | Level | Number of nodes/leaves |           Total Nr recs |
> > > > > |       |                        | (nr nodes/leaves * 125) |
> > > > > |-------+------------------------+-------------------------|
> > > > > |     0 |                      1 |                       2 |
> > > > > |     1 |                      2 |                     250 |
> > > > > |     2 |                    250 |                   31250 |
> > > > > |     3 |                  31250 |                 3906250 |
> > > > > |     4 |                3906250 |               488281250 |
> > > > > |     5 |              488281250 |             61035156250 |
> > > > > |-------+------------------------+-------------------------|
> > > > > 
> > > > > For xattr extents, (2 ** 32) - 1 = 4294967295 (~ 4 billion extents). So this
> > > > > will cause the corresponding bmbt's maximum height to go from 3 to 5.
> > > > > This probably won't cause any regression.
> > > > 
> > > > We already have the XFS_DA_NODE_MAXDEPTH set to 5, so changing the
> > > > attr fork extent count makes no difference to the attribute fork
> > > > bmbt reservations. i.e. the bmbt reservations are defined by the
> > > > dabtree structure limits, not the maximum extent count the fork can
> > > > hold.
> > > 
> > > I think the dabtree structure limits is because of the following ...
> > > 
> > > How many levels of dabtree would be needed to hold ~100 million xattrs?
> > > - name len = 16 bytes
> > >          struct xfs_parent_name_rec {
> > >                __be64  p_ino;
> > >                __be32  p_gen;
> > >                __be32  p_diroffset;
> > >        };
> > >   i.e. 64 + 32 + 32 = 128 bits = 16 bytes;
> > > - Value len = file name length = Assume ~40 bytes
> > 
> > That's quite long for a file name, but lets run with it...
> > 
> > > - Formula for number of node entries (used in column 3 in the table given
> > >   below) at any level of the dabtree,
> > >   nr_blocks * ((block size - sizeof(struct xfs_da3_node_hdr)) / sizeof(struct
> > >   xfs_da_node_entry))
> > >   i.e. nr_blocks * ((block size - 64) / 8)
> > > - Formula for number of leaf entries (used in column 4 in the table given
> > >   below),
> > >   (block size - sizeof(xfs_attr_leaf_hdr_t)) /
> > >   (sizeof(xfs_attr_leaf_entry_t) + valuelen + namelen + nameval)
> > >   i.e. nr_blocks * ((block size - 32) / (8 + 2 + 1 + 16 + 40))
> > > 
> > > Here I have assumed block size to be 4k.
> > > 
> > > |-------+------------------+--------------------------+--------------------------|
> > > | Level | Number of blocks | Number of entries (node) | Number of entries (leaf) |
> > > |-------+------------------+--------------------------+--------------------------|
> > > |     0 |              1.0 |                      5e2 |                    6.1e1 |
> > > |     1 |              5e2 |                    2.5e5 |                    3.0e4 |
> > > |     2 |            2.5e5 |                    1.3e8 |                    1.5e7 |
> > > |     3 |            1.3e8 |                   6.6e10 |                    7.9e9 |
> > > |-------+------------------+--------------------------+--------------------------|
> > 
> > I'm not sure what this table actually represents.
> > 
> > > 
> > > Hence we would need a tree of height 3.
> > > Total number of blocks = 1 + 5e2 + 2.5e5 + 1.3e8 = ~1.3e8
> > 
> > 130 million blocks to hold 100 million xattrs? That doesn't pass the
> > smell test.
> > 
> > I think you are trying to do these calculations from the wrong
> > direction.
> 
> You are right. Btrees grow in height by adding a new root
> node. Hence the btree space usage should be calculated in bottom-to-top
> direction.
> 
> > Calculate the number of leaf blocks needed to hold the
> > xattr data first, then work out the height of the pointer tree from
> > that. e.g:
> > 
> > If we need 100m xattrs, we need this many 100% full 4k blocks to
> > hold them all:
> > 
> > blocks	= 100m / entries per leaf
> > 	= 100m / 61
> > 	= 1.64m
> > 
> > and if we assume 37% for the least populated (because magic
> > split/merge number), multiply by 3, so blocks ~= 5m for 100m xattrs
> > in 4k blocks.
> > 
> > That makes a lot more sense. Now the tree itself:
> > 
> > ptrs per node ^ N = 5m
> > ptrs per node ^ (N-1) = 5m / 500 = 10k
> > ptrs per node ^ (N-2) = 10k / 500 = 200
> > ptrs per node ^ (N-3) = 200 / 500 = 1
> > 
> > So, N-3 = level 0, so we've got a tree of height 4 for 100m xattrs,
> > and the pointer tree requires ~12000 blocks which is noise compared
> > to the number of leaf blocks...
> > 
> > As for the bmbt, we've got ~5m extents worst case, which is
> > 
> > ptrs per node ^ N = 5m
> > ptrs per node ^ (N-1) = 5m / 125 = 40k
> > ptrs per node ^ (N-2) = 40k / 125 = 320
> > ptrs per node ^ (N-3) = 320 / 125 = 3
> > 
> > As 3 bmbt records should fit in the inode fork, we'd only need a 4
> > level bmbt tree to hold this, too. It's at the lower limit of a 4
> > level tree, but 100m xattrs is the extreme case we are talking about
> > here...
> > 
> > FWIW, repeat this with a directory data segment size of 32GB w/ 40
> > byte names, and the numbers aren't much different to a worst case
> > xattr tree of this shape. You'll see the reason for the dabtree
> > height being limited to 5, and that neither the directory structure
> > nor the xattr structure is anywhere near the 2^32 bit extent count
> > limit...
> 
> Directory segment size is 32 GB                                                                                                                                  
>   - Number of directory entries required for indexing 32GiB.
>     - 32GiB is divided into 4k data blocks. 
>     - Number of 4k blocks = 32GB / 4k = 8M
>     - Each 4k data block has,
>       - struct xfs_dir3_data_hdr = 64 bytes
>       - struct xfs_dir2_data_entry = 12 bytes (metadata) + 40 bytes (name)
>                                    = 52 bytes
>       - Number of 'struct xfs_dir2_data_entry' in a 4k block
>         (4096 - 64) / 52 = 78
>     - Number of 'struct xfs_dir2_data_entry' in 32-GiB space
>       8m * 78 = 654m
>   - Contents of a single dabtree leaf
>     - struct xfs_dir3_leaf_hdr = 64 bytes
>     - struct xfs_dir2_leaf_entry = 8 bytes
>     - Number of 'struct xfs_dir2_leaf_entry' = (4096 - 64) / 8 = 504
>     - 37% of 504 = 186 entries
>   - Contents of a single dabtree node
>     - struct xfs_da3_node_hdr = 64 bytes
>     - struct xfs_da_node_entry = 8 bytes
>     - Number of 'struct xfs_da_node_entry' = (4096 - 64) / 8 = 504
>   - Nr leaves
>     Level (N) = 654m / 186 = 3m leaves
>     Level (N-1) = 3m / 504 = 6k
>     Level (N-2) = 6k / 504 = 12
>     Level (N-3) = 12 / 504 = 1
>     Dabtree having 4 levels is sufficient.
> 
> Hence a dabtree with 5 levels should be more than enough to index a 32GiB
> directory segment containing directory entries with even shorter names.
> 
> Even with 5m extents (used in xattr tree example above) consumed by a da
> btree, this is still much less than the limit imposed by 2^32 (i.e. ~4
> billion) extents.
> 
> Hence the actual log space consumed for logging bmbt blocks is limited by the
> height of da btree.
> 
> My experiment with changing the values of MAXEXTNUM and MAXAEXTNUM to 2^47 and
> 2^32 respectively, gave me the following results,
> - For 1k block size, bmbt tree height increased by 3.
> - For 4k block size, bmbt tree height increased by 2.
> 
> This happens because xfs_bmap_compute_maxlevels() calculates the BMBT tree
> height by assuming that there will be MAXEXTNUM/MAXAEXTNUM worth of leaf
> entries in the worst case.
> 
> For Attr fork Bmbt , Do you think the calculation should be changed to
> consider the number of extents occupied by a dabtree holding > 100 million
> xattrs?
> 
> The new increase in Bmbt height in turn causes the static reservation values
> to increase. In the worst case, the maximum increase observed was 118k bytes
> (4k block size, reflink=0, tr_rename).
> 
> The experiment was executed after applying "xfsprogs: Fix log reservation
> calculation for xattr insert operation" patch
> (https://lore.kernel.org/linux-xfs/20200404085229.2034-2-chandanrlinux@gmail.com/)
> 
> I am attaching the output of "xfs_db -c logres <dev>" executed on the
> following configurations of the XFS filesystem.
> - -b size=1k -m reflink=0
> - -b size=1k -m rmapbt=1reflink=1
> - -b size=4k -m reflink=0
> - -b size=4k -m rmapbt=1reflink=1
> - -b size=1k -m crc=0
> - -b size=4k -m crc=0
> 
> I will go through the code which calculates the log reservations of the
> entries which have a drastic increase in their values.
> 

The highest increase (i.e. an increase of 118k) in log reservation was
associated with the rename operation,

STATIC uint
xfs_calc_rename_reservation(
        struct xfs_mount        *mp)
{
        return XFS_DQUOT_LOGRES(mp) +
                max((xfs_calc_inode_res(mp, 4) +
                     xfs_calc_buf_res(2 * XFS_DIROP_LOG_COUNT(mp),
                                      XFS_FSB_TO_B(mp, 1))),
                    (xfs_calc_buf_res(7, mp->m_sb.sb_sectsize) +
                     xfs_calc_buf_res(xfs_allocfree_log_count(mp, 3),
                                      XFS_FSB_TO_B(mp, 1))));
}

The first argument to max() contributes the highest value.

xfs_calc_inode_res(mp, 4) + xfs_calc_buf_res(2 * XFS_DIROP_LOG_COUNT(mp),XFS_FSB_TO_B(mp, 1))

The inode reservation part is a constant.

The number of blocks computed by the second operand of the '+' operator is,

2 * ((XFS_DA_NODE_MAXDEPTH + 2) + ((XFS_DA_NODE_MAXDEPTH + 2) * (bmbt_height - 1)))

= 2 * ((5 + 2) + ((5 + 2) * (bmbt_height - 1)))

When bmbt height is 5 (i.e. when using the original 2^31 extent count limit) this
evaluates to,

2 * ((5 + 2) + ((5 + 2) * (5 - 1)))
= 70 blocks

When bmbt height is 7 (i.e. when using the original 2^47 extent count limit) this
evaluates to,

2 * ((5 + 2) + ((5 + 2) * (7 - 1)))
= 98 blocks

However, I don't see any extraneous space reserved by the above calculation
that could be removed. Also, IMHO an increase by 118k is most likely not going
to introduce any bugs. I will execute xfstests to make sure that no
regressions get added.

-- 
chandan



