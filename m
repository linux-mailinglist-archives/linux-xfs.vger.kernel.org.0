Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6421FEB0D
	for <lists+linux-xfs@lfdr.de>; Sat, 16 Nov 2019 08:02:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726034AbfKPHCg (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sat, 16 Nov 2019 02:02:36 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:39164 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725971AbfKPHCg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 16 Nov 2019 02:02:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=S+YmFZQQ1ZAuPWnQWLCTfvm5cWsVH5WY6TA7arkxGRc=; b=KwpAGjBbezUfepIzlPuf0YspC
        8MGojThcriOpL86j585zU9OHJWxcGXKyIzSyOlkCWhL5qG0IS22/a/2XQKjjv4NhK3cDm5AFt2dIv
        1NqPrz5DMGmiVspowl3Ix8jy+3jkDkM/NN1b6fJ2I1KWTincwYgAkyw8u/p4J59002NSsQPyqUAiO
        MGTqlfcN8zM50QoFXPnAQgczBHrZOOIFPt3TgkMNpdT7KW2glbcz5k3RckfVzLFhCoL2OCln16em0
        fIE41rYU7otrnMoeCxYPo5d6bz5HvcUF/K4MnZGyiARHL8GZxrKWZDYpCny6M6LWXV5hAE6X4QkPK
        JOP4IF2jg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iVs6O-0000t0-6U; Sat, 16 Nov 2019 07:02:36 +0000
Date:   Fri, 15 Nov 2019 23:02:36 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [ANNOUNCE] xfs-linux: for-next updated to f368b29ba917
Message-ID: <20191116070236.GA30357@infradead.org>
References: <20191114181654.GG6211@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191114181654.GG6211@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

FYI, this crash for me in xfs/348 with unfortunately a completely
garbled dmesg.  The xfs-5.5-merge-11 is fine.
