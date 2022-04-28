Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACB92513454
	for <lists+linux-xfs@lfdr.de>; Thu, 28 Apr 2022 15:01:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346747AbiD1NEN (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 28 Apr 2022 09:04:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346743AbiD1NEM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Apr 2022 09:04:12 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 268ED6EB22
        for <linux-xfs@vger.kernel.org>; Thu, 28 Apr 2022 06:00:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=uhhA5mY+ZAqz+cB/C12dUoMG/h
        Jkr0n9SMWUNZvkCvc5dambRFKgx0+VZKMrrrSiGzoi2BbQhGeP37oO+UaJaL87whK9TUqFlWL07ZJ
        jkTVtQBnF9VKGfmU4hqyMf4cCxslOA+REChmizYh+hPkR9tEZi8/0tYgYI5lwThiDaboAKPkBKZNK
        VN6AgdQwrKb1c2YvKt0WdE21X4lN/zwpOZHLc4foig3gaHzxnHDoscAEgQTuPqq2+OHgcNLBGrJxS
        99Q3T7omA6EPXlJIyJhsL5CdsHkM3HRbYG+bht/rQmOT8v73+SJfPZYW0Na1ik0Jt+T4zowWBTc62
        V1wGBzKA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nk3lR-006vKO-M8; Thu, 28 Apr 2022 13:00:57 +0000
Date:   Thu, 28 Apr 2022 06:00:57 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/8] xfs: hide log iovec alignment constraints
Message-ID: <YmqQCaxttVVyMyVk@infradead.org>
References: <20220427022259.695399-1-david@fromorbit.com>
 <20220427022259.695399-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220427022259.695399-2-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
