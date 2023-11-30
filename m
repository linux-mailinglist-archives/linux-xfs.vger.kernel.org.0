Return-Path: <linux-xfs+bounces-270-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 040F77FE819
	for <lists+linux-xfs@lfdr.de>; Thu, 30 Nov 2023 05:05:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A8E5C2821DB
	for <lists+linux-xfs@lfdr.de>; Thu, 30 Nov 2023 04:05:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF6A9156DB;
	Thu, 30 Nov 2023 04:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="ei0btfjs"
X-Original-To: linux-xfs@vger.kernel.org
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38E44D5C
	for <linux-xfs@vger.kernel.org>; Wed, 29 Nov 2023 20:05:29 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id d9443c01a7336-1cfd04a6e49so5109295ad.0
        for <linux-xfs@vger.kernel.org>; Wed, 29 Nov 2023 20:05:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1701317129; x=1701921929; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=W+yjpAu/Jsru6QG03RfnszV7SN1caXKKF6cUUXYNdao=;
        b=ei0btfjs2A6YP0G5kO7A8C1/BKadMV3FHYjLiSzAshm60pfGk1n/PIQcQ6h+giScHW
         ZrsqlmWTb25Xd+p1qwu3sGm/WxBg/LgJ3DC0DUZl2oKJPaeT2WXbKjGRxBUb756cP6Ry
         QkIanKM6B8a9uyPIiypA1dswN/SP+DteGuKFyD7rjYJbe6GRdjGw/ZLXkqzhszleIWAl
         ktvN0Fi0p9CSYvwJf/geL4xR+42EE+sugDv4ufqMR1rhq5qGBb6Tp7oqWYlWXNYBtoBN
         qqDq1KvWpJsGbXyFf4DTClrN3DdhQjgW5HAxp8AoroPSe/Xp8/2+wpEROAwyMIv4xpri
         JITA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701317129; x=1701921929;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=W+yjpAu/Jsru6QG03RfnszV7SN1caXKKF6cUUXYNdao=;
        b=L+WlBiwETsIQS5J+6Ae9UCiK5WxJW30n33tFHnWykbE1DNWX2ZMm2uMDoHuwuyF6pC
         VlbBakGW8KdMd9RWWcXK6bRnwG3K+1zRbxlR7Qa8ueGi6/36szZoUrtqlGTAtV3V9eJ5
         TGMgPgvwIl2IHHljSdpDXcf1HRoXkGtMB4b5Dq150+zhjPNDh0Zj/AHnXzM9lGKaB63J
         vpbOTmyMqi5tEWCEx3XJXZszxEbFnjws0qlmmJ3JU+apgH/MinUXUrOouaK8U2D4F9Ja
         WOEnJ5y/plX4eQlAhI9pNkmHcbU/KncArwil2ToZ6RG5xdHGmh8di3sXrInIhFcpzojX
         9PjA==
X-Gm-Message-State: AOJu0YyvgT4oi2oxGUZGCmQXrnR/Ti4eY9XsE/JRzg95H/OivaphWwqS
	5ENFK0tk9CrbqzdF5DzjrOvoNg==
X-Google-Smtp-Source: AGHT+IF2TPny1kU3pUpbWpuyFpMHloE4EU/UOBulaT2ThGwlIOchgef/BblJ7yPK0aci9EcXP1Nrvg==
X-Received: by 2002:a17:903:249:b0:1cf:b4bb:9bdc with SMTP id j9-20020a170903024900b001cfb4bb9bdcmr23350613plh.9.1701317128695;
        Wed, 29 Nov 2023 20:05:28 -0800 (PST)
Received: from localhost.localdomain ([61.213.176.7])
        by smtp.gmail.com with ESMTPSA id u6-20020a170903124600b001d01c970119sm174181plh.275.2023.11.29.20.05.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Nov 2023 20:05:28 -0800 (PST)
From: Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Chinner <dchinner@redhat.com>,
	Allison Henderson <allison.henderson@oracle.com>,
	Zhang Tianci <zhangtianci.1997@bytedance.com>,
	Brian Foster <bfoster@redhat.com>,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	xieyongji@bytedance.com,
	me@jcix.top,
	Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>
Subject: [PATCH v3 0/3] Fixes for ENOSPC xfs_remove
Date: Thu, 30 Nov 2023 12:05:13 +0800
Message-Id: <20231130040516.35677-1-zhangjiachen.jaycee@bytedance.com>
X-Mailer: git-send-email 2.35.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

Recently, our use-case ran into 2 bugs in case doing xfs_remove when the
disk space is in-pressure, which may cause xfs shutdown and kernel crash
in the xfs log recovery procedure. Here are 2 patches to fix the
problem, and a patch adding a helper to optimize the code structure.

The 1st patch fixes an uninitialized variable issue.

The 2nd patch ensures the blkno in the xfs_buf is updated when doing
xfs_da3_swap_lastblock().

The 3rd patch adds a xfs_buf copy helper to optimize the code structure.

Changes of v2:
- directly set the *logflagsp value to make the code more robust in the
  1st commit,
- check xfs's crc-feature rather than magic in the 2nd commit, and
- fixed code style and rebased onto the master branch.

Changes of v3:
- fix code style, and
- add a new patch which does xfs_buf memcpy in a helper.

Thanks,
Jiachen


Jiachen Zhang (1):
  xfs: ensure logflagsp is initialized in xfs_bmap_del_extent_real

Zhang Tianci (2):
  xfs: update dir3 leaf block metadata after swap
  xfs: extract xfs_da_buf_copy() helper function

 fs/xfs/libxfs/xfs_attr_leaf.c | 12 ++----
 fs/xfs/libxfs/xfs_bmap.c      | 73 +++++++++++++++--------------------
 fs/xfs/libxfs/xfs_da_btree.c  | 70 +++++++++++++++------------------
 fs/xfs/libxfs/xfs_da_btree.h  |  2 +
 4 files changed, 69 insertions(+), 88 deletions(-)

-- 
2.20.1


