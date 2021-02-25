Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF655324CBA
	for <lists+linux-xfs@lfdr.de>; Thu, 25 Feb 2021 10:24:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236233AbhBYJYW (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 25 Feb 2021 04:24:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236289AbhBYJXq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Feb 2021 04:23:46 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A9FDC061756
        for <linux-xfs@vger.kernel.org>; Thu, 25 Feb 2021 01:23:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=PpNcChBzo7ELAvVbxVitdN09xG
        cuIRVaf1+JgLskCb2Ke86U2y8x8oXOgBAeczqLcIeseb9cYGUTB9CcCu2wzrPnDjAKOoiZkp2Q0wA
        vGfRSbZODhSm+ooi2EuxMBPTf67Jzkvs1/6t0IdcvpEB8f1bqYsbl23Vi7Sbsw+sOHQH0HCTvvK23
        RPAc+8MuEXQ4V9LYpJWN+iFp9tHk78DY2qdLI4O2oyHg7exWnFLI6xDHc4kScjLiQCYIUHazE5Gyw
        qWXBuQURxZJtatLAMgos4FxSvhfhT6u3NTR/kDSREE6u8gGfTUMqNkBmk+C+wIADKB6MpNQKiebJO
        jRFSXdpQ==;
Received: from 213-225-9-156.nat.highway.a1.net ([213.225.9.156] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lFCqt-00AW6A-14; Thu, 25 Feb 2021 09:22:41 +0000
Date:   Thu, 25 Feb 2021 10:20:20 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/13] xfs: log tickets don't need log client id
Message-ID: <YDdr1JJtGHnElZhG@infradead.org>
References: <20210224063459.3436852-1-david@fromorbit.com>
 <20210224063459.3436852-6-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210224063459.3436852-6-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
