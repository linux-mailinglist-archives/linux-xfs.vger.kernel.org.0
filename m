Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88610725869
	for <lists+linux-xfs@lfdr.de>; Wed,  7 Jun 2023 10:48:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238918AbjFGIsM (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 7 Jun 2023 04:48:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235007AbjFGIsK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Jun 2023 04:48:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98A3B1712
        for <linux-xfs@vger.kernel.org>; Wed,  7 Jun 2023 01:48:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 281B7632CF
        for <linux-xfs@vger.kernel.org>; Wed,  7 Jun 2023 08:48:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8237C433EF;
        Wed,  7 Jun 2023 08:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686127688;
        bh=4/9z5a2jmUst/N1xXLuVrrXa9oC7Dj0cBAvLVQZTBuQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZNI+8J6Z0JLezv6LNiyrLqHmSskR/2XZlojGaAaavmjf2SjMUhhx19bx5gwf/wy2x
         J00nofzBTZRB0jh6nssZZtoYmAjX6dm1+T4NSBgBJCaDiP47bwzSNUNYirQRNbH8Bb
         5EGZfNYqOTeGJ5P7l/c6AV9YfAf560wMk+IsZ4zcl7B77EnZ8qCGci4WX3f+WYecY/
         yVrQBp/wpYfEVgkw/JHFNvAa9y2nzpXuVEi7ByFoYs36jIBDWD+6ON7c7cxVDlXwBC
         ZX33vf+1nS31VfTCmW21U5ZjWZwlD5bRCTbQ7q+4n5/lBunYQVqwKxAXEvdhhhywzc
         RFPo5MRNpl5fw==
Date:   Wed, 7 Jun 2023 10:48:04 +0200
From:   Carlos Maiolino <cem@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH V2] xfs: Comment out unreachable code within
 xchk_fscounters()
Message-ID: <20230607084804.vh3dz6qvgbkotjav@andromeda>
References: <20230606151122.853315-1-cem@kernel.org>
 <i5VjxsfPIrRyvOoqV6BqW6qno66Gxsc-zGbsc1RZ60MawgxcwuoRtOODkv1SKvanvnXaNriVpBuIGtR99YA_Vw==@protonmail.internalid>
 <ZIAmCHghf8Acr26I@infradead.org>
 <20230607073757.zwfhie3qbn7mox5i@andromeda>
 <k8Kj2sTeNZWAzveaTqq0fnhlyrNj59s_SwIZn82YJTtQHnnXOS7GM08VCbW5V8M4uXSjuMxVJ3umucWeAYqxLQ==@protonmail.internalid>
 <ZIA2NLCSw7nVMh6w@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZIA2NLCSw7nVMh6w@infradead.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 07, 2023 at 12:48:04AM -0700, Christoph Hellwig wrote:
> On Wed, Jun 07, 2023 at 09:37:57AM +0200, Carlos Maiolino wrote:
> > The code isn't dead, it's temporarily broken. I spoke with Darrick about
> > removing it, but by doing that, later, 'reverting' the patch that removed the
> > broken code, will break the git history (specifically for git blame), and I
> > didn't want to give Darrick extra work by needing to re-add back all this code
> > later when he come back to work on this.
> > Anyway, just an attempt to quiet built test warning alerts :)
> > I'm totally fine ^R'ing these emails :)
> 
> #if 0 is a realy bad thing.  I'd much prefer to remvoe it and re-added
> it when needed.  But even if Darrick insists on just disabling it, you
> need to add a comment explaining what is going on, because otherwise
> people will just trip over the complete undocumented #if 0 with a
> completely meaningless commit message in git-blame.  That's how people
> dealt with code in the early 90s and not now.

You are right, I should have added at least some comment on that, I'll wait for
Darrick to wake up and see if we deal with it somehow or just leave it as-is.
