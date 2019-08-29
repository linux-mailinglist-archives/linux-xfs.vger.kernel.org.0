Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5923FA1391
	for <lists+linux-xfs@lfdr.de>; Thu, 29 Aug 2019 10:25:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727026AbfH2IZC (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 29 Aug 2019 04:25:02 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:58132 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725782AbfH2IZB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Aug 2019 04:25:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Ry3m19F8xf7+3R5QBu6hdR9z99Uh/q1UlcGnYNAO9Lg=; b=ptwT/qZRn46X6Ld+Pdi2x4Rfi
        2S7QDy+fUVRxgiesgn5aa0ofcCRvobyZsOQQtsA+/sUT2n4lWegUjm5H/4cADwB6+vDH2pstHp7rp
        aQxTuddUowZGPv2JmX+oattAI9xFjGPDPpE/MMOJh1tP02eiL80bR7eyrLE9lzlQcyrkDrbQjdK3T
        I1bUc3Seb200GootcH9rP8J8GzqdEjYYnCo6c2ozB0z7vjD/tZ0S9DCHLvocWmZEvgwb6LOGt+Xqy
        48qZ9NEwXLbSQWoH4oXmV5NiCQn6+WEgdP96TN4flgScT94gqdbElShFrI5sf5DqI5e5tt1KcnmON
        o0icK4GIA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i3Fjp-0004tH-9s; Thu, 29 Aug 2019 08:25:01 +0000
Date:   Thu, 29 Aug 2019 01:25:01 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/5] xfs: speed up directory bestfree block scanning
Message-ID: <20190829082501.GA18614@infradead.org>
References: <20190829063042.22902-1-david@fromorbit.com>
 <20190829063042.22902-5-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190829063042.22902-5-david@fromorbit.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Actually, another comment:

> +		/* Scan the free entry array for a large enough free space. */
> +		do {
> +			if (be16_to_cpu(bests[findex]) != NULLDATAOFF &&

This could be changed to:

			if (bests[findex] != cpu_to_be16(NULLDATAOFF) &&

which might lead to slightly better code generation.
