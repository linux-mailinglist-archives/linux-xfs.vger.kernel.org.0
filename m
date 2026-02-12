Return-Path: <linux-xfs+bounces-30783-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IDPbOmvejWnE8AAAu9opvQ
	(envelope-from <linux-xfs+bounces-30783-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Thu, 12 Feb 2026 15:06:35 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 7958A12E1D5
	for <lists+linux-xfs@lfdr.de>; Thu, 12 Feb 2026 15:06:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D590C318B85D
	for <lists+linux-xfs@lfdr.de>; Thu, 12 Feb 2026 14:02:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F7A735C1AD;
	Thu, 12 Feb 2026 14:02:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FrrDZHE5"
X-Original-To: linux-xfs@vger.kernel.org
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6312135BDCF
	for <linux-xfs@vger.kernel.org>; Thu, 12 Feb 2026 14:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770904967; cv=none; b=mtNKy/zj7sncNOZKIPLFi3LNG8vB2xhr0C7YZnn/YdQHOpEVPMrri67Y/jysO18ActkSPKJDkP8+KBtgtu7cVqbR6Stmuxg0qmeWOvDnrNw0IuYD4TmngAExlFU2/+IFyceOgdZRL8G4/PFhi3IVeE6oU0cHdMfay1t4oXPmfbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770904967; c=relaxed/simple;
	bh=Z23X0NujPCmCGjOmhqq7suAsKtVT5lxdFHLwLKmCw+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sWuWGMBd02uR7GFSlXlHqOFfHk7m33s3fux1s9oZSKUb5Nh8AeHjCArufZeLyTt7Gs44LzikHbeKKk94fjT1BYWo+XOzdvnZMEaguGfKy1QS6hUtjWOxroMdPch8JMjtXWC7JvB53nVFWCOI9o2IoBVwgiB7IEYELOuzdryOFOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FrrDZHE5; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-82310b74496so4178413b3a.3
        for <linux-xfs@vger.kernel.org>; Thu, 12 Feb 2026 06:02:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770904966; x=1771509766; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UNrWvg8TRPD8Huyxa4eyv0ShdQGKI+VQvTdKqCC4jTw=;
        b=FrrDZHE55oziRQNP8NSebviajitQBgB/bgdz+oMTcgscewVX+qUUaOx20CFHu/mxN+
         KWf+plcsJuEZPYFglrz8XgTSC3J0645RxqUxm0ovXdauWHbpxRBFU/NztbHKnfjisA9I
         wcXmxYgONOFtG6XUIlVRAEj4TM5xYTQaZlSi0vAklvfpNprdxjkhUYPOce9Je9y4Tpq9
         OnOrbZxw5KgIbT3NytsH3r7pZXnxMn/pg3q4AODntN/A+Vj88j2NGfMpnJQyXGGhlSOM
         ysPgXxc3fs4q5eyQAHamtcCq0h7O6AS73AvhBW+DeuLHYGB9RNolb1v2hCqQaADt4MZI
         1NEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770904966; x=1771509766;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UNrWvg8TRPD8Huyxa4eyv0ShdQGKI+VQvTdKqCC4jTw=;
        b=ZRKaHlOAyY5OMa1x7lVYSKGRMYnVFR1c5lBQthhmHL6C3yNe+PZIzqmUIm1w/IYNuX
         qneaQ4EycfmHoM3s+bd5q3vxIK7jO8YOHgtXktw4n1nXw+De1hPTiWkTIu9QWjSR/gxh
         zUeLAY0Ea8iz5OyY44v5OyAMAR9kLuEUTQ4nZT5iYOtkdKOUMSP7kjxfvBZa4X10Si0U
         er+5PxtmI5cz+Y67+rtV2FBEIJL0UAZk4xSRlg006k1C1zYdAJ3KD7EnLTf+tQVTXZX6
         2DqC4E+9ERWU7jhGrhhP5VzSLbKu6uhPI0Cvf/wArvqvnBELh2/apSRPJp5B9WXGczxU
         6GQg==
X-Gm-Message-State: AOJu0YwHSC9snyz3FtBjkBL9htiWFm385u3fbHHF8fWId38PWBj03kJs
	xwC/q5/HRQDCvtGfcUV3i+t595D5AlPobFf3Nuq+V4L/GiaPtrTUT4MN
X-Gm-Gg: AZuq6aLzom9wkzOppuSHIa2ZuGDfDMMEMlenGd4TJvgS0XeNUp40iKg8sk3ApuW4nN5
	A9imzm1fPi5E1ZmI0emmdW3ft72O6GVawZV1XSEk0F8jRq3Gym5BWFkf0jDOc0+gNFvUfd/muox
	00NKUgJ6tVlOLlI9spoAzS+OxPVzIJtL8rNGR5MgfpzWp+c5gzRA+5Kpmy3z09hH6c0N7M64/aE
	7qZNQyZb4nFMFMe8QzTsu5gpA0C8sOKOKHg/x7nHw3HjM3z1Bfm6VMU+WgMixwAQdsR6fV7gDrJ
	iGATr1lx5JLYo4LsjijWQ19qxVf9Oy+SGJrp+RoXBA+N0JtKbpfnb6eLT0cCgWxzXFZTt/jIFKw
	hlfLc0ZnCIucrcQnIjh2mzdFVwVVxwbEmml0nrvkVM2Bp2/rFpPS/ReiLrFQMlH1rc/pJymksdA
	pl5xNE82L1DU5fsVZXmQmKO731CTpcp8whE8SeMSgx9S6qHtHN2k8WBfeCtfP7272h/sDnJ5rtP
	CgVhDHPnZX9IH4FyoN9
X-Received: by 2002:a05:6a00:438b:b0:81f:be2a:56e4 with SMTP id d2e1a72fcca58-824b04f6222mr3098985b3a.49.1770904965574;
        Thu, 12 Feb 2026 06:02:45 -0800 (PST)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com.com ([49.207.226.188])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8249e367b7esm5116590b3a.4.2026.02.12.06.02.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Feb 2026 06:02:45 -0800 (PST)
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
To: djwong@kernel.org,
	hch@infradead.org,
	cem@kernel.org
Cc: linux-xfs@vger.kernel.org,
	ritesh.list@gmail.com,
	ojaswin@linux.ibm.com,
	nirjhar.roy.lists@gmail.com
Subject: [PATCH v1 2/4] xfs: Update sb_frextents when lazy count is set
Date: Thu, 12 Feb 2026 19:31:45 +0530
Message-ID: <3621604ea26a7d7b70b637df7ce196e0aa07b3c4.1770904484.git.nirjhar.roy.lists@gmail.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <cover.1770904484.git.nirjhar.roy.lists@gmail.com>
References: <cover.1770904484.git.nirjhar.roy.lists@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_FROM(0.00)[bounces-30783-lists,linux-xfs=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com,linux.ibm.com];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[nirjharroylists@gmail.com,linux-xfs@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[linux-xfs];
	RCPT_COUNT_SEVEN(0.00)[7];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 7958A12E1D5
X-Rspamd-Action: no action

Since sb_frextents is a lazy counter, update it when lazy count is set,
just like sb_icount, sb_ifree and sb_fdblocks.

Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
---
 fs/xfs/libxfs/xfs_sb.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 94c272a2ae26..bf1f4a86dab1 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -1340,17 +1340,18 @@ xfs_log_sb(
 				percpu_counter_sum_positive(&mp->m_ifree),
 				mp->m_sb.sb_icount);
 		mp->m_sb.sb_fdblocks = xfs_sum_freecounter(mp, XC_FREE_BLOCKS);
-	}
-
-	/*
-	 * sb_frextents was added to the lazy sb counters when the rt groups
-	 * feature was introduced.  This counter can go negative due to the way
-	 * we handle nearly-lockless reservations, so we must use the _positive
-	 * variant here to avoid writing out nonsense frextents.
-	 */
-	if (xfs_has_rtgroups(mp) && !xfs_has_zoned(mp)) {
-		mp->m_sb.sb_frextents =
-				xfs_sum_freecounter(mp, XC_FREE_RTEXTENTS);
+		/*
+		 * sb_frextents was added to the lazy sb counters when the
+		 * rt groups feature was introduced.  This counter can go
+		 * negative due to the way we handle nearly-lockless
+		 * reservations, so we must use the _positive variant here to
+		 * avoid writing out nonsense frextents.
+		 */
+		if (xfs_has_rtgroups(mp) && !xfs_has_zoned(mp)) {
+			mp->m_sb.sb_frextents =
+					xfs_sum_freecounter(mp,
+					XC_FREE_RTEXTENTS);
+		}
 	}
 
 	xfs_sb_to_disk(bp->b_addr, &mp->m_sb);
-- 
2.43.5


