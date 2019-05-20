Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50984243ED
	for <lists+linux-xfs@lfdr.de>; Tue, 21 May 2019 01:12:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726584AbfETXMz (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 20 May 2019 19:12:55 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:34604 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726164AbfETXMz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 May 2019 19:12:55 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4KMwpC1139647;
        Mon, 20 May 2019 23:12:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=FTBu9MFQHIjoiGrvXVgJ9JzGtQS88b+Zi/PcQNINfJY=;
 b=caPRCx7StDauCEzxwI64/b1b/2AuzvKL5OYuFPya4wa7GynMLcJwDZ4wCgsxreGzw6lo
 7R9X3Mynfca4cxgwxW3jefPJvKM46hMcZ57e9PQtvC1HebbQZqHN44c4olAW06ya/2mJ
 i3Ul4x5McweUh+t/gozPTOUsMht0LuUgRZr3sF62X/3Mj2gXoksvpL3coznYpUhD2Ndw
 SG+FEC9wjn4RSFrdDL9kZeJ0m41jBqZ2GioQ2eui9ntM5qAJjxXl9aPWpzMVQV1DX8Ek
 aeZORmxJSdqSNDgjtdcD1YJfTWXvcgdE+MSXC1w/nAzNONgJtkrxMgXlCjEzuDgt0qcH RA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2sjapq9ts2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 May 2019 23:12:33 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4KNCUAG141424;
        Mon, 20 May 2019 23:12:32 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2sm046n24e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 May 2019 23:12:32 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x4KNCTn3005009;
        Mon, 20 May 2019 23:12:29 GMT
Received: from localhost (/10.159.247.197)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 20 May 2019 23:12:28 +0000
Date:   Mon, 20 May 2019 16:12:27 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 6/3] libxfs: factor common xfs_trans_bjoin code
Message-ID: <20190520231227.GK5335@magnolia>
References: <8fc2eb9e-78c4-df39-3b8f-9109720ab680@redhat.com>
 <3a54f934-5651-d709-1503-b583f9e044e9@redhat.com>
 <20190520225620.GG5335@magnolia>
 <467b059a-e99c-a2dc-5c63-606212e5505f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <467b059a-e99c-a2dc-5c63-606212e5505f@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9263 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905200142
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9263 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905200141
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 20, 2019 at 05:58:29PM -0500, Eric Sandeen wrote:
> On 5/20/19 5:56 PM, Darrick J. Wong wrote:
> > On Thu, May 16, 2019 at 03:39:49PM -0500, Eric Sandeen wrote:
> >> Most of xfs_trans_bjoin is duplicated in xfs_trans_get_buf_map,
> >> xfs_trans_getsb and xfs_trans_read_buf_map.  Add a new
> >> _xfs_trans_bjoin which can be called by all three functions.
> >>
> >> Source kernel commit: d7e84f413726876c0ec66bbf90770f69841f7663
> >>
> >> Signed-off-by: Christoph Hellwig <hch@lst.de>
> >> Reviewed-by: Dave Chinner <david@fromorbit.com>
> >> Signed-off-by: Alex Elder <aelder@sgi.com>
> >> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> >> ---
> >>  libxfs/trans.c | 53 +++++++++++++++++++++++++++++++++++++-------------
> >>  1 file changed, 39 insertions(+), 14 deletions(-)
> >>
> >> diff --git a/libxfs/trans.c b/libxfs/trans.c
> >> index f3c28fa7..f78222fd 100644
> >> --- a/libxfs/trans.c
> >> +++ b/libxfs/trans.c
> >> @@ -537,19 +537,50 @@ xfs_trans_binval(
> >>  	tp->t_flags |= XFS_TRANS_DIRTY;
> >>  }
> >>  
> >> -void
> >> -xfs_trans_bjoin(
> >> -	xfs_trans_t		*tp,
> >> -	xfs_buf_t		*bp)
> >> +/*
> >> + * Add the locked buffer to the transaction.
> >> + *
> >> + * The buffer must be locked, and it cannot be associated with any
> >> + * transaction.
> >> + *
> >> + * If the buffer does not yet have a buf log item associated with it,
> >> + * then allocate one for it.  Then add the buf item to the transaction.
> >> + */
> >> +STATIC void
> >> +_xfs_trans_bjoin(
> >> +	struct xfs_trans	*tp,
> >> +	struct xfs_buf		*bp,
> >> +	int			reset_recur)
> > 
> > bool?
> 
> If you fix it in the kernel I'll merge it to xfsprogs ;)

LOL, ok.

--D

> >>  {
> >> -	xfs_buf_log_item_t	*bip;
> >> +	struct xfs_buf_log_item	*bip;
> >>  
> >>  	ASSERT(bp->b_transp == NULL);
> >>  
> >> +        /*
> >> +	 * The xfs_buf_log_item pointer is stored in b_log_item.  If
> >> +	 * it doesn't have one yet, then allocate one and initialize it.
> >> +	 * The checks to see if one is there are in xfs_buf_item_init().
> >> +	 */
> >>  	xfs_buf_item_init(bp, tp->t_mountp);
> >>  	bip = bp->b_log_item;
> >> +	if (reset_recur)
> >> +		bip->bli_recur = 0;
> >> +
> >> +	/*
> >> +	 * Attach the item to the transaction so we can find it in
> >> +	 * xfs_trans_get_buf() and friends.
> >> +	 */
> >>  	xfs_trans_add_item(tp, (xfs_log_item_t *)bip);
> > 
> > Kill typedef here               ^^^^^^?
> 
> ditto.
> 
> Point of all this is to match the kernel for easier future syncups.
> 
> (oh wait, actually, this is fixed in a later patch, getting rid of the dumb
> cast altogether)
> 
> -Eric
> 
> > --D
> > 
> >>  	bp->b_transp = tp;
> >> +
> >> +}
> >> +
> >> +void
> >> +xfs_trans_bjoin(
> >> +	struct xfs_trans	*tp,
> >> +	struct xfs_buf		*bp)
> >> +{
> >> +	_xfs_trans_bjoin(tp, bp, 0);
> >>  	trace_xfs_trans_bjoin(bp->b_log_item);
> >>  }
> >>  
> >> @@ -594,9 +625,7 @@ xfs_trans_get_buf_map(
> >>  	if (bp == NULL)
> >>  		return NULL;
> >>  
> >> -	xfs_trans_bjoin(tp, bp);
> >> -	bip = bp->b_log_item;
> >> -	bip->bli_recur = 0;
> >> +	_xfs_trans_bjoin(tp, bp, 1);
> >>  	trace_xfs_trans_get_buf(bp->b_log_item);
> >>  	return bp;
> >>  }
> >> @@ -626,9 +655,7 @@ xfs_trans_getsb(
> >>  
> >>  	bp = xfs_getsb(mp);
> >>  
> >> -	xfs_trans_bjoin(tp, bp);
> >> -	bip = bp->b_log_item;
> >> -	bip->bli_recur = 0;
> >> +	_xfs_trans_bjoin(tp, bp, 1);
> >>  	trace_xfs_trans_getsb(bp->b_log_item);
> >>  	return bp;
> >>  }
> >> @@ -677,9 +704,7 @@ xfs_trans_read_buf_map(
> >>  	if (bp->b_error)
> >>  		goto out_relse;
> >>  
> >> -	xfs_trans_bjoin(tp, bp);
> >> -	bip = bp->b_log_item;
> >> -	bip->bli_recur = 0;
> >> +	_xfs_trans_bjoin(tp, bp, 1);
> >>  done:
> >>  	trace_xfs_trans_read_buf(bp->b_log_item);
> >>  	*bpp = bp;
> >> -- 
> >> 2.17.0
> >>
> 
