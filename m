Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9584512745
	for <lists+linux-xfs@lfdr.de>; Fri,  3 May 2019 07:49:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726585AbfECFtX (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 3 May 2019 01:49:23 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:60080 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726156AbfECFtW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 May 2019 01:49:22 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x435n6uU180288;
        Fri, 3 May 2019 05:49:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=zflXOM923xlmHI9E5+uNaxGQO3sHF2rboR4mSvU4alw=;
 b=u38kcbcwUVvW4OLRBD7UX3iey250LKoLGLf0f0DCDAYHc8X9CMChPKP7l0dTgCqTNbjD
 lof7Hzsh4J2+Gxf2+iRHazuvvmHaHNdu9jl4t1/ZreXuguk3cdxMQXDi3dOeYo91DHIM
 zUMoGyyHvwKvOxUpcBV7KUEmR9tpT7tGRVkG6RT1QR5Mmw4svq0WW4d4+JHIhOmzGbth
 XoND9QSg3I5KP2zerjr0BncxK4UhpcW0k5ulXaRExcyQOsU82xchMIDdbnA1ecPYjZ1N
 wj1fvjrbk2m5JqpIiDzJLuDjMX1eT9uYaMcYbozu/59L6VJq1+Hy1D8gsYVVPYVqXozK yw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 2s6xhymmts-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 May 2019 05:49:10 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x435n9XO004621;
        Fri, 3 May 2019 05:49:09 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2s6xhheyf5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 May 2019 05:49:09 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x435n8uZ025697;
        Fri, 3 May 2019 05:49:08 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 02 May 2019 22:49:07 -0700
Date:   Thu, 2 May 2019 22:49:06 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [RFC PATCH] mkfs: validate start and end of aligned logs
Message-ID: <20190503054906.GQ5207@magnolia>
References: <20190503035312.GP5207@magnolia>
 <494dcfb7-7ca9-5a95-532c-13d569ccd3da@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <494dcfb7-7ca9-5a95-532c-13d569ccd3da@sandeen.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9245 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905030037
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9245 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905030037
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 02, 2019 at 11:12:21PM -0500, Eric Sandeen wrote:
> 
> 
> On 5/2/19 10:53 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Validate that the start and end of the log stay within a single AG if
> > we adjust either end to align to stripe units.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  mkfs/xfs_mkfs.c |   11 ++++++++++-
> >  1 file changed, 10 insertions(+), 1 deletion(-)
> > 
> > diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> > index 3ca8c9dc..0862621a 100644
> > --- a/mkfs/xfs_mkfs.c
> > +++ b/mkfs/xfs_mkfs.c
> > @@ -3070,11 +3070,20 @@ align_internal_log(
> >  	if ((cfg->logstart % sunit) != 0)
> >  		cfg->logstart = ((cfg->logstart + (sunit - 1)) / sunit) * sunit;
> >  
> > +	/* if our log start rounds into the next AG we're done */
> > +	if (!xfs_verify_fsbno(mp, cfg->logstart)) {
> > +			fprintf(stderr,
> > +_("Due to stripe alignment, the internal log start (%lld) cannot be aligned\n"
> > +  "within an allocation group.\n"),
> > +			(long long) cfg->logstart);
> > +		usage();
> > +	}
> > +
> >  	/* round up/down the log size now */
> >  	align_log_size(cfg, sunit);
> >  
> >  	/* check the aligned log still fits in an AG. */
> > -	if (cfg->logblocks > cfg->agsize - XFS_FSB_TO_AGBNO(mp, cfg->logstart)) {
> > +	if (!xfs_verify_fsbno(mp, cfg->logstart + cfg->logblocks - 1)) {
> 
> This used to see if the aligned log size was actually smaller than the AG.
> 
> Your new check just makes sure that the end block doesn't land on metadata,
> right?
> 
> i.e. we could end up with:
> 
> [ AG 0 ][ AG 1 ]
> [    log    ]
> 
> and pass your new test, because the end of the log doesn't stomp on ag
> metadata, even though it goes past the end of the start AG... right?

DOH.  Yes.  Somewhere in there I coded up a FSB_TO_AGNO(logstart) ==
FSB_TO_AGNO(logstart + logblocks - 1) but clearly it fell out.

Derp derp try again tomorrow. :(

--D

> -Eric
> 
> >  		fprintf(stderr,
> >  _("Due to stripe alignment, the internal log size (%lld) is too large.\n"
> >    "Must fit within an allocation group.\n"),
> > 
