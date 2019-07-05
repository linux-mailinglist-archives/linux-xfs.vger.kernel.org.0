Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B228160A53
	for <lists+linux-xfs@lfdr.de>; Fri,  5 Jul 2019 18:35:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728424AbfGEQfS (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 5 Jul 2019 12:35:18 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:57884 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726851AbfGEQfS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Jul 2019 12:35:18 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x65GXtH2132955;
        Fri, 5 Jul 2019 16:35:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=6sxumRxbqiSH68e3RQJfnXlOPWYC9wkRQPYudw3stkY=;
 b=sTAqO+j3OG4gzn4AWqbaHxzjCxPexHuToCizAWtWj+vuZgcsrldtwf+G4HTqpdpTENay
 +nr8XBLXW58HB+Vx7NqaaqJc17Gg0q6VOqo37SKiBVUOc6N4yoa4kvMsgNutx06W+izt
 7CyYzSLqI1XQFycf6yvvrcakvXsbvjZ6RYoqCJ8lRNXbRdbJ8mrjuQVUGY+GUdborJ4W
 V28UEMan+tnn4G1jK17wSg9M5kitSY3it1l5VVBrdngTGCgaWoKdVdASR0yh4ss6V0aD
 2UfWKEcnYSNfUh+YVL6mpAHWmC5N3Hi14ymAAkhGcw119LEmYvMjWTg0l5isCwr6afit eg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2te61ekrv5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Jul 2019 16:35:06 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x65GWWfn033544;
        Fri, 5 Jul 2019 16:35:06 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2thxrvhen4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Jul 2019 16:35:06 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x65GZ5Lf023754;
        Fri, 5 Jul 2019 16:35:06 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 05 Jul 2019 09:35:05 -0700
Date:   Fri, 5 Jul 2019 09:35:04 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/6] xfs: online scrub needn't bother zeroing its
 temporary buffer
Message-ID: <20190705163504.GE1404256@magnolia>
References: <156158199378.495944.4088787757066517679.stgit@magnolia>
 <156158203074.495944.13142136337107091755.stgit@magnolia>
 <20190705145246.GH37448@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190705145246.GH37448@bfoster>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9309 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907050203
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9309 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907050203
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 05, 2019 at 10:52:46AM -0400, Brian Foster wrote:
> On Wed, Jun 26, 2019 at 01:47:10PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > The xattr scrubber functions use the temporary memory buffer either for
> > storing bitmaps or for testing if attribute value extraction works.  The
> > bitmap code always zeroes what it needs and the value extraction merely
> > sets the buffer contents (we never read the contents, we just look for
> > return codes), so it's not necessary to waste CPU time zeroing on
> > allocation.
> > 
> 
> If we don't need to zero the buffer because we never look at the result,
> that suggests we don't need to populate it in the first place right?

We still need to read the attr value into the buffer (at least for
remote attr values) because scrub doesn't otherwise check the remote
attribute block header.

We never read the contents (because the contents are just arbitrary
bytes) but we do need to be able to catch an EFSCORRUPTED if, say, the
attribute dabtree points at a corrupt block.

> > A flame graph analysis showed that we were spending 7% of a xfs_scrub
> > run (the whole program, not just the attr scrubber itself) allocating
> > and zeroing 64k segments needlessly.
> > 
> 
> How much does this patch help?

About 1-2% I think.  FWIW the "7%" figure represents the smallest
improvement I saw in runtimes, where allocation ate 1-2% of the runtime
and zeroing accounts for the rest (~5-6%).

Practically speaking, when I retested with NVME flash instead of
spinning rust then the improvement jumped to 15-20% overall.

> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/scrub/attr.c |    7 ++++++-
> >  1 file changed, 6 insertions(+), 1 deletion(-)
> > 
> > 
> > diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
> > index 09081d8ab34b..d3a6f3dacf0d 100644
> > --- a/fs/xfs/scrub/attr.c
> > +++ b/fs/xfs/scrub/attr.c
> > @@ -64,7 +64,12 @@ xchk_setup_xattr_buf(
> >  		sc->buf = NULL;
> >  	}
> >  
> > -	ab = kmem_zalloc_large(sizeof(*ab) + sz, flags);
> > +	/*
> > +	 * Allocate the big buffer.  We skip zeroing it because that added 7%
> > +	 * to the scrub runtime and all the users were careful never to read
> > +	 * uninitialized contents.
> > +	 */
> 
> Ok, that suggests the 7% hit was due to zeroing (where the commit log
> says "allocating and zeroing"). Either way, we probably don't need such
> details in the code. Can we tweak the comment to something like:
> 
> /*
>  * Don't zero the buffer on allocation to avoid runtime overhead. All
>  * users must be careful never to read uninitialized contents.
>  */ 

Ok, I'll do that.

Thanks for all the review! :)

--D

> 
> With that:
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> > +	ab = kmem_alloc_large(sizeof(*ab) + sz, flags);
> >  	if (!ab)
> >  		return -ENOMEM;
> >  
> > 
