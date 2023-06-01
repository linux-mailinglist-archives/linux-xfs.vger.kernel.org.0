Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D06371A1CF
	for <lists+linux-xfs@lfdr.de>; Thu,  1 Jun 2023 17:04:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234513AbjFAPDl (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 1 Jun 2023 11:03:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234530AbjFAPDa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Jun 2023 11:03:30 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39A2B1FD2
        for <linux-xfs@vger.kernel.org>; Thu,  1 Jun 2023 08:02:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=UhMS2I9Hxr+/A3Qw7msZkmRF8O
        VoZoNPdju5hOSbO4ptV5nvHqrKRMAP3Kq8Rul/90xLxAa+SPqoCPVRJ9lOMxAlptrMeAbiI/fgwYq
        VUupn6ycGQvSNjlLMP1zDZws3IMvJqH96sCCt8R9qdGf3eVC/t0xgrkUjM/iZQNif20teSUTkuvt5
        /Fzaiwf6VSejl4ng9wp/BaYqdDMoFUUfP69zuk0FbFzZeLmooTa+toi68p4umW76EVwVALuYhT1fb
        PChsGGD4XBe76nLQmxffiGVSqBtFXmrcKLMb+crBkVUCpNDPp4QWrsy4ZfoGmSx2wjKQqxal7qrQe
        Wev+p6pw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1q4jna-003woy-1c;
        Thu, 01 Jun 2023 15:01:10 +0000
Date:   Thu, 1 Jun 2023 08:01:10 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs: defered work could create precommits
Message-ID: <ZHiyto/MdYOlztBb@infradead.org>
References: <20230517000449.3997582-1-david@fromorbit.com>
 <20230517000449.3997582-4-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230517000449.3997582-4-david@fromorbit.com>
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

