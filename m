Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29C3A1957A3
	for <lists+linux-xfs@lfdr.de>; Fri, 27 Mar 2020 14:00:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727185AbgC0NAG (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 27 Mar 2020 09:00:06 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:45714 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726742AbgC0NAG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 27 Mar 2020 09:00:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=WValxPeh5BGdhfjCY0b6yHa0lnjU6Qhlu+8aLnwZzlU=; b=S/JDepgypfKkDO+h/F/HRxCzDb
        08PiHpKb6VvQJ+r2ne2MFZcELKu1Ce2PbKba1Z2iz14LiY3DJ0yFUkSkLBzCg3uS9CEoyGK8AvVC8
        kgBovA27LGlGvhVarYXQovK2MCRfKlO3ChBmH+DAlntkMu8y2BeGpWBi+PzJFmP+BnsUYIqlQFiaz
        bF6g2CqMentsF4nRjd5V9fyQ3rzBJO9PkPQOt9+Xrn/3RqDrbU0zgt7cIN6+WSOJa5Wop25I+Z2pk
        W/I6sdt2494BmO7fs3xP0rDgvdk/zaF+2wSpA5s5c4/kZS9D7JPj7noessflLaDNezPIjqUCJYiVF
        3UW9JPNw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jHoak-0006GQ-EC; Fri, 27 Mar 2020 13:00:06 +0000
Date:   Fri, 27 Mar 2020 06:00:06 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: return locked status of inode buffer on xfsaild
 push
Message-ID: <20200327130006.GB20273@infradead.org>
References: <20200326131703.23246-1-bfoster@redhat.com>
 <20200326131703.23246-3-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200326131703.23246-3-bfoster@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 26, 2020 at 09:17:03AM -0400, Brian Foster wrote:
> If the inode buffer backing a particular inode is locked,
> xfs_iflush() returns -EAGAIN and xfs_inode_item_push() skips the
> inode. It still returns success to xfsaild, however, which bypasses
> the xfsaild backoff heuristic. Update xfs_inode_item_push() to
> return locked status if the inode buffer couldn't be locked.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
