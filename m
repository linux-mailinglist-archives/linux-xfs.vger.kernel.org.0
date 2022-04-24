Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA8AE50CFE9
	for <lists+linux-xfs@lfdr.de>; Sun, 24 Apr 2022 07:45:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238305AbiDXFsL (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 24 Apr 2022 01:48:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231567AbiDXFsK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 24 Apr 2022 01:48:10 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56FC8F71
        for <linux-xfs@vger.kernel.org>; Sat, 23 Apr 2022 22:45:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=NP2XJlrMQXUTYAACQeMa9VZnY8
        Fsk3fpuJsnD2v8xebQytJMgN1ihzn5UIVvhOp5W4V4S3qpL+m4Iz7FDUIrTA90ysXEeEFrSiLBu3L
        f2ePdWuofPsn0NVEuIlIaiUjNeRQhZbrZNuFYZQaEcstb7mFzOPQZE7Nw3bhWB4RvsQ+tuMgB2v5L
        kmRe8R4EurQs067tC1nGoG+iHXwgzofRYtjjsccOtQXaApp87G1QNh/9xu9jRwkEBjuDlotFpjMWh
        e9CahR5cg4kK2RX9b4TrrJ/OeJVPMAler7c0XMEDqnpVFWeLdbWFq7BW98kG1k11ue84Od/twH++i
        vnx0swgA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1niV3S-005s17-Rv; Sun, 24 Apr 2022 05:45:06 +0000
Date:   Sat, 23 Apr 2022 22:45:06 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     david@fromorbit.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs: simplify xfs_rmap_lookup_le call sites
Message-ID: <YmTj4kP6jjYFqHAB@infradead.org>
References: <164997683918.383709.10179435130868945685.stgit@magnolia>
 <164997685075.383709.9161047695879739444.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164997685075.383709.9161047695879739444.stgit@magnolia>
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
