Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA66D740A33
	for <lists+linux-xfs@lfdr.de>; Wed, 28 Jun 2023 10:00:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231451AbjF1H7o (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 28 Jun 2023 03:59:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231462AbjF1H5j (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Jun 2023 03:57:39 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CEA5358E
        for <linux-xfs@vger.kernel.org>; Wed, 28 Jun 2023 00:56:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=MCDS6NmzyoRCV6IJnepJ+hjfjYnFg72qgWpC8ZlvMVQ=; b=g8J+bI6NjwHwO1Cv4qlDfT4RFU
        OSMunrAgiXxuWBijx+0G1yp7n60IEHda9L/vc+TmxsU5FIZeVuPKGOnoXBENCFstwCKVcv7DleqGC
        6H7dwwhe1vSZrkkn4mj50Lbz1+6C0qUk+xCboBmqgREXs+vVLkAVTULt8e8mBQ3+QsSAIvHcbE4GF
        G60bEQFgh9yKy9upqXl29EmgzhhqCxZRP2wJIUsfre7lEdleivo6mnOx1NxqqxFnznHSSI1AohdRL
        9DSZnUrut6OZTfjDCHZ9KtUZJakMFxSteqaTiX4moWYQDYKB3BFiecPYpc0BEFWsajogAPyZWISm1
        b3RupZ/g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qEON1-00EwCq-1q;
        Wed, 28 Jun 2023 06:09:39 +0000
Date:   Tue, 27 Jun 2023 23:09:39 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 8/8] xfs: fix bounds check in xfs_defer_agfl_block()
Message-ID: <ZJvOowANw4U+ymi6@infradead.org>
References: <20230627224412.2242198-1-david@fromorbit.com>
 <20230627224412.2242198-9-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230627224412.2242198-9-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 28, 2023 at 08:44:12AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Need to happen before we allocate and then leak the xefi. Found by
> coverity via an xfsprogs libxfs scan.

... and also fixes the type of the agbno argument, which probably should
be here in the commit log.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
