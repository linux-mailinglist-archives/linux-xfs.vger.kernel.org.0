Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A31578E89
	for <lists+linux-xfs@lfdr.de>; Mon, 29 Jul 2019 16:58:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727219AbfG2O6s (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 29 Jul 2019 10:58:48 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:49548 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726197AbfG2O6s (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 29 Jul 2019 10:58:48 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6TEwei2085698;
        Mon, 29 Jul 2019 14:58:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2018-07-02;
 bh=S44Lyz0/tsObu/mpUDwWwxLgtc4ypQE+97AdgkhVadw=;
 b=smEJVfdXyJDHAIWMIQygDaOXub9D8R4YnvDwDNYrk7UOFEW3cpFANX8BYAJQbjVAStrc
 8hHXehi577Z27FasijOQCWi1m/u2w+B1B1dnBlMo9oGDrLEdnSpU+XUd16JAC0mBDk4B
 YEj2cm9Xwkdoxiq5anY3ssbU+jdSg3D3AyMoxYcfg+aPXgvG+239VIY6JAh7Ew0rjwju
 5Gl3md3jYvyWUcBFrkcFCZWlJqfJjZS/tJoBoPVkXpY/3EtQP1RHEH/gyjG0vtWpTK30
 +oUVKpc5eCqXQMULBvtd6Hu02iqqGuUQbEH7Li1xSzRMBQdflCJfEAsKK7UTmsPENqix vg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2u0e1tg4f9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 29 Jul 2019 14:58:40 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6TEw029030865;
        Mon, 29 Jul 2019 14:58:37 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2u0bqth2t9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 29 Jul 2019 14:58:37 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x6TEwZsv006331;
        Mon, 29 Jul 2019 14:58:35 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 29 Jul 2019 07:58:35 -0700
Date:   Mon, 29 Jul 2019 07:58:38 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Jia-Ju Bai <baijiaju1990@gmail.com>
Cc:     bfoster@redhat.com, sandeen@sandeen.net, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs: xfs: Fix possible null-pointer dereferences in
 xchk_da_btree_block_check_sibling()
Message-ID: <20190729145838.GN1561054@magnolia>
References: <20190729032401.28081-1-baijiaju1990@gmail.com>
 <20190729042034.GM1561054@magnolia>
 <efa37544-0402-af92-c94e-cec49701dca2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <efa37544-0402-af92-c94e-cec49701dca2@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9333 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1907290170
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9333 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1907290170
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 29, 2019 at 03:25:04PM +0800, Jia-Ju Bai wrote:
> 
> 
> On 2019/7/29 12:20, Darrick J. Wong wrote:
> > On Mon, Jul 29, 2019 at 11:24:01AM +0800, Jia-Ju Bai wrote:
> > > In xchk_da_btree_block_check_sibling(), there is an if statement on
> > > line 274 to check whether ds->state->altpath.blk[level].bp is NULL:
> > >      if (ds->state->altpath.blk[level].bp)
> > > 
> > > When ds->state->altpath.blk[level].bp is NULL, it is used on line 281:
> > >      xfs_trans_brelse(..., ds->state->altpath.blk[level].bp);
> > >          struct xfs_buf_log_item	*bip = bp->b_log_item;
> > >          ASSERT(bp->b_transp == tp);
> > > 
> > > Thus, possible null-pointer dereferences may occur.
> > > 
> > > To fix these bugs, ds->state->altpath.blk[level].bp is checked before
> > > being used.
> > > 
> > > These bugs are found by a static analysis tool STCheck written by us.
> > > 
> > > Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
> > > ---
> > >   fs/xfs/scrub/dabtree.c | 4 +++-
> > >   1 file changed, 3 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/fs/xfs/scrub/dabtree.c b/fs/xfs/scrub/dabtree.c
> > > index 94c4f1de1922..33ff90c0dd70 100644
> > > --- a/fs/xfs/scrub/dabtree.c
> > > +++ b/fs/xfs/scrub/dabtree.c
> > > @@ -278,7 +278,9 @@ xchk_da_btree_block_check_sibling(
> > >   	/* Compare upper level pointer to sibling pointer. */
> > >   	if (ds->state->altpath.blk[level].blkno != sibling)
> > >   		xchk_da_set_corrupt(ds, level);
> > > -	xfs_trans_brelse(ds->dargs.trans, ds->state->altpath.blk[level].bp);
> > > +	if (ds->state->altpath.blk[level].bp)
> > > +		xfs_trans_brelse(ds->dargs.trans,
> > > +						ds->state->altpath.blk[level].bp);
> > Indentation here (in xfs we use two spaces)
> 
> Okay, I will fix this.
> 
> > 
> > Also, uh, shouldn't we set ds->state->altpath.blk[level].bp to NULL
> > since we've released the buffer?
> 
> So I should set ds->state->altpath.blk[level].bp to NULL at the end of the
> function xchk_da_btree_block_check_sibling()?
> Like:
>     if (ds->state->altpath.blk[level].bp)
>         xfs_trans_brelse(ds->dargs.trans,
>                 ds->state->altpath.blk[level].bp);
>     ds->state->altpath.blk[level].bp = NULL;

You could put the whole thing in a single if clause, e.g.

	if (ds->state->altpath.blk[level].bp) {
		xfs_trans_brelse(ds->dargs.trans,
				 ds->state->altpath.blk[level].bp);
		ds->state->altpath.blk[level].bp = NULL;
	}

--D

> 
> 
> Best wishes,
> Jia-Ju Bai
