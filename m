Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7123C56D479
	for <lists+linux-xfs@lfdr.de>; Mon, 11 Jul 2022 08:04:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbiGKGEH (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 11 Jul 2022 02:04:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiGKGEF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Jul 2022 02:04:05 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C179ADEB0
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jul 2022 23:04:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=iJPf9aRSvXG4s34Uhpzfdx/AfO5bc5iKecgtMMaYLCk=; b=FqDo9f6RNGwdMoNWP2ecrk130u
        v8TGxqXSC1Uvg149L8x+CReOcM9zPaLJOuwIdtJ9FpvssGZmqrj3f5qOr1Eov3MsLc3b8Mu19xqWY
        6vhIxJt+KENKtRw1UlwOYMGre1CIZnX7LUwfj6jdjNk0FcOlH6eXtEg3wvbZpV5EklhjntPV7xFTv
        aDiWe6yP8juhsPkzNajE8R3g/nPOOWamMjzCvGP0rJifvMybvX0ZSCrV4ZYMhBF1kfBM+/2zKCGBy
        G0FcabVxPEqJTkDb3t7mC00O7yLjW0uwb4BwNYrouS3KZjsd/MiNKUgVMCae0Shj9sr7t/Cc8M67i
        hj4tTukg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oAmWZ-00GIxo-Af; Mon, 11 Jul 2022 06:04:03 +0000
Date:   Sun, 10 Jul 2022 23:04:03 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/8] xfs: AIL targets log space, not grant space
Message-ID: <Ysu9U/I9j2uQ+YDv@infradead.org>
References: <20220708015558.1134330-1-david@fromorbit.com>
 <20220708015558.1134330-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220708015558.1134330-3-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 08, 2022 at 11:55:52AM +1000, Dave Chinner wrote:
> COnvert the xfs_ail_push_target() to use physical log space for the

s/COnvert/convert/
