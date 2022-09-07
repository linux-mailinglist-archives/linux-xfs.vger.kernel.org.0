Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 420785B0629
	for <lists+linux-xfs@lfdr.de>; Wed,  7 Sep 2022 16:12:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbiIGOM0 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 7 Sep 2022 10:12:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbiIGOMZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Sep 2022 10:12:25 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0A6F642D5
        for <linux-xfs@vger.kernel.org>; Wed,  7 Sep 2022 07:12:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=hKKrnJUbqkPWbLxksC8x4UCntQ
        ElrZ0/r1+hWQipNEel8sVf3FxgWN3UjBJ9js2vLZG66hT0RzdCF0kGIZYv5Kh/PYV4czy+GwPsNVo
        Clp6izbkYOk0U5ztiXBY9YSWFb1b9DqQklfC7NgynLlUyKOu5+Gm0iVtCGL7m5sr7qW93uPxJnVh3
        RobNo0EpzR3XKqns74QggZWda0X1475wC6mZa/GR5O4n3AyrCSrhx/s66pKhibE1XeJ/tP46i8uTT
        LPO2dR5OWhbmTbYTxecjptZkBT+Lv8viTjeF6ceOaIpXIrLX/xxpSZpFdDFoXz7nm/3us5mUUHbWe
        WE0e+EpA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oVvmv-006kUj-Kx; Wed, 07 Sep 2022 14:12:21 +0000
Date:   Wed, 7 Sep 2022 07:12:21 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/9] xfs: collapse xlog_state_set_callback in caller
Message-ID: <YximxcDwFXV3lxlH@infradead.org>
References: <20220809230353.3353059-1-david@fromorbit.com>
 <20220809230353.3353059-7-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220809230353.3353059-7-david@fromorbit.com>
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
