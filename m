Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 084AC1B882F
	for <lists+linux-xfs@lfdr.de>; Sat, 25 Apr 2020 19:37:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726285AbgDYRho (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sat, 25 Apr 2020 13:37:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726145AbgDYRho (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 25 Apr 2020 13:37:44 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25BE3C09B04D
        for <linux-xfs@vger.kernel.org>; Sat, 25 Apr 2020 10:37:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=7BT6u7IZzGHDJD9FmMreOuti5PksCMEtvBLR/w7BxIw=; b=fw6v6e2Gwsyan9+stXb60/Lmzv
        seTe9DM6CsWyGTtpMP8yfldyCpYGC+utoo4q7hGU/xLbITddA/1fpMxjmPhBhjua7+n6rZuyl8UXx
        4bfJatIjFeZ1n8+a6Mv20RMa0hjmi/wPqyFWC+l2cgXN9KQBvw3tmCSHzMdELysyyU3r50Qx1VSyI
        sonovqyOZOoAeTMncktygASZYCisJEgvDi5gTogrrMSjXHgVR6x6/83O5v3uxPUBU+g6U3RH1ly/J
        KUbQseE2jhm2hGiq/yLqxedkgdiy1xydVNoBUVyCo8S6Zo9Rh+35NZUo19MIC61x6iU9PtleMHfvY
        WKuhD2sQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jSOkI-00044I-1F; Sat, 25 Apr 2020 17:37:42 +0000
Date:   Sat, 25 Apr 2020 10:37:42 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 11/13] xfs: remove unused iflush stale parameter
Message-ID: <20200425173742.GH30534@infradead.org>
References: <20200422175429.38957-1-bfoster@redhat.com>
 <20200422175429.38957-12-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200422175429.38957-12-bfoster@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 22, 2020 at 01:54:27PM -0400, Brian Foster wrote:
> The stale parameter was used to control the now unused shutdown
> parameter of xfs_trans_ail_remove().
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Allison Collins <allison.henderson@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
