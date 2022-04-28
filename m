Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EE38513446
	for <lists+linux-xfs@lfdr.de>; Thu, 28 Apr 2022 14:56:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344020AbiD1M7p (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 28 Apr 2022 08:59:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346736AbiD1M7p (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Apr 2022 08:59:45 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B119A67D27
        for <linux-xfs@vger.kernel.org>; Thu, 28 Apr 2022 05:56:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=ciMvvlkxjMOrN5e867UoVAOoC1
        IUfih7t6OV5U6UX8AoQg5IKf/J5pZfzatjHowDNyh++bgHj2NXItxctn2QH5Ski3klh45zHy26Sxa
        AZfTT1YT0N9RwgpiGqjU2tWTnS6PmvIGVGFoqMer13hhw2uUpBpCqcoaib0Mlti/RbBumeKYYAVv3
        kJe+okZ6jX9sl/+O0u86tXiwUb5QIcClRZO6AlhLU2Mrsw+UBzH7G6Mi1NJM/OSRbdjbayFbc4Wrm
        Pc6jDTMaRlZ32P1UfEBj9ZeXsP4iGL2XdsSPK/KS1ybWNNTDC4sdUNyof+Lq0LWL4Hvt65dBnnVQx
        obooK4cQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nk3h6-006uzs-56; Thu, 28 Apr 2022 12:56:28 +0000
Date:   Thu, 28 Apr 2022 05:56:28 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     david@fromorbit.com, Dave Chinner <dchinner@redhat.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 8/9] xfs: rewrite xfs_reflink_end_cow to use intents
Message-ID: <YmqO/PKni51Chxfp@infradead.org>
References: <165102071223.3922658.5241787533081256670.stgit@magnolia>
 <165102075737.3922658.2470136533458678121.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165102075737.3922658.2470136533458678121.stgit@magnolia>
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
