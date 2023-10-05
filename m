Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6631B7BA4FD
	for <lists+linux-xfs@lfdr.de>; Thu,  5 Oct 2023 18:14:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240063AbjJEQN1 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 5 Oct 2023 12:13:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235616AbjJEQMY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Oct 2023 12:12:24 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F7A826183
        for <linux-xfs@vger.kernel.org>; Thu,  5 Oct 2023 05:02:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=bgPeuZqomKa3ZqGiziJz1M13gQ
        3Svp521CzGzI16LXDwbzoI6rSbN78hLPWhF7R9Mj/VfK6YhSWgc9hx+IDdiTpQ0M5EeLmqw07zTST
        VXPWKM9yhToXC5J3UYbFbqkpIVxj/kDQvyKxdQs8jT9YJ4ugR0Qc7RnWwrVSP5MG0uY7c9kJ79uzM
        XU3mhYme/dT2E3zV3AskA8cFBrWKRsgi5EV+D9fat7TAZxLi52xX+vvukPZ8UZMhidLGhczrUee0O
        WBO4jC0oc0Du+lZ6Ezj5yExmRebHoBP4PVR6KguH/M0G2US5XU4dvYKd49W6+y7QhJT7/px5yFU3H
        eMxtshnw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qoN3k-002YlG-2D;
        Thu, 05 Oct 2023 12:02:28 +0000
Date:   Thu, 5 Oct 2023 05:02:28 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, john.g.garry@oracle.com
Subject: Re: [PATCH 6/9] xfs: use agno/agbno in xfs_alloc_vextent functions
Message-ID: <ZR6l1KwGAt/hjLJl@infradead.org>
References: <20231004001943.349265-1-david@fromorbit.com>
 <20231004001943.349265-7-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231004001943.349265-7-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

