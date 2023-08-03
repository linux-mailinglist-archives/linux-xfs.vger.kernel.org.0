Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 263BB76E4D5
	for <lists+linux-xfs@lfdr.de>; Thu,  3 Aug 2023 11:44:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232852AbjHCJos (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 3 Aug 2023 05:44:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233244AbjHCJoY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Aug 2023 05:44:24 -0400
Received: from out-84.mta1.migadu.com (out-84.mta1.migadu.com [IPv6:2001:41d0:203:375::54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7B473AB6
        for <linux-xfs@vger.kernel.org>; Thu,  3 Aug 2023 02:44:17 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1691055426;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=RlouW3YFFaE/nLb2+Vq4gYGLf7SAMMeK3fHcOrMathc=;
        b=Iq5BYYTzPoX7wzAGlcfAU6i8bfZ48IHNR9scX3fZ3JjZHMOVGDLBumvd+MC+vTyN2P7EX9
        qVM+3zLRX1z5torDBVd2X+c4r387ytyCgs04uCRGU9ba7AKgGhzezjvnviBV45+H/8zvOX
        L1Cm6MpG77U/zromeIU7zCapfMOFFYA=
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
To:     amir73il@gmail.com, djwong@kernel.org, dchinner@redhat.com,
        yangx.jy@fujitsu.com
Cc:     linux-xfs@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH 5.10 0/2] Fix xfs/179 for 5.10 stable
Date:   Thu,  3 Aug 2023 17:36:50 +0800
Message-Id: <20230803093652.7119-1-guoqing.jiang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

With the two patches applied, xfs/179 can pass in 5.10.188. Otherwise I got

[root@localhost xfstests]# ./check xfs/179
FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/x86_64 localhost 5.10.188-default #14 SMP Thu Aug 3 15:23:19 CST 2023
MKFS_OPTIONS  -- -f /dev/loop1
MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 /dev/loop1 /mnt/scratch

xfs/179 1s ... [failed, exit status 1]- output mismatch (see /root/xfstests/results//xfs/179.out.bad)
    --- tests/xfs/179.out	2023-07-13 16:12:27.000000000 +0800
    +++ /root/xfstests/results//xfs/179.out.bad	2023-08-03 16:55:38.173787911 +0800
    @@ -8,3 +8,5 @@
     Check scratch fs
     Remove reflinked files
     Check scratch fs
    +xfs_repair fails
    +(see /root/xfstests/results//xfs/179.full for details)
    ...
    (Run 'diff -u /root/xfstests/tests/xfs/179.out /root/xfstests/results//xfs/179.out.bad'  to see the entire diff)

HINT: You _MAY_ be missing kernel fix:
      b25d1984aa88 xfs: estimate post-merge refcounts correctly

Ran: xfs/179
Failures: xfs/179
Failed 1 of 1 tests

Please review if they are approriate for 5.10 stable.

Thanks,
Guoqing

Darrick J. Wong (2):
  xfs: hoist refcount record merge predicates
  xfs: estimate post-merge refcounts correctly

 fs/xfs/libxfs/xfs_refcount.c | 146 +++++++++++++++++++++++++++++++----
 1 file changed, 130 insertions(+), 16 deletions(-)

-- 
2.33.0

