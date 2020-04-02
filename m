Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7CE019BA47
	for <lists+linux-xfs@lfdr.de>; Thu,  2 Apr 2020 04:26:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733303AbgDBC0n (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 1 Apr 2020 22:26:43 -0400
Received: from mail-pj1-f68.google.com ([209.85.216.68]:40743 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733308AbgDBC0n (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Apr 2020 22:26:43 -0400
Received: by mail-pj1-f68.google.com with SMTP id kx8so907305pjb.5
        for <linux-xfs@vger.kernel.org>; Wed, 01 Apr 2020 19:26:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Gw1plltr70hS19r9RNTPG/3Ge4f+zU6JkZ15rByJBH8=;
        b=Mu7tj0QtQgRE4pe35r1cq7t0T8C/DpDAgsN0K1mTIkehlF+ZPn2O9xHgxAsT/RqmFS
         xQYzMLfPG0sLC2fP0jwGGLFzZFqSYTuLn9m9zdsOX3XBmVe6/NqKzEYn6ampUTfIwW+G
         KBcBWipBp2qE6p21QT43dPvYtq7kppYzHM9cM5zFtadvNXLypADCLof6CvhiEcSmziRW
         ML0UjttDgAeo+htAmwXCAvH8Cxt/IHoqG70a9a0lx1y0+JYd5bV1YRbdivDy4uQyghZy
         Y1QKKQdaF9uYXjo30/G4D3ANyMaqOmMx+nHxMshwP3yHTiCFcE40GsKk074xmlzC/uA5
         qunA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Gw1plltr70hS19r9RNTPG/3Ge4f+zU6JkZ15rByJBH8=;
        b=eFqkh4ZLg6rRceNIVQPQUURk5F5eF5uKqOYQFSFzfq/7YkC2X7t/NVXwiqJp8Apt+m
         38EFt+dTbo6YxvnLlh9kFfHQV6UmaIhsPfQYDvl8wdZiY0L9skTpDV+beegH7tu3R097
         TlbJPvzsFrR3njb6SesdmlRM/CT9Di0NDkmlxuXckvrJVfnWgFJot8XPLOOXhG58l/mm
         6LItAw6a1zx/LMz6xtJB8NCrXK3V1Dd3SxLqNqeU+TSB0ACcNiDTUZ1C0hx9Pktz7ibs
         1PKm2UOj/6v5w7AQqQMjst3ITajFn9kQ7Tv7n2RnAJvM3hw9egUxIbmN8UbvMQzaEcNz
         /LqQ==
X-Gm-Message-State: AGi0PuaeM9FWkbLcL9XdLVKEOq+tl9jAYtCAxPSXM54kP0zboVN8tSgz
        uLv2EFEf7dgWs48QD8rk/sCQNYM+ZQ==
X-Google-Smtp-Source: APiQypKwVJ1VCwfebgjhLNxOvucsSFKdzSLrDBZbuanAOAUhO0TFXK0+QYZ22PPQhP9OlTVwo8A6Gw==
X-Received: by 2002:a17:90a:d154:: with SMTP id t20mr1167389pjw.133.1585794402106;
        Wed, 01 Apr 2020 19:26:42 -0700 (PDT)
Received: from he-cluster.localdomain ([67.216.221.250])
        by smtp.gmail.com with ESMTPSA id m3sm2425532pgt.27.2020.04.01.19.26.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 01 Apr 2020 19:26:41 -0700 (PDT)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH] xfs: combine two if statements with same condition
Date:   Thu,  2 Apr 2020 10:26:34 +0800
Message-Id: <1585794394-31041-1-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

The two if statements have same condition, and the mask value
does not change in xfs_setattr_nonsize(), so combine them.

Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
---
 fs/xfs/xfs_iops.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index f7a99b3..e348145 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -738,12 +738,7 @@
 			if (error)	/* out of quota */
 				goto out_cancel;
 		}
-	}
 
-	/*
-	 * Change file ownership.  Must be the owner or privileged.
-	 */
-	if (mask & (ATTR_UID|ATTR_GID)) {
 		/*
 		 * CAP_FSETID overrides the following restrictions:
 		 *
-- 
1.8.3.1

