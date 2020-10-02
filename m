Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 397B1280DDE
	for <lists+linux-xfs@lfdr.de>; Fri,  2 Oct 2020 09:06:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726206AbgJBHGq (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 2 Oct 2020 03:06:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725948AbgJBHGq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Oct 2020 03:06:46 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBA9FC0613D0
        for <linux-xfs@vger.kernel.org>; Fri,  2 Oct 2020 00:06:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=w5q8XF9vq3qVwzpuAHuwsOOKyXKp5DbVe7LhFCLZczk=; b=LkVJwwYgs8MJOGHJmoo8kLhqTV
        Rn/5WBTAzlln17QBh6nsgw7qXmTBlYFP1DI5R3sZC5J5v0Md3yA68sdF37OGIC/M5iabtQa7GNTkQ
        ikt1kYwuAaL9THHk2CNhnUfS+SSpq1CjvtebNIDOqN2gDduDVbdaGIo2CyYVS8l/WxrbOem2gOBYs
        mpMvssGsfFj0Z+5msCxp2rMifwDTsa0N4HhpJhYuKuXD9TY47wGha5IGMGPzJ50hGopd8+/QToVwa
        PTC5Tf127vbEHhLANRH4hnmyFr77qiHVVmHZNzn+ENeXKb2e/46wgjh5cjC+srbwCENUxnwVHf4Kd
        Xsd3tBPw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kOF9Q-0000AX-Bt; Fri, 02 Oct 2020 07:06:44 +0000
Date:   Fri, 2 Oct 2020 08:06:44 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: limit entries returned when counting fsmap
 records
Message-ID: <20201002070644.GA32516@infradead.org>
References: <160161415855.1967459.13623226657245838117.stgit@magnolia>
 <160161416467.1967459.10753396346204946090.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160161416467.1967459.10753396346204946090.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 01, 2020 at 09:49:24PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> If userspace asked fsmap to count the number of entries, we cannot
> return more than UINT_MAX entries because fmh_entries is u32.
> Therefore, stop counting if we hit this limit or else we will waste time
> to return truncated results.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

(after remembering the magic repurposing of -ECANCELED in the fsmap
code)
