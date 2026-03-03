Return-Path: <linux-xfs+bounces-31662-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UN+DGvQopmk+LQAAu9opvQ
	(envelope-from <linux-xfs+bounces-31662-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Tue, 03 Mar 2026 01:19:00 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CCAE1E70DA
	for <lists+linux-xfs@lfdr.de>; Tue, 03 Mar 2026 01:18:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 465A8304CEB0
	for <lists+linux-xfs@lfdr.de>; Tue,  3 Mar 2026 00:18:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D766B1632DD;
	Tue,  3 Mar 2026 00:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MYaVV4aO"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3B80390991
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 00:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772497137; cv=none; b=vDfshb3w3nYElPIvF8zbM3K8YAl3l1eWolu/cpxAp+YpbruEJILoCFfr3xCFEXDU7aCr1+5lJ0o20Pj+vUJ5rKHqrCbPbG4oA9OPsTJKjGUTw+f5M6prpP+SnL4+RX2IGIyjZDoJO6425V2cXM5Vlmb4chdalxLG85s9GVu6SNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772497137; c=relaxed/simple;
	bh=b5C34FoUc0zxqJPttP8/Pe5OieiCtsWzRFDnaAvQ4v0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fYozMxLCrS+RaaRWE3RCgOE5YqsUi9PShfz6lSrp1TFQjAI4BaAbKV/HJBIopbqMgKAlOw+gpY0CGw23rMTXfTdd7KCRnX35nDUxJ6EXyB715E+bvufJbiUSPCauF3K8b+uBrxniz1d0WAlKB7ZC5hMdpCT+Wi6DliQGwpyewbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MYaVV4aO; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E73BC19423;
	Tue,  3 Mar 2026 00:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772497137;
	bh=b5C34FoUc0zxqJPttP8/Pe5OieiCtsWzRFDnaAvQ4v0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=MYaVV4aOMVXgX93BMM1eh3XlbCr16WccxHN2doQIcCwab06+Hl+oFL89xp2WCoffU
	 lF22/VijLjXmUzhmriGHlNt3PVbEu/bTNL57jPH5CjmEU2zHRKhy2YHFMQA+vm+Fjh
	 t7IkpJpleVzgUqB6YEMPyb46NrvZiATROfcXt/8RUY6EGzl0E2zJ+NxvGnuc1rkqGR
	 BZPeCLDtvudJcYe5voQlgmlqBAvEH0hKKn6WgQLB2E5E2/T+q3qvCtI+Chs76IPq0c
	 Yt+oVGiMJz/Y0RxZ+DSBdxUgDV1YKYQ78b10WgJ728hx6nJ8ar48o5HmSKMUcs9Ckq
	 bQYHZ0QzHR2gg==
Date: Mon, 02 Mar 2026 16:18:57 -0800
Subject: [PATCH 26/36] xfs: don't validate error tags in the I/O path
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: cem@kernel.org, cmaiolino@redhat.com, hans.holmberg@wdc.com, hch@lst.de,
 linux-xfs@vger.kernel.org
Message-ID: <177249638256.457970.12041287422883068113.stgit@frogsfrogsfrogs>
In-Reply-To: <177249637597.457970.8500158485809720053.stgit@frogsfrogsfrogs>
References: <177249637597.457970.8500158485809720053.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 8CCAE1E70DA
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	TAGGED_FROM(0.00)[bounces-31662-lists,linux-xfs=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_NONE(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[djwong@kernel.org,linux-xfs@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[linux-xfs];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,lst.de:email]
X-Rspamd-Action: no action

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: b8862a09d8256a9037293f1da3b4617b21de26f1

We can trust XFS developers enough to not pass random stuff to
XFS_ERROR_TEST/DELAY.  Open code the validity check in xfs_errortag_add,
which is the only place that receives unvalidated error tag values from
user space, and drop the now pointless xfs_errortag_enabled helper.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hans Holmberg <hans.holmberg@wdc.com>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_errortag.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/libxfs/xfs_errortag.h b/libxfs/xfs_errortag.h
index 57e47077c75a2a..b7d98471684bf1 100644
--- a/libxfs/xfs_errortag.h
+++ b/libxfs/xfs_errortag.h
@@ -53,7 +53,7 @@
  * Drop-writes support removed because write error handling cannot trash
  * pre-existing delalloc extents in any useful way anymore. We retain the
  * definition so that we can reject it as an invalid value in
- * xfs_errortag_valid().
+ * xfs_errortag_add().
  */
 #define XFS_ERRTAG_DROP_WRITES				28
 #define XFS_ERRTAG_LOG_BAD_CRC				29


