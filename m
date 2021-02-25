Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73608324B7B
	for <lists+linux-xfs@lfdr.de>; Thu, 25 Feb 2021 08:48:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234907AbhBYHrb (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 25 Feb 2021 02:47:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233137AbhBYHrO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Feb 2021 02:47:14 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02EFBC061574
        for <linux-xfs@vger.kernel.org>; Wed, 24 Feb 2021 23:46:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=Y7z0HfiePk6ASoJO/DW6oRL5UK
        pX1NXrKfZQVy+DlfJxn16YsG7Cqfq6cjP8Scq8oe3TWIMyCFuSwXlKcllE8ezITxTxFHWsRRZwihU
        q8XEzfLcLgDrKNiHZGvdQ0qKQmZ7zvXoMFQeKdPWvqYQh872nK1dVtdGYjRBbhHWm2vUVmhMcvt08
        DhcMasvDLkp++EivvRDzkcaIJA+J7dODDjS5LJLcQU1zfVlGxeSmLiPPYRONNlnRPrQ1PbWfPZIhe
        0Qe/3P+DIlKWl1vdOraDSpim+MQZznjQNBw2I35uB/1egvTr5q9+UavKplp6DC9FuQ7H1PoIXdR6z
        iVVmRwFg==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lFBLJ-00AQby-LR; Thu, 25 Feb 2021 07:45:55 +0000
Date:   Thu, 25 Feb 2021 07:45:49 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Brian Foster <bfoster@redhat.com>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2] xfs: don't nest transactions when scanning for
 eofblocks
Message-ID: <20210225074549.GF2483198@infradead.org>
References: <20210219042940.GB7193@magnolia>
 <20210219172341.GD7193@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210219172341.GD7193@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
