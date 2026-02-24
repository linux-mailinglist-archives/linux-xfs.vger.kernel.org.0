Return-Path: <linux-xfs+bounces-31237-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eEDlFtJQnWkBOgQAu9opvQ
	(envelope-from <linux-xfs+bounces-31237-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Tue, 24 Feb 2026 08:18:42 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C8C40182E78
	for <lists+linux-xfs@lfdr.de>; Tue, 24 Feb 2026 08:18:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id AE0AF3064133
	for <lists+linux-xfs@lfdr.de>; Tue, 24 Feb 2026 07:17:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4226E13DBA0;
	Tue, 24 Feb 2026 07:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LPvN8+ZZ";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="sWaaqKY1"
X-Original-To: linux-xfs@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED8D92C15AA
	for <linux-xfs@vger.kernel.org>; Tue, 24 Feb 2026 07:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771917461; cv=none; b=erwrMaUBWDegwpV2Rn6TVVOmFPtrhoQXLIJj2fotx5WF2wHdG+Uzh2pZRloZVTCVcoKp2QVV8N8BSXZ4MdRMddga3VUd9Gt9/pm+TZmwFeYu9U7oCdCHabnWX0zDIfedXMwvIxkcqdNwoDC0+EX086OVI5/fy89a7BllTzsBvTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771917461; c=relaxed/simple;
	bh=xGmONydd2jWiN+UzdnBYNlTMyfE/g2e7SF2xqbSe3Mk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZScEjbbkkMWS3QlykPkRW7U2lZQusFo+eWfdozvPhJmkNbns4FMPxXv92BO2wIunyjw6THwXZS0pNM9RP7JRACwwEbcAZUYqtbY4yLpAEIP+OktjTh33XtrjNwzuoGDXRELpr/SJDrv2jhssy4zsxPJ/y/HQU4IHsCP+9TsJgD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LPvN8+ZZ; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=sWaaqKY1; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771917459;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bMIeqtSnCK7ha2/zVgmj7vaLrcRrbv04MQlOsYPLD4I=;
	b=LPvN8+ZZX+cKzDWB2rmMuBm0Ru5EGPCXmgufAaAlGpnOpkh4k5lBe/KVsDzvM8MIqtjd/i
	NdD0GC6AL15kq+WRnE9zbWcx1SzOwTAbAD4ipcvkFkEloYcKbqkEETxRGGaT1VpCyAbT2W
	vBTjmqaGswDWWhIp/U/hH3gizwFCHP0=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-411-C2u1HB5TOmWX3qz-H1MKbQ-1; Tue, 24 Feb 2026 02:17:37 -0500
X-MC-Unique: C2u1HB5TOmWX3qz-H1MKbQ-1
X-Mimecast-MFC-AGG-ID: C2u1HB5TOmWX3qz-H1MKbQ_1771917457
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2adaa9c4b89so3193125ad.0
        for <linux-xfs@vger.kernel.org>; Mon, 23 Feb 2026 23:17:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1771917456; x=1772522256; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bMIeqtSnCK7ha2/zVgmj7vaLrcRrbv04MQlOsYPLD4I=;
        b=sWaaqKY1KSTM+yN5+Kvgqz8RG33d7USkebTCIHbe83Ry+cSGas6KcJ6FLVO9Dzqg7c
         Ch8qKFVOAYa8w6USkXSPe3yhv4Msys2j7txqk5yA7NozYS0LqsgEmtmva80xygP2K196
         5c/QHMeykG3Y9lUJVeOW3LjKXH4F+yquWBOD/ghBC/TATX7a2dapW1lK/ejgKnpb8mmy
         x2t6AXUricLq0Vla6CDIv3ov6DWBwvgitlTqK/Z/UDnrIfN/PeK7xyyWKMHmHWlWlad2
         qD6FrB9BDj+y3KMBSO4JnHp+Ax/HF2MTTVrLYqkRGWuuN3eNYoEF4xxC9z8ctaH4BMEw
         piPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771917456; x=1772522256;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bMIeqtSnCK7ha2/zVgmj7vaLrcRrbv04MQlOsYPLD4I=;
        b=DtI4g6MGxy27Ag8P22S/KnVq/fM4A4ydmeVzy8QM9ZJyIpBmEEBxqPabvhVt6NXifk
         u8jvDFbQDQBbFqsmEW671TAvsd7Hb1xfGohbFnTJXh3wJUt2l0GPIJw9Gh5KHL0oF613
         oTVuMkb1DCc6BQ1ujiXaxKaNyrSGs1LVs3Gq9a8ZH5RGUWcPBW3mrjWDdU5eS602YkzI
         wHbfSzYmuoFmUh2ud7O0i5iFNX/Q9xAG9E36KYWcjSY/vP7y3RugJlsE9OpK1jOxRoad
         t35bzpGTA2Sm1S1Z02rgGvoo0gdNXrfO9X5DamM1xtntVDeu8/HX6D+SzOx7DaCPvz66
         cObQ==
X-Gm-Message-State: AOJu0Ywvw3gbXNfUHwOenDXw2aHQKmYn9YVyJDOA5hxHK8Vdv1rauoOE
	UWqZ1Zj/25zJHuNjDWm+44HPXU2oJHoJ37ZkOwviOxcG8/3VUPIWxek0139CwVyS3TN5SnoEiQA
	Sy/I15xwbtl2tvs+gzpVtKuWnzrKSMUUpNLLU+gNuTiOYDCCraLhMs56V9oiaIYqIVcpcRI4rS3
	Odmquu7jD1kEaJj2LtzADG2w0TqqkQ7lexHiLbl1ehF9PaCg==
X-Gm-Gg: ATEYQzzlBkiHedK7ykd2bvrmZkbvBRL9HqC38Om3dw1lD40ZAFqZ0zY2nYax+ihqz2+
	ESt7jj022ywW7BJrDarUJyvVHH7a2jQGxHCsPRHQ30GUdSXLfmZwL1fB5B38ULcLObWmACoa8c/
	zhYwyBwAmyQiDu+I7YImuNwYwZ9Kb306OUZCYccjRTibmOIFAJ5nUrWKD8xTiv+qWnlDeDnTjlm
	TqCQ0cmtt2uD945ncOUHrjAM/9DjoNdO/6STcDUdBXclF5a0M5BOYjMZfs+e61jKc81VCorE6bv
	6kF07QE6c9AJMWxUGyZeRpAMYuRnfwuDSpeaJV8l6Yun96UeG7/tYyr/gAHmNkNaeAEFZIpZl+2
	yJ5Y2g5FCI4kyb+LCoMCWi8ydPRtxvGqs4w==
X-Received: by 2002:a17:902:cecf:b0:2ad:b213:feba with SMTP id d9443c01a7336-2adb213ff9dmr380095ad.5.1771917456574;
        Mon, 23 Feb 2026 23:17:36 -0800 (PST)
X-Received: by 2002:a17:902:cecf:b0:2ad:b213:feba with SMTP id d9443c01a7336-2adb213ff9dmr379905ad.5.1771917456061;
        Mon, 23 Feb 2026 23:17:36 -0800 (PST)
Received: from anathem.redhat.com ([2001:8003:4a36:e700:56b6:ee78:9da2:b58f])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ad80907b4csm58720515ad.78.2026.02.23.23.17.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Feb 2026 23:17:35 -0800 (PST)
From: Donald Douwsma <ddouwsma@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: Donald Douwsma <ddouwsma@redhat.com>
Subject: [PATCH 1/5] xfsrestore: remove unused variable strctxp
Date: Tue, 24 Feb 2026 18:17:08 +1100
Message-ID: <20260224071712.1014075-2-ddouwsma@redhat.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260224071712.1014075-1-ddouwsma@redhat.com>
References: <20260224071712.1014075-1-ddouwsma@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-31237-lists,linux-xfs=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ddouwsma@redhat.com,linux-xfs@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[linux-xfs];
	NEURAL_HAM(-0.00)[-0.999];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: C8C40182E78
X-Rspamd-Action: no action

Reviewing xfsdump warnings showed

content.c: In function ‘restore_extattr’:
content.c:8635:27: warning: unused variable ‘strctxp’ [-Wunused-variable]
 8635 |         stream_context_t *strctxp = (stream_context_t *)drivep->d_strmcontextp;
      |                           ^~~~~~~

strctxp is never used in restore_extattr() remove it.

Signed-off-by: Donald Douwsma <ddouwsma@redhat.com>
---
 restore/content.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/restore/content.c b/restore/content.c
index 7ec3a4d..b916e39 100644
--- a/restore/content.c
+++ b/restore/content.c
@@ -8632,7 +8632,6 @@ restore_extattr(drive_t *drivep,
 {
 	drive_ops_t *dop = drivep->d_opsp;
 	extattrhdr_t *ahdrp = (extattrhdr_t *)get_extattrbuf(drivep->d_index);
-	stream_context_t *strctxp = (stream_context_t *)drivep->d_strmcontextp;
 	bstat_t *bstatp = &fhdrp->fh_stat;
 	bool_t isfilerestored = BOOL_FALSE;
 
-- 
2.47.3


