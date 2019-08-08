Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9FFA86603
	for <lists+linux-xfs@lfdr.de>; Thu,  8 Aug 2019 17:37:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733258AbfHHPhA (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 8 Aug 2019 11:37:00 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:51240 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728380AbfHHPhA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Aug 2019 11:37:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=YRzw+ugwPDJo0McwXZm/ccv31s0nPL4olEWIbHVM440=; b=LY3zYxhJI3rJ1ATyZso/zZUNt
        RyUhPplysA+Gyg11owELXC2WzPPt+J8obIXyDwvNp17hja/76wjVW3ZjSxwgoVDzps3LEOE2aAjH8
        jribfH31t4bveI+OXr9cdplwyB3mzMXmtn/7PN00gRchxdmJrkOrhZ5b8nEbMjLwbQcd8noGLgY9p
        t0ld9+nvY/MXQ88c0bemuECm5mz+MRX6bGiCQknj8OBiS+FTKCWiB0xHU/pZLPXo1Eci9asvHbGeQ
        90UuFiVkC2R/FqjEX4+bL/oy4AREDBDoShmlBx20Amgj/MN1XCwh9d0tXaX0+9Nrat6NloG5mwdz5
        ndYkuN+DQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hvkTK-000703-FB; Thu, 08 Aug 2019 15:36:58 +0000
Date:   Thu, 8 Aug 2019 08:36:58 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Mel Gorman <mgorman@techsingularity.net>
Cc:     Dave Chinner <david@fromorbit.com>,
        Michal Hocko <mhocko@kernel.org>, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH] [Regression, v5.0] mm: boosted kswapd reclaim b0rks
 system cache balance
Message-ID: <20190808153658.GA26893@infradead.org>
References: <20190807091858.2857-1-david@fromorbit.com>
 <20190807093056.GS11812@dhcp22.suse.cz>
 <20190807150316.GL2708@suse.de>
 <20190807205615.GI2739@techsingularity.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190807205615.GI2739@techsingularity.net>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> -			if (sc->may_shrinkslab) {
> -				shrink_slab(sc->gfp_mask, pgdat->node_id,
> -				    memcg, sc->priority);
> -			}
> +			shrink_slab(sc->gfp_mask, pgdat->node_id,
> +			    memcg, sc->priority);

Not the most useful comment, but the indentation for the continuing line
is weird (already in the original code).  This should be something like:

			shrink_slab(sc->gfp_mask, pgdat->node_id, memcg,
					sc->priority);
