Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEE413C12C
	for <lists+linux-xfs@lfdr.de>; Tue, 11 Jun 2019 04:12:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728717AbfFKCM1 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 10 Jun 2019 22:12:27 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:35192 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728685AbfFKCM0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Jun 2019 22:12:26 -0400
Received: by mail-pf1-f196.google.com with SMTP id d126so6385185pfd.2;
        Mon, 10 Jun 2019 19:12:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=fMTn/Iy6GueujryBwNtpy65Zx9EQLhL2NLjdOWA+Tzw=;
        b=CHHrF/rEweZMs70kk9FQ/jWGT08bovmt8dbmk9P1v9Rd2sVuYW89m41hScRgWTM2Yk
         AZd3FJTqjf1nwa0R7eJp1J1SX1AIIWrmMGSiNidijFDeO0ANiV6y3+8Wb+NKY5sKKnHF
         oJNDmbhJTy8P23y/pnR2NvjaYAQ5ZNz6l7V7TavGGLchNGHNEJy23iB9e7KG6QOlyK+J
         v+7m96zXUUFT880tQJxbnQmcRZe8p3ufpcoU4m5Da2/Mc4mH/G6mPjVW/q/VXHk2eSMh
         e6NMb8vCYTANDtuP6rp0J8u1Sw2u4/8qS8hrLQrr8R13lQLV03PxXOD9tBjUw0jjcmx/
         xBOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=fMTn/Iy6GueujryBwNtpy65Zx9EQLhL2NLjdOWA+Tzw=;
        b=cruWsQ9FzLoMsK6GiUvR3ro4exZLYl3jaWuHskfDCpGmV327rWDRjADNhu6GqJoRun
         NVJ1mKnT3f6kKQGKpdu6+u9C1PW5mBLNvREpmRE0o+F4ZV+J3GJi+79MubVK1ZHPUPPr
         R0kOHOPHUWrD3UFsEux+udi2q5jcVEI6w2ryBcf4nS2HFWYJ3NEvnBQPfgshm9nIeua1
         MrnV9uPbWteO0v80v5UGZVOt8Ml1g2sap2Wq3Vm9YHpwachE/pQA1J6yBu7S0ZNP00mf
         TRQ3sDaP5wemtUcujh3Tfree89ssjCKiM9t2CX6bQ0EBxgRtEFTC0OZ3tm9UtGiPVl51
         j54Q==
X-Gm-Message-State: APjAAAVPnUnyysybpSTHznYh6MbRNGAJaF/iHOjn3QqP6bTImmdfmYHZ
        moqBWRSTn99jYp/6PWC+Nyk=
X-Google-Smtp-Source: APXvYqz0E8mK4rjphSApPt3orEMSuTw9W3+7LaXJbDLYV4HTICtAwL7qxrq64pwZwpbHP5KESLa2IQ==
X-Received: by 2002:a62:7a8a:: with SMTP id v132mr54752511pfc.103.1560219145708;
        Mon, 10 Jun 2019 19:12:25 -0700 (PDT)
Received: from localhost ([47.254.35.144])
        by smtp.gmail.com with ESMTPSA id 188sm23178644pfe.30.2019.06.10.19.12.24
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 10 Jun 2019 19:12:24 -0700 (PDT)
Date:   Tue, 11 Jun 2019 10:12:22 +0800
From:   Eryu Guan <guaneryu@gmail.com>
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>,
        Olga Kornievskaia <olga.kornievskaia@gmail.com>,
        fstests <fstests@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v3 3/6] generic: copy_file_range swapfile test
Message-ID: <20190611021222.GY15846@desktop>
References: <20190602124114.26810-1-amir73il@gmail.com>
 <20190602124114.26810-4-amir73il@gmail.com>
 <20190610035829.GA18429@mit.edu>
 <CAOQ4uxi-s6ncLGjh_u5x4DFK+dvcaobDCqup_ZV3mZOYDRuOEQ@mail.gmail.com>
 <20190610133131.GE15963@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190610133131.GE15963@mit.edu>
User-Agent: Mutt/1.11.3 (2019-02-01)
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
> 
> # The proposed fix for generic/484, "locks: change POSIX lock
> # ownership on execve when files_struct is displaced" would break NFS
> # Jeff Layton and Eric Biederman have some ideas for how to address it
> # but fixing it is non-trivial
> generic/484
> 
> The generic/484 test landed in August 2018, and as far as I know, the
> issue which it is testing for *still* hasn't been fixed upstream.
> (There were issues raised with the proposed fix, and it looks like the
> people looking at the kernel change have lost interest.)

I usually push "known failing" tests only when there's a known & pending
fix which is expected to be merged into mainline kernel soon. And as
Darrick stated, "enables broader testing by the other fs maintainers."
and could bring broader attention of the failure.

But generic/484 is a bit unfortunate. It was in that exact situation
back then (or at least gave me the impression that the fix would be
merged soon), but apparaently things changed after test being applied..

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

I don't see generic/454 failing with ext4 (I'm testing with default
mkfs/mount options, kernel is 5.2-rc2). But IMHO, I think generic/454 is
different, it's not a targeted regression test, it's kind of generic
test that should work for all filesystems.

> 
> At the very *least* there should be a comment in the test that fix is
> pending, and might not be applied yet, with a URL to the mailing list
> discussion.  That will save effort when months (years?) go by, and the
> fix still hasn't landed the upstream kernel....

Agreed, I've been making sure there's a comment referring to the fix or
pending fix (e.g. only commit summary no hash ID) for such targeted
regression tests.

Thanks,
Eryu
