Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29133161415
	for <lists+linux-xfs@lfdr.de>; Mon, 17 Feb 2020 15:01:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728101AbgBQOB5 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 17 Feb 2020 09:01:57 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:59928 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727803AbgBQOB5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Feb 2020 09:01:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=zW1NYg9KeyuV5om3djHkTAzF694l2/2Dc+UJLmr2dmw=; b=JmHw0/bi3w0FkEDCrM3PC9TLNV
        NBOzViwWif5zM52HTe9m4mAegAYh20YiYZyPwBcQiYKiifZy3S2EY1d7st99ddlXd4nog5zN1IiaT
        bKAsi0B16nTkT/qllPYNCWkxF4QzJ3dvYjPvHhKs2UWf9vDBPtATAHczhuDXPxREN0GVpYRBAu7xZ
        JWNgvBxOgHPzWWdVCumWvKYNYWnNS5OMkmdxMNjyfngRCdekBmCBXWPiIAXB0EwJRLKPuo7rj/+aQ
        4xhCUarSw5CZiN5Leypvym83Gfd46RVu2CwXVJ1BTtPm1c/jC3fBcL2p11M7hCyhGwCVJO2n1W7s+
        UUw/6Olw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j3gyC-0005Vp-C2; Mon, 17 Feb 2020 14:01:56 +0000
Date:   Mon, 17 Feb 2020 06:01:56 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] misc: make all tools check that metadata updates
 have been committed
Message-ID: <20200217140156.GO18371@infradead.org>
References: <158086364511.2079905.3531505051831183875.stgit@magnolia>
 <158086366953.2079905.14262588326790505460.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158086366953.2079905.14262588326790505460.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 04, 2020 at 04:47:49PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add a new function that will ensure that everything we changed has
> landed on stable media, and report the results.  Teach the individual
> programs to report when things go wrong.

This just seems to touch a few tools, so all seems a little
unspecific.  Best split this into the infrastructure in one patch,
and then one per tool to wire the call up.
