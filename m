Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98A552C9EFB
	for <lists+linux-xfs@lfdr.de>; Tue,  1 Dec 2020 11:20:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726705AbgLAKSi (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 1 Dec 2020 05:18:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726688AbgLAKSi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Dec 2020 05:18:38 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2B5FC0613D2
        for <linux-xfs@vger.kernel.org>; Tue,  1 Dec 2020 02:17:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=74kZWzH0aTWyDndwlCStl448kLeoWMwANKuQ9LlDOsI=; b=M9LAK9KBgdU9WsOoP78kAbl/At
        wU4pAiBk8io9x5qxj6FzYpWdDEdHqX/V5w9l9/b2Dg6nBErZGsOc7PTOEEvx25WHtMPLUl6jHgC8m
        E08thny4ars6EKy/H9XjzqsRx4FM9Pyb45Klsrs9x1MJobB+7I0QTn7yFv9oUJCBfgJ1O0SkIuAWp
        17NeOD30cCDTVfc2nKr7PM7OagpX+0kKBuHSb5WpI7oPIfVxqMkckJC8wFepjtY8x0KmVsmAuNqB5
        RWX+EONuoEILbe8PSENkj102pD73zdWq5UMMHpcFUJT7Mgtjyr36LCHKJ+nap0BnNIBYbfahAQ5FL
        VK3oBhqw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kk2jK-0003x4-RB; Tue, 01 Dec 2020 10:17:54 +0000
Date:   Tue, 1 Dec 2020 10:17:54 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/5] libxfs: fix weird comment
Message-ID: <20201201101754.GC12730@infradead.org>
References: <160633667604.634603.7657982642827987317.stgit@magnolia>
 <160633668822.634603.17791163917116618433.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160633668822.634603.17791163917116618433.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 25, 2020 at 12:38:08PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Not sure what happened with this multiline comment, but clean up all the
> stars.

Looks like a typical copy and paste error when the editor tries to be
"smart".

Reviewed-by: Christoph Hellwig <hch@lst.de>
