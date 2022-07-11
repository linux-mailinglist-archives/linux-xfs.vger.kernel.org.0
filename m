Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8667D55F967
	for <lists+linux-xfs@lfdr.de>; Wed, 29 Jun 2022 09:43:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232183AbiF2HnJ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 29 Jun 2022 03:43:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232430AbiF2HnH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jun 2022 03:43:07 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6DDE38E
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 00:43:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Pbn4hs9j2mTtJzC0gOd9/xe5B5
        XqORolOoJgME2smPrezUmjXx1G1XZUJHC7GwM7uX0qN1QdT0Aa4x/GtcnCs/tvvngnFtx1ftTnUq9
        9M9MiQal4UwOi0K8MfWk0uQDHw5ogUNrpv8ME95mwsYhAQ0DotHg0jv2tTz9S6W0ohh6a+3AVy1wP
        xJ6m7YGDX4Uuse9J9GgvbLOwvMECSsCSHAJdVDnC/gocwe+2/6aHPeIN59gz5Xv1xjw+V4e4PgBv9
        W2t88m3w7hEZLLKy5quAnKqw/wKGRjOCn6evbQBNJTxg5gXrmrU2WZcQ/Mk/ThFyr/GvB9Xe79/gi
        pM4ie7PQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o6SLn-00AAX6-DR; Wed, 29 Jun 2022 07:43:03 +0000
Date:   Wed, 29 Jun 2022 00:43:03 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/8] misc: fix unsigned integer comparison complaints
Message-ID: <YrwChxmDKsRuKqYl@infradead.org>
References: <165644930619.1089724.12201433387040577983.stgit@magnolia>
 <165644931191.1089724.14586418293765469096.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165644931191.1089724.14586418293765469096.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
