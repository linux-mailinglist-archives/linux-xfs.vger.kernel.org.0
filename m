Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C71A1680F3
	for <lists+linux-xfs@lfdr.de>; Fri, 21 Feb 2020 15:56:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728955AbgBUO4y (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 21 Feb 2020 09:56:54 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:57160 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728910AbgBUO4y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Feb 2020 09:56:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ntqVNAXNlT48qmHW7Lpar8yVV3M66KRbv5Sw+8QNf5M=; b=h8alSlrihQdP2EuW+pRBaQjVM/
        fzAL+I7IWbkP35SRQ0KPfzeQXUSGsd9zxWL4YVvh/Zt8jdP/d2fgphLqqr5U3ad5Ou0StpjMWhZI+
        aKbXI1MvuWf3b4LAErhCbtrQE34MZhUDDKGR6/gH4eIzOMAEfQKn6VpZy6K73UPz0KQLS/cf5c3QW
        KF4wCdA0YN8KsmlgXfosVKwdd44Klv+U4IgZwN4oLuncUECUrrwviYH3ml9NJHsyLQB6YVUpoliG2
        qrZ+x1yTlCshgOaT/gL0OO+N3z9jemF1lI2LBeUIYGc6ETi59zj1vvLtYC4gt4TiD0cOHINFh5rGe
        5BEMxsBw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j59jZ-0006Kn-EY; Fri, 21 Feb 2020 14:56:53 +0000
Date:   Fri, 21 Feb 2020 06:56:53 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/14] libxfs: make libxfs_getbuf_flags return an error
 code
Message-ID: <20200221145653.GR15358@infradead.org>
References: <158216306957.603628.16404096061228456718.stgit@magnolia>
 <158216308182.603628.4786904164891459161.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158216308182.603628.4786904164891459161.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 19, 2020 at 05:44:41PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Convert libxfs_getbuf_flags() to return numeric error codes like most
> everywhere else in xfsprogs.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
