Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DB9E4FCE40
	for <lists+linux-xfs@lfdr.de>; Tue, 12 Apr 2022 06:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244051AbiDLEuW (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 12 Apr 2022 00:50:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233516AbiDLEuU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Apr 2022 00:50:20 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12AC129808
        for <linux-xfs@vger.kernel.org>; Mon, 11 Apr 2022 21:48:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=KkQWodRSaABH4BeT+I33+MhaDmE2DfmLpfbnoZKF5Kg=; b=QlgY3xp+ZpK26hIxVQCHjh6D0o
        rm9PDqgOOReDRGiCpF3qmNaxvN7rX0MfaZKkHSAokZo/5QXBVAcw3vY01CXKIN9tvghKROvgAyuYy
        KPLnyFfnvA7TtCx8+D11RoDG/wZ/bFZ8dzJYZYeLBZug4xvxm5Vg9NV0u6vBwgFRXU7gx4+NtGt/g
        QjTuyp6wrDuPkUCeR/u1CC974iEIyB4vPa5pLoqeK/L9jVS6uolawk91KTz85v3pJwTgan2wFTL1b
        YUEuhNHpciZjwVH0W2H7poBF/brOOH1BJj9aBwfYknOzz0GzucJJiT1HCZs77EcBLJvh/G1jGPtQK
        w1gykmlw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ne8Rg-00BfjN-N4; Tue, 12 Apr 2022 04:48:04 +0000
Date:   Mon, 11 Apr 2022 21:48:04 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com
Subject: Re: [PATCH 00/10] xfs: LARP - clean up xfs_attr_set_iter state
 machine
Message-ID: <YlUEhMlr5g7uirBW@infradead.org>
References: <20220412042543.2234866-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220412042543.2234866-1-david@fromorbit.com>
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

On Tue, Apr 12, 2022 at 02:25:33PM +1000, Dave Chinner wrote:
> Hi Allison,
> 
> This is first patchset for fixing up stuff in the LARP code. I've
> based this on my current 5.19-compose branch here:

What is "LARP"?
