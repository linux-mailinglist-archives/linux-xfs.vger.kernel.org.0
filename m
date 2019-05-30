Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86DE530034
	for <lists+linux-xfs@lfdr.de>; Thu, 30 May 2019 18:32:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726045AbfE3QcH (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 30 May 2019 12:32:07 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:41742 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726079AbfE3QcH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 May 2019 12:32:07 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4UGSqAI089782;
        Thu, 30 May 2019 16:32:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=OSV2bdmqLVa8TL4f9p9+GWe2MSEkoMGVyuQgACvbAKM=;
 b=pTV0FKSLjTz2ryH23SYI1EVPxAFROYKZhf5ZUYKbE8V9iAW5vAep+gPesjkiPJP+Gqtq
 ZjeB0DiI/qniAFTVn6aTOon0mpar6iDGEbf/iH6V6xq7/GnB6a6lrsCPsC/aPqRnfpOI
 mS3yqj3lx71o1emR3uB+xF1UQQTz+fJScANpuV9oipCGVtySKHe56lufhWSMtq0s5Com
 zvZCJ6QL3dtUA7bLlIbymyA+t9lXJhCpwU52ZA1SjXImt61Mfkuhju1bfg0jNH/TIGFc
 2KcHhqwex+pvFqfgRzmt0rDHIqAxeSXLVjPPsU7kb7aJabaoYbYbvQmsLwoIgd0U6RNt Og== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2spxbqh66x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 May 2019 16:32:05 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4UGVPAN188376;
        Thu, 30 May 2019 16:32:04 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2ss1fp5xr0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 May 2019 16:32:04 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x4UGW3EO013094;
        Thu, 30 May 2019 16:32:03 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 30 May 2019 09:32:03 -0700
Date:   Thu, 30 May 2019 09:32:02 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH ] xfs: check for COW overflows in i_delayed_blks
Message-ID: <20190530163202.GD5383@magnolia>
References: <155839150599.62947.16097306072591964009.stgit@magnolia>
 <155839151219.62947.9627045046429149685.stgit@magnolia>
 <20190526142735.GP15846@desktop>
 <20190528170132.GA5231@magnolia>
 <20190530072023.GR15846@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190530072023.GR15846@desktop>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9272 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905300117
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9272 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905300117
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 30, 2019 at 03:20:23PM +0800, Eryu Guan wrote:
> On Tue, May 28, 2019 at 10:01:32AM -0700, Darrick J. Wong wrote:
> > On Sun, May 26, 2019 at 10:27:35PM +0800, Eryu Guan wrote:
> > > On Mon, May 20, 2019 at 03:31:52PM -0700, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > > 
> > > > With the new copy on write functionality it's possible to reserve so
> > > > much COW space for a file that we end up overflowing i_delayed_blks.
> > > > The only user-visible effect of this is to cause totally wrong i_blocks
> > > > output in stat, so check for that.
> > > > 
> > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > I hit xfs_db killed by OOM killer (2 vcpu, 8G memory kvm guest) when
> > > trying this test and the test takes too long time (I changed the fs size
> > > from 300T to 300G and tried a test run), perhaps that's why you don't
> > > put it in auto group?
> > 
> > Oh.  Right.  I forget that I patched out xfs_db from
> > check_xfs_filesystem on my dev tree years ago.
> > 
> > Um... do we want to remove xfs_db from the check function?  Or just open
> > code a call to xfs_repair $SCRATCH_MNT/a.img at the end of the test?
> 
> If XFS maintainer removes the xfs_check call in _check_xfs_filesystem(),
> I'd say I like to see it being removed :)

I tried to remove it last year[1] but Dave wanted us to precede that
with a comprehensive analysis of what corruptions are caught via
xfs_repair vs. xfs_check.  I haven't had time to do that.

> > As for the 300T size, the reason I picked that is to force the
> > filesystem to have large enough AGs to support the maximum cowextsize
> > hint.  I'll see if it still works with a 4TB filesystem.
> 
> After removeing the xfs_db call, I can finish the test within 20s on the
> same test vm, and a.img only takes 159MB space on $SCRATCH_DEV, so I
> think 300T fs size is fine.

Hm.  I /do/ have a separate patch banging around in my xfstests tree
that bumps up the oom score adjustment of a test (and lowers it for the
./check process).  One could do a similar thing to the post-test
filesystem check, though at some point the bash code becomes messy.

Or I guess we could just allow a hidden environment variable to turn off
xfs_db in _check_xfs_filesystem and call it explicitly from the test.
What do you all think about that?

--D

[1] https://patchwork.kernel.org/patch/10206103/

> 
> Thanks,
> Eryu
