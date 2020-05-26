Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2EB31B7201
	for <lists+linux-xfs@lfdr.de>; Fri, 24 Apr 2020 12:30:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726667AbgDXKao (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 24 Apr 2020 06:30:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726193AbgDXKan (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Apr 2020 06:30:43 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2039C09B045;
        Fri, 24 Apr 2020 03:30:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=4Sw6XO8HGnt227nUuGdGgUq+h3XmixRIxRJmsIKqIyQ=; b=o92onYY1N76X2/K10Tm44Z3zz1
        Vb4SXhLYJ00mbArnY4Q30kEVrnPWpXwts7yt3hau500UxZHyTF/j+u1/1ATMuCvSIPwmjoTG1jeCI
        tlQVfb24/BttGN/YLuyBV3MKBmqruPZdsgortb1/faWTOaGpSGEYWxEVytetXTpHpmGzr7FEdyw5J
        AKq81cm6uLNHd4Hg4RK2AJuKgS8sj/niED2cWqUqlwED3imeulITMABOhE5uSsJ/mKC0jB1Xipznf
        /n3Pb+f3CZVkfDep2XGji3Ex7VmiNB/0sSJqsUPlthcbQGh4ygqDWE6YxDUv05CHhY4zhW9bBI2Jp
        rjC1DVvQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jRvbW-0002Yt-Un; Fri, 24 Apr 2020 10:30:42 +0000
Date:   Fri, 24 Apr 2020 03:30:42 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 4/5] xfs/30[78]: fix regressions due to strengthened AGF
 checks
Message-ID: <20200424103042.GA8585@infradead.org>
References: <158768467175.3019327.8681440148230401150.stgit@magnolia>
 <158768469665.3019327.1634286381311814235.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158768469665.3019327.1634286381311814235.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 23, 2020 at 04:31:36PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Reorder the order in which we tweak AGF fields to avoid falling afoul of
> the new AGF sanity checks.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
