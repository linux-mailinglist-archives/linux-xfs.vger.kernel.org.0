Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0BF6324BE8
	for <lists+linux-xfs@lfdr.de>; Thu, 25 Feb 2021 09:19:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235826AbhBYIS7 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 25 Feb 2021 03:18:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235813AbhBYISx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Feb 2021 03:18:53 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB906C06174A
        for <linux-xfs@vger.kernel.org>; Thu, 25 Feb 2021 00:18:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=HX2UkwwKT2TDp9jHBitiu5+OKs
        eu8xqxK2Kk9ESww/jtfacivwp/sEiiB5stAcf+6G8g/J43A4gVs2rrJS9LlntllW/XEQI8s8l+xa7
        fFVkdj9wT1x6Rpx3RoDF2bD2g4MJtc9iyIM+9rjjoZaNjGy/CgO70zjHPw5U5tkoM0c2j/Xs1NKr8
        PYbpPL+3L+a8b0QlK3mHK9GDw55TNNEbKBEtfxUTG9TJkLF4++gDO0FT/jUYhIPXCm4VmQwcGIP3I
        S0mIDZMdmeFquMDVz/WI7lIX+NhGiDk1Rso/910f/FrXW3KvCfy7dZlNpVW/Gg1wLMv8yZ+3XIlBT
        doNCFdJQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lFBq0-00ASL8-Gs; Thu, 25 Feb 2021 08:17:47 +0000
Date:   Thu, 25 Feb 2021 08:17:32 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, Brian Foster <bfoster@redhat.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] libxfs: simulate system failure after a certain
 number of writes
Message-ID: <20210225081732.GM2483198@infradead.org>
References: <161404926046.425602.766097344183886137.stgit@magnolia>
 <161404927196.425602.4393417228179099132.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161404927196.425602.4393417228179099132.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
