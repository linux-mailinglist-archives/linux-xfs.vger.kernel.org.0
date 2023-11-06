Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4953F7E264F
	for <lists+linux-xfs@lfdr.de>; Mon,  6 Nov 2023 15:11:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbjKFOLC (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 6 Nov 2023 09:11:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229922AbjKFOLC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Nov 2023 09:11:02 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88115BF;
        Mon,  6 Nov 2023 06:10:59 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 792AFC433C8;
        Mon,  6 Nov 2023 14:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1699279859;
        bh=BxoSTuO4u/SJYd+0Xpj36hQ/yzIzZbV94ASNVv0iXmk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Vppqxvf/F40r2NuRJ/oMlzB7p/Zfi5YXI6pHjuVmSzDDrDCLwtYbKf0W6NbL8xJF9
         JN3jgMob8ThPeXY0iQxaJnXHW+RKFEF7KKcXfK+EWJY7KTE8c1r8fAYrKoIdxopP36
         /LFm+qwUJUGbG6zsfuXh/WAcEly3AxHpjPchuzPgR+nsABAyy2o08x65woToQ3Xxul
         yubdUx41dCZoR+vZ3IDYzMP9ji6j1chQ7NaHTMtQ4iKfdkzWbAHBYIIEUx/6fuWDM3
         R7zKgPlzmLqbuGf4zYDgg90eDyn5uMb/aSNE9CBkHzutFjKED8KE2Uvuut5tt+S95N
         5kf4a5vJVlLkw==
Date:   Mon, 6 Nov 2023 15:10:53 +0100
From:   Christian Brauner <brauner@kernel.org>
To:     Jan Kara <jack@suse.cz>
Cc:     linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>,
        Kees Cook <keescook@google.com>,
        syzkaller <syzkaller@googlegroups.com>,
        Alexander Popov <alex.popov@linux.com>,
        linux-xfs@vger.kernel.org, Dmitry Vyukov <dvyukov@google.com>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/7] block: Remove blkdev_get_by_*() functions
Message-ID: <20231106-rentabel-beurlauben-468c636d268e@brauner>
References: <20231101173542.23597-1-jack@suse.cz>
 <20231101174325.10596-2-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231101174325.10596-2-jack@suse.cz>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 01, 2023 at 06:43:07PM +0100, Jan Kara wrote:
> blkdev_get_by_*() and blkdev_put() functions are now unused. Remove
> them.
> 
> Acked-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---

Yes, very nice!
Reviewed-by: Christian Brauner <brauner@kernel.org>
