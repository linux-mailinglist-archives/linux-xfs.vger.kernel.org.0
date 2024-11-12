Return-Path: <linux-xfs+bounces-15324-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 458799C6309
	for <lists+linux-xfs@lfdr.de>; Tue, 12 Nov 2024 22:04:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 05A65B398FD
	for <lists+linux-xfs@lfdr.de>; Tue, 12 Nov 2024 17:59:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6300D21949E;
	Tue, 12 Nov 2024 17:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="Byyv2E8Q"
X-Original-To: linux-xfs@vger.kernel.org
Received: from mail-yb1-f170.google.com (mail-yb1-f170.google.com [209.85.219.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A4BE218D7A
	for <linux-xfs@vger.kernel.org>; Tue, 12 Nov 2024 17:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731434208; cv=none; b=RPbsB4zerzthm3sitELYpf3YJW10dcC2kxLte7DA+zwUWrZRNeoqCu0l8ZcXqLw0ITnVA4aM9hR9sYyYjxAbnXVKHRL20ePFO2WEdWbNSLiDFARA1erX2PqPNxXws9h33sM4nGMfHMwY/IqXt4ZbCaoG/IuQT88RNXEMgMxazgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731434208; c=relaxed/simple;
	bh=5B5wDUCiexWCnhtjvpbGBVK7zLBdlwK0uzIP7IVVbW8=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=He5365e5bwQnSIOcNviwHO5yZGVSkbylB2H5p5Bbmx2QfU9HFGNXvoVM2AZMQ3gm5n0wyzV8lKpToSrAsxTmzK7M9S7l+wFwVmwJ37pIT7rabbWgCyZ5o7NK60FDvrScec7COHeGR/8dbhjF9XLee3akceWk2vG5gGo+7OoujyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=Byyv2E8Q; arc=none smtp.client-ip=209.85.219.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Received: by mail-yb1-f170.google.com with SMTP id 3f1490d57ef6-e2e444e355fso5304544276.1
        for <linux-xfs@vger.kernel.org>; Tue, 12 Nov 2024 09:56:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1731434205; x=1732039005; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wpMEZ8etGpHeGwDSCw0SFADsZn6aen0TJzBYBdUeEVI=;
        b=Byyv2E8QuXz+yoScHHiciIwNxo7g1QV5EPigLtEkzdWDjXA73IFXOWRUjPNMaFNBze
         lz79fUq1vabDgoYgSnjQ8TocP3h/qL74fS3YzuFuTl3gcM5kTpJwo6M088fxPd/S0lCa
         y9e+t3ZwfJQEJEP46yTDHkUeJctCN1rBhRE6+D5bKU8BGV2JoT1b1kJJZj14LgFF++EZ
         r+3hzyloa1BX677H1jRKtnM58fjEdU3TyMfStNrOho1TA/2zkt458xUeYtm9unJjzyWX
         Xb1tHV4yC54R1MwkG84zm2aoXfB8Y3NRqGTcc4KqLUq3ZG+aOJbqyQkfnqXK9tqsxqpc
         yBuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731434205; x=1732039005;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wpMEZ8etGpHeGwDSCw0SFADsZn6aen0TJzBYBdUeEVI=;
        b=hWMlEPvjBlHRqfuhipYoxYf3tnq7wuDUxx8AaJM2A6pJR5pNlT0W+jzrcA4uxe4Zp4
         7RVyaOwCl69OYmVklh8CUf/1gB1nD4LdpN5rmqkWC8BgqIK5eNWvl6rBeC5BgZWXJVUC
         iATiPNgkq47E8qVZYIagCZqlGPPioGPOG49PEoMwdz3Gnv/P8F08KECWrI4sI4O2vaii
         d7D0VxQMaPWpqRUV6ZrUUnd7xI9MDNrpgIKWeR9HYdwLDFJIieuVOxZhUK80zO15l+0f
         AgGn4VmOJQoeVHgplg59pS/qp3Gj1OQINuKh4sXcdzKNBSIdAxVrkmBfatlp+ZMk2gR0
         PMwA==
X-Forwarded-Encrypted: i=1; AJvYcCU3bUodJgxSqhJ9JnuJeTESDLxY+75pKwpiHv1mEqSVL2s424aZUUYSPgQHuwMf13a0hRYmc95avoQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxWJkckqdygZzWnCQaG995/r8EglJdKMOdFzIScrCxQy0Kb7EQj
	FNe13YOF547vAsWRRCc+5risezUGW1OHUxElSJUbuJJ3YnCXaclCv9mDzQb9aKA=
X-Google-Smtp-Source: AGHT+IFx6UWdvrNKDaX/OENaRjq87dwE63td/svMIV9HfNIfAMFBzFtM680J2ZNXHuwnb0+bit+2+g==
X-Received: by 2002:a25:6b06:0:b0:e29:27db:a1ac with SMTP id 3f1490d57ef6-e337e17cdb1mr14809403276.17.1731434205572;
        Tue, 12 Nov 2024 09:56:45 -0800 (PST)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e336ee15578sm2749556276.1.2024.11.12.09.56.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Nov 2024 09:56:44 -0800 (PST)
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
Subject: [PATCH v7 11/18] fanotify: allow to set errno in FAN_DENY permission response
Date: Tue, 12 Nov 2024 12:55:26 -0500
Message-ID: <6f1748cdfa0b2849361223563ac3c8ee417b230c.1731433903.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1731433903.git.josef@toxicpanda.com>
References: <cover.1731433903.git.josef@toxicpanda.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Amir Goldstein <amir73il@gmail.com>

With FAN_DENY response, user trying to perform the filesystem operation
gets an error with errno set to EPERM.

It is useful for hierarchical storage management (HSM) service to be able
to deny access for reasons more diverse than EPERM, for example EAGAIN,
if HSM could retry the operation later.

Allow fanotify groups with priority FAN_CLASSS_PRE_CONTENT to responsd
to permission events with the response value FAN_DENY_ERRNO(errno),
instead of FAN_DENY to return a custom error.

Limit custom error values to errors expected on read(2)/write(2) and
open(2) of regular files. This list could be extended in the future.
Userspace can test for legitimate values of FAN_DENY_ERRNO(errno) by
writing a response to an fanotify group fd with a value of FAN_NOFD in
the fd field of the response.

The change in fanotify_response is backward compatible, because errno is
written in the high 8 bits of the 32bit response field and old kernels
reject respose value with high bits set.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/notify/fanotify/fanotify.c      | 19 +++++++++++----
 fs/notify/fanotify/fanotify.h      |  5 ++++
 fs/notify/fanotify/fanotify_user.c | 37 ++++++++++++++++++++++++++----
 include/linux/fanotify.h           |  5 +++-
 include/uapi/linux/fanotify.h      |  7 ++++++
 5 files changed, 62 insertions(+), 11 deletions(-)

diff --git a/fs/notify/fanotify/fanotify.c b/fs/notify/fanotify/fanotify.c
index da6c3c1c7edf..e3d04d77caba 100644
--- a/fs/notify/fanotify/fanotify.c
+++ b/fs/notify/fanotify/fanotify.c
@@ -223,7 +223,8 @@ static int fanotify_get_response(struct fsnotify_group *group,
 				 struct fanotify_perm_event *event,
 				 struct fsnotify_iter_info *iter_info)
 {
-	int ret;
+	int ret, errno;
+	u32 decision;
 
 	pr_debug("%s: group=%p event=%p\n", __func__, group, event);
 
@@ -256,20 +257,28 @@ static int fanotify_get_response(struct fsnotify_group *group,
 		goto out;
 	}
 
+	decision = event->response &
+		(FANOTIFY_RESPONSE_ACCESS | FANOTIFY_RESPONSE_FLAGS);
 	/* userspace responded, convert to something usable */
-	switch (event->response & FANOTIFY_RESPONSE_ACCESS) {
+	switch (decision & FANOTIFY_RESPONSE_ACCESS) {
 	case FAN_ALLOW:
 		ret = 0;
 		break;
 	case FAN_DENY:
+		/* Check custom errno from pre-content events */
+		errno = fanotify_get_response_errno(event->response);
+		if (errno) {
+			ret = -errno;
+			break;
+		}
+		fallthrough;
 	default:
 		ret = -EPERM;
 	}
 
 	/* Check if the response should be audited */
-	if (event->response & FAN_AUDIT)
-		audit_fanotify(event->response & ~FAN_AUDIT,
-			       &event->audit_rule);
+	if (decision & FAN_AUDIT)
+		audit_fanotify(decision & ~FAN_AUDIT, &event->audit_rule);
 
 	pr_debug("%s: group=%p event=%p about to return ret=%d\n", __func__,
 		 group, event, ret);
diff --git a/fs/notify/fanotify/fanotify.h b/fs/notify/fanotify/fanotify.h
index 7f06355afa1f..9e93aba210c9 100644
--- a/fs/notify/fanotify/fanotify.h
+++ b/fs/notify/fanotify/fanotify.h
@@ -528,3 +528,8 @@ static inline unsigned int fanotify_mark_user_flags(struct fsnotify_mark *mark)
 
 	return mflags;
 }
+
+static inline u32 fanotify_get_response_errno(int res)
+{
+	return res >> FAN_ERRNO_SHIFT;
+}
diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index 5ab9ad69915a..b83fefc8aa2d 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -329,11 +329,14 @@ static int process_access_response(struct fsnotify_group *group,
 	struct fanotify_perm_event *event;
 	int fd = response_struct->fd;
 	u32 response = response_struct->response;
+	u32 decision = response &
+		(FANOTIFY_RESPONSE_ACCESS | FANOTIFY_RESPONSE_FLAGS);
+	int errno = fanotify_get_response_errno(response);
 	int ret = info_len;
 	struct fanotify_response_info_audit_rule friar;
 
-	pr_debug("%s: group=%p fd=%d response=%u buf=%p size=%zu\n", __func__,
-		 group, fd, response, info, info_len);
+	pr_debug("%s: group=%p fd=%d response=%x errno=%d buf=%p size=%zu\n",
+		 __func__, group, fd, response, errno, info, info_len);
 	/*
 	 * make sure the response is valid, if invalid we do nothing and either
 	 * userspace can send a valid response or we will clean it up after the
@@ -342,18 +345,42 @@ static int process_access_response(struct fsnotify_group *group,
 	if (response & ~FANOTIFY_RESPONSE_VALID_MASK)
 		return -EINVAL;
 
-	switch (response & FANOTIFY_RESPONSE_ACCESS) {
+	switch (decision & FANOTIFY_RESPONSE_ACCESS) {
 	case FAN_ALLOW:
+		if (errno)
+			return -EINVAL;
+		break;
 	case FAN_DENY:
+		/* Custom errno is supported only for pre-content groups */
+		if (errno && group->priority != FSNOTIFY_PRIO_PRE_CONTENT)
+			return -EINVAL;
+
+		/*
+		 * Limit errno to values expected on open(2)/read(2)/write(2)
+		 * of regular files.
+		 */
+		switch (errno) {
+		case 0:
+		case EIO:
+		case EPERM:
+		case EBUSY:
+		case ETXTBSY:
+		case EAGAIN:
+		case ENOSPC:
+		case EDQUOT:
+			break;
+		default:
+			return -EINVAL;
+		}
 		break;
 	default:
 		return -EINVAL;
 	}
 
-	if ((response & FAN_AUDIT) && !FAN_GROUP_FLAG(group, FAN_ENABLE_AUDIT))
+	if ((decision & FAN_AUDIT) && !FAN_GROUP_FLAG(group, FAN_ENABLE_AUDIT))
 		return -EINVAL;
 
-	if (response & FAN_INFO) {
+	if (decision & FAN_INFO) {
 		ret = process_access_response_info(info, info_len, &friar);
 		if (ret < 0)
 			return ret;
diff --git a/include/linux/fanotify.h b/include/linux/fanotify.h
index c747af064d2c..d9bb48976b53 100644
--- a/include/linux/fanotify.h
+++ b/include/linux/fanotify.h
@@ -132,7 +132,10 @@
 /* These masks check for invalid bits in permission responses. */
 #define FANOTIFY_RESPONSE_ACCESS (FAN_ALLOW | FAN_DENY)
 #define FANOTIFY_RESPONSE_FLAGS (FAN_AUDIT | FAN_INFO)
-#define FANOTIFY_RESPONSE_VALID_MASK (FANOTIFY_RESPONSE_ACCESS | FANOTIFY_RESPONSE_FLAGS)
+#define FANOTIFY_RESPONSE_ERRNO	(FAN_ERRNO_MASK << FAN_ERRNO_SHIFT)
+#define FANOTIFY_RESPONSE_VALID_MASK \
+	(FANOTIFY_RESPONSE_ACCESS | FANOTIFY_RESPONSE_FLAGS | \
+	 FANOTIFY_RESPONSE_ERRNO)
 
 /* Do not use these old uapi constants internally */
 #undef FAN_ALL_CLASS_BITS
diff --git a/include/uapi/linux/fanotify.h b/include/uapi/linux/fanotify.h
index 0636a9c85dd0..bd8167979707 100644
--- a/include/uapi/linux/fanotify.h
+++ b/include/uapi/linux/fanotify.h
@@ -235,6 +235,13 @@ struct fanotify_response_info_audit_rule {
 /* Legit userspace responses to a _PERM event */
 #define FAN_ALLOW	0x01
 #define FAN_DENY	0x02
+/* errno other than EPERM can specified in upper byte of deny response */
+#define FAN_ERRNO_BITS	8
+#define FAN_ERRNO_SHIFT (32 - FAN_ERRNO_BITS)
+#define FAN_ERRNO_MASK	((1 << FAN_ERRNO_BITS) - 1)
+#define FAN_DENY_ERRNO(err) \
+	(FAN_DENY | ((((__u32)(err)) & FAN_ERRNO_MASK) << FAN_ERRNO_SHIFT))
+
 #define FAN_AUDIT	0x10	/* Bitmask to create audit record for result */
 #define FAN_INFO	0x20	/* Bitmask to indicate additional information */
 
-- 
2.43.0


