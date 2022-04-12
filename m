Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F23CB4FDC43
	for <lists+linux-xfs@lfdr.de>; Tue, 12 Apr 2022 13:04:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241168AbiDLKQz (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 12 Apr 2022 06:16:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353861AbiDLKC5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Apr 2022 06:02:57 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4DBBC340C1
        for <linux-xfs@vger.kernel.org>; Tue, 12 Apr 2022 02:09:19 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-233-190.pa.vic.optusnet.com.au [49.186.233.190])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 05203534515;
        Tue, 12 Apr 2022 19:09:17 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1neCWS-00GlqL-JY; Tue, 12 Apr 2022 19:09:16 +1000
Date:   Tue, 12 Apr 2022 19:09:16 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Cc:     allison.henderson@oracle.com
Subject: [PATCH 11/10] xfs: initialise attrd item to zero
Message-ID: <20220412090916.GF1544202@dread.disaster.area>
References: <20220412042543.2234866-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220412042543.2234866-1-david@fromorbit.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=625541be
        a=bHAvQTfMiaNt/bo4vVGwyA==:117 a=bHAvQTfMiaNt/bo4vVGwyA==:17
        a=kj9zAlcOel0A:10 a=z0gMJWrwH1QA:10 a=20KFwNOVAAAA:8
        a=VdGwt750K41ze9-0lWsA:9 a=CjuIK1q_8ugA:10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


From: Dave Chinner <dchinner@redhat.com>

On the first allocation of a attrd item, xfs_trans_add_item() fires
an assert like so:

 XFS (pmem0): EXPERIMENTAL logged extended attributes feature added. Use at your own risk!
 XFS: Assertion failed: !test_bit(XFS_LI_DIRTY, &lip->li_flags), file: fs/xfs/xfs_trans.c, line: 683
 ------------[ cut here ]------------
 kernel BUG at fs/xfs/xfs_message.c:102!
 Call Trace:
  <TASK>
  xfs_trans_add_item+0x17e/0x190
  xfs_trans_get_attrd+0x67/0x90
  xfs_attr_create_done+0x13/0x20
  xfs_defer_finish_noroll+0x100/0x690
  __xfs_trans_commit+0x144/0x330
  xfs_trans_commit+0x10/0x20
  xfs_attr_set+0x3e2/0x4c0
  xfs_initxattrs+0xaa/0xe0
  security_inode_init_security+0xb0/0x130
  xfs_init_security+0x18/0x20
  xfs_generic_create+0x13a/0x340
  xfs_vn_create+0x17/0x20
  path_openat+0xff3/0x12f0
  do_filp_open+0xb2/0x150

The attrd log item is allocated via kmem_cache_alloc, and
xfs_log_item_init() does not zero the entire log item structure - it
assumes that the structure is already all zeros as it only
initialises non-zero fields. Fix the attr items to be allocated
via the *zalloc methods.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---

With this patch, the series also passes the attr group fstests with
larp enabled. This probably should be folded back into the original
patchset where this allocation is added.

 fs/xfs/xfs_attr_item.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 0e2ef0dedb28..b6561861ef01 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -725,7 +725,7 @@ xfs_trans_get_attrd(struct xfs_trans		*tp,
 
 	ASSERT(tp != NULL);
 
-	attrdp = kmem_cache_alloc(xfs_attrd_cache, GFP_NOFS | __GFP_NOFAIL);
+	attrdp = kmem_cache_zalloc(xfs_attrd_cache, GFP_NOFS | __GFP_NOFAIL);
 
 	xfs_log_item_init(tp->t_mountp, &attrdp->attrd_item, XFS_LI_ATTRD,
 			  &xfs_attrd_item_ops);
