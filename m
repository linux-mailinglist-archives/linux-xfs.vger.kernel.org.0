Return-Path: <linux-xfs+bounces-31803-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8B5dNIQEp2k7bgAAu9opvQ
	(envelope-from <linux-xfs+bounces-31803-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Tue, 03 Mar 2026 16:55:48 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7733E1F30C3
	for <lists+linux-xfs@lfdr.de>; Tue, 03 Mar 2026 16:55:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 33B8030C10C9
	for <lists+linux-xfs@lfdr.de>; Tue,  3 Mar 2026 15:51:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8050C492196;
	Tue,  3 Mar 2026 15:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="IY5gGmJm"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72C943CF68F
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 15:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772553106; cv=none; b=tXMWCq1x0kWD3B18kAlgHWeYxNAhfJq4wfJ3OT8J1v8rsB/m6Xoe0qEEr7zTW8OMUiGbq7GA5pPzNZ9wW90pxYEH7YeXuOiPbyqUWVsfq3RwGn/yKMcpcjbkTr4C5B4QDsG+ERZxs8J6tSFd5GblnAkCp9JbAaQHd2Wz60fiC6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772553106; c=relaxed/simple;
	bh=Lu1e/gcNikUoT4/y1a8UINoKbO4p43zNgadblmqSP8A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GOCu64TR5tvNxuKfoPkoA71A4Rwz5OL4mvZHi66860RZAsjzL/gVKtnx9NI0rWkcL7NdzKQ5m7M4gb69iZuP2N0DPSATkx4I1HKSSSy2iKipV+yq4X1UXjmcFYenUKFx0QngDtWuwXZnxfUhpr/adgBEPyxSkBKlvyRx/zpEocE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=IY5gGmJm; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Lu1e/gcNikUoT4/y1a8UINoKbO4p43zNgadblmqSP8A=; b=IY5gGmJmu5JS6qCV7Lr0IkQQ5u
	wRCwIfuH55u9XyAiIiP5WG6jzqE2MY9xS08dj5tu7fEJza3wMS1+HaVDxDx/6swsRjSGcVMT/9ZBD
	WKI+cKwgsUhNyzYDHAcIvjFjq6VpC/O3Tcc9/Ui4hYYNoVGP5i/7fXWyqHZ3f4zX3iTkJUQWhq7sI
	8XFmS/oXeKakh3UF1EgNNPNBuSFHPMpHOHKC8TzJmStSXEnauxq/1DVcnW+WLHHjUwa8XmLr7cGuC
	nmB9v8ffkZwq9Mao85JjcdzaAwxKbLZBdEBflzE3JWnsaOKyo/ZjMNHZZtpzqibeyTFlUyZMLSs2A
	fRTpaiMA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vxS2D-0000000FTDg-0NT7;
	Tue, 03 Mar 2026 15:51:45 +0000
Date: Tue, 3 Mar 2026 07:51:45 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 17/26] xfs_healer: use getmntent to find moved filesystems
Message-ID: <aacDkSiRLgD1k3Tg@infradead.org>
References: <177249783165.482027.209169366483011357.stgit@frogsfrogsfrogs>
 <177249783601.482027.9121579371607325115.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177249783601.482027.9121579371607325115.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Queue-Id: 7733E1F30C3
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[infradead.org,none];
	R_DKIM_ALLOW(-0.20)[infradead.org:s=bombadil.20210309];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[infradead.org:+];
	TAGGED_FROM(0.00)[bounces-31803-lists,linux-xfs=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[hch@infradead.org,linux-xfs@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[linux-xfs];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[lst.de:email,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,infradead.org:dkim,infradead.org:mid]
X-Rspamd-Action: no action

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

but in a way just grabing a weak handle at mount time and never
dropping it would seem more useful?

