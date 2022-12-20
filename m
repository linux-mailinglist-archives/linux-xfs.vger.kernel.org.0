Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F0976516E9
	for <lists+linux-xfs@lfdr.de>; Tue, 20 Dec 2022 01:01:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232256AbiLTABT (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 19 Dec 2022 19:01:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232798AbiLTABJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Dec 2022 19:01:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60391A46F;
        Mon, 19 Dec 2022 16:01:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F0C356117E;
        Tue, 20 Dec 2022 00:01:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F891C433EF;
        Tue, 20 Dec 2022 00:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671494464;
        bh=4zn2xuFc1yOSaUF7eMyuTKLng4SSlpqNcVU4ptwF3rE=;
        h=Subject:From:To:Cc:Date:From;
        b=iZ3i5yGJ7HxuCDpj6BHij9NO+F/l6u/Efs8875tkRbvRM2IIHKdvHN5I1DOmWrstc
         +Wfpj+Mfrc78aHny193NOBLWwbrIUS9O9B/vaji/UKP8gDTw6G25nCCpxKbWZmWsPx
         /BoadlJ/pgYKg3w4zYiGl3SMmYi9agQQbAMJLNhRdSmDbhiJ4IhofuR+R8C6mAm9bv
         HBMjfSdH4YsZ5G+8CM5PiLjeB8k9MfsnLfCYmzQ3IT/kVNEmfNqNSjA/d/F8Ahvn1I
         zDN0J4zlOoIF7Lsgkmfe2TiRCgw5VMZnP8UPi49OuRsUaL3zxn+yG/ZQplAgTj7NiB
         sHZzhqSCNvPMg==
Subject: [PATCHSET RFC 0/8] fstests: improve junit xml reporting
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        leah.rumancik@gmail.com, quwenruo.btrfs@gmx.com
Date:   Mon, 19 Dec 2022 16:01:03 -0800
Message-ID: <167149446381.332657.9402608531757557463.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series improves the fstests reporting code in several ways.  First,
change the ./check code to generate the report after every test, so that
a cluster-based fstest scheduler can reschedule tests after a VM crash.
Personally, I was using it to get live status on my tests dashboard.

The bulk of the patches in here improve the junit xml reporting so that
we (a) actually declare which xml schema we're trying to emit and (b)
capture a lot more information about what was being tested.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=xunit-reporting-improvements
---
 check         |   10 +++
 common/ext4   |    5 +
 common/report |   77 +++++++++++++++++--
 common/xfs    |   10 +++
 doc/xunit.xsd |  226 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 318 insertions(+), 10 deletions(-)
 create mode 100644 doc/xunit.xsd

