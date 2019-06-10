Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D4EC3BA40
	for <lists+linux-xfs@lfdr.de>; Mon, 10 Jun 2019 18:59:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728164AbfFJQ7s (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 10 Jun 2019 12:59:48 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:60772 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727648AbfFJQ7s (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Jun 2019 12:59:48 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5AGx5at032942;
        Mon, 10 Jun 2019 16:59:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=rjuG86FmP43l6ZRWViJaACPS84tzAxyuz4Hy84qcvrs=;
 b=ivNBue9iRjaMXWfblQDbOKIjEXy4+r88tTy6frbbjHqilkFy7Pfq0a4ORvvY55YV2szq
 3iQfHFfSb4mesP1y0OXIJGOXX8ngIhDmtMh4ODm2ib9gjZALs5BJBPGHa/4XFzPdg22J
 RRkR+g48tmEA8qAhPsuYxY3y45MHapYZAYYIgEnSmdRB1l0YZDYgtk4P2T8m8kXZu/yZ
 fWVCGr2Q0s7IwLAOOViFbZNqNpSAh/l2pGdpLQHNCTaGLOXt02Td77Z4o70hh27kWYYV
 N6S3ghuAKoR3ZuxSkBeyMh8+aFa561aG3mevJwD/2EZbReU9nQQzbMDCGclBM6LbtUEW 6w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2t04etg4k4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Jun 2019 16:59:17 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5AGwtca149364;
        Mon, 10 Jun 2019 16:59:17 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2t1jpgyp5q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Jun 2019 16:59:16 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5AGxFEi025347;
        Mon, 10 Jun 2019 16:59:15 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 10 Jun 2019 09:59:15 -0700
Date:   Mon, 10 Jun 2019 09:59:09 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/10] xfs: create simplified inode walk function
Message-ID: <20190610165909.GI1871505@magnolia>
References: <155968496814.1657646.13743491598480818627.stgit@magnolia>
 <155968497450.1657646.15305138327955918345.stgit@magnolia>
 <20190610135816.GA6473@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190610135816.GA6473@bfoster>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9284 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906100115
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9284 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906100116
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 10, 2019 at 09:58:19AM -0400, Brian Foster wrote:
> On Tue, Jun 04, 2019 at 02:49:34PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Create a new iterator function to simplify walking inodes in an XFS
> > filesystem.  This new iterator will replace the existing open-coded
> > walking that goes on in various places.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/Makefile                  |    1 
> >  fs/xfs/libxfs/xfs_ialloc_btree.c |   31 +++
> >  fs/xfs/libxfs/xfs_ialloc_btree.h |    3 
> >  fs/xfs/xfs_itable.c              |    5 
> >  fs/xfs/xfs_itable.h              |    8 +
> >  fs/xfs/xfs_iwalk.c               |  400 ++++++++++++++++++++++++++++++++++++++
> >  fs/xfs/xfs_iwalk.h               |   18 ++
> >  fs/xfs/xfs_trace.h               |   40 ++++
> >  8 files changed, 502 insertions(+), 4 deletions(-)
> >  create mode 100644 fs/xfs/xfs_iwalk.c
> >  create mode 100644 fs/xfs/xfs_iwalk.h
> > 
> > 
> ...
> > diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
> > index ac4b65da4c2b..cb7eac2f51c0 100644
> > --- a/fs/xfs/libxfs/xfs_ialloc_btree.c
> > +++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
> > @@ -564,6 +564,34 @@ xfs_inobt_max_size(
> >  					XFS_INODES_PER_CHUNK);
> >  }
> >  
> > +/* Read AGI and create inobt cursor. */
> > +int
> > +xfs_inobt_cur(
> > +	struct xfs_mount	*mp,
> > +	struct xfs_trans	*tp,
> > +	xfs_agnumber_t		agno,
> > +	struct xfs_btree_cur	**curpp,
> > +	struct xfs_buf		**agi_bpp)
> > +{
> > +	struct xfs_btree_cur	*cur;
> > +	int			error;
> > +
> > +	ASSERT(*agi_bpp == NULL);
> > +
> 
> FYI, the xfs_inobt_count_blocks() caller doesn't initialize the pointer
> according to the assert.

AgAGkgjwepth, there's a gcc plugin that makes all uninitialized stack
variables zero now, and so I never see these things anymore. :(

Thanks for catching this.

> 
> > +	error = xfs_ialloc_read_agi(mp, tp, agno, agi_bpp);
> > +	if (error)
> > +		return error;
> > +
> > +	cur = xfs_inobt_init_cursor(mp, tp, *agi_bpp, agno, XFS_BTNUM_INO);
> > +	if (!cur) {
> > +		xfs_trans_brelse(tp, *agi_bpp);
> > +		*agi_bpp = NULL;
> > +		return -ENOMEM;
> > +	}
> > +	*curpp = cur;
> > +	return 0;
> > +}
> > +
> >  static int
> >  xfs_inobt_count_blocks(
> >  	struct xfs_mount	*mp,
> ...
> > diff --git a/fs/xfs/xfs_iwalk.c b/fs/xfs/xfs_iwalk.c
> > new file mode 100644
> > index 000000000000..3e6c06e69c75
> > --- /dev/null
> > +++ b/fs/xfs/xfs_iwalk.c
> > @@ -0,0 +1,400 @@
> ...
> > +/* Walk all inodes in a single AG, from @iwag->startino to the end of the AG. */
> > +STATIC int
> > +xfs_iwalk_ag(
> > +	struct xfs_iwalk_ag		*iwag)
> > +{
> > +	struct xfs_mount		*mp = iwag->mp;
> > +	struct xfs_trans		*tp = iwag->tp;
> > +	struct xfs_buf			*agi_bp = NULL;
> > +	struct xfs_btree_cur		*cur = NULL;
> > +	xfs_agnumber_t			agno;
> > +	xfs_agino_t			agino;
> > +	int				has_more;
> > +	int				error = 0;
> > +
> > +	/* Set up our cursor at the right place in the inode btree. */
> > +	agno = XFS_INO_TO_AGNO(mp, iwag->startino);
> > +	agino = XFS_INO_TO_AGINO(mp, iwag->startino);
> > +	error = xfs_iwalk_ag_start(iwag, agno, agino, &cur, &agi_bp, &has_more);
> > +
> > +	while (!error && has_more) {
> > +		struct xfs_inobt_rec_incore	*irec;
> > +
> > +		cond_resched();
> > +
> > +		/* Fetch the inobt record. */
> > +		irec = &iwag->recs[iwag->nr_recs];
> > +		error = xfs_inobt_get_rec(cur, irec, &has_more);
> > +		if (error || !has_more)
> > +			break;
> > +
> > +		/* No allocated inodes in this chunk; skip it. */
> > +		if (irec->ir_freecount == irec->ir_count) {
> > +			error = xfs_btree_increment(cur, 0, &has_more);
> > +			if (error)
> > +				break;
> > +			continue;
> > +		}
> > +
> > +		/*
> > +		 * Start readahead for this inode chunk in anticipation of
> > +		 * walking the inodes.
> > +		 */
> > +		xfs_bulkstat_ichunk_ra(mp, agno, irec);
> > +
> > +		/*
> > +		 * If there's space in the buffer for more records, increment
> > +		 * the btree cursor and grab more.
> > +		 */
> > +		if (++iwag->nr_recs < iwag->sz_recs) {
> > +			error = xfs_btree_increment(cur, 0, &has_more);
> > +			if (error || !has_more)
> > +				break;
> > +			continue;
> > +		}
> > +
> > +		/*
> > +		 * Otherwise, we need to save cursor state and run the callback
> > +		 * function on the cached records.  The run_callbacks function
> > +		 * is supposed to return a cursor pointing to the record where
> > +		 * we would be if we had been able to increment like above.
> > +		 */
> > +		error = xfs_iwalk_run_callbacks(iwag, xfs_iwalk_ag_recs, agno,
> > +				&cur, &agi_bp, &has_more);
> > +	}
> > +
> > +	xfs_iwalk_del_inobt(tp, &cur, &agi_bp, error);
> > +
> > +	/* Walk any records left behind in the cache. */
> > +	if (iwag->nr_recs == 0 || error)
> > +		return error;
> > +
> > +	return xfs_iwalk_ag_recs(iwag);
> 
> Hmm, I find the above pattern to process the leftover records a bit
> confusing because of how it is open coded. Could we find a way to reuse
> xfs_iwalk_run_callbacks() in both cases so it looks more obvious? For
> example, pass a flag to indicate whether the callback helper should
> recreate the cursor for continued processing. FWIW, it looks like
> has_more already reflects that state in the current logic above.

Yeah, I think this can be done without making the function too
incohesive.

> > +}
> > +
> > +/*
> > + * Given the number of inodes to prefetch, set the number of inobt records that
> > + * we cache in memory, which controls the number of inodes we try to read
> > + * ahead.
> > + *
> > + * If no max prefetch was given, default to 4096 bytes' worth of inobt records;
> > + * this should be plenty of inodes to read ahead.  This number (256 inobt
> > + * records) was chosen so that the cache is never more than a single memory
> > + * page.
> > + */
> > +static inline void
> > +xfs_iwalk_set_prefetch(
> > +	struct xfs_iwalk_ag	*iwag,
> > +	unsigned int		max_prefetch)
> > +{
> > +	if (max_prefetch)
> > +		iwag->sz_recs = round_up(max_prefetch, XFS_INODES_PER_CHUNK) /
> > +					XFS_INODES_PER_CHUNK;
> > +	else
> > +		iwag->sz_recs = 4096 / sizeof(struct xfs_inobt_rec_incore);
> > +
> 
> Perhaps this should use PAGE_SIZE or a related macro?

It did in the previous revision, but Dave pointed out that sz_recs then
becomes quite large on a system with 64k pages...

65536 bytes / 16 bytes per inobt record = 4096 records
4096 records * 64 inodes per record = 262144 inodes
262144 inodes * 512 bytes per inode = 128MB of inode readahead

I could extend the comment to explain why we don't use PAGE_SIZE...

/*
 * Note: We hardcode 4096 here (instead of, say, PAGE_SIZE) because we want to
 * constrain the amount of inode readahead to 16k inodes regardless of CPU:
 *
 * 4096 bytes / 16 bytes per inobt record = 256 inobt records
 * 256 inobt records * 64 inodes per record = 16384 inodes
 * 16384 inodes * 512 bytes per inode(?) = 8MB of inode readahead
 */

--D

> Brian
> 
> > +	/*
> > +	 * Allocate enough space to prefetch at least two records so that we
> > +	 * can cache both the inobt record where the iwalk started and the next
> > +	 * record.  This simplifies the AG inode walk loop setup code.
> > +	 */
> > +	iwag->sz_recs = max_t(unsigned int, iwag->sz_recs, 2);
> > +}
> > +
> > +/*
> > + * Walk all inodes in the filesystem starting from @startino.  The @iwalk_fn
> > + * will be called for each allocated inode, being passed the inode's number and
> > + * @data.  @max_prefetch controls how many inobt records' worth of inodes we
> > + * try to readahead.
> > + */
> > +int
> > +xfs_iwalk(
> > +	struct xfs_mount	*mp,
> > +	struct xfs_trans	*tp,
> > +	xfs_ino_t		startino,
> > +	xfs_iwalk_fn		iwalk_fn,
> > +	unsigned int		max_prefetch,
> > +	void			*data)
> > +{
> > +	struct xfs_iwalk_ag	iwag = {
> > +		.mp		= mp,
> > +		.tp		= tp,
> > +		.iwalk_fn	= iwalk_fn,
> > +		.data		= data,
> > +		.startino	= startino,
> > +	};
> > +	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, startino);
> > +	int			error;
> > +
> > +	ASSERT(agno < mp->m_sb.sb_agcount);
> > +
> > +	xfs_iwalk_set_prefetch(&iwag, max_prefetch);
> > +	error = xfs_iwalk_alloc(&iwag);
> > +	if (error)
> > +		return error;
> > +
> > +	for (; agno < mp->m_sb.sb_agcount; agno++) {
> > +		error = xfs_iwalk_ag(&iwag);
> > +		if (error)
> > +			break;
> > +		iwag.startino = XFS_AGINO_TO_INO(mp, agno + 1, 0);
> > +	}
> > +
> > +	xfs_iwalk_free(&iwag);
> > +	return error;
> > +}
> > diff --git a/fs/xfs/xfs_iwalk.h b/fs/xfs/xfs_iwalk.h
> > new file mode 100644
> > index 000000000000..45b1baabcd2d
> > --- /dev/null
> > +++ b/fs/xfs/xfs_iwalk.h
> > @@ -0,0 +1,18 @@
> > +// SPDX-License-Identifier: GPL-2.0+
> > +/*
> > + * Copyright (C) 2019 Oracle.  All Rights Reserved.
> > + * Author: Darrick J. Wong <darrick.wong@oracle.com>
> > + */
> > +#ifndef __XFS_IWALK_H__
> > +#define __XFS_IWALK_H__
> > +
> > +/* Walk all inodes in the filesystem starting from @startino. */
> > +typedef int (*xfs_iwalk_fn)(struct xfs_mount *mp, struct xfs_trans *tp,
> > +			    xfs_ino_t ino, void *data);
> > +/* Return value (for xfs_iwalk_fn) that aborts the walk immediately. */
> > +#define XFS_IWALK_ABORT	(1)
> > +
> > +int xfs_iwalk(struct xfs_mount *mp, struct xfs_trans *tp, xfs_ino_t startino,
> > +		xfs_iwalk_fn iwalk_fn, unsigned int max_prefetch, void *data);
> > +
> > +#endif /* __XFS_IWALK_H__ */
> > diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> > index 2464ea351f83..f9bb1d50bc0e 100644
> > --- a/fs/xfs/xfs_trace.h
> > +++ b/fs/xfs/xfs_trace.h
> > @@ -3516,6 +3516,46 @@ DEFINE_EVENT(xfs_inode_corrupt_class, name,	\
> >  DEFINE_INODE_CORRUPT_EVENT(xfs_inode_mark_sick);
> >  DEFINE_INODE_CORRUPT_EVENT(xfs_inode_mark_healthy);
> >  
> > +TRACE_EVENT(xfs_iwalk_ag,
> > +	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
> > +		 xfs_agino_t startino),
> > +	TP_ARGS(mp, agno, startino),
> > +	TP_STRUCT__entry(
> > +		__field(dev_t, dev)
> > +		__field(xfs_agnumber_t, agno)
> > +		__field(xfs_agino_t, startino)
> > +	),
> > +	TP_fast_assign(
> > +		__entry->dev = mp->m_super->s_dev;
> > +		__entry->agno = agno;
> > +		__entry->startino = startino;
> > +	),
> > +	TP_printk("dev %d:%d agno %d startino %u",
> > +		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->agno,
> > +		  __entry->startino)
> > +)
> > +
> > +TRACE_EVENT(xfs_iwalk_ag_rec,
> > +	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
> > +		 struct xfs_inobt_rec_incore *irec),
> > +	TP_ARGS(mp, agno, irec),
> > +	TP_STRUCT__entry(
> > +		__field(dev_t, dev)
> > +		__field(xfs_agnumber_t, agno)
> > +		__field(xfs_agino_t, startino)
> > +		__field(uint64_t, freemask)
> > +	),
> > +	TP_fast_assign(
> > +		__entry->dev = mp->m_super->s_dev;
> > +		__entry->agno = agno;
> > +		__entry->startino = irec->ir_startino;
> > +		__entry->freemask = irec->ir_free;
> > +	),
> > +	TP_printk("dev %d:%d agno %d startino %u freemask 0x%llx",
> > +		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->agno,
> > +		  __entry->startino, __entry->freemask)
> > +)
> > +
> >  #endif /* _TRACE_XFS_H */
> >  
> >  #undef TRACE_INCLUDE_PATH
> > 
