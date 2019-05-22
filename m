Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DF8826883
	for <lists+linux-xfs@lfdr.de>; Wed, 22 May 2019 18:42:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730012AbfEVQmi (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 22 May 2019 12:42:38 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:55260 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729572AbfEVQmi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 May 2019 12:42:38 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4MGdN8e161329;
        Wed, 22 May 2019 16:42:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=r1vU/VILKA+TM6Jl2Zyt5MIpCXYf9mkaOPhxuln0MFc=;
 b=1iRz6grnMu7fpfbZOZHp/cWJJXqdXLtabFcwY+lTo/ewTlyk8aIDW0EJRwCVL2Zta+0N
 7mxACjOW5DsIQm7Ww9cJGyYpe2I7EqHie6Al6jC7MgtJYqCRYSfHvStcdQ4bi5tr6X3U
 fJVMQ6zIBHVHa9E9WK6WCGocchGFqojbi/c4l/MmciRlOErIoh9oCqkcQs3ggHmbm3sP
 d1U+WRZTxiHFAsuXbLGmpGmrGj57Rh58JsBKjtFhIkpMC9ph0kWmktcGNCmg/ZUjbet7
 7RLAjtAgBPH/tyYaGvAtbe6v4wp6LANmuOsVXXL2fcbq7Cbze2js7S6tMVXQt+D/8QJ9 Wg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2smsk5d4gx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 May 2019 16:42:35 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4MGg5JI163674;
        Wed, 22 May 2019 16:42:34 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2smsh1qd17-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 May 2019 16:42:34 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x4MGgXYI010922;
        Wed, 22 May 2019 16:42:34 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 22 May 2019 16:42:33 +0000
Date:   Wed, 22 May 2019 09:42:30 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/12] mkfs: validate start and end of aligned logs
Message-ID: <20190522164230.GE5141@magnolia>
References: <155839420081.68606.4573219764134939943.stgit@magnolia>
 <155839427473.68606.3900005341580158051.stgit@magnolia>
 <03cd588a-f4b0-0c79-4862-31ae0e5cd3dd@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <03cd588a-f4b0-0c79-4862-31ae0e5cd3dd@sandeen.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9264 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905220116
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9264 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905220117
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 21, 2019 at 02:24:40PM -0500, Eric Sandeen wrote:
> On 5/20/19 6:17 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Validate that the start and end of the log stay within a single AG if
> > we adjust either end to align to stripe units.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  mkfs/xfs_mkfs.c |   15 ++++++++++++++-
> >  1 file changed, 14 insertions(+), 1 deletion(-)
> > 
> > 
> > diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> > index 5b66074d..8f84536e 100644
> > --- a/mkfs/xfs_mkfs.c
> > +++ b/mkfs/xfs_mkfs.c
> > @@ -3044,15 +3044,28 @@ align_internal_log(
> >  	struct xfs_mount	*mp,
> >  	int			sunit)
> >  {
> > +	uint64_t		logend;
> > +
> >  	/* round up log start if necessary */
> >  	if ((cfg->logstart % sunit) != 0)
> >  		cfg->logstart = ((cfg->logstart + (sunit - 1)) / sunit) * sunit;
> >  
> > +	/* if our log start rounds into the next AG we're done */
> 
> /* If our log start overlaps the next AG's metadata, fail */

Ok.

> > +	if (!xfs_verify_fsbno(mp, cfg->logstart)) {
> > +			fprintf(stderr,
> > +_("Due to stripe alignment, the internal log start (%lld) cannot be aligned\n"
> > +  "within an allocation group.\n"),
> > +			(long long) cfg->logstart);
> 
> Hm, should it suggest what should be modified to try again ...?

But what should be modified, exactly?  -d su=0,sw=0?

> > +		usage();
> > +	}
> > +
> >  	/* round up/down the log size now */
> >  	align_log_size(cfg, sunit);
> >  
> >  	/* check the aligned log still fits in an AG. */
> > -	if (cfg->logblocks > cfg->agsize - XFS_FSB_TO_AGBNO(mp, cfg->logstart)) {
> > +	logend = cfg->logstart + cfg->logblocks - 1;
> > +	if (XFS_FSB_TO_AGNO(mp, cfg->logstart) != XFS_FSB_TO_AGNO(mp, logend) ||
> > +	    !xfs_verify_fsbno(mp, logend)) {
> 
> this xfs_verify_fsbno is probably redundant but can't hurt?

<nod>

Will respin patch.

--D

> -Eric
> 
> >  		fprintf(stderr,
> >  _("Due to stripe alignment, the internal log size (%lld) is too large.\n"
> >    "Must fit within an allocation group.\n"),
> > 
