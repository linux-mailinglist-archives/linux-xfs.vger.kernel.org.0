Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A93A7A7BB9
	for <lists+linux-xfs@lfdr.de>; Wed,  4 Sep 2019 08:32:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726004AbfIDGcl (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 4 Sep 2019 02:32:41 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:44282 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725840AbfIDGcl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Sep 2019 02:32:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=hxevBI3FYdYAfaKrKySYzGtcoUk4jAmFIgQc8xyoMSU=; b=Gr/VBWh2L/4Gd6wI6FisbQeVE
        Ows8dOBHDjUqGn9DMO9JsWajyKaWPP9/XpZT2+72NacX0FC/HKXwr78gPPUfzi1zv5OHfOQK62pJZ
        6obNfeUibAy3HpAyVn6UyHqD0FnKvf9qM9kseRZL8Zczxk+30Vk5ogTze91PQVhD4ywz3iDKr9oEk
        0VUmlJuEz28FHyFXITqASb3+C4zZDlxkgZEScrN2lw43fCZ4mX5t0rxAezXV2ATONnrsKr7whtSGV
        CVbE5VD9enXgXCD0c5/SaGaqgQpJRBv18RCxEQ7wKJwP2U7DfzXALXGj1MH+1HhGeDooPpF66vegU
        8nTvMvH9Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i5OqO-0007aE-EI; Wed, 04 Sep 2019 06:32:40 +0000
Date:   Tue, 3 Sep 2019 23:32:40 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/7] xfs: factor callbacks out of xlog_state_do_callback()
Message-ID: <20190904063240.GA24212@infradead.org>
References: <20190904042451.9314-1-david@fromorbit.com>
 <20190904042451.9314-5-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190904042451.9314-5-david@fromorbit.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

After going back to this from the next patch I think I spotted a
behavior difference:  xlog_state_do_iclog_callbacks only returns true,
and xlog_state_do_callback only increments loopdidcallbacks if
ic_callbacks was non-emty.  But we already dropped the block just
to check that it is empty, so I think we need to keep the old
behavior.
