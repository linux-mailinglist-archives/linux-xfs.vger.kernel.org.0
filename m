Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27BFE2FB1B2
	for <lists+linux-xfs@lfdr.de>; Tue, 19 Jan 2021 07:41:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725969AbhASGj4 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 19 Jan 2021 01:39:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727038AbhASGi6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Jan 2021 01:38:58 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2D33C061573
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jan 2021 22:38:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=SrfpGKxt+XkpBpBDJvm7dAj9Dq
        X8UMQg7WwkA6IE9uTa8KKu3z8xTNQUezg1J4oefbjIkSKEDNdFEl8uOi6V/LoUgov7JNybnZIIfvd
        v+iI7Oe/Iti1cP9ABtyl4F5ouf4v8Hi9Bs6Wj1Al3p4rJHXwuqdfMPQv4I5r/I1XGJnV3PTvwzSJG
        hQblvQcFSrN3G7Q9rPjC5RxTKoIdAr7H98dVywfWKMxlihtdyoSl1+xUzOxfW1+cX0UoQND6p2D9e
        gcW+IRo+BkQoJu59tPJ7HfL2OCUruabL3ay+RqJWZrHDQqSd0ECstxabzczbnVEfSyD5GmfGVPYKY
        umi1tk8A==;
Received: from 089144206130.atnat0015.highway.bob.at ([89.144.206.130] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1l1kdz-00DuU5-AY; Tue, 19 Jan 2021 06:37:41 +0000
Date:   Tue, 19 Jan 2021 07:35:23 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs: clean up quota reservation callsites
Message-ID: <YAZ9q9zEIpd/IETJ@infradead.org>
References: <161100789347.88678.17195697099723545426.stgit@magnolia>
 <161100789930.88678.12106031748396086815.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161100789930.88678.12106031748396086815.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
