Return-Path: <linux-xfs+bounces-25692-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 458F3B598C4
	for <lists+linux-xfs@lfdr.de>; Tue, 16 Sep 2025 16:07:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E4FC43ABEF2
	for <lists+linux-xfs@lfdr.de>; Tue, 16 Sep 2025 14:05:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09DC235E4D7;
	Tue, 16 Sep 2025 14:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RtUt9nFp"
X-Original-To: linux-xfs@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6B613570D8
	for <linux-xfs@vger.kernel.org>; Tue, 16 Sep 2025 14:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758031205; cv=none; b=FeNssbH52R1pOIZ4EhvmNGUYQrm+pJsWEZI8VEI9Fg78Pyfzp0HCaIs1KLVoqNPBVTwV3wFAZmqSK5vr8dkXzDLcbAtqZFW4hpvveE4VkEwt8BBG+sVnspV3be7C8Yu3ynbgCiLDbJp5/KuTc9fPFBHGtAeH9OCvKvR+/Brz0Rc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758031205; c=relaxed/simple;
	bh=onJPCe9YqJgqvuYwKD4fnxdCGXT93MaxVU0lwENDDkI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XZXh6Nij/m8u999Oi5Qsl1bSD2g0luflaQ5rJVyP6Jbt468DLDdT/VXLc7oCVe7LhfN0OeabeoJ5UkxPA1eHwz4+ElafZfQbq1lFhb+6sPMsklFQ4+SakaxESbW98WW2KXo+ids1eebJpYzueVB9D/Mggfv99VKJAT5DTiucZBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RtUt9nFp; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-45dd5e24d16so52702325e9.3
        for <linux-xfs@vger.kernel.org>; Tue, 16 Sep 2025 07:00:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758031201; x=1758636001; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9LJ4r8TF2Lv0as7EYdqZVHam471k9lVFSDN/DCiOydU=;
        b=RtUt9nFpd50H7wmzr0gHC58QRsJODnR+/tCPl1yNDa0OdGz8TZwvuZRtbSOYz+iZW+
         DRZCQlpIZQqsRh1TqDFUvf8A899jysaa1AIkBL39A9YUUipAZgQ/yQDhj+h9Hd32NOKz
         VQkmEnQiDn4DOlZveL4LIkl7SHK/bFDiB5cySMs57DOXhJP5sT51HrhMkavke8tZjR/n
         r7GADARKaNnMQAu3ZiUCnjRubbNc3hV1pgLEosREt8hzec0AYg5f/Acjw8fivI6+3Dr+
         AEFdfCHbTnv0+NKXHtM/soOzMeeqvYtV+QAalJqAgBKLJ9DnImHL1odT6uVFWuMJ5+gS
         gfbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758031201; x=1758636001;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9LJ4r8TF2Lv0as7EYdqZVHam471k9lVFSDN/DCiOydU=;
        b=aX0lgUUKLEtpQJTlxOGCJAzspJBqFytdARXyd8mVYXcK2WovlA8+vYInsxLoJjw7Hr
         fFuZjohgGAq0dDoROvtiB6MjwYZlUR6VxH3da2xXk670QJQrjB4JjAUo7uQxs4vna69v
         DBG+G/qd9PKb/QvdVyHk8N7gdwDniZdf72/ahPpKwigqTq9ZGyjO2ub/a99+6uW1JWn5
         MdrCSPU2grvsmjlLXSdr9Y2SPiZp5VGUY3z4faKmY2khFDOrv0PF5NjoLRsT33U84ghu
         WKb++OhzpRY+ETRMPt+LAwaAJJY07uPuQpV2OPF2PM9Upjopsuplg9iTkHEoDn5jhqtP
         uTdQ==
X-Forwarded-Encrypted: i=1; AJvYcCWrqCJQbYzFAUD3KOzFFDo05M9sYZcCMuts0qxucvlfNQ3pvkRDE6AnyB0LjJSd98X8SHHWXCaNc+Y=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx6vUtjBpo0yvBJy84Gaue141bRa9m/hmzJv8JC0cGan3x5qQcn
	sX1SWuqBka6RM2jKTw34COUyVUHucFrTMeJ+HhHbNrcDIEMHCZsb1Wzg
X-Gm-Gg: ASbGncuTqYVM24N0TUHbWrOqYlyPxjtBCWHLKtdO2QSenvlh6aq0QAcAFXl+fPIv8p7
	3nKZnG0juyGcb5VczodOwagPyl5cBGJw//pdQ6gyg9nhcHtlgVT/Al02oj+gHr2wfpYNSy1XL1r
	NfLEZmE81VcONGsRH6bnAlh6cecJNcJ7TO6OpZ+2KTCvi5qg+yxSN4UCbO6CXvgnQKet9stUUy6
	YpZbw2w/ydmKSCMVEWNjxRkyIRppI2c1cnSIaiZLjfF8zYKuyrCkUPvPpFibc/G/D2iCtpvY8Bb
	x+q5jjCwJG/TqV5uSCiTvRY7z+aY6bUpR48pBboHoye2jOIsEB7hxF6wu7xHXh6dG3JUqUoxz3e
	866HCZWDSDY27AOgcSQ2Bt+SI60TOuRTa5odwNCj8CnoWFZCbB++rhQsJoj3fPnGPN0gbtFB5
X-Google-Smtp-Source: AGHT+IHYJqSjXtRyu8AlavSqqYLYRl8QcSweA/3ngpN0GUZA3qROSZnetWUBJ5Se7JCe/tV8GyTMYw==
X-Received: by 2002:a05:600c:1387:b0:45b:88d6:8ddb with SMTP id 5b1f17b1804b1-45f211fc2dbmr154100195e9.37.1758031200730;
        Tue, 16 Sep 2025 07:00:00 -0700 (PDT)
Received: from f.. (cst-prg-88-146.cust.vodafone.cz. [46.135.88.146])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e7cde81491sm16557991f8f.42.2025.09.16.06.59.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Sep 2025 07:00:00 -0700 (PDT)
From: Mateusz Guzik <mjguzik@gmail.com>
To: brauner@kernel.org
Cc: viro@zeniv.linux.org.uk,
	jack@suse.cz,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	josef@toxicpanda.com,
	kernel-team@fb.com,
	amir73il@gmail.com,
	linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	ceph-devel@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	Mateusz Guzik <mjguzik@gmail.com>
Subject: [PATCH v4 10/12] ceph: use the new ->i_state accessors
Date: Tue, 16 Sep 2025 15:58:58 +0200
Message-ID: <20250916135900.2170346-11-mjguzik@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250916135900.2170346-1-mjguzik@gmail.com>
References: <20250916135900.2170346-1-mjguzik@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Change generated with coccinelle and fixed up by hand as appropriate.

Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
---
 fs/ceph/cache.c  |  2 +-
 fs/ceph/crypto.c |  4 ++--
 fs/ceph/file.c   |  4 ++--
 fs/ceph/inode.c  | 28 ++++++++++++++--------------
 4 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/fs/ceph/cache.c b/fs/ceph/cache.c
index 930fbd54d2c8..f678bab189d8 100644
--- a/fs/ceph/cache.c
+++ b/fs/ceph/cache.c
@@ -26,7 +26,7 @@ void ceph_fscache_register_inode_cookie(struct inode *inode)
 		return;
 
 	/* Only new inodes! */
-	if (!(inode->i_state & I_NEW))
+	if (!(inode_state_read_once(inode) & I_NEW))
 		return;
 
 	WARN_ON_ONCE(ci->netfs.cache);
diff --git a/fs/ceph/crypto.c b/fs/ceph/crypto.c
index 7026e794813c..928746b92512 100644
--- a/fs/ceph/crypto.c
+++ b/fs/ceph/crypto.c
@@ -329,7 +329,7 @@ int ceph_encode_encrypted_dname(struct inode *parent, char *buf, int elen)
 out:
 	kfree(cryptbuf);
 	if (dir != parent) {
-		if ((dir->i_state & I_NEW))
+		if ((inode_state_read_once(dir) & I_NEW))
 			discard_new_inode(dir);
 		else
 			iput(dir);
@@ -438,7 +438,7 @@ int ceph_fname_to_usr(const struct ceph_fname *fname, struct fscrypt_str *tname,
 	fscrypt_fname_free_buffer(&_tname);
 out_inode:
 	if (dir != fname->dir) {
-		if ((dir->i_state & I_NEW))
+		if ((inode_state_read_once(dir) & I_NEW))
 			discard_new_inode(dir);
 		else
 			iput(dir);
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index c02f100f8552..59f2be41c9aa 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -744,7 +744,7 @@ static int ceph_finish_async_create(struct inode *dir, struct inode *inode,
 		      vino.ino, ceph_ino(dir), dentry->d_name.name);
 		ceph_dir_clear_ordered(dir);
 		ceph_init_inode_acls(inode, as_ctx);
-		if (inode->i_state & I_NEW) {
+		if (inode_state_read_once(inode) & I_NEW) {
 			/*
 			 * If it's not I_NEW, then someone created this before
 			 * we got here. Assume the server is aware of it at
@@ -907,7 +907,7 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
 				new_inode = NULL;
 				goto out_req;
 			}
-			WARN_ON_ONCE(!(new_inode->i_state & I_NEW));
+			WARN_ON_ONCE(!(inode_state_read_once(new_inode) & I_NEW));
 
 			spin_lock(&dentry->d_lock);
 			di->flags |= CEPH_DENTRY_ASYNC_CREATE;
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 480cb3a1d639..6786ec955a87 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -86,7 +86,7 @@ struct inode *ceph_new_inode(struct inode *dir, struct dentry *dentry,
 			goto out_err;
 	}
 
-	inode->i_state = 0;
+	inode_state_set_raw(inode, 0);
 	inode->i_mode = *mode;
 
 	err = ceph_security_init_secctx(dentry, *mode, as_ctx);
@@ -155,7 +155,7 @@ struct inode *ceph_get_inode(struct super_block *sb, struct ceph_vino vino,
 
 	doutc(cl, "on %llx=%llx.%llx got %p new %d\n",
 	      ceph_present_inode(inode), ceph_vinop(inode), inode,
-	      !!(inode->i_state & I_NEW));
+	      !!(inode_state_read_once(inode) & I_NEW));
 	return inode;
 }
 
@@ -182,7 +182,7 @@ struct inode *ceph_get_snapdir(struct inode *parent)
 		goto err;
 	}
 
-	if (!(inode->i_state & I_NEW) && !S_ISDIR(inode->i_mode)) {
+	if (!(inode_state_read_once(inode) & I_NEW) && !S_ISDIR(inode->i_mode)) {
 		pr_warn_once_client(cl, "bad snapdir inode type (mode=0%o)\n",
 				    inode->i_mode);
 		goto err;
@@ -215,7 +215,7 @@ struct inode *ceph_get_snapdir(struct inode *parent)
 		}
 	}
 #endif
-	if (inode->i_state & I_NEW) {
+	if (inode_state_read_once(inode) & I_NEW) {
 		inode->i_op = &ceph_snapdir_iops;
 		inode->i_fop = &ceph_snapdir_fops;
 		ci->i_snap_caps = CEPH_CAP_PIN; /* so we can open */
@@ -224,7 +224,7 @@ struct inode *ceph_get_snapdir(struct inode *parent)
 
 	return inode;
 err:
-	if ((inode->i_state & I_NEW))
+	if ((inode_state_read_once(inode) & I_NEW))
 		discard_new_inode(inode);
 	else
 		iput(inode);
@@ -698,7 +698,7 @@ void ceph_evict_inode(struct inode *inode)
 
 	netfs_wait_for_outstanding_io(inode);
 	truncate_inode_pages_final(&inode->i_data);
-	if (inode->i_state & I_PINNING_NETFS_WB)
+	if (inode_state_read_once(inode) & I_PINNING_NETFS_WB)
 		ceph_fscache_unuse_cookie(inode, true);
 	clear_inode(inode);
 
@@ -967,7 +967,7 @@ int ceph_fill_inode(struct inode *inode, struct page *locked_page,
 	      le64_to_cpu(info->version), ci->i_version);
 
 	/* Once I_NEW is cleared, we can't change type or dev numbers */
-	if (inode->i_state & I_NEW) {
+	if (inode_state_read_once(inode) & I_NEW) {
 		inode->i_mode = mode;
 	} else {
 		if (inode_wrong_type(inode, mode)) {
@@ -1044,7 +1044,7 @@ int ceph_fill_inode(struct inode *inode, struct page *locked_page,
 
 #ifdef CONFIG_FS_ENCRYPTION
 	if (iinfo->fscrypt_auth_len &&
-	    ((inode->i_state & I_NEW) || (ci->fscrypt_auth_len == 0))) {
+	    ((inode_state_read_once(inode) & I_NEW) || (ci->fscrypt_auth_len == 0))) {
 		kfree(ci->fscrypt_auth);
 		ci->fscrypt_auth_len = iinfo->fscrypt_auth_len;
 		ci->fscrypt_auth = iinfo->fscrypt_auth;
@@ -1638,13 +1638,13 @@ int ceph_fill_trace(struct super_block *sb, struct ceph_mds_request *req)
 			pr_err_client(cl, "badness %p %llx.%llx\n", in,
 				      ceph_vinop(in));
 			req->r_target_inode = NULL;
-			if (in->i_state & I_NEW)
+			if (inode_state_read_once(in) & I_NEW)
 				discard_new_inode(in);
 			else
 				iput(in);
 			goto done;
 		}
-		if (in->i_state & I_NEW)
+		if (inode_state_read_once(in) & I_NEW)
 			unlock_new_inode(in);
 	}
 
@@ -1830,11 +1830,11 @@ static int readdir_prepopulate_inodes_only(struct ceph_mds_request *req,
 			pr_err_client(cl, "inode badness on %p got %d\n", in,
 				      rc);
 			err = rc;
-			if (in->i_state & I_NEW) {
+			if (inode_state_read_once(in) & I_NEW) {
 				ihold(in);
 				discard_new_inode(in);
 			}
-		} else if (in->i_state & I_NEW) {
+		} else if (inode_state_read_once(in) & I_NEW) {
 			unlock_new_inode(in);
 		}
 
@@ -2046,7 +2046,7 @@ int ceph_readdir_prepopulate(struct ceph_mds_request *req,
 			pr_err_client(cl, "badness on %p %llx.%llx\n", in,
 				      ceph_vinop(in));
 			if (d_really_is_negative(dn)) {
-				if (in->i_state & I_NEW) {
+				if (inode_state_read_once(in) & I_NEW) {
 					ihold(in);
 					discard_new_inode(in);
 				}
@@ -2056,7 +2056,7 @@ int ceph_readdir_prepopulate(struct ceph_mds_request *req,
 			err = ret;
 			goto next_item;
 		}
-		if (in->i_state & I_NEW)
+		if (inode_state_read_once(in) & I_NEW)
 			unlock_new_inode(in);
 
 		if (d_really_is_negative(dn)) {
-- 
2.43.0


