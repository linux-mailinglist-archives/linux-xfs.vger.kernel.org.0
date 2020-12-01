Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A97FF2C9E97
	for <lists+linux-xfs@lfdr.de>; Tue,  1 Dec 2020 11:04:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729030AbgLAKED (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 1 Dec 2020 05:04:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725912AbgLAKED (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Dec 2020 05:04:03 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 503D3C0613D3
        for <linux-xfs@vger.kernel.org>; Tue,  1 Dec 2020 02:03:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=pFnqZmC6osdjRNkoYXd/Bc/q2vkpZX6g1nmR7lEDszs=; b=bdj4KVUi7a9K8nezuu98qkcOzx
        XIRWhSFkwFf7flFPpZhXjwxA9wk5isV/0ZHkyNA0FdRZ787WUFyChpl9KOWiAVMAPXEnxCTozmA5p
        1URxmbpWeCpU064Q8APUDkutyptlkaYFyxdozm8LCJPi8wRPPtqlZSYhctQ/+p3m/A+tvPCdJgO11
        +eTDAtbQ/moIb9DOI1IRhoDwyLxPci5TBPaaNgWtEFYn1YUp6hH4kErX2OcCXWzEM/1cEcCRWiA7U
        omWOxuosixgsvTsShMWW/LXa5/5U4mpVNjBVUs8V7L9pLt9SlaxvGg9/QdqtFJiqfrjJu2jid2QT8
        Y25Ce3XQ==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kk2VG-0002rq-2J; Tue, 01 Dec 2020 10:03:22 +0000
Date:   Tue, 1 Dec 2020 10:03:22 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/10] xfs: improve the code that checks recovered bmap
 intent items
Message-ID: <20201201100322.GC10262@infradead.org>
References: <160679385987.447963.9630288535682256882.stgit@magnolia>
 <160679387231.447963.15156459924591469631.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160679387231.447963.15156459924591469631.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 30, 2020 at 07:37:52PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The code that validates recovered bmap intent items is kind of a mess --
> it doesn't use the standard xfs type validators, and it doesn't check
> for things that it should.  Fix the validator function to use the
> standard validation helpers and look for more types of obvious errors.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
