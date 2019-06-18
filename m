Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F5734AA62
	for <lists+linux-xfs@lfdr.de>; Tue, 18 Jun 2019 20:54:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730435AbfFRSyi (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 18 Jun 2019 14:54:38 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:55840 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730429AbfFRSyi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Jun 2019 14:54:38 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5IIs2eU142784;
        Tue, 18 Jun 2019 18:54:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=c/pe3oBecZH6DcCx8A279ezKk1ZyY+l0QKGEIfHwbag=;
 b=tJQtXLe+TUesmgSkwF23b+xl6B5e+Kt5/c6qz5VpUTmin7W9NcCOJjadYauYaGMUzs9T
 O1qV75RwMK1rVey+l8ldLJOf4QeWjf7ySD9xhORobk54iTepSbeCyvqykh30ZevAU8A5
 c8lUsQcjPJwK8fCSqFn2qchCibXKcE/+u27cl3QLEtKOFyjWvb77Hk0e47kAbFTv4d7c
 PB869NBmJyW8vW5vk/ghW95eV0i6NJQjstHphFibXEfNJbQwqAp6zuL2Eps0MZg6/6Y2
 4+ZdPXmiA6BX79uupZ2iIAENKcjgfY/JZu/UNSmSXUXES4gFXG7G/C/AoHiOw/k6ox6S Gg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2t4saqe86h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jun 2019 18:54:35 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5IIrZ4d164243;
        Tue, 18 Jun 2019 18:54:35 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2t59ge0x9m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jun 2019 18:54:34 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5IIsXtX013356;
        Tue, 18 Jun 2019 18:54:33 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 18 Jun 2019 11:54:33 -0700
Date:   Tue, 18 Jun 2019 11:54:32 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/9] libxfs: break out the GETXATTR/SETXATTR manpage
Message-ID: <20190618185432.GH5387@magnolia>
References: <155993574034.2343530.12919951702156931143.stgit@magnolia>
 <155993574662.2343530.11024375240678275350.stgit@magnolia>
 <1def4f4f-e938-76e2-2583-a07fc18b3ed8@sandeen.net>
 <20190615164332.GL3773859@magnolia>
 <d1930542-58e7-1709-3847-fe688b08d256@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d1930542-58e7-1709-3847-fe688b08d256@sandeen.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9292 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906180149
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9292 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906180149
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 17, 2019 at 09:55:44AM -0500, Eric Sandeen wrote:
> On 6/15/19 11:43 AM, Darrick J. Wong wrote:
> > On Fri, Jun 14, 2019 at 04:17:10PM -0500, Eric Sandeen wrote:
> >> On 6/7/19 2:29 PM, Darrick J. Wong wrote:
> >>> From: Darrick J. Wong <darrick.wong@oracle.com>
> >>>
> >>> Break out the xfs file attribute get and set ioctls into a separate
> >>> manpage to reduce clutter in xfsctl.
> >>
> >> <comes up for air>
> >>
> >> Now that we've uh, hoisted it to be a generic vfs interface,
> >> FS_IOC_FSGETXATTR, shouldn't we be documenting it as that instead
> >> of the (old) xfs variant?
> > 
> > No, first we document the old xfs ioctl, then we move the manpage over
> > to the main man-pages.git project as the vfs ioctl, and then we update
> > the xfsprogs manpage to say "Please refer to the VFS documentation but
> > in case your system doesn't have it, here you go..." :)
> 
> I guess it's kind of a sad state of affairs that I'm not quite sure
> if this is serious.  :)

It is, because the other implementers of this ioctl are not maintaining
the same behavior as xfs.  The first step to doing that is to document
our behaviors, and then get the code under testing.

Granted, those users (ext4/f2fs) aren't using most of the fields or
flags anyway so there's not a lot to test...

--D

> >>
> >> (honestly that'd be mostly just search and replace for this patch)
> >>
> >> Except of course XFS_IOC_FSGETXATTRA has no vfs variant.  :/
> >>
> >> I also wonder if FS_IOC_SETFLAGS should be mentioned, and/or a
> >> SEE_ALSO because some of the functionality overlaps?
> > 
> > Oh, wow, there's actually a manpage for it...
> > 
> > ...bleh, it's the weekend, I'll respond to the rest later.
> 
> ok thanks
> 
> -Eric
