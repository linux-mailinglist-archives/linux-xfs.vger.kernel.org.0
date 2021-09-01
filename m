Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 753AC3FD5BB
	for <lists+linux-xfs@lfdr.de>; Wed,  1 Sep 2021 10:36:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243297AbhIAIhN (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 1 Sep 2021 04:37:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243278AbhIAIhL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Sep 2021 04:37:11 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8746C061575;
        Wed,  1 Sep 2021 01:36:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=wQtnFgOyZJGXHOGxNUSKY5R2N+
        3iq0VMh13I58z/MbH1yOPqmbK4JkOStc+H5hcPX53ZcAgAvo9b03fozBKOkou0de/TIU2JR9oXWaP
        ddfn0ReFWmVOo38unejg8TlljzBYvtXgeWEWRSgymOoskYQvy4i2dAHcSZSsJdvUDA47jZoBkD9fr
        jUru+2MADBMeCi0lv8WEiwk8YVD/gY1hF1RRMkISG8ZjKfvmkKDT33ydGp0oPBDkY316dYs7FSAe9
        Hvuk4zNT2rOyajJXWq2v4nc1J/jrUsMFQzhQNuLW8LvKvf40NpT88pqDCw+eaj7X6zWoPPSxyZbIa
        pdYal19A==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mLLh3-0022z1-Ll; Wed, 01 Sep 2021 08:34:27 +0000
Date:   Wed, 1 Sep 2021 09:34:01 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 2/2] generic/643: fix weird problems on 64k-page arm
 systems
Message-ID: <YS86+dxiI3aPCtDG@infradead.org>
References: <163045507051.769821.5924414818977330640.stgit@magnolia>
 <163045508165.769821.10102236634811320096.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <163045508165.769821.10102236634811320096.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
