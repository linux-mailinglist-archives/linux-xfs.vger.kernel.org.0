Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0DA013D6BF
	for <lists+linux-xfs@lfdr.de>; Thu, 16 Jan 2020 10:24:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730161AbgAPJYP (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 16 Jan 2020 04:24:15 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:40780 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726684AbgAPJYP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jan 2020 04:24:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=PrIe6nMfaoJIv4p+WEqp/9XzMuDQbFdgjAphOjDz3Gg=; b=BBJYU3pDn/ztKOKc1dOao5fLA
        +JqGxTLjO/aA85BPrxVtKA3f5wH5/GEtFGu4ecgC/CJ3j2j6w+QPbwBhqcvMIijjsttBoob3cbdp2
        sawmerngI5Px6bIH7jYjscxvUvFgul+85vWq6QRQaZHSp5oo89t4wePhNntidRMzRknl/8IBAVkqz
        E9By0qwAaxBV90LTGYP10Srya2/Em/HmYnhXWzNGWpHlV8wLvRWo2q2ECy5p8eRKnxL9AVrVwsMPy
        GH8Gahy+QjrLPda6ZWoCkjcucq8UXvT4GtZZTRe8wlUIeV8DIOvsdu0TSeDIcdOWiAVfHAmllb8tX
        fHnCXh22A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1is1Nu-00066S-Q3; Thu, 16 Jan 2020 09:24:14 +0000
Date:   Thu, 16 Jan 2020 01:24:14 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 3/7] xfs/507: skip if we can't create a large sparse file
 for testing
Message-ID: <20200116092414.GC21601@infradead.org>
References: <157915143549.2374854.7759901526137960493.stgit@magnolia>
 <157915145418.2374854.11482414938923072334.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157915145418.2374854.11482414938923072334.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 15, 2020 at 09:10:54PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Skip this test we can't create the large sparse file needed to test
> overflows.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
