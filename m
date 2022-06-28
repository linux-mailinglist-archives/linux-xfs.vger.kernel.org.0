Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 175A855D39C
	for <lists+linux-xfs@lfdr.de>; Tue, 28 Jun 2022 15:12:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242259AbiF1C37 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 27 Jun 2022 22:29:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245072AbiF1C2h (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Jun 2022 22:28:37 -0400
X-Greylist: delayed 349 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 27 Jun 2022 19:28:36 PDT
Received: from smtp1.onthe.net.au (smtp1.onthe.net.au [203.22.196.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0AD9D1EC45
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jun 2022 19:28:36 -0700 (PDT)
Received: from localhost (smtp2.private.onthe.net.au [10.200.63.13])
        by smtp1.onthe.net.au (Postfix) with ESMTP id CFAF9610A7;
        Tue, 28 Jun 2022 12:22:45 +1000 (EST)
Received: from smtp1.onthe.net.au ([10.200.63.11])
        by localhost (smtp.onthe.net.au [10.200.63.13]) (amavisd-new, port 10028)
        with ESMTP id 9JEtMDs_zndU; Tue, 28 Jun 2022 12:22:45 +1000 (AEST)
Received: from athena.private.onthe.net.au (chris-gw2-vpn.private.onthe.net.au [10.9.3.2])
        by smtp1.onthe.net.au (Postfix) with ESMTP id A4DDD61036;
        Tue, 28 Jun 2022 12:22:45 +1000 (EST)
Received: by athena.private.onthe.net.au (Postfix, from userid 1026)
        id 8446B68056A; Tue, 28 Jun 2022 12:22:45 +1000 (AEST)
Date:   Tue, 28 Jun 2022 12:22:45 +1000
From:   Chris Dunlop <chris@onthe.net.au>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/6] xfs: break up xfs_buf_find() into individual pieces
Message-ID: <20220628022245.GA459863@onthe.net.au>
References: <20220627060841.244226-1-david@fromorbit.com>
 <20220627060841.244226-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220627060841.244226-3-david@fromorbit.com>
X-Spam-Status: No, score=-0.5 required=5.0 tests=BAYES_05,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 27, 2022 at 04:08:37PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
>
> xfs_buf_find() is made up of three main parts: lookup, insert and
> locking. The interactions with xfs_buf_get_map() require it to be
> called twice - once for a pure lookup, and again on lookup failure
> so the insert path can be run. We want to simplify this down a lot,
> so split it into a fast path lookup, a slow path insert and a "lock
> the found buffer" helper. This will then let use integrate these

"let us"
