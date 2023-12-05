Return-Path: <linux-xfs+bounces-436-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E3458048AC
	for <lists+linux-xfs@lfdr.de>; Tue,  5 Dec 2023 05:38:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5CE7E1C20DB5
	for <lists+linux-xfs@lfdr.de>; Tue,  5 Dec 2023 04:38:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA3D7802;
	Tue,  5 Dec 2023 04:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="bnTKgo8t"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01531A9
	for <linux-xfs@vger.kernel.org>; Mon,  4 Dec 2023 20:38:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=5RyCADam5no5NOrw5GTAcqGx4KlXDDaAjkXP/8BRmrA=; b=bnTKgo8tbxvxkgwa+NTimsJOlv
	oSEpXmfbwTxm+lSWi8h6lYRU8y3fN2A7y10rNJUvsCfEIyklJaPCLezcwjD18O/2z42NJT8A+K0uK
	yktjVZaYCt59ZYgEuOh7QAlsW9drluBR8yVaTE5LYreTLrms6fl1J2oIcScSDxsstTV0d9VogaP6s
	NBdUH1r1D3gzB2Ayz763rAbau9WiL6Yj2TE87d55o1c/MCwtM06E56sUoSyhz2Nt9zPp7jhgscaLz
	I0GdpeVOt9SG4baA7V+JdPmAv13yaZUTIDaQZEW2mq9mQj+WDRaCuYR/8d0Nlr2jNJKHhi04z2CGn
	+Gs0fMPA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rANCC-006EnO-37;
	Tue, 05 Dec 2023 04:38:08 +0000
Date: Mon, 4 Dec 2023 20:38:08 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Long Li <leo.lilong@huawei.com>
Cc: djwong@kernel.org, chandanbabu@kernel.org, linux-xfs@vger.kernel.org,
	yi.zhang@huawei.com, houtao1@huawei.com, yangerkun@huawei.com
Subject: Re: [PATCH 2/2] xfs: fix perag leak when growfs fails
Message-ID: <ZW6pMHNK/tUxsbuM@infradead.org>
References: <20231204043911.1273667-1-leo.lilong@huawei.com>
 <20231204043911.1273667-2-leo.lilong@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231204043911.1273667-2-leo.lilong@huawei.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> +void
> +xfs_destroy_perag(
> +	xfs_mount_t		*mp,
> +	xfs_agnumber_t		agstart,
> +	xfs_agnumber_t		agend)

Not sure xfs_destroy_perag is the right name, as it frees a range of
AGs, how about xfs_free_unuses_perag_range?

Also a comment explaining that this must never be used for AGs that
have been visible (that is included in mp->m_sb.sb_agcount) would
probably be useful.


