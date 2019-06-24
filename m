Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B7F651028
	for <lists+linux-xfs@lfdr.de>; Mon, 24 Jun 2019 17:19:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729222AbfFXPTU (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 24 Jun 2019 11:19:20 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:38070 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726414AbfFXPTU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jun 2019 11:19:20 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5OFE7BH169773;
        Mon, 24 Jun 2019 15:19:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=YuwWc0/LElXuwH+t4A0zQc6RQB/x9mfZDbbXxMWVn5c=;
 b=D0Wis4A5DBhmWI08Bhar+R8XrNIUNn2VmlGNeHzYbyLOnceMahb/5KDzRjIbDdTOc2TT
 ssF1s5byh+Tde/+puO5scITI+R5ySmdpOuzsCwFSRR7gFlyDCnNjQ7OnliYmxzXPlIiJ
 tGLnQ/TiizD2RuqT8ip6kc+Ex10SB2F6h2s9pkrQf/rU/f6B1gmGYyW3szOIrW4Ufgo9
 awVETFPMoGlhwwAhZEGGSDEn5q7Xx3gTO6j8TA2CYtauDIiLFZeH+xDxbXcuOQoBqSgN
 55tFvytKjBEJfaCmjTrcy2qOgVo4EgwyWenZ9AyT5hnAzAXj7CrJ7as5r0+rSh0UgCUH qw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2t9c9pf1e7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Jun 2019 15:19:13 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5OFHtgm109986;
        Mon, 24 Jun 2019 15:19:12 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2t99f3b5gv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Jun 2019 15:19:12 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5OFJBog020999;
        Mon, 24 Jun 2019 15:19:12 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 24 Jun 2019 08:19:11 -0700
Date:   Mon, 24 Jun 2019 08:19:10 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     "Theodore Ts'o" <tytso@mit.edu>
Cc:     Christoph Hellwig <hch@lst.de>, fstests@vger.kernel.org,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH] shared/011: run on all file system that support cgroup
 writeback
Message-ID: <20190624151910.GJ5387@magnolia>
References: <20190624134407.21365-1-hch@lst.de>
 <20190624150839.GB6350@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190624150839.GB6350@mit.edu>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9298 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906240123
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9298 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906240123
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 24, 2019 at 11:08:39AM -0400, Theodore Ts'o wrote:
> On Mon, Jun 24, 2019 at 03:44:07PM +0200, Christoph Hellwig wrote:
> > Run the cgroup writeback test on xfs, for which I've just posted
> > a patch to support cgroup writeback as well as ext2 and f2fs, which
> > have supported cgroup writeback for a while now.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  tests/shared/011 | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/tests/shared/011 b/tests/shared/011
> > index a0ac375d..96ce9d1c 100755
> > --- a/tests/shared/011
> > +++ b/tests/shared/011
> > @@ -39,7 +39,7 @@ rm -f $seqres.full
> >  # real QA test starts here
> >  
> >  # Modify as appropriate.
> > -_supported_fs ext4 btrfs
> > +_supported_fs ext2 ext4 f2fs btrfs xfs
> 
> Per my comments in another e-mail thread, given how many of the
> primary file systems support cgroup-aware writeback, maybe we should
> just remove the _supported_fs line and move this test to generic?
> 
> Whether we like it or not, there are more and more userspace tools
> which assume that cgroup-aware writeback is a thing.
> 
> Alternatively, maybe we should have some standardized way so the
> kernel can signal whether or not a particular mounted file system
> supports cgroup-aware writeback?

I prefer this second option because I'd rather the test suite do the
work to figure out if cgroup aware writeback is enabled and therefore
worth testing rather than making everyone's QA department to add another
conditional known-failure entry for when they want to run new fstests on
some old LTS/distro kernel.

--D

> 						- Ted
