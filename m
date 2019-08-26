Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 148DF9CCDD
	for <lists+linux-xfs@lfdr.de>; Mon, 26 Aug 2019 11:52:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729524AbfHZJwx (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 26 Aug 2019 05:52:53 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:45104 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726616AbfHZJwx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Aug 2019 05:52:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=maGv03MNuHFLTHx2cIEmzFE+urdEJnlgCqOojAskGZk=; b=IneWFXZiURNV1f/G+tqXoCY0b
        K78d6rQnEAjZRM4IOvkvMYSGEt8A38ZN2m8SLQI7/Z8uq4Le5V/NCturkEMZDGDFydz8YbjGeUcbH
        5aHpsRMMK6xU5AoW2yXmijTNXU8+fTw3wozP7YBri4eU3rAKwdIgOvBD9D9ucfwdtMD2DNzVsJCWy
        4jQ7slP/5jVjzasYjERutpJZ5Xpbl9xR5HIf5pBUYwC6x1Wucvg/Ddlrmry0mba3bAEdcmmVZpJ3Q
        lgyHGpGqhQHZoSPV8lY5WH2BJVqLVMrvixtxfy6KOGpx+rc7/BJMF7uuPvf09SFKSuwE0l8MnNTWE
        25lIJKxLw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i2BgD-0000Oz-8h; Mon, 26 Aug 2019 09:52:53 +0000
Date:   Mon, 26 Aug 2019 02:52:53 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Murphy Zhou <jencce.kernel@gmail.com>
Cc:     linux-xfs@vger.kernel.org, darrick.wong@oracle.com
Subject: Re: [PATCH] xfsdump: fix compiling errors due to typedef removal in
 xfsprogs
Message-ID: <20190826095253.GA1260@infradead.org>
References: <20190826050130.eqzxbotjlblckmgu@XZHOUW.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190826050130.eqzxbotjlblckmgu@XZHOUW.usersys.redhat.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 26, 2019 at 01:01:30PM +0800, Murphy Zhou wrote:
> Since xfsprogs commit
>   32dd7d9c xfs: remove various bulk request typedef usage
> 
> Some typedef _t types have been removed, so did in header files.

I wonder if we need to add them back to xfsprogs to not break other
tools using the header.  But independent of that I think killing
them in xfsdump is good.

>  typedef char *(*gwbfp_t)(void *contextp, size_t wantedsz, size_t *szp);
>  typedef int (*wfp_t)(void *contextp, char *bufp, size_t bufsz);
> +typedef struct xfs_bstat xfs_bstat_t;
> +typedef struct xfs_inogrp xfs_inogrp_t;
> +typedef struct xfs_fsop_bulkreq xfs_fsop_bulkreq_t;

I think we just need to stop using the typedefs, as this would break
a compile with the old xfsprogs headers.
