Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61BD99EBD2
	for <lists+linux-xfs@lfdr.de>; Tue, 27 Aug 2019 17:05:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726140AbfH0PF0 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 27 Aug 2019 11:05:26 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:47746 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725920AbfH0PF0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Aug 2019 11:05:26 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7RExVbO112318;
        Tue, 27 Aug 2019 15:04:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=CaqxpG6cu/CuJIX0T78e9xrLKshNO7dTQ4gOrc5/XMw=;
 b=F13eePTZdr7qWPEogVVr1Hbby9SO8MJQHtea2D/L1j1EQsny/YKmdpnuXqnQPClf93rj
 nPyLLEi2SC3QzwKuOgzti91DVsP0ZhKMQn1mkTy/EOrJFdQrYCXaZgg8xckYRF9Ki9ZO
 bmjoWZDulMrb0U7r53pJWQxEaLCWg6eWsobcs+sjp6Ehl8U8HNKGYU4fyvJAfQcsKHNW
 nHAltugDKXOluFIlDaSLUGdbI6TzRU961xfmh4uc4o0rJPRKCzcr8LaSDg65Hyz3wtXX
 FkoGQZv12o2kFzfuXCO3diXiamVEi852Y4JbnyT5vVpCJkg6wpeR/zsHcOTh6iNsOOJE sw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2un6qtr24u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Aug 2019 15:04:59 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7REwFAf185819;
        Tue, 27 Aug 2019 15:04:58 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2umhu8v33h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Aug 2019 15:04:58 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7RF4pAt022987;
        Tue, 27 Aug 2019 15:04:53 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 27 Aug 2019 08:04:51 -0700
Date:   Tue, 27 Aug 2019 08:04:51 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Eryu Guan <guaneryu@gmail.com>,
        Christoph Hellwig <hch@infradead.org>,
        xfs <linux-xfs@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>,
        Salvatore Bonaccorso <carnil@debian.org>,
        Security Officers <security@kernel.org>,
        Debian Security Team <team@security.debian.org>,
        benjamin.moody@gmail.com, Ben Hutchings <benh@debian.org>,
        fstests <fstests@vger.kernel.org>
Subject: Re: [PATCH v2] generic: test for failure to unlock inode after chgrp
 fails with EDQUOT
Message-ID: <20190827150451.GY1037350@magnolia>
References: <20190827041816.GB1037528@magnolia>
 <alpine.DEB.2.21.1908270811030.1939@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.1908270811030.1939@nanos.tec.linutronix.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9362 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908270155
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9362 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908270155
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 27, 2019 at 08:13:19AM +0200, Thomas Gleixner wrote:
> On Mon, 26 Aug 2019, Darrick J. Wong wrote:
> > +++ b/tests/generic/719
> > @@ -0,0 +1,59 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0-or-newer
> 
> Please run scripts/spdxcheck.py on that file and consult the licensing
> documentation.

-or-later, sorry.

So .... now that everyone who wanted these SPDX identifiers have spread
"GPL-2.0+" around the kernel and related projects (xfsprogs, xfstests)
just in time for SPDX 3.0 to deprecate the "+" syntax, what are we
supposed to do?  Another treewide change to fiddle with SPDX syntax?
Can we just put:

Valid-License-Identifier: GPL-2.0+
Valid-License-Identifier: GPL-2.0-or-later

in the LICENSES/GPL-2.0 file like the kernel does?

Is that even going to stay that way?  I thought I heard that Greg was
working on phasing out the "2.0+" tags since SPDX deprecated that?

I think xfsprogs and xfstests just follow whatever the kernel does, but
AFAICT this whole initiative /continues/ to communicate poorly with the
maintainers about (1) how this is supposed to benefit us and (2) what we
are supposed to do to maintain all of it.

Do we have to get lawyers involved to roll to a new SPDX version?  Will
LF do that for (at least) the projects hosted on kernel.org?  Should we
just do it and hope for the best since IANAFL?  I know how to review
code.  I don't know how to review licensing and all the tiny
implications that go along with things like this.  I don't even feel
confident that the two identifiers above are exactly the same, because
all I know is that I read it on a webpage somewhere.

I for one still have heard abso-f*cking-lutely nothing about what is
this SPDX change other than Greg shoving treewide changes in the kernel.
That sufficed to get the mechanical work done (at the cost of a lot of
frustration for Greg) but this doesn't help me sustain our community.

Guidance needed.  Apologies all around if this rant is misdirected, but
I have no idea who (if anyone) is maintaining SPDX tags.  There's no
entry for LICENSES/ in MAINTAINERS, which is where I looked first.

--D

> Thanks,
> 
> 	tglx
