Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45AE354DC00
	for <lists+linux-xfs@lfdr.de>; Thu, 16 Jun 2022 09:40:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359094AbiFPHkf (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 16 Jun 2022 03:40:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359047AbiFPHk3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jun 2022 03:40:29 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61A2B5C769
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jun 2022 00:40:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=H1Zx9P4yLtNx1CPROD4FV02M9D
        JRTv6crIgzwZX3dn8gf7r3v8+lIXnBxE00cRT965yllVmOFLaaJNMpy7hXDP+YufXf9HY07OTagK2
        RJzieESshlYY9OjymroqTTKaeOJLU+BtK8MfeZKuHkzdQo6/tGACvNYdpBh003t36GeMWA47Gecxa
        AQeIoIoPq/kNvWkhAHm56tl1je5R1+H0c7UVl7+kTrOATsAOWFCAswBQvKiPO/QuDhv/HZzxotaIC
        lFor5JGcojFFkpjt5KZIVBAHSNGKYPEDp1Q4X97JJ/n6y5RhICBR4vJ4ZVUyKqe5mNJaQCuv8xrNh
        v7LP6h8A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o1k7A-0016lV-24; Thu, 16 Jun 2022 07:40:28 +0000
Date:   Thu, 16 Jun 2022 00:40:28 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/50] xfs: pass perag to xfs_alloc_get_freelist
Message-ID: <YqrebAWJkqS4obRl@infradead.org>
References: <20220611012659.3418072-1-david@fromorbit.com>
 <20220611012659.3418072-9-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220611012659.3418072-9-david@fromorbit.com>
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
