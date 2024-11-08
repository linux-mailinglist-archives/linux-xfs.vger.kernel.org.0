Return-Path: <linux-xfs+bounces-15209-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 949699C125C
	for <lists+linux-xfs@lfdr.de>; Fri,  8 Nov 2024 00:27:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4C73E1F2347A
	for <lists+linux-xfs@lfdr.de>; Thu,  7 Nov 2024 23:27:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7850218D94;
	Thu,  7 Nov 2024 23:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jiU3ZU/l"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75CE32170B2
	for <linux-xfs@vger.kernel.org>; Thu,  7 Nov 2024 23:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731022025; cv=none; b=XLGbtxWEIpxQyFdNwcGSE4JuuZjC6jbgYN3EwsqhqiV5VaL6DvELGNTsRh+i8nGPwRWCrmK20NSuL1QOVcdqQpocmWJSN4k1JxD5UmJKQ/wysFzbWdr8jWEK97b4dYVhA+GHzu9O0wf48WbK1YnNNEkVD9jgJRkiLPbE5pB/el4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731022025; c=relaxed/simple;
	bh=OaGV+TH6pLtA5ze+4nl505cPKWUguc+lYrdHGo+0rUM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XrI8bMoXtq65jpJxZvA1Aj+KuR36hnEQPmBDbgjKiLCZKH7EGFRYWiEZdiwhTLhTrJDbgdTKTUFfyJ5ScaALvW6969BF8f6Dj+silIIpK7qlYu7Eau0jCHuiImF1PKabB5s4h+UctDGPPwXQSf5QCLM8w/tV45RkkXSg7SVQ36o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jiU3ZU/l; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07FC1C4CECC;
	Thu,  7 Nov 2024 23:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731022025;
	bh=OaGV+TH6pLtA5ze+4nl505cPKWUguc+lYrdHGo+0rUM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=jiU3ZU/ljfK5MJx1kvGrckwGb9rasIW3rwEHmGNdnEgGkoxn6I1DisDdP88FLnbxE
	 wQvevpP/SqSjeM6Az7YNAk5pxV1AAcoXzfqgQ89AuTYbx4Az/1jjn7ZSO1pkZUOuOt
	 Kj/wGdmhjQUYZODWmI+yHjtwvHqotdmxdR6DDwr365FXeC8mA3ZCSMGeKtN6HaV9Cl
	 l5Me2eLSlw/TpjyJ3Wfq50U9ee8fkv6720cwQ3AR3AT2UTBs0IgUM3ei64HJ0hXLK2
	 sBe3nFLyFK0z0N31iycelPd4Us06BL3oAQzWyvXpQ3DMLDoanDErNWZlgd3FWEn74w
	 tW2JI5kLF/Buw==
Date: Thu, 07 Nov 2024 15:27:04 -0800
Subject: [PATCH 4/4] design: update metadump v2 format to reflect rt dumps
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173102187933.4143993.5785776084169738258.stgit@frogsfrogsfrogs>
In-Reply-To: <173102187871.4143993.7808162081973053540.stgit@frogsfrogsfrogs>
References: <173102187871.4143993.7808162081973053540.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Update the metadump v2 format documentation to add realtime device
dumps.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 design/XFS_Filesystem_Structure/metadump.asciidoc |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)


diff --git a/design/XFS_Filesystem_Structure/metadump.asciidoc b/design/XFS_Filesystem_Structure/metadump.asciidoc
index a32d6423ea6e75..226622c0d2f20e 100644
--- a/design/XFS_Filesystem_Structure/metadump.asciidoc
+++ b/design/XFS_Filesystem_Structure/metadump.asciidoc
@@ -119,7 +119,16 @@ Dump contains external log contents.
 |=====
 
 *xmh_incompat_flags*::
-Must be zero.
+A combination of the following flags:
+
+.Metadump v2 incompat flags
+[options="header"]
+|=====
+| Flag				| Description
+| +XFS_MD2_INCOMPAT_RTDEVICE+	|
+Dump contains realtime device contents.
+
+|=====
 
 *xmh_reserved*::
 Must be zero.
@@ -143,6 +152,7 @@ Bits 55-56 determine the device from which the metadata dump data was extracted.
 | Value		| Description
 | 0		| Data device
 | 1		| External log
+| 2		| Realtime device
 |=====
 
 The lower 54 bits determine the device address from which the dump data was


