Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E21E229D4A5
	for <lists+linux-xfs@lfdr.de>; Wed, 28 Oct 2020 22:53:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728181AbgJ1Vxp (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 28 Oct 2020 17:53:45 -0400
Received: from casper.infradead.org ([90.155.50.34]:44160 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728247AbgJ1VwD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Oct 2020 17:52:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=lDUTJNTL4+tkdhCbZqZECbuPcosEGYa7Hu8t/UjdKwQ=; b=YO/Dfeu/hmhudKaAu596wCI4tA
        oGHrydam0h5c00vnM2m30n2r6hh8HSiA9Wq0ATvo7tAHLydxgd9D4AyktOs7JDu7kCIJiGf09TLz7
        YG6EZnmx0s6YboKot2JNzOGDfsHNQwrEy12Bir+3iYdAx6CG4fIqTTDnNcFS46c7DgwE97jTpDUZJ
        WR40VTh7hVzVQ+GgWS9uKBCUu38HQrKVlhylemQuu8rHnz6ylo0NDtwAbKJqxhN2osEDHl6HGp/zz
        6hAHwXNWTvVatRnCEgHsS5i3veV88WhXnGS1BcyPFlZ4f8AoZRq148Fcm3C23vge42Fd8swrlYveR
        8XX6wsfg==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kXfvb-00008x-Oo; Wed, 28 Oct 2020 07:31:27 +0000
Date:   Wed, 28 Oct 2020 07:31:27 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] iomap: support partial page discard on writeback block
 mapping failure
Message-ID: <20201028073127.GA32068@infradead.org>
References: <20201026182019.1547662-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201026182019.1547662-1-bfoster@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

>  	if (unlikely(error)) {
> +		unsigned int	pageoff = offset_in_page(file_offset);
> +		/*
> +		 * Let the filesystem know what portion of the current page
> +		 * failed to map. If the page wasn't been added to ioend, it
> +		 * won't be affected by I/O completion and we must unlock it
> +		 * now.
> +		 */
> +		if (wpc->ops->discard_page)
> +			wpc->ops->discard_page(page, pageoff);

I don't think we need the pageoff variable here.   Also it would
seem more natural to pass the full file_offset offset instead of
having to recreate it in the file system.
