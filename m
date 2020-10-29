Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D16D29E7C5
	for <lists+linux-xfs@lfdr.de>; Thu, 29 Oct 2020 10:49:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726063AbgJ2JtC (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 29 Oct 2020 05:49:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725999AbgJ2JtC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Oct 2020 05:49:02 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC92DC0613CF
        for <linux-xfs@vger.kernel.org>; Thu, 29 Oct 2020 02:49:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=fIwOlg7FOjN29BA34fUg9OVMYHbpxG0NtAETaoI1qr8=; b=NIECMAZ6lzeuVnjpqpATg0oJ/1
        B2H/8HvT9hUiYNJirq2Y40dzPU5L8ha1FrEFwlq5n4Iq3AMmlt90amzXfttVMJkw+RRMEn7f+tIox
        tACeABPG+Sj5XgKnmNMuwe19pDJQuPdc+JcZVFk5m8okBDxTmcubUivZNygd4ncexDcW1bIwFq/AM
        /yxpUEzk5D5Uw1GAo+lUz99lMCvxETYd3C97UmlflELj2exr2aIbmafCtmeXQ/lXHdh+2sKLgfp/N
        YAFPo2uEiGYSYWz935bPav3pyZxm3fnQ2A9gqCeTLJbQ/7UPzRw0nGrR3sriG6NJnV2kIjJ2l5+aP
        XNDg1fXw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kY4YE-0001cQ-LU; Thu, 29 Oct 2020 09:48:58 +0000
Date:   Thu, 29 Oct 2020 09:48:58 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 18/26] libxfs: propagate bigtime inode flag when
 allocating
Message-ID: <20201029094858.GM2091@infradead.org>
References: <160375524618.881414.16347303401529121282.stgit@magnolia>
 <160375536384.881414.3371469706002982157.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160375536384.881414.3371469706002982157.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 26, 2020 at 04:36:03PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Ensure that we propagate the bigtime inode flag correctly when creating
> new inodes.  There critical part here is to use the new_diflags2 field
> in the incore geometry just like we do in the kernel.
> 
> We also modify xfs_flags2diflags2 to have the same behavior as the
> kernel.  This isn't strictly needed here, but we aim to avoid letting
> userspace diverge from the kernel function when we can.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
