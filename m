Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB17A17860B
	for <lists+linux-xfs@lfdr.de>; Tue,  3 Mar 2020 23:58:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727827AbgCCW6P (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 3 Mar 2020 17:58:15 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:52252 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727429AbgCCW6P (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Mar 2020 17:58:15 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 023MsPZr061564;
        Tue, 3 Mar 2020 22:58:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=79of/q0UGjHI7pC5y4JUVVJzsSSLBJBVYh/oYoPvGa8=;
 b=FVLY4mxLmHAazNNCv7z5lCvQ4yOMgK77R60jr3mu0zgte50NO1/TWJcMMsBRhx3iFq81
 5n1KbedXZVTdY7UOzw8rouC+Kcp/sO1l0+7tAgNT0W1akiua8GGjbnWWPS0v++hfr3ph
 /KrVahQVoog0QVA68ZyjiE3ay2TTmFc4RQr1N7uF/G+gm1k2GtMXqcoPTe5RhiDT/SyK
 llq5/xZrKbvBRHwvj+5LBeb9vVKSH/MeRGhQiva3GCnLySUbEpBov9jOfQkj5CKdakzP
 O57vZ7ExfYYYZEVG+cMBfunq7ZQ35Rn3fEj0uSu03IgNM0GgcrXXJfa5qS5gyubZYEUA tA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2yffwqtf07-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Mar 2020 22:58:12 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 023Mr4tQ192360;
        Tue, 3 Mar 2020 22:58:12 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2yg1gyf82h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Mar 2020 22:58:12 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 023MwBHc019612;
        Tue, 3 Mar 2020 22:58:12 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Mar 2020 14:58:11 -0800
Date:   Tue, 3 Mar 2020 14:58:10 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: mark extended attr corrupt when lookup-by-hash
 fails
Message-ID: <20200303225810.GH8045@magnolia>
References: <158294094367.1730101.10848559171120744339.stgit@magnolia>
 <158294095587.1730101.1908515041366122931.stgit@magnolia>
 <20200303222643.GW10776@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200303222643.GW10776@dread.disaster.area>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9549 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 suspectscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003030148
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9549 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 spamscore=0
 impostorscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 suspectscore=0
 phishscore=0 clxscore=1015 bulkscore=0 adultscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003030148
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 04, 2020 at 09:26:43AM +1100, Dave Chinner wrote:
> On Fri, Feb 28, 2020 at 05:49:15PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > In xchk_xattr_listent, we attempt to validate the extended attribute
> > hash structures by performing a attr lookup by (hashed) name.  If the
> > lookup returns ENODATA, that means that the hash information is corrupt.
> > The _process_error functions don't catch this, so we have to add that
> > explicitly.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/scrub/attr.c |    5 +++++
> >  1 file changed, 5 insertions(+)
> > 
> > 
> > diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
> > index d9f0dd444b80..54ea1efa7ddc 100644
> > --- a/fs/xfs/scrub/attr.c
> > +++ b/fs/xfs/scrub/attr.c
> > @@ -163,6 +163,11 @@ xchk_xattr_listent(
> >  	args.valuelen = valuelen;
> >  
> >  	error = xfs_attr_get_ilocked(context->dp, &args);
> > +	if (error == -ENODATA) {
> > +		/* ENODATA means the hash lookup failed and the attr is bad */
> > +		xchk_fblock_set_corrupt(sx->sc, XFS_ATTR_FORK, args.blkno);
> > +		goto fail_xref;
> > +	}
> >  	if (!xchk_fblock_process_error(sx->sc, XFS_ATTR_FORK, args.blkno,
> >  			&error))
> >  		goto fail_xref;
> 
> Same question as the first patch.

Same resolution as the first patch. :)

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
