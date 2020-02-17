Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2B0E1613A6
	for <lists+linux-xfs@lfdr.de>; Mon, 17 Feb 2020 14:37:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726750AbgBQNhJ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 17 Feb 2020 08:37:09 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:48170 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726492AbgBQNhJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Feb 2020 08:37:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=myBs8RbtaFGX+oaeM90EvAlHIvIjCLH671keQ0KvdHo=; b=I/yzgb3zWGa9BawJe1QeMT0m32
        +oz76+yqZ1Bl0OtP90FEabTCvUQKAn6tLV2Phttx8OHgAjZ62bEmNiJpOt8jkZXYD/YVVcwvE9FQl
        0b68+nWMWwZA5wqHXccwO6xfil1RCw2T6RTJBsqWds2DtcWTLVi/jPyrNPuN5ecfMLRS8g9D82r33
        5GaH1o01u4PKXx8XWQGIP1K4nR/Mxhout53EstbP0aEmyH1QhjRg/MxnuqcSqXUU1c+E/+niVimVA
        25VpKa3nWKnuZAeM9jsHSpRhSzyE4QB9PGZuRMFXjvpfra4eLmujsjDCcf/bXpQzu19CINmPxIycH
        +O27jQHw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j3gaC-0002Us-Ja; Mon, 17 Feb 2020 13:37:08 +0000
Date:   Mon, 17 Feb 2020 05:37:08 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 1/4] xfs: fix up some whitespace in quota code
Message-ID: <20200217133708.GF31012@infradead.org>
References: <333ea747-8b45-52ae-006e-a1804e14de32@redhat.com>
 <31c57459-2b3e-984d-cb20-e85566caafd0@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <31c57459-2b3e-984d-cb20-e85566caafd0@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Feb 08, 2020 at 03:10:37PM -0600, Eric Sandeen wrote:
> There is a fair bit of whitespace damage in the quota code, so
> fix up enough of it that subsequent patches are restricted to
> functional change to aid review.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
