Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A9D07B9FBA
	for <lists+linux-xfs@lfdr.de>; Thu,  5 Oct 2023 16:29:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbjJEO2e (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 5 Oct 2023 10:28:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233288AbjJEO05 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Oct 2023 10:26:57 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE22526184
        for <linux-xfs@vger.kernel.org>; Thu,  5 Oct 2023 05:02:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=iK69FrPvBnPnFGQteuc+E+nlOd
        P1jFu02C+XjGRXVouzHxJb+q/ed32dWCyxxMAkUEP0kre/U/UxtDjB3jMYubuygX7BKbXTCwt9V8v
        GpkxhmdYwGqJMmdaVkQo/MW4UkNIDmx1p3s39Dd0RIhDAPqpyud6DylcT37Nr6KfVCuFpXbOTMviQ
        HnGfi0ustMuZ6Rq8+Z3jsLCmfKj6sAWLQ0JUm6+3tv/LEWe+rrOojyjX6CJfyB1eVG9ewQLyFEkqT
        DxF7aUZ5LWc5kceVwgF6oVisBgd2q6dfuYB3OBbT6yFZwh6DVwWxBuXGNV1ZMRldd925DmZkl/QyN
        l5ivjAVg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qoN4A-002YzK-2e;
        Thu, 05 Oct 2023 12:02:54 +0000
Date:   Thu, 5 Oct 2023 05:02:54 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, john.g.garry@oracle.com
Subject: Re: [PATCH 7/9] xfs: caller perag always supplied to
 xfs_alloc_vextent_near_bno
Message-ID: <ZR6l7rHIvGxE1n4n@infradead.org>
References: <20231004001943.349265-1-david@fromorbit.com>
 <20231004001943.349265-8-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231004001943.349265-8-david@fromorbit.com>
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
