Return-Path: <linux-xfs+bounces-30540-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iov0Oq7ce2kdJAIAu9opvQ
	(envelope-from <linux-xfs+bounces-30540-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Thu, 29 Jan 2026 23:18:22 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 5712BB53C6
	for <lists+linux-xfs@lfdr.de>; Thu, 29 Jan 2026 23:18:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 39E5130157F6
	for <lists+linux-xfs@lfdr.de>; Thu, 29 Jan 2026 22:18:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BF50361DDF;
	Thu, 29 Jan 2026 22:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b="KH9PLm81"
X-Original-To: linux-xfs@vger.kernel.org
Received: from mailly.debian.org (mailly.debian.org [82.195.75.114])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADB6635292A
	for <linux-xfs@vger.kernel.org>; Thu, 29 Jan 2026 22:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.114
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769725100; cv=none; b=ojggciVcU8KS0eXD2dw9610sBsJe/sczpmWFfXWpDPueRleeU6SIBgJy4z9oJJSHTCM1aPbB6uHjNiBuFoFZBbs9CLnAFgXlnhXQnWalD3Vr0p151LFeZeUFrE+PRupzCU0rQlyprqypv6N/LYCtq28l9lZpMQLLXLKq5mhHPLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769725100; c=relaxed/simple;
	bh=jipQX2RJSotdSG3Jt6QE03v93AC5MGQriW6amT6dfys=;
	h=To:From:Subject:Date:Message-Id; b=PbDkmFI4c7qearV42REXzNEWOwY4okHtLc91oXot8L/gz/e5ykqIupUax8vMIiI9eorM72A6dVR1lcGPshR6v1Zwm2efHo+nPCHJo+9PbWttP8co/FrcyzajSL48WVJCXVrD765LVyOd9uhYCRB71Z/Y0cS+uEjEshAE/aVC5eo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ftp-master.debian.org; spf=none smtp.mailfrom=ftp-master.debian.org; dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b=KH9PLm81; arc=none smtp.client-ip=82.195.75.114
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp-master.debian.org
Received: from usper.debian.org ([2603:400a:ffff:bb8::801f:45]:39780)
	from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=usper.debian.org,EMAIL=hostmaster@usper.debian.org (verified)
	by mailly.debian.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <ftpmaster@ftp-master.debian.org>)
	id 1vlaLA-0055Wg-2O
	for linux-xfs@vger.kernel.org;
	Thu, 29 Jan 2026 22:18:16 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=ftp-master.debian.org; s=smtpauto.usper; h=Message-Id:Date:Subject:From:To:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=9zVncHKUIPkDVkPbJsEtu6b6Dz3IJuqxvFEgfdutbFE=; b=KH9PLm81z97SNmsyz5tE7i4FpO
	dGVgn24a8+Yb3y1YQcE9Ic7N0ACuUJvIIWu5H8QPbrlITj1erpBvgGWCniBX1NZxFoSCx+Cbf2RIO
	i2r0L6z1NabV3u6QP24yfxDQEFYAv2f54I7D2Qcl1Bf8unFBEPoQy++4uFiJ7GrPD7PMQcgKgFnWe
	JcwN5lV9oUcvAhlQKjjSNMAIFCO4gfGpqS8ABgXKZ9198J9E4ooR6AfP9qyc8PMAP3/RNc47HY/7W
	xhf3BTgfDHlbjBF9zPlxIbvsx2cdYVEpqd0woVCSxjD+d+2lMnQcODzQUH8yB0DVmIpadWPXr6Ghi
	emdXBABQ==;
Received: from dak-unpriv by usper.debian.org with local (Exim 4.96)
	(envelope-from <ftpmaster@ftp-master.debian.org>)
	id 1vlaL9-002qpL-2n
	for linux-xfs@vger.kernel.org;
	Thu, 29 Jan 2026 22:18:15 +0000
To: linux-xfs@vger.kernel.org
From: Debian FTP Masters <ftpmaster@ftp-master.debian.org>
Subject: Processing of xfsprogs_6.18.0-3_source.changes
Date: Thu, 29 Jan 2026 22:18:15 +0000
X-Debian: DAK
X-DAK: DAK
Precedence: bulk
Auto-Submitted: auto-generated
X-Debian-Package: xfsprogs
Message-Id: <E1vlaL9-002qpL-2n@usper.debian.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[ftp-master.debian.org:s=smtpauto.usper];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_FROM(0.00)[bounces-30540-lists,linux-xfs=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	DKIM_TRACE(0.00)[ftp-master.debian.org:+];
	DMARC_NA(0.00)[debian.org];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_NONE(0.00)[];
	MISSING_XM_UA(0.00)[];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[linux-xfs];
	FROM_NEQ_ENVFROM(0.00)[ftpmaster@ftp-master.debian.org,linux-xfs@vger.kernel.org];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 5712BB53C6
X-Rspamd-Action: no action

xfsprogs_6.18.0-3_source.changes uploaded successfully to localhost
along with the files:
  xfsprogs_6.18.0-3.dsc
  xfsprogs_6.18.0-3.debian.tar.xz
  xfsprogs_6.18.0-3_source.buildinfo

Greetings,

	Your Debian queue daemon (running on host usper.debian.org)

