Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C7D02D40A
	for <lists+linux-xfs@lfdr.de>; Wed, 29 May 2019 05:00:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725847AbfE2DAN (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 28 May 2019 23:00:13 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:39086 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725816AbfE2DAN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 May 2019 23:00:13 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4T2nXUq061293;
        Wed, 29 May 2019 03:00:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=M1C1XlmeJK1+DaVuqrYx9BXYK7AKTis9bvUkW2Lsgyo=;
 b=r6OOdfR3KnTokaH0MEjpav8LhQrc166nYfk9b/dCZk+A+zmtxO7aYXLkvCOA0QZbCMxJ
 G6vC2gmcwBqt1sX1gM0l1RMnJQ6DgnzUoAxQeK6wwz1RHkXzPKmJMYr2WjvLwq354MPX
 l7KTvHQDSJahFd1kezWeQybtLJ2BIIkFTfqMw1O5g1hrwkGtjjq83rbaM2hYzBKkiQ9w
 FSMqKKgPm1/9Gf7BxcfSFhLpF9SXh8XdE1uL9C2rNPjnqc0YGzDs76qX9vXQSLY51Tc2
 kDw1w15hi2TOy64jYorFdgtWxfIaYltce+OmC2/OqZ6/Ge/+dnZLuypZz2ybTWn5AE1F MA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 2spu7df2sd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 May 2019 03:00:04 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4T2xqjt091102;
        Wed, 29 May 2019 03:00:03 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2srbdx4n6r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 May 2019 03:00:03 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x4T303m8030171;
        Wed, 29 May 2019 03:00:03 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 28 May 2019 20:00:02 -0700
Date:   Tue, 28 May 2019 20:00:01 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Eryu Guan <guaneryu@gmail.com>, Dave Chinner <david@fromorbit.com>,
        fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 0/5] fstests: copy_file_range() tests
Message-ID: <20190529030001.GC5244@magnolia>
References: <20190526084535.999-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190526084535.999-1-amir73il@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9271 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905290017
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9271 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905290017
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, May 26, 2019 at 11:45:30AM +0300, Amir Goldstein wrote:
> Eryu,
> 
> This is a re-work of Dave Chinner's copy_file_range() tests which
> I used to verify the kernel fixes of the syscall [1].
> 
> I split out the single bounds test by Dave to 4 tests.
> immutable and swap file copy have specific requiremenet which many
> filesystems do not meet (e.g. cifs,nfs,ceph,overlayfs), so those
> test cases were split to individual test to allow better bounds test
> converage for all filesystems.
> 
> The 3 first tests fix bugs in the interface, so they are appropriate
> for merge IMO. The last test (cross-device copy) tests a new
> functionality, so you may want to wait with merge till after the work
> is merged upstream.

The tests mostly look ok to me...

> NOTE that the bounds check test depend on changes that have been merged
> to xfsprogs v4.20. Without those changes the test will hang!

Is that the requirement for opening pipes in nonblocking mode?

If so... that ought to be a separate test (or at least a separate part
of the test) that can be skipped if we detect an old xfs_io.

> I used an artificial requirement _require_xfs_io_command "chmod" to
> skip the test with old xfs_io. I welcome suggestions for better way to
> handle this issue.

Grepping manpages? :D

--D

> 
> Thanks,
> Amir.
> 
> Changes from v1:
> - Remove patch to test EINVAL behavior instead of short copy
> - Remove 'chmod -r' permission drop test case
> - Split out test for swap/immutable file copy
> - Split of cross-device copy test
> 
> [1] https://lore.kernel.org/linux-fsdevel/20190526061100.21761-1-amir73il@gmail.com/
> 
> Amir Goldstein (5):
>   generic: create copy_range group
>   generic: copy_file_range immutable file test
>   generic: copy_file_range swapfile test
>   generic: copy_file_range bounds test
>   generic: cross-device copy_file_range test
> 
>  tests/generic/434     |   2 +
>  tests/generic/988     |  59 ++++++++++++++++++++
>  tests/generic/988.out |   5 ++
>  tests/generic/989     |  56 +++++++++++++++++++
>  tests/generic/989.out |   4 ++
>  tests/generic/990     | 123 ++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/990.out |  37 +++++++++++++
>  tests/generic/991     |  56 +++++++++++++++++++
>  tests/generic/991.out |   4 ++
>  tests/generic/group   |  14 +++--
>  10 files changed, 355 insertions(+), 5 deletions(-)
>  create mode 100755 tests/generic/988
>  create mode 100644 tests/generic/988.out
>  create mode 100755 tests/generic/989
>  create mode 100644 tests/generic/989.out
>  create mode 100755 tests/generic/990
>  create mode 100644 tests/generic/990.out
>  create mode 100755 tests/generic/991
>  create mode 100644 tests/generic/991.out
> 
> -- 
> 2.17.1
> 
