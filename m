Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F22F2583DE
	for <lists+linux-xfs@lfdr.de>; Thu, 27 Jun 2019 15:52:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726942AbfF0Nwc (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 27 Jun 2019 09:52:32 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:47824 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726370AbfF0Nwc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Jun 2019 09:52:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=0y2co1VtuxLtMunicbtPfuwjgsotxyaSHzNDNuerVo8=; b=eeUqC7Ve8Xb/qAFsrHqClbMU6
        DZqThUX2x9UJ6jKy5pgAgPxueD/kNHyHgYSfZZgdpRXYbjVr5y5u1Qph2fGwHas1kECz5SRU4nEgn
        /bGmDmgaODaRZchFEJSUoqToDvz9GRJNNE3Nk3+gaSmIiJJ2nA5lrojBSYbPSlp/d4vIrolvmrf2z
        DZdS9a3XaofxCos7TJu3pUpFLcoT4Gojob3n3AApUFNrHs60C6TiYWqUNbREjqUyr3nLDrXOXkBek
        RZr2ZCjuNFt8QRh/OmfI58prGws+ZCls6SOoa/rRuvvQl4zpBvIur2Ku0H7OF/ka2vyxyhW0iHSOL
        iyY487GKg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hgUp7-00069z-Rw; Thu, 27 Jun 2019 13:52:25 +0000
Date:   Thu, 27 Jun 2019 06:52:25 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     syzbot <syzbot+b75afdbe271a0d7ac4f6@syzkaller.appspotmail.com>
Cc:     darrick.wong@oracle.com, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: KASAN: use-after-free Read in xlog_alloc_log
Message-ID: <20190627135225.GA22423@infradead.org>
References: <000000000000783d99058c489257@google.com>
 <20190627110654.GA13946@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190627110654.GA13946@infradead.org>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 27, 2019 at 04:06:54AM -0700, Christoph Hellwig wrote:
> It seems like this is the xlog_alloc_log error path.  We didn't
> really change anything in the circular ioclogs queue handling, so
> maybe thish has been there before, but xfs_buf wasn't wired up to
> kasan to catch it?
> 
> Either way I suspect the right thing to do is to replace the list
> with an array based lookup.  I'll look into that, maybe a reproducer
> appears until then.

Actually, the iclog allocations are obviously too small.  A patch will
be on its way soon.
