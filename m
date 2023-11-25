Return-Path: <linux-xfs+bounces-88-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 19EA17F8890
	for <lists+linux-xfs@lfdr.de>; Sat, 25 Nov 2023 07:12:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A04F7B21319
	for <lists+linux-xfs@lfdr.de>; Sat, 25 Nov 2023 06:12:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 908954435;
	Sat, 25 Nov 2023 06:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Qp4uJVME"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B5501723
	for <linux-xfs@vger.kernel.org>; Fri, 24 Nov 2023 22:12:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ENdh52SjyVCrTMNCHKA0P/wmeR1+bEPuNBWZfxdYWKg=; b=Qp4uJVMEZv3OwKSh5wkrp5o1yZ
	9PuL3WVvqc9hIIKK+KkfOyvl5ABav9fwls11OFlIltg+GbVn1QLSOG35Q/SfNtsX+8iCufkiomCAy
	UzUaFmypzY6OYkF9VI8AXRR5Viyp9CjpYGNg8lTsmw75WI69GU7ZIRCXZrjf9pVR6HiXBWeAULwKm
	cOsiidUVtohaqyZnwbGlIYecJ87yymnrdMGdgW2Hq6wjAOrazQGjUMnRi6v1/MFFMSNfXdyiQOPG3
	XLJNYvBmGbFcaDAc1PYYpL/gu/0LkFhXOkWg6I1tpCxmuek8f3bnP9m93QmKhCiBmStxlYcu6vJzj
	ybN1DRFA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1r6luH-008f28-28;
	Sat, 25 Nov 2023 06:12:45 +0000
Date: Fri, 24 Nov 2023 22:12:45 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/5] xfs: repair inode btrees
Message-ID: <ZWGQXZckfk6KvocG@infradead.org>
References: <170086926983.2770967.13303859275299344660.stgit@frogsfrogsfrogs>
 <170086927060.2770967.9879944169477785031.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170086927060.2770967.9879944169477785031.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> +/* Simple checks for inode records. */
> +xfs_failaddr_t
> +xfs_inobt_check_irec(
> +	struct xfs_btree_cur			*cur,
> +	const struct xfs_inobt_rec_incore	*irec)
> +{
> +	return xfs_inobt_check_perag_irec(cur->bc_ag.pag, irec);
> +}

Same comment about just dropping the wrapper.  Otherwise I'll
need more digestion time for the new code.


