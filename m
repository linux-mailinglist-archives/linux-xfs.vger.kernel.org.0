Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 947502106B9
	for <lists+linux-xfs@lfdr.de>; Wed,  1 Jul 2020 10:51:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728612AbgGAIvL (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 1 Jul 2020 04:51:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726009AbgGAIvK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Jul 2020 04:51:10 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D027C061755
        for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2020 01:51:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=prwKZVkIAhwgNxEUy9IkdqeZqm1WKmfDlEWwUacK1iI=; b=ih6obAQy84+N9cnH4ZtoiwlLIG
        KQs4nrxZSIdmKGu3X5B3y75U1Cof4Gljdqq1oumhNeieLxcHy1WQyy7wllQzNtlj3SH8RobipttF2
        ITeU/QN4dXX0xvaj5X1FqS0OwEGFKaG7S2BAa3rzFcTu/LGfDREFclsrKORHLHLS3gLZUIbZEOOGI
        HqrBGSEsLuj5PduVDXbBlK5tQH+WvHOyrah4aMl5dvgM5+gzIMBxP1ijFdmodT8A0LJZ8dIMXa9re
        oN0HXCPvr5AZey9dMzOLo+sQp79hXWdvuVHCQSimI3DSvXAo+hKcAGaqMuYqf+1mewoWNWyMwBg5i
        NTwVtkMg==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jqYSS-0007dC-TH; Wed, 01 Jul 2020 08:51:08 +0000
Date:   Wed, 1 Jul 2020 09:51:08 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/18] xfs: stop using q_core counters in the quota code
Message-ID: <20200701085108.GH25171@infradead.org>
References: <159353170983.2864738.16885438169173786208.stgit@magnolia>
 <159353176230.2864738.15493398497982706092.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159353176230.2864738.15493398497982706092.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 30, 2020 at 08:42:42AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add counter fields to the incore dquot, and use that instead of the ones
> in qcore.  This eliminates a bunch of endian conversions and will
> eventually allow us to remove qcore entirely.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
