Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FB743C7EA9
	for <lists+linux-xfs@lfdr.de>; Wed, 14 Jul 2021 08:44:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238079AbhGNGqd (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 14 Jul 2021 02:46:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238063AbhGNGqc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Jul 2021 02:46:32 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABF78C06175F
        for <linux-xfs@vger.kernel.org>; Tue, 13 Jul 2021 23:43:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=hkYqs5GELGhGHVswtnj9IE6NKnR4UB7uCkultB20JFQ=; b=ueDQjIWX+VLhkPbxi1lHxtrwZu
        0F4NWyBw7rO9uAyeS/lG5AbDgek7wRRQ901tsDb+1plWZbWDODjDODcLBNRYR2qKp6xmmpeyEkw2C
        BqLzM/KeAkBCCahI+sWbji8w6QRYPnzmmVlZLakqZ/d+E1XhVSeHADvWRRzGNKgAzA1jmc1deBWaO
        cnF7zlXGzg7ki5PBYHXq0eE7XSYe7cLat3P5B1iXu2JkWzPDhN2AEGRi+1Fq64B2TnUvovSMz+o+P
        c5nsqr32QYUtusbr++Lf/zs2z7Fr4VOVCrXzX3bwMWpN7PTZVZhHElPubKLn3OaV/p8kAZAs19GfY
        /+ZByzEA==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m3Yc3-001vn5-4h; Wed, 14 Jul 2021 06:43:30 +0000
Date:   Wed, 14 Jul 2021 07:43:19 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/16] xfs: sb verifier doesn't handle uncached sb buffer
Message-ID: <YO6HhyRIupe08o5/@infradead.org>
References: <20210714041912.2625692-1-david@fromorbit.com>
 <20210714041912.2625692-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210714041912.2625692-2-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 14, 2021 at 02:18:57PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The verifier checks explicitly for bp->b_bn == XFS_SB_DADDR to match
> the primary superblock buffer, but the primary superblock is an
> uncached buffer and so bp->b_bn is always -1ULL. Hence this never
> matches and the CRC error reporting is wholly dependent on the
> mount superblock already being populated so CRC feature checks pass
> and allow CRC errors to be reported.
> 
> Fix this so that the primary superblock CRC error reporting is not
> dependent on already having read the superblock into memory.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

.. in the long run we really need to kill of b_bn to avoid this
kind of confusion.
