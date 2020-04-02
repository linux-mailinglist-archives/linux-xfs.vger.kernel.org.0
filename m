Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1D6F19BFC0
	for <lists+linux-xfs@lfdr.de>; Thu,  2 Apr 2020 12:59:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729213AbgDBK7f (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 2 Apr 2020 06:59:35 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:42030 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728803AbgDBK7f (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Apr 2020 06:59:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Zs3jqOkqmyEutTK3/LJemzAKr6/95/4rH7ArZ16ZB/4=; b=nfbIVVxm15GSJUOaUfVTkTLHXt
        TBVU3hNtVBOFshM6tnEdInqrOSTbBOQq3/H/DiZqt5mCceeXC535sgSGKMB7j24TnJDeI4PsFDXNJ
        s1NYtwZkv2e2a0emDmleAj2uDGDe3FaQoIsQBPqu1FcqIl1fe0J5VSMQFRSzQIL9jdFqs6CQ1nrjJ
        N/NzFdrHPSzZuHg7wQcWsIA2TGPfEoQNXuPNUUjpnvM6Ja2W3oKiHdPwCh9J+T43AAXh1iNuSQkWn
        78rrQOzUaV4BHakqpOnVSeTOxKPJqVM0ZTENyK+NAehLMdM+Sim8qYfjkrsc4mjlg1PtxMNyEe96/
        Vsj27d5w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jJxZO-0006mj-P4; Thu, 02 Apr 2020 10:59:34 +0000
Date:   Thu, 2 Apr 2020 03:59:34 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org, Qian Cai <cai@lca.pw>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: fix inode number overflow in ifree cluster helper
Message-ID: <20200402105934.GA23109@infradead.org>
References: <20200402105718.609-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200402105718.609-1-bfoster@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 02, 2020 at 06:57:18AM -0400, Brian Foster wrote:
> Qian Cai reports seemingly random buffer read verifier errors during
> filesystem writeback. This was isolated to a recent patch that
> factored out some inode cluster freeing code and happened to cast an
> unsigned inode number type to a signed value. If the inode number
> value overflows, we can skip marking in-core inodes associated with
> the underlying buffer stale at the time the physical inodes are
> freed. If such an inode happens to be dirty, xfsaild will eventually
> attempt to write it back over non-inode blocks. The invalidation of
> the underlying inode buffer causes writeback to read the buffer from
> disk. This fails the read verifier (preventing eventual corruption)
> if the buffer no longer looks like an inode cluster. Analysis by
> Dave Chinner.
> 
> Fix up the helper to use the proper type for inode number values.
> 
> Fixes: 5806165a6663 ("xfs: factor inode lookup from xfs_ifree_cluster")
> Reported-by: Qian Cai <cai@lca.pw>
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
> 
> Fixes the problem described here[1]. I wasn't sure if we planned on
> fixing the original patch in for-next or wanted a separate patch. Feel
> free to commit standalone or fold into the original...

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
