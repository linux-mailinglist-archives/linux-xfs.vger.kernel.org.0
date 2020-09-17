Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B125326D622
	for <lists+linux-xfs@lfdr.de>; Thu, 17 Sep 2020 10:13:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726370AbgIQINe (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 17 Sep 2020 04:13:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726491AbgIQINH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Sep 2020 04:13:07 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 702E1C06178C
        for <linux-xfs@vger.kernel.org>; Thu, 17 Sep 2020 01:02:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=qmYsvXNbEds0Qnhc0qTo94vYxA95cw9obLEPGXOtyAo=; b=g4fuAdkIBl471ngV2JqQTME3jO
        GtNpxY/VbClXjNl9OJeDDAC8EhaWqLEvmOhsCuwtQh24X3D07K1RPyF2Lswk2UuFfbOiQNGNTOpzG
        wB3HVA/9J2WSMD4++qkXw/QjNZ5k94NRFBY9Gvxgh2h3um2I6k1zCPPy5Kg0Et3YXTA9C9CAGKWpB
        tkkcNgv7MZepJLljRkoyPp7Y7AdZ9wT/Gtb90LaP7oRtc9EEWTFUcNNin1yvO6gSsxVLpe+qNZAo4
        gCODFwyhb12AKDEdDs28+QFxMAmXPKgH+gfJEOxrQ9L0CP91WgHElYkWQYOyIEToP8HT4eDZkcF/X
        onnSLUOA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kIosE-0007od-Ip; Thu, 17 Sep 2020 08:02:34 +0000
Date:   Thu, 17 Sep 2020 09:02:34 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] mkfs: don't allow creation of realtime files from a
 proto file
Message-ID: <20200917080234.GV26262@infradead.org>
References: <160013466518.2932378.9536364695832878473.stgit@magnolia>
 <160013468391.2932378.13825727040727340226.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160013468391.2932378.13825727040727340226.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 14, 2020 at 06:51:23PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> If someone runs mkfs with rtinherit=1, a realtime volume configured, and
> a protofile that creates a regular file in the filesystem, mkfs will
> error out with "Function not implemented" because userspace doesn't know
> how to allocate extents from the rt bitmap.  Catch this specific case
> and hand back a somewhat nicer explanation of what happened.

Would this be so hard to fix?
