Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5EAB1C73B2
	for <lists+linux-xfs@lfdr.de>; Wed,  6 May 2020 17:13:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728784AbgEFPNl (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 6 May 2020 11:13:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728428AbgEFPNl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 May 2020 11:13:41 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B35DC061A0F
        for <linux-xfs@vger.kernel.org>; Wed,  6 May 2020 08:13:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=QrObTFSHytPVZKe//NiEnT4WK/PH1Yku7P9SPX4mA4Y=; b=NUDa+ftxaqk2ATI45bqA92CMz3
        8zPosfDbEQ/VbioiTHHM+u5mDLgTT0n2spp1mBJbuTbQOGSXCauxalHp0naFQT+/B3NyYx1633oqQ
        5qZaUWzxAi2zjCSJr6EXHUBV8Tf1FV1muS2X5lHSX+XQG7PGuRpTiUidJrrsCKz1sstgxvzP2BePI
        xYRRW8SZg/N1H+6APZvamLUIrWNgTesEA7Ex2eGRPXx+LXTiPyjFdlhBILKZk/Snm6r9mAMZke05S
        MjnMhMuV/NaumfBWi9ZTjwmmnSlZSkx3v374r4MimJHaMBkuyrwwSZfxV4KshuS2sZYl/PTyNQIdu
        2GoXTMaw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWLjx-0008Mk-3t; Wed, 06 May 2020 15:13:41 +0000
Date:   Wed, 6 May 2020 08:13:41 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/28] xfs: refactor log recovery CUI item dispatch for
 pass2 commit functions
Message-ID: <20200506151341.GO7864@infradead.org>
References: <158864103195.182683.2056162574447133617.stgit@magnolia>
 <158864110138.182683.14407149575371476288.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158864110138.182683.14407149575371476288.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 04, 2020 at 06:11:41PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Move the refcount update intent and intent-done pass2 commit code into
> the per-item source code files and use dispatch functions to call them.
> We do these one at a time because there's a lot of code to move.  No
> functional changes.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
