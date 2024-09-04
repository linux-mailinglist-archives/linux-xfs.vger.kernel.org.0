Return-Path: <linux-xfs+bounces-12677-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 288EC96C88D
	for <lists+linux-xfs@lfdr.de>; Wed,  4 Sep 2024 22:32:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D6299289CBD
	for <lists+linux-xfs@lfdr.de>; Wed,  4 Sep 2024 20:31:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5EFA1E9769;
	Wed,  4 Sep 2024 20:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="mrbXx0A6"
X-Original-To: linux-xfs@vger.kernel.org
Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com [209.85.167.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F4381E9749
	for <linux-xfs@vger.kernel.org>; Wed,  4 Sep 2024 20:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725481783; cv=none; b=Nu2SpT2G5X/vJj70d7O+AmqS5eHdsk1UWM8YW8xzK7FC79NlWrPWVwtcK5auPFM1+Kb3tBq58EzuEM4GBpO5UypiW5IXX9v1Qr69nv0L642MS63P+T2s9QV8765mLnIqiG8eNzPercq8rPye0FT832CEzi0SSKgOZqMHyqkecPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725481783; c=relaxed/simple;
	bh=wT7ZMo9Fh5VSq1s78YBc49T5i3a6aTxkHXKOOzIvwHc=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AutPQ7cyg9qu6mAcsoqwQSa8nB9jmCN93cQojGtI9DBItPou1xnNaZ28rxmIOsHSKn+9FvNT2SyUieuvkeGAkUjzJN8IQ5MI3fqg9yIDmQw5AInRh0Ic87Ds/QXcZo5XbjL9D7XTsO+EormivOd4qx6pgUcEeSOLKumE77KayQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=mrbXx0A6; arc=none smtp.client-ip=209.85.167.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Received: by mail-oi1-f182.google.com with SMTP id 5614622812f47-3df0c4a65baso4328795b6e.2
        for <linux-xfs@vger.kernel.org>; Wed, 04 Sep 2024 13:29:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1725481781; x=1726086581; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8Z8sRCIfMieTISA3wuOPUcg1dm1vDp7n73Jg7OelYjY=;
        b=mrbXx0A6WH/L9F/fPw/ggso+cBDHyN1A7GYeDwwPskP0oJm2agj6nqKbMLk43qqGT2
         dIVvyTxbpUH2jTTkV2zEziSapTSRkwe6efAUMfczFha383yN2+CuTw6uzf8xVdqMgzVc
         Oe4qViReBFdwQYDxuq8V9hypR4kflvZbj/wdfKx6ZCWDVupnppn1QlUaFZNAYUfIfVnu
         Haw2a9VGKovzO/IqjQknOvYinhGLt+MKRU/PCk/caewdkcnHKCiQgGd1iNnlDuARJsUN
         2iK7Z3yafW1WPsPa7auDME3hQ5ZKuEI285FanwPCqh879HZ1pc+31u5MRZCVfEOS896L
         e9IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725481781; x=1726086581;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8Z8sRCIfMieTISA3wuOPUcg1dm1vDp7n73Jg7OelYjY=;
        b=OVAKxjA5FtOCbnKLYHhZjMxGcC1HzTyZaTeozOi8PpYkWgzEO6SlZjbOum8hScopxM
         SkQhYUOllWkGPwX7XWH4gKo5VGvY0GQt9DttP2rkpd11eeOyKAtsBk5NZvzs+73v762V
         monIvtYcaZ9x3+8gisY4pOpoH/iqB6cifq6lTxDadic/nMZAHoBLqvEtryTboLCVEfgg
         JTbAOUuSisqCOOZjSQARHMImRs7SrLFXhUHCBU8V5EbCMClG3V1YV8p77TapLk4TZdvP
         MvrOp5HMlM5aYqcvezMdo5SBEwSX9h99bNqOOq86I9HLjbKYlIIPkwoXcIkjtlDLHV6J
         idIA==
X-Forwarded-Encrypted: i=1; AJvYcCU3COR26my1jo2klDFgzYgpYRRYOcnDz7A4ikUqcCe6AfENn+zmNRIsBGKaBR+ll3BWnG48WjS1SFM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzfAKfgEBXZeVdWYxR0eGV7pQ3dwDpswEAO55z/VbjQ37nrX3A8
	JI7zinwLEjmxExvp6rkziyMeDWhFfZVKX9n8X79kNx8Gi/8iYOF9Hsa0UcS/NMM=
X-Google-Smtp-Source: AGHT+IETtHQ5ywMiUmPhP/0afBVUyPAVLJijgZTnYTfqkdZL3bCN8lBGOnkAyW3ORokI+fooL1bn0A==
X-Received: by 2002:a05:6808:f13:b0:3e0:483:8bc1 with SMTP id 5614622812f47-3e004838dfdmr11138749b6e.43.1725481781057;
        Wed, 04 Sep 2024 13:29:41 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-45801cbc493sm1441111cf.69.2024.09.04.13.29.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Sep 2024 13:29:40 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: kernel-team@fb.com,
	linux-fsdevel@vger.kernel.org,
	jack@suse.cz,
	amir73il@gmail.com,
	brauner@kernel.org,
	linux-xfs@vger.kernel.org,
	linux-bcachefs@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v5 16/18] xfs: add pre-content fsnotify hook for write faults
Date: Wed,  4 Sep 2024 16:28:06 -0400
Message-ID: <12aebe1a4f039d0234ea74393a39614c0244f7e0.1725481503.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1725481503.git.josef@toxicpanda.com>
References: <cover.1725481503.git.josef@toxicpanda.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

xfs has it's own handling for write faults, so we need to add the
pre-content fsnotify hook for this case.  Reads go through filemap_fault
so they're handled properly there.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/xfs/xfs_file.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 4cdc54dc9686..3e385756017f 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1283,6 +1283,10 @@ xfs_write_fault(
 	unsigned int		lock_mode = XFS_MMAPLOCK_SHARED;
 	vm_fault_t		ret;
 
+	ret = filemap_fsnotify_fault(vmf);
+	if (unlikely(ret))
+		return ret;
+
 	sb_start_pagefault(inode->i_sb);
 	file_update_time(vmf->vma->vm_file);
 
-- 
2.43.0


