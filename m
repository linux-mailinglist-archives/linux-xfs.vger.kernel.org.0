Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5F527BF361
	for <lists+linux-xfs@lfdr.de>; Tue, 10 Oct 2023 08:55:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442333AbjJJGzM (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 10 Oct 2023 02:55:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442319AbjJJGzM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Oct 2023 02:55:12 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE82599
        for <linux-xfs@vger.kernel.org>; Mon,  9 Oct 2023 23:55:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=UEHJd6WPPWtkGym7vIbulnUmtt
        Us5YYgbC05l0kC9V/bv2nn7RxnEJ29JrTNdwbUaHNwdrA95cQ16v2eroygevRuq40SMf6N/gZpw3F
        IROe6t4ljQqLonSNbh/e0Zk0sbTRZmKL5/1bSJzfRCpQ5XLC1qcKjb3cP1SDJrYxv2zH+UfpsSjGy
        8oQFgXLeqNuz98RNJ0NVuA7LgsfS/e2uMX+cekS47Kzx2P8pFQmbPxqpmnRv0pcmKFUQbBuN3ZYHE
        sXlM4shiHpC86xFRbowztEosaRhbJJCJJQwqUl6lN5nvIli36ABsClt/M3mAn412Ki0UyWDlryA+/
        R7qoFm0g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qq6e5-00Cdzq-2L;
        Tue, 10 Oct 2023 06:55:09 +0000
Date:   Mon, 9 Oct 2023 23:55:09 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: adjust the incore perag block_count when
 shrinking
Message-ID: <ZST1TQSi10kKEZUy@infradead.org>
References: <169687594536.3969352.5780413854846204650.stgit@frogsfrogsfrogs>
 <169687595108.3969352.10885468926344975772.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169687595108.3969352.10885468926344975772.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
