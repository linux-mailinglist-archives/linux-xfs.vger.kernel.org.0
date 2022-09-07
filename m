Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C4AB5B05B9
	for <lists+linux-xfs@lfdr.de>; Wed,  7 Sep 2022 15:51:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230080AbiIGNvp (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 7 Sep 2022 09:51:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229673AbiIGNvc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Sep 2022 09:51:32 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64C55AB418
        for <linux-xfs@vger.kernel.org>; Wed,  7 Sep 2022 06:51:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=4IAHWwFa6pwdJivjZDdOEW0uw9vRrLiXURdEuLCyWPU=; b=S8DrTvdHsJCvLOy6/ODmcov5dU
        Tf6De0rQ2Zi4WhHAuiNALhw1d7bVfrLshi3T5vFdhjppugo5qv92CJ86GEYI68P/kdr8xEXkdtJhX
        fUhf3mG1BY/kRXAoBv9MPMmoTxZ9eqCxAeWfvKmDNfo9CkiCufri7Y9tgjyAwZJsUdWhu6JCOUZh4
        /E/QVPu34ZOHin/B66A/glsNTzOXbiru7vVA19WI0aks4FG5Dz+lhIGvJMDYZuekNpFRCEw2GIMY+
        EfAEwicIz3S/WgWT3q47fUIW28PMbSvSIOvPILr1bcbnWzrEbnfj8dsWqcAYPKqCn2W5r4ZUtxLVv
        A2sTHBdQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oVvSY-006dRt-6E; Wed, 07 Sep 2022 13:51:18 +0000
Date:   Wed, 7 Sep 2022 06:51:18 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/9] xfs: move and xfs_trans_committed_bulk
Message-ID: <Yxih1kBXRZCK72Ir@infradead.org>
References: <20220809230353.3353059-1-david@fromorbit.com>
 <20220809230353.3353059-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220809230353.3353059-2-david@fromorbit.com>
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

As the bot pointed out xlog_cil_ail_insert should to be marked static
now.  Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
