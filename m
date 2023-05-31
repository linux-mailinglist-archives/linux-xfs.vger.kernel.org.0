Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF43E7176A0
	for <lists+linux-xfs@lfdr.de>; Wed, 31 May 2023 08:07:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234134AbjEaGG5 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 31 May 2023 02:06:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232171AbjEaGG4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 31 May 2023 02:06:56 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2FD8129
        for <linux-xfs@vger.kernel.org>; Tue, 30 May 2023 23:06:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=t3tEuxHqD5/He81ahZdIACYRZk
        D9VpbVEOYEjxIRw2WAetM6ECCeKFvy/3K24VZCDPHZQQ+rfwSS/sK7HqZyChoS+WoqamyJTxr0NnB
        Y1T/hMuXc05rxCZDYDiQ3LFUZO6+ksfd1dwYqgrlm9FapgOlzcHJO7gYu2cYA/BZN0guHxguXAisT
        UF7vWRcyZNHhvqWWq+ByhqC3YQ9nFldnYwPOJrB7yF+SfkklCQMvWZhez+SSRDkKuUBWqvEsXBh8T
        uyhhkyQhkmkN07q1yS+DZeutv2Hpu5z+Fe/9dfwwiUvX6iSMDTBQ79na2dGZ/nFIWHTkb4juxch3W
        uWg/CqLw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1q4Eyy-00GFM4-2n;
        Wed, 31 May 2023 06:06:52 +0000
Date:   Tue, 30 May 2023 23:06:52 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: validate block number being freed before adding
 to xefi
Message-ID: <ZHbj/LlZFYCLHsav@infradead.org>
References: <20230529000825.2325477-1-david@fromorbit.com>
 <20230529000825.2325477-4-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230529000825.2325477-4-david@fromorbit.com>
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
