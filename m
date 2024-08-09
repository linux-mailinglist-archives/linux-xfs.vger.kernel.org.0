Return-Path: <linux-xfs+bounces-11492-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8EF1194D697
	for <lists+linux-xfs@lfdr.de>; Fri,  9 Aug 2024 20:45:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4162C282FB7
	for <lists+linux-xfs@lfdr.de>; Fri,  9 Aug 2024 18:45:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA54C168491;
	Fri,  9 Aug 2024 18:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="gUo0/4bJ"
X-Original-To: linux-xfs@vger.kernel.org
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 198A01607BB
	for <linux-xfs@vger.kernel.org>; Fri,  9 Aug 2024 18:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723229105; cv=none; b=NBkekYMWw98u+DituiLwBw6ywvmMS9ER+k7iF7MlRUjvz7xLagI/fd1It59KsucWTUrQClDChg8SmV1710BbcD9hxH6rpoUkvu6RcfvfqxUZJwjXKcCGhKXDPq4EPRPS22fPgG0716FR0tGLzfbwWzmWHApuJpc/1hxbrIf7WYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723229105; c=relaxed/simple;
	bh=x/zxNttmCT+y0dOsXy0tvMYfEvnIhvz+MK7V5Zr+cWQ=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gS9pEufU+8jiDnoxkVZ/Axegq6e9inFVOEI8sjN2sJnpdgfUB7YC/9IYd7JisWzD8mSTh4t1jM1tJrBbekFL1I3LuhX/ouqlXWHhpqt+6I2NNZJ+1mafaleSfqDr/7pzWC3CmH5F5dE8V2EQcwf1xWRxMd8h0a0HS76BKT1Cc18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=gUo0/4bJ; arc=none smtp.client-ip=209.85.222.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-79ef72bb8c8so100186485a.2
        for <linux-xfs@vger.kernel.org>; Fri, 09 Aug 2024 11:45:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1723229103; x=1723833903; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=c/Hz6ZhLh0CWwWHWSWJMj1KvT9KtOfMKuwzMM3GJFXM=;
        b=gUo0/4bJ0sH5WGF3w1UTD4zDlqnNphE+9uXaL27BP3CYTMuk7nk498v0koRPTVkUAx
         i9Dl5HuQUgqyhBS+ljkiT1SeEzgoRuWebu1vljybilwWB9SAa3v5Mk94CULIyqHalvHo
         xFHh73hseuvREgckT1NMgiWRp35jlkuhetNU5xS/JTK1WSDT6tigCqPA5BovEwIQPkEn
         lLfwb+fS9OcRNr/6Skqqu0GpztsC16giVputh7wktHlWf9iQrphrc6xfHJZ8milPhX0N
         7d7Zn9bj5lJVnj0bHmGY57Pww41bv1jv6SxIg3YzBK+OBiSMf67D9eG74bRcFwSQ+UF6
         YMcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723229103; x=1723833903;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c/Hz6ZhLh0CWwWHWSWJMj1KvT9KtOfMKuwzMM3GJFXM=;
        b=MsG1WLPYN1GV4Dvt1Fo2o3cnqcARKx6/iSHFTlm7+YixTmO9vQPCbkxrY4uyA2am3X
         gp9OVBwsjlneU+SjgSeTDt3QnIQBGLBQL9VmFYHFpD6ulalTLZEno2PZ9LAJA+R39Xfn
         ZSGk2R82sTLnWjKexH8s++wfb+msoe98oS7ziJ5/em/bwo7AkcKG4wwtXqR0jHg8/oYW
         Rwa5VV34ys8zB+eL68qa+YbYgGMWdo5AyevRkGYAFgPr7bRx5dO7qBC7ho0rM7IThbl9
         r0QcLKxYd7osm9Bn2x1UdGMi7PuJIigLHmp196q9HWT5g6COB7D5Ky0xt8Vlr5C9z9IA
         WUtA==
X-Forwarded-Encrypted: i=1; AJvYcCXFpQAq2m+VXyR3szNHH56a9KjhYyJIiJCE5QfS1qIEv6NhUxrX8TXnG7WSIh+6gdOc8cQ9xu7ua+rqC+dLjHEBNzVSnORaRg6g
X-Gm-Message-State: AOJu0Yy8hJmH8j38YVHHB4CVzRcvrNTzxXf8CfRAK6TEXIvTgQK0FkuI
	UNMZYnEKYcs/6ep3N7AGkfgHVCusXxVM9fGZe8BPTRhsFdFy9C3JJZyvTob0PK5z/rM7XguAKoo
	L
X-Google-Smtp-Source: AGHT+IEIbv/fofhxlK5ZEcOd7R2JvcZpA0PjT9A+quKRPs53fKNVchqwyqsM9QW/LaUgq4RQ8LraRg==
X-Received: by 2002:a05:620a:3704:b0:797:91a7:4f36 with SMTP id af79cd13be357-7a4c18644afmr258081085a.62.1723229103009;
        Fri, 09 Aug 2024 11:45:03 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a4c7e01fb5sm3766485a.99.2024.08.09.11.45.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Aug 2024 11:45:02 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: kernel-team@fb.com,
	linux-fsdevel@vger.kernel.org,
	jack@suse.cz,
	amir73il@gmail.com,
	brauner@kernel.org,
	linux-xfs@vger.kernel.org,
	gfs2@lists.linux.dev,
	linux-bcachefs@vger.kernel.org
Subject: [PATCH v3 08/16] fanotify: report file range info with pre-content events
Date: Fri,  9 Aug 2024 14:44:16 -0400
Message-ID: <b72ac7d8171570eaa9adf05e5a55f6ea8ba41ac2.1723228772.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1723228772.git.josef@toxicpanda.com>
References: <cover.1723228772.git.josef@toxicpanda.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Amir Goldstein <amir73il@gmail.com>

With group class FAN_CLASS_PRE_CONTENT, report offset and length info
along with FAN_PRE_ACCESS and FAN_PRE_MODIFY permission events.

This information is meant to be used by hierarchical storage managers
that want to fill partial content of files on first access to range.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/notify/fanotify/fanotify.h      |  8 +++++++
 fs/notify/fanotify/fanotify_user.c | 38 ++++++++++++++++++++++++++++++
 include/uapi/linux/fanotify.h      |  7 ++++++
 3 files changed, 53 insertions(+)

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
index 5ece186d5c50..ed56fe6f5ec7 100644
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
 
@@ -526,6 +531,30 @@ static int copy_pidfd_info_to_user(int pidfd,
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
@@ -647,6 +676,15 @@ static int copy_info_records_to_user(struct fanotify_event *event,
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
index ac00fad66416..cc28dce5f744 100644
--- a/include/uapi/linux/fanotify.h
+++ b/include/uapi/linux/fanotify.h
@@ -145,6 +145,7 @@ struct fanotify_event_metadata {
 #define FAN_EVENT_INFO_TYPE_DFID	3
 #define FAN_EVENT_INFO_TYPE_PIDFD	4
 #define FAN_EVENT_INFO_TYPE_ERROR	5
+#define FAN_EVENT_INFO_TYPE_RANGE	6
 
 /* Special info types for FAN_RENAME */
 #define FAN_EVENT_INFO_TYPE_OLD_DFID_NAME	10
@@ -191,6 +192,12 @@ struct fanotify_event_info_error {
 	__u32 error_count;
 };
 
+struct fanotify_event_info_range {
+	struct fanotify_event_info_header hdr;
+	__u64 offset;
+	__u64 count;
+};
+
 /*
  * User space may need to record additional information about its decision.
  * The extra information type records what kind of information is included.
-- 
2.43.0


