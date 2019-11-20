Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE4491046D8
	for <lists+linux-xfs@lfdr.de>; Thu, 21 Nov 2019 00:09:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725842AbfKTXJD (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 20 Nov 2019 18:09:03 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:55358 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725820AbfKTXJD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Nov 2019 18:09:03 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAKN90Yj011416;
        Wed, 20 Nov 2019 23:09:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=wtkPERogq7EoVCLqrXcmTmY2r8qdznUyRCPcV+LAA3Y=;
 b=ijRXRepsIVDitLfehrZSPRLwXAy4aOJoHHHp0rkvT8LGl++6toUXY0v9hMGj4LHv7AD9
 eFjke9+aPnPHGS8jxzHJFQnNfPVJDjqdcZOMIWTd7dqmQgRJHyYRCUTm6F4uUa6yQX0W
 seEG3aGYLlyDe+MALqVNJYSzwMuKGfQm23JM86Yonin5azPNvMz0wRzNelYFxKZb3yML
 LmC5lD9UHZ9gNjbBHnHb+1QlKeqeE7kLzUIb8tazbbsU4L4+ivg9d7GFqJw9lr8JCNPJ
 wghlstG0X+Bwv0r+pyOdlCDI6KoeKmL3vxj7u5oU1OYFxUMTlq2kIbQJrshMdRGzgo+D rA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2wa9rqrkr3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Nov 2019 23:09:00 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAKN8qZR142112;
        Wed, 20 Nov 2019 23:08:55 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2wd47vxhdq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Nov 2019 23:08:51 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xAKN8TQT019052;
        Wed, 20 Nov 2019 23:08:29 GMT
Received: from localhost (/10.159.246.236)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 20 Nov 2019 15:08:28 -0800
Date:   Wed, 20 Nov 2019 15:08:28 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs: remove kmem_zalloc() wrapper
Message-ID: <20191120230828.GU6219@magnolia>
References: <20191120104425.407213-1-cmaiolino@redhat.com>
 <20191120104425.407213-4-cmaiolino@redhat.com>
 <20191120212401.GC4614@dread.disaster.area>
 <20191120214145.GT6219@magnolia>
 <20191120224404.dbuegv5ejmydrlb6@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191120224404.dbuegv5ejmydrlb6@orion>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9447 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911200195
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9447 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911200195
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 20, 2019 at 11:44:04PM +0100, Carlos Maiolino wrote:
> On Wed, Nov 20, 2019 at 01:41:45PM -0800, Darrick J. Wong wrote:
> > On Thu, Nov 21, 2019 at 08:24:01AM +1100, Dave Chinner wrote:
> > > On Wed, Nov 20, 2019 at 11:44:23AM +0100, Carlos Maiolino wrote:
> > > > Use kzalloc() directly
> > > > 
> > > > Special attention goes to function xfs_buf_map_from_irec(). Giving the
> > > > fact we are not allowed to fail there, I removed the 'if (!map)'
> > > > conditional from there, I'd just like somebody to double check if it's
> > > > fine as I believe it is
> > > > 
> > > > Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> > > 
> > > It looks good as a 1:1 translation, but I've noticed a few places we
> > > actually have the context wrong and have been saved by the fact tehy
> > > are called in transaction context (hence GFP_NOFS is enforced by
> > > task flags).
> > > 
> > > This can be fixed in a separate patch, I've noted the ones I think
> > > need changing below.
> > > 
> > > > diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> > > > index 795b9b21b64d..67de68584224 100644
> > > > --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> > > > +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> > > > @@ -2253,7 +2253,8 @@ xfs_attr3_leaf_unbalance(
> > > >  		struct xfs_attr_leafblock *tmp_leaf;
> > > >  		struct xfs_attr3_icleaf_hdr tmphdr;
> > > >  
> > > > -		tmp_leaf = kmem_zalloc(state->args->geo->blksize, 0);
> > > > +		tmp_leaf = kzalloc(state->args->geo->blksize,
> > > > +				   GFP_KERNEL | __GFP_NOFAIL);
> > > 
> > > In a transaction, GFP_NOFS.
> > 
> > As we're discussing on IRC, this is probably correct, but let's do a
> > straight KM_ -> GFP_ conversion here, warts and all; and then do a
> > separate series to sort out incorrect flag usage.
> 
> Sure, thanks guys, I can focus on that then after this series. Do you guys
> prefer me to 'finish' this series (i.e. removing KM_* flags), or fixing the
> wrong contexts before the next patches for KM_* -> GFP_* stuff?

Dunno, but it's all 5.6 material at this point, so you could possibly do
both.  I'm guessing that continuing the KM_ removal will be easier to
review and therefore should go first.

--D

> Cheers.
> 
> > 
> > --D
> > 
> > > > diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> > > > index dc39b2d1b351..4fea8e5e70fb 100644
> > > > --- a/fs/xfs/xfs_buf_item.c
> > > > +++ b/fs/xfs/xfs_buf_item.c
> > > > @@ -701,8 +701,8 @@ xfs_buf_item_get_format(
> > > >  		return 0;
> > > >  	}
> > > >  
> > > > -	bip->bli_formats = kmem_zalloc(count * sizeof(struct xfs_buf_log_format),
> > > > -				0);
> > > > +	bip->bli_formats = kzalloc(count * sizeof(struct xfs_buf_log_format),
> > > > +				   GFP_KERNEL | __GFP_NOFAIL);
> > > >  	if (!bip->bli_formats)
> > > >  		return -ENOMEM;
> > > >  	return 0;
> > > 
> > > In a transaction, GFP_NOFS.
> > > 
> > > > diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
> > > > index 1b5e68ccef60..91bd47e8b832 100644
> > > > --- a/fs/xfs/xfs_dquot_item.c
> > > > +++ b/fs/xfs/xfs_dquot_item.c
> > > > @@ -347,7 +347,8 @@ xfs_qm_qoff_logitem_init(
> > > >  {
> > > >  	struct xfs_qoff_logitem	*qf;
> > > >  
> > > > -	qf = kmem_zalloc(sizeof(struct xfs_qoff_logitem), 0);
> > > > +	qf = kzalloc(sizeof(struct xfs_qoff_logitem),
> > > > +		     GFP_KERNEL | __GFP_NOFAIL);
> > > 
> > > In a transaction, GFP_NOFS.
> > > 
> > > > diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
> > > > index 9f0b99c7b34a..0ce50b47fc28 100644
> > > > --- a/fs/xfs/xfs_extent_busy.c
> > > > +++ b/fs/xfs/xfs_extent_busy.c
> > > > @@ -33,7 +33,8 @@ xfs_extent_busy_insert(
> > > >  	struct rb_node		**rbp;
> > > >  	struct rb_node		*parent = NULL;
> > > >  
> > > > -	new = kmem_zalloc(sizeof(struct xfs_extent_busy), 0);
> > > > +	new = kzalloc(sizeof(struct xfs_extent_busy),
> > > > +		      GFP_KERNEL | __GFP_NOFAIL);
> > > 
> > > transaction, GFP_NOFS.
> > > 
> > > >  	new->agno = agno;
> > > >  	new->bno = bno;
> > > >  	new->length = len;
> > > > diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> > > > index c3b8804aa396..872312029957 100644
> > > > --- a/fs/xfs/xfs_extfree_item.c
> > > > +++ b/fs/xfs/xfs_extfree_item.c
> > > > @@ -163,7 +163,7 @@ xfs_efi_init(
> > > >  	if (nextents > XFS_EFI_MAX_FAST_EXTENTS) {
> > > >  		size = (uint)(sizeof(xfs_efi_log_item_t) +
> > > >  			((nextents - 1) * sizeof(xfs_extent_t)));
> > > > -		efip = kmem_zalloc(size, 0);
> > > > +		efip = kzalloc(size, GFP_KERNEL | __GFP_NOFAIL);
> > > >  	} else {
> > > >  		efip = kmem_cache_zalloc(xfs_efi_zone,
> > > >  					 GFP_KERNEL | __GFP_NOFAIL);
> > > 
> > > Both of these GFP_NOFS.
> > > 
> > > > @@ -333,9 +333,9 @@ xfs_trans_get_efd(
> > > >  	ASSERT(nextents > 0);
> > > >  
> > > >  	if (nextents > XFS_EFD_MAX_FAST_EXTENTS) {
> > > > -		efdp = kmem_zalloc(sizeof(struct xfs_efd_log_item) +
> > > > +		efdp = kzalloc(sizeof(struct xfs_efd_log_item) +
> > > >  				(nextents - 1) * sizeof(struct xfs_extent),
> > > > -				0);
> > > > +				GFP_KERNEL | __GFP_NOFAIL);
> > > >  	} else {
> > > >  		efdp = kmem_cache_zalloc(xfs_efd_zone,
> > > >  					 GFP_KERNEL | __GFP_NOFAIL);
> > > 
> > > Same here.
> > > 
> > > Hmmm. I guess I better go look at the kmem_cache_[z]alloc() patches,
> > > too.
> > > 
> > > > diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
> > > > index 76b39f2a0260..7ec70a5f1cb0 100644
> > > > --- a/fs/xfs/xfs_refcount_item.c
> > > > +++ b/fs/xfs/xfs_refcount_item.c
> > > > @@ -143,8 +143,8 @@ xfs_cui_init(
> > > >  
> > > >  	ASSERT(nextents > 0);
> > > >  	if (nextents > XFS_CUI_MAX_FAST_EXTENTS)
> > > > -		cuip = kmem_zalloc(xfs_cui_log_item_sizeof(nextents),
> > > > -				0);
> > > > +		cuip = kzalloc(xfs_cui_log_item_sizeof(nextents),
> > > > +			       GFP_KERNEL | __GFP_NOFAIL);
> > > >  	else
> > > >  		cuip = kmem_cache_zalloc(xfs_cui_zone,
> > > >  					 GFP_KERNEL | __GFP_NOFAIL);
> > > 
> > > Both GFP_NOFS.
> > > 
> > > > diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
> > > > index 6aeb6745d007..82d822885996 100644
> > > > --- a/fs/xfs/xfs_rmap_item.c
> > > > +++ b/fs/xfs/xfs_rmap_item.c
> > > > @@ -142,7 +142,8 @@ xfs_rui_init(
> > > >  
> > > >  	ASSERT(nextents > 0);
> > > >  	if (nextents > XFS_RUI_MAX_FAST_EXTENTS)
> > > > -		ruip = kmem_zalloc(xfs_rui_log_item_sizeof(nextents), 0);
> > > > +		ruip = kzalloc(xfs_rui_log_item_sizeof(nextents),
> > > > +			       GFP_KERNEL | __GFP_NOFAIL);
> > > >  	else
> > > >  		ruip = kmem_cache_zalloc(xfs_rui_zone,
> > > >  					 GFP_KERNEL | __GFP_NOFAIL);
> > > 
> > > Both GFP_NOFS.
> > > 
> > > Cheers,
> > > 
> > > Dave.
> > > -- 
> > > Dave Chinner
> > > david@fromorbit.com
> > 
> 
> -- 
> Carlos
> 
