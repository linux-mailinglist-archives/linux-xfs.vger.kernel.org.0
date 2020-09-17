Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9670A26D614
	for <lists+linux-xfs@lfdr.de>; Thu, 17 Sep 2020 10:13:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726389AbgIQIMM (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 17 Sep 2020 04:12:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726199AbgIQIBQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Sep 2020 04:01:16 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D0ACC061788;
        Thu, 17 Sep 2020 01:01:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=4xqIGy2iZdu8N0lYfL+pyuE/vh8Y9cHUWnBdhIXPi3g=; b=aeR9zCXPk3V+PC8T4S1LNkhgJT
        u1/lZ5457SHYfgOqKDm7HIIwE2zoTFYd8L3LmxiETBgEb2Bob75kJWwScPJgxtCzj9RPEWsK7MXrB
        fM28v+3D91EEZBu9rVkGWtdYVTHKmVFyleEGHC21kTG3LuyClGYfeuuicNkeyGhIsb+u2DeCWBir0
        madNibzDZTOfQWK0zu+nWOQUDMBUyDaem65ZbLToiyd8jhJ1XxBovszBK6KifTTC7P9z0VF8CGJT8
        9Q0hXcOk9sKhujmluDhwUN8ge0pcRvjQQJGqpV3JP7WstjbRiU/8R1ppM74tb99deoTh3STf35rqd
        yWmDbTyw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kIoqq-0007kN-Lz; Thu, 17 Sep 2020 08:01:08 +0000
Date:   Thu, 17 Sep 2020 09:01:08 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 22/24] xfs/141: run for longer with TIME_FACTOR
Message-ID: <20200917080108.GR26262@infradead.org>
References: <160013417420.2923511.6825722200699287884.stgit@magnolia>
 <160013431528.2923511.17636617456077025611.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160013431528.2923511.17636617456077025611.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 14, 2020 at 06:45:15PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Allow the test runner to run the crash loop in this test for longer by
> setting TIME_FACTOR.  This has been useful for finding bugs in log
> recovery.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
