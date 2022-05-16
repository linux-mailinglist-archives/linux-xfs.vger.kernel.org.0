Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 233105285BC
	for <lists+linux-xfs@lfdr.de>; Mon, 16 May 2022 15:44:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234083AbiEPNo5 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 16 May 2022 09:44:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231887AbiEPNo4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 May 2022 09:44:56 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D23C35ABE
        for <linux-xfs@vger.kernel.org>; Mon, 16 May 2022 06:44:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=axMF3zi7vMBgaDDc96ExDjjItU
        keug0KtxAx1hthKax9QeyMX9XMeC8dfHf6MHlSdhpahdr/L1c3QuOaAgPcYE6E7bv7ZIKEjjmvJ2X
        COUIpV9IgX9mFIwCK+d85000YkJhn72/TzJBo7gcGWJq0I5gMy8cAeOiIU4ap8S7Jd/qNw8jBJTEI
        pEblXDtDWWslXF5B3/DTjODrVhNhbqNavZxPeuhKngHnOlKJTWGannthQxXooeLBvivFHzwOAnLoB
        X13okNsxARCu5BPk5fIEmByzACcYZAJV6uBMw2kVqainSSQKvHnbTmXmM74xv6qtHobkHYhoexxPi
        CQOGRxVg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nqb1p-0081rB-WB; Mon, 16 May 2022 13:44:54 +0000
Date:   Mon, 16 May 2022 06:44:53 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs_repair: check free rt extent count
Message-ID: <YoJVVagabw9CSb9/@infradead.org>
References: <165247403337.275439.13973873324817048674.stgit@magnolia>
 <165247404480.275439.7642632291214731611.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165247404480.275439.7642632291214731611.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
