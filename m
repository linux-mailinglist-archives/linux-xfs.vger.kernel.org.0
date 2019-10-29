Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3035BE896E
	for <lists+linux-xfs@lfdr.de>; Tue, 29 Oct 2019 14:26:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388486AbfJ2N0r (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 29 Oct 2019 09:26:47 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:43910 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726858AbfJ2N0r (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Oct 2019 09:26:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=u5/HxIXUvUpuJq2nsI+hGtxnd2Gr+/Y7spIGiC9DVPM=; b=oSqYuRuhSAmQX7M3pHNQsxjtr
        nZhGfLtYuctrYDbUimC1rfN0NpcOzZaWUHYxgpYbeiDi/1GBzpZ0Ze85a7y16+KQeLHZEItiRHafB
        Usbf72eKg2qYHfRcHLkKHXR35HIO31d9qoc0AmtfKWp+XnwPlOi2g6WLDI9GhX7NJ7s9B8ssfAVGS
        QB7502Qmbz01Buwkim2C0jNSvhINFV/nfgxZTCJzwcGGvdcEjlYJ6kzLx82n5cK5VWL8b93D+iw90
        HLFn/nsUPkkAY+re1jb4yjYGMztpo4NKkIdoltWOE49YoV5OHDmtw1pFjSlpmAzNa7IcwDJw2KPE9
        xzmUEOQrg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iPRWI-0001Nq-He; Tue, 29 Oct 2019 13:26:46 +0000
Date:   Tue, 29 Oct 2019 06:26:46 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Eric Sandeen <sandeen@redhat.com>,
        linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs_growfs: allow mounted device node as argument
Message-ID: <20191029132646.GA5180@infradead.org>
References: <0283f073-88d8-977f-249c-f813dabd9390@redhat.com>
 <20191029071536.GA31501@infradead.org>
 <6a30d8d1-8786-f7cd-f897-d4d6d6f517f5@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6a30d8d1-8786-f7cd-f897-d4d6d6f517f5@sandeen.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 29, 2019 at 08:24:50AM -0500, Eric Sandeen wrote:
> 
> 
> On 10/29/19 2:15 AM, Christoph Hellwig wrote:
> > On Mon, Oct 28, 2019 at 10:23:51PM -0500, Eric Sandeen wrote:
> >> I can clone tests/xfs/289 to do tests of similar permutations for
> >> device names.
> > 
> > Can we just add the device name based tests to xfs/289?
> 
> Could do, I was hesitant to make a once-passing test start failing on older
> userspace. (maybe we should formalize a policy for this sort of thing)

Well, it is supposed to work for all but one release, right?
