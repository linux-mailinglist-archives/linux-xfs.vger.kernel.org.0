Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D6AE5D214
	for <lists+linux-xfs@lfdr.de>; Tue,  2 Jul 2019 16:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727033AbfGBOuK (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 2 Jul 2019 10:50:10 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:60992 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726283AbfGBOuJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jul 2019 10:50:09 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x62EneX1033721;
        Tue, 2 Jul 2019 14:49:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=l7WlU7zsEEP4FUEG34DDVCENDB+iBc2t2HRJdtgkWHA=;
 b=rVXmCsCGMU31P/mRZgqz9JluBz8WxisIjx0oE/scR/81wuYp4QV8YW1iyq4RCXas2VCs
 7BEttjtDHRoMcnaDko1pdbKzvaGnaF0fCHc8al3mk9Prs2caEtv7FhJKOP7CJ2uqKdEf
 tMcLnWZJXXC48dKepSvtl1SoY+sAh108HG6QYxBFZmoviOuBJ1McMewqNianlzSEUX2g
 ORHs4ndj0r771NyJ8kAVvZle/Og1mLnNIt9hKX8BV5osUFvd+ksmKZv7uaGW2Df5ZQqr
 EmzjnwDIcTQVoox6XiclieHYIM3ndIJXggE2OWUFXcM1KTWXlTEHFzPYbHpIas3Bf3P5 BQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2te61pv3ja-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Jul 2019 14:49:40 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x62EmEDK079729;
        Tue, 2 Jul 2019 14:49:29 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2tebaktdb5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Jul 2019 14:49:29 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x62EnRVT024363;
        Tue, 2 Jul 2019 14:49:28 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 02 Jul 2019 07:49:27 -0700
Date:   Tue, 2 Jul 2019 07:49:26 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/15] xfs: calculate inode walk prefetch more carefully
Message-ID: <20190702144926.GD1654093@magnolia>
References: <156158183697.495087.5371839759804528321.stgit@magnolia>
 <156158188075.495087.14228436478786857410.stgit@magnolia>
 <20190702142403.GD2866@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190702142403.GD2866@bfoster>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9306 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907020162
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9306 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907020162
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 02, 2019 at 10:24:03AM -0400, Brian Foster wrote:
> On Wed, Jun 26, 2019 at 01:44:40PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > The existing inode walk prefetch is based on the old bulkstat code,
> > which simply allocated 4 pages worth of memory and prefetched that many
> > inobt records, regardless of however many inodes the caller requested.
> > 65536 inodes is a lot to prefetch (~32M on x64, ~512M on arm64) so let's
> > scale things down a little more intelligently based on the number of
> > inodes requested, etc.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> 
> A few nits..
> 
> >  fs/xfs/xfs_iwalk.c |   46 ++++++++++++++++++++++++++++++++++++++++++++--
> >  1 file changed, 44 insertions(+), 2 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/xfs_iwalk.c b/fs/xfs/xfs_iwalk.c
> > index 304c41e6ed1d..3e67d7702e16 100644
> > --- a/fs/xfs/xfs_iwalk.c
> > +++ b/fs/xfs/xfs_iwalk.c
> > @@ -333,16 +333,58 @@ xfs_iwalk_ag(
> >  	return error;
> >  }
> >  
> > +/*
> > + * We experimentally determined that the reduction in ioctl call overhead
> > + * diminishes when userspace asks for more than 2048 inodes, so we'll cap
> > + * prefetch at this point.
> > + */
> > +#define MAX_IWALK_PREFETCH	(2048U)
> > +
> 
> Something like IWALK_MAX_INODE_PREFETCH is a bit more clear IMO.

<nod>

> >  /*
> >   * Given the number of inodes to prefetch, set the number of inobt records that
> >   * we cache in memory, which controls the number of inodes we try to read
> > - * ahead.
> > + * ahead.  Set the maximum if @inode_records == 0.
> >   */
> >  static inline unsigned int
> >  xfs_iwalk_prefetch(
> >  	unsigned int		inode_records)
> 
> Perhaps this should be called 'inodes' since the function converts this
> value to inode records?

ok, I see how that could be a little confusing.

> >  {
> > -	return PAGE_SIZE * 4 / sizeof(struct xfs_inobt_rec_incore);
> > +	unsigned int		inobt_records;
> > +
> > +	/*
> > +	 * If the caller didn't tell us the number of inodes they wanted,
> > +	 * assume the maximum prefetch possible for best performance.
> > +	 * Otherwise, cap prefetch at that maximum so that we don't start an
> > +	 * absurd amount of prefetch.
> > +	 */
> > +	if (inode_records == 0)
> > +		inode_records = MAX_IWALK_PREFETCH;
> > +	inode_records = min(inode_records, MAX_IWALK_PREFETCH);
> > +
> > +	/* Round the inode count up to a full chunk. */
> > +	inode_records = round_up(inode_records, XFS_INODES_PER_CHUNK);
> > +
> > +	/*
> > +	 * In order to convert the number of inodes to prefetch into an
> > +	 * estimate of the number of inobt records to cache, we require a
> > +	 * conversion factor that reflects our expectations of the average
> > +	 * loading factor of an inode chunk.  Based on data gathered, most
> > +	 * (but not all) filesystems manage to keep the inode chunks totally
> > +	 * full, so we'll underestimate slightly so that our readahead will
> > +	 * still deliver the performance we want on aging filesystems:
> > +	 *
> > +	 * inobt = inodes / (INODES_PER_CHUNK * (4 / 5));
> > +	 *
> > +	 * The funny math is to avoid division.
> > +	 */
> 
> The last bit of this comment is unclear. What do you mean by "avoid
> division?"

"..to avoid 64-bit integer division."

> With those nits fixed up:
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> > +	inobt_records = (inode_records * 5) / (4 * XFS_INODES_PER_CHUNK);
> > +
> > +	/*
> > +	 * Allocate enough space to prefetch at least two inobt records so that
> > +	 * we can cache both the record where the iwalk started and the next
> > +	 * record.  This simplifies the AG inode walk loop setup code.
> > +	 */
> > +	return max(inobt_records, 2U);
> >  }
> >  
> >  /*
> > 
