Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EBC6711D26
	for <lists+linux-xfs@lfdr.de>; Fri, 26 May 2023 03:53:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229942AbjEZBxc (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 25 May 2023 21:53:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229890AbjEZBxb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:53:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B68A318D
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:53:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 522BB61295
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:53:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B24FAC433EF;
        Fri, 26 May 2023 01:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685066009;
        bh=IJT8kuACDjUlGrRq3Si76H+zoOHiPJYCA88SuFREGmA=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=CQxhvf7ZZ2JnzsUjtqrRCQXCUpdckXloRw0S6lIGdptN2La4neygDQ1YdULlaXuLj
         XXnr0oGWH4NhbT3X0UPlP6JhbkYjXj3q+afsQ516+PEhSaz6FZhB2DY+hmGJU9w7Sh
         QytQu3Ud/YmUkvs4zu1kf1lbrIgfidAb5VPahiNQ2P0lA3FOS092092QlVsLR6rEKs
         7RV19cCuTWQk3SIpfwfqXzDk4WeY1fZ1JvSCry2aVSaEd89Zt3JwSGs7vUHcjkSxt/
         BBVmUrUgtLCNG/MFqa6NOjhy/a4Bk10Az7+suCqmOL0epJpOimJFHUG3YYJ34x8EtD
         FQyMfDsZ/JRAw==
Date:   Thu, 25 May 2023 18:53:29 -0700
Subject: [PATCH 4/5] xfs_scrub_fail: fix sendmail detection
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506073887.3745766.3554648508638613549.stgit@frogsfrogsfrogs>
In-Reply-To: <168506073832.3745766.10929690168821459226.stgit@frogsfrogsfrogs>
References: <168506073832.3745766.10929690168821459226.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

This script emails the results of failed scrub runs to root.  We
shouldn't be hardcoding the path to the mailer program because distros
can change the path according to their whim.  Modify this script to use
command -v to find the program.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/xfs_scrub_fail.in |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/scrub/xfs_scrub_fail.in b/scrub/xfs_scrub_fail.in
index b154202815b..a69be8a54cb 100755
--- a/scrub/xfs_scrub_fail.in
+++ b/scrub/xfs_scrub_fail.in
@@ -7,13 +7,14 @@
 
 # Email logs of failed xfs_scrub unit runs
 
-mailer=/usr/sbin/sendmail
 recipient="$1"
 test -z "${recipient}" && exit 0
 mntpoint="$2"
 test -z "${mntpoint}" && exit 0
 hostname="$(hostname -f 2>/dev/null)"
 test -z "${hostname}" && hostname="${HOSTNAME}"
+
+mailer="$(command -v sendmail)"
 if [ ! -x "${mailer}" ]; then
 	echo "${mailer}: Mailer program not found."
 	exit 1

