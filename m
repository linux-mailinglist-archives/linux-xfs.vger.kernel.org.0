Return-Path: <linux-xfs+bounces-4402-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BB0E86A768
	for <lists+linux-xfs@lfdr.de>; Wed, 28 Feb 2024 04:56:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 44616289942
	for <lists+linux-xfs@lfdr.de>; Wed, 28 Feb 2024 03:56:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A90DE208A9;
	Wed, 28 Feb 2024 03:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="uMTjqg/H"
X-Original-To: linux-xfs@vger.kernel.org
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 521E01F945;
	Wed, 28 Feb 2024 03:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709092602; cv=none; b=NlSsigLvTq1RTS9GpTUsBfg60qVtUa0YcAGdv6uv1Jq1+wkUW5Ew+22oG1UzE16XRVEnpHnfq+PSe8P5x6s3/hiXhj4i4Ge+ii8yW46z4m7ui4Zi7TRm+6cCb9KVlnQ0Dd+mLmMtF+0wwDiL13cXqcwsumCYRGIOu+a0X/R3ltg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709092602; c=relaxed/simple;
	bh=H6Qr2reD5s8r88LVd+vg7tarXaxWu53crt0LqEI8X6U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=eNm4C2r4gSF9DQZYFeDMXLTzUFO3FVGmpK9P+MXDrJhB9tCuZ5bePuej5OtgEB+0tuoLd1RlJbxHrUnP6AHPXaxmesWeqbkh05QPMwOb1GxONBryNiNQMMgycH3vrFQz9IvcZHG2aVCgesc88w0Vj2H8xykTFr/Wj9tRj4jac4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=uMTjqg/H; arc=none smtp.client-ip=115.124.30.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1709092596; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=hZbCOIT/E0UqzQPyFHDNXNS4X1myzrQR/yuhRJSCWXI=;
	b=uMTjqg/H4GO/r/vO4+rXbkIkJZULJq9w31Dzu+DU452pOM60LNTlsYc/7aQPSmC3Sp0rdIlFn0LPuOghHeMfpJ8g8TjbF+SDzhJzcwcVI10ARC1RARY9y8XeqJ+5yvcQJP/uoGF2AkFwY4owkeKfHyEbWOObhQ9X2jXNeDF/tXw=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R781e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045168;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0W1OQcYH_1709092590;
Received: from localhost(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0W1OQcYH_1709092590)
          by smtp.aliyun-inc.com;
          Wed, 28 Feb 2024 11:56:36 +0800
From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To: chandan.babu@oracle.com
Cc: djwong@kernel.org,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
	Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH 2/2] xfs: Remove duplicate include
Date: Wed, 28 Feb 2024 11:56:12 +0800
Message-Id: <20240228035612.25396-2-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
In-Reply-To: <20240228035612.25396-1-jiapeng.chong@linux.alibaba.com>
References: <20240228035612.25396-1-jiapeng.chong@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

./fs/xfs/xfs_trace.c: xfs_bmap.h is included more than once.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Closes: https://bugzilla.openanolis.cn/show_bug.cgi?id=8385
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 fs/xfs/xfs_trace.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/xfs_trace.c b/fs/xfs/xfs_trace.c
index 1a963382e5e9..23e906b60f21 100644
--- a/fs/xfs/xfs_trace.c
+++ b/fs/xfs/xfs_trace.c
@@ -17,7 +17,6 @@
 #include "xfs_btree.h"
 #include "xfs_da_btree.h"
 #include "xfs_alloc.h"
-#include "xfs_bmap.h"
 #include "xfs_attr.h"
 #include "xfs_trans.h"
 #include "xfs_log.h"
-- 
2.20.1.7.g153144c


