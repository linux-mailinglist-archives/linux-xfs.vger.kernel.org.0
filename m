Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78E473BA49
	for <lists+linux-xfs@lfdr.de>; Mon, 10 Jun 2019 19:04:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728097AbfFJREl (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 10 Jun 2019 13:04:41 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:59898 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728096AbfFJREl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Jun 2019 13:04:41 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5AGxF3w042426;
        Mon, 10 Jun 2019 17:04:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=vNhGzWE9mLR64sDxJ7Wq8UNbn8PGhL0BI4j7KxpTZ1g=;
 b=0HK/EE10YJ4x1aBae797yV6lQWcpRluRxsoWBrtpj5pg6C+hPJDx2mRp4VvLjuKGJ+R6
 c4pPAmBAKgmC0IHT+0xhx/tgwY/nhouw1h5NWKtqey0wWUvTd5xLDfMROOpttbDGRb1R
 IZuAXh7oTb+V62hrrQPV+5fVDukN8drmbNMTouys4t7EPuLxkT1hz7aI7Vc52/gKNKvW
 c0Ds2m09uunfFrnBer/5xpmX4XvhZsrL4xUWU5QOEuyg7nRv4bb3GsS4NE1lkTyAq+Ft
 rjqaR4tQpcZwhm35dGEspkD7cgxggbipnHfKTId5PoQWZxQ4AV4Gxj+fQxLtBkrMIlbm vw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2t05nqg2ky-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Jun 2019 17:04:37 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5AH301K038720;
        Mon, 10 Jun 2019 17:04:36 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2t04hxvve7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Jun 2019 17:04:36 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5AH4ZZL024821;
        Mon, 10 Jun 2019 17:04:35 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 10 Jun 2019 10:04:35 -0700
Date:   Mon, 10 Jun 2019 10:04:34 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     "Theodore Ts'o" <tytso@mit.edu>, Eryu Guan <guaneryu@gmail.com>,
        Dave Chinner <david@fromorbit.com>,
        Olga Kornievskaia <olga.kornievskaia@gmail.com>,
        fstests <fstests@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v3 3/6] generic: copy_file_range swapfile test
Message-ID: <20190610170434.GJ1871505@magnolia>
References: <20190602124114.26810-1-amir73il@gmail.com>
 <20190602124114.26810-4-amir73il@gmail.com>
 <20190610035829.GA18429@mit.edu>
 <CAOQ4uxi-s6ncLGjh_u5x4DFK+dvcaobDCqup_ZV3mZOYDRuOEQ@mail.gmail.com>
 <20190610133131.GE15963@mit.edu>
 <20190610160616.GE1688126@magnolia>
 <CAOQ4uxiQsOTFO5f_aQWrmbSgSGuOy2wHoJbQAdWHrA1s-pZoHQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxiQsOTFO5f_aQWrmbSgSGuOy2wHoJbQAdWHrA1s-pZoHQ@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9284 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906100116
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9284 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906100116
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 10, 2019 at 07:54:52PM +0300, Amir Goldstein wrote:
> On Mon, Jun 10, 2019 at 7:06 PM Darrick J. Wong <darrick.wong@oracle.com> wrote:
> >
> > On Mon, Jun 10, 2019 at 09:31:31AM -0400, Theodore Ts'o wrote:
> > > On Mon, Jun 10, 2019 at 09:37:32AM +0300, Amir Goldstein wrote:
> > > >
> > > >Why do you think thhis is xfs_io fall back and not kernel fall back to
> > > >do_splice_direct()? Anyway, both cases allow read from swapfile
> > > >on upstream.
> > >
> > > Ah, I had assumed this was changed that was made because if you are
> > > implementing copy_file_range in terms of some kind of reflink-like
> > > mechanism, it becomes super-messy since you know have to break tons
> > > and tons of COW sharing each time the kernel swaps to the swap file.
> > >
> > > I didn't think we had (or maybe we did, and I missed it) a discussion
> > > about whether reading from a swap file should be prohibited.
> > > Personally, I think it's security theatre, and not worth the
> > > effort/overhead, but whatever.... my main complaint was with the
> > > unnecessary test failures with upstream kernels.
> > >
> > > > Trying to understand the desired flow of tests and fixes.
> > > > I agree that generic/554 failure may be a test/interface bug that
> > > > we should fix in a way that current upstream passes the test for
> > > > ext4. Unless there is objection, I will send a patch to fix the test
> > > > to only test copy *to* swapfile.
> > > >
> > > > generic/553, OTOH, is expected to fail on upstream kernel.
> > > > Are you leaving 553 in appliance build in anticipation to upstream fix?
> > > > I guess the answer is in the ext4 IS_IMMUTABLE patch that you
> > > > posted and plan to push to upstream/stable sooner than VFS patches.
> > >
> > > So I find it kind of annoying when tests land before the fixes do
> > > upstream.  I still have this in my global_exclude file:
> >
> > Yeah, it's awkward for VFS fixes because on the one hand we don't want
> > to have multiyear regressions like generic/484, but OTOH stuffing tests
> > in before code goes upstream enables broader testing by the other fs
> > maintainers.
> 
> And to prove this point, Ted pointed out a test bug in 554, which also
> affects the kernel and man pages fixes, so it was really worth it ;-)

:D

> >
> > In any case, the fixes are in the copy-range-fixes branch which I'm
> > finally publishing...
> >
> > > # The proposed fix for generic/484, "locks: change POSIX lock
> > > # ownership on execve when files_struct is displaced" would break NFS
> > > # Jeff Layton and Eric Biederman have some ideas for how to address it
> > > # but fixing it is non-trivial
> >
> > Also, uh, can we remove this from the auto and quick groups for now?
> >
> 
> I am not opposed to removing these test from auto,quick, although removing
> from quick is a bit shady. I would like to mark them explicitly with group
> known_issues, so that users can run ./check -g quick -x known_issues.
> BTW, overlay/061 is also a known_issue that is going to be hard to fix.
> 
> But anyway, neither 553 nor 554 fall into that category.

Sorry, I was unclear -- I was asking to remove g/484 from auto/quick.

--D

> Thanks,
> Amir.
