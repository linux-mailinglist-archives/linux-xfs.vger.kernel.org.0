Return-Path: <linux-xfs+bounces-31002-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CCiCKkqdlmksiAIAu9opvQ
	(envelope-from <linux-xfs+bounces-31002-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Thu, 19 Feb 2026 06:19:06 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 226A615C163
	for <lists+linux-xfs@lfdr.de>; Thu, 19 Feb 2026 06:19:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 861823017F82
	for <lists+linux-xfs@lfdr.de>; Thu, 19 Feb 2026 05:19:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9F292701B1;
	Thu, 19 Feb 2026 05:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VnPevLt+"
X-Original-To: linux-xfs@vger.kernel.org
Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6A5A27C866
	for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 05:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771478343; cv=none; b=DqVNGFoGX/arNuT2RvfvMyHicY4UYDV+gEifgCfAuUPLihVNRCQMvj2rEdw4C6j/tF4jHaEUKkRvVu+IQr04foHm/ZS5lQOXTqwVI+brV8Ulrl5JPJ6GviLTlhjUxgQwJbqlzQfKa2HekARUL/Xxt7y9g0xPbSDoCwVi3XUVrfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771478343; c=relaxed/simple;
	bh=yAOLt5cp2yu+UqjPxG15UIW33I+iBd4PUKxTeXhmCn0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LetD1J5m9gHF4Ml/Dj6gNuqkZn8dAkbEO9Lv/0GuhTkbXQFXOv32vw6yIGNt8UYCeuebJTxcsUDNub2yR5XxXvZ5GS6+n53PVsnBLVIFtiH7zrEcVzxEmY4oXYQMc4wM/DvvcopScWFYkq5/aU7xJCqkFKx6vcjNsFumlZghwEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VnPevLt+; arc=none smtp.client-ip=209.85.128.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-794f701a3e6so5417757b3.2
        for <linux-xfs@vger.kernel.org>; Wed, 18 Feb 2026 21:19:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771478341; x=1772083141; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=pZ250747q10WS5+8kR/YF5mfo58r2Yqv/yzlUt3P8g8=;
        b=VnPevLt+euKQl8t9GJAjsiKRukc4WiYNqYPJr8x/QLcMnQEOYyTkZ2+IafugoVfaa4
         wIYL3i4OF2llB2kq90QcaG/buZoXsmIHeQJMJXSBI7i7kM9I+hmamJZ5Ca8oy7ZXPDzl
         IFjrJZF+Uu1160Phf898Aq7gKTuT20oeQ4IuI4t3NbcY8AiKev53k3DJgxEJDssjnUQ4
         gtw6KWqrt8JmTgfgqPJ4xiscr11cQgUQT8WYQLfbM8t7OyPOQdueIJJSaqAoy2jl2GzO
         d3z/qj6NpT8OdcEeoU1GH8beygJgO6lEwVHvOq0DBqD8mH4MyOZWtAcmDpvDm6EGZV1n
         yzNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771478341; x=1772083141;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pZ250747q10WS5+8kR/YF5mfo58r2Yqv/yzlUt3P8g8=;
        b=Cd0GlrHw61BHhArysbz8OkESOR0urJUF7K/Ywkd/TngqXQOCEyE9aSLgg6Iv5B1yU/
         gQ6YKRxJxlc+b4JTGJRoB2RxgQP+tU4pyW4XqKa5j0Ki+u3LW4463zhzS0/sLXDCfquM
         tWMa9Xg8lvqgHkXmf76uUmaolWlhyA5JYuWNwRY67U226HnI9ZFTZsCSCTE8xQrCdNp9
         aGymc+amr8ZqOtF2B+phO9gM+eWUOZrYcS68Wai00lcdgsiMImTM5iald1eX2ziIV7cE
         ixvtQI8KPftXhre/+MGQ+imiFxvOJXX/vrmFjuQtRqQDlXuw6k8sKyDZxxt1RLdidvQ5
         h5NA==
X-Forwarded-Encrypted: i=1; AJvYcCUiZKARdsGqgrd1oB9Jo1IBDBlan8Kr02RtiTKnrhG/g3FpLjtDS0gSV9S/yFXyC9KIIYOoYpIeAyE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxKaz2yfIQ2aH1ZbW2erUxl5FhGE/GslBucp4+Z4+ov1wYNbI6L
	zG687V8yJW8LQEmP5OT1blOFaJvgxiarmi6uulmO8i8pO0S5hPLCRl4w
X-Gm-Gg: AZuq6aKj9q6Byss8em+mjBanKBOelT71DS9kJiKKtuhKxegEkJf8hanKgA8eHOtCXxA
	oK0/duV/iW81ayHgY4htv6tJHSuf5YDcAkV9rD1YM7wmerpClkbhlvRqQx4YCpe3xLB0vrT+KoB
	oV01pBY0eJRO13K2xfX8Yj/dvat0S28SoRGrV1QYwCzJG6+sOViL5i2y4bgIcf/UWwZaQonkaHE
	r5BkEMnchCPSk46R0ikZ8N/hocsBRpL4R9PSSbuo1CktmHeiW5PxZfD23Wbu86FWMTIHFU+mgJL
	ZD3L9Pw+m31fxguwsUbj8Vr7bVTe8Vwu4FVubnv9hVWL7m2gk89AqJTKTglQ1SSQpfJnTxrSIof
	qlMwW517WuGKEctHhjvTVXqxdTtygut9lcxTJeB14kkoI45Dy/p/QHpUiAo8dRzPcuQmAk+arHW
	sE8hdAIsDFf6D1iCNIuEW0GN0R3wPCHZ7osBbc3H21z/0nyrkQTyGaz9RKpY/tXIfZ8Un8lbcSz
	P46siT45hcLklEttI4FV/j8IGB8ul3RdvPol0eAMnY=
X-Received: by 2002:a05:690c:87:b0:798:1f8:3acc with SMTP id 00721157ae682-79803c7a3ebmr14472327b3.33.1771478340743;
        Wed, 18 Feb 2026 21:19:00 -0800 (PST)
Received: from tux ([2601:7c0:c37c:4c00:e3a8:26f7:7e08:88e1])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7966c23f251sm131638257b3.24.2026.02.18.21.19.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Feb 2026 21:19:00 -0800 (PST)
From: Ethan Tidmore <ethantidmore06@gmail.com>
To: Carlos Maiolino <cem@kernel.org>,
	NeilBrown <neil@brown.name>
Cc: Christian Brauner <brauner@kernel.org>,
	Jeff Layton <jlayton@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>,
	"Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ethan Tidmore <ethantidmore06@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH v2] xfs: Fix error pointer dereference
Date: Wed, 18 Feb 2026 23:18:41 -0600
Message-ID: <20260219051841.60999-1-ethantidmore06@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_CC(0.00)[kernel.org,gmail.com,vger.kernel.org];
	TAGGED_FROM(0.00)[bounces-31002-lists,linux-xfs=lfdr.de];
	RCVD_COUNT_FIVE(0.00)[5];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ethantidmore06@gmail.com,linux-xfs@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	NEURAL_HAM(-0.00)[-1.000];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_RCPT(0.00)[linux-xfs];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 226A615C163
X-Rspamd-Action: no action

The function try_lookup_noperm() can return an error pointer and is not
checked for one. Add checks for error pointer and propagate it.

Fixes: 73597e3e42b4 ("xfs: ensure dentry consistency when the orphanage adopts a file")
Cc: <stable@vger.kernel.org> # v6.16
Signed-off-by: Ethan Tidmore <ethantidmore06@gmail.com>
---
 fs/xfs/scrub/orphanage.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/scrub/orphanage.c b/fs/xfs/scrub/orphanage.c
index 52a108f6d5f4..3269a0646e19 100644
--- a/fs/xfs/scrub/orphanage.c
+++ b/fs/xfs/scrub/orphanage.c
@@ -442,6 +442,9 @@ xrep_adoption_check_dcache(
 		return 0;
 
 	d_child = try_lookup_noperm(&qname, d_orphanage);
+	if (IS_ERR(d_child))
+		return PTR_ERR(d_child);
+
 	if (d_child) {
 		trace_xrep_adoption_check_child(sc->mp, d_child);
 
@@ -464,7 +467,7 @@ xrep_adoption_check_dcache(
  * There should not be any positive entries for the name, since we've
  * maintained our lock on the orphanage directory.
  */
-static void
+static int
 xrep_adoption_zap_dcache(
 	struct xrep_adoption	*adopt)
 {
@@ -476,9 +479,12 @@ xrep_adoption_zap_dcache(
 	/* Invalidate all dentries for the adoption name */
 	d_orphanage = d_find_alias(VFS_I(sc->orphanage));
 	if (!d_orphanage)
-		return;
+		return 0;
 
 	d_child = try_lookup_noperm(&qname, d_orphanage);
+	if (IS_ERR(d_child))
+		return PTR_ERR(d_child);
+
 	while (d_child != NULL) {
 		trace_xrep_adoption_invalidate_child(sc->mp, d_child);
 
@@ -497,6 +503,8 @@ xrep_adoption_zap_dcache(
 		d_invalidate(d_child);
 		dput(d_child);
 	}
+
+	return 0;
 }
 
 /*
@@ -592,7 +600,10 @@ xrep_adoption_move(
 	xfs_dir_update_hook(sc->orphanage, sc->ip, 1, adopt->xname);
 
 	/* Remove negative dentries from the lost+found's dcache */
-	xrep_adoption_zap_dcache(adopt);
+	error = xrep_adoption_zap_dcache(adopt);
+	if (error)
+		return error;
+
 	return 0;
 }
 
-- 
2.53.0


