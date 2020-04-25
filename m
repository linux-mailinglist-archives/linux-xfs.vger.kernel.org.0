Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D04751B8889
	for <lists+linux-xfs@lfdr.de>; Sat, 25 Apr 2020 20:35:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726216AbgDYSfa (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sat, 25 Apr 2020 14:35:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726145AbgDYSfa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 25 Apr 2020 14:35:30 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 895A1C09B04D
        for <linux-xfs@vger.kernel.org>; Sat, 25 Apr 2020 11:35:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=jDkMvWP3286eV/h5YJKWI1XAUK9CgRY1SQLo60DTLWM=; b=qUNV/NezXMmMeJr6pYqR37TmEM
        hnPH29WeYL370XNfqp7Y/ud7DA2gKeS/INM2wo8BYT+3bB2IQ53Bopqy3BfHqx4W1/YnGXsSQ1GkE
        uJ/7MT1024YK3W20rp8mqNEyQfgaSVm4l3OMOJX2kZSmppakBP2ZghTxRCftkajf2oZ7T2LgMQaA7
        fvXU/6zrsbevA9gdradn4C7frZF8zjwR06VH4LHk5Bs+vm/8UE5JFTxNn1FTKv7CVJNpl88xtIJQv
        IX0YBWLye9B33F7bgKW+sErH6rugczD3xVsWyN7jtxU/v60T8S+aGJi3MUGB3827aLyjASpsQiy+p
        M5XYhOOQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jSPeE-0003Xn-Da; Sat, 25 Apr 2020 18:35:30 +0000
Date:   Sat, 25 Apr 2020 11:35:30 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 17/19] xfs: hoist the ail unlock/lock cycle when
 cancelling intents during recovery
Message-ID: <20200425183530.GI16698@infradead.org>
References: <158752116283.2140829.12265815455525398097.stgit@magnolia>
 <158752127272.2140829.17836221324265747282.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158752127272.2140829.17836221324265747282.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 21, 2020 at 07:07:52PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Move the spin_unlock/spin_lock of the ail lock up to
> xlog_recover_cancel_intents so that the individual ->cancel_intent
> functions don't have to do that anymore.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
