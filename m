Return-Path: <linux-xfs+bounces-241-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C0017FCECE
	for <lists+linux-xfs@lfdr.de>; Wed, 29 Nov 2023 07:05:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9BDB42831DF
	for <lists+linux-xfs@lfdr.de>; Wed, 29 Nov 2023 06:05:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C7A3D2EB;
	Wed, 29 Nov 2023 06:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="xUvCAezx"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B4331BD4
	for <linux-xfs@vger.kernel.org>; Tue, 28 Nov 2023 22:05:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=k+A7vOLRtdtM4rVLO1dJaB24zAQLC2LhPkTQvn1Am8w=; b=xUvCAezxyZnmPVqvAPMdPV5541
	SFo9UvI6S3Q/vlIRRK3Gtbly2sM+znlQBGCe69lLMWpk5pwp+smGUM+JhP19B2gY27i/7HsenhcAD
	u2XguJq4tIvyiMDmKM9GsI+ig4YEc6sxdmWw+XI/GBOC7qAJ7DMAVgFYsrsIcKA6vQWjqTVu9p7/V
	ZYcIgdxHJ/LP1v622UtxbMDPtWS89b7rTUfUnQB7bIioyluIxTzOJcvFxqUhC/fyKOhl4nXXbNDMD
	nWxc8eWNoMU+y/tgaJTFixEIJfLoPWIMyAalsA+hhR4qjcGpwKqoCLeiCbLM005Wp62cv7nL4/8xA
	/NmrTPQw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1r8Dh4-007Ax3-2E;
	Wed, 29 Nov 2023 06:05:06 +0000
Date: Tue, 28 Nov 2023 22:05:06 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/6] xfs: check rt bitmap file geometry more thoroughly
Message-ID: <ZWbUkgEfsjP4xNTI@infradead.org>
References: <170086928333.2771542.10506226721850199807.stgit@frogsfrogsfrogs>
 <170086928361.2771542.12276270495680939208.stgit@frogsfrogsfrogs>
 <ZWXzaiaUDQYrT/5x@infradead.org>
 <20231128232740.GE4167244@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231128232740.GE4167244@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Nov 28, 2023 at 03:27:40PM -0800, Darrick J. Wong wrote:
> > All these will be 0 if mp->m_sb.sb_rblocks, and rtb is zeroed allocation
> > right above, so calculating the values seems a bit odd.  Why not simply:
> > 
> > 	if (mp->m_sb.sb_rblocks) {
> > 		rtb->rextents = xfs_rtb_to_rtx(mp, mp->m_sb.sb_rblocks);
> > 		rtb->rextslog = xfs_highbit32(rtb->rextents);
> 
> Well... xfs_highbit32 returns -1 if its argument is zero, which is
> possible for the nasty edge case of (say) a 64k block device and a
> realtime extent size of 1MB, which results in rblocks > 0 and
> rextents == 0.

Eww.  How do we even allow creating a mounting that?  Such a
configuration doesn't make any sense.

