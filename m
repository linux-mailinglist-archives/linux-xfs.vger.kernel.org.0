Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E16A016B3C5
	for <lists+linux-xfs@lfdr.de>; Mon, 24 Feb 2020 23:21:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727843AbgBXWVV (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 24 Feb 2020 17:21:21 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:43408 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727400AbgBXWVU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Feb 2020 17:21:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=WOERrC+DLjQBwVUJMl3L/x9Dz/rIPYdVOI3zI5VQ+To=; b=sR010A5KtpD7apboMMEb4QHWi2
        3aPGGk77tBwoCMZNGS8xTXFUlmTiBJ1FWgmSRVLlnAtXzTl5WsSHINtb6wesUtgwCIA4wYjAvfWcG
        SgHNXjyIy3s/yFwnCm4+44TRKy3oZ2cvdOET5itP9Y5jhrArfYxr+wuvCifWnu9yH01q0CErs+FQg
        WepiXgPoxLE3Y3/MBXs01xxNCU9wAhqGrGgZOs5QTFDp8XQwF8iql6ibo5bL8bxYO9rdVOwWLBkXG
        A79j503mC8ti1IrVmglKnBxNxIyF1bR2PQEI3cT64t6w3StD/tr3e/332XQCktAp6QRn8Z9El1i2s
        CkfmtsgA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j6M6I-0001Rv-Nf; Mon, 24 Feb 2020 22:21:18 +0000
Date:   Mon, 24 Feb 2020 14:21:18 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 1/6] xfs: remove the agfl_bno member from struct xfs_agfl
Message-ID: <20200224222118.GA681@infradead.org>
References: <20200130133343.225818-1-hch@lst.de>
 <20200130133343.225818-2-hch@lst.de>
 <20200224220256.GA3446@infradead.org>
 <20200224221931.GA6740@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200224221931.GA6740@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 24, 2020 at 02:19:31PM -0800, Darrick J. Wong wrote:
> > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > 
> > Any chance we can pick this up for 5.6 to unbreak arm OABI?
> 
> Yeah, I can do that.  Is there a Fixes: tag that goes with this?

I'm not sure what to add.  I think the problem itself has actually
always been around since adding v5 fs support.  But the build break
was only caused by the addition of the BUILD_BUG_ON.

> Also, will you have a chance to respin the last patch for 5.7?

Last patch in this series?
