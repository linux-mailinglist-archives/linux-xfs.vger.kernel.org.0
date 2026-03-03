Return-Path: <linux-xfs+bounces-31790-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eJmAEwgDp2k7bgAAu9opvQ
	(envelope-from <linux-xfs+bounces-31790-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Tue, 03 Mar 2026 16:49:28 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B9A21F2EBD
	for <lists+linux-xfs@lfdr.de>; Tue, 03 Mar 2026 16:49:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D25893035A9D
	for <lists+linux-xfs@lfdr.de>; Tue,  3 Mar 2026 15:45:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5C1437B039;
	Tue,  3 Mar 2026 15:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="HOv9V5Oh"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4A681891A9
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 15:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772552750; cv=none; b=smSDnD2Yrrc3wO9DjXgjCRFkdtEDl/yn8g5NAt6L5ZryCylmHO11Lmd6SkKVYuhB7oL+a5S/CT9mGOZIL2v0Nss+gQZqZVM6pCaL0HzlhMTzgP/64oD9SCdxOtHwM9daiO6gpZlv5MwzDTEqmNozjZPDViaNvDFviFcN+H1xdAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772552750; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B5kVe0w83NRLA/0wSnV35wQioLEbSI3hFkAGMcNSsusvkBbGtDJv9fwv54Sc9eof+YJv6Ayge4DEYT0RL8zVKilNb3VxhFy2e16PmJfyzshY/zdIyxCjFIXNHCF3LDxvQ+FUMXFKiR9HlHRmPhd7s5vC+VMgdK60YCuW5MWOaf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=HOv9V5Oh; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=HOv9V5Oh14D+D8bl+CzEiMUafn
	3JNO8pbSu3rVfLEFGwEa3U6oLMDpsRIHVAllxtKJZCxCbdi6LjxG78Q6+fE8d0yaRH6xv3+umYP8F
	+xsExQjH5H0PPg5yWU9CX2rGClgBB+dBdlkRdd0MZ+Lt0HCosnToNhzy2yAeI7kw8uMp1yPK+r1ae
	H5XeLBNtU4ZkEj4zi7IsV3LMN7/VyuG9iD8JMHKUqEpZbR979mEqHPK8tSdodGljR82uhBEe96SF4
	EWtnjajgvSbrb2yTGBw0nXwtvmlQLSuHqjgDs1Z4iCDk2xqVcBz7uwjIvhpJlt3qAAC7atLmxBLGB
	kBnP7hew==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vxRwT-0000000FS7L-1vNz;
	Tue, 03 Mar 2026 15:45:49 +0000
Date: Tue, 3 Mar 2026 07:45:49 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/26] libfrog: hoist a couple of service helper functions
Message-ID: <aacCLSRSGYnXKy__@infradead.org>
References: <177249783165.482027.209169366483011357.stgit@frogsfrogsfrogs>
 <177249783366.482027.6931104577818307338.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177249783366.482027.6931104577818307338.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Queue-Id: 9B9A21F2EBD
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[infradead.org,none];
	R_DKIM_ALLOW(-0.20)[infradead.org:s=bombadil.20210309];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-31790-lists,linux-xfs=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[infradead.org:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[hch@infradead.org,linux-xfs@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[4];
	MID_RHS_MATCH_FROM(0.00)[];
	SINGLE_SHORT_PART(0.00)[];
	TAGGED_RCPT(0.00)[linux-xfs];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[lst.de:email,infradead.org:dkim,infradead.org:mid,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

