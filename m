Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94B7557057
	for <lists+linux-xfs@lfdr.de>; Wed, 26 Jun 2019 20:12:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726239AbfFZSMo (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 26 Jun 2019 14:12:44 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:52444 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726042AbfFZSMn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Jun 2019 14:12:43 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5QI9GXG006629;
        Wed, 26 Jun 2019 18:12:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=hNUUy5NTqQxg8mOvyeop5TzTEC1TDcVQNREaWZgMHvw=;
 b=iyAxIFdH2UuXy17GRtrFQkbYd8zgZN94evMkZ+Jt4iZ55eFbAd3F37AgItbwIEHlcQsS
 IUoT7WkNRgpPyw0iP9IUjMK16sgvYL/oIMM35tsNm89aBdjRG1WScKqB4ClaJ2ruW4fZ
 lsV2VNNARuEwFuQahbjKo5n8/PpzGlSp9rHwx9fv8ZQFQJRJq2rAZUNu2A8xfpLPeEgb
 O1DJxpuh3QikaPTF+VT8abyK4Qs47xwvGND23cG/9zPX7/Kg+CtlymLySYVfK4q2Pby0
 xFTdLaempU2WTANFGbqBM84I5xErUQ2ZogKGaQ/GiAyl2JjT2wVL5jcQ7MCIJhR5TSed Uw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2t9c9puxxu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Jun 2019 18:12:10 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5QIBRof113832;
        Wed, 26 Jun 2019 18:12:09 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2tat7cygas-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Jun 2019 18:12:09 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5QIC855002483;
        Wed, 26 Jun 2019 18:12:08 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 26 Jun 2019 11:12:07 -0700
Date:   Wed, 26 Jun 2019 11:12:06 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Eric Sandeen <sandeen@redhat.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        David Valin <dvalin@redhat.com>
Subject: Re: [PATCH] xfs: short circuit xfs_get_acl() if no acl is possible
Message-ID: <20190626181206.GH5171@magnolia>
References: <35128e32-d69b-316e-c8d6-8f109646390d@redhat.com>
 <20190508201033.GW5207@magnolia>
 <20190509130535.GB41691@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190509130535.GB41691@bfoster>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9300 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906260212
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9300 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906260212
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 09, 2019 at 09:05:39AM -0400, Brian Foster wrote:
> On Wed, May 08, 2019 at 01:10:33PM -0700, Darrick J. Wong wrote:
> > On Wed, May 08, 2019 at 02:28:09PM -0500, Eric Sandeen wrote:
> > > If there are no attributes on the inode, don't go through the
> > > cost of memory allocation and callling xfs_attr_get when we
> > > already know we'll just get -ENOATTR.
> > > 
> > > Reported-by: David Valin <dvalin@redhat.com>
> > > Suggested-by: Dave Chinner <david@fromorbit.com>
> > > Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> > > ---
> > > 
> > > diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
> > > index 8039e35147dd..b469b44e9e71 100644
> > > --- a/fs/xfs/xfs_acl.c
> > > +++ b/fs/xfs/xfs_acl.c
> > > @@ -132,6 +132,9 @@ xfs_get_acl(struct inode *inode, int type)
> > >  		BUG();
> > >  	}
> > >  
> > > +	if (!xfs_inode_hasattr(ip))
> > > +		return NULL;
> > 
> > This isn't going to cause problems if someone's adding an ACL to the
> > inode at the same time, right?
> > 
> > I'm assuming that's the case since we only would load inodes when
> > setting up a vfs inode but before any userspace can get its sticky
> > fingers all over the inode, but it sure would be nice to know that
> > for sure. :)
> > 
> 
> Hmm, that's a good question. At first I was thinking it wouldn't matter,
> but then I remembered the fairly recent issue around writing back an
> empty leaf buffer on format conversion a bit too early. That has me
> wondering if that would be an issue here as well. For example, suppose a
> non-empty local format attr fork is being converted to extent format due
> to a concurrent (and unrelated) xattr set. That involves
> xfs_attr_shortform_to_leaf() -> xfs_bmap_local_to_extents_empty(), which
> looks like it creates a transient empty fork state. Might
> xfs_inode_hasattr() catch that as a false negative here? If so, that
> would certainly be a problem if the existing xattr was the ACL the
> caller happens to be interested in. It might be prudent to surround this
> check with ILOCK_SHARED...

<shrug> But xfs_inode_hasattr checks forkoff > 0, so as long as the
shortform to leaf conversion doesn't zero forkoff we'd be fine, I think.
AFAICT it doesn't...?

--D

> Brian
> 
> > --D
> > 
> > > +
> > >  	/*
> > >  	 * If we have a cached ACLs value just return it, not need to
> > >  	 * go out to the disk.
> > > 
