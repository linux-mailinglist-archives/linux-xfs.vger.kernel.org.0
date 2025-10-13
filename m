Return-Path: <linux-xfs+bounces-26283-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id CED16BD141B
	for <lists+linux-xfs@lfdr.de>; Mon, 13 Oct 2025 04:49:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id CF4654E600D
	for <lists+linux-xfs@lfdr.de>; Mon, 13 Oct 2025 02:49:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 475F621B9E0;
	Mon, 13 Oct 2025 02:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="kbvAdzBg"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D083135948
	for <linux-xfs@vger.kernel.org>; Mon, 13 Oct 2025 02:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760323786; cv=none; b=WSlFZ0YfxRgLeImM1rSn7F2iwbu7bw5MRJnclsiDTc4eEhlzlBHDlbUg3D2lvzqUKdU9KUlBWYXPRQaWIGOcEMkfPQoLxrfvZisz+OnhgdDM2JQBYPJAanOr97zM6wP5nya6Oy9lyicXMyb4QoJq8WdgJVWUIJS82f1YNANsJNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760323786; c=relaxed/simple;
	bh=yVeBggqqJ1rSaDhN3HBvw78oheS4hgb5ZQYFywp8vHk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z1SbwVQEhkOLuJsAsw7dAebxjb1Up3OCKdkJlJddS4Jj11GJmFzjCy61yBDzSyd+p3j14VasVRE2BfXg36ToVBozwgoiAVDQFHaQ6WoDwKzdQxtfrJassh1RPdfxPdIftKXk65vGgZISDRV/ZaNpdLDLKctjnWbag/UbHTsN6G0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=kbvAdzBg; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=YPso+AwMyFhgjWgaVrKSRhef9Nldt5S+mxohxwsdpGY=; b=kbvAdzBgA60Hi5/quIs7bozoJX
	nCRCHExHgkoAXaE3olG3SMpulOlewIsaSGSyk+NuIi2ZHmTXeg7q5FPSH2BKKdfqipQTvaZlUoVM8
	7qzeg2MsMUEYDEBxcNk80tC1mfF0UbB1B+arPnekbnXK9/hTfL3DXBWx1eAx+WNI5GjTONIjbi+wW
	01E7PadRQyJWBbqVTwp0qmgGC5Ok5Ips1kWzNHDGI3nslARLGnMNEJVaECzVnSCOJufpWrfz4Wwzw
	GwmzLffqyAe8dXnHd1j53l70x1ousf0l7Zz0acNtcLQT0JdbOlgk95MHmZ4QgQQWTP3Kpk8MVzSuu
	jd3uQv5g==;
Received: from [220.85.59.196] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v88d6-0000000C7hp-068I;
	Mon, 13 Oct 2025 02:49:44 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 11/17] xfs: remove q_qlock locking in xfs_qm_scall_setqlim
Date: Mon, 13 Oct 2025 11:48:12 +0900
Message-ID: <20251013024851.4110053-12-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251013024851.4110053-1-hch@lst.de>
References: <20251013024851.4110053-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

q_type can't change for an existing dquot, so there is no need for
the locking here.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_qm_syscalls.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 6c8924780d7a..022e2179c06b 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -302,9 +302,7 @@ xfs_qm_scall_setqlim(
 		return error;
 	}
 
-	mutex_lock(&dqp->q_qlock);
 	defq = xfs_get_defquota(q, xfs_dquot_type(dqp));
-	mutex_unlock(&dqp->q_qlock);
 
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_qm_setqlim, 0, 0, 0, &tp);
 	if (error)
-- 
2.47.3


