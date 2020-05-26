Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A1A41C7415
	for <lists+linux-xfs@lfdr.de>; Wed,  6 May 2020 17:18:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729066AbgEFPSk (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 6 May 2020 11:18:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729003AbgEFPSk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 May 2020 11:18:40 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5070DC061A0F
        for <linux-xfs@vger.kernel.org>; Wed,  6 May 2020 08:18:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=8QtZZRvbGQEHzp8NgbGunFc8uunHnAqVZEcZldykSIQ=; b=HipQeufv/QpG4ho4J1E6YXCG3a
        KtjDZHIzktRkErHzTFDyuC1vQyxMjwIYnVBvHG8DEw4ztzvX2jAVgjb22Zfks4TSs93ocyxfGwYxy
        dOfVRShvB6KfN/Fxoj1G6JKlki3IgQq8JmKWKTnqj59qil69a2/38d1DEf+QGa0bvKMXQSD+7SP1n
        sCWZ9pEPcstRdDQgDptW/8ta4clxBgDV3JhD/U9DXJomXNuLex5b02760/Mee3xZ/mfnJzabZccfH
        sd5dyYtBhSPsrTKB/OSmV79KzxW6V37BQ9jzPfYfNWv6kYHPt54fHWHUa7BABncEY0p0yusgRF2rV
        eypiX5aA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWLom-0007NT-35; Wed, 06 May 2020 15:18:40 +0000
Date:   Wed, 6 May 2020 08:18:40 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 15/28] xfs: refactor recovered RUI log item playback
Message-ID: <20200506151840.GS7864@infradead.org>
References: <158864103195.182683.2056162574447133617.stgit@magnolia>
 <158864112778.182683.3049865779495487697.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158864112778.182683.3049865779495487697.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 04, 2020 at 06:12:07PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Move the code that processes the log items created from the recovered
> log items into the per-item source code files and use dispatch functions
> to call them.  No functional changes.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
