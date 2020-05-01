Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CF751C10C0
	for <lists+linux-xfs@lfdr.de>; Fri,  1 May 2020 12:19:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728268AbgEAKTs (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 1 May 2020 06:19:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728119AbgEAKTr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 May 2020 06:19:47 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A05EEC08E859
        for <linux-xfs@vger.kernel.org>; Fri,  1 May 2020 03:19:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=tVXSpdQP5IhfxOp1Ii35E5nWdsV3CUbyrs1Fqr5N0bE=; b=Bx7ECiFvJ14YycVD1W6ijDlLZt
        zc4SSH5XcPXNQuAaMKQMikeZOt2Qr8pkjU8nkJgtHiJw4FZMgIP+HpVKkbpxYP9qNijEg1dnV5Bnv
        zUlHbVG9MHzhYiKTPMZOecnnuPnDcJlQYb9J8SGxDmuhrTRM4JhFuP8iNhebBrMqI/dkL2Uj4769p
        KKGb3cXi/402dNn5dFQd3GhN4gdxU13wOjyCbKoL+EJtpH0Z3JWH7xV3OGK1xfg7LIv5W/LJM+1vF
        gypyyL9THGLA8TMO1ZpGlA51KFf93spf+XnkA9K5KGVsHJmOCwyfCN/eCy4sH8EXSXOP5y6vykrP5
        6NidGZNg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jUSln-0000YT-Dm; Fri, 01 May 2020 10:19:47 +0000
Date:   Fri, 1 May 2020 03:19:47 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/21] xfs: refactor recovered EFI log item playback
Message-ID: <20200501101947.GA1201@infradead.org>
References: <158820765488.467894.15408191148091671053.stgit@magnolia>
 <158820773902.467894.5745757511104582380.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158820773902.467894.5745757511104582380.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 29, 2020 at 05:48:59PM -0700, Darrick J. Wong wrote:
> +STATIC int xfs_efi_recover(struct xfs_mount *mp, struct xfs_efi_log_item *efip);

Can you just move xfs_efi_item_ops down a bit to avoid the forward
declaration?  Same for the other patches doing the same.
