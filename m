Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A71A733D00A
	for <lists+linux-xfs@lfdr.de>; Tue, 16 Mar 2021 09:42:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234166AbhCPIlu (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 16 Mar 2021 04:41:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234203AbhCPIl3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Mar 2021 04:41:29 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB21BC06174A
        for <linux-xfs@vger.kernel.org>; Tue, 16 Mar 2021 01:41:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=+1yiN4vOPoP27bQ9RQd9HUsL0TT96pW2bn8gEDGtQ68=; b=n5whfbSAJgcxCS8oczFhG0h/a0
        IHOMwv6tX38f4+NdmPGRpu9Kgmwl/EjkAZ46hyf0DE1hFON1sRGi5XLmP4levogQE0J3BLtSi02Ce
        lScBEYyPJA15EWRx1EC6uKH+ASW5j4RBD0jNtCmxfFa52G0or4tdj0x8s97GcYI8P7/ah0zDjT49/
        pnpKqfgfuzkT8qcrm4gc1uYWzBHbmqtfZYdA0aUh9bQbMRmySw4+WhjbixOUYWVHzSdJhLzS0mJYZ
        EXqWYe0oMrfHXGEnt+CEXVevHOW4ek8qks4HfptXXE2jHXo15+q8/0zbbXSmcyVfEdQog8hJH+jA6
        Pnzagb+w==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lM5GF-001fyE-SS; Tue, 16 Mar 2021 08:41:11 +0000
Date:   Tue, 16 Mar 2021 08:41:07 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/45] xfs: remove xfs_blkdev_issue_flush
Message-ID: <20210316084107.GC398013@infradead.org>
References: <20210305051143.182133-1-david@fromorbit.com>
 <20210305051143.182133-5-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210305051143.182133-5-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 05, 2021 at 04:11:02PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> It's a one line wrapper around blkdev_issue_flush(). Just replace it
> with direct calls to blkdev_issue_flush().
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
