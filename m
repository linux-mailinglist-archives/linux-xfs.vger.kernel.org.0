Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3905834C42A
	for <lists+linux-xfs@lfdr.de>; Mon, 29 Mar 2021 08:56:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbhC2G4R (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 29 Mar 2021 02:56:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229873AbhC2Gz7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 29 Mar 2021 02:55:59 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65ADCC061574
        for <linux-xfs@vger.kernel.org>; Sun, 28 Mar 2021 23:55:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=sbncSGvUr0+/8wNrGn+ZmFcMzMm84Vrt3rCaWQh6a74=; b=yuHQCGOOXeO1UycUCGKuXevzWs
        FW35Nuh8B6clGHP7ZV9OMRHV4SG+pmK6ioa2ub3h8pYKWODe3BGCCN3g1HG25VKw1NIpSK/xFS04o
        d1nnk7kFUvT4cZzUXjc5xFMUL4IS2jrdBGn2tazWv9X4sUZjSnwDIBCURKDCQfOrwdKlniiFY8bzG
        YQOukSFAdK7FinvDM/CIA9+6khssylMjbe0FQsc1r/w2Un0tv6I0qocuNp3vsU4RDT3cAp/dVbrZh
        aaMH996CdD6Lk50/ADyPHTRpl4r88kON9OSzJezZhSP70HbZW5oZyMuX777bZxhOvZhl8sXVBI1n8
        jtm2mWlA==;
Received: from 173.40.253.84.static.wline.lns.sme.cust.swisscom.ch ([84.253.40.173] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lQkbq-006oP4-AC; Mon, 29 Mar 2021 05:38:42 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH 04/20] xfs: remove the unused xfs_icdinode_has_bigtime helper
Date:   Mon, 29 Mar 2021 07:38:13 +0200
Message-Id: <20210329053829.1851318-5-hch@lst.de>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210329053829.1851318-1-hch@lst.de>
References: <20210329053829.1851318-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_inode_buf.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
index 9e1ae38380b3c0..b3097ea8b53366 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.h
+++ b/fs/xfs/libxfs/xfs_inode_buf.h
@@ -32,11 +32,6 @@ struct xfs_icdinode {
 	struct timespec64 di_crtime;	/* time created */
 };
 
-static inline bool xfs_icdinode_has_bigtime(const struct xfs_icdinode *icd)
-{
-	return icd->di_flags2 & XFS_DIFLAG2_BIGTIME;
-}
-
 /*
  * Inode location information.  Stored in the inode and passed to
  * xfs_imap_to_bp() to get a buffer and dinode for a given inode.
-- 
2.30.1

