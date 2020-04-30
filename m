Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D8011C0489
	for <lists+linux-xfs@lfdr.de>; Thu, 30 Apr 2020 20:18:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbgD3SSk (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 30 Apr 2020 14:18:40 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:56630 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726355AbgD3SSk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Apr 2020 14:18:40 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03UHwsVd063622;
        Thu, 30 Apr 2020 18:18:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2020-01-29;
 bh=AFk98aXqfjqnRzsoxI4FkmWCxhi0PdevDGivQTgVS9M=;
 b=iND3gm2PHEVZ3QJTJTpmSJzqzhhkMb/R+nmXk69M7spIJJFafqpLyNqBfR5UpNgUUCax
 /UxjLpc5YS48j1ZZkkIricafcwtI30W19cz8/tXz9RefT6I3OtakPYG6SvMJP+kc6jD5
 PS8mK32HGIZkMgGQBsFfurmXz2mfugNDAcABZQ04FwFyk6rqNTxCehzHPt3aVJEaQM9j
 utiKpLjhrtgMKUiXqkLkigjiFSoUpkIea1ldMJEa78a9L4ze89FU2xVORqEIvTJZPr+o
 iKCUWADQS+IO2mQ7rGD9ILZ6zAI4m0bRNdAe91CpHPryqfBENX4ptpV12iPGqZHboguj wQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 30nucgd3ja-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Apr 2020 18:18:33 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03UI6Yb7111284;
        Thu, 30 Apr 2020 18:16:32 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 30qtkwx9f3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Apr 2020 18:16:32 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03UIGTOx004289;
        Thu, 30 Apr 2020 18:16:29 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 30 Apr 2020 11:16:29 -0700
Date:   Thu, 30 Apr 2020 11:16:28 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/21] xfs: refactor log recovery item sorting into a
 generic dispatch structure
Message-ID: <20200430181628.GB6742@magnolia>
References: <158820765488.467894.15408191148091671053.stgit@magnolia>
 <158820766135.467894.13993542565087629835.stgit@magnolia>
 <20200430055309.GA29110@infradead.org>
 <20200430150821.GY6742@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200430150821.GY6742@magnolia>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9607 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 mlxscore=0
 phishscore=0 mlxlogscore=999 adultscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004300142
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9607 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 priorityscore=1501
 mlxlogscore=999 impostorscore=0 suspectscore=0 malwarescore=0
 lowpriorityscore=0 mlxscore=0 spamscore=0 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004300142
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 30, 2020 at 08:08:21AM -0700, Darrick J. Wong wrote:
> On Wed, Apr 29, 2020 at 10:53:09PM -0700, Christoph Hellwig wrote:
> > On Wed, Apr 29, 2020 at 05:47:41PM -0700, Darrick J. Wong wrote:
> > > +extern const struct xlog_recover_item_type xlog_icreate_item_type;
> > > +extern const struct xlog_recover_item_type xlog_buf_item_type;
> > > +extern const struct xlog_recover_item_type xlog_inode_item_type;
> > > +extern const struct xlog_recover_item_type xlog_dquot_item_type;
> > > +extern const struct xlog_recover_item_type xlog_quotaoff_item_type;
> > > +extern const struct xlog_recover_item_type xlog_bmap_intent_item_type;
> > > +extern const struct xlog_recover_item_type xlog_bmap_done_item_type;
> > > +extern const struct xlog_recover_item_type xlog_extfree_intent_item_type;
> > > +extern const struct xlog_recover_item_type xlog_extfree_done_item_type;
> > > +extern const struct xlog_recover_item_type xlog_rmap_intent_item_type;
> > > +extern const struct xlog_recover_item_type xlog_rmap_done_item_type;
> > > +extern const struct xlog_recover_item_type xlog_refcount_intent_item_type;
> > > +extern const struct xlog_recover_item_type xlog_refcount_done_item_type;
> > 
> > I'd prefer if we didn't have to expose these structures, but had a
> > xlog_register_recovery_item helper that just adds them to a list or
> > array.
> 
> I can look into making a register function and do lookups, but that's
> a lot of indirection to save ~15 or so externs.

Ok, so I looked into this, and I don't know of a good way to avoid
exporting 14 *somethings*.  If we require a xlog_register_recovery_item
call to link the item types when the module loads, something has to call
that registration function.  That can be an __init function in each item
recovery source file, but now we have to export all fourteen of those
functions so that we can call them from init_xfs_fs.  Unless you've got
a better suggestion, I don't think this is worth the effort.

--D

> > >  typedef struct xlog_recover_item {
> > >  	struct list_head	ri_list;
> > > -	int			ri_type;
> > >  	int			ri_cnt;	/* count of regions found */
> > >  	int			ri_total;	/* total regions */
> > >  	xfs_log_iovec_t		*ri_buf;	/* ptr to regions buffer */
> > > +	const struct xlog_recover_item_type *ri_type;
> > >  } xlog_recover_item_t;
> > 
> > Btw, killing the xlog_recover_item_t typedef might be a worthwhile prep
> > patch.
> 
> Hrm, ok....
> 
> > > --- a/fs/xfs/xfs_buf_item.c
> > > +++ b/fs/xfs/xfs_buf_item.c
> > > @@ -17,7 +17,6 @@
> > >  #include "xfs_trace.h"
> > >  #include "xfs_log.h"
> > >  
> > > -
> > >  kmem_zone_t	*xfs_buf_item_zone;
> > >  
> > >  static inline struct xfs_buf_log_item *BUF_ITEM(struct xfs_log_item *lip)
> > 
> > Spurious whitespace change in a file not otherwise touched.
> 
> Fixed.
> 
> > >  
> > > @@ -107,3 +109,14 @@ xfs_icreate_log(
> > >  	tp->t_flags |= XFS_TRANS_DIRTY;
> > >  	set_bit(XFS_LI_DIRTY, &icp->ic_item.li_flags);
> > >  }
> > > +
> > > +static enum xlog_recover_reorder
> > > +xlog_icreate_reorder(
> > > +		struct xlog_recover_item *item)
> > > +{
> > > +	return XLOG_REORDER_BUFFER_LIST;
> > > +}
> > 
> > It might be worth to throw in a comment why icreate items got to
> > the buffer list.
> > 
> > > +		return 0;
> > > +#ifdef CONFIG_XFS_QUOTA
> > > +	case XFS_LI_DQUOT:
> > > +		item->ri_type = &xlog_dquot_item_type;
> > > +		return 0;
> > > +	case XFS_LI_QUOTAOFF:
> > > +		item->ri_type = &xlog_quotaoff_item_type;
> > > +		return 0;
> > > +#endif /* CONFIG_XFS_QUOTA */
> > > +	default:
> > > +		return -EFSCORRUPTED;
> > > +	}
> > > +}
> > 
> > Quote recovery support currently is unconditionalẏ  Making it
> > conditional on CONFIG_XFS_QUOTA means a kernel without that config
> > will now fail to recover a file system with quota updates in the log.
> 
> Heh, I hadn't realized that quota recovery always works even if quotas
> are disabled.  Ok, xfs_dquot_recovery.c it is...
> 
> --D
