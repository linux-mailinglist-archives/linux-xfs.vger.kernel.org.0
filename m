Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03A617DD32
	for <lists+linux-xfs@lfdr.de>; Thu,  1 Aug 2019 16:02:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730800AbfHAOCH (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 1 Aug 2019 10:02:07 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:33432 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730502AbfHAOCH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Aug 2019 10:02:07 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x71DsR6i099838;
        Thu, 1 Aug 2019 14:01:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=XlGn0cwJoXM/sV5dKAaqiZSVeBlO/QiXzSYnv+4yGAE=;
 b=JTeOJ0KwjvDmq2VoTBsOyLU86sE0IWcv/oUG+qdS0r1vv0+LCxMq0eveIBAdFrSJYc3H
 2xJllbzLhp+XyxltaOOZjTDJv+JMKuJm5wmeWq8qH5IvicnA/B1NxGAQURGf5if2DtoE
 sAA+5s7w5E9pGpndS6v2934Dso/bxOJ86ojamiCi6DLKyXlEgofBpjGOhNSeVT4wGfIA
 8D/qbN27Xxsazb7M5NfM+SLIxjjiZDTUNYAPMogjhnlVkZuQoxCUwhHmLse6hWCQ8qng
 LiYbzO3cMYnK8F/VTc/4RCnkB1iVTTT05MghYil60CYxuOk33ydRXlFfLCLhByu4kuGD 2g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2u0e1u496n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Aug 2019 14:01:49 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x71DwES0163037;
        Thu, 1 Aug 2019 14:01:49 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2u38fbqckv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Aug 2019 14:01:49 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x71E1mpJ007066;
        Thu, 1 Aug 2019 14:01:48 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 01 Aug 2019 07:01:48 -0700
Date:   Thu, 1 Aug 2019 07:01:46 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 5/5] xfs: test new v5 bulkstat commands
Message-ID: <20190801140146.GC1561054@magnolia>
References: <156462375516.2945299.16564635037236083118.stgit@magnolia>
 <156462379043.2945299.17354996626313190310.stgit@magnolia>
 <20190801104814.GC59093@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190801104814.GC59093@bfoster>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9335 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908010146
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9335 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908010146
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 01, 2019 at 06:48:15AM -0400, Brian Foster wrote:
> On Wed, Jul 31, 2019 at 06:43:10PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Check that the new v5 bulkstat commands do everything the old one do,
> > and then make sure the new functionality actually works.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  .gitignore                 |    1 
> >  src/Makefile               |    2 
> >  src/bulkstat_null_ocount.c |   61 +++++++++
> >  tests/xfs/744              |  215 ++++++++++++++++++++++++++++++++
> >  tests/xfs/744.out          |  297 ++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/745              |   47 +++++++
> >  tests/xfs/745.out          |    2 
> >  tests/xfs/group            |    2 
> >  8 files changed, 626 insertions(+), 1 deletion(-)
> >  create mode 100644 src/bulkstat_null_ocount.c
> >  create mode 100755 tests/xfs/744
> >  create mode 100644 tests/xfs/744.out
> >  create mode 100755 tests/xfs/745
> >  create mode 100644 tests/xfs/745.out
> > 
> > 
> ...
> > diff --git a/tests/xfs/group b/tests/xfs/group
> > index 270d82ff..ef0cf92c 100644
> > --- a/tests/xfs/group
> > +++ b/tests/xfs/group
> > @@ -506,3 +506,5 @@
> >  506 auto quick health
> >  507 clone
> >  508 auto quick quota
> > +744 auto ioctl quick
> > +745 auto ioctl quick
> > 
> 
> One quick note that xfs/744 runs in ~68 seconds in my (low resource)
> test VM. Not a problem in and of itself, but it seems slightly long for
> the quick group. Can somebody remind me of the quick group criteria?
> 
> FWIW if I kick off a quick group run, the first 10-15 tests complete in
> 10s or so or less with the exception of generic/013, which takes over a
> minute. So perhaps anything under a minute or so is fine..? Either way,
> that can be easily changed on merge if appropriate:

Hmm, yeah, that's probably too slow for quick...

> Reviewed-by: Brian Foster <bfoster@redhat.com>

Thanks for the review!

--D
