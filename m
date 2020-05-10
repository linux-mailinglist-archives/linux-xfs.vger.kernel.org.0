Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 961F01CC79B
	for <lists+linux-xfs@lfdr.de>; Sun, 10 May 2020 09:26:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726906AbgEJH0U (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 10 May 2020 03:26:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725810AbgEJH0U (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 May 2020 03:26:20 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87CA4C061A0C
        for <linux-xfs@vger.kernel.org>; Sun, 10 May 2020 00:26:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=zPQUYjJowmGkn8Pm2OhqDGchUnKxiSMrjXfD9RwZkf0=; b=I0+14tdUzg0LpLGEI1wAcTb/bg
        hUZymBI9bgNJB3s6aSkvBXmJAxT0CeVFUJf196usq9ibBSs17okm4/xI/0KFwvTNdyjapqFhJudp3
        uGEBFgy051Vhbr4LVZIkFE8eX/peVPEU435RECAE5QPTors1H0LGI5YFAU5aiApWRFRE9IufUKfy/
        fLl1jBRDOaglX1GkJSQnixzUGQkah8bFAlfykHelNF4ae+K3uxF2+WPdI2yPBz5P/nGMfu8X9tiGJ
        Xwai1g+KozJnfRobKk0fwylB88UKog+wCG8CmI9h7cbWRCql4VcfFXyioO8hYiIU7sw+Ku9d8y6EY
        H0A7fVxg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jXgLr-0007RE-R5; Sun, 10 May 2020 07:26:19 +0000
Date:   Sun, 10 May 2020 00:26:19 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/16] xfs_repair: mark entire free space btree record as
 free1
Message-ID: <20200510072619.GD8939@infradead.org>
References: <158904179213.982941.9666913277909349291.stgit@magnolia>
 <158904188022.982941.11510270346760102443.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158904188022.982941.11510270346760102443.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, May 09, 2020 at 09:31:20AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In scan_allocbt, we iterate each free space btree record (of both bnobt
> and cntbt) in the hopes of pushing all the free space from UNKNOWN to
> FREE1 to FREE.  Unfortunately, the first time we see a free space record
> we only set the first block of that record to FREE1, which means that
> the second time we see the record, the first block will get set to FREE,
> but the rest of the free space will only make it to FREE1.  This is
> incorrect state, so we need to fix that.

That sounds pretty bad..

The fix looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
