Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00503579182
	for <lists+linux-xfs@lfdr.de>; Tue, 19 Jul 2022 05:56:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234591AbiGSD4V (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 18 Jul 2022 23:56:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229916AbiGSD4U (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Jul 2022 23:56:20 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E40622505
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 20:56:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=mbhmPyn9S5bo0WP4juzU9aEQMd
        y3RlVZlSzyE9GhtvzgbqCBlfHuzDRPgsqr9ajVabpG2ZWYMJ4UM/KbOiKaZKRIrp23sgZatGLr4+W
        oX8sJUV1K9rI3eZ6VW9SK4R7aAzRiZvez/k6TeJhEBOjT7IJkiEmfxI3Jut6Nzj0uup/I7/GgT/0N
        qYC4sZbUWkljwr7OrGfpVDpQrp2AgnwJOQmFn1714eskbm1tDZKD3bJGW1F+Bg+UF8GHgLMxqhOqv
        6OfeZlvkOtcS+f6l6xANAED1E+KAH+H5SMIF52xXVu0PLz19CIrabtw2k2kcNHZXSpNga5tuydzHM
        olfer1hQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oDeLL-004aQv-8B; Tue, 19 Jul 2022 03:56:19 +0000
Date:   Mon, 18 Jul 2022 20:56:19 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: xfs_buf cache destroy isn't RCU safe
Message-ID: <YtYrY8+hKxQaDSO1@infradead.org>
References: <20220718235851.1940837-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220718235851.1940837-1-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

