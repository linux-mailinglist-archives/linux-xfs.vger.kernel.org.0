Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1019975685
	for <lists+linux-xfs@lfdr.de>; Thu, 25 Jul 2019 20:03:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726864AbfGYSDr (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 25 Jul 2019 14:03:47 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:55982 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725842AbfGYSDr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Jul 2019 14:03:47 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6PI3OHu065942;
        Thu, 25 Jul 2019 18:03:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=yXj3n9OGg829TCCHea/Fy3DGozn/Y+9edIZ3iK288M0=;
 b=L9vtoHMl6c2yLjc/NG9JBMERLArmQpmGHd1CKkXH3FG3C/rnHwnv3YM6rPxFa9X4lTbl
 ufcUras8Xyylqyz/h8WhRms/1pzJMdZwXkD0aLo/33t6PcincqSMXo2itbmjHin53qkQ
 nfPDR8u5UbYwGInVv0PEeqbzi+Kis3IAu0Hu5NI9liy7wxC38KHAfy0tTN08SKZnZu85
 CV+S6FDN5TBYV/EUODr0ukgaHADDWhas3ag67d89IJLLXLudluPs++xAve8jKdjGwFgb
 KLohueTQAztT/sm2ck2NrmnD/9TLGx0BHINHX4zAW8vAaXsWK4u9W95s3xKqZ1g1XwSh YQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2tx61c5qjh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Jul 2019 18:03:44 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6PI3DHk003263;
        Thu, 25 Jul 2019 18:03:44 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2tx60yfc9g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Jul 2019 18:03:44 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x6PI3h6Z015887;
        Thu, 25 Jul 2019 18:03:43 GMT
Received: from localhost (/10.144.111.83)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 25 Jul 2019 11:03:42 -0700
Date:   Thu, 25 Jul 2019 11:03:42 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 7/3] xfs/194: unmount forced v4 fs during cleanup
Message-ID: <20190725180342.GI1561054@magnolia>
References: <156394156831.1850719.2997473679130010771.stgit@magnolia>
 <20190724155656.GH7084@magnolia>
 <20190724232259.GC7777@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190724232259.GC7777@dread.disaster.area>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9329 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1907250213
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9329 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1907250213
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 25, 2019 at 09:22:59AM +1000, Dave Chinner wrote:
> On Wed, Jul 24, 2019 at 08:56:56AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Unmount the V4 filesystem we forcibly created to run this test during
> > test cleanup so that the post-test wrapup checks won't try to remount
> > the filesystem with different MOUNT_OPTIONS (specifically, the ones
> > that get screened out by _force_xfsv4_mount_options) and fail.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  tests/xfs/194 |    1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/tests/xfs/194 b/tests/xfs/194
> > index 3e186528..1f46d403 100755
> > --- a/tests/xfs/194
> > +++ b/tests/xfs/194
> > @@ -18,6 +18,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
> >  _cleanup()
> >  {
> >      cd /
> > +    _scratch_unmount
> 
> Comment as to why this is necessary here so we don't go and remove
> it because unmounting in cleanup should generally be unnecessary....

Ok.

--D

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
