Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8781A71D67
	for <lists+linux-xfs@lfdr.de>; Tue, 23 Jul 2019 19:08:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733035AbfGWRIo (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 23 Jul 2019 13:08:44 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:58088 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726513AbfGWRIo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Jul 2019 13:08:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=cMpaYkU8GOyUcrbIHWZ/OKR5ijTl7MjDuUm+91i9cjg=; b=qDTsloAKK4oCbjtiQpBPj/xxO
        ibUSmiQvECjd672eKtOch/QbFkvU1ks3tfY6Vt7a5byiN8o+tx9y80+28dUd83Wgrc1y9FHxcQUgl
        SJ5CRPXVNDSdUBSCM0SM8vul/lDRbSe3Wrr1WmdS4kOtJOr/PduC3GDBSBbFmqECke45Xn9iz02BB
        pX7xXf7uha9SawtmztEczfPzZ7MqPxuuAE+4bMgRlEBOMwHD7MzUND/GWMY/NkEp8Jvs79XsCPiuW
        cg++fmr6pfRm8gHeQllAAWNM4F09UCZBsXWpaw5z766Ylq886rnwgItAIWKcOZWilqL2AmP0SdtN9
        3BXL9V+jw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hpyHL-0000rq-C2; Tue, 23 Jul 2019 17:08:43 +0000
Date:   Tue, 23 Jul 2019 10:08:43 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] xfs: Do not free xfs_extent_busy from inside a spinlock
Message-ID: <20190723170843.GA1952@infradead.org>
References: <20190723150017.31891-1-cmaiolino@redhat.com>
 <20190723151102.GA1561054@magnolia>
 <20190723153133.wqt3p3dqaghxbkpr@orion.maiolino.org>
 <20190723155135.GA16481@infradead.org>
 <c2f3542bd06860ecf33f1785b9c146a09a155bf7.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c2f3542bd06860ecf33f1785b9c146a09a155bf7.camel@kernel.org>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 23, 2019 at 01:07:00PM -0400, Jeff Layton wrote:
> Note that those places are already broken. AIUI, the basic issue is that
> vmalloc/vfree have to fix up page tables and that requires being able to
> sleep. This patch just makes this situation more evident. If that patch
> gets merged, I imagine we'll have a lot of places to clean up (not just
> in xfs).
> 
> Anyway, in the case of being in an interrupt, we currently queue the
> freeing to a workqueue. Al mentioned that we could create a new
> kvfree_atomic that we could use from atomic contexts like this. That may
> be another option (though Carlos' patch looked reasonable to me and
> would probably be more efficient).

The point is for XFS we generally only use kmem_free for pure kmalloc
allocations under spinlocks.  But yes, the interfac is a little
suboptimal and a kmem_free_large would be nicer and then warnings like
this that might be pretty useful could be added.
