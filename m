Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C733F54C78
	for <lists+linux-xfs@lfdr.de>; Tue, 25 Jun 2019 12:40:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728289AbfFYKkX (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 25 Jun 2019 06:40:23 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:57120 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726756AbfFYKkX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Jun 2019 06:40:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=ExsP9pNR6iVSbcTFqJ4b1xXX7H8L1kYRY1mLUzLMTDQ=; b=ooI2XJVap8b/F4K12ESUC3LnQ
        4Jbel3tgo0IY+UN/wESz0jcHxWVEhD1ldSC6c6qoMn3tB5O336sXz1v+BbqB95xYc2F8ZUwwznxvl
        vVb3BfbXnvowErIk6Vwe3jtNDnlntw/ostRgXvn2i9xI6dPfHghoFs+gIpHrE+KR3gOdgq8ixyYhs
        YmTWXQ8h5R5cE1CjfQCrTl7FLRPW8SgqY5cSITiO4T/uNGm3A5HK9TQhQ2iLLwncPyJm6hQZ7ny3z
        5OSYU02wj+R/zGEuNTnzIQKJehSIYxqTNDkeADBIsF7hJFtY/krq6NonJXpRZ1tK8Hb/u41RmMhwj
        o/ystgkcA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hfisB-0003EB-17; Tue, 25 Jun 2019 10:40:23 +0000
Date:   Tue, 25 Jun 2019 03:40:23 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/6] libxfs: fix buffer refcounting in delwri_queue
Message-ID: <20190625104022.GF30156@infradead.org>
References: <156114701371.1643538.316410894576032261.stgit@magnolia>
 <156114704472.1643538.14565976860288969023.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156114704472.1643538.14565976860288969023.stgit@magnolia>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 21, 2019 at 12:57:24PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In the kernel, xfs_buf_delwri_queue increments the buffer reference
> count before putting the buffer on the buffer list, and the refcount is
> decremented after the io completes for a net refcount change of zero.
> 
> In userspace, delwri_queue calls libxfs_writebuf, which puts the buffer.
> delwri_queue is a no-op, for a net refcount change of -1.  This creates
> problems for any callers that expect a net change of zero, so increment
> the buffer refcount before calling writebuf.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
