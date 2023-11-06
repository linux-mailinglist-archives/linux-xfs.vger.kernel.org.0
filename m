Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DDD67E292F
	for <lists+linux-xfs@lfdr.de>; Mon,  6 Nov 2023 16:57:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231767AbjKFP5g (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 6 Nov 2023 10:57:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbjKFP5g (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Nov 2023 10:57:36 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C21EB107;
        Mon,  6 Nov 2023 07:57:33 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05E95C433C7;
        Mon,  6 Nov 2023 15:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1699286253;
        bh=XakOiVEMQ571wvcS5zGAhlpsZauOUa29Y5gHDvsw+qk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tVeB/a8uodkCX0j62lt47x2YG8Bv4xgWfFh3B93YWDE3uZR/1+H5DvLu8B36rQoqM
         eNGiPC/TAgJ1tevx7Ou2o9LuR9c6uRcm6gByg+upuaeD3XOqHyUaXKpHrij/buYQ9G
         sirzNOITl2dbJUuqg5dFqbSgPbRAKgQxRzXxcGkNpNFfPAuaSl8NXeVhkbuquyl/+i
         Yk9Fuatfq1iHVqmf10evgxHZ0+Fnk6MKb437dy8PKln7pcoOH/jh+HLETNkJ3QE1OD
         T673p/8RTDKUS3FGNkDPIoQY+rZzadZlSJF3kb+DbVBq1kOrv/xvnSjnYohAl5WCpm
         N2YMd6Q7b12+Q==
Date:   Mon, 6 Nov 2023 16:57:27 +0100
From:   Christian Brauner <brauner@kernel.org>
To:     Jan Kara <jack@suse.cz>
Cc:     linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>,
        Kees Cook <keescook@google.com>,
        syzkaller <syzkaller@googlegroups.com>,
        Alexander Popov <alex.popov@linux.com>,
        linux-xfs@vger.kernel.org, Dmitry Vyukov <dvyukov@google.com>
Subject: Re: [PATCH 3/7] block: Add config option to not allow writing to
 mounted devices
Message-ID: <20231106-mieten-wildnis-6cb767d234eb@brauner>
References: <20231101173542.23597-1-jack@suse.cz>
 <20231101174325.10596-3-jack@suse.cz>
 <20231106-einladen-macht-30a9ad957294@brauner>
 <20231106151826.wxjw6ullsx6mhmov@quack3>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231106151826.wxjw6ullsx6mhmov@quack3>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> > Let's hope that this can become the default one day.
> 
> Yes, I'd hope as well but we need some tooling work (util-linux, e2fsprogs)
> before that can happen.

Yeah, absolutely. I'm moderately confident we'll have fairly quick
adoption of this though.
