Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83DB328EE57
	for <lists+linux-xfs@lfdr.de>; Thu, 15 Oct 2020 10:17:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387910AbgJOIRT (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 15 Oct 2020 04:17:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387764AbgJOIRT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Oct 2020 04:17:19 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 706B0C061755
        for <linux-xfs@vger.kernel.org>; Thu, 15 Oct 2020 01:17:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=oYt97sLVLtTBc5I73aBIaFPG/4
        T8zLKs152D/2cMgWph0tXJ2uwPxHiYSHAC2yfKQcGBI4AhNfsw+ysKMckseYB09orl+5KXBEgZBEH
        mWPzJSkCBFQfaydjDWExc4ZoS+ZEYeEwixawaY/8vun092UsBXOmLIBHhO6fKSDbUX8pMFrin0BaG
        5gfLz1VZeG9jBZdwbs7Omm1MUUd6AVEP6AkYAjbdE9s5/KDxXHR1GJPFjRoCJ6nTifVBIBI3Vxvdp
        LJTt2QOtBKZBmhQIcw7diC/t9mCepkBloMVEuh87BYQuGr8S/1E/kMX02MghbUoTT0/3LVyYAMi7h
        whrHA8rQ==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kSyRp-0000g0-WE; Thu, 15 Oct 2020 08:17:18 +0000
Date:   Thu, 15 Oct 2020 09:17:17 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Pavel Reichl <preichl@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v11 2/4] xfs: clean up whitespace in xfs_isilocked() calls
Message-ID: <20201015081717.GB1882@infradead.org>
References: <20201009195515.82889-1-preichl@redhat.com>
 <20201009195515.82889-3-preichl@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201009195515.82889-3-preichl@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
