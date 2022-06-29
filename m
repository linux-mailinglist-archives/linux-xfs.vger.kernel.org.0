Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BAB055F949
	for <lists+linux-xfs@lfdr.de>; Wed, 29 Jun 2022 09:41:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbiF2Hkr (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 29 Jun 2022 03:40:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229820AbiF2Hkq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jun 2022 03:40:46 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E00FE186F6
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 00:40:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=jUIwRpZs3C/atfJBDgHWwbawUt
        2uNR0acqLQTu4tuAljaYGfh9EtkcwnORAFmt3sek5cAprPzdwC6+VIjNVct0j5vUMfdfQyF3hX/KH
        NSAMBUamiQSdn4RFFj/zqeNPzetczjkCX8XpHDh9DYhKaPNEizOmDmCuaRVoWT69Zqx0FJT5O+Enx
        UMTl5vjx09PkmNpxDxfnLGmH9RfHw7WqTI94mXrbabn48GDns6JvVXHwBm6/xauPTg3NWhjFYtnGe
        7bVDvgQqx1+HVo8RAIine5RCrYGJ3qDwEu6OxXsvB41/5WvMfGPipVKE4/kfFoP3IH17YLohj5dSE
        gWlbXkSg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o6SJZ-00A9hG-H1; Wed, 29 Jun 2022 07:40:45 +0000
Date:   Wed, 29 Jun 2022 00:40:45 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/6] xfs: remove a superflous hash lookup when inserting
 new buffers
Message-ID: <YrwB/cID+2F8164m@infradead.org>
References: <20220627060841.244226-1-david@fromorbit.com>
 <20220627060841.244226-6-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220627060841.244226-6-david@fromorbit.com>
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
