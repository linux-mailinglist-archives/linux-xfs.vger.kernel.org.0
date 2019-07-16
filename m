Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 518FE69FA9
	for <lists+linux-xfs@lfdr.de>; Tue, 16 Jul 2019 02:03:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731373AbfGPADT (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 15 Jul 2019 20:03:19 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:49814 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730888AbfGPADT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 Jul 2019 20:03:19 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6FNx7ax109330;
        Tue, 16 Jul 2019 00:03:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=Dv/TPOjaL9Ezw7fyB8t64dAYnEaLjOo6rsXZc2riWzc=;
 b=vCd1W5jmVSjM41bLQEQPnCE4WhPy+de5VKgrByGn28PUayKP5o0vmgDYtG9eHOMIYo2/
 YfVTPZTNd3Sl0li6mNqFZpwDIp2kg04sVxc+oR7/gVU3/YtLmEX5GGDwe1G+KWQCZ9iw
 WVGwa+U8h5zmV8FoyYEyIFkou7nREppmx+tNaYRTrWia5U4SmMfme4LCUT1SQ897SzH0
 /9pLzFKvqvdXcE7dB78U24hu6v85A+QGYo+vi89LkUdEZK6KHeI491u8yPKDshOPirow
 tLEUvR31JRvO30jonNyIw8aLj1PX/KCr0Ty5+PONrvTgR6GpSR+7zYyfYu7nZftZlZ2z 8A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2tq78phbpr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Jul 2019 00:03:05 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6G02RWh018135;
        Tue, 16 Jul 2019 00:03:04 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2tq742t1yn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Jul 2019 00:03:04 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x6G03437006793;
        Tue, 16 Jul 2019 00:03:04 GMT
Received: from localhost (/10.159.158.106)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 15 Jul 2019 17:03:03 -0700
Date:   Mon, 15 Jul 2019 17:03:03 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Eric Sandeen <sandeen@redhat.com>,
        linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 2/2] xfs: sync up xfs_trans_inode with userspace
Message-ID: <20190716000303.GD6147@magnolia>
References: <68ef2df9-3f8e-6547-4e2b-181bce30ca3c@redhat.com>
 <112d2e52-c96c-af83-7e53-5fca12448c76@redhat.com>
 <20190715222209.GN7689@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190715222209.GN7689@dread.disaster.area>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9319 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907150270
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9319 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907150269
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 16, 2019 at 08:22:09AM +1000, Dave Chinner wrote:
> On Fri, Jul 12, 2019 at 12:46:17PM -0500, Eric Sandeen wrote:
> > Add an XFS_ICHGTIME_CREATE case to xfs_trans_ichgtime() to keep in
> > sync with userspace.  (Currently no kernel caller sends this flag.)
> > 
> > Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> > ---
> > 
> > diff --git a/fs/xfs/libxfs/xfs_trans_inode.c b/fs/xfs/libxfs/xfs_trans_inode.c
> > index 93d14e47269d..a9ad90926b87 100644
> > --- a/fs/xfs/libxfs/xfs_trans_inode.c
> > +++ b/fs/xfs/libxfs/xfs_trans_inode.c
> > @@ -66,6 +66,10 @@ xfs_trans_ichgtime(
> >  		inode->i_mtime = tv;
> >  	if (flags & XFS_ICHGTIME_CHG)
> >  		inode->i_ctime = tv;
> > +	if (flags & XFS_ICHGTIME_CREATE) {
> > +		ip->i_d.di_crtime.t_sec = (int32_t)tv.tv_sec;
> > +		ip->i_d.di_crtime.t_nsec = (int32_t)tv.tv_nsec;
> > +	}
> 
> Please use the same format as the rest of the function. i.e.
> 
> 	if (flags & XFS_ICHGTIME_CREATE)
> 		ip->i_d.di_crtime = tv;
> 
> And convert userspace over to the same :P

How about promoting crtime to struct inode while we're at it?

(That said I think Eric was going for the quick resync now to keep
kernel libxfs in sync with xfsprogs libxfs...)

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
