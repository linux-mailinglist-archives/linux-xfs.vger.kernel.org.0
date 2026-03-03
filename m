Return-Path: <linux-xfs+bounces-31776-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oMhIHOP0pmmgawAAu9opvQ
	(envelope-from <linux-xfs+bounces-31776-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Tue, 03 Mar 2026 15:49:07 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1248C1F1C58
	for <lists+linux-xfs@lfdr.de>; Tue, 03 Mar 2026 15:49:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 74A323012D22
	for <lists+linux-xfs@lfdr.de>; Tue,  3 Mar 2026 14:49:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7389835B64C;
	Tue,  3 Mar 2026 14:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="3XlnLOv7"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 764AE366DA4
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 14:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772549345; cv=none; b=ZXICN3L4pK6Idt9r/HFX6Rh2yiPgGeMM0TrRUBvPZmr5kvhwUXToPAwCfbGs6sf7DwnHEcHwcLqAg8AeXA95d5mAn49UlmWpxQy0ZWb6z4RT+oT1mIBbufL/h0UqpEDPso/dSYJY2nhNoYvervdCq8qlE379iwJbbziloBHZvG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772549345; c=relaxed/simple;
	bh=rS1/6mRsyemGBkcjvyFIqCOb96FXDu2avtFofNmE3Ew=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZnflB5tAU59qoa6UEMDtTPr/8xqgBu17dOQnj62shDP0NwSYJKLu51Xd8odtndzT1oUZcFZvo5w9q/vj7KxMlyw5/BaOOo3WmR5sejlR6kE70v2yT3Why+kH4/ONqU65QCRe1H3+QDN06uh8Zp3I13HL0Y9Cl4KTUEaL3sVOyFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=3XlnLOv7; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ABXkFTyVUjP9uxNMqoA1ahYS3OBwQ4e5TOlTewAjiAA=; b=3XlnLOv7ACuFoAOiTQpTLX/8Jw
	QIMpYaBlHjAzq339Kid0IsK/b9URXd3HXgQktzAcV99CAwfxzgvHdWJArnVLlFcuTocOkdfnL7C+W
	/QLPWs5oUTBHiY2FpsPAP1PRbbos64BmH0+YUGhDstVzyHbta6aoaA0h9d8F++2Vay7c2ud6/UnHi
	vvNxRhJdQUsDfV69X4iyOWKElBGcoMoAAkhVhuPgNkDuUQx9mj6Vv8wwnTwQm1XMprXtVn0XFLfB1
	zTx0p1DyL7QbpQN6InECtTroBQmYOyG2cM8cho3ymrCdM4JsibQnECGjdwQgW+YbcRNk0aaIa4uZH
	g7g8bYAQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vxR3X-0000000FMFW-433x;
	Tue, 03 Mar 2026 14:49:03 +0000
Date: Tue, 3 Mar 2026 06:49:03 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, cem@kernel.org, hch@lst.de,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 33/36] xfs: remove metafile inodes from the active inode
 stat
Message-ID: <aab03-37QcwSKu0u@infradead.org>
References: <177249637597.457970.8500158485809720053.stgit@frogsfrogsfrogs>
 <177249638385.457970.8057539261074430844.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177249638385.457970.8057539261074430844.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Queue-Id: 1248C1F1C58
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[infradead.org,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[infradead.org:s=bombadil.20210309];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-31776-lists,linux-xfs=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[infradead.org:dkim,infradead.org:mid]
X-Rspamd-Action: no action

On Mon, Mar 02, 2026 at 04:20:47PM -0800, Darrick J. Wong wrote:
> -#define XFS_STATS_DEC(mp, count, x)	do { (mp) = (mp); } while (0)
> +#define XFS_STATS_DEC(mp, count)	do { (mp) = (mp); } while (0)

Looks like XFS_STATS_DEC has been around for a while like this.  Maybe
split that fix out?


