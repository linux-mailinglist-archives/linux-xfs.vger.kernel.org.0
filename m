Return-Path: <linux-xfs+bounces-2985-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5940083BC77
	for <lists+linux-xfs@lfdr.de>; Thu, 25 Jan 2024 09:59:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EDF7C1F29D08
	for <lists+linux-xfs@lfdr.de>; Thu, 25 Jan 2024 08:59:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40FFB1BF2B;
	Thu, 25 Jan 2024 08:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Z3XEP95U"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFF861BF2A;
	Thu, 25 Jan 2024 08:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706173102; cv=none; b=rMXAEqUkvwjhjENiOgRAuv9qDsw4ebLGrfPOxoRKl4Ck+v4/OoG+dSkJQ3+9H6PpZ+RSow+GidiIoBE8Ly7DAFon2NvOjbSPy5dppva3ioF899S4bhKM3bTz/oliB+y0wKCy6uV/quk0pvbAgLIPjTPeIFlqDd2KZavAu8IOHhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706173102; c=relaxed/simple;
	bh=fJLE9r+QEojqvLMnrCNPOT7KyaYHqxx+aO7siaaR/Bk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WhV/6MmRntpbEvKKA5PM1HZYX6jWs6mOnPToBfD2RN90VtWohRfbimfu6F2QtU676alt68OAjrukX3kf7kC9W5errp17gnsaDIhKtDdb3kDCLNOtgfMM1wbFRYmjtLkQwJYX3VpPozKhujQm9BvKmyEaWWyOz7+7vRpAsYWfmI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Z3XEP95U; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=xkTkipsZ3cJs79h1k4zQ5uPIipflfgz0lHVVoqCuaRQ=; b=Z3XEP95URFlirst2CbG0dJA364
	FulC5T4auE+QQ1CfqyRb85iyZUG/TPGIRz5b0wz7TFrveqq3IdNZPwXIgIRRbr6NEALfARgSwvWOx
	HOiTEaXMXH8giauijMsmkpjphfncVFr2i+CdcM5P7ORAiBPrAHW6mSqcp0Z2JJDn03qMkxRCKBWQJ
	xUEWnDSWmFx6KsdgTmvqXzgUN0lUKW5JTLdLZlskqxCVmdYNC5ifTJBLUAUxGEz2nth6T+1RqkdAT
	riWAqFdM5DI2XAHdnBtVnh1L8WuYkmz6y2FwTQvZ7A+7O3awT4+96hnCM0clkbgm4A6kPyaJn2y36
	mUR50Qng==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rSvYp-007Q9V-1E;
	Thu, 25 Jan 2024 08:58:11 +0000
From: Christoph Hellwig <hch@lst.de>
To: linux-mm@kvack.org
Cc: Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.com>,
	David Howells <dhowells@redhat.com>,
	Brian Foster <bfoster@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jan Kara <jack@suse.cz>,
	Dave Chinner <dchinner@redhat.com>
Subject: [PATCH 02/19] writeback: also update wbc->nr_to_write on writeback failure
Date: Thu, 25 Jan 2024 09:57:41 +0100
Message-Id: <20240125085758.2393327-3-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240125085758.2393327-1-hch@lst.de>
References: <20240125085758.2393327-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

When exiting write_cache_pages early due to a non-integrity write
failure, wbc->nr_to_write currently doesn't account for the folio
we just failed to write.  This doesn't matter because the callers
always ingore the value on a failure, but moving the update to
common code will allow to simplify the code, so do it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jan Kara <jack@suse.cz>
Acked-by: Dave Chinner <dchinner@redhat.com>
---
 mm/page-writeback.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index ef2334291a7270..0c1e9c016bc48f 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -2473,6 +2473,7 @@ int write_cache_pages(struct address_space *mapping,
 			trace_wbc_writepage(wbc, inode_to_bdi(mapping->host));
 			error = writepage(folio, wbc, data);
 			nr = folio_nr_pages(folio);
+			wbc->nr_to_write -= nr;
 			if (unlikely(error)) {
 				/*
 				 * Handle errors according to the type of
@@ -2506,7 +2507,6 @@ int write_cache_pages(struct address_space *mapping,
 			 * we tagged for writeback prior to entering this loop.
 			 */
 			done_index = folio->index + nr;
-			wbc->nr_to_write -= nr;
 			if (wbc->nr_to_write <= 0 &&
 			    wbc->sync_mode == WB_SYNC_NONE) {
 				done = 1;
-- 
2.39.2


