Return-Path: <linux-xfs+bounces-31092-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IO0FGuAQl2n7uAIAu9opvQ
	(envelope-from <linux-xfs+bounces-31092-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Thu, 19 Feb 2026 14:32:16 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id E773615F17C
	for <lists+linux-xfs@lfdr.de>; Thu, 19 Feb 2026 14:32:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2F758300DDE5
	for <lists+linux-xfs@lfdr.de>; Thu, 19 Feb 2026 13:32:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0674C253B42;
	Thu, 19 Feb 2026 13:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="1nAkXpi6"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D14727FB1E
	for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 13:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771507928; cv=none; b=rLBuXXp1vCKynY+GNDRh3wyq9UVcZTkjGEkE/iP9tfxpBFiAlDp/iY0zzJVvYDqLc2+90anG+QnfoQdFC3T206QonskiNrQryPJEQOnVB+zrw/5hWTDdeK3pazb7MHh8/loCUn84SO1Oh+tuHs33IdEWkj+1SqhhMLiQ8lU0TNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771507928; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iYDPye+pJYUdcsm3Grj9KlGOx5IfrP5EGIzfJPAzzJnfKXzqXVLo9Ye3i2KZfWucu9iiElTg04/XdKHKq6hLj1o6ilCHuLn29NNRtFyl9cglFV1bPySr/Xlij9gvGoScCTOkrFYHJ67nUYrX3MowZ5JNCTeF1eNBNvLKaBPCkm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=1nAkXpi6; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=1nAkXpi6+L1NYjiOoHdTM+uoBG
	reUDHSmTedfKtJz6dqmKlIbRvGuh45aJpw3AWQ11AA6y3AguX/ATAhCwyO26zhsn9AlHepKkrlkxq
	WdzZYNdMsh1rYGuJND6SdTzMtno1zwf2QO7z9HQ3mzkYYoItgR8VquUeZ6lAvfAD2ATYt0BODQoHN
	RrTjgOM+QCgLlTxhOlIGq4haJ32MUFX4b8TWfi90zpXPGmdkVWqYwnGpgPJDWWEodiIqw6RAt+YOz
	9mPlgibEKRaOo5VKBCa2LEGqdEFQFLA5bgUcTw5j7kDCSwwRws+PgaLkhhSLx+ssohYzSIuhV7CZ3
	MAFyLmMg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vt48R-0000000BPB8-01r5;
	Thu, 19 Feb 2026 13:32:03 +0000
Date: Thu, 19 Feb 2026 05:32:02 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Lukas Herbolt <lukas@herbolt.com>
Cc: hch@infradead.org, aalbersh@redhat.com, cem@kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/1] mkfs.xfs fix sunit size on 512e and 4kN disks.
Message-ID: <aZcQ0oULFZv3CYNx@infradead.org>
References: <20260219114405.31521-3-lukas@herbolt.com>
 <20260219114405.31521-6-lukas@herbolt.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260219114405.31521-6-lukas@herbolt.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[infradead.org,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[infradead.org:s=bombadil.20210309];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-31092-lists,linux-xfs=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[infradead.org:+];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[hch@infradead.org,linux-xfs@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[linux-xfs];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,infradead.org:mid,infradead.org:dkim,lst.de:email]
X-Rspamd-Queue-Id: E773615F17C
X-Rspamd-Action: no action

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


