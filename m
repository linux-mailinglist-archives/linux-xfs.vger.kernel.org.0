Return-Path: <linux-xfs+bounces-6284-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A7E5289A520
	for <lists+linux-xfs@lfdr.de>; Fri,  5 Apr 2024 21:45:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A42C91C212A7
	for <lists+linux-xfs@lfdr.de>; Fri,  5 Apr 2024 19:45:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57FC0173349;
	Fri,  5 Apr 2024 19:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4Pmp957s"
X-Original-To: linux-xfs@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C7DA173336
	for <linux-xfs@vger.kernel.org>; Fri,  5 Apr 2024 19:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712346311; cv=none; b=sS/RU/ebroqUBSXRb6BMqg+ej/9bgR6iEAAvCr1KFlFT67nYhUgh/nOjWAlMmtfOb+rTVU4yaW1tk7gNgYKgN7rKAuxSzHGjSEYaYr/vWjLFb5eRKOLlgU6gMkFmXiooIdHEcdR5eHFdfVi2ZKOA3S4Mj0gGrpM5dtty3gpB18U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712346311; c=relaxed/simple;
	bh=T3ejxbb56c+nrn15llqrQ7RzaittgP9efQjwG4WBQuo=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=Mf0Xpitr+MR2QroBuNRSzkoVtx6HsHnMo/V7Zt7ZI9eI4KHbNnBszmP1uIkCthHcU7OrhS7IfIhjD4LE9HWdPuQH5SapopeiqTlMIMqMK/JBnOcDjVqrF9An0UCNnX0rh9ID/iVxjTTtMPRc8do1SNTaVoJ8gIjSU+SOgMNLxLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--justinstitt.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4Pmp957s; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--justinstitt.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dc647f65573so4491690276.2
        for <linux-xfs@vger.kernel.org>; Fri, 05 Apr 2024 12:45:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712346308; x=1712951108; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=2vtixN1wtkWuNV0Qa4mXNUhaVbrMuwdt0CR0qhCTFhg=;
        b=4Pmp957sWq/92GZ0Wc/xV8rICwS0Nq62eLltef3DLe1QSq61I/W+yCR7PyyG+LSZ0p
         68WXe2aczCWywL8r5EH4EORFAldWfoTizAyc4vGQVjX7fPmXFHZYpE634xw0UVmcr28e
         RrChrp6TiatQgaKYwoUw05BGCfSqIsSH120KbgvAVZOOROjKobAS/n4KVTA85wcmyHm1
         GEMLhg20PRXl+ZZOs+vRb4XIsFs54a3HTkz5XrGs/0jSVPEuP2Q/T1P29n07Ofaw15kg
         84bEEbqSaJ8TJq/MJ5hM/ahj2lTpcfGYXY+wyBMR3okvki2I9diPt9gIAVzsaINdYjiS
         51vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712346308; x=1712951108;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2vtixN1wtkWuNV0Qa4mXNUhaVbrMuwdt0CR0qhCTFhg=;
        b=WsOs+RxItduey9ZZeTNEx+fMclmtsjzDJhu1x+27TpsZXepPEAe4rbfUZbzYEJB8zf
         FI/J3lEXTFlK2m2ARllqa4Ux0LAtM9ol1uIHboetPR8zCopJ1wVMf9OAar1iirTXbaji
         wil57IMUWnpx2a4GSqeUyO5QTDy+y3hT7jUiSGiK2Lsda3RgaUgqEulG7N6Hw0gWlGBZ
         P6hCBC8voJ40pLN45HlIa93P7RGAzQsUZPYOnfY0cD6jHyYigdryfFunLJRSTJ5ySMXT
         Z6hMICeLDB2wFgBhVC3+SH79NaAaKzMaGOkg2JJxiDZMddpwUFWnbAePqkscReKodPK2
         urbg==
X-Gm-Message-State: AOJu0YzWG2JR3ykTjt/Ryf9EQqOEHGqISx9tAf0xpZIPPhRxkdC799xl
	JOgM3SIPe0s7qPSq5Habskwl30u/6lgG5U3EA33zuDq1pe/1+jbGEwGqa2hJBMcueLUsw8cDwup
	0nXlhEnn4atU0O3LqxtAbqQ==
X-Google-Smtp-Source: AGHT+IGQaWsEMLLYQanS2Lwqb6aaiWTFAVRKofb23kbm/JtMo/+pr+L8fTYQOVjDpYmss57BpRnWpLm22Llm8Gso7A==
X-Received: from jstitt-linux1.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:23b5])
 (user=justinstitt job=sendgmr) by 2002:a25:8411:0:b0:dcd:5e5d:458b with SMTP
 id u17-20020a258411000000b00dcd5e5d458bmr602236ybk.3.1712346308719; Fri, 05
 Apr 2024 12:45:08 -0700 (PDT)
Date: Fri, 05 Apr 2024 19:45:08 +0000
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIAMNUEGYC/x3MwQqDMAyA4VeRnBeIVXfYqwwPoaYaGF1JylDEd
 1/x+B3+/wQXU3F4dSeY/NT1mxv6Rwdx47wK6tIMgcJII03o1XIsB+5cq6GXj9aAxAOnRPHJgaC lxSTpfm/f83X9AQuPS9JmAAAA
X-Developer-Key: i=justinstitt@google.com; a=ed25519; pk=tC3hNkJQTpNX/gLKxTNQKDmiQl6QjBNCGKJINqAdJsE=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1712346307; l=2126;
 i=justinstitt@google.com; s=20230717; h=from:subject:message-id;
 bh=T3ejxbb56c+nrn15llqrQ7RzaittgP9efQjwG4WBQuo=; b=vM4znULoH125X+4VZ0HIeV+udu59Elb7Dpzi4RgxOBcA1cIaWxOo2FSqK8bf9iocWinmC32eH
 FxLPTDU2wM/BbG0Jq6CPnD7D5QkYleqzvrhLT8U2VTYV8JrH2frfGaa
X-Mailer: b4 0.12.3
Message-ID: <20240405-strncpy-xattr-split2-v1-1-90ab18232407@google.com>
Subject: [PATCH] xfs: xattr: replace strncpy and check for truncation
From: Justin Stitt <justinstitt@google.com>
To: Chandan Babu R <chandan.babu@oracle.com>, "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-hardening@vger.kernel.org, Justin Stitt <justinstitt@google.com>
Content-Type: text/plain; charset="utf-8"

strncpy is deprecated and as such we should prefer less ambiguous and
more robust string interfaces [1].

There's a lot of manual memory management to get a prefix and name into
a string. Let's use an easier to understand and more robust interface in
scnprintf() to accomplish the same task while enabling us to check for
possible truncation, resulting in a soft warning.

Link: https://www.kernel.org/doc/html/latest/process/deprecated.html#strncpy-on-nul-terminated-strings [1]
Link: https://manpages.debian.org/testing/linux-manual-4.8/strscpy.9.en.html [2]
Link: https://github.com/KSPP/linux/issues/90
Cc: linux-hardening@vger.kernel.org
Signed-off-by: Justin Stitt <justinstitt@google.com>
---
Split from https://lore.kernel.org/all/20240401-strncpy-fs-xfs-xfs_ioctl-c-v1-1-02b9feb1989b@google.com/
with feedback from Christoph H.
---
 fs/xfs/xfs_xattr.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index 364104e1b38a..bc7246eaebdd 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -206,6 +206,7 @@ __xfs_xattr_put_listent(
 {
 	char *offset;
 	int arraytop;
+	size_t combined_len, actual_len;
 
 	if (context->count < 0 || context->seen_enough)
 		return;
@@ -220,11 +221,16 @@ __xfs_xattr_put_listent(
 		return;
 	}
 	offset = context->buffer + context->count;
-	memcpy(offset, prefix, prefix_len);
-	offset += prefix_len;
-	strncpy(offset, (char *)name, namelen);			/* real name */
-	offset += namelen;
-	*offset = '\0';
+
+	combined_len = prefix_len + namelen;
+
+	/* plus one byte for \0 */
+	actual_len = scnprintf(offset, combined_len + 1, "%s%s", prefix, name);
+
+	if (actual_len < combined_len)
+		xfs_warn(context->dp->i_mount,
+	"cannot completely copy %s%s to context buffer resulting in truncation",
+			prefix, name);
 
 compute_size:
 	context->count += prefix_len + namelen + 1;

---
base-commit: c85af715cac0a951eea97393378e84bb49384734
change-id: 20240405-strncpy-xattr-split2-0a3aff0c6a20

Best regards,
--
Justin Stitt <justinstitt@google.com>


