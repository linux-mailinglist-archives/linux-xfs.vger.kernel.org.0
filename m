Return-Path: <linux-xfs+bounces-30833-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MN7fDBJJk2mi3AEAu9opvQ
	(envelope-from <linux-xfs+bounces-30833-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Mon, 16 Feb 2026 17:42:58 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B531B1464CF
	for <lists+linux-xfs@lfdr.de>; Mon, 16 Feb 2026 17:42:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2CC9D300BDBA
	for <lists+linux-xfs@lfdr.de>; Mon, 16 Feb 2026 16:42:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B957D292B2E;
	Mon, 16 Feb 2026 16:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VJDIpyr+"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 959702DB7BA;
	Mon, 16 Feb 2026 16:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771260150; cv=none; b=UNKoeW4+a40VIZpE3uyIVPpK7xUaqj1JA039s+nXVfYk4QMG3bK0IGcb6q1YVM9XH9/VlExym8q50F/Z2UK/rlhTGB5l6gug5boBc+NT8KOvV9pwSOETYRMn6DKzjj+HKlptxEM5A0GiAaSzSEG/MPBbanBln7/9TtagKezrx5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771260150; c=relaxed/simple;
	bh=zoY67iG/FSuUAT7p8OYsF9jSb6we351Qlbk9CJpfhqQ=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=gJjx2gGylqZDYRhl2jyMXSKS35rRy9p4WkwiNLy3mPgDhfkcHLpMhfERFtztT5WKJIdL7yw9QmdPSzEb2AapK0mg7Mz912B23kAlOETZD3AcAkotM85S89AxvDxpSTn5/qe4DW6jsYSNSqCSBIuMNIJnm14BFBBDRnok711ISdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VJDIpyr+; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF313C116C6;
	Mon, 16 Feb 2026 16:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771260150;
	bh=zoY67iG/FSuUAT7p8OYsF9jSb6we351Qlbk9CJpfhqQ=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=VJDIpyr+zMwrU7qlf3W4sDZAW/QHbGzudVlRVyOhQZJTCEX0+lAcePx7rypm8a3ee
	 l5fyUBDmzjv82COtS+S123W7MtlKhG6kegcauMxEn661JATsPZog7P9t2X0a+Rai0T
	 SUMGY9nD94RqXW1sXiUFJ7cSmm7mBzMyeSNa1BnO6MsEgcQkLPlzjchEvLyd/43/i4
	 JWbxuj6PNImbac8BQKTBTXYxN9gpHUl5l134DSfy90lom56PqgD7z8os2OckEfvnsu
	 UjBxpkstxjPzZ9qmWkwLmIyefPV7zetSAaEGsWPONthh9Kj3sN4kYTcoQXTxWSpqHs
	 9clkEr9fmf35g==
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J . Wong" <djwong@kernel.org>, 
 Wilfred Mallawa <wilfred.opensource@gmail.com>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Christoph Hellwig <hch@lst.de>, Wilfred Mallawa <wilfred.mallawa@wdc.com>
In-Reply-To: <20260212225005.732651-2-wilfred.opensource@gmail.com>
References: <20260212225005.732651-2-wilfred.opensource@gmail.com>
Subject: Re: [PATCH v2] xfs: fix code alignment issues in xfs_ondisk.c
Message-Id: <177126014862.263147.10407228739121431012.b4-ty@kernel.org>
Date: Mon, 16 Feb 2026 17:42:28 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-30833-lists,linux-xfs=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_TO(0.00)[kernel.org,gmail.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[cem@kernel.org,linux-xfs@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-xfs];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: B531B1464CF
X-Rspamd-Action: no action

On Fri, 13 Feb 2026 08:50:06 +1000, Wilfred Mallawa wrote:
> Fixup some code alignment issues in xfs_ondisk.c
> 
> 

Applied to for-next, thanks!

[1/1] xfs: fix code alignment issues in xfs_ondisk.c
      commit: e920893f56ef5f3d1f480c26966ac113e917bc63

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>


