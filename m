Return-Path: <linux-xfs+bounces-30272-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mJM5NmrAdGnU9QAAu9opvQ
	(envelope-from <linux-xfs+bounces-30272-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Sat, 24 Jan 2026 13:51:54 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 382EE7DA70
	for <lists+linux-xfs@lfdr.de>; Sat, 24 Jan 2026 13:51:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D5F6C300B9E0
	for <lists+linux-xfs@lfdr.de>; Sat, 24 Jan 2026 12:51:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E314318132;
	Sat, 24 Jan 2026 12:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b="pWgoBBft"
X-Original-To: linux-xfs@vger.kernel.org
Received: from mitropoulos.debian.org (mitropoulos.debian.org [194.177.211.212])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB3B12EDD4D
	for <linux-xfs@vger.kernel.org>; Sat, 24 Jan 2026 12:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=194.177.211.212
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769259108; cv=none; b=o5HLIW0sCZBBACjW74HBI5b7ANFMiMacAFPbgPrgZuCLty/NedXXyjVk6InLQEMbRjPWD9gEnOWgkx5Gy5xvtPjYDT5fegJmOkeI0L49YcgZ3bQNk4vDB21aWdm2wkIye/dhMObp9goNA9fFWIRHdQvd+3yLS8FEzkHlTrU1nYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769259108; c=relaxed/simple;
	bh=pu6B9H48BqpVoAZ4TR2JMZr39zs6x4/c5Y47A37uKkg=;
	h=To:From:Subject:Date:Message-Id; b=NnT+FCWggQclGR7dX+0IoElXey9Dy+asncvUn+zC1OP0R+32I17gYuY4YlJ52fs1ZutHm2N4mdiVYt3226fHJnejaHYpp4gJm9q12BSnZa67GIZwJb27CWmQQeWAph2XfXqLV6yiLMr47lo+JYjcuZYy6rPgiXuGIjAJ6wPB1ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ftp-master.debian.org; spf=none smtp.mailfrom=ftp-master.debian.org; dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b=pWgoBBft; arc=none smtp.client-ip=194.177.211.212
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp-master.debian.org
Received: from usper.debian.org ([2603:400a:ffff:bb8::801f:45]:40646)
	from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=usper.debian.org,EMAIL=hostmaster@usper.debian.org (verified)
	by mitropoulos.debian.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <ftpmaster@ftp-master.debian.org>)
	id 1vjd74-00GUm8-0f
	for linux-xfs@vger.kernel.org;
	Sat, 24 Jan 2026 12:51:38 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=ftp-master.debian.org; s=smtpauto.usper; h=Message-Id:Date:Subject:From:To:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=FZujb2DPfwTvWri0PdToLiC4H1kE9X00srCwOMNXtuM=; b=pWgoBBft+IT4MU0LHMbwu9JdWh
	Gl8itx5rn11YDDTLLzRGTX3k6hceBqjNf/vqgIX8w95p+vxb42IVkTwNiQgQwwUvcosM3hRpHrZJl
	YpSZ7nEuTpneSNEzGFNd+ZUV1RJeF8/j6KGk6hnIDiwLzxcA5alWkq155AJ5ylmvX8IUkZreIrVLG
	VYD0UI1h8HEtXCU8WGCO6iMpWSHU8aklGWkGh9l0FSXHjJ4zt1SmEa26OL58vsWMnFhL4e8rwdlIl
	V/kk/hXBUpa/SYhYv0J/9MWV47K7wFzDM1kZvZgzzRQQE7wpBUNpBgKIwZTLkRdNpMfO6FDkAEEuS
	YnS/8mDQ==;
Received: from dak-unpriv by usper.debian.org with local (Exim 4.96)
	(envelope-from <ftpmaster@ftp-master.debian.org>)
	id 1vjd73-00EpYB-03
	for linux-xfs@vger.kernel.org;
	Sat, 24 Jan 2026 12:51:37 +0000
To: linux-xfs@vger.kernel.org
From: Debian FTP Masters <ftpmaster@ftp-master.debian.org>
Subject: Processing of xfsprogs_6.18.0-1_source.changes
Date: Sat, 24 Jan 2026 12:51:36 +0000
X-Debian: DAK
X-DAK: DAK
Precedence: bulk
Auto-Submitted: auto-generated
X-Debian-Package: xfsprogs
Message-Id: <E1vjd73-00EpYB-03@usper.debian.org>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_FROM(0.00)[bounces-30272-lists,linux-xfs=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	DKIM_TRACE(0.00)[ftp-master.debian.org:+];
	DMARC_NA(0.00)[debian.org];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_NONE(0.00)[];
	MISSING_XM_UA(0.00)[];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[linux-xfs];
	FROM_NEQ_ENVFROM(0.00)[ftpmaster@ftp-master.debian.org,linux-xfs@vger.kernel.org];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 382EE7DA70
X-Rspamd-Action: no action

xfsprogs_6.18.0-1_source.changes uploaded successfully to localhost
along with the files:
  xfsprogs_6.18.0-1.dsc
  xfsprogs_6.18.0.orig.tar.xz
  xfsprogs_6.18.0-1.debian.tar.xz
  xfsprogs_6.18.0-1_source.buildinfo

Greetings,

	Your Debian queue daemon (running on host usper.debian.org)

