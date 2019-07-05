Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E36A760A9F
	for <lists+linux-xfs@lfdr.de>; Fri,  5 Jul 2019 18:47:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725681AbfGEQrT (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 5 Jul 2019 12:47:19 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:54030 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725788AbfGEQrS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Jul 2019 12:47:18 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x65GiBfW151480;
        Fri, 5 Jul 2019 16:46:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=8Rjpn4YQcFowOh8H0u9hwoJhbFJPfo1N1UsKfSfsT6s=;
 b=YVmv5Nnv6EKovT3aR3mdX+cMglspNak4ThzIbUhwmJgMS4s2FA419FAiCP1P3vtavYVE
 JH4M+7HrwaCNG2h8dQpbmjblgquUtQioJeYNfo8YImYD67EG/pNLjRfwcvqX09Rq0/GQ
 tAUQ+jvh6zitSN1Mya7rvGWnPsTbetM3zob8tBgMnrfYoPt8QEv2+YFKKPFoaE3CSUdJ
 m8D2LmzVfz27TUmeUSp3Zj1OG/NwrXHxmMLGemvhenBQaEjRev08qX7EF6KtPbO/PbmU
 9r94IyKi7ZP4eguuLQ5+AEbqsCYIov4So2qh/+yJaVYGfu6I3K0eLmM4rm2muBDRvYS8 Iw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2te61qbu01-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Jul 2019 16:46:57 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x65Gh3tG189833;
        Fri, 5 Jul 2019 16:46:57 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2th5qmkp3f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Jul 2019 16:46:57 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x65GkuYS029247;
        Fri, 5 Jul 2019 16:46:56 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 05 Jul 2019 09:46:56 -0700
Date:   Fri, 5 Jul 2019 09:46:55 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/6] xfs: attribute scrub should use seen_enough to pass
 error values
Message-ID: <20190705164655.GF1404256@magnolia>
References: <156158199378.495944.4088787757066517679.stgit@magnolia>
 <156158200593.495944.1612838829393872431.stgit@magnolia>
 <20190705144917.GD37448@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190705144917.GD37448@bfoster>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9309 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907050205
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9309 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907050206
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 05, 2019 at 10:49:17AM -0400, Brian Foster wrote:
> On Wed, Jun 26, 2019 at 01:46:45PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > When we're iterating all the attributes using the built-in xattr
> > iterator, we can use the seen_enough variable to pass error codes back
> > to the main scrub function instead of flattening them into 0/1.  This
> > will be used in a more exciting fashion in upcoming patches.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/scrub/attr.c |    8 ++++++--
> >  1 file changed, 6 insertions(+), 2 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
> > index dce74ec57038..f0fd26abd39d 100644
> > --- a/fs/xfs/scrub/attr.c
> > +++ b/fs/xfs/scrub/attr.c
> > @@ -83,7 +83,7 @@ xchk_xattr_listent(
> >  	sx = container_of(context, struct xchk_xattr, context);
> >  
> >  	if (xchk_should_terminate(sx->sc, &error)) {
> > -		context->seen_enough = 1;
> > +		context->seen_enough = error;
> 
> It might be appropriate to update the xfs_attr_list_context structure
> definition comment since 'seen_enough' is not self explanatory as an
> error code..? Otherwise looks fine:

Ok.  I'll change it to:

	/*
	 * Abort attribute list iteration if non-zero.  Can be used to
	 * pass error values to the xfs_attr_list caller.
	 */

--D

> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> >  		return;
> >  	}
> >  
> > @@ -125,7 +125,7 @@ xchk_xattr_listent(
> >  					     args.blkno);
> >  fail_xref:
> >  	if (sx->sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
> > -		context->seen_enough = 1;
> > +		context->seen_enough = XFS_ITER_ABORT;
> >  	return;
> >  }
> >  
> > @@ -464,6 +464,10 @@ xchk_xattr(
> >  	error = xfs_attr_list_int_ilocked(&sx.context);
> >  	if (!xchk_fblock_process_error(sc, XFS_ATTR_FORK, 0, &error))
> >  		goto out;
> > +
> > +	/* Did our listent function try to return any errors? */
> > +	if (sx.context.seen_enough < 0)
> > +		error = sx.context.seen_enough;
> >  out:
> >  	return error;
> >  }
> > 
