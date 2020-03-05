Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC3C117AAE2
	for <lists+linux-xfs@lfdr.de>; Thu,  5 Mar 2020 17:50:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725963AbgCEQuF (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 5 Mar 2020 11:50:05 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:60498 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725948AbgCEQuF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Mar 2020 11:50:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=HmOMSRFye4q50TXlIA6ItQuwPboEHEhdqm56d18Dxtk=; b=mZBFSXLxJZPG3hgYSlenfQX2rM
        N8hN8lkRw7XKHlSAxNJ57U4mgVFwRXQN2PGDFlUPokoxwz+6OrCNUtFtq/9cDbwy4UE7fmcKqHGqh
        HStZrrsid44n1DQ0D6DaJkuxgDVUZmIGneD73t6+b5q8lVT2slrDM3m62XRNFsBE0ub633e7aX1R1
        vMDWzxc/kagBGPAkW2sR4v8jOcFyJ08i0aGXRG2SBOgQuhNxxSIMAi4RLWuBgnteIeFuW9fqmo4b3
        UyrwNCLis47TQ6slUHrSNSNP1ON2ec7Xu1+1eLKeO8mYhf8be8fqCQ4q+CZmJ5m8SwKvc5zI9ZwcG
        eKaurCPQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j9thE-0002zi-UV; Thu, 05 Mar 2020 16:50:04 +0000
Date:   Thu, 5 Mar 2020 08:50:04 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs: check owner of dir3 free blocks
Message-ID: <20200305165004.GC7630@infradead.org>
References: <158294091582.1729975.287494493433729349.stgit@magnolia>
 <158294092825.1729975.10937805307008830676.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158294092825.1729975.10937805307008830676.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Feb 28, 2020 at 05:48:48PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Check the owner field of dir3 free block headers.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
