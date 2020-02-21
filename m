Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AE4A1680BC
	for <lists+linux-xfs@lfdr.de>; Fri, 21 Feb 2020 15:50:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728544AbgBUOuA (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 21 Feb 2020 09:50:00 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:50052 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727315AbgBUOuA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Feb 2020 09:50:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=m1PCbbhcf1N60GUUlWX8fGPz1DQo48lB/rBHVs+YMYY=; b=thMKsC3/DPR6fciuT9cmCWEi1M
        MWuDqwqxfZN1WdIRe5nz3Y44B3ze4KzEqHKHAOZm3tzV2CX1/D+bKJrhCfYRU2N8taNehQqtwCsxk
        9Fh69yYpt0vjJVD0PklW/wsuVh9S8MQEgUeZce7cjn4tLET5bxgH48r7RjPRCuRx99GJ5L6+Ms0qn
        f9P88VhPUVE9zIfc7o3VcQ1HNpOXMoNI2kNefc04vFOQ10sQFqg1r+tZfSXD1Mv7d5iF9dU3R1lnJ
        uzwsJ/uPnSXefmIPUvvLoI46YQU6TMhACreIz235Aj12bfKrxcqNxDjnWY1aFunQWoNGeTnCiV0nn
        NQjO9z2A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j59ct-000128-Pf; Fri, 21 Feb 2020 14:49:59 +0000
Date:   Fri, 21 Feb 2020 06:49:59 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/18] libxlog: use uncached buffers instead of
 open-coding them
Message-ID: <20200221144959.GI15358@infradead.org>
References: <158216295405.602314.2094526611933874427.stgit@magnolia>
 <158216302373.602314.13809511355239867956.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158216302373.602314.13809511355239867956.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 19, 2020 at 05:43:43PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Use the new uncached buffer functions to manage buffers instead of
> open-coding the logic.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Isn't xfs_log_recover.c supposed to be partially shared with the kernel?
I guess I need to port over my changes to the buffer handling there,
which would mean implementing xfs_rw_bdev using preadv/pwritev.
