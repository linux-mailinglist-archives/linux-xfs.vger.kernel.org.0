Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CD9165A245
	for <lists+linux-xfs@lfdr.de>; Sat, 31 Dec 2022 04:11:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236311AbiLaDLT (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 30 Dec 2022 22:11:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231476AbiLaDLS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:11:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E68DFCD8;
        Fri, 30 Dec 2022 19:11:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D00CB61C7A;
        Sat, 31 Dec 2022 03:11:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 346D3C433D2;
        Sat, 31 Dec 2022 03:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672456277;
        bh=9r3YWrd97eMRBfrifUnTj7hpJqxR5akt/XOxxgrKmGA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=s51b5tMk0pN8qu3k9xZdbYHnZ3KhHs6DWmpU7sx4hp/Z9kXo+C00RRVC/jtyEQbJq
         +aX9mpu9l2Fon6W1whPBTKwPgOpjMsoaM39hyHkhm/AaEmGiAsh+QgtNmLe71TsheE
         J6Hisq6jcmgD1MitrVYTizSyS5ptYblZneV8+pK/3CVsvjbv0gXk1qFEXX/58DJygE
         LHoqlhxhRDw89tYOlwsWoKUvTlzL8ZMrRUD25Zdp3/L0WWUB48pVVWvOcL39lAh2AK
         +5VPjjN2qv+QHAV9a5B0lawiydrZ9Ap/FIkmFc4jbNhYEfDEelgPfcEaaOGW+J3xhJ
         HXmlazPRMfCNw==
Subject: [PATCH 07/12] xfs/449: update test to know about xfs_db -R
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:20:40 -0800
Message-ID: <167243884037.739029.16745495389634352379.stgit@magnolia>
In-Reply-To: <167243883943.739029.3041109696120604285.stgit@magnolia>
References: <167243883943.739029.3041109696120604285.stgit@magnolia>
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

The realtime groups feature added a -R flag to xfs_db so that users can
pass in the realtime device.  Since we've now modified the
_scratch_xfs_db to use this facility, we can update the test to do exact
comparisons of the xfs_db info command against the mkfs output.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/449 |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)


diff --git a/tests/xfs/449 b/tests/xfs/449
index 5374bf2f85..66c443e994 100755
--- a/tests/xfs/449
+++ b/tests/xfs/449
@@ -32,7 +32,11 @@ echo DB >> $seqres.full
 cat $tmp.dbinfo >> $seqres.full
 # xfs_db doesn't take a rtdev argument, so it reports "realtime=external".
 # mkfs does, so make a quick substitution
-diff -u <(cat $tmp.mkfs | sed -e 's/realtime =\/.*extsz=/realtime =external               extsz=/g') $tmp.dbinfo
+if $XFS_DB_PROG --help 2>&1 | grep -q -- '-R rtdev'; then
+	diff -u $tmp.mkfs $tmp.dbinfo
+else
+	diff -u <(cat $tmp.mkfs | sed -e 's/realtime =\/.*extsz=/realtime =external               extsz=/g') $tmp.dbinfo
+fi
 
 _scratch_mount
 

