Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B5B0324B5F
	for <lists+linux-xfs@lfdr.de>; Thu, 25 Feb 2021 08:43:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233817AbhBYHiR (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 25 Feb 2021 02:38:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234592AbhBYHiR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Feb 2021 02:38:17 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1287CC061756
        for <linux-xfs@vger.kernel.org>; Wed, 24 Feb 2021 23:37:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=SD3gvaqzwaF4P53i+x0ALhBBIJ
        7JOGQlF2kaoxNKmO9b6TE8gMk4It7TKn/5ShX3fbuY+ubBKzxmxwh7pcY657FDZAn859OqnwcBtM7
        xsq0pKVuFCtssxueNOS20yHp0uVt9WheAdJTKy1UG0GomGKEnfKUnJMQgxZHJ3aSARtq413zXoBd0
        699yCE6EtUNQv6+e69tOIvHZr0fgj6dzsNmAZ4BulSD6KrH05sImaaDz/7Ns0sduA3dsbnsOFp4BJ
        nNsqxglB6cziymrq+CON6uwVYOOaYLIyE54eG7dctyEkztkIwc1YkozsOlBmenEk9+SzZVylyFr5X
        pRRsDfvQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lFBCo-00AQ3W-MI; Thu, 25 Feb 2021 07:37:14 +0000
Date:   Thu, 25 Feb 2021 07:37:02 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>, Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfs: restore speculative_cow_prealloc_lifetime sysctl
Message-ID: <20210225073702.GA2483198@infradead.org>
References: <20210212172436.GK7193@magnolia>
 <20210212214802.GN7193@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210212214802.GN7193@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
