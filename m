Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70FDC388EE4
	for <lists+linux-xfs@lfdr.de>; Wed, 19 May 2021 15:21:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344612AbhESNWe (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 19 May 2021 09:22:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240404AbhESNWe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 May 2021 09:22:34 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B26FDC06175F
        for <linux-xfs@vger.kernel.org>; Wed, 19 May 2021 06:21:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=etaPCXPkM0Jaqo4Mue/7E5pF9MGOMsJ29Vs6yCUU0J8=; b=kCk9P+wUxx+WH0c2jGHl/U3JCJ
        dDqOQ9J99+6Vmkqyktx+Guw7M9qzAPuB8dVg9Wa2TCHj9v36zgW6E6yVrCqAOUCEef8kIB+Fo7vWY
        RX3xIqHz0tCCxjmaIvZC7jeJ9kRz5cRqKW1ZXZbZZL1AlQYZMwmQbVGxHIKLYbImB6nwMOfIgLBHA
        cm8T3Ilgj9CeJqu4U7GCGOVWJXq/s38GbVCeFJg6n4mN8NLlFxFns5PpbsrNiLzqVKoCuRvCn//9C
        73gDNugCEoQoOhwwqU4668az3Pnbx7yfWhcjgO6EpS5AVtJGzVRytAhxqshwaszbuJmSO/CH5K57E
        RUz9SWwA==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1ljM7a-00Ey4I-LF; Wed, 19 May 2021 13:20:39 +0000
Date:   Wed, 19 May 2021 14:20:22 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: fix deadlock retry tracepoint arguments
Message-ID: <YKUQlmmHxWDubKHT@infradead.org>
References: <162086768823.3685697.11936501771461638870.stgit@magnolia>
 <162086769410.3685697.9016566085994934364.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162086769410.3685697.9016566085994934364.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 12, 2021 at 06:01:34PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> sc->ip is the inode that's being scrubbed, which means that it's not set
> for scrub types that don't involve inodes.  If one of those scrubbers
> (e.g. inode btrees) returns EDEADLOCK, we'll trip over the null pointer.
> Fix that by reporting either the file being examined or the file that
> was used to call scrub.

Without an indication of which one we trace this is a little weird,
isn't it?  Still better than a crash, though..
