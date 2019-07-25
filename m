Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6486A75505
	for <lists+linux-xfs@lfdr.de>; Thu, 25 Jul 2019 19:02:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726148AbfGYRCg (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 25 Jul 2019 13:02:36 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:33156 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725800AbfGYRCf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Jul 2019 13:02:35 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6PGtgqe088184
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jul 2019 17:02:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=stdMw7/9j6hmbvcU4UO6sJ4htvMktxwLwAAGO/Bcf0w=;
 b=P00keaVcs1e+8isBhKWY6b3kJwZNSvBCH+IGhh8xzGw8YDrlPk7FjwAfbRYkO0q6b97P
 M3zpkXaqQqEVyKjczSlMDTzztHrpnSrjOexQWWuHj5GsiKf5W+27dp3cLeDpT6bs4ZgN
 l58NV6q043W2cO+IPHmLPEyBuEexxPmbifL8Vcd+ChjfVZ5uwdcvTgHG5stbMkiF/NTY
 labkabIDQCJ+MaZXPqhMCIRyml7cvDtU7gDGIKHwF79SgXHWfQ8u3iFa9FekdX2frtpm
 39moN8CGIH795cwReHUvvWQ0OlyXHHEheF1MzOFsYxaW2urA7nNNEQ6LABegmET1QjY5 tw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2tx61c5a40-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jul 2019 17:02:33 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6PFwGI5078818
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jul 2019 17:02:32 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2tx60yedbm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jul 2019 17:02:32 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x6PH2VJ9013592
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jul 2019 17:02:32 GMT
Received: from localhost (/10.144.111.83)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 25 Jul 2019 10:02:31 -0700
Date:   Thu, 25 Jul 2019 10:02:30 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix stack contents leakage in the v1
 bulkstat/inumbers ioctls
Message-ID: <20190725170230.GD1561054@magnolia>
References: <20190724153545.GC1561054@magnolia>
 <20190725065216.GI3089@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190725065216.GI3089@kadam>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9329 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1907250188
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9329 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1907250188
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 25, 2019 at 09:52:17AM +0300, Dan Carpenter wrote:
> On Wed, Jul 24, 2019 at 08:35:45AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Explicitly initialize the onstack structures to zero so we don't leak
> > kernel memory into userspace when converting the in-core structure to
> > the v1 ioctl structure.
> > 
> > Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/xfs_ioctl.c |    4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> > index f193f7b288ca..44e1a290f053 100644
> > --- a/fs/xfs/xfs_ioctl.c
> > +++ b/fs/xfs/xfs_ioctl.c
> > @@ -719,7 +719,7 @@ xfs_fsbulkstat_one_fmt(
> >  	struct xfs_ibulk		*breq,
> >  	const struct xfs_bulkstat	*bstat)
> >  {
> > -	struct xfs_bstat		bs1;
> > +	struct xfs_bstat		bs1 = { 0 };
> 
> This sort of initialization is potentially problematic because some
> versions of GCC will change it as a series of assignments (which doesn't
> clear the struct hole).  It's not clear to me the rules where GCC does
> this and also I wish there were an option to disable that feature.

And poor maintainers like me didn't even /know/ that.... ok, I'll go
with an explicit memset like Eric suggested in the patch review.

--D

> [ I am still out of office until the end of the month ]
> 
> regards,
> dan carpenter
> 
