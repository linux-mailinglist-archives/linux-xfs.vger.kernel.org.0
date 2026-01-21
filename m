Return-Path: <linux-xfs+bounces-30056-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qAF5LTHGcGkNZwAAu9opvQ
	(envelope-from <linux-xfs+bounces-30056-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Wed, 21 Jan 2026 13:27:29 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C12656BFA
	for <lists+linux-xfs@lfdr.de>; Wed, 21 Jan 2026 13:27:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id C32874652E4
	for <lists+linux-xfs@lfdr.de>; Wed, 21 Jan 2026 12:24:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AC1B478848;
	Wed, 21 Jan 2026 12:24:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f3mqyqps"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 062A042048
	for <linux-xfs@vger.kernel.org>; Wed, 21 Jan 2026 12:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768998277; cv=none; b=SoRhMgTIucIF+5vmpL598eqqE28ELBpOohpY2M0PrfMN3nPJWY5aHIMWmmOUwiwwoSNpNdn72lYvM8KzmOaAdGVZohzZn863K5MTMLajeqCqWcMUYu3j71sLmsD51zyGbYmaFEOnB2V/uYNz2s3ECT5fi3wg9JoweRbSzJ/Ovw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768998277; c=relaxed/simple;
	bh=xeCGpho21PAnheJB+fWbv4rXVJMYwI5kaFZcO+748pg=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=b0zIQoiIVeGOGmxbeq+DqEnsx+bYzSFuiSIDio3kyPLPuSUzXBG2dShFAiEpoW5IVchzcZcLVzSCRsd6gZM5X57sP7qxK/WEir6r9O/Ue1KVK+7sjXqlHGDfnM36nUSvMWxbvTaLzMZYTg2PrmlxMbFgwKCbbXaOOMrjnlalbdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f3mqyqps; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D07AAC116D0;
	Wed, 21 Jan 2026 12:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768998276;
	bh=xeCGpho21PAnheJB+fWbv4rXVJMYwI5kaFZcO+748pg=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=f3mqyqpsb1qQr2uYHfBGFVJAg31OFBHKX0/if2yvPhIRD8cI+kCA7DlC/B8l9fC7M
	 yySU/mkCjz4xZKOsWcrEF0tKTEgjWTzJOur3EVZpkbbPbYbK/EuJE451o4SCJ562e2
	 3g5hwdKNE9WCjv07QRCERhgE/RnzpOnDSx7Z7it2vje4qa+5+qegHm/J6poQ3omtcS
	 h5v43K7Cin+uT/6ktstOJcONxsQmeKMcnwqN+rF+a50WayNYdgSJEyQfLLSk/QqMRl
	 0wLcTVWgFh0xCl+Fn2G+1aoYvvmVHCX2CFbhgYs9wFi1ZIr+setAkmt6pDw7U0F3Lq
	 AHZWhUyXSRosw==
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org, Hans Holmberg <hans.holmberg@wdc.com>
Cc: Dave Chinner <david@fromorbit.com>, 
 "Darrick J . Wong" <djwong@kernel.org>, Christoph Hellwig <hch@lst.de>, 
 dlemoal@kernel.org, johannes.thumshirn@wdc.com
In-Reply-To: <20260120085746.29980-1-hans.holmberg@wdc.com>
References: <20260120085746.29980-1-hans.holmberg@wdc.com>
Subject: Re: [PATCH] xfs: always allocate the free zone with the lowest
 index
Message-Id: <176899827456.852996.335962182196285347.b4-ty@kernel.org>
Date: Wed, 21 Jan 2026 13:24:34 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2
X-Spamd-Result: default: False [-1.96 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	DMARC_POLICY_ALLOW(0.00)[kernel.org,quarantine];
	TAGGED_FROM(0.00)[bounces-30056-lists,linux-xfs=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:7979, ipnet:213.196.21.0/24, country:US];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[cem@kernel.org,linux-xfs@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	RCPT_COUNT_SEVEN(0.00)[7];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[linux-xfs];
	DBL_BLOCKED_OPENRESOLVER(0.00)[ams.mirrors.kernel.org:rdns,ams.mirrors.kernel.org:helo]
X-Rspamd-Queue-Id: 9C12656BFA
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Tue, 20 Jan 2026 09:57:46 +0100, Hans Holmberg wrote:
> Zones in the beginning of the address space are typically mapped to
> higer bandwidth tracks on HDDs than those at the end of the address
> space. So, in stead of allocating zones "round robin" across the whole
> address space, always allocate the zone with the lowest index.
> 
> This increases average write bandwidth for overwrite workloads
> when less than the full capacity is being used. At ~50% utilization
> this improves bandwidth for a random file overwrite benchmark
> with 128MiB files and 256MiB zone capacity by 30%.
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: always allocate the free zone with the lowest index
      commit: 01a28961549ac9c387ccd5eb00d58be1d8c2794b

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>


