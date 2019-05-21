Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDA1125846
	for <lists+linux-xfs@lfdr.de>; Tue, 21 May 2019 21:28:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727032AbfEUT2n (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 21 May 2019 15:28:43 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:45048 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726771AbfEUT2n (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 May 2019 15:28:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=SFq8GpWoNhXQv18z2y68+/lOuRFD3HEBbmn0epwiQR0=; b=qI1R7XX4JHns/8Nnc+NKWSzpH
        xjCB0+gjN0RARkSV4HPG+keFIY7PJfeGajCnNTaEc+uOpIDtPryQPCIXBqx5sLjtw+giZX/qnuwQS
        PgB1M4arVwO0KaJQEAkhLGB/0eAlegldRdvQ9vTghNfEdZJ5yW186N82rh6YTq+Hmed6TAQmvzI6W
        gtNZlB5Q4Rb+5fYX8M0Ca+to9GPJISPt5pRulHrd5Cpc360K984UR2g2G32bakknP2y/FLmZJxj9B
        viHg2YGm2bWrrJNDOrgSRFc/X7FkXggTurnrN6cOOmNe5xf11E8AEErVaYxGQIA15srkWbsWc1rn8
        we0vRcoMA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hTARG-00059Y-2l; Tue, 21 May 2019 19:28:42 +0000
Date:   Tue, 21 May 2019 12:28:41 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/12] libfrog: fix bitmap return values
Message-ID: <20190521192841.GA18265@infradead.org>
References: <155839420081.68606.4573219764134939943.stgit@magnolia>
 <155839424514.68606.14562327454853103352.stgit@magnolia>
 <5caa6c9e-3a42-6c8e-101b-c198af77e765@sandeen.net>
 <20190521170103.GD5141@magnolia>
 <c281d3c3-5385-90a3-125a-8a620944c971@sandeen.net>
 <20190521191946.GA5657@infradead.org>
 <d3a556b7-95ad-9fc9-1867-cd71d43f00e8@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d3a556b7-95ad-9fc9-1867-cd71d43f00e8@sandeen.net>
User-Agent: Mutt/1.9.2 (2017-12-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 21, 2019 at 02:20:51PM -0500, Eric Sandeen wrote:
> > On Tue, May 21, 2019 at 01:59:58PM -0500, Eric Sandeen wrote:
> >> So yeah I'm of the opinion that unless it's kernel(-ish?) code it should be
> >> positive, and I can send a patch to clean up stuff that's not.
> >>
> >> I can be swayed by counterarguments if you have them.  :)
> > 
> > What speaks against everything is negative?  It isn't like returning
> > positive errors really is a traditional userspace convention, as that
> > is return -1 (negative!) and look at errno..
> 
> Sorry, I wasn't clear - I meant returning negative errnos.  That's
> the part that's not consistent.

Yes.  And for libxfs/libfrog/etc stuff I think sticking to that and
always returning negative error values sounds sanest to me.  Note that
some userspace libraries have adopted that calling convention, for
example libaio.
