Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51325740ACB
	for <lists+linux-xfs@lfdr.de>; Wed, 28 Jun 2023 10:11:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231168AbjF1ILR (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 28 Jun 2023 04:11:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230445AbjF1H5r (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Jun 2023 03:57:47 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A64D1BE8
        for <linux-xfs@vger.kernel.org>; Wed, 28 Jun 2023 00:56:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=t5Zs4zCzWMr+vVfvPMMa+GUD48
        M4oJqldD1tsjm5ZGJwnarMyEYHe5+Fsjd88gXKedSk1agcUStDOhUyhkHuyTRmsbBq7ZJpr1bfkMX
        ZMj737574OZCMaSQ9iQo1oTqnToLfrMwtOyXLAoOUJRvCEGxX1kBlF6ju6o9l5M5AvfH0Eh9LMmG0
        WpslaeW0klzAqKBTH6chcBwhI2ca7sImDEm1x+9x3oWXUvYyjFyKYZbClSDYVXMBJDW0W8lZRn8zG
        Wcu+7NOWknwFxsBRxlzDmYrq+WI3RCLaJOffH27CUZ9CyyZW8wx0yAAYp8w39EN4F2dPEVqfUy9s6
        UnPDTmmA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qEOH8-00Evig-2E;
        Wed, 28 Jun 2023 06:03:34 +0000
Date:   Tue, 27 Jun 2023 23:03:34 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/8] xfs: don't reverse order of items in bulk AIL
 insertion
Message-ID: <ZJvNNqMcjAj/2AWx@infradead.org>
References: <20230627224412.2242198-1-david@fromorbit.com>
 <20230627224412.2242198-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230627224412.2242198-2-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
