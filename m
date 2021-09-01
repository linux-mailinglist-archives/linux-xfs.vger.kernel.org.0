Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB9EF3FD5DF
	for <lists+linux-xfs@lfdr.de>; Wed,  1 Sep 2021 10:49:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237776AbhIAIuE (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 1 Sep 2021 04:50:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232688AbhIAIuD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Sep 2021 04:50:03 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60332C061575;
        Wed,  1 Sep 2021 01:49:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=WXfA4IC/Zk63UrYKCwxOcRU5g2QD+ENGkxLUi16ucX4=; b=VTFtQnGWFFEB/hgbX4D3NuDooH
        Lia81wTaCzr9Hth/npsv0Epm8ZtsXvck5dbYMl1ynkfzwTL4T2H3jJfzrkib8e3VwMfaL8tWwlSq5
        LiIKvyO0iNWZsZVwAaZUzJ1Mp93f87HH2vbSJqor2RIB9engGz3plGIYP+nDyBxW12vafjUkmrzUR
        9pCywG+t1bD+he+m2va0oKV4r4z/Nb6giu8Mw75YlQSBN2sf+5g4G/rnebiZLPrz6g27AAbZnkCOM
        SZgEyXBK7zAdV6ikuE7sMFxzPCZ3zTLcIy4LM99HGWNpAPXtREL0hxxKbgh8SSQDGpD4gF7CDf25Q
        zX4iPY+A==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mLLuu-0023lV-IY; Wed, 01 Sep 2021 08:48:32 +0000
Date:   Wed, 1 Sep 2021 09:48:20 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 3/5] xfs: fix incorrect fuzz test group name
Message-ID: <YS8+VLfosd74CPp1@infradead.org>
References: <163045514980.771564.6282165259140399788.stgit@magnolia>
 <163045516624.771564.3811466819215120895.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <163045516624.771564.3811466819215120895.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 31, 2021 at 05:12:46PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> The group name for fuzz tests is 'fuzzers'.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
