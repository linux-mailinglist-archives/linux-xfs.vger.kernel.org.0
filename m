Return-Path: <linux-xfs+bounces-30785-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wJUIC7rejWnE8AAAu9opvQ
	(envelope-from <linux-xfs+bounces-30785-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Thu, 12 Feb 2026 15:07:54 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id C9F7412E20C
	for <lists+linux-xfs@lfdr.de>; Thu, 12 Feb 2026 15:07:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 82D8130514A1
	for <lists+linux-xfs@lfdr.de>; Thu, 12 Feb 2026 14:03:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29B8E3EBF1F;
	Thu, 12 Feb 2026 14:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Qp6I5Ocf"
X-Original-To: linux-xfs@vger.kernel.org
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EC392253FF
	for <linux-xfs@vger.kernel.org>; Thu, 12 Feb 2026 14:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770904990; cv=none; b=JoEfnLNGDWv7bDo8Hgsi8kpQDiO+ciLjiLYmJUYuaN3sn3mReB2/IeZKdGuhmKDV3Rn3TARUsa8XbgcDxSkRurjQxcslR6h7tLQ+O4Qkry62yy1yfunaZhHUCHCtInaD6pJqmWcH6YO2GkuoRHbCyYWt9U2Bo9qHMiDqwmH2Qqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770904990; c=relaxed/simple;
	bh=xqY8i9/9jTt2vk6qo2Qg930oQIqaK/ahOW7yiJx+wpA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EXOrvdaQGWvAwM1fKYcnLEIb7ckEf21iSc0aPH9ZbOvy3cedHICE3SeaZ4Ec6QGcdawyy4bBNgjnRy9kuah4knmFj2UKLHsvOb1uSToyGeQxmoGPs8/15GUV73wF/ru5CDf+Wlb9aBrJ0o+uRr/XozIHUZRTCJD0s7hd3NVpaik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Qp6I5Ocf; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-824adf81fa6so548148b3a.3
        for <linux-xfs@vger.kernel.org>; Thu, 12 Feb 2026 06:03:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770904988; x=1771509788; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lji41OuF5Kzm1LKV7vngj1JOIsuCXtmHi4Ic/mVbOUQ=;
        b=Qp6I5OcfjPIAuvLYiM3cohmdFbOhnvevK8AC7nQxmRvrskkACVP/3fGmJjwwqfhvT1
         StGapAHPB5S9tJC/W57+YjY6fjdUXcuwESdThvKg25Sdo7fmvdSgNrBIm8gN7N3nA4Nz
         6khFUd3wbCSPsneZPWK92nozwY75BG2pKqFs93H0v2tGWfbbxiOIl664L8K2cR0A7xCt
         QAfbQqTas7Mg7bbQ1pnpuDIK2skUzpguWLcurDMupNUAHa4dj7GgL4oIwv/FLRvM9znu
         82O0D9d5e5Cnj+Op3U2YCcJb7wD8AMrQpq9RqZgryE8y2Ho0BapV+nvoBdp3rwa3jzFT
         FD6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770904988; x=1771509788;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lji41OuF5Kzm1LKV7vngj1JOIsuCXtmHi4Ic/mVbOUQ=;
        b=kZbrad3adi/CEgccfWLzv9J2o81r4eb+7YS6wGSDpi5Z44IaYWJVdZJLXfMA8VG/Pg
         GyTSLI3dLPS4Qk0QF3Mnw+1mFJm7boQkJy6eUnv7X4PC6nLXDrDXSd0aJqC2EuM1SIhd
         ZS6UQ8BFS/UQU+BcxBIWL4N23t2XmcS1UKMAWgR5sv1v1ZOIx/UgA4m1X2FlrmDeJhZP
         roUv7T9LEgZTp92rr9m0sHJsFl8ny1buZK3ltsveTWFC/eIHJqgCeQf7ah3KCBfUPpPy
         5defUz/R09r4OStDEMIPoN76O3ACpDQA84jPoCBSPo3+mcBsoY3keBkbcoXxhJtZ3cNK
         k8Ig==
X-Gm-Message-State: AOJu0Yzyc58lOaz3IyG8eSy42oITjg2GocDFhBFqjWlTtex6JW4EEUwQ
	P1qggdLayKox0FwaQgG+/Jx0LuOqUy1x24jfawNAtUO1uDLnCS9sqeZI
X-Gm-Gg: AZuq6aKYizNKw56oTo6K7i7hCY7t+lIC+/215PFBvzw/G+Sjz66Yh8U5J3usJ7I2/Xi
	7MDNuJJM5pzn2jaskOwsEDN3wldiEXa2Lp90+5kJuq25kvGVNKrqvxZr2aRmHPSjyr8ZoqIt78V
	6VaTEIDN7MNoFXdI7xTFmCipa3A3BIzk/EWflxp8NIUeo+yigri43kVQTRpbE2iqseFLk5Hsm2a
	KJfQ8o+1RSmgu0wr3FGxQfZLSwOaHePvrUncx94W+wYvtJ6CbUe83TsNkYtqdkfrJuxkLgvA584
	z0vekjh3hcCpZQSpl/wLy5aP8zRxaadCSbT1BPy5a6RIDxYs7tUroLbdf6sgC66AodJ9oMQP+1U
	M4Lg50+4u6FUpEm4sVuo83UhHAjMkiq9nY5x6dj9tClYrAjhxX4zcG1KsEnoItHW3FMX/XeoGef
	ZTKuVOtl+qf5D9vfkhu/WaUOMNaVNWf7SJ9MSKhEUaWPZleQ7HToxXNCUO45vt3NzQ457HYpjkM
	cvJAIViQg==
X-Received: by 2002:a05:6a00:a218:b0:81c:717b:9d35 with SMTP id d2e1a72fcca58-824b045c648mr2665670b3a.28.1770904985220;
        Thu, 12 Feb 2026 06:03:05 -0800 (PST)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com.com ([49.207.226.188])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8249e367b7esm5116590b3a.4.2026.02.12.06.03.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Feb 2026 06:03:04 -0800 (PST)
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
To: djwong@kernel.org,
	hch@infradead.org,
	cem@kernel.org
Cc: linux-xfs@vger.kernel.org,
	ritesh.list@gmail.com,
	ojaswin@linux.ibm.com,
	nirjhar.roy.lists@gmail.com
Subject: [PATCH v1 4/4] xfs: Add some comments in some macros.
Date: Thu, 12 Feb 2026 19:31:47 +0530
Message-ID: <96578ab7bc45eced7c4a3de66c7b81fec2f2095d.1770904484.git.nirjhar.roy.lists@gmail.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <cover.1770904484.git.nirjhar.roy.lists@gmail.com>
References: <cover.1770904484.git.nirjhar.roy.lists@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_FROM(0.00)[bounces-30785-lists,linux-xfs=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com,linux.ibm.com];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[nirjharroylists@gmail.com,linux-xfs@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[linux-xfs];
	RCPT_COUNT_SEVEN(0.00)[7];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: C9F7412E20C
X-Rspamd-Action: no action

Some comments on usage of XFS_IS_CORRUPT() and ASSERT.

Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
---
 fs/xfs/xfs_linux.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index 4dd747bdbcca..3a69dff50bfd 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -225,6 +225,7 @@ int xfs_rw_bdev(struct block_device *bdev, sector_t sector, unsigned int count,
 
 #ifdef XFS_WARN
 
+/* Please note that this ASSERT doesn't kill the kernel */
 #define ASSERT(expr)	\
 	(likely(expr) ? (void)0 : asswarn(NULL, #expr, __FILE__, __LINE__))
 
@@ -235,6 +236,11 @@ int xfs_rw_bdev(struct block_device *bdev, sector_t sector, unsigned int count,
 #endif /* XFS_WARN */
 #endif /* DEBUG */
 
+/*
+ * Use this to catch metadata corruptions that are not caught by the regular
+ * verifiers. The reason is that the verifiers check corruptions only within
+ * the block.
+ */
 #define XFS_IS_CORRUPT(mp, expr)	\
 	(unlikely(expr) ? xfs_corruption_error(#expr, XFS_ERRLEVEL_LOW, (mp), \
 					       NULL, 0, __FILE__, __LINE__, \
-- 
2.43.5


