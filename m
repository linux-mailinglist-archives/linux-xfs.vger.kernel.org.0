Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B8761BD466
	for <lists+linux-xfs@lfdr.de>; Wed, 29 Apr 2020 08:07:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726420AbgD2GHD (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 29 Apr 2020 02:07:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726274AbgD2GHD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Apr 2020 02:07:03 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07DCDC03C1AD
        for <linux-xfs@vger.kernel.org>; Tue, 28 Apr 2020 23:07:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=jySYj75EHSiP0h/Ih9Hy7tzey0Ldv1Ycujky8q3yseg=; b=n25/qfXdbAzPQyEHYSTkDtqoB2
        mCs5m9Z292buoAGkC8taxwk4h0EkJGIduGFUtAENFdaFkTuykV7HfZxtn94Q44CHl0BOi7Hf/ItV3
        b1F7RRlvoCUglATwCjQTTW6fIffybALPKjdktYqG9cCkJwvSftkvQmX9VI+aOt8560vPkjZ0dALgG
        YFa7EBzP5SdANXWHzXAqtBGdAtZ05RJIJ0rue1AEWoYu8inwwHKzguxrTtpG5NiC5quAI+Ne1JMiG
        jFv7X/H/SE8uy0Kx5opgdsA2vsmazcKfj3pZtK/nf/gF7I36J62Ck19oljuGC2l2LfINZu2XIer2t
        0VGKN7SA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jTfs6-0005YD-OH; Wed, 29 Apr 2020 06:07:02 +0000
Date:   Tue, 28 Apr 2020 23:07:02 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/19] xfs: refactor log recovery item dispatch for pass2
 readhead functions
Message-ID: <20200429060702.GA9813@infradead.org>
References: <158752116283.2140829.12265815455525398097.stgit@magnolia>
 <158752118180.2140829.13805128567366066982.stgit@magnolia>
 <20200425181929.GB16698@infradead.org>
 <20200428205424.GG6742@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200428205424.GG6742@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 28, 2020 at 01:54:24PM -0700, Darrick J. Wong wrote:
> > > +			if (item->ri_type && item->ri_type->ra_pass2_fn)
> > > +				item->ri_type->ra_pass2_fn(log, item);
> > 
> > Shouldn't we ensure eatly on that we always have a valid ->ri_type?
> 
> Item sorting will bail out on unrecognized log item types, in which case
> we will discard the transaction (and all its items) and abort the mount,
> right?  That should suffice to ensure that we always have a valid
> ri_type long before we get to starting readahead for pass 2.

Yes, I think so.
