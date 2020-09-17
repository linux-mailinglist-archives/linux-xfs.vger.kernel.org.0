Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6078726D551
	for <lists+linux-xfs@lfdr.de>; Thu, 17 Sep 2020 09:55:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726311AbgIQHzV (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 17 Sep 2020 03:55:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726192AbgIQHyx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Sep 2020 03:54:53 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD47DC06178A;
        Thu, 17 Sep 2020 00:54:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=yB20x5tJe8JnJKkFoAi+8QgoBdkpHcMtc637MCKZ02E=; b=atUfNXrfsrOtATbpZ68hVCIQuK
        EdfCiUsEHt4dDIa0g1yCVprRGFra+igamgzQYKeF/uSkEidnIsP/Z6ZSGuxRQXGlSi/Dwq+x/ne3a
        lia7c9Q4HH2OXMdXsjbpjN8kY1Bg9JLZeNcfLlEtCK8Yju6RXgOjRZfYN9tApWsRiwt7R8yK48FCm
        SIXEr4AotGM07uvhHEdBRnV4YMZ1pfKOVBBhgHoh23ArZfXKb9nAdPJHKrGJrXDlT20htT0lSa4s1
        2Li3RaMGNDrsB1b3WiqRi1zxiudPjx0RAOeQyMsd6ziDwmrIZwJflRBVU0rAzNikiPs3GB7imb0i+
        pSQ7xHFg==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kIokE-0007BC-NK; Thu, 17 Sep 2020 07:54:18 +0000
Date:   Thu, 17 Sep 2020 08:54:18 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 06/24] xfs: wrap xfs_db calls to the test device
Message-ID: <20200917075418.GF26262@infradead.org>
References: <160013417420.2923511.6825722200699287884.stgit@magnolia>
 <160013421410.2923511.10970678307725348190.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160013421410.2923511.10970678307725348190.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 14, 2020 at 06:43:34PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Create a _test_xfs_db analogue to _scratch_xfs_db so that we can
> encapsulate whatever strange test fs options were fed to us by the test
> runner.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
