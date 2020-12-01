Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 712D82C9EC2
	for <lists+linux-xfs@lfdr.de>; Tue,  1 Dec 2020 11:08:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbgLAKGt (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 1 Dec 2020 05:06:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387432AbgLAKGt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Dec 2020 05:06:49 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 263E8C0613CF
        for <linux-xfs@vger.kernel.org>; Tue,  1 Dec 2020 02:06:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=wb5WRspEI8xKaMevXNwYs/t7FgZ8DbfuW4sd9roBpU4=; b=sLntRAj8mwWpO2XQJcNlLbI7PY
        mZ41blLpLaTy8THqmuG6IWm/QrLsEkIXWaV2E2h8xm85KDglKj3BkYqMpzppFmO0qNJL59R1xuzRS
        luQBXJlQYyolobWciGNyu0cw7ihgn8IUlrGYErcQOGVsTSipL54SYN99rjna0CT/w4l48naXWBXi1
        QwkOEcwIW3F9GpQVOUoeIItxUFtfXC0/HYR9+rJhJdutChMpSTmYjgatsB8SXUYkwerImiClIJUpE
        Thq6Z0ZffzRA1QmZpPmEjRbQ8u/yAhDl1yQeuEIreQKnHbyMSh6nu3ykSziJtFi3uOg/pH1cO+kfC
        uj8Ter0w==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kk2YK-0003Da-Qr; Tue, 01 Dec 2020 10:06:32 +0000
Date:   Tue, 1 Dec 2020 10:06:32 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/10] xfs: hoist recovered extent-free intent checks out
 of xfs_efi_item_recover
Message-ID: <20201201100632.GH10262@infradead.org>
References: <160679385987.447963.9630288535682256882.stgit@magnolia>
 <160679390266.447963.18406641317021209964.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160679390266.447963.18406641317021209964.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 30, 2020 at 07:38:22PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> When we recover a extent-free intent from the log, we need to validate
> its contents before we try to replay them.  Hoist the checking code into
> a separate function in preparation to refactor this code to use
> validation helpers.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
