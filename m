Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E91F26D605
	for <lists+linux-xfs@lfdr.de>; Thu, 17 Sep 2020 10:12:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726306AbgIQILz (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 17 Sep 2020 04:11:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726365AbgIQICN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Sep 2020 04:02:13 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AA2FC06174A
        for <linux-xfs@vger.kernel.org>; Thu, 17 Sep 2020 01:02:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=PPjh+q6pG9EDvX0GONWKa76AIaPEqCkhYpkG3TkgmZU=; b=fMmQ2gBfIxctDiZKN/qqEFxivH
        XIeEmgPRYNbhXIroUcBQnavkGns3VUaN6ND3KJSbw2f5bvX6Seb37qPGRPXFt1QU+FWmLT907tC80
        jnUTwBunBTOvTJ4Rujwrfnk/qXvQ4/45G/NaYtDAF3HCrWPxw1HFR6C6wgvFaTIRTZzeGCTSFc44S
        zehaNraDYmmJSxA+pPXUGtOcW84+3qEqGeocL6NpxKlqXAsGHA/KNLHIbMIFdpP91wG7fHQvz7U/x
        siDdZXU4ILH2vBnLqfFwnPAfC3IlsLNATEXMGdNhb3j2u1FuYHsExWkRf48kAV77fbQ4LrsEKq9pi
        8eLtsY6Q==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kIorf-0007my-G5; Thu, 17 Sep 2020 08:01:59 +0000
Date:   Thu, 17 Sep 2020 09:01:59 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] libxfs: refactor inode flags propagation code
Message-ID: <20200917080159.GT26262@infradead.org>
References: <160013466518.2932378.9536364695832878473.stgit@magnolia>
 <160013467138.2932378.13730720108241920821.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160013467138.2932378.13730720108241920821.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 14, 2020 at 06:51:11PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Hoist the code that propagates di_flags from a parent to a new child
> into a separate function.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good (except for the fact that this is duplicated and not shared
with the kernel..)

Reviewed-by: Christoph Hellwig <hch@lst.de>
