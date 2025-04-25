Return-Path: <linux-xfs+bounces-21876-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E59D9A9C65C
	for <lists+linux-xfs@lfdr.de>; Fri, 25 Apr 2025 12:57:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3CFA917134A
	for <lists+linux-xfs@lfdr.de>; Fri, 25 Apr 2025 10:57:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D28023A58B;
	Fri, 25 Apr 2025 10:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="HNkqpsCK"
X-Original-To: linux-xfs@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD47D1FC7E7;
	Fri, 25 Apr 2025 10:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745578629; cv=none; b=EbVr6vIl/Rm+iJ6AP4RL75HuUsNWz9pdLnf7A3hkQoHxFwOl5w7svjmwNbpcLd1O8La9jR2LODYESHlpP5QXEDdf9rFN0intPpzaX2ktuMeNPN4B4/zU9bd9flUsq9PxiDMCRajnJAxlphzZFEEaDSgvxWl70tG3Ruy+NZiDPfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745578629; c=relaxed/simple;
	bh=U1AP8Vp6gymlW5LbPui+5j590E4DK1rbwyZvEsY/+mo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MDKcwn6j0fz70antGNEFKfyrIaWTrW8SMq1XXF5sDLkAnEZwrKwIVs3nk3fJxXsZXOg66dWVP9v18ACKDBwyfdAJOX97gAJH9lrMoCEOeKm+TVW/KyGRZDNIPW4YZGWkyy7jef2sWH2j4bQcc7W64d90yiX7PCgYJ3i97H61Apw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=HNkqpsCK; arc=none smtp.client-ip=117.135.210.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:Subject:Date:Message-ID:MIME-Version; bh=e+aUN
	DuOX0Nk2fqzeFbWOErRpUPr6PDp+yz5IsRUTmA=; b=HNkqpsCKZUdvC4djhRc3A
	gTpcDsVR/ZCtyrBs12xl3AKZFo5o0+OGguJRY9U+Ls1z/sQ+THcDpVq6CpLwTa79
	8JRpGEYEnGzw9osxmrggxqLmDMQwS8LPxROxQsAoH8ASsFHhcKE8sZY5lKRyObZW
	v0p3fScNOUvMuU1HHeCFpE=
Received: from chi-Redmi-Book.. (unknown [])
	by gzsmtp4 (Coremail) with SMTP id PygvCgAHVbB1agtoLX64Ag--.54305S2;
	Fri, 25 Apr 2025 18:56:55 +0800 (CST)
From: Chi Zhiling <chizhiling@163.com>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Chi Zhiling <chizhiling@kylinos.cn>
Subject: [RFC PATCH 0/2] Implement concurrent buffered write with folio lock
Date: Fri, 25 Apr 2025 18:38:39 +0800
Message-ID: <20250425103841.3164087-1-chizhiling@163.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PygvCgAHVbB1agtoLX64Ag--.54305S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrZry7KFW7AFW7Jry3Cw1rJFb_yoWDCwcE9F
	4vqryxJr10qF4UJaySkFn8JrZ09a1UGF18AFWktF43Wr98AFnIgw4DArySkr1qg3WUt3Z5
	JrWkA34fCrnFkjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU1Gg4PUUUUU==
X-CM-SenderInfo: hfkl6xxlol0wi6rwjhhfrp/xtbBgAE6nWgLW4qwQgABsn

From: Chi Zhiling <chizhiling@kylinos.cn>

This is a patch attempting to implement concurrent buffered writes.
The main idea is to use the folio lock to ensure the atomicity of the
write when writing to a single folio, instead of using the i_rwsem.

I tried the "folio batch" solution, which is a great idea, but during
testing, I encountered an OOM issue because the locked folios couldn't
be reclaimed.

So for now, I can only allow concurrent writes within a single block.
The good news is that since we already support BS > PS, we can use a
larger block size to enable higher granularity concurrency.

These ideas come from previous discussions:
https://lore.kernel.org/all/953b0499-5832-49dc-8580-436cf625db8c@163.com/


Chi Zhiling (2):
  xfs: Add i_direct_mode to indicate the IO mode of inode
  xfs: Enable concurrency when writing within single block

 fs/xfs/xfs_file.c  | 71 ++++++++++++++++++++++++++++++++++++++++++----
 fs/xfs/xfs_inode.h |  6 ++++
 2 files changed, 72 insertions(+), 5 deletions(-)

-- 
2.43.0


