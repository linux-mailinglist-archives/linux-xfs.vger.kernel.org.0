Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72ADD167FBB
	for <lists+linux-xfs@lfdr.de>; Fri, 21 Feb 2020 15:11:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728626AbgBUOL4 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 21 Feb 2020 09:11:56 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:59294 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728590AbgBUOL4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Feb 2020 09:11:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=2sSZWlUYu4PnEXVX9AYk32viqeXEKbTgPi2NFhbaZzE=; b=YzZST2scypCMUKF1PjEa8uyD8r
        r444uHTsEe3gjMo1K/x+LBNKbaslw3/TuyJJIkRy/VtFUQjOylqMTpkVSRRET8uXjoiF6/fr362Lr
        yfXRfPNpoKirpeYhC9agP9U6EqGbFrc96SKV9g1Lmo1bl2udNpgHc/P1i498vBS5ryEaSNJXhhtvo
        dcOBL/boFPGbYMVIOoimiczEPgwWDtEXUO2EcYHXWJ4q5dwcJkb3bIPKfqm5dG6D2ngQJWnJfz6ZD
        PfnIXL9XoyMPCaMn3eIcGwBB2mfT1yJZ8GtNcuoUAGDGu8YDvenSjQvlYeChLVCBcRzrVsn+euB78
        vthOyd6Q==;
Received: from [38.126.112.138] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j5924-0000Gk-HA; Fri, 21 Feb 2020 14:11:56 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Allison Collins <allison.henderson@oracle.com>,
        Dave Chinner <dchinner@redhat.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Chandan Rajendra <chandanrlinux@gmail.com>
Subject: [PATCH 07/31] xfs: remove the name == NULL check from xfs_attr_args_init
Date:   Fri, 21 Feb 2020 06:11:30 -0800
Message-Id: <20200221141154.476496-8-hch@lst.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200221141154.476496-1-hch@lst.de>
References: <20200221141154.476496-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

All callers provide a valid name pointer, remove the redundant check.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_attr.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index bb391b96cd78..a968158b9bb1 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -65,10 +65,6 @@ xfs_attr_args_init(
 	size_t			namelen,
 	int			flags)
 {
-
-	if (!name)
-		return -EINVAL;
-
 	memset(args, 0, sizeof(*args));
 	args->geo = dp->i_mount->m_attr_geo;
 	args->whichfork = XFS_ATTR_FORK;
-- 
2.24.1

