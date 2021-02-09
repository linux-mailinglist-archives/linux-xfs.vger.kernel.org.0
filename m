Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9131314BAE
	for <lists+linux-xfs@lfdr.de>; Tue,  9 Feb 2021 10:35:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbhBIJdj (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 9 Feb 2021 04:33:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbhBIJbT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Feb 2021 04:31:19 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5530BC06178A
        for <linux-xfs@vger.kernel.org>; Tue,  9 Feb 2021 01:30:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=f+oo8B1S1V8+V6B0AhJ9Tly4zKoB1xruwLpLFMP9yTA=; b=Fz2MAZob+WHnVegTgXpnQKFSGh
        XV5HI6OPAijL3IE1+fpJ8WDAHdAhANcW1LiBzCqjJxceZqtzzljkWfLYnZiwJyr5WuH3AGTkphH5W
        zxYI9kreFAXWIXoJyn71UosF/zfNQiJNwo7kAaglOfMfE87QwC0NMAuM22RySuMKZu/nocoKg534t
        Fw7zIccw5TtlTtvjqh0h16OB11IWDB76HZ+qbq3MCp+BQ9sMfTvkvHw8FVUKm4GQwureYzBpO72hn
        AuizInfW833wsr3GSYXvjvTZfOnGPtJ2aqJnLEPuRuB/hSbp8/HHVobmFaL+nIGcDsXMt2yhItlyY
        RSA/ivaw==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l9PLs-007EjG-Ho; Tue, 09 Feb 2021 09:30:32 +0000
Date:   Tue, 9 Feb 2021 09:30:32 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, Chaitanya.Kulkarni@wdc.com
Subject: Re: [PATCH 4/6] xfs_scrub: handle concurrent directory updates
 during name scan
Message-ID: <20210209093032.GP1718132@infradead.org>
References: <161284387610.3058224.6236053293202575597.stgit@magnolia>
 <161284389874.3058224.15020913005905277309.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161284389874.3058224.15020913005905277309.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 08, 2021 at 08:11:38PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> The name scanner in xfs_scrub cannot lock a namespace (dirent or xattr)
> and the kernel does not provide a stable cursor interface, which means
> that we can see the same byte sequence multiple times during a scan.
> This isn't a confusing name error since the kernel enforces uniqueness
> on the byte sequence, so all we need to do here is update the old entry.

So we get the same name but a different ino?  I guess that can happen
with a replacing rename.  Maybe state that more clearly?

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
