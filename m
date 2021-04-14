Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 673DE35ED18
	for <lists+linux-xfs@lfdr.de>; Wed, 14 Apr 2021 08:17:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237794AbhDNGQ7 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 14 Apr 2021 02:16:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232405AbhDNGQ6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Apr 2021 02:16:58 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36A78C061574;
        Tue, 13 Apr 2021 23:16:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=Vi1R3YyCYSZzrmzo3YfiDapP6x
        ituTcvc3e7J2Ym/ul8QcWpRyNWgEkuFsxeM6vGE4jCQEv3ecJWBLt/zWGdau0QT9iyn/lD0uuCUsr
        yQbBDNo2X2FbMjgee1EfRHJ/Hlg8qTVbHIs2WJRkHRbJZL/psdDpmjaQn+z3W6kLRfo68Jr0CcMaY
        sM0HGOLfaLzpdwAJaHr+sRdpVQHJhJloyxNXKha8M15xveGeeH7KSHH6/fvgVfx5w2LRwQZruzooq
        6kDpBMfahMkNJyqw4Zo+HEYs+qnT6Sqoi/tcJhN+LJPK+/L8xeVyKGEDe80ZyREOMjwqR7z7dUJH3
        sMcfojSg==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lWYp7-006jQu-Fw; Wed, 14 Apr 2021 06:16:27 +0000
Date:   Wed, 14 Apr 2021 07:16:25 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 4/9] common/dump: filter out xfs_restore messages about
 fallocate failures
Message-ID: <20210414061625.GF1602505@infradead.org>
References: <161836227000.2754991.9697150788054520169.stgit@magnolia>
 <161836229453.2754991.3539097521630217821.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161836229453.2754991.3539097521630217821.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
