Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEE303072C3
	for <lists+linux-xfs@lfdr.de>; Thu, 28 Jan 2021 10:35:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232465AbhA1JaZ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 28 Jan 2021 04:30:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232589AbhA1J2E (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Jan 2021 04:28:04 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB526C061756
        for <linux-xfs@vger.kernel.org>; Thu, 28 Jan 2021 01:27:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=dA5BM4/ARHU2ynkGmWzHEj0xQD
        HsBcNaD14igaYVP11+b5D/wdR3M2ou5sbNUWA4RD4PnviECWUTsLQVePEueo32B9+IlLYeqDH7scH
        O7XB6B+jK/0B9BpXqRibhp7Bctxj+Cvb3dzIt/YKWxpS0q1lHJXY16mHUKlTVEzBciTZu8v7Mj9Tb
        pYozwwe92lEenT538SYdmMQVOWo4/nMmdCxcsJW7+yN4gH9dFtGBIElQl+CSi7UV10BqAizMcpBer
        c2ZVDCEGeVZbSazryDg0Rj9x91xxG3Y8GySIpRw8PqAnYEHba1ZBsXbORbC0ynaNFqCP+UrsA0hXS
        5z/n/JvA==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l53aD-008G9i-88; Thu, 28 Jan 2021 09:27:21 +0000
Date:   Thu, 28 Jan 2021 09:27:21 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com,
        bfoster@redhat.com
Subject: Re: [PATCH 1/2] xfs: increase the default parallelism levels of
 pwork clients
Message-ID: <20210128092721.GC1967319@infradead.org>
References: <161181380539.1525344.442839530784024643.stgit@magnolia>
 <161181381108.1525344.3612916862426784356.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161181381108.1525344.3612916862426784356.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
