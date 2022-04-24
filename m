Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 488C950CFE3
	for <lists+linux-xfs@lfdr.de>; Sun, 24 Apr 2022 07:41:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237971AbiDXFoZ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 24 Apr 2022 01:44:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231567AbiDXFoZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 24 Apr 2022 01:44:25 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7BE0199818
        for <linux-xfs@vger.kernel.org>; Sat, 23 Apr 2022 22:41:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=I2jTn+YCVtnoO/plYbmRdxbjSX
        HzQsq4palfdXqkxTEym1XvllF1RYoHI4bebOCNLCs4iS3nv4/ZDnT+fj/c2jDnxwdMFcPc5VaRLel
        zZYEAnmSsZmZgj8MEKRb/dk0GxHSmmAoEFkGjRF8/uWavs408O65HPRBMzOLLJRwj1TWwJ3kl4RQo
        tpwTOuDRdsjTg7dYKu9HK6xnhD+UGD7UTuslstfq34lUd49SxucmEfAtBhLYlqtgWs0rFiVQY6peU
        ANubZfaytPPAF5sayp6wEkdFFV8qXyVIJMSfAsieXXrD9TATUakZ2rjBrfmLIUngbdSAzmGe0jE71
        LhGfMpjQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1niUzs-005rCz-3K; Sun, 24 Apr 2022 05:41:24 +0000
Date:   Sat, 23 Apr 2022 22:41:24 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] mkfs: fix missing validation of -l size against
 maximum internal log size
Message-ID: <YmTjBNPgM43QgHOO@infradead.org>
References: <164996213753.226891.14458233911347178679.stgit@magnolia>
 <164996214332.226891.14374740027876929439.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164996214332.226891.14374740027876929439.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
