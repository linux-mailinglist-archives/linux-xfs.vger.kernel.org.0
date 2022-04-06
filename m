Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CBCB4F68C1
	for <lists+linux-xfs@lfdr.de>; Wed,  6 Apr 2022 20:19:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240049AbiDFSF1 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 6 Apr 2022 14:05:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240111AbiDFSFK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Apr 2022 14:05:10 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66F6B299A4C
        for <linux-xfs@vger.kernel.org>; Wed,  6 Apr 2022 09:39:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=AFpz1gYEqJr0y4OXj3fnbRY/sa
        hWCt+1srJusoHrgswo0sz5Y4PjYikaeEI2iOECxWDeERplknLmUa48sucvFNC9aSuZSsoUsEkNdJd
        McDOYbHpKTX4pWAGh9UbLNW3lpwyD7eCaMyRgo/cRLZBPIb1zKbKHMHRlm0aph9PWN8j7B/+ePX1W
        go+OSY8ZreiGh6xYEtz9W8luP+fmlQ6y1G2U0THdeYFLg8Dxi0b/btFxrCaIYQqRB0Qo9IDTIp7Yu
        yWLbQAvGFtKx055wXn5cz3Is6rLFRqCIoE/4p+WipJhEFak3wcnyDPe+LIM2ZjpvH3KpLSjEp8wu/
        eZNVTVdw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nc8h0-007ECA-Sq; Wed, 06 Apr 2022 16:39:38 +0000
Date:   Wed, 6 Apr 2022 09:39:38 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Brian Foster <bfoster@redhat.com>,
        Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
        david@fromorbit.com
Subject: Re: [PATCH 2/6] xfs: don't include bnobt blocks when reserving free
 block pool
Message-ID: <Yk3CSgoEo5Poexx3@infradead.org>
References: <164840029642.54920.17464512987764939427.stgit@magnolia>
 <164840030799.54920.14162809636198918115.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164840030799.54920.14162809636198918115.stgit@magnolia>
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
