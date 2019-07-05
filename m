Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B41C560B43
	for <lists+linux-xfs@lfdr.de>; Fri,  5 Jul 2019 19:57:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726568AbfGER5q (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 5 Jul 2019 13:57:46 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:57022 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726116AbfGER5q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Jul 2019 13:57:46 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x65Hs8R7095745;
        Fri, 5 Jul 2019 17:57:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=EvyU+dx50uQsGC9xJxvy0v6ajpg2N1Cx9VeIvNl54WM=;
 b=IxxlV9MJlgNXlQfgseGNsiBQ76ZDhyQniyLep3jQF0NczC9DQU+YQ0T/FtRJhfPiiQWP
 W6v3dbCdXpoYMLTQseuL7jb2ggv5jLGXQ3A0RNslJmSbBltTh9gBXHWYO0DRQ1Su56CR
 jlZUzngKCHyN30nX5QkoL5htUfwHCv1C9Wl7/Th28OvevFYzdaOfT6V/j3lIaoRLKb5H
 yz0mFWp1kDfN4YrEVUznxS5sYTtRXSKMe41mu5+6VF9JNS8a6fcN9uyUWHeszgKjDtJS
 8uZU24Jbcw2X5k8fQRe39QVBLsncqtgps5NsQHxn167Vg5NcbqYE38P0gHBiwS8tc0JA Lw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2te5tc432h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Jul 2019 17:57:38 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x65Hvc4j175720;
        Fri, 5 Jul 2019 17:57:38 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2th9ecj296-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Jul 2019 17:57:37 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x65HvaPg017816;
        Fri, 5 Jul 2019 17:57:36 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 05 Jul 2019 10:57:36 -0700
Date:   Fri, 5 Jul 2019 10:57:35 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/6] xfs: online scrub needn't bother zeroing its
 temporary buffer
Message-ID: <20190705175735.GL1404256@magnolia>
References: <156158199378.495944.4088787757066517679.stgit@magnolia>
 <156158203074.495944.13142136337107091755.stgit@magnolia>
 <20190705145246.GH37448@bfoster>
 <20190705163504.GE1404256@magnolia>
 <20190705172639.GJ37448@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190705172639.GJ37448@bfoster>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9309 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907050223
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9309 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907050222
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 05, 2019 at 01:26:39PM -0400, Brian Foster wrote:
> On Fri, Jul 05, 2019 at 09:35:04AM -0700, Darrick J. Wong wrote:
> > On Fri, Jul 05, 2019 at 10:52:46AM -0400, Brian Foster wrote:
> > > On Wed, Jun 26, 2019 at 01:47:10PM -0700, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > > 
> > > > The xattr scrubber functions use the temporary memory buffer either for
> > > > storing bitmaps or for testing if attribute value extraction works.  The
> > > > bitmap code always zeroes what it needs and the value extraction merely
> > > > sets the buffer contents (we never read the contents, we just look for
> > > > return codes), so it's not necessary to waste CPU time zeroing on
> > > > allocation.
> > > > 
> > > 
> > > If we don't need to zero the buffer because we never look at the result,
> > > that suggests we don't need to populate it in the first place right?
> > 
> > We still need to read the attr value into the buffer (at least for
> > remote attr values) because scrub doesn't otherwise check the remote
> > attribute block header.
> > 
> > We never read the contents (because the contents are just arbitrary
> > bytes) but we do need to be able to catch an EFSCORRUPTED if, say, the
> > attribute dabtree points at a corrupt block.
> > 
> 
> Ok.. what I'm getting at here is basically wondering if since the buffer
> zeroing was noticeable in performance traces, whether the xattr value
> memory copy might be similarly noticeable for certain datasets (many
> large xattrs?). I suppose that may be less prominent if the buffer
> alloc/zero was unconditional as opposed to tied to the existence of an
> actual xattr, but that doesn't necessarily mean the performance impact
> is zero.
> 
> If non-zero, it might be interesting to explore whether some sort of
> lookup interface makes sense for xattrs that essentially do everything
> we currently do via xfs_attr_get() except read the attr. Presumably we
> could avoid the memory copy along with the buffer allocation in that
> case. But that's just a random thought for future consideration,
> certainly not low handing fruit as is this patch. If you have a good
> scrub performance test, an easy experiment might be to run it with a
> hack to skip the buffer allocation, pass a NULL buffer and
> conditionalize the ->value accesses/copies in the xattr code to avoid
> explosions and see whether there's any benefit.

Ahhh, yes.  Currently for flame graph analysis I just use perf record +
Brendan Gregg's flamegraph tools to spit out a svg and then go digging
into any call stack is wide and not especially conical.  I hadn't really
noticed the actual attr value copyout but that's only because it tends
to get lost in the noise of parsing through attr leaves and whatnot.

However, it does sound like a nice shortcut to be able to set
xfs_da_args.value = NULL and have the attr value code go through the
motions of extracting the value but skipping the memcpy part.

Will put this on my list of things to study for 5.4. :)

--D

> > > > A flame graph analysis showed that we were spending 7% of a xfs_scrub
> > > > run (the whole program, not just the attr scrubber itself) allocating
> > > > and zeroing 64k segments needlessly.
> > > > 
> > > 
> > > How much does this patch help?
> > 
> > About 1-2% I think.  FWIW the "7%" figure represents the smallest
> > improvement I saw in runtimes, where allocation ate 1-2% of the runtime
> > and zeroing accounts for the rest (~5-6%).
> > 
> > Practically speaking, when I retested with NVME flash instead of
> > spinning rust then the improvement jumped to 15-20% overall.
> > 
> 
> Nice!
> 
> Brian
> 
> > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > > ---
> > > >  fs/xfs/scrub/attr.c |    7 ++++++-
> > > >  1 file changed, 6 insertions(+), 1 deletion(-)
> > > > 
> > > > 
> > > > diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
> > > > index 09081d8ab34b..d3a6f3dacf0d 100644
> > > > --- a/fs/xfs/scrub/attr.c
> > > > +++ b/fs/xfs/scrub/attr.c
> > > > @@ -64,7 +64,12 @@ xchk_setup_xattr_buf(
> > > >  		sc->buf = NULL;
> > > >  	}
> > > >  
> > > > -	ab = kmem_zalloc_large(sizeof(*ab) + sz, flags);
> > > > +	/*
> > > > +	 * Allocate the big buffer.  We skip zeroing it because that added 7%
> > > > +	 * to the scrub runtime and all the users were careful never to read
> > > > +	 * uninitialized contents.
> > > > +	 */
> > > 
> > > Ok, that suggests the 7% hit was due to zeroing (where the commit log
> > > says "allocating and zeroing"). Either way, we probably don't need such
> > > details in the code. Can we tweak the comment to something like:
> > > 
> > > /*
> > >  * Don't zero the buffer on allocation to avoid runtime overhead. All
> > >  * users must be careful never to read uninitialized contents.
> > >  */ 
> > 
> > Ok, I'll do that.
> > 
> > Thanks for all the review! :)
> > 
> > --D
> > 
> > > 
> > > With that:
> > > 
> > > Reviewed-by: Brian Foster <bfoster@redhat.com>
> > > 
> > > > +	ab = kmem_alloc_large(sizeof(*ab) + sz, flags);
> > > >  	if (!ab)
> > > >  		return -ENOMEM;
> > > >  
> > > > 
