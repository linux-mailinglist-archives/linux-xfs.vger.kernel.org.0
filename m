Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7520F7E26D7
	for <lists+linux-xfs@lfdr.de>; Mon,  6 Nov 2023 15:32:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbjKFOch (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 6 Nov 2023 09:32:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjKFOcg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Nov 2023 09:32:36 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B33991;
        Mon,  6 Nov 2023 06:32:34 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E04BC433C7;
        Mon,  6 Nov 2023 14:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1699281153;
        bh=lXClTxVR0gTtEQpR7wLQM5KHmuWQx4g7X7NcmIWBY/M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=byjhbkQu++jMpPLIxKaIzPNy8fjHoSObAkNkNopA9bNoxvUpsDy0VnjNtzrXVQq/2
         sOXP+3zVCONsXGKOxhQDwv+fXmcxbGvTIwDdq9DEgfkOMs2FzAdgxbapQwEU2ZlOJB
         wue8J0DtyXnGFZB7a71YyuSO5IDL7xq2zkdol1htwfFerAmeRNQqB8qrfvG7dnOEHI
         3A7Ak12d/LvBYkCZ0i8i4tEoVnLBGshKvopppyIgEpT0TSCp0EUgJcyGvWkg98L8IQ
         G2elcJ5XC5y1Sv5XghTNP5j018wGDJ/pcoLi2v9pRhVOAmCK7EJMyLBiNDW2t/d5sp
         xHRMCfuCDOp9w==
Date:   Mon, 6 Nov 2023 15:32:28 +0100
From:   Christian Brauner <brauner@kernel.org>
To:     Jan Kara <jack@suse.cz>
Cc:     linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>,
        Kees Cook <keescook@google.com>,
        syzkaller <syzkaller@googlegroups.com>,
        Alexander Popov <alex.popov@linux.com>,
        linux-xfs@vger.kernel.org, Dmitry Vyukov <dvyukov@google.com>
Subject: Re: [PATCH 5/7] fs: Block writes to mounted block devices
Message-ID: <20231106-erleben-seeadler-bec35961548f@brauner>
References: <20231101173542.23597-1-jack@suse.cz>
 <20231101174325.10596-5-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231101174325.10596-5-jack@suse.cz>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 01, 2023 at 06:43:10PM +0100, Jan Kara wrote:
> Ask block layer to block writes to block devices mounted by filesystems.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---

Looks good to me,
Reviewed-by: Christian Brauner <brauner@kernel.org>
