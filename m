Return-Path: <linux-xfs+bounces-15315-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C4F59C5F9A
	for <lists+linux-xfs@lfdr.de>; Tue, 12 Nov 2024 18:57:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 21E49286475
	for <lists+linux-xfs@lfdr.de>; Tue, 12 Nov 2024 17:57:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F804216A1E;
	Tue, 12 Nov 2024 17:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="i7Azw3WC"
X-Original-To: linux-xfs@vger.kernel.org
Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C4AB215C42
	for <linux-xfs@vger.kernel.org>; Tue, 12 Nov 2024 17:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731434193; cv=none; b=WmFZM4Hb0XOQrtQnt0zGFR0C4Mm1AbvTShD16F3CxmrNLxaBPsucncXZZtjcCQP9LtujJPYmDSocccbZ25nxuMbD+7nnSuDLr25NwLwOYrfJ1opf/+3oVOJajMmGz2JP7n+PloRt2UyCkbxO/EBbwrQLIaK2H8yIdgtV+hfDYfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731434193; c=relaxed/simple;
	bh=+d0EqeW8oMHKy/4riewptbzn/hRXZWMS2t//Ji2Zv/g=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UhIEXykA8o0jJOq+jCHljPXBVOe0DzJ51TbQM0F5NTSmH7sa5i5I5Fc18wvAsfTw1N6ORpyCUE3SqH5MmJxSJKFpuQ60mGzBWjmwNEGalxsKKAviIm4SiP+Z2zCufa0PiDaw4JNF7NX7+1PbMmB+24MEf/XakjELxQSCD5Ez4+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=i7Azw3WC; arc=none smtp.client-ip=209.85.128.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-6e330b7752cso49001887b3.1
        for <linux-xfs@vger.kernel.org>; Tue, 12 Nov 2024 09:56:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1731434191; x=1732038991; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DjBGMOunPJ0cAEWOCfFP2w1O3j7Clx8hp97a9eP3Qf4=;
        b=i7Azw3WC+HU7A4DN01dEr5YosC/MFe8EBxtOTvC5WNPvKRubVMjs6b4rWUL9FN9XrJ
         1nSdDJAHt4ePTSrFU42AzthFlVQD+ZuswWNAshTgjZqbj75lzoAH9XsLfXtJT94w1KAr
         MdFB1xEjq+itaJzYzYzZcdsyrzIfBi4hha2fLiqidZ0XxMKOxv14nzvkSzuHLsjozPIF
         nDXaEewLTfiH02zgPCmd+sekRe2htkWJt1mBA7My4z6l3SMdcVxTN42sEF9wd7guwxF4
         x84u3QqdZ2lTg4SSgBMILBDkKP8vNpCFolZKe7MxihCWacbpaJfuFNfBl0UmcUYZTutH
         +iiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731434191; x=1732038991;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DjBGMOunPJ0cAEWOCfFP2w1O3j7Clx8hp97a9eP3Qf4=;
        b=S21dfpD1ikIgkSiDvXhGPvkDqMrhNWNEFPrv9AZpBOmynOkiEqZuJI07qwMGBhHlDw
         OMqXt7eexKJbv+SsT/BDaLhZeNu3w7EVb4c0f+YBG5REnREL9Dz8UaoJFYXhIleAq72t
         /YRiBtbRCKP6XMT1MfCR2j/s7w57X1HKuJrMu0pua2PR/4i3BVOqeAZfQwQZoCchqD4T
         0oa1cBr09rJaFJkds0U+IfnMB9qqiE4jnhsfwkWgkHYdZ4iX+58bFy0QSZtxwj/j7pWX
         MMZosghneUSDorW442dFvmdLiSRQEc7t5KhiKuTEs6bNYksffghkqtWk7J0yYJK/DahM
         5rPA==
X-Forwarded-Encrypted: i=1; AJvYcCW5nxWfZBocNsO02NAWzqNYI2pomAIbiDCjAnavNPsz80qtQMfKrWP2yDR3KQgjtpoLEbHp6xg9Gjg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxxTLDZIolaMeqTFwSMDpNw3h952aAR3V+b5sk+0PSiyJhLH9RO
	vV9KXVJQ0mJhQmDqePSnbAR6P4shdoDmdQxHd2D46xrSBE06sJvLdF4oWW5nPNo=
X-Google-Smtp-Source: AGHT+IE9ja6LbFpT71HNVj209iZC1LoqOzL3KmMfD6EjJ8DsteP+p2eBET7rNbO75x+IVtTpW9hviQ==
X-Received: by 2002:a05:690c:6902:b0:6ea:86ae:cbc with SMTP id 00721157ae682-6eade510509mr128158657b3.13.1731434190711;
        Tue, 12 Nov 2024 09:56:30 -0800 (PST)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-6eace8d520asm26537437b3.8.2024.11.12.09.56.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Nov 2024 09:56:30 -0800 (PST)
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
Subject: [PATCH v7 02/18] fanotify: don't skip extra event info if no info_mode is set
Date: Tue, 12 Nov 2024 12:55:17 -0500
Message-ID: <ce1cc82322ae850a0b5f36e72b8eb78ad9969b7c.1731433903.git.josef@toxicpanda.com>
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

Previously we would only include optional information if you requested
it via an FAN_ flag at fanotify_init time (FAN_REPORT_FID for example).
However this isn't necessary as the event length is encoded in the
metadata, and if the user doesn't want to consume the information they
don't have to.  With the PRE_ACCESS events we will always generate range
information, so drop this check in order to allow this extra
information to be exported without needing to have another flag.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/notify/fanotify/fanotify_user.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index 2d85c71717d6..8528c1bfee7d 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -159,9 +159,6 @@ static size_t fanotify_event_len(unsigned int info_mode,
 	int fh_len;
 	int dot_len = 0;
 
-	if (!info_mode)
-		return event_len;
-
 	if (fanotify_is_error_event(event->mask))
 		event_len += FANOTIFY_ERROR_INFO_LEN;
 
@@ -756,12 +753,10 @@ static ssize_t copy_event_to_user(struct fsnotify_group *group,
 	buf += FAN_EVENT_METADATA_LEN;
 	count -= FAN_EVENT_METADATA_LEN;
 
-	if (info_mode) {
-		ret = copy_info_records_to_user(event, info, info_mode, pidfd,
-						buf, count);
-		if (ret < 0)
-			goto out_close_fd;
-	}
+	ret = copy_info_records_to_user(event, info, info_mode, pidfd,
+					buf, count);
+	if (ret < 0)
+		goto out_close_fd;
 
 	if (f)
 		fd_install(fd, f);
-- 
2.43.0


