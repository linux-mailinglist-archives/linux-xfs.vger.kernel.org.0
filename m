Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 134337BD8B4
	for <lists+linux-xfs@lfdr.de>; Mon,  9 Oct 2023 12:34:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345755AbjJIKeU (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 9 Oct 2023 06:34:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345716AbjJIKeT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Oct 2023 06:34:19 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D1659C
        for <linux-xfs@vger.kernel.org>; Mon,  9 Oct 2023 03:34:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=U+HFdSNO+S3ziAAS5dVFTX3bPwPgz5Mr45L96GmDHa8=; b=XhZUGb9p8SKyzuEyGZFZ8zdCm3
        bkokQmzcMsL9EUuxiM+JIqU3NHpzKDscIceP8V7Iuu/mZ7XAe87fybg3a80AjtGf9pAlBEJZ/0N8r
        j6QLbFsMt1PFf74F+7kNt3oAhQZr/XPDqoh7jfnfYw4cb+w5gYsLT/vVgT/2X5dBQchTp1/VEM6fp
        Ymhyn7b/MzooLd1Yygw7tLoFJ+/KMnaiELDU3HlYvbwQ57uFyOCwtYjKcPIWA09B0xGxJbYv4kPwQ
        TQz7AiNnYirYX46MBz9Dm+Zeh9/vl7FEN+FPKspqTrn0KSIX35zMRimTRqivxHKyO5ndSWaRXWgA0
        LKgbHMQA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qpnab-00AEZp-0w;
        Mon, 09 Oct 2023 10:34:17 +0000
Date:   Mon, 9 Oct 2023 03:34:17 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Omar Sandoval <osandov@osandov.com>
Cc:     linux-xfs@vger.kernel.org, "Darrick J . Wong" <djwong@kernel.org>,
        kernel-team@fb.com, Prashant Nema <pnema@fb.com>
Subject: Re: [PATCH v2 1/6] xfs: cache last bitmap block in realtime allocator
Message-ID: <ZSPXKVCy6KrepBiB@infradead.org>
References: <cover.1693950248.git.osandov@osandov.com>
 <317bb892b0afe4d3355ab78eb7132f174e44d7f7.1693950248.git.osandov@osandov.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <317bb892b0afe4d3355ab78eb7132f174e44d7f7.1693950248.git.osandov@osandov.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Notwithstanding the whole RT code type confusion, the change here
looks good to me:

Reviewed-by: Christoph Hellwig <hch@lst.de>
