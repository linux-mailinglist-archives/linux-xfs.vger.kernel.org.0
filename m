Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA5AA155E9A
	for <lists+linux-xfs@lfdr.de>; Fri,  7 Feb 2020 20:30:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726974AbgBGTa3 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 7 Feb 2020 14:30:29 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:41000 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726900AbgBGTa3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 7 Feb 2020 14:30:29 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 017JE643100166;
        Fri, 7 Feb 2020 19:30:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=oaBqd+P2h5iQyHnlhNAWKsUW0+mfC1KLZ2taqz1tDis=;
 b=R7DQSB5c16UrkefhUS+zwuhYYKuEoobNmpurDPa1gf+t2E92cVxxmztrblE6oxzHWor7
 KZz59nlWatDoLxIlImyHUeA7YzMC/AGadtj3JXtnDPM9fRhiJlXRPWndID3pv0VdlsQG
 aWLPuA1oqJ8veVRPE4f7fG6apHzqwXaNCNuwW1HXkQ2OeKcytRj3cursIl2Te646Li9Y
 dpz7h6kGVjTTpfJzlh0QC+k5eWof+I9TCKTFhcKtn3GYUQPXmrj7HLNEQukXbJb2O5g6
 OLbu0nCvbaP2+9ImG4OyVirN354J9h2uvtGE5H+DPEZ9YIEe2eOPDKmFqIV7RnhFqM9G ng== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2xykbphy4t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 07 Feb 2020 19:30:24 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 017JE6Nt003551;
        Fri, 7 Feb 2020 19:30:24 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2y0mk3f800-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 07 Feb 2020 19:30:23 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 017JUNnd032370;
        Fri, 7 Feb 2020 19:30:23 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 07 Feb 2020 11:30:22 -0800
Date:   Fri, 7 Feb 2020 11:30:22 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Pavel Reichl <preichl@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 3/4] xfs: Fix bug when checking diff. locks
Message-ID: <20200207193022.GI6870@magnolia>
References: <20200206190502.389139-1-preichl@redhat.com>
 <20200206190502.389139-4-preichl@redhat.com>
 <1f09e8f2-06b8-2c3e-c1f4-d63e508bb465@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1f09e8f2-06b8-2c3e-c1f4-d63e508bb465@sandeen.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9524 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2002070139
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9524 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2002070139
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Feb 07, 2020 at 01:25:06PM -0600, Eric Sandeen wrote:
> On 2/6/20 1:05 PM, Pavel Reichl wrote:
> > xfs_isilocked() will only check one lock type so it's needed to split
> > the check into 2 calls.
> 
> I think it's worth documenting the apparent intent of these calls;
> did the old call mean one or the other is locked?  (given the '|')
> or does it mean to test both?
> 
> Testing both individually does seem legit.  The single caller of each
> of these functions has already asserted:
> 
> ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL));
> 
> and then each also does:
> 
> xfs_ilock(ip, XFS_ILOCK_EXCL);
> 
> before calling these functions, so it is safe and reasonable to assume
> that both locks are held, and the intent is to test each one.
> 
> Oh, and if we look at when the old form got introduced, git blame says 
> ecfea3f0c8c64ce7375f4be4506996968958bd01, and it did:
> 
> -       ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL));
> -       ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
> -       ASSERT(direction == SHIFT_LEFT || direction == SHIFT_RIGHT);
> +       ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL));
> 
> so really, this is just reverting that invalid change back to
> valid individual ASSERTs.
> 
> I'll leave it up to Darrick whether he wants to massage the commit
> log I guess, but please at least add a :
> 
> Fixes: ecfea3f0c8c6 ("xfs: split xfs_bmap_shift_extents")
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>

Yeah, we should've done "one test per assert" back then... :/

And please do massage the commit log.

--D

> > Suggested-by: Dave Chinner <dchinner@redhat.com>
> > Signed-off-by: Pavel Reichl <preichl@redhat.com>
> > ---
> >  fs/xfs/libxfs/xfs_bmap.c | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> > index bc2be29193aa..c9dc94f114ed 100644
> > --- a/fs/xfs/libxfs/xfs_bmap.c
> > +++ b/fs/xfs/libxfs/xfs_bmap.c
> > @@ -5829,7 +5829,8 @@ xfs_bmap_collapse_extents(
> >  	if (XFS_FORCED_SHUTDOWN(mp))
> >  		return -EIO;
> >  
> > -	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL));
> > +	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL));
> > +	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
> >  
> >  	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
> >  		error = xfs_iread_extents(tp, ip, whichfork);
> > @@ -5946,7 +5947,8 @@ xfs_bmap_insert_extents(
> >  	if (XFS_FORCED_SHUTDOWN(mp))
> >  		return -EIO;
> >  
> > -	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL));
> > +	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL));
> > +	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
> >  
> >  	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
> >  		error = xfs_iread_extents(tp, ip, whichfork);
> > 
