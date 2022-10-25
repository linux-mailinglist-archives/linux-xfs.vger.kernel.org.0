Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43B1060BEB2
	for <lists+linux-xfs@lfdr.de>; Tue, 25 Oct 2022 01:36:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbiJXXge (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 24 Oct 2022 19:36:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230438AbiJXXgP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Oct 2022 19:36:15 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36EA51960B6
        for <linux-xfs@vger.kernel.org>; Mon, 24 Oct 2022 14:56:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=w7/GdyrirYqDY2yNiE1oq5a88QHllQcaNdsPM4o9pt0=; b=LNVo02OjR4qfust6qwn6n57m1D
        FI8O6x93heJfA520X/L/qXt9M+cxXr7e3sCxkr56AfpfLLl1W/PrLE8SFAqyUeVjKlyam81+2Pr+6
        peDNUSrxW4k2N/8c6yE7U4jcjxMjpBwBH0kw1LZ5HJ9NNgIAL56jf7si4OGHeFr8I+PXpwbv9VNvr
        AhtGFq4vkU+8Pot+nBiobBsFPPr5l7Y5KYn9uKSwfXaVVMc+deLQLZS1lAZhy/HmbSmc2rQhRhtE5
        oAsmNMbYggmGc/ww8TgiAT1T6BgvN/W9A6PkzP9u3MCwqg68fl8TdgvymQqI23nMsGNHxFNU7Aio+
        hhEayM/w==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1on5RA-00FmMc-Fy; Mon, 24 Oct 2022 21:56:48 +0000
Date:   Mon, 24 Oct 2022 22:56:48 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>,
        Shiyang Ruan <ruansy.fnst@fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [PATCH] xfs: fix incorrect return type for fsdax fault handlers
Message-ID: <Y1cKIEmT2R9INlDT@casper.infradead.org>
References: <Y1cEYs4TK/kED/52@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y1cEYs4TK/kED/52@magnolia>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 24, 2022 at 02:32:18PM -0700, Darrick J. Wong wrote:
> Fix the incorrect return type for these two functions, and make the
> !fsdax version return SIGBUS since there is no vm_fault_t that maps to
> zero.

Hmm?  You should be able to return 0 without sparse complaining.

