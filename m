Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8F0F5066B3
	for <lists+linux-xfs@lfdr.de>; Tue, 19 Apr 2022 10:16:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349882AbiDSISx (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 19 Apr 2022 04:18:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349957AbiDSISR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Apr 2022 04:18:17 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6335E2AC49;
        Tue, 19 Apr 2022 01:15:24 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id D071868D06; Tue, 19 Apr 2022 10:15:18 +0200 (CEST)
Date:   Tue, 19 Apr 2022 10:15:17 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        linux-block@vger.kernel.org, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, Changhui Zhong <czhong@redhat.com>
Subject: Re: [PATCH V2] block: avoid io timeout in case of sync polled dio
Message-ID: <20220419081517.GA6427@lst.de>
References: <20220415034703.2081695-1-ming.lei@redhat.com> <20220415051844.GA22762@lst.de> <YllQVT6n472eUB7+@T590> <20220416054913.GA7405@lst.de> <YlqGZ7W9rg0eNt9A@T590> <20220418051234.GA3559@lst.de> <Yl0e/YBPGydwVAE7@T590> <20220419053924.GA31720@lst.de> <Yl5pDrgglwv00caD@T590>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yl5pDrgglwv00caD@T590>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 19, 2022 at 03:47:26PM +0800, Ming Lei wrote:
> I agree to remove it because it is legacy poll interface, and very likely
> no one use it since the problem to be addressed can easily be exposed by
> sync polled dio sanity test or 'blktests block/007'.
> 
> I'd suggest to switch sync polled dio into non-polled silently, just with
> logging sort of 'sync polled io is obsolete, please use io_uring for io
> polling', or any other idea?

We've carefully define RWF_HIPRI to just be a hint.  So I don't think
logging an error would be all that useful.
