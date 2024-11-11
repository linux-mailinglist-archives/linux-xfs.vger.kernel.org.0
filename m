Return-Path: <linux-xfs+bounces-15252-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 85FF89C4697
	for <lists+linux-xfs@lfdr.de>; Mon, 11 Nov 2024 21:21:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 16B0D1F25628
	for <lists+linux-xfs@lfdr.de>; Mon, 11 Nov 2024 20:21:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F09F1C245C;
	Mon, 11 Nov 2024 20:19:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="RB/8HFdr"
X-Original-To: linux-xfs@vger.kernel.org
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4381C1B86CF
	for <linux-xfs@vger.kernel.org>; Mon, 11 Nov 2024 20:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731356366; cv=none; b=jRRUc5CDw3zyKlqLrcO9kCRIRn6bTXUpcUd39RmxotZhT9h2svQRPXBNnHRLWC2dMqcYieByO6kM3sliGCfXC777Nk/82HKJDRejECvAQuk7Zx1/0xX2+YigHa7EcAa5EmRy6sFXdbLn2hkTmX5L6hVruN5Qi6IBjo1n2upicKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731356366; c=relaxed/simple;
	bh=QBEIEok2zEjZt3JCIFogxoADuLr4VlZ3jLJ5rAkDDL0=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bGbDTZnkNoeqAgikCAr2Tn5ZXzKRKXz6dZT4jK3w/BLVTZeheoiAMcP7zS6zUw+Ui6jHAoj4Wqb/OHjUPXrtcVkQHYtp0uR6pO0Ec6TorHDeagFCz9Za4WdAZFl0VRQ0/ZqbtCCr1acyL5svtdO3z4TuFqFajcLvG5Fc4xZLIO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=RB/8HFdr; arc=none smtp.client-ip=209.85.222.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-7b1539faa0bso318198785a.1
        for <linux-xfs@vger.kernel.org>; Mon, 11 Nov 2024 12:19:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1731356364; x=1731961164; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LGryhZjhYAebksFaS9pdbr55rRjOBk5banX6k6b7VeY=;
        b=RB/8HFdrpaUKISo5/c+mHum5Up7uW0cVspSBHaW6+YPgOq+33HMHUKmeWWyt/TvKLT
         duyxHa8VkTVuJcvH5xuawsuoFf+wi2CnOODSHrVuxaDfCj8vl1jbVG9y16vORs1VPp32
         ccVstK1dgrzwm23LpUlSZ0O/s0OPcee8SrN2kJVZcFAOc23eqMiuczsRlD4fD2FZst9p
         +SfaiXeB52+vV+QfVEvC5dwF07A1s7ypt7cG9gZv5X+auOvFldiX6OyvyjB2AgXQa5mu
         dRvr8W7fJmk717t2iJp/A4BcGcuTprOUePivQfAyg1FJl9oZ0+t95eeaflKZKiW9ugeK
         ClDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731356364; x=1731961164;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LGryhZjhYAebksFaS9pdbr55rRjOBk5banX6k6b7VeY=;
        b=BzHgWitcbUXzjsfHUWxT86fQBsLY1qclJnJlZ8HoV6K3SCMToVj0LZ5CR6I4ICQWuk
         pz4KQFJ8pvKpoe5T+IMQLkLbmCZxkZwSVhfJ6ILVSkloK+bAC0nfURoIf0Z5meFfuKX2
         NjdrYcXwkVVh9kegtWaIFHZ4mxhXzgp5Q7KJBTE4KjxpEUIll/1tLXw3oZpUXerCpsQo
         Fr45bfZYIizeP5DD3Bv7bsPOV0pCu1BIL3UYkwqQB3L0R+FRVSMGG6oB+cYSQzHdxtKs
         ULifXNl0Z7GHXvU0HUUSB/3OIFCzWtIvO4hbytdVKvei/cTi5wVt24u1CJQ/bKxFObdQ
         SYwQ==
X-Forwarded-Encrypted: i=1; AJvYcCXLbAN8Qzz4QJS75bEMVNznDOKdOrF/XDdCmmk4QTtiWZmpW7wv5MbE3Dx9k9+bZ/bVt47w5lQT5gA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw9EU3ekq0wr3LokwrlyC9tjb/Kz6cgOuNimU5Z3n5+UVLLeYjv
	ykh+o2VEoX0g9afjzrh8hvLFuXSqnK4IHiNtBxMSKQLDAyRt+FX2qOb1OKGGiqU=
X-Google-Smtp-Source: AGHT+IF22B/D1c9DuKVBsfxqpgJ2vY2z65TspT6Q0Pw0A6vpDeL8FShi0pjnRxFhWA3rscCdafTgdQ==
X-Received: by 2002:a05:620a:1a94:b0:7b1:48ff:6b3c with SMTP id af79cd13be357-7b331d8b905mr1736558085a.16.1731356364156;
        Mon, 11 Nov 2024 12:19:24 -0800 (PST)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7b32ac57002sm525823885a.43.2024.11.11.12.19.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Nov 2024 12:19:23 -0800 (PST)
From: Josef Bacik <josef@toxicpanda.com>
To: kernel-team@fb.com,
	linux-fsdevel@vger.kernel.org,
	jack@suse.cz,
	amir73il@gmail.com,
	brauner@kernel.org,
	torvalds@linux-foundation.org,
	linux-xfs@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-mm@kvack.org,
	linux-ext4@vger.kernel.org
Subject: [PATCH v6 09/17] fanotify: report file range info with pre-content events
Date: Mon, 11 Nov 2024 15:17:58 -0500
Message-ID: <2146833d30122ef9a031e231d8ced7d8a085196d.1731355931.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1731355931.git.josef@toxicpanda.com>
References: <cover.1731355931.git.josef@toxicpanda.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Amir Goldstein <amir73il@gmail.com>

With group class FAN_CLASS_PRE_CONTENT, report offset and length info
along with FAN_PRE_ACCESS pre-content events.

This information is meant to be used by hierarchical storage managers
that want to fill partial content of files on first access to range.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/notify/fanotify/fanotify.h      |  8 +++++++
 fs/notify/fanotify/fanotify_user.c | 38 ++++++++++++++++++++++++++++++
 include/uapi/linux/fanotify.h      |  8 +++++++
 3 files changed, 54 insertions(+)

diff --git a/fs/notify/fanotify/fanotify.h b/fs/notify/fanotify/fanotify.h
index 93598b7d5952..7f06355afa1f 100644
--- a/fs/notify/fanotify/fanotify.h
+++ b/fs/notify/fanotify/fanotify.h
@@ -448,6 +448,14 @@ static inline bool fanotify_is_perm_event(u32 mask)
 		mask & FANOTIFY_PERM_EVENTS;
 }
 
+static inline bool fanotify_event_has_access_range(struct fanotify_event *event)
+{
+	if (!(event->mask & FANOTIFY_PRE_CONTENT_EVENTS))
+		return false;
+
+	return FANOTIFY_PERM(event)->ppos;
+}
+
 static inline struct fanotify_event *FANOTIFY_E(struct fsnotify_event *fse)
 {
 	return container_of(fse, struct fanotify_event, fse);
diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index da9cf09565ce..17402f9e8609 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -123,6 +123,8 @@ struct kmem_cache *fanotify_perm_event_cachep __ro_after_init;
 	sizeof(struct fanotify_event_info_pidfd)
 #define FANOTIFY_ERROR_INFO_LEN \
 	(sizeof(struct fanotify_event_info_error))
+#define FANOTIFY_RANGE_INFO_LEN \
+	(sizeof(struct fanotify_event_info_range))
 
 static int fanotify_fid_info_len(int fh_len, int name_len)
 {
@@ -182,6 +184,9 @@ static size_t fanotify_event_len(unsigned int info_mode,
 	if (info_mode & FAN_REPORT_PIDFD)
 		event_len += FANOTIFY_PIDFD_INFO_LEN;
 
+	if (fanotify_event_has_access_range(event))
+		event_len += FANOTIFY_RANGE_INFO_LEN;
+
 	return event_len;
 }
 
@@ -519,6 +524,30 @@ static int copy_pidfd_info_to_user(int pidfd,
 	return info_len;
 }
 
+static size_t copy_range_info_to_user(struct fanotify_event *event,
+				      char __user *buf, int count)
+{
+	struct fanotify_perm_event *pevent = FANOTIFY_PERM(event);
+	struct fanotify_event_info_range info = { };
+	size_t info_len = FANOTIFY_RANGE_INFO_LEN;
+
+	if (WARN_ON_ONCE(info_len > count))
+		return -EFAULT;
+
+	if (WARN_ON_ONCE(!pevent->ppos))
+		return -EINVAL;
+
+	info.hdr.info_type = FAN_EVENT_INFO_TYPE_RANGE;
+	info.hdr.len = info_len;
+	info.offset = *(pevent->ppos);
+	info.count = pevent->count;
+
+	if (copy_to_user(buf, &info, info_len))
+		return -EFAULT;
+
+	return info_len;
+}
+
 static int copy_info_records_to_user(struct fanotify_event *event,
 				     struct fanotify_info *info,
 				     unsigned int info_mode, int pidfd,
@@ -640,6 +669,15 @@ static int copy_info_records_to_user(struct fanotify_event *event,
 		total_bytes += ret;
 	}
 
+	if (fanotify_event_has_access_range(event)) {
+		ret = copy_range_info_to_user(event, buf, count);
+		if (ret < 0)
+			return ret;
+		buf += ret;
+		count -= ret;
+		total_bytes += ret;
+	}
+
 	return total_bytes;
 }
 
diff --git a/include/uapi/linux/fanotify.h b/include/uapi/linux/fanotify.h
index 7596168c80eb..0636a9c85dd0 100644
--- a/include/uapi/linux/fanotify.h
+++ b/include/uapi/linux/fanotify.h
@@ -146,6 +146,7 @@ struct fanotify_event_metadata {
 #define FAN_EVENT_INFO_TYPE_DFID	3
 #define FAN_EVENT_INFO_TYPE_PIDFD	4
 #define FAN_EVENT_INFO_TYPE_ERROR	5
+#define FAN_EVENT_INFO_TYPE_RANGE	6
 
 /* Special info types for FAN_RENAME */
 #define FAN_EVENT_INFO_TYPE_OLD_DFID_NAME	10
@@ -192,6 +193,13 @@ struct fanotify_event_info_error {
 	__u32 error_count;
 };
 
+struct fanotify_event_info_range {
+	struct fanotify_event_info_header hdr;
+	__u32 pad;
+	__u64 offset;
+	__u64 count;
+};
+
 /*
  * User space may need to record additional information about its decision.
  * The extra information type records what kind of information is included.
-- 
2.43.0


