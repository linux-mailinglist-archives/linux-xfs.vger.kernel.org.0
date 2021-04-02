Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A94613526B8
	for <lists+linux-xfs@lfdr.de>; Fri,  2 Apr 2021 08:49:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231207AbhDBGs7 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 2 Apr 2021 02:48:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbhDBGs7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Apr 2021 02:48:59 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBAB5C0613E6
        for <linux-xfs@vger.kernel.org>; Thu,  1 Apr 2021 23:48:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M2rmiF1PXbh7VOlM+swBFn9SLo4OfoGQqWt9G752Eos=; b=kPKelNCXKziQVrevZfZLjKzNet
        DeNUoc4XXy0YLRh4YuGtdZlL5xoZL27I1XmJ3tCFcAGH1f0H4/5ayxD0wU9SkcQx2IbtExi0WLE4Y
        tSHvxIolLbs3EygDISd5M6fE4Pr7uoAL3+jsuunEYmF63TpiOXP6Y/fLE3CyYoi1Bli/KrZt62H6W
        RjiTLI6PAYAD1vP969CgcL6EEXSguyYZdhehOFIIRljTm8aHX/Oss9tH2e0xLFCHmd9LlwEQ+iNtr
        TieRg2xKjpzAn25FInBgF3cmwVSdrgW5lJnebUQsTqarH31F5BGaTAWMjmAibM98ndb1s3SJZycVL
        CSicwjNQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lSDbs-007Iue-SL; Fri, 02 Apr 2021 06:48:50 +0000
Date:   Fri, 2 Apr 2021 07:48:48 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs: eager inode attr fork init needs attr feature
 awareness
Message-ID: <20210402064848.GE1739516@infradead.org>
References: <20210330053059.1339949-1-david@fromorbit.com>
 <20210330053059.1339949-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210330053059.1339949-2-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 30, 2021 at 04:30:56PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The pitfalls of regression testing on a machine without realising
> that selinux was disabled. Only set the attr fork during inode
> allocation if the attr feature bits are already set on the
> superblock.
> 
> Fixes: e6a688c33238 ("xfs: initialise attr fork on inode create")
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
