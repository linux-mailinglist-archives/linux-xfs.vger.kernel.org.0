Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C6B3A2EFA
	for <lists+linux-xfs@lfdr.de>; Fri, 30 Aug 2019 07:35:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726939AbfH3Ffw (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 30 Aug 2019 01:35:52 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:50804 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726144AbfH3Ffw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Aug 2019 01:35:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=hmQXnVChAHlknLBOQuabMxAeSzhABHI8nkuo1XuGHG0=; b=PUgnWUcZ1wvAolao9DBBERXcm
        C4RtCp8R2MwniDcUiTBYQ7plK50w2A5wgC7KVzcqxgscR314ZoCyHkyz6ZWMP9MKw7sLa1Pa7dL6J
        rzu3M2Ym90HYlMGd0WDgBpGAfkYak75aRMJ/v/l7zxUpNV7Z8PkoMeQXg7RtRoQilGfrO1jbH4byX
        o0G0/qV3XGoywO5T2j3BBRW8Nac0r3duLR4b4nHDRkKch9CMqfWZOHTaAChp7h3Li3lMOQDGapvp0
        2AQKgqetfjJB7NF4KK7IZHPOUvRTbz/Jixduwyg8BUtaPEVL1o5qTUzLwM0MA+nq8u1DgM2T24MYC
        9uB4UPrJg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i3ZZg-0007H4-El; Fri, 30 Aug 2019 05:35:52 +0000
Date:   Thu, 29 Aug 2019 22:35:52 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/5] xfs: consolidate attribute value copying
Message-ID: <20190830053552.GG6077@infradead.org>
References: <20190829113505.27223-1-david@fromorbit.com>
 <20190829113505.27223-5-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190829113505.27223-5-david@fromorbit.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 29, 2019 at 09:35:04PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The same code is used to copy do the attribute copying in three
> different places. Consolidate them into a single function in
> preparation from on-demand buffer allocation.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
