Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E7587D8E0A
	for <lists+linux-xfs@lfdr.de>; Fri, 27 Oct 2023 07:18:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231221AbjJ0FSz (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 27 Oct 2023 01:18:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbjJ0FSx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 27 Oct 2023 01:18:53 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B95AA1A5;
        Thu, 26 Oct 2023 22:18:51 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 1436A67373; Fri, 27 Oct 2023 07:18:48 +0200 (CEST)
Date:   Fri, 27 Oct 2023 07:18:47 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Pankaj Raghav <kernel@pankajraghav.com>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        willy@infradead.org, djwong@kernel.org, mcgrof@kernel.org,
        hch@lst.de, da.gomez@samsung.com, gost.dev@samsung.com,
        david@fromorbit.com, Pankaj Raghav <p.raghav@samsung.com>
Subject: Re: [PATCH] iomap: fix iomap_dio_zero() for fs bs > system page
 size
Message-ID: <20231027051847.GA7885@lst.de>
References: <20231026140832.1089824-1-kernel@pankajraghav.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231026140832.1089824-1-kernel@pankajraghav.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

>  
> -	__bio_add_page(bio, page, len, 0);
> +	while (len) {
> +		unsigned int io_len = min_t(unsigned int, len, PAGE_SIZE);
> +
> +		__bio_add_page(bio, page, io_len, 0);
> +		len -= io_len;
> +	}

Maybe out of self-interest, but shouldn't we replace ZERO_PAGE with a
sufficiently larger ZERO_FOLIO?  Right now I have a case where I have
to have a zero padding of up to MAX_PAGECACHE_ORDER minus block size,
so having a MAX_PAGECACHE_ORDER folio would have been really helpful
for me, but I suspect there are many other such cases as well.
