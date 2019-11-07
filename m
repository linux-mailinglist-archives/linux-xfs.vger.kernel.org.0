Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37E32F2966
	for <lists+linux-xfs@lfdr.de>; Thu,  7 Nov 2019 09:42:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387541AbfKGImG (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 7 Nov 2019 03:42:06 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:33406 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387441AbfKGImG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Nov 2019 03:42:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=F0DqqDeRNQKi5/dpAxu8YGKKNqsX2sMzNFshqCkTzP0=; b=tBl+9Rhx+Itow7wKMWIggjpQ/
        7HguhfuBfCCja+79PJd1kmoDVQGQzQVlInlAwRL8YsmRMSISKvA6SOiPkK6EOZU+W+Eo2eO+gZVr3
        bgEZAFsDq6BYEa5/9JMRuxEa9TkyHUlFHDkTzJaCLy3Yh59uQksNt/Jb7L+mTYF9IZ0d0UWCVYtM1
        LuV15mpsoieKrLF/0qCS5WWSBF6a+tB54TLhVqpfVhe7aBOiPwCJpl5owCA0lkeDGeDZ8Lv6QSkdz
        V5Q+6+mNeIN2Z6H/NAvp24Swa4GvcTOrt51CpRKlLYECh51tquHfynYBasRL3voBJEGDJXn1Nl2Fi
        mYu3vWkLw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iSdMk-00079K-1D; Thu, 07 Nov 2019 08:42:06 +0000
Date:   Thu, 7 Nov 2019 00:42:05 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/6] xfs: "optimize" buffer item log segment bitmap
 setting
Message-ID: <20191107084205.GE6729@infradead.org>
References: <157309573874.46520.18107298984141751739.stgit@magnolia>
 <157309577521.46520.17834347718436642749.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157309577521.46520.17834347718436642749.stgit@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 06, 2019 at 07:02:55PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Optimize the setting of full words of bits in xfs_buf_item_log_segment.
> The optimization is purely within the bug triage process.  No functional
> changes.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
