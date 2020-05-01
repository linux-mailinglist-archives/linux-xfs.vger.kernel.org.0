Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0D181C0EF6
	for <lists+linux-xfs@lfdr.de>; Fri,  1 May 2020 09:43:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728297AbgEAHnP (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 1 May 2020 03:43:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728253AbgEAHnP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 May 2020 03:43:15 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E472C035494
        for <linux-xfs@vger.kernel.org>; Fri,  1 May 2020 00:43:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=I+fxtrnqm5PDhBufdZyYx82e7IuB6qGi1tOk86HP8Dw=; b=TMlYJZWQcyj+uxGox1BlTISkg8
        36UPFzLeZXNYHxB+5oRRHBZ9TgCgzGd5qBsc533734wbKHr71oUe3OY8aFxHUtL+0Z7wYlaZo8DWC
        5S3oCqP4hn5Lsu4vyerI6hOHG0FDVCMvSVsZGpD15/Nkn1MntAvpuYUjQuF7H3rkXcLlcF1UiOe9Y
        c2fgD/rQP/18wMhaxHSS/f1HFPA7XQwtX1tzqqZQ2a2SJ96IXMdciMMYOneezhi1Gkq/4q2MRJxSa
        fnrnpL9mbWO92EDpRxQbRNoRUBSfskkQ8fUbqJSRpQmpdSzEKkU5/xnMXtXbnrEOztYdf8vLr9xvC
        9Zvvm8dQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jUQKG-000869-1R; Fri, 01 May 2020 07:43:12 +0000
Date:   Fri, 1 May 2020 00:43:12 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 02/17] xfs: factor out buffer I/O failure code
Message-ID: <20200501074312.GA29479@infradead.org>
References: <20200429172153.41680-1-bfoster@redhat.com>
 <20200429172153.41680-3-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200429172153.41680-3-bfoster@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 29, 2020 at 01:21:38PM -0400, Brian Foster wrote:
> We use the same buffer I/O failure code in a few different places.
> It's not much code, but it's not necessarily self-explanatory.
> Factor it into a helper and document it in one place.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Allison Collins <allison.henderson@oracle.com>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

Still no fan of the "simulate", but otherwise this looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
