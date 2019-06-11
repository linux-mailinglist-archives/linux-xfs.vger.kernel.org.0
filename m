Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58E7F3C12D
	for <lists+linux-xfs@lfdr.de>; Tue, 11 Jun 2019 04:13:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728791AbfFKCNL (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 10 Jun 2019 22:13:11 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:39711 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728685AbfFKCNL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Jun 2019 22:13:11 -0400
Received: by mail-pl1-f195.google.com with SMTP id g9so4393693plm.6;
        Mon, 10 Jun 2019 19:13:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=FDka2LomCCjzKUDoyHkQuynLln8lqOKoER8acK9H1YA=;
        b=uuGRDWoGszNNXzW2hp5D9qZWnq9S9HO5JLzqLL0G1v3zJktEMOSJcKKV3qAH2ZZFBU
         W74eQJKTpoj+VEkunnHEOVg3mDoqZICJEdBQeYJtw82464Xpil4tCUrGD7WrPXgBTqXF
         QyXaCXh3JcUar++IqU3dp2wTVxBKG9piUhEFr+x+Usg6046lUWMaOVP0Ig1j/W87Ceql
         Z0IrI/JXtWyquCQapHBUx0sNGnbiqF7XVpaFbneyY0YwpHQ6kWdyIx8z/95a23D3pW0M
         rnsIcmODAx0+8TbFdh9KkrJv/Z4D7+u0xZMnZgExPfUW1CNItNqTaSuaRP1mUbX2g2P+
         /CrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=FDka2LomCCjzKUDoyHkQuynLln8lqOKoER8acK9H1YA=;
        b=IRbhjfCsb55Or753d9EjMN/ifV69r9yO1HnN6kVYhJ6N6IhDjFaqC3+Y+hegS7CkFo
         JTnzu6M5+sW3oD41fZ6Yp/0yfxfhmTlydC5E+RhTOmxT6yw2KR+yTzFLHHYhMBvJx94D
         TPnNIb/f3hxYgDRU57s9JJQIhNsjvnpOO86rvafpne5ukq2ZGo6RivKVK7Ix5kCMOif6
         azXxbbIsLJt2ZlGqF5cxOV6ljYH+w4AacWYvlMDbSqfrj2JZujJPs9jWsMrKqQAwGD/o
         SCWrd+jUxj0BwoJAA5jXon9OtV8IRIMVTypNiCchoSSMzgJXXc18oI1grCDfFWQ46hO4
         JD/A==
X-Gm-Message-State: APjAAAXeijwhaYD5CGnSzshT40grA1FxDdsxHUsC+AJysoJgHR2Lh99L
        b/09oSqSNtHgdU+mTcqOPefBDTdB2h4=
X-Google-Smtp-Source: APXvYqyevCTTB5KWim+e15x2aVZOPwNUVfFT/Dw7qbfX+pvM8Pt3sa74TKnqAADY8SeJRI2WmMZfjg==
X-Received: by 2002:a17:902:903:: with SMTP id 3mr48024587plm.281.1560219191026;
        Mon, 10 Jun 2019 19:13:11 -0700 (PDT)
Received: from localhost ([47.254.35.144])
        by smtp.gmail.com with ESMTPSA id g15sm23199607pfm.119.2019.06.10.19.13.10
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 10 Jun 2019 19:13:10 -0700 (PDT)
Date:   Tue, 11 Jun 2019 10:13:08 +0800
From:   Eryu Guan <guaneryu@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Theodore Ts'o <tytso@mit.edu>, Amir Goldstein <amir73il@gmail.com>,
        Dave Chinner <david@fromorbit.com>,
        Olga Kornievskaia <olga.kornievskaia@gmail.com>,
        fstests <fstests@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v3 3/6] generic: copy_file_range swapfile test
Message-ID: <20190611021308.GZ15846@desktop>
References: <20190602124114.26810-1-amir73il@gmail.com>
 <20190602124114.26810-4-amir73il@gmail.com>
 <20190610035829.GA18429@mit.edu>
 <CAOQ4uxi-s6ncLGjh_u5x4DFK+dvcaobDCqup_ZV3mZOYDRuOEQ@mail.gmail.com>
 <20190610133131.GE15963@mit.edu>
 <20190610160616.GE1688126@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190610160616.GE1688126@magnolia>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 10, 2019 at 09:06:16AM -0700, Darrick J. Wong wrote:
> On Mon, Jun 10, 2019 at 09:31:31AM -0400, Theodore Ts'o wrote:
> > On Mon, Jun 10, 2019 at 09:37:32AM +0300, Amir Goldstein wrote:
> > >
> > >Why do you think thhis is xfs_io fall back and not kernel fall back to
> > >do_splice_direct()? Anyway, both cases allow read from swapfile
> > >on upstream.
> > 
> > Ah, I had assumed this was changed that was made because if you are
> > implementing copy_file_range in terms of some kind of reflink-like
> > mechanism, it becomes super-messy since you know have to break tons
> > and tons of COW sharing each time the kernel swaps to the swap file.
> > 
> > I didn't think we had (or maybe we did, and I missed it) a discussion
> > about whether reading from a swap file should be prohibited.
> > Personally, I think it's security theatre, and not worth the
> > effort/overhead, but whatever.... my main complaint was with the
> > unnecessary test failures with upstream kernels.
> > 
> > > Trying to understand the desired flow of tests and fixes. 
> > > I agree that generic/554 failure may be a test/interface bug that
> > > we should fix in a way that current upstream passes the test for
> > > ext4. Unless there is objection, I will send a patch to fix the test
> > > to only test copy *to* swapfile.
> > > 
> > > generic/553, OTOH, is expected to fail on upstream kernel.
> > > Are you leaving 553 in appliance build in anticipation to upstream fix?
> > > I guess the answer is in the ext4 IS_IMMUTABLE patch that you
> > > posted and plan to push to upstream/stable sooner than VFS patches.
> > 
> > So I find it kind of annoying when tests land before the fixes do
> > upstream.  I still have this in my global_exclude file:
> 
> Yeah, it's awkward for VFS fixes because on the one hand we don't want
> to have multiyear regressions like generic/484, but OTOH stuffing tests
> in before code goes upstream enables broader testing by the other fs
> maintainers.
> 
> In any case, the fixes are in the copy-range-fixes branch which I'm
> finally publishing...
> 
> > # The proposed fix for generic/484, "locks: change POSIX lock
> > # ownership on execve when files_struct is displaced" would break NFS
> > # Jeff Layton and Eric Biederman have some ideas for how to address it
> > # but fixing it is non-trivial
> 
> Also, uh, can we remove this from the auto and quick groups for now?

I'm fine with that :)

Thanks,
Eryu
