Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C1A4129EFD
	for <lists+linux-xfs@lfdr.de>; Tue, 24 Dec 2019 09:31:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726224AbfLXIbp (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 24 Dec 2019 03:31:45 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:35348 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726091AbfLXIbp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Dec 2019 03:31:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=7yYWpFStKE9s43Ma4Tyd6re13UZsEHjn1Ywes5sJtmo=; b=kHrF+IXiCLatB61Xl9nTz54oY
        GChpALTh27VdWWsVVsVSVun79tSy55KwyGNFJg9oqFAk03Sko90AIijdTOMaumVEOkYm8BPyM94Mg
        Bxtn5I9u55o/VY0ZaH3QbohFESJNqZtr/05YTipzBvA8U3kWWX8K4cYCQ7OTFoRVjKFipv4FEU8TM
        csfFa4iRHFxINXFDcbAiDyjJQQPOo5pkxALr+xcJSGgi4M2LknuMg/Pa1UMJSzhH4ArO6l3FvjwZ0
        1YrCuIPm+uCfujGd6++bwI6IsgKpcvxT587/dC5FwE2QBg/kiKNVKVRe61wpaC7vFACuupd1hTPzT
        sFTui0c3w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ijfbU-0007E6-Pr; Tue, 24 Dec 2019 08:31:44 +0000
Date:   Tue, 24 Dec 2019 00:31:44 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com, david@fromorbit.com,
        alex@zadara.com
Subject: Re: [PATCH 1/3] xfs: refactor agfl length computation function
Message-ID: <20191224083144.GB20650@infradead.org>
References: <157669784202.117895.9984764081860081830.stgit@magnolia>
 <157669784878.117895.2399564206474502745.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157669784878.117895.2399564206474502745.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> +/*
> + * Compute the minimum length of the AGFL in the given AG.  If @pag is NULL,
> + * return the largest possible minimum length.
> + */
>  unsigned int
>  xfs_alloc_min_freelist(
>  	struct xfs_mount	*mp,
>  	struct xfs_perag	*pag)
>  {
> +	/* AG btrees have at least 1 level. */
> +	static const uint8_t	fake_levels[XFS_BTNUM_AGF] = {1, 1, 1};
> +	const uint8_t		*levels = pag ? pag->pagf_levels : fake_levels;
>  	unsigned int		min_free;

Yikes.  This is just the nastiest calling convention possible.  Why
not factor out a xfs_alloc_min_freelist_levels helpers that gets the
levels pointer passed, and we get something much saner.
