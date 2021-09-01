Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19EFB3FD46D
	for <lists+linux-xfs@lfdr.de>; Wed,  1 Sep 2021 09:30:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242599AbhIAHbn (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 1 Sep 2021 03:31:43 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:37239 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242568AbhIAHbn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Sep 2021 03:31:43 -0400
Received: from dread.disaster.area (pa49-195-182-146.pa.nsw.optusnet.com.au [49.195.182.146])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id E42F71B73BF;
        Wed,  1 Sep 2021 17:30:45 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mLKhm-007NLJ-IA; Wed, 01 Sep 2021 17:30:42 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1mLKhm-003Xnw-9z; Wed, 01 Sep 2021 17:30:42 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Cc:     allison.henderson@oracle.com
Subject: [PATCH 1/5] xfs: fix fallthrough annotations in xfs_attr_set_iter()
Date:   Wed,  1 Sep 2021 17:30:35 +1000
Message-Id: <20210901073039.844617-2-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210901073039.844617-1-david@fromorbit.com>
References: <20210824224434.968720-1-allison.henderson@oracle.com>
 <20210901073039.844617-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=QpfB3wCSrn/dqEBSktpwZQ==:117 a=QpfB3wCSrn/dqEBSktpwZQ==:17
        a=7QKq2e-ADPsA:10 a=20KFwNOVAAAA:8 a=UZGndzrlyjZV2BPfUNIA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_attr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 7150f0e051a0..e49284325d04 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -448,7 +448,7 @@ xfs_attr_set_iter(
 			return -EAGAIN;
 		}
 
-		/* fallthrough */
+		fallthrough;
 	case XFS_DAS_FLIP_LFLAG:
 		/*
 		 * Dismantle the "old" attribute/value pair by removing a
@@ -566,7 +566,7 @@ xfs_attr_set_iter(
 			return -EAGAIN;
 		}
 
-		/* fallthrough */
+		fallthrough;
 	case XFS_DAS_FLIP_NFLAG:
 		/*
 		 * Dismantle the "old" attribute/value pair by removing a
-- 
2.31.1

