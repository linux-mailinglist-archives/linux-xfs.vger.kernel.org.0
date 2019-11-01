Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99544EC72C
	for <lists+linux-xfs@lfdr.de>; Fri,  1 Nov 2019 18:01:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729204AbfKARBz (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 1 Nov 2019 13:01:55 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:49886 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729197AbfKARBz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Nov 2019 13:01:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=zA/jos8C9vufvG4So90HoCfS5s/7vwa6Xng+MDdZ2WU=; b=XbUISd9aeZxjRnYJBQC97sqW8
        2cqI1hSOQOXXfgP5Z0uDs4YCtDkObmpyTO1+XUgAX6igkQGH92dRqmgLI6DWagoxE+VKRW2kNyJQg
        21uN5J/wJVHG8xreTalZuu8ezwBilZTAvcdq6rWV9vJvqDQA8mJPVxkPk9lORfrBurrNyHV28AXGt
        F8gmKFDdMLgOJWz9RFb6heppTBi8CqXupDoMdZ4cxGOBL+Py/CzeuYU3XHKL5aktQBArahIeW+GZV
        IrCm41FIPur/jtQ5Yf0dxPVD4ewidk8SHhnkvmeSJnfs+fnhuj0fKoFAVsGC62fjUYzY4eNiPqLfv
        acWI19gVw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iQaJ6-0007Qo-Pn; Fri, 01 Nov 2019 17:01:52 +0000
Date:   Fri, 1 Nov 2019 10:01:52 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Ian Kent <raven@themaw.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v8 03/16] xfs: dont use XFS_IS_QUOTA_RUNNING() for option
 check
Message-ID: <20191101170152.GA28495@infradead.org>
References: <157259452909.28278.1001302742832626046.stgit@fedora-28>
 <157259461351.28278.7899654768801700302.stgit@fedora-28>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157259461351.28278.7899654768801700302.stgit@fedora-28>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 01, 2019 at 03:50:13PM +0800, Ian Kent wrote:
> When CONFIG_XFS_QUOTA is not defined any quota option is invalid.
> 
> Using the macro XFS_IS_QUOTA_RUNNING() as a check if any quota option
> has been given is a little misleading so use a simple m_qflags != 0
> check to make the intended use more explicit.
> 
> Also change to use the IS_ENABLED() macro for the kernel config check.
> 
> Signed-off-by: Ian Kent <raven@themaw.net>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
