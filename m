Return-Path: <linux-xfs+bounces-3695-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B8B44851A8A
	for <lists+linux-xfs@lfdr.de>; Mon, 12 Feb 2024 18:02:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7441A288080
	for <lists+linux-xfs@lfdr.de>; Mon, 12 Feb 2024 17:02:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E5BD4174F;
	Mon, 12 Feb 2024 17:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Hk4cq2CS"
X-Original-To: linux-xfs@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92C6E45945
	for <linux-xfs@vger.kernel.org>; Mon, 12 Feb 2024 17:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707757230; cv=none; b=ructvGIov9TnTBIDpVtpqKuJ76/4k5i7zGLExAixjiVa4hNqxHfZiO+OttSotXttmv/yGjB5oP1OlDqr4XG8m0ve+68OiF1wXPmUU/JR5rRuKu0WngOnIL/CTq8APxjY3I8tDx84ExpSD/Yrjq9/A+e+1bFH1rCYciFYbujEVI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707757230; c=relaxed/simple;
	bh=3huMSuptuBha2CwG1y0/SfdkyV9jIivWktDsQLKbc70=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PqyHRRy99q5xmMPmP4pzFDpaqb8gpV5GX08J0Dw0BenZRlDO2/VsIawV88oI2oGBy32Jg/YV8zxeNH9dnv611PybfJv6GlPmLGaM4cQWF+3ib0gts+DFSKxxJPSZqm2VzdbRCpMbaq1a4ubwd4ZsyztCPfgek8HC5ZuW37A14bI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Hk4cq2CS; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707757227;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=O/7GvRpwmqndoF+ccNvwmWywMN3/sSl/624LXUp5jis=;
	b=Hk4cq2CSlOy6a2/vfb3Av9fU+RSWtD8IGDCXD3O8UKG6N7GzFexOXv43IHIWLSaXQV5AeD
	Q2TCUyl4cqDtcipDJ8rNJZVci9Ng0aEwmYNVwSDHwVQRs6ZymZzaDsCEey+xOjv/RjSMmv
	C96pq+F9sXTeglX09n1hX7/HV0HTDTA=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-36-66rEke76PoqvAHPqIoOtXw-1; Mon, 12 Feb 2024 12:00:25 -0500
X-MC-Unique: 66rEke76PoqvAHPqIoOtXw-1
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-55fc415b15aso3642192a12.0
        for <linux-xfs@vger.kernel.org>; Mon, 12 Feb 2024 09:00:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707757224; x=1708362024;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=O/7GvRpwmqndoF+ccNvwmWywMN3/sSl/624LXUp5jis=;
        b=DtPxthUvaH29X6BWSdJDqqMLAGSJSqTxvPP+imBSat8dHUUrF7iqe9KA+JZZngokSw
         /AsY6qgjbmPfwC242jAA5Bu/uevkg9qeUYvQrozO+13G+7rh/2aDRPXbt02DU04KxEaw
         kn1uzLWGfAA3SRR2ZAkFXeDrF0cOKseHkk1odAbcu/CM3DDzr5Sra+LOiaD3iTSVlExU
         Cnk0IwjO5MC3pJkOuCVS+1SLXuEzXr4YqgWPJ3pvkKPZOfqCPiR98UwBKjtagKy0w/Yc
         MNCMk/5Kd/3tYShDuEggwmA2jUI017/k1OtQstiZYodsoYGI7rCVQ0/TZBLSS8bIKXku
         2gug==
X-Forwarded-Encrypted: i=1; AJvYcCVHlgf+I8hFzPXkzqd0kis/tnU6yZ3SBuX+Dd1+7Adt8CgYxH3D/sIjvfsiae09XTMxp7nHAeuV5ety8nEc8py03iIwjySBtVaO
X-Gm-Message-State: AOJu0Yy8TEhd6721RAZLrJ8rG7lN7egzpZ1q7Ft3LjetMfmgFgZqCYBx
	26av6iYNyi+uzqTMGeubHplpYwBjZXI6hdfqjIFZqFbiBNZWSaSi2BITwQLN6P1S+NuRr1N+GEq
	yNzpu6iRAHnpVgvZCdjMwFFlXJM3SAv3dxYIUQAvE5NaMl9Kj4QpNRVGd
X-Received: by 2002:a05:6402:2405:b0:55f:cc6d:29b5 with SMTP id t5-20020a056402240500b0055fcc6d29b5mr52470eda.21.1707757224284;
        Mon, 12 Feb 2024 09:00:24 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH42HIFL/dxKgR7EyOrBhc7xXCpi26qG+Fua//JDh3CFnZGhulP1ThwFDEDHGR3MncapDV1sg==
X-Received: by 2002:a05:6402:2405:b0:55f:cc6d:29b5 with SMTP id t5-20020a056402240500b0055fcc6d29b5mr52460eda.21.1707757224085;
        Mon, 12 Feb 2024 09:00:24 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUY6g9lFbfToZ6KmsvUog3OF70TqTeRgGoC22qmpr2jCPKLvbuFVjIq05EHMUe49MvRMFzVuy29Mh6GJIT6KrIM8cjQ7qF2q5tZa1yNTy1oj9j/AInK7bE+csVY6aVl+btLiGQ+1+sPxkGqT/bsGmYuD94elGcJQZvp0Mbu/COh91A4Guz98UtLS/1F6UUbm+YLFurg6FjBkxzzLYFk5j8Y18gMWHLOeKMK
Received: from thinky.redhat.com ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id 14-20020a0564021f4e00b0056176e95a88sm2620261edz.32.2024.02.12.09.00.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Feb 2024 09:00:23 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
To: fsverity@lists.linux.dev,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	chandan.babu@oracle.com,
	djwong@kernel.org,
	ebiggers@kernel.org
Cc: Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH v4 24/25] xfs: add fs-verity ioctls
Date: Mon, 12 Feb 2024 17:58:21 +0100
Message-Id: <20240212165821.1901300-25-aalbersh@redhat.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20240212165821.1901300-1-aalbersh@redhat.com>
References: <20240212165821.1901300-1-aalbersh@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add fs-verity ioctls to enable, dump metadata (descriptor and Merkle
tree pages) and obtain file's digest.

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
---
 fs/xfs/xfs_ioctl.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 048d83acda0a..5d64e11bf056 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -43,6 +43,7 @@
 #include <linux/mount.h>
 #include <linux/namei.h>
 #include <linux/fileattr.h>
+#include <linux/fsverity.h>
 
 /*
  * xfs_find_handle maps from userspace xfs_fsop_handlereq structure to
@@ -2174,6 +2175,22 @@ xfs_file_ioctl(
 		return error;
 	}
 
+	case FS_IOC_ENABLE_VERITY:
+		if (!xfs_has_verity(mp))
+			return -EOPNOTSUPP;
+		return fsverity_ioctl_enable(filp, (const void __user *)arg);
+
+	case FS_IOC_MEASURE_VERITY:
+		if (!xfs_has_verity(mp))
+			return -EOPNOTSUPP;
+		return fsverity_ioctl_measure(filp, (void __user *)arg);
+
+	case FS_IOC_READ_VERITY_METADATA:
+		if (!xfs_has_verity(mp))
+			return -EOPNOTSUPP;
+		return fsverity_ioctl_read_metadata(filp,
+						    (const void __user *)arg);
+
 	default:
 		return -ENOTTY;
 	}
-- 
2.42.0


