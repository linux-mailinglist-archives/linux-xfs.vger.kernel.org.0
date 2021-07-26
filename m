Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A7793D5432
	for <lists+linux-xfs@lfdr.de>; Mon, 26 Jul 2021 09:28:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232459AbhGZGma (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 26 Jul 2021 02:42:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232461AbhGZGm3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Jul 2021 02:42:29 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A22C0C061757
        for <linux-xfs@vger.kernel.org>; Mon, 26 Jul 2021 00:22:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=eLAZNIl87u4i0rAcTyRyDogE6o
        ge47gZg408nrzmx+N0qBh3JnHayC4+RA0KbnesKl48i3UmRQ+gB7FSqxhZGS5afmoJwJLf03UmkOQ
        HIcQ97F1O2p8KG6TxFxy81lOEkNv8xWjoS9xMT9axNcj6BIB+GKwShd41l1a5tpIduw+jnKV6Jvj2
        yPoeDdv8xM6/x7qpdv/FAMdPrgtoyI+9Ev0XXHM8g8uCoiRNifrFyMGYa67TJOo3T22lGJAWT15lL
        O6AtukPvgWGRuRZh63PlxNL5kGbUFh5k2+UTEoSJKMan2PbcwroCWbQjxmkifTA1uIJlxDKZmk5S9
        UztITL8Q==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m7uwQ-00DhBt-P5; Mon, 26 Jul 2021 07:22:34 +0000
Date:   Mon, 26 Jul 2021 08:22:22 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/10] xfs: fix ordering violation between cache flushes
 and tail updates
Message-ID: <YP5irkEACl0xJZGn@infradead.org>
References: <20210726060716.3295008-1-david@fromorbit.com>
 <20210726060716.3295008-5-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210726060716.3295008-5-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
