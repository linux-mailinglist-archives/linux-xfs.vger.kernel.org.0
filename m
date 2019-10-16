Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DE87D8AF9
	for <lists+linux-xfs@lfdr.de>; Wed, 16 Oct 2019 10:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729246AbfJPIaX (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 16 Oct 2019 04:30:23 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:47734 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726092AbfJPIaX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Oct 2019 04:30:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=map2CSAxFpD7a4ffh6P4y2wsNZUnlOG8b0FIcKmzVUE=; b=gHr/hsI6JEiQpouPoyM8q4aYH
        87+Qb2Am4LvFTqHOa1CgrhHYjruw58tFPgHjVPXqn6nUb62zTTfyC8XySlQCqnEuWefnJZN9OWbzS
        /d6Npx3ZKytKZypQYl+mPuJK2v2OehJMXtheAtYkChIkCxQ1XK/cjck5RVyc4M/b4DSavLqmXN6Cj
        W7ogJ89tR1wM5/FBXLRHeLRb7XUfksEkDfVBTkGhbPxCVNleVGo6wh7Z/P3PXwhXa1KuyL+AZ9div
        1O1wQ7XwJdtVGGs7ENTD4CDQ5k2A0e1VC6yTc8TLo4dWMST0GMI2h4g+StBrcDfIByRkLTpfE6KKx
        e/LJXaIrw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iKehK-0003R1-Fg; Wed, 16 Oct 2019 08:30:22 +0000
Date:   Wed, 16 Oct 2019 01:30:22 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Ian Kent <raven@themaw.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v6 06/12] xfs: add xfs_remount_rw() helper
Message-ID: <20191016083022.GE29140@infradead.org>
References: <157118625324.9678.16275725173770634823.stgit@fedora-28>
 <157118647366.9678.14061368527967040009.stgit@fedora-28>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157118647366.9678.14061368527967040009.stgit@fedora-28>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> +	xfs_sb_t		*sbp = &mp->m_sb;

Please use the underlying struct types instead of the typedefs for all
new/modified code.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
