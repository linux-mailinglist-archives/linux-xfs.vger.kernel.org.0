Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B35F5187AC
	for <lists+linux-xfs@lfdr.de>; Tue,  3 May 2022 17:00:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237691AbiECPEW (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 3 May 2022 11:04:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237670AbiECPEV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 May 2022 11:04:21 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08B6B18B39
        for <linux-xfs@vger.kernel.org>; Tue,  3 May 2022 08:00:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=LD8JTiqu08s3m81LVlKPcSkMy/1WrafIGGFvnvK03CI=; b=vGglUXa65PmBDQ3nwHRbNpFphZ
        nKA5ksDYC2V1/yEUIasiPWBaYBZhfWzKbH2kksHOStCcMaiwnc1zskZQqRjBYwBekunRXuzsrjIng
        h8y8h6313iqhmWfftbr5NaM4pzU+ym6dhiK0q+1Zc7bmAQcBmzcwGzlRuQMR2vmqxDwhRE9b5Ed3Z
        ykoYi3RYT0uLCL2dOeIoJEqe+ISfuGEftvjdoXsVJJpWBZHMAb5w4NL0Ej1zxvnY2tecZN1WGQXtD
        lGqo5yslF/0VhBP6db5PhMH6KyPzFrkyl5hL8cUQCOORiZRz7loj2yu15FJ1gb3UzdyTBIcPxxMWS
        jAY69ncg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nlu1A-006OMu-II; Tue, 03 May 2022 15:00:48 +0000
Date:   Tue, 3 May 2022 08:00:48 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: validate v5 feature fields
Message-ID: <YnFDoMfAM9Ofls6f@infradead.org>
References: <20220502082018.1076561-1-david@fromorbit.com>
 <20220502082018.1076561-5-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220502082018.1076561-5-david@fromorbit.com>
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

> +	/* Now check all the required V4 feature flags are set. */

V5?

Otherwise this looks good modulo the buildbot warning about the missing
static.  A more verbose and decriptive commit log would be nice, though.

Reviewed-by: Christoph Hellwig <hch@lst.de>
