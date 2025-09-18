Return-Path: <linux-xfs+bounces-25474-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E349B55362
	for <lists+linux-xfs@lfdr.de>; Fri, 12 Sep 2025 17:27:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0C0D91D67C87
	for <lists+linux-xfs@lfdr.de>; Fri, 12 Sep 2025 15:28:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D8D6301011;
	Fri, 12 Sep 2025 15:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="loh649Mj"
X-Original-To: linux-xfs@vger.kernel.org
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D54B222597
	for <linux-xfs@vger.kernel.org>; Fri, 12 Sep 2025 15:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757690857; cv=none; b=GRXIavp39P6tODjHnlx9WNoBta4kicm/0TMuwl0XTVaV6sqpdp7sKMIOjTKGCrF4xf3Z+eHgq4cc9K4swA1V1OXgOhnziqaDJOhI731M1YQvq81dpCuwJ58GS/Nyg5OR/sC3w0EOKZY+IsuhMTnF1ZlGkyhoVmkQqIpffFjDceE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757690857; c=relaxed/simple;
	bh=IDX79HDL4EGNYPA7gq8OYoVmXTMrr1SHy58I3vqzc5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rQaKt0ifUMYdsp3nUzr3zh/T0mEdxW1sq07A87IinfsqLfU6+KjKJr8O+HLodLGSU+n3dxUvCWFK+60NUkhCYv+tCn2eV/n1XGbx5cyOiocfPtrwNKPzQLPRy5TYSHp8QvcDWUHjsTb+iHlxxz8J7eqi5opJ/LFOa5bu9QUHnvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=loh649Mj; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-7761578340dso986615b3a.3
        for <linux-xfs@vger.kernel.org>; Fri, 12 Sep 2025 08:27:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757690855; x=1758295655; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R6iI6c97nNvMnmhDAC2q15k1wXIF9MfYotWBXA6wQ3Q=;
        b=loh649MjWy3NcR+i9x+jdNVAA/eDItl0Hvkrzvd3eSJVyXhwHPKCdmhFGr7gmxZvwD
         hosEG9HmQd7iz/voMxuuYgr067FI1nIg7jfAjtU+7pn9j272V24fsJkU8Ic+LPGEV9YM
         ksW1ZG9PZFSw9aGBZ8/jNkEPYxsqrQxog9i502spFbac1DuCJP4YIucSPVGBo2lZqArm
         4A3gYLe8SuFDg4Sr1pxXp9bymOClxTY0p/5Nxa25ghhwOJwFD2jwzwh4pdgDFkQ8ZJfE
         JR+Gzbga84BAGcySgO36p0b3eopzfseQgoBG6b+f5s2Q5+ur9WI3XWTvfWqrqFOy5IHy
         bIKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757690855; x=1758295655;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=R6iI6c97nNvMnmhDAC2q15k1wXIF9MfYotWBXA6wQ3Q=;
        b=DtWB2GfpZVBiM2nFiaTxbF0tfSNZvQ0qQUnTdi9zlA7tRs6kQCEqATKGq+3/efFoVz
         rdi3U6oXRpMqZSI2a5j+IWZPa1/pH/beqgdXCR/uuClQdYm7/ycW+UWMlvl4uATEji7G
         BoWVLeH0hXqGyU/XrZHBwd9DKSADqLLCGpHycqJkVBfWZZofCAcoSwmFMaJ8/kC1HZAi
         n36yDfPCzCDo9CIbUbciqCaM1gBvBHQDBVDSvlWcjmpoqSrB1TITh/TdZfH98upaUfrV
         +rR0F2KmGHkXvbGOta6fW/PW35Wm8ZhIdZmT6IcbWP8QbqdgmwTF2CRL8RKjesQqCFUf
         fapQ==
X-Forwarded-Encrypted: i=1; AJvYcCVXj+2A2FqNWGa8S4lcxjf69aXk9zyRKTHh3lL9Bv8a8YVB+1gOn/e7BiNe1BPiJOnNLnwxheXjSqA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyVhVsf7W1rAu+5STCWwnpDMRvGV6Wr8mCcAghPVT8zM8YXB64/
	pbZXklVQO/wdOInUm2oOFmyE8GTsVkUO8PF3b5s56/5pWMVy/u7dqMti
X-Gm-Gg: ASbGncv9Beg73ab0RvLS7DR08cdjMvkwYXXmeCkA2FWnQwkeQP6Kp41NXeJfw/DZwAB
	LREtqyXfiH68NUBiGrVSeCbbjvS2EWuHkCQ2RkbtIe/M42Y/+E1ZaH6yJpEcIjXcx3G3hLnAdm3
	sXIKApm/3XGjLxOmYsMZHefffkHaAeoGAFDbi1LSCjXn3lTDTWPJHgf596XRxcxS/2OuQrEFG+V
	0mgWbqO82lh9UN9hiCKibABsM1zCO7/c7uzWMvOknuAj9JPUQ+4Kc3RQTRTd7hl6qYcPKqPGtY0
	KzlAevs4zNlgNN7m3NQzI5581PEa9LmlTAzmhFAY6kzdWYpeqrLgj81xowzMwmLreFguyN/dGnV
	6OQY53LVU1cj72WbygRxMDvXtr0rMX0XA3PVI
X-Google-Smtp-Source: AGHT+IGPSgPoH9ZurstrFWAHFz86xMcMkRukFkaqYmLdzKBpPjC+ANyiwLlIoflWM+XwEc5MT8/WXA==
X-Received: by 2002:a05:6a00:13a8:b0:772:8694:1d5d with SMTP id d2e1a72fcca58-776121a7cf8mr3981797b3a.29.1757690854453;
        Fri, 12 Sep 2025 08:27:34 -0700 (PDT)
Received: from jicarita ([65.144.169.45])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7760944a9a9sm5436846b3a.78.2025.09.12.08.27.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Sep 2025 08:27:33 -0700 (PDT)
From: Thomas Bertschinger <tahbertschinger@gmail.com>
To: io-uring@vger.kernel.org,
	axboe@kernel.dk,
	linux-fsdevel@vger.kernel.org,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	linux-nfs@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	cem@kernel.org,
	chuck.lever@oracle.com,
	jlayton@kernel.org,
	amir73il@gmail.com
Cc: Thomas Bertschinger <tahbertschinger@gmail.com>
Subject: [PATCH v3 03/10] fhandle: helper for allocating, reading struct file_handle
Date: Fri, 12 Sep 2025 09:28:48 -0600
Message-ID: <20250912152855.689917-4-tahbertschinger@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250912152855.689917-1-tahbertschinger@gmail.com>
References: <20250912152855.689917-1-tahbertschinger@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Pull the code for allocating and copying a struct file_handle from
userspace into a helper function get_user_handle() just for this.

do_handle_open() is updated to call get_user_handle() prior to calling
handle_to_path(), and the latter now takes a kernel pointer as a
parameter instead of a __user pointer.

This new helper, as well as handle_to_path(), are also exposed in
fs/internal.h. In a subsequent commit, io_uring will use these helpers
to support open_by_handle_at(2) in io_uring.

Signed-off-by: Thomas Bertschinger <tahbertschinger@gmail.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/fhandle.c  | 63 +++++++++++++++++++++++++++++----------------------
 fs/internal.h |  3 +++
 2 files changed, 39 insertions(+), 27 deletions(-)

diff --git a/fs/fhandle.c b/fs/fhandle.c
index 605ad8e7d93d..4ba23229758c 100644
--- a/fs/fhandle.c
+++ b/fs/fhandle.c
@@ -330,25 +330,44 @@ static inline int may_decode_fh(struct handle_to_path_ctx *ctx,
 	return 0;
 }
 
-static int handle_to_path(int mountdirfd, struct file_handle __user *ufh,
-		   struct path *path, unsigned int o_flags)
+struct file_handle *get_user_handle(struct file_handle __user *ufh)
 {
-	int retval = 0;
 	struct file_handle f_handle;
-	struct file_handle *handle __free(kfree) = NULL;
-	struct handle_to_path_ctx ctx = {};
-	const struct export_operations *eops;
+	struct file_handle *handle;
 
 	if (copy_from_user(&f_handle, ufh, sizeof(struct file_handle)))
-		return -EFAULT;
+		return ERR_PTR(-EFAULT);
 
 	if ((f_handle.handle_bytes > MAX_HANDLE_SZ) ||
 	    (f_handle.handle_bytes == 0))
-		return -EINVAL;
+		return ERR_PTR(-EINVAL);
 
 	if (f_handle.handle_type < 0 ||
 	    FILEID_USER_FLAGS(f_handle.handle_type) & ~FILEID_VALID_USER_FLAGS)
-		return -EINVAL;
+		return ERR_PTR(-EINVAL);
+
+	handle = kmalloc(struct_size(handle, f_handle, f_handle.handle_bytes),
+			 GFP_KERNEL);
+	if (!handle)
+		return ERR_PTR(-ENOMEM);
+
+	/* copy the full handle */
+	*handle = f_handle;
+	if (copy_from_user(&handle->f_handle,
+			   &ufh->f_handle,
+			   f_handle.handle_bytes)) {
+		return ERR_PTR(-EFAULT);
+	}
+
+	return handle;
+}
+
+int handle_to_path(int mountdirfd, struct file_handle *handle,
+		   struct path *path, unsigned int o_flags)
+{
+	int retval = 0;
+	struct handle_to_path_ctx ctx = {};
+	const struct export_operations *eops;
 
 	retval = get_path_anchor(mountdirfd, &ctx.root);
 	if (retval)
@@ -362,31 +381,16 @@ static int handle_to_path(int mountdirfd, struct file_handle __user *ufh,
 	if (retval)
 		goto out_path;
 
-	handle = kmalloc(struct_size(handle, f_handle, f_handle.handle_bytes),
-			 GFP_KERNEL);
-	if (!handle) {
-		retval = -ENOMEM;
-		goto out_path;
-	}
-	/* copy the full handle */
-	*handle = f_handle;
-	if (copy_from_user(&handle->f_handle,
-			   &ufh->f_handle,
-			   f_handle.handle_bytes)) {
-		retval = -EFAULT;
-		goto out_path;
-	}
-
 	/*
 	 * If handle was encoded with AT_HANDLE_CONNECTABLE, verify that we
 	 * are decoding an fd with connected path, which is accessible from
 	 * the mount fd path.
 	 */
-	if (f_handle.handle_type & FILEID_IS_CONNECTABLE) {
+	if (handle->handle_type & FILEID_IS_CONNECTABLE) {
 		ctx.fh_flags |= EXPORT_FH_CONNECTABLE;
 		ctx.flags |= HANDLE_CHECK_SUBTREE;
 	}
-	if (f_handle.handle_type & FILEID_IS_DIR)
+	if (handle->handle_type & FILEID_IS_DIR)
 		ctx.fh_flags |= EXPORT_FH_DIR_ONLY;
 	/* Filesystem code should not be exposed to user flags */
 	handle->handle_type &= ~FILEID_USER_FLAGS_MASK;
@@ -400,12 +404,17 @@ static int handle_to_path(int mountdirfd, struct file_handle __user *ufh,
 static long do_handle_open(int mountdirfd, struct file_handle __user *ufh,
 			   int open_flag)
 {
+	struct file_handle *handle __free(kfree) = NULL;
 	long retval = 0;
 	struct path path __free(path_put) = {};
 	struct file *file;
 	const struct export_operations *eops;
 
-	retval = handle_to_path(mountdirfd, ufh, &path, open_flag);
+	handle = get_user_handle(ufh);
+	if (IS_ERR(handle))
+		return PTR_ERR(handle);
+
+	retval = handle_to_path(mountdirfd, handle, &path, open_flag);
 	if (retval)
 		return retval;
 
diff --git a/fs/internal.h b/fs/internal.h
index c972f8ade52d..ab80f83ded47 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -363,4 +363,7 @@ void pidfs_get_root(struct path *path);
 long do_sys_name_to_handle_at(int dfd, const char __user *name,
 			      struct file_handle __user *handle,
 			      void __user *mnt_id, int flag, int lookup_flags);
+struct file_handle *get_user_handle(struct file_handle __user *ufh);
+int handle_to_path(int mountdirfd, struct file_handle *handle,
+		   struct path *path, unsigned int o_flags);
 #endif /* CONFIG_FHANDLE */
-- 
2.51.0


