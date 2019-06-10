Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34F1E3B8F9
	for <lists+linux-xfs@lfdr.de>; Mon, 10 Jun 2019 18:06:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391445AbfFJQG2 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 10 Jun 2019 12:06:28 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:32936 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391391AbfFJQG2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Jun 2019 12:06:28 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5AFwmIp002646;
        Mon, 10 Jun 2019 16:06:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=NWkvhza8ynvwYsC1qZewWsp0B55TEdAikKlFfUPZE+Y=;
 b=ZEWmYPZuzha19t0R8ZmPL9bb5nk2gqbHipWQREDmwMXTokojAQrD6pweQwmu9rDM7SXv
 CZLsnXAHWK2JUCQtb7xYY2uB9mfCPsHGuWQ6ljaJsnSIRIMN9Apn53L7Fe0KaR/6SW+Z
 ony4vGg8ynOzuPKEdBqt1jsGK3nhHQ4AmaUd6BthbJrC+NwcE6eypWL+fX3p/HZL+7Od
 edAdBfUX9vtMUAL0Ox5b3prbgtLFeAfSRPQ8om3Gufme47m/oAtsZrhJF7pIo5EOjJca
 xXEt92Yd8b6RB7ZLlxHLXIOTfCMZD2QxBvWRWZGrJMpxmpAVNqP9T1pOTekPZ/HpH8xT Ow== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 2t02heg0ts-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Jun 2019 16:06:21 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5AG4k37018174;
        Mon, 10 Jun 2019 16:06:21 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2t1jpgxwty-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Jun 2019 16:06:21 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5AG6Krc008538;
        Mon, 10 Jun 2019 16:06:20 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 10 Jun 2019 09:06:19 -0700
Date:   Mon, 10 Jun 2019 09:06:16 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     "Theodore Ts'o" <tytso@mit.edu>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        Eryu Guan <guaneryu@gmail.com>,
        Dave Chinner <david@fromorbit.com>,
        Olga Kornievskaia <olga.kornievskaia@gmail.com>,
        fstests <fstests@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v3 3/6] generic: copy_file_range swapfile test
Message-ID: <20190610160616.GE1688126@magnolia>
References: <20190602124114.26810-1-amir73il@gmail.com>
 <20190602124114.26810-4-amir73il@gmail.com>
 <20190610035829.GA18429@mit.edu>
 <CAOQ4uxi-s6ncLGjh_u5x4DFK+dvcaobDCqup_ZV3mZOYDRuOEQ@mail.gmail.com>
 <20190610133131.GE15963@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190610133131.GE15963@mit.edu>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9284 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906100109
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9284 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906100109
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 10, 2019 at 09:31:31AM -0400, Theodore Ts'o wrote:
> On Mon, Jun 10, 2019 at 09:37:32AM +0300, Amir Goldstein wrote:
> >
> >Why do you think thhis is xfs_io fall back and not kernel fall back to
> >do_splice_direct()? Anyway, both cases allow read from swapfile
> >on upstream.
> 
> Ah, I had assumed this was changed that was made because if you are
> implementing copy_file_range in terms of some kind of reflink-like
> mechanism, it becomes super-messy since you know have to break tons
> and tons of COW sharing each time the kernel swaps to the swap file.
> 
> I didn't think we had (or maybe we did, and I missed it) a discussion
> about whether reading from a swap file should be prohibited.
> Personally, I think it's security theatre, and not worth the
> effort/overhead, but whatever.... my main complaint was with the
> unnecessary test failures with upstream kernels.
> 
> > Trying to understand the desired flow of tests and fixes. 
> > I agree that generic/554 failure may be a test/interface bug that
> > we should fix in a way that current upstream passes the test for
> > ext4. Unless there is objection, I will send a patch to fix the test
> > to only test copy *to* swapfile.
> > 
> > generic/553, OTOH, is expected to fail on upstream kernel.
> > Are you leaving 553 in appliance build in anticipation to upstream fix?
> > I guess the answer is in the ext4 IS_IMMUTABLE patch that you
> > posted and plan to push to upstream/stable sooner than VFS patches.
> 
> So I find it kind of annoying when tests land before the fixes do
> upstream.  I still have this in my global_exclude file:

Yeah, it's awkward for VFS fixes because on the one hand we don't want
to have multiyear regressions like generic/484, but OTOH stuffing tests
in before code goes upstream enables broader testing by the other fs
maintainers.

In any case, the fixes are in the copy-range-fixes branch which I'm
finally publishing...

> # The proposed fix for generic/484, "locks: change POSIX lock
> # ownership on execve when files_struct is displaced" would break NFS
> # Jeff Layton and Eric Biederman have some ideas for how to address it
> # but fixing it is non-trivial

Also, uh, can we remove this from the auto and quick groups for now?

--D

> generic/484
> 
> The generic/484 test landed in August 2018, and as far as I know, the
> issue which it is testing for *still* hasn't been fixed upstream.
> (There were issues raised with the proposed fix, and it looks like the
> people looking at the kernel change have lost interest.)
> 
> The problem is that there are people who are trying to use xfstests to
> look for failures, and unless they start digging into the kernel
> archives from last year, they won't understand that generic/484 is a
> known failing test, and it will get fixed....someday.
> 
> For people in the know, or for people who use my kvm-xfstests,
> gce-xfstests, it's not a big problem, since I've already blacklisted
> the test.  But not everyone (and in fact, probably most people don't)
> use my front end scripts.
> 
> For generic/553, I have a fix in ext4 so it will clear the failure,
> and that's fine, since I think we've all agreed in principle what the
> correct fix will be, and presumably it will get fixed soon.  At that
> point, I might revert the commit from ext4, and rely on the VFS to
> catch the error, but the overhead of a few extra unlikely() tests
> aren't that big.  But yeah, I did that mainly because unnecessary test
> failures because doing an ext4-specific fix didn't have many
> downsides, and one risk of adding tests to the global exclude file is
> that I then have to remember to remove it from the global exclude file
> when the issue is finally fixed upstream.
> 
> > Do you think that should there be a different policy w.r.t timing of
> > merging xfstests tests that fail on upstream kernel?
> 
> That's my opinion, and generic/484 is the best argument for why we
> should wait.  Other people may have other opinions though, and I have
> a workaround, so I don't feel super-strong about it.  (generic/454 is
> now the second test in my global exclude file.  :-)
> 
> At the very *least* there should be a comment in the test that fix is
> pending, and might not be applied yet, with a URL to the mailing list
> discussion.  That will save effort when months (years?) go by, and the
> fix still hasn't landed the upstream kernel....
> 
> 	       	       	      	      - Ted
