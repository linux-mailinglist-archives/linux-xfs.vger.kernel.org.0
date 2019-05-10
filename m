Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B1351A245
	for <lists+linux-xfs@lfdr.de>; Fri, 10 May 2019 19:26:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727611AbfEJR0O (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 10 May 2019 13:26:14 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:59344 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727318AbfEJR0O (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 May 2019 13:26:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=ZaK1FM0O9a3JNJb+p7iCa8lzJyR7LBiWw3nLW2HM8VY=; b=DYvIFGI4VeZaTD67JOsl/oOTK
        GjD4b/TcvprjddIu6wCmRpaEbQxqViEpOUcqCh4YRp2P5YWFW5BYiDfmgoHAFTZuW1aBurCiu5Cjq
        doxZSA0m3k/2yOFCs38dIDqt4lk7/jYDzrWz+tbB3fD+G68/3T84HQD9XF1UUwOIEgN+hSZpws1Zw
        U0W4/4qI4MY++XTXh+x944MR/UBCK43ASTeXG5BoN5M4oIFohUU8xs7HKZ99dxkocJh341WfqOKco
        I39FjONG4OE5ECQZol+0CP6gkC25JCJDMAYl/pxn1M5hwFDFUJaSFTrtlfe6pznQCsIppYpz18/A8
        380lbcNzA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hP9Hh-0006QD-Ox; Fri, 10 May 2019 17:26:13 +0000
Date:   Fri, 10 May 2019 10:26:13 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/6] xfs: always update params on small allocation
Message-ID: <20190510172613.GB18992@infradead.org>
References: <20190509165839.44329-1-bfoster@redhat.com>
 <20190509165839.44329-3-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190509165839.44329-3-bfoster@redhat.com>
User-Agent: Mutt/1.9.2 (2017-12-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 09, 2019 at 12:58:35PM -0400, Brian Foster wrote:
> xfs_alloc_ag_vextent_small() doesn't update the output parameters in
> the event of an AGFL allocation. Instead, it updates the
> xfs_alloc_arg structure directly to complete the allocation.
> 
> Update both args and the output params to provide consistent
> behavior for future callers.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
