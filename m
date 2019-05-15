Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41D301E968
	for <lists+linux-xfs@lfdr.de>; Wed, 15 May 2019 09:52:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725902AbfEOHwy (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 15 May 2019 03:52:54 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:45394 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725876AbfEOHwy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 May 2019 03:52:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=ysATgtVMh2+dqpZDadJ1SpAv3rmnUzMrncr/OqMmJRA=; b=rIfb0wjOcDX5u/vbdDvd7ZcXv
        3YSHcI63wv0n1oX6KrWAH8wvIqHbVaFcUxl0DaoMe+SDeJoSSCFniqQwMmxHNyhw0ZsN8pYpvLdrJ
        Uy0E/e7pv661bvt6hVghRCdrzoPDCyFkJoMZMxj1TedlPXbgiB+u+EnlyhoBFSCBSE8/H6L2Bb/lP
        5kQEdRl6uV0NjLreCtqWSmxPDA2ZeaxDqYUnvlX1bxABdz60tlRhYi91Zmk1+YQZANGtxLr0ZymVe
        vjDDuzPzwwZT/yn1dzjDZi+zmFHPpocysOmwbqBqh7+ojKliey7m+8MYhcXIajpaOYjocKjkrhSmM
        NV3Wq8nXQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hQoib-00057C-Jx; Wed, 15 May 2019 07:52:53 +0000
Date:   Wed, 15 May 2019 00:52:53 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/6] xfs: refactor small allocation helper to skip cntbt
 attempt
Message-ID: <20190515075253.GG29211@infradead.org>
References: <20190509165839.44329-1-bfoster@redhat.com>
 <20190509165839.44329-2-bfoster@redhat.com>
 <20190510172446.GA18992@infradead.org>
 <20190513154433.GD61135@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190513154433.GD61135@bfoster>
User-Agent: Mutt/1.9.2 (2017-12-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 13, 2019 at 11:44:34AM -0400, Brian Foster wrote:
> The only functional change was basically to check for ccur before using
> it and initializing i to zero. It just seemed to make sense to clean up
> the surrounding code while there, but I can either split out the
> aesthetic cleanup or defer that stuff to the broader rework at the end
> of the series (where the cursor stuff just gets ripped out anyways) if
> either of those is cleaner..

Yeah, I noticed how trivial the actual change was.  That is why just
doing the cleanup in pass 1 and applying the change in pass 2 might
make it more readbale.  It might also be worth to throw in the use
a goto label instead of long conditionals from your last patch into
that cleanup prep patch.
