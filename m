Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53028695CB5
	for <lists+linux-xfs@lfdr.de>; Tue, 14 Feb 2023 09:17:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231147AbjBNIRM (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 14 Feb 2023 03:17:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230044AbjBNIRM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Feb 2023 03:17:12 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 797CB133
        for <linux-xfs@vger.kernel.org>; Tue, 14 Feb 2023 00:17:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=PQNLAzUDHCL+z59ONGA2J170Uv
        T9M3gxplfIXKhin141j8DhlWXHZaq/MN39qbKTb1h9SfhHXDJCm3mO993NkYwzTtM1xj+FzGeF+pU
        Ugok+wg0ABiZ7fqO9BusRBjF1wE8XIi7LtwwHOliu9OXjl1KSn1nESMJy1WJuTCiqATNrXVsJx6NU
        DEl6fx438tr8d1K3EiN+Ez+MTKqqMAim80Gzm4cGPrAFd2GnYVTWYm1rjIUvwiLLHN1fCBpALF3c1
        MCKLHztMK3O0PxjJluaAn5cNzCQnRrdK9GC4orZntjranqGhy9/233nqm2RNuUcBqH9DdydAkSy2J
        wSYqf5Ig==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pRqUx-000Vq7-5m; Tue, 14 Feb 2023 08:17:11 +0000
Date:   Tue, 14 Feb 2023 00:17:11 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Carlos Maiolino <cem@kernel.org>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs_io: fix bmap command not detecting realtime files
 with xattrs
Message-ID: <Y+tDh1DNuOJ8yLEi@infradead.org>
References: <Y+RcuAFlqnxNBw5I@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y+RcuAFlqnxNBw5I@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
