Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21DF72A4ED0
	for <lists+linux-xfs@lfdr.de>; Tue,  3 Nov 2020 19:27:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725892AbgKCS1X (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 3 Nov 2020 13:27:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725385AbgKCS1X (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Nov 2020 13:27:23 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E9D4C0613D1
        for <linux-xfs@vger.kernel.org>; Tue,  3 Nov 2020 10:27:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=iCyH5/I5IbKOm3edZo0z2LLPuxNnEKiTJyyU8xyBohg=; b=Dl701eA7B75VOBIJHMTNggtgoZ
        +SvfYuMh4cLd9qa2JD8YMWGhBoXbgRK3S34iILov1kQGGFxq7AFA/lNblAaT95WHBjPoUpOBAxcP1
        d2ypdD4W6QNagvPdJ4si7wvUtTKLVjyM3WXPVsVG8ELViU/eKGBnIRNmzoGNHYNY+O7iw1qocbXFS
        VnhAvG4vXuILsAOh5a9EjI6ILarIFROeqBOMT94O/6ikDrpPO1jfdySOJK4Y34UWGfc/VlhJZdlkQ
        PfHgYG9Y71ehaQoNosFD0g/29GCjqprnf1DewcJT2EdcPYa7+TTgCNaZfwWz2EkFwUe7vdmeiLGXc
        J4hXa57A==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ka11d-0003py-IY; Tue, 03 Nov 2020 18:27:21 +0000
Date:   Tue, 3 Nov 2020 18:27:21 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: fix scrub flagging rtinherit even if there is no rt
 device
Message-ID: <20201103182721.GA14636@infradead.org>
References: <20201103172827.GE7123@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201103172827.GE7123@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 03, 2020 at 09:28:27AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The kernel has always allowed directories to have the rtinherit flag
> set, even if there is no rt device, so this check is wrong.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
