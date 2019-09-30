Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABFF6C1C99
	for <lists+linux-xfs@lfdr.de>; Mon, 30 Sep 2019 10:11:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728310AbfI3ILi (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 30 Sep 2019 04:11:38 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:49196 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725767AbfI3ILi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Sep 2019 04:11:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=szzzMveuiEPlopBdtgZzocMqxlnMoIgiwMzhT24NSV0=; b=lD8Djxw3mpoI5R+ysv4MjGrkO
        RPfNbFCjpO5BZ9QRvIjIenYK4I4wwP3zLPtq499oRLQ/7Vzt+Gx3FY0hUWRAJ4NJLvgnu5fbCNNLL
        Hg9tbDQz62cqmJAmJG4AGyBzKDkcSRHb4dYzjz7SGoVJDtIg1dqs5hKQXrNXrfZBQLxM9HFCzdTkK
        Z6190+RbZRtgP/1UY/Ax1aUKvzvrRWEFML3dHTTyhzda/UPg4+7FQwvf81lFxdy217f4IepgA6uHf
        UkiiN6xqV28kkeHeNCx4JggS5kys5grCvIrrISsqjYNClH3qvXb6O7QvGVbUXdGLELSLLQ73hWW8X
        u+xIeG1AQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iEqmQ-0001J9-FZ; Mon, 30 Sep 2019 08:11:38 +0000
Date:   Mon, 30 Sep 2019 01:11:38 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v5 01/11] xfs: track active state of allocation btree
 cursors
Message-ID: <20190930081138.GA2999@infradead.org>
References: <20190927171802.45582-1-bfoster@redhat.com>
 <20190927171802.45582-2-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190927171802.45582-2-bfoster@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Sep 27, 2019 at 01:17:52PM -0400, Brian Foster wrote:
> The upcoming allocation algorithm update searches multiple
> allocation btree cursors concurrently. As such, it requires an
> active state to track when a particular cursor should continue
> searching. While active state will be modified based on higher level
> logic, we can define base functionality based on the result of
> allocation btree lookups.
> 
> Define an active flag in the private area of the btree cursor.
> Update it based on the result of lookups in the existing allocation
> btree helpers. Finally, provide a new helper to query the current
> state.

I vaguely remember having the discussion before, but why isn't the
active flag in the generic part of xfs_btree_cur and just tracked
for all types?  That would seem bother simpler and more useful in
the long run.
