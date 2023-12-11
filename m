Return-Path: <linux-xfs+bounces-600-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C6B880D20A
	for <lists+linux-xfs@lfdr.de>; Mon, 11 Dec 2023 17:38:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8DB6F1C212C8
	for <lists+linux-xfs@lfdr.de>; Mon, 11 Dec 2023 16:38:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 124E01D535;
	Mon, 11 Dec 2023 16:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="MCNKme/c"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E1FC98
	for <linux-xfs@vger.kernel.org>; Mon, 11 Dec 2023 08:37:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=d59nT4IHoHqgpRImVueFbui60aL9QlMykGN6BmiZgTU=; b=MCNKme/cmH6B81ktYd5yYrT6lg
	x6VhgqQC7SQ4/JrpPhS3UxieDsEejEWiXYtYe0Wt2mSqnRnCzLdpC8vimdCShwOPdriEI9+AmVTvn
	O41RteVw1BZg+dS80cpdWXcbmrf8fe+pnIown562BQHHLSkw6ob2Ms3e6jS6akfyOZLoXhF6qPs1j
	mUez0ZF4dceNv9aSSP/D0x2SP8bjRnH/cZq1tJFc0iDoJdHIRJzLXZqCA3rZ+LILkH9pV1nb766Z9
	FYa1JFIb127WPwQD6u3pTYO6x7Oq+T7ndpvMfyVZDXo3ttSYqng1Hg5i9Zg4vcYf8e4jkWeDsHMcU
	gR1vfEHQ==;
Received: from [2001:4bb8:19a:a621:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rCjHw-005sqq-2Z;
	Mon, 11 Dec 2023 16:37:49 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 01/23] libxfs: remove the unused icache_flags member from struct libxfs_xinit
Date: Mon, 11 Dec 2023 17:37:20 +0100
Message-Id: <20231211163742.837427-2-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231211163742.837427-1-hch@lst.de>
References: <20231211163742.837427-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/libxfs.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/libxfs.h b/include/libxfs.h
index b28781d19..9b0294cb8 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -124,7 +124,6 @@ typedef struct libxfs_xinit {
 	int             dfd;            /* data subvolume file descriptor */
 	int             logfd;          /* log subvolume file descriptor */
 	int             rtfd;           /* realtime subvolume file descriptor */
-	int		icache_flags;	/* cache init flags */
 	int		bcache_flags;	/* cache init flags */
 } libxfs_init_t;
 
-- 
2.39.2


