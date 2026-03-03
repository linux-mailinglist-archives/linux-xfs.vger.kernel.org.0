Return-Path: <linux-xfs+bounces-31639-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QB/OMYonpmk+LQAAu9opvQ
	(envelope-from <linux-xfs+bounces-31639-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Tue, 03 Mar 2026 01:12:58 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CF131E7006
	for <lists+linux-xfs@lfdr.de>; Tue, 03 Mar 2026 01:12:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 5641C302C75F
	for <lists+linux-xfs@lfdr.de>; Tue,  3 Mar 2026 00:12:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1B241684BE;
	Tue,  3 Mar 2026 00:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pvLQ4eEt"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F7E51632E7
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 00:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772496776; cv=none; b=oIhJEcf6J7lqQAJvJGtxQy1BKLdLrHSDhUcdOq4mgnbbzzNbAcUhoPx46LcmBM3VTvoMzSvWRpYT4qnBlOGBYDC4KPAQ2Nku5FdkqgOSkSGT10iFoXXXQ8DM8YcaqSgpOoKDs8I8vZL0mioicOcw39yMdU5QVrJPlmSEx5Zqecc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772496776; c=relaxed/simple;
	bh=EP2OYme2W0t2CEqTpWazQZBZRcj42xfvJo+Xjy3bSQs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JDhRbj+1qlb44WXVSlxGW+F7D91c6NAU+bSv8VktINCbTp5Rhar8V5mS+hD0ux8/0k84b2S8LiBMBALW3nb4eK32Y+Er/ehGrb6LpxNTHWXOQAdEQz4KsRGSGCikbqqF/ycbTODMYJGk8pFpXcJTYxOyL3wqBIlESQ5u6BjTZUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pvLQ4eEt; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A8F9C19423;
	Tue,  3 Mar 2026 00:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772496776;
	bh=EP2OYme2W0t2CEqTpWazQZBZRcj42xfvJo+Xjy3bSQs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=pvLQ4eEtdYyTSPQxM3EkOEuPb22agyfgl557Y64szNoBzOEEgjjfEAxm+01q+cckH
	 1w+6/Nvg1vEA7DRD40rL7CkgkH655/yEE400QNVbrG3eXb149K5ZzIEwDPCdrA32Pl
	 PYt2tDIYnnmatpReLYi3B9ocgNSlv3pElW0YKyPtePQfc/DCcFed0clJ5kt9uLruVr
	 IsDf+d/c6GzkJlrh7A5ZhJ8j5d9NZvXy1Eo3VLhzuXfPemr2FXktPI/piiNCtO5xRh
	 nIEvmsD/gZUPgeP7cTrkhuf0itJcHtyVBMYI0CbC3nY+omJGK9m/AIbLNl9y/CmR+h
	 0Bi1X+8OIMb0g==
Date: Mon, 02 Mar 2026 16:12:55 -0800
Subject: [PATCH 03/36] xfs: start creating infrastructure for health
 monitoring
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177249637831.457970.12019564788928142266.stgit@frogsfrogsfrogs>
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
X-Rspamd-Queue-Id: 5CF131E7006
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-31639-lists,linux-xfs=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	TO_DN_NONE(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[djwong@kernel.org,linux-xfs@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[4];
	NEURAL_HAM(-0.00)[-0.999];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-xfs];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Action: no action

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: a48373e7d35a89f6f9b39f0d0da9bf158af054ee

Start creating helper functions and infrastructure to pass filesystem
health events to a health monitoring file.  Since this is an
administrative interface, we only support a single health monitor
process per filesystem, so we don't need to use anything fancy such as
notifier chains (== tons of indirect calls).

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_fs.h |    7 +++++++
 1 file changed, 7 insertions(+)


diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 12463ba766da05..c58e55b3df4099 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -1003,6 +1003,12 @@ struct xfs_rtgroup_geometry {
 #define XFS_RTGROUP_GEOM_SICK_RMAPBT	(1U << 3)  /* reverse mappings */
 #define XFS_RTGROUP_GEOM_SICK_REFCNTBT	(1U << 4)  /* reference counts */
 
+struct xfs_health_monitor {
+	__u64	flags;		/* flags */
+	__u8	format;		/* output format */
+	__u8	pad[23];	/* zeroes */
+};
+
 /*
  * ioctl commands that are used by Linux filesystems
  */
@@ -1042,6 +1048,7 @@ struct xfs_rtgroup_geometry {
 #define XFS_IOC_GETPARENTS_BY_HANDLE _IOWR('X', 63, struct xfs_getparents_by_handle)
 #define XFS_IOC_SCRUBV_METADATA	_IOWR('X', 64, struct xfs_scrub_vec_head)
 #define XFS_IOC_RTGROUP_GEOMETRY _IOWR('X', 65, struct xfs_rtgroup_geometry)
+#define XFS_IOC_HEALTH_MONITOR	_IOW ('X', 68, struct xfs_health_monitor)
 
 /*
  * ioctl commands that replace IRIX syssgi()'s


