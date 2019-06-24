Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A71550C33
	for <lists+linux-xfs@lfdr.de>; Mon, 24 Jun 2019 15:43:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729803AbfFXNnW (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 24 Jun 2019 09:43:22 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:38618 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729607AbfFXNnW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jun 2019 09:43:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=XRd0jh1gN0ygNr955GOjp6yzR4M/htzCYSWiBo/y+hA=; b=rzKvCIlQYabUTMB+65po5ScVN2
        UpD6OIreoWh0NRrVbdkS4R7xixCN8S6vF83HUuyw8NLHVITGVuk0EBz9KbA1raL+had1dDp1+3Kg0
        Z7FRjtJtZAYvfakLOnzqfiwL4CIz14PIhnUV48AvZ2U+RSWdw3n54U0cGN2Jcse6ITjAvqPSdWcHN
        U7EaTg/6AOT+SwCeWQQzco7zIKsP3BUmxBBPVkfFuz3SNA96fVWubCcp/k0k01Na3h3Xhz0/dSHGJ
        J94x+Z7p38ET0DnyYWWnj42vHc770WfLw5PdrN1B/3/G8nZ4PBwusRNOJKxvBVY3dhY2HTZFm3hsf
        aO/s0FrA==;
Received: from clnet-p19-102.ikbnet.co.at ([83.175.77.102] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hfPFh-0007As-W1; Mon, 24 Jun 2019 13:43:22 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Subject: [PATCH 2/2] xfs: implement cgroup aware writeback
Date:   Mon, 24 Jun 2019 15:43:15 +0200
Message-Id: <20190624134315.21307-3-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190624134315.21307-1-hch@lst.de>
References: <20190624134315.21307-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Link every newly allocated writeback bio to cgroup pointed to by the
writeback control structure, and charge every byte written back to it.

Tested-by: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_aops.c  | 4 +++-
 fs/xfs/xfs_super.c | 2 ++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 9cceb90e77c5..73c291aeae17 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -700,6 +700,7 @@ xfs_alloc_ioend(
 	bio->bi_iter.bi_sector = sector;
 	bio->bi_opf = REQ_OP_WRITE | wbc_to_write_flags(wbc);
 	bio->bi_write_hint = inode->i_write_hint;
+	wbc_init_bio(wbc, bio);
 
 	ioend = container_of(bio, struct xfs_ioend, io_inline_bio);
 	INIT_LIST_HEAD(&ioend->io_list);
@@ -727,7 +728,7 @@ xfs_chain_bio(
 	struct bio *new;
 
 	new = bio_alloc(GFP_NOFS, BIO_MAX_PAGES);
-	bio_copy_dev(new, prev);
+	bio_copy_dev(new, prev);/* also copies over blkcg information */
 	new->bi_iter.bi_sector = bio_end_sector(prev);
 	new->bi_opf = prev->bi_opf;
 	new->bi_write_hint = prev->bi_write_hint;
@@ -782,6 +783,7 @@ xfs_add_to_ioend(
 	}
 
 	wpc->ioend->io_size += len;
+	wbc_account_io(wbc, page, len);
 }
 
 STATIC void
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 594c119824cc..ee0df8f611ff 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1685,6 +1685,8 @@ xfs_fs_fill_super(
 	sb->s_maxbytes = xfs_max_file_offset(sb->s_blocksize_bits);
 	sb->s_max_links = XFS_MAXLINK;
 	sb->s_time_gran = 1;
+	sb->s_iflags |= SB_I_CGROUPWB;
+
 	set_posix_acl_flag(sb);
 
 	/* version 5 superblocks support inode version counters. */
-- 
2.20.1

