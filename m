Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B05161B6E0E
	for <lists+linux-xfs@lfdr.de>; Fri, 24 Apr 2020 08:22:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726072AbgDXGWl (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 24 Apr 2020 02:22:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725554AbgDXGWl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Apr 2020 02:22:41 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 645C6C09B045;
        Thu, 23 Apr 2020 23:22:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=iyYMyFrasiDMpPfSxLSZZPtzLeFDMrolRBCdul6uH28=; b=Nw0dzxLTpjziuO7xh8tRTgvY/e
        ba9W/g/aYWmCO469t/YMOMHJ91+i7qdufQa8sSPRxAu9KmHJnziuhHXdJ6beyN8drbE0mA5r1jGBY
        mQJet0+Z8iTF5A32y7vQmRfjS+QeJ70aRLvxWeOv37Ytb1NNZEmpnchzr6BzCSyZwlttdWQDEWLBo
        Pa06UOXAccjMgN7WGEq876mNVB9OZ6LMfL+jzlsZxrL3zSavkdQO3pperZgLM/ja1DE36tpOqAT0R
        i6OSZxht2iGg5hWlzVI5Y1rJX6DhVVNrgQVlZOSUGf6mmawgvkt4Qfbe7YQNWBfoyVDa4lzxzIwnV
        x1YrCR+g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jRrjK-0003fS-CM; Fri, 24 Apr 2020 06:22:30 +0000
Date:   Thu, 23 Apr 2020 23:22:30 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 3/5] generic/570: don't run this test on systems
 supporting userspace hibernate
Message-ID: <20200424062230.GA2537@infradead.org>
References: <158768467175.3019327.8681440148230401150.stgit@magnolia>
 <158768469040.3019327.7570482503352003021.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158768469040.3019327.7570482503352003021.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 23, 2020 at 04:31:30PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> It turns out that userspace actually does need the ability to write to
> an active swapfile if userspace hibernation (uswsusp) is enabled.
> Therefore, this test doesn't apply under those conditions.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good and fixes the spurious failures I'm seeing:

Reviewed-by: Christoph Hellwig <hch@lst.de>

