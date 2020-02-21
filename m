Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B573168112
	for <lists+linux-xfs@lfdr.de>; Fri, 21 Feb 2020 16:03:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728803AbgBUPDk (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 21 Feb 2020 10:03:40 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:59908 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727315AbgBUPDk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Feb 2020 10:03:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=UWu7gShxRdAhPEHwH8jGlzM9x3Mq52iqGZrEnxJxFJI=; b=WyPnxn5jzb+r3a83ssN1mty4Gq
        qYCAlcjEeMrx/d8O6rdqIOMsMag3guJomD3IH2bHvYb4r0hiWGD4DV0sLS3mxG/X8RBLVYy6mwaP5
        z8fOPQKSMv7ltm6uBDjOAbxXg/lquxg6D/kzJDPUa3Z0oG2xGqMGAKJEvhItwFI//avwyVOFTqh1n
        CDajQDRu3nxDFa9WuLgSH5Q254sqEhhZhYXuqgwsUmNG8wwoSK2ZO2tK5ol3mmc1lCEANqUI/ZI++
        O9NgATfFJx1a2wkdLJrlYAtyu5NOzLYwx9UqolCYsTo71TB75YHTGBEh28fzm3+5GMuIT0ND+lBZa
        DQck5/Wg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j59q7-0000Rc-G8; Fri, 21 Feb 2020 15:03:39 +0000
Date:   Fri, 21 Feb 2020 07:03:39 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/14] libxfs: make libxfs_buf_read_map return an error
 code
Message-ID: <20200221150339.GU15358@infradead.org>
References: <158216306957.603628.16404096061228456718.stgit@magnolia>
 <158216310149.603628.17465705830434897306.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158216310149.603628.17465705830434897306.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 19, 2020 at 05:45:01PM -0800, Darrick J. Wong wrote:
> @@ -1050,15 +1083,26 @@ libxfs_buf_read_map(struct xfs_buftarg *btp, struct xfs_buf_map *map, int nmaps,
>  				flags);
>  	else
>  		error = libxfs_readbufr_map(btp, bp, flags);
> +	if (error == -EIO && salvage)
> +		goto ok;

I understand the part about skipping the verifiers.  But how does ignoring
EIO in this case fir the scheme?
