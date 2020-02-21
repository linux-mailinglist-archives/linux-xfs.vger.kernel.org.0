Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67198168104
	for <lists+linux-xfs@lfdr.de>; Fri, 21 Feb 2020 16:00:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728824AbgBUPAC (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 21 Feb 2020 10:00:02 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:59778 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728712AbgBUPAC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Feb 2020 10:00:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=aKZW1c9wfJkgo2WIXIs9gnusuHWZiF0QiZUuFqjHhyA=; b=EN7Y6Wep7iL16ZrhRRSx0ZJ4G4
        EVj8+i3PHhH1UkuR8x+G9Kr7QbzBknrdnp0Lrq+EM/t/QQfYjNrj+BW15kSQKnkg3sxC+uVfCYfHL
        3eUt54goBYFZK2Z1RveIU4OQTBZBVvs0ZG5ueUl+Q5sVBqNTZhPU7KXgdPSbJW8pqj8vj5Dy4TBTW
        rP98BWLBQ2x0SCih+I/wgd2klUpeGplf09Jzwo53vyZup4WLt+1pDj6hmgAN+mpiSXu9VLW127Xxi
        J8vp5PzvszJ0cPXdrThDh1OBs4XJKG4K8qhm+rFVJnWwV2uj4AZT9ZZcByZdoicouxfWf1Nxoe4an
        dcAlyzKg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j59mb-0006zx-RN; Fri, 21 Feb 2020 15:00:01 +0000
Date:   Fri, 21 Feb 2020 07:00:01 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/14] libxfs: refactor libxfs_readbuf out of existence
Message-ID: <20200221150001.GT15358@infradead.org>
References: <158216306957.603628.16404096061228456718.stgit@magnolia>
 <158216309405.603628.3732022870551516081.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158216309405.603628.3732022870551516081.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 19, 2020 at 05:44:54PM -0800, Darrick J. Wong wrote:
> +	/*
> +	 * if the buffer was prefetched, it is likely that it was not validated.

Please capitalize the first character in multi-line comments.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
