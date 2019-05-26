Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 371552A8D8
	for <lists+linux-xfs@lfdr.de>; Sun, 26 May 2019 08:28:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726348AbfEZG2e (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 26 May 2019 02:28:34 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:34933 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725999AbfEZG2d (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 26 May 2019 02:28:33 -0400
Received: by mail-wr1-f66.google.com with SMTP id m3so13683393wrv.2;
        Sat, 25 May 2019 23:28:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=HltrZ9Y26+BomrIjk30FDuP0Xf8LQvqT34H9pYFxMRk=;
        b=h1ckKVQUHjz/Df74Vr9OKBTatdWQ7E0CajrhEKtG8Ql5KA+PHajLZDm85+PJ34i1Ko
         tUiDC8U80YOZOlWSwPXEfBP9mhyx7LTJcacMmkxXuyC0cclwyqyoUtbVnuc8qEhvn1FI
         RbFYMQerVPepQ1p1sBdhs18UL02ROG3iVgnXrlZPjrSIdeQy2jeAh0Y8zi6zIc+k28Ku
         50TFwSlPGKLnh0jMKOFKY4eWFfFZpFKZcIz4DFnF9lJX8oYmYjDVxX3I6AZ2wO9MBCM4
         qBobFCjftFcM7hfZnlkqpMWe7FL86G5uJuzj0R3fvY1jbB0enUQBxSxlFCEEj3fJcmU2
         1H3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=HltrZ9Y26+BomrIjk30FDuP0Xf8LQvqT34H9pYFxMRk=;
        b=crdwyTQ+FGm1BcAITIbsm0oUi0kwsegGHUJM2Fy3rdH0/duC+nPFGXzvR+JBqm37F5
         E1R/CU4GmYUgZOISRke9rz6DVQ5VemBxmwI1xCnprZr9rXU04mMUx6qXlA6aECSt/vOK
         PujU9K0oMICHxDuYV3iSjWGfaymyniL6pwPAHpnqY1tp5Z3zxx70EZFBRhyqjd5K7loh
         OIyfFe/fD+agy6PqJ/7k1FOXvjMBWXXK7uzNkgbxdpT22FtrgKP+NiYWYo14bal10n75
         VaRWVCI++xgg4T9shA2kD4zxsMZPgI22Kxq/ui/Z/JQRXi1XwdKJOWvvX6c7Umqpg9Z8
         RlgA==
X-Gm-Message-State: APjAAAXIF5vlx1eiFMPb5ZwTT5Ld52MqIljHvik6X9kNRFlSKtYiGeGe
        a5xj5pZS0CggLzov99hH6MzTwPRH
X-Google-Smtp-Source: APXvYqyRvQivV3LZg4B7USgOcrR/yB3T9O6qhYQ+SBAMVN8Moc2D+8rnIfuv+B9gCa3xR2od4ZnprQ==
X-Received: by 2002:adf:dccf:: with SMTP id x15mr23430712wrm.139.1558852111989;
        Sat, 25 May 2019 23:28:31 -0700 (PDT)
Received: from localhost.localdomain ([5.102.238.208])
        by smtp.gmail.com with ESMTPSA id y10sm16111325wmg.8.2019.05.25.23.28.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 25 May 2019 23:28:31 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Dave Chinner <david@fromorbit.com>, linux-unionfs@vger.kernel.org,
        linux-xfs@vger.kernel.org
Subject: [PATCH] ovl: support the FS_IOC_FS[SG]ETXATTR ioctls
Date:   Sun, 26 May 2019 09:28:25 +0300
Message-Id: <20190526062825.23059-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

They are the extended version of FS_IOC_FS[SG]ETFLAGS ioctls.
xfs_io -c "chattr <flags>" uses the new ioctls for setting flags.

This used to work in kernel pre v4.19, before stacked file ops
introduced the ovl_ioctl whitelist.

Reported-by: Dave Chinner <david@fromorbit.com>
Fixes: d1d04ef8572b ("ovl: stack file ops")
Cc: <stable@vger.kernel.org> # v4.19
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/file.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 540a8b845145..340a6ad45914 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -426,7 +426,8 @@ static unsigned int ovl_get_inode_flags(struct inode *inode)
 	return ovl_iflags;
 }
 
-static long ovl_ioctl_set_flags(struct file *file, unsigned long arg)
+static long ovl_ioctl_set_flags(struct file *file, unsigned int cmd,
+				unsigned long arg)
 {
 	long ret;
 	struct inode *inode = file_inode(file);
@@ -456,7 +457,7 @@ static long ovl_ioctl_set_flags(struct file *file, unsigned long arg)
 	if (ret)
 		goto unlock;
 
-	ret = ovl_real_ioctl(file, FS_IOC_SETFLAGS, arg);
+	ret = ovl_real_ioctl(file, cmd, arg);
 
 	ovl_copyflags(ovl_inode_real(inode), inode);
 unlock:
@@ -474,11 +475,13 @@ static long ovl_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 
 	switch (cmd) {
 	case FS_IOC_GETFLAGS:
+	case FS_IOC_FSGETXATTR:
 		ret = ovl_real_ioctl(file, cmd, arg);
 		break;
 
 	case FS_IOC_SETFLAGS:
-		ret = ovl_ioctl_set_flags(file, arg);
+	case FS_IOC_FSSETXATTR:
+		ret = ovl_ioctl_set_flags(file, cmd, arg);
 		break;
 
 	default:
-- 
2.17.1

