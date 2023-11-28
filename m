Return-Path: <linux-xfs+bounces-177-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D5BAE7FBC21
	for <lists+linux-xfs@lfdr.de>; Tue, 28 Nov 2023 15:04:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 13D0A1C20CBE
	for <lists+linux-xfs@lfdr.de>; Tue, 28 Nov 2023 14:04:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C76E59B7E;
	Tue, 28 Nov 2023 14:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="n+IPD+Ex"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A36DC1
	for <linux-xfs@vger.kernel.org>; Tue, 28 Nov 2023 06:04:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=FLu3bvIPe0pxKDryK3CU0hm9bEVEQzVpJeGD+7M6KQ4=; b=n+IPD+Exg916jmQjVVKX/NAxml
	SZOpHkJtNsSXGsnNGlcIN62Od7weKeNsce4CcL3zxY2oju2p06qLyNo5QS1hpRTSMjuTpgC0Qt4rF
	5zhFXIfQdvG5AEyVuyN7Ep72UceaJXgVCQ6674D7KX3rjhkD3BrzES8pz/M326OoUfUdCTxsjBetY
	MGziN4L762FZ07Q6pM7kgC4mHp8cms3+G3ieVf8QjQq1KBrkkve2ERqvJ5/FSE/sVQ8OxS05+m1n+
	f3pabY+AsUELO60Tu3lIjShEOVqGDomWqRQdd4/dVlKQyVmznysLxJvdmdgo2Ui1mJA+ZgaKxq7qI
	iJ7Ue0yw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1r7yhO-005RJl-12;
	Tue, 28 Nov 2023 14:04:26 +0000
Date: Tue, 28 Nov 2023 06:04:26 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/6] xfs: check rt bitmap file geometry more thoroughly
Message-ID: <ZWXzaiaUDQYrT/5x@infradead.org>
References: <170086928333.2771542.10506226721850199807.stgit@frogsfrogsfrogs>
 <170086928361.2771542.12276270495680939208.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170086928361.2771542.12276270495680939208.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> +	/*
> +	 * Now that we've locked the rtbitmap, we can't race with growfsrt
> +	 * trying to expand the bitmap or change the size of the rt volume.
> +	 * Hence it is safe to compute and check the geometry values.
> +	 */
> +	rtb->rextents = xfs_rtb_to_rtx(mp, mp->m_sb.sb_rblocks);
> +	rtb->rextslog = rtb->rextents ? xfs_highbit32(rtb->rextents) : 0;
> +	rtb->rbmblocks = xfs_rtbitmap_blockcount(mp, rtb->rextents);

All these will be 0 if mp->m_sb.sb_rblocks, and rtb is zeroed allocation
right above, so calculating the values seems a bit odd.  Why not simply:

	if (mp->m_sb.sb_rblocks) {
		rtb->rextents = xfs_rtb_to_rtx(mp, mp->m_sb.sb_rblocks);
		rtb->rextslog = xfs_highbit32(rtb->rextents);
		rtb->rbmblocks = xfs_rtbitmap_blockcount(mp, rtb->rextents);
	}

?

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

