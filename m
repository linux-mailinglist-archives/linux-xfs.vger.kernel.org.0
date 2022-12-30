Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A247865A23E
	for <lists+linux-xfs@lfdr.de>; Sat, 31 Dec 2022 04:09:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236316AbiLaDJm (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 30 Dec 2022 22:09:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236324AbiLaDJa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:09:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67A0415F1C;
        Fri, 30 Dec 2022 19:09:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EDEAA61C7A;
        Sat, 31 Dec 2022 03:09:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55B22C433EF;
        Sat, 31 Dec 2022 03:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672456168;
        bh=64aj6sNU4jmIXiBD/oAd0BMwgzQu21eyPSkp/TpfSsg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=rQrsvvWVvEWlg5WR6opot1l6W1fb28OHbjt2Z76hYx4unxGX/SZPPrlxxmSMNxluS
         3DmW4c/V4BguzqbntkZ71HcKt3lc4DR02F+F+nm98h6pW3JN8XJRWC4xkek1/T1A1V
         VAKTZph5Taj13sY46mo7KrDc3Sg9wam09O8opNDFKj3kKPH8JMnqK8QQec86SRB/SG
         RRC4dQJdC7pKgJsye5LkUevgmWZvlRWez6IeBpVuwI73qU8uLuQtOyNCviittOv5WI
         WYnNqBl8eyrcFCMxn2wgx7u84yajc8/AsnZ9NUmExs+jZPn/YESWw3kIUpRyXEjEZ8
         SGxZ0qEs68Fiw==
Subject: [PATCH 4/4] common/xfs: capture external logs during
 metadump/mdrestore
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:20:36 -0800
Message-ID: <167243883661.738384.17775898025965694134.stgit@magnolia>
In-Reply-To: <167243883613.738384.6883268151338937809.stgit@magnolia>
References: <167243883613.738384.6883268151338937809.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

If xfs_metadump supports the -x switch to capture the contents of
external log devices and there is an external log device, add the option
to the command line to enable preservation.

Similarly, if xfs_mdrestore supports the -l switch and there's an
external scratch log, pass the option so that we can restore log
contents.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/xfs |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)


diff --git a/common/xfs b/common/xfs
index 29130fabbc..36e02413db 100644
--- a/common/xfs
+++ b/common/xfs
@@ -667,9 +667,20 @@ _xfs_metadump() {
 	shift; shift; shift; shift
 	local options="$@"
 	test -z "$options" && options="-a -o"
+	local metadump_has_dash_x
+
+	# Does metadump support capturing from external devices?
+	$XFS_METADUMP_PROG --help 2>&1 | grep -q -- '-[a-zA-Z]*[wW]x' && \
+			metadump_has_dash_x=1
 
 	if [ "$logdev" != "none" ]; then
 		options="$options -l $logdev"
+
+		# Tell metadump to capture the log device
+		if [ -n "$metadump_has_dash_x" ]; then
+			options="$options -x"
+			unset metadump_has_dash_x
+		fi
 	fi
 
 	$XFS_METADUMP_PROG $options "$device" "$metadump"
@@ -696,6 +707,13 @@ _xfs_mdrestore() {
 	fi
 	test -r "$metadump" || return 1
 
+	# Does mdrestore support restoring to external log devices?  If so,
+	# restore to it, and do not wipe it afterwards.
+	if [ "$logdev" != "none" ] && $XFS_MDRESTORE_PROG --help 2>&1 | grep -q -- '-l logdev'; then
+		options="$options -l $logdev"
+		logdev="none"
+	fi
+
 	$XFS_MDRESTORE_PROG $options "${metadump}" "${device}"
 	res=$?
 	test $res -ne 0 && return $res

