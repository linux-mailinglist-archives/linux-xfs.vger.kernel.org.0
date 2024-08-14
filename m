Return-Path: <linux-xfs+bounces-11663-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8957A9524B1
	for <lists+linux-xfs@lfdr.de>; Wed, 14 Aug 2024 23:26:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 45D56281441
	for <lists+linux-xfs@lfdr.de>; Wed, 14 Aug 2024 21:26:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 474101C9DFA;
	Wed, 14 Aug 2024 21:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="dwhmid1F"
X-Original-To: linux-xfs@vger.kernel.org
Received: from mail-oo1-f46.google.com (mail-oo1-f46.google.com [209.85.161.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BB691C8FC3
	for <linux-xfs@vger.kernel.org>; Wed, 14 Aug 2024 21:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723670772; cv=none; b=e5R27j7/ilo9kjTjOzwm59rctgm4rsTEHVjoEURcX/XhG/yN7UJZvA4u2pYrLevURpRLx1moAv7basnqKIsAG/DVeqM1+gKECby9Hf05UTG25XSUHO0Vj+oXYbmzp6bW1By7kRCQ3FxiOud7FhFEHdq1+1WOq7J8IWn4FPmjHao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723670772; c=relaxed/simple;
	bh=pD+LVjuiFGqxiYXNcE7SFfWih4a6NzbE/J64a1HUTSE=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ztbqii1T0yN/qdDbzlIYjAGU+aFh5rke/FEED5OGRCDouy3OD7b3RHuAXYpdcwUvZM71kDY5w0o2sq5/dMe9hHMgAc3GuXKvDwueRaNM8NHrwuf1LnueSWA2lURt6ADJRqwhkVrMant2fNf1eje5ohtz4rdvMojiRek4stnNinA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=dwhmid1F; arc=none smtp.client-ip=209.85.161.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Received: by mail-oo1-f46.google.com with SMTP id 006d021491bc7-5d5d0535396so187560eaf.1
        for <linux-xfs@vger.kernel.org>; Wed, 14 Aug 2024 14:26:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1723670769; x=1724275569; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=03GJ1k40z8a5Psi/RqpgoqHfW5s1FJwp4eQtJBRMqtc=;
        b=dwhmid1FiaJqaBZR/k5Rr3PyIAu+zVraohw0tWiYQwxLa5ILvudOESc5h8YYkc1d0w
         hqZVyMXa9ShT9cTtpFg9u3OR8k5PmSwC3SSrrgRRbixjo+2suCr71dh7Wa22+zO+N6Hy
         5uQw0oq1zGzcpv9QhO+I7KzxhfZ+AIlPiiIOCH6aTP/YoCksC3Z02IdEFv5SOYYcTpOa
         QdLbn/7cOuaqlq5Pow47NfzzcTGWtE5fPHYI/sL5/JZAw3P8uF7kPMij2/qDWdDH85Rk
         0IZRYTcG7vlasQn8S5b0swv/qKTIxN+cedz+I+RMoi+Xa2VFQF+GNMaBgtauniDsu3U/
         bIkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723670769; x=1724275569;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=03GJ1k40z8a5Psi/RqpgoqHfW5s1FJwp4eQtJBRMqtc=;
        b=ohhFqrC0wKcDVdUb/I3B/fzVNbuxGEU7nXwNqnd31kF6d+0bM3cPjVL0RkaeFFBWjO
         YeP8pLWh96pdSczWO/OAN+PtrVRiEfeHQZP54n+tjwSmJOBvJRQ8QEoWpPkDHPazM0TX
         4Iuulcs9pXDqZlnV1C3129dc4PqAlE4TV5AWrIYkX/74EJXXH7/ehmMPLLrADdI3QmJe
         fU7jf9/0Hh0H5HEq2qV42dpcwRlB3ioJ5V2vWit2kYA2qTTdklQz+5VxQS2GrDpHSCUh
         M8nhn+RKpXuKVyDPP6GgzBrwCKdbn1n55jD1emGWtxOhJyz+G8NEc8iUWo0bTGUcdKGu
         RwAw==
X-Forwarded-Encrypted: i=1; AJvYcCVDorcWxSK0QLZbyrU82+h88EHg3dBZlAT6Nn+sEZUYGxDvVnpqLiJsSRl0Z8g5LsCa6SaKI9EWjdg4kSNXtbHjMK9y0bXapvsy
X-Gm-Message-State: AOJu0YzTdZ0k3x91XavqyANpzEIzWiOwe/31KJkhZO8jAd7w2MIYiJ2+
	VbN6OHt8T9eEZVcQRO7XiM7AUh6SPDLjSNiANUrcmTzAgC1+rMLUusJKuWQI70Q=
X-Google-Smtp-Source: AGHT+IHTmjx53oOy4ZaSkJClqvqNoIclprOHFm1rhknp6QMuI7g4a2JjrNNw/WvyavtTdJbWVmGPzw==
X-Received: by 2002:a05:6218:2612:b0:1af:7ea6:c95e with SMTP id e5c5f4694b2df-1b1aab1fe35mr483092455d.4.1723670769562;
        Wed, 14 Aug 2024 14:26:09 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a4ff02b136sm8804385a.25.2024.08.14.14.26.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Aug 2024 14:26:09 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: kernel-team@fb.com,
	linux-fsdevel@vger.kernel.org,
	jack@suse.cz,
	amir73il@gmail.com,
	brauner@kernel.org,
	linux-xfs@vger.kernel.org,
	gfs2@lists.linux.dev,
	linux-bcachefs@vger.kernel.org
Subject: [PATCH v4 05/16] fanotify: introduce FAN_PRE_MODIFY permission event
Date: Wed, 14 Aug 2024 17:25:23 -0400
Message-ID: <5142d1715dfecf58bc0a77eb410ca21d95e71cfc.1723670362.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1723670362.git.josef@toxicpanda.com>
References: <cover.1723670362.git.josef@toxicpanda.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Amir Goldstein <amir73il@gmail.com>

Generate FAN_PRE_MODIFY permission event from fsnotify_file_perm()
pre-write hook to notify fanotify listeners on an intent to make
modification to a file.

Like FAN_PRE_ACCESS, it is only allowed with FAN_CLASS_PRE_CONTENT
and unlike FAN_MODIFY, it is only allowed on regular files.

Like FAN_PRE_ACCESS, it is generated without sb_start_write() held,
so it is safe to perform filesystem modifications in the context of
event handler.

This pre-content event is meant to be used by hierarchical storage
managers that want to fill the content of files on first write access.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Christian Brauner <brauner@kernel.org>
---
 fs/notify/fanotify/fanotify.c      | 3 ++-
 fs/notify/fanotify/fanotify_user.c | 2 ++
 include/linux/fanotify.h           | 3 ++-
 include/uapi/linux/fanotify.h      | 1 +
 4 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/notify/fanotify/fanotify.c b/fs/notify/fanotify/fanotify.c
index 7dac8e4486df..b163594843f5 100644
--- a/fs/notify/fanotify/fanotify.c
+++ b/fs/notify/fanotify/fanotify.c
@@ -911,8 +911,9 @@ static int fanotify_handle_event(struct fsnotify_group *group, u32 mask,
 	BUILD_BUG_ON(FAN_FS_ERROR != FS_ERROR);
 	BUILD_BUG_ON(FAN_RENAME != FS_RENAME);
 	BUILD_BUG_ON(FAN_PRE_ACCESS != FS_PRE_ACCESS);
+	BUILD_BUG_ON(FAN_PRE_MODIFY != FS_PRE_MODIFY);
 
-	BUILD_BUG_ON(HWEIGHT32(ALL_FANOTIFY_EVENT_BITS) != 22);
+	BUILD_BUG_ON(HWEIGHT32(ALL_FANOTIFY_EVENT_BITS) != 23);
 
 	mask = fanotify_group_event_mask(group, iter_info, &match_mask,
 					 mask, data, data_type, dir);
diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index c294849e474f..3a7101544f30 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -1673,6 +1673,8 @@ static int fanotify_events_supported(struct fsnotify_group *group,
 	if (mask & FANOTIFY_PRE_CONTENT_EVENTS) {
 		if (!is_dir && !d_is_reg(path->dentry))
 			return -EINVAL;
+		if (is_dir && mask & FAN_PRE_MODIFY)
+			return -EISDIR;
 	}
 
 	return 0;
diff --git a/include/linux/fanotify.h b/include/linux/fanotify.h
index 5c811baf44d2..ae6cb2688d52 100644
--- a/include/linux/fanotify.h
+++ b/include/linux/fanotify.h
@@ -92,7 +92,8 @@
 #define FANOTIFY_CONTENT_PERM_EVENTS (FAN_OPEN_PERM | FAN_OPEN_EXEC_PERM | \
 				      FAN_ACCESS_PERM)
 /* Pre-content events can be used to fill file content */
-#define FANOTIFY_PRE_CONTENT_EVENTS  (FAN_PRE_ACCESS)
+#define FANOTIFY_PRE_CONTENT_EVENTS  (FAN_PRE_ACCESS | FAN_PRE_MODIFY)
+#define FANOTIFY_PRE_MODIFY_EVENTS   (FAN_PRE_MODIFY)
 
 /* Events that require a permission response from user */
 #define FANOTIFY_PERM_EVENTS	(FANOTIFY_CONTENT_PERM_EVENTS | \
diff --git a/include/uapi/linux/fanotify.h b/include/uapi/linux/fanotify.h
index bcada21a3a2e..ac00fad66416 100644
--- a/include/uapi/linux/fanotify.h
+++ b/include/uapi/linux/fanotify.h
@@ -27,6 +27,7 @@
 #define FAN_OPEN_EXEC_PERM	0x00040000	/* File open/exec in perm check */
 
 #define FAN_PRE_ACCESS		0x00080000	/* Pre-content access hook */
+#define FAN_PRE_MODIFY		0x00100000	/* Pre-content modify hook */
 
 #define FAN_EVENT_ON_CHILD	0x08000000	/* Interested in child events */
 
-- 
2.43.0


