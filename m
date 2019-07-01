Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C29DE551D5
	for <lists+linux-xfs@lfdr.de>; Tue, 25 Jun 2019 16:36:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731034AbfFYOg4 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 25 Jun 2019 10:36:56 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:46908 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728710AbfFYOg4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Jun 2019 10:36:56 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5PETAgU165207;
        Tue, 25 Jun 2019 14:36:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=VTBOU++tT10/JKUqZ0AZDj8b75mj+0KTDdA5GO8183I=;
 b=20rIt2iCkQWF+TpGwvd50FtwIX2xYTR/tFIL8wdgmKUYJE+pPg39gf5yJab8oXoF5tWz
 AVy8sCi+5PHEgssDetvUXmYVDgCmWrPjAr+PuzBTqLoyQHh8IktVYKtgtLHdPXO9sQUQ
 Y8xx2MTIq01/nXbEGu2du7SoRZTHXbLVxX3maP6mXsemcfCWPLnECchVved1PbWYic4Z
 T2ITlTrPSca1FcSnl7k7bdVZdN8MEK/qJdnDgNtS1FUxFxnXyVofFlFnG89mIGPS09LL
 XeE9gg1Vs3xEUghoG6jaEB+sxwvU/C66e7DXTVQ36aT1Eza8SXi5pJ40vsRmrn27/BoZ wA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2t9cyqcqkd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jun 2019 14:36:17 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5PEZOpU007612;
        Tue, 25 Jun 2019 14:36:17 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2tat7c95bt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jun 2019 14:36:17 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5PEaGdH020318;
        Tue, 25 Jun 2019 14:36:16 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 25 Jun 2019 07:36:15 -0700
Date:   Tue, 25 Jun 2019 07:36:16 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Zorro Lang <zlang@redhat.com>
Cc:     guaneryu@gmail.com, fstests@vger.kernel.org,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs: test xfs_info on block device and mountpoint
Message-ID: <20190625143616.GD5380@magnolia>
References: <20190622153827.4448-1-zlang@redhat.com>
 <20190623214919.GD5387@magnolia>
 <20190624012103.GF30864@dhcp-12-102.nay.redhat.com>
 <20190625024546.GO15846@desktop>
 <20190625071639.GG30864@dhcp-12-102.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190625071639.GG30864@dhcp-12-102.nay.redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9299 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906250113
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9299 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906250113
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 25, 2019 at 03:16:39PM +0800, Zorro Lang wrote:
> On Tue, Jun 25, 2019 at 10:45:46AM +0800, Eryu Guan wrote:
> > On Mon, Jun 24, 2019 at 09:21:03AM +0800, Zorro Lang wrote:
> > > On Sun, Jun 23, 2019 at 02:49:19PM -0700, Darrick J. Wong wrote:
> > > > On Sat, Jun 22, 2019 at 11:38:27PM +0800, Zorro Lang wrote:
> > > > > There was a bug, xfs_info fails on a mounted block device:
> > > > > 
> > > > >   # xfs_info /dev/mapper/testdev
> > > > >   xfs_info: /dev/mapper/testdev contains a mounted filesystem
> > > > > 
> > > > >   fatal error -- couldn't initialize XFS library
> > > > > 
> > > > > xfsprogs has fixed it by:
> > > > > 
> > > > >   bbb43745 xfs_info: use findmnt to handle mounted block devices
> > > > > 
> > > > > Signed-off-by: Zorro Lang <zlang@redhat.com>
> > > > 
> > > > Aha!  I remembered something -- xfs/449 already checks for consistency
> > > > in the various xfs geometry reports that each command provides, so why
> > > > not just add the $XFS_INFO_PROG $SCRATCH_DEV case at the end?
> 
> Hmm... But I hope the case can keep running xfs_info test even there're not
> xfs_spaceman -c "info" or xfs_db -c "info", just skip these two steps. Due
> to RHEL-7 has old xfsprogs, we'd like to cover bug on RHEL-7.
> 
> What do you think?

If there isn't an xfs_db -c info command then xfs_info <blockev> won't
work because that's what it does internally.

Sooo unless you're backporting the new xfs_db info command to rhel7
xfsprogs as well as the new xfs_info wrapper, the test ought to just
_notrun on rhel7.

--D

> > > 
> > > Wow, there're so many cases, can't sure what we've covered now:)
> > > 
> > > Sure, I can do this change on xfs/449, if Eryu thinks it's fine to increase
> > > the test coverage of a known case.
> > 
> > Given that we're having more and more tests and the test time grows
> > quickly, I'm fine now with adding such small & similar test to existing
> > test case to reuse the test setups, especially when XFS maintainer
> > agrees to do so :)
> > 
> > Thanks,
> > Eryu
