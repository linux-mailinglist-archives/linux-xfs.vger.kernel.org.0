Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 371813B9DC9
	for <lists+linux-xfs@lfdr.de>; Fri,  2 Jul 2021 10:54:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230479AbhGBI53 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 2 Jul 2021 04:57:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230166AbhGBI52 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Jul 2021 04:57:28 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 795AEC061762
        for <linux-xfs@vger.kernel.org>; Fri,  2 Jul 2021 01:54:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=H1pao3tEyZOPSi2l2aSJpblmmqgeR7aXubASc6aHDMs=; b=NL0MYBYbJYL61nKdW/0+5NCmDC
        S1BZAVUnWmgmnV+tIG5MYrq5pcWzkN9KaB/9w2+Z9Q3ylO28o1uezx1oLCvHcpG2nJCLM0pvnJt0R
        CFKnvs8uMVdhfd4vIO4942tqf/3OHrhFQk627qripcvwJOQSo9/P3EXMtKR61qPnFCncjVKNlTlmz
        /rowqLnIhNiXBejqnfH8vBNH3blxNEA1iLjXxfgckUaAGCo1rIobAvck9LwAwpqr8UEEx2rRDisvr
        xcTTwo5XQSEtD9KixZbGCcIxYnCQs0I21/n3frAPbb9gL1rmOm7vcSCUW8h2l+trURX+07k0wvTVm
        M6OgMP5A==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1lzEwB-007XEz-8w; Fri, 02 Jul 2021 08:54:26 +0000
Date:   Fri, 2 Jul 2021 09:54:15 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/5] xfs: move xlog_commit_record to xfs_log_cil.c
Message-ID: <YN7UNwJjqDAEsd4P@infradead.org>
References: <20210630072108.1752073-1-david@fromorbit.com>
 <20210630072108.1752073-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210630072108.1752073-2-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 30, 2021 at 05:21:04PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> It is only used by the CIL checkpoints, and is the counterpart to
> start record formatting and writing that is already local to
> xfs_log_cil.c.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
