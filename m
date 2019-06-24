Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E87750C3A
	for <lists+linux-xfs@lfdr.de>; Mon, 24 Jun 2019 15:44:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729707AbfFXNoJ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 24 Jun 2019 09:44:09 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:39870 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727763AbfFXNoJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jun 2019 09:44:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=HUCmbMyhBf9KqDj4JRsBMrrsBxX/IF3m3o5NBEotTD0=; b=OUBirhNtmDrH3+jdO5I5ZSx5t
        rK1LhtFB4+YN2M7ceR8F2JQtKXKGy97W4sQzPYsg2LWJPNEHm8JYc+SK4KRU0OLI9txDF2BYV2XJL
        D9hRw1QFmTAzI7K/ASY8c7EB+9SJpfBdwgJ2WQJyvPTS9MDK8U/CQkq8xysdzaatk75ajnOO9251M
        5Xs6boCdD+2a5kjXfowTepqr+T/3bzTieRbUuWvuaXLmAKUN/QZt3UIpIGcjmD1QYdaiv+Wa7n6I3
        H84XsmjZo59M7n5z80qUAKhLIAFOyoHPcwJO5kYr+0INIPRlRUWQ3O1TOYavBA0oUn/cnAfBx0jIW
        Ez+RFvGJg==;
Received: from clnet-p19-102.ikbnet.co.at ([83.175.77.102] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hfPGS-0007Q4-Kp; Mon, 24 Jun 2019 13:44:09 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: [PATCH] shared/011: run on all file system that support cgroup writeback
Date:   Mon, 24 Jun 2019 15:44:07 +0200
Message-Id: <20190624134407.21365-1-hch@lst.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Run the cgroup writeback test on xfs, for which I've just posted
a patch to support cgroup writeback as well as ext2 and f2fs, which
have supported cgroup writeback for a while now.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/shared/011 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/shared/011 b/tests/shared/011
index a0ac375d..96ce9d1c 100755
--- a/tests/shared/011
+++ b/tests/shared/011
@@ -39,7 +39,7 @@ rm -f $seqres.full
 # real QA test starts here
 
 # Modify as appropriate.
-_supported_fs ext4 btrfs
+_supported_fs ext2 ext4 f2fs btrfs xfs
 _supported_os Linux
 _require_scratch
 _require_cgroup2 io
-- 
2.20.1

