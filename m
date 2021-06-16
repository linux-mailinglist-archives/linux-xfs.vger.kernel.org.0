Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2E633A94E7
	for <lists+linux-xfs@lfdr.de>; Wed, 16 Jun 2021 10:23:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232083AbhFPIZ7 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 16 Jun 2021 04:25:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232057AbhFPIZ7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Jun 2021 04:25:59 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E02C9C061574
        for <linux-xfs@vger.kernel.org>; Wed, 16 Jun 2021 01:23:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=AInZNq0WBj5xV24DyU2e97bIPvD63SrCFW1ikBQfGGE=; b=Bcb7kn68HUAJoLR59EfaTNO1Ky
        ycKn5zdTuptYeyG2VnooOVWmLLMxlaYzbCkcjqpsPjgnpGbanE/QgWJ+WTkqRZepw2vmVjxWxJOt7
        K6RMebsagDJdn9OP/1zBawjrDrdFdd3ikBQbEqVKESd0shAGYMtfSX6P827E+df8DNVfyOkFz794Z
        LtFWUv8Ipt9DSSmGkcTg45nVGjJg4/PwMp7M4KwFkMLcR6uPUfBHaw8L00hh4GsBNkdgTlv/T/x5y
        i4EcNSNLuH0njI5R8cUV4Ra/AJkJ/k4jXIJR3juEYBlATJUmXKw0/MvnWbU5iQS4B08YpMpugs50n
        cnUzLRVw==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ltQpY-007nhY-Fp; Wed, 16 Jun 2021 08:23:29 +0000
Date:   Wed, 16 Jun 2021 09:23:24 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org,
        bfoster@redhat.com
Subject: Re: [PATCH 04/16] xfs: clean up xfs_inactive a little bit
Message-ID: <YMm0/IJP1KhBYmk8@infradead.org>
References: <162360479631.1530792.17147217854887531696.stgit@locust>
 <162360481889.1530792.8153660904394768299.stgit@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162360481889.1530792.8153660904394768299.stgit@locust>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jun 13, 2021 at 10:20:18AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Move the dqattach further up in xfs_inactive.  In theory we should
> always have dquots attached if there are CoW blocks, but this makes the
> usage pattern more consistent with the rest of xfs (attach dquots, then
> start making changes).

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
