Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E384D11C8
	for <lists+linux-xfs@lfdr.de>; Wed,  9 Oct 2019 16:52:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731523AbfJIOwX (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 9 Oct 2019 10:52:23 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:51854 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728019AbfJIOwW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Oct 2019 10:52:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=5rfCydrfY7Ga6Jk/1+VQVtBM1yCEdCSBZh+ZaCI1cz8=; b=tjb4ugjRTb3Tps4MOZTcM02M+
        X/Fb8vf7OLWzGpjYprMYh3PpDey4nBMLIyDX6CN8XyvjTAAWt5369jyCs8aHc9XVnrrjJFURAUaX5
        Clb8jrdpsJSo1wZthfe9yxU9/Io2xnCuj5ODvgrzBZuiOjpQr4FI8Ocggzg/keHjTcUn9jjre4z9z
        ZjSus2trFl330LJZj+4aeADpurrtQOOxUps/zrRD1pD7QYgtzWXf/b91mHLMMhbblrJRYAXh9Zyvs
        +Ea3doi0WhKHenIAgN6ChMS/TAQv0c2MelUK2g0zTY3iDOWSP7Z9MUllRhRzBHJPkJLjmL4sGhoN3
        9AWlg5dcQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iIDKA-0004Qp-KN; Wed, 09 Oct 2019 14:52:22 +0000
Date:   Wed, 9 Oct 2019 07:52:22 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Ian Kent <raven@themaw.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v5 00/17] xfs: mount API patch series
Message-ID: <20191009145222.GC10349@infradead.org>
References: <157062043952.32346.977737248061083292.stgit@fedora-28>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157062043952.32346.977737248061083292.stgit@fedora-28>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 09, 2019 at 07:30:10PM +0800, Ian Kent wrote:
>  fs/super.c                 |   97 +++++
>  fs/xfs/xfs_super.c         |  926 +++++++++++++++++++++++---------------------
>  include/linux/fs_context.h |    5 
>  3 files changed, 587 insertions(+), 441 deletions(-)

I am a little worried about the diffstat.  A few more lines of code
more for a more abstract API seems fine, but +150 lines for no new
functionality is worrisome.

