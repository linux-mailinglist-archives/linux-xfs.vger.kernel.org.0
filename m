Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 860247D9CF8
	for <lists+linux-xfs@lfdr.de>; Fri, 27 Oct 2023 17:30:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232100AbjJ0PaI (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 27 Oct 2023 11:30:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231995AbjJ0PaH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 27 Oct 2023 11:30:07 -0400
Received: from buxtehude.debian.org (buxtehude.debian.org [IPv6:2607:f8f0:614:1::1274:39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2B09AC
        for <linux-xfs@vger.kernel.org>; Fri, 27 Oct 2023 08:30:04 -0700 (PDT)
Received: from debbugs by buxtehude.debian.org with local (Exim 4.94.2)
        (envelope-from <debbugs@buxtehude.debian.org>)
        id 1qwOmg-003JU9-QA; Fri, 27 Oct 2023 15:30:02 +0000
X-Loop: owner@bugs.debian.org
Subject: Bug#1054644: xfsprogs-udeb: causes D-I to fail, reporting errors about missing partition devices
Reply-To: Philip Hands <phil@hands.com>, 1054644@bugs.debian.org
X-Loop: owner@bugs.debian.org
X-Debian-PR-Message: followup 1054644
X-Debian-PR-Package: xfsprogs-udeb
X-Debian-PR-Keywords: 
References: <169839498168.1174073.11485737048739628391.reportbug@nimble.hk.hands.com> <169839498168.1174073.11485737048739628391.reportbug@nimble.hk.hands.com>
X-Debian-PR-Source: xfsprogs
Received: via spool by 1054644-submit@bugs.debian.org id=B1054644.1698420468788271
          (code B ref 1054644); Fri, 27 Oct 2023 15:30:01 +0000
Received: (at 1054644) by bugs.debian.org; 27 Oct 2023 15:27:48 +0000
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Bayes: score:0.0000 Tokens: new, 24; hammy, 150; neutral, 87; spammy,
        0. spammytokens: hammytokens:0.000-+--H*r:DragonFly,
        0.000-+--grubinstaller, 0.000-+--grub-installer, 0.000-+--H*r:v0.13,
        0.000-+--syslog
Received: from free.hands.com ([2001:1b40:5600:ff80:f8ee::1]:35829)
        by buxtehude.debian.org with esmtps (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <phil@hands.com>)
        id 1qwOkT-003J3o-QM
        for 1054644@bugs.debian.org; Fri, 27 Oct 2023 15:27:47 +0000
Received: from nimble.hk.hands.com (p5b08cc82.dip0.t-ipconnect.de [91.8.204.130])
        by free.hands.com (Postfix) with ESMTPSA id 7A5D22A720
        for <1054644@bugs.debian.org>; Fri, 27 Oct 2023 16:20:43 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hands.com;
        s=202202.hands; t=1698420043;
        bh=f0dQigR+GdkPGsDfau2KE7ez1yQBwy40HzH5RsEV4Uo=;
        h=From:To:Subject:In-Reply-To:References:Date:From;
        b=l4GrqLP+WyiUep6YQEUquPtXCJ9QNdyc5Cfc5AaC5OJBY4XFIkKaarD0r8fnPwSWO
         E5EdrQTpx0Z3SmSncHnUW8/c1tdC5G9eeSSldrWHZIN7E+uHBLaTjpdE3ud8L6mhJc
         W8rGyWJPKyttGNLNFPYGODyHL3rJ0YdX4/N2cYBLI6NUIOxqzE6UJLSvKiXtb6veLf
         3RCQPVngtlCQSgKOKsm50tO6go7IDK8pACOs30W7HL/kCWUz0Rd7xT9UIQw0SDl5YB
         RxSDvlBzMbiyD9y36uabRCUY/Bc+DGyFcCmXg9tpCvHr7P3Bbps8TSSaYaXigC3ODg
         xuFNYyRe73N9g==
Received: from phil (uid 1000)
        (envelope-from phil@hands.com)
        id 10c96b
        by nimble.hk.hands.com (DragonFly Mail Agent v0.13 on nimble);
        Fri, 27 Oct 2023 17:20:42 +0200
From:   Philip Hands <phil@hands.com>
To:     1054644@bugs.debian.org
In-Reply-To: <169839498168.1174073.11485737048739628391.reportbug@nimble.hk.hands.com>
Date:   Fri, 27 Oct 2023 17:20:42 +0200
Message-ID: <871qdgccs5.fsf@nimble.hk.hands.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Greylist: delayed 411 seconds by postgrey-1.36 at buxtehude; Fri, 27 Oct 2023 15:27:45 UTC
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Philip Hands <phil@hands.com> writes:
...
> Could this be related to #1051543?
>
> I'll try testing D-I while using the patch from that bug, to see if that helps.

It seems (to me at least) that the patch there does not apply usefully
to the version we're talking about, so I'll leave it to people that know
more about grub & XFS to look further.

=-=-=

BTW the jobs where this failure first occured are:

(BIOS)  https://openqa.debian.net/tests/198911
(UEFI)  https://openqa.debian.net/tests/198912

and the immediately previous working jobs are these:

(BIOS)  https://openqa.debian.net/tests/198840
(UEFI)  https://openqa.debian.net/tests/198841

In the jobs you can see a 'Logs & Assets' tab, where you can find e.g.
the syslog from the D-I run.

Here's the one from the first BIOS failure:

  https://openqa.debian.net/tests/198911/logfile?filename=DI_syslog.txt

One thing I notice when comparing that to the matching successful log:

  https://openqa.debian.net/tests/198840/logfile?filename=complete_install-DI_syslog.txt

is that they both include a block of lines like:

   grub-installer: Unknown device "/dev/vda1": No such device

so that's just noise by the looks of it, since it was also saying that
when it was working.

I've since slightly reorganised the openQA jobs, to have a job that only
differs from the normal minimal install by the selection of XFS, so if
you want to see currently failing jobs, they will be the ones called
nonGUI_XFS@64bit & nonGUI_XFS (for BIOS & UEFI installs, respectively)
in this overview:

  https://openqa.debian.net/tests/overview?distri=debian&groupid=10

HTH

Cheers, Phil.
-- 
Philip Hands -- https://hands.com/~phil
