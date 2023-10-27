Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 497B47D9D9F
	for <lists+linux-xfs@lfdr.de>; Fri, 27 Oct 2023 17:57:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345780AbjJ0P5O (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 27 Oct 2023 11:57:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346224AbjJ0P5O (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 27 Oct 2023 11:57:14 -0400
Received: from buxtehude.debian.org (buxtehude.debian.org [IPv6:2607:f8f0:614:1::1274:39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5557C2
        for <linux-xfs@vger.kernel.org>; Fri, 27 Oct 2023 08:57:11 -0700 (PDT)
Received: from debbugs by buxtehude.debian.org with local (Exim 4.94.2)
        (envelope-from <debbugs@buxtehude.debian.org>)
        id 1qwPCp-003NAg-0l; Fri, 27 Oct 2023 15:57:03 +0000
X-Loop: owner@bugs.debian.org
Subject: Bug#1054644: xfsprogs-udeb: causes D-I to fail, reporting errors about missing partition devices
Reply-To: "Darrick J. Wong" <djwong@kernel.org>, 1054644@bugs.debian.org
X-Loop: owner@bugs.debian.org
X-Debian-PR-Message: followup 1054644
X-Debian-PR-Package: xfsprogs-udeb
X-Debian-PR-Keywords: 
References: <169839498168.1174073.11485737048739628391.reportbug@nimble.hk.hands.com> <169839498168.1174073.11485737048739628391.reportbug@nimble.hk.hands.com> <871qdgccs5.fsf@nimble.hk.hands.com> <169839498168.1174073.11485737048739628391.reportbug@nimble.hk.hands.com>
X-Debian-PR-Source: xfsprogs
Received: via spool by 1054644-submit@bugs.debian.org id=B1054644.1698422089803390
          (code B ref 1054644); Fri, 27 Oct 2023 15:57:02 +0000
Received: (at 1054644) by bugs.debian.org; 27 Oct 2023 15:54:49 +0000
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Bayes: score:0.0000 Tokens: new, 21; hammy, 150; neutral, 201; spammy,
        0. spammytokens: hammytokens:0.000-+--42pm, 0.000-+--42PM,
        0.000-+--grubinstall, 0.000-+--grub-install, 0.000-+--grubprobe
Received: from sin.source.kernel.org ([2604:1380:40e1:4800::1]:58656)
        by buxtehude.debian.org with esmtps (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <djwong@kernel.org>)
        id 1qwPAc-003Mzc-5u
        for 1054644@bugs.debian.org; Fri, 27 Oct 2023 15:54:49 +0000
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
        by sin.source.kernel.org (Postfix) with ESMTP id 1051CCE0AD6;
        Fri, 27 Oct 2023 15:45:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DA4FC433C7;
        Fri, 27 Oct 2023 15:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698421506;
        bh=dBkOSPZu3i5dFTVS6sf9cHlY3bEU30IwNCIbfsC9Ogw=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=D1+c6nbTpChDZJzJuDUQW1xa95Y2Bgti2ljJrhWuxG5Zkv0Hx6vlwzXEotJvuMOU4
         Y79+UUBX7F1gNWc+rfb2A8m+fPKSx6zWmq1DkhaKzeo+QNPR6ikpDb3GNexvDQXxN0
         1OqgdWbc4/9F3Qyc89/1EjHrzYV0RRoCArGG47x40oLMji86OAD7YsoUOxzWSkVvy7
         iQCyzpc4DNZDOZ8qMnrkfulT5D/jqC2QgMib/T6ThxvsnsC0JIyW7r1xvQM+t6uu6A
         PNxnwBPkF6IMF84FyOrxi1IdxsDVKUE8UcJXHSCR/FzdwDYMsEi8jb4VHUmplPsaYO
         1bJiri/+T8AfA==
Date:   Fri, 27 Oct 2023 08:45:05 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Philip Hands <phil@hands.com>, 1054644@bugs.debian.org
Message-ID: <20231027154505.GL3195650@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871qdgccs5.fsf@nimble.hk.hands.com>
X-Greylist: delayed 573 seconds by postgrey-1.36 at buxtehude; Fri, 27 Oct 2023 15:54:45 UTC
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 27, 2023 at 05:20:42PM +0200, Philip Hands wrote:
> Philip Hands <phil@hands.com> writes:
> ...
> > Could this be related to #1051543?
> >
> > I'll try testing D-I while using the patch from that bug, to see if that helps.
> 
> It seems (to me at least) that the patch there does not apply usefully
> to the version we're talking about, so I'll leave it to people that know
> more about grub & XFS to look further.

From https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1054644#5:

> > I note that if one runs e.g.:  grub-probe -d /dev/vda1
> > at the moment of failure, the XFS filesystem is not recognised
> > (despite being mounted as XFS at that moment).
> > 
> > Could this be related to #1051543?
> > 
> > I'll try testing D-I while using the patch from that bug, to see if that
> > helps.

I noticed this too while migrating to Debian 12 -- if you mkfs.xfs a
/boot with feature flags that grub doesn't know about, grub-install
unhelpfully refuses to recognize that there's a filesystem there at all.

mkfs.xfs in xfsprogs 6.5 turned on both the large extent counts and
reverse mapping btree features by default.  My guess is that grub hasn't
caught up with those changes to the ondisk format yet.

Ah, yeah, upstream grub hasn't picked up large extent counts (internally
called nrext64) yet.
https://git.savannah.gnu.org/cgit/grub.git/tree/grub-core/fs/xfs.c#n83

If you can manually reformat the filesystem from within the installer
with

mkfs.xfs -c /usr/share/xfsprogs/mkfs/lts_6.1.conf

Does grub start to recognize the filesystem again?

> 
> =-=-=
> 
> BTW the jobs where this failure first occured are:
> 
> (BIOS)  https://openqa.debian.net/tests/198911
> (UEFI)  https://openqa.debian.net/tests/198912
> 
> and the immediately previous working jobs are these:
> 
> (BIOS)  https://openqa.debian.net/tests/198840
> (UEFI)  https://openqa.debian.net/tests/198841
> 
> In the jobs you can see a 'Logs & Assets' tab, where you can find e.g.
> the syslog from the D-I run.
> 
> Here's the one from the first BIOS failure:
> 
>   https://openqa.debian.net/tests/198911/logfile?filename=DI_syslog.txt

Curiously, this log says:

Oct 24 05:35:32 in-target: Setting up xfsprogs (6.4.0-1) ...^M

So ... is it running 6.4 and not 6.5?

--D

> 
> One thing I notice when comparing that to the matching successful log:
> 
>   https://openqa.debian.net/tests/198840/logfile?filename=complete_install-DI_syslog.txt
> 
> is that they both include a block of lines like:
> 
>    grub-installer: Unknown device "/dev/vda1": No such device
> 
> so that's just noise by the looks of it, since it was also saying that
> when it was working.
> 
> I've since slightly reorganised the openQA jobs, to have a job that only
> differs from the normal minimal install by the selection of XFS, so if
> you want to see currently failing jobs, they will be the ones called
> nonGUI_XFS@64bit & nonGUI_XFS (for BIOS & UEFI installs, respectively)
> in this overview:
> 
>   https://openqa.debian.net/tests/overview?distri=debian&groupid=10
> 
> HTH
> 
> Cheers, Phil.
> -- 
> Philip Hands -- https://hands.com/~phil
