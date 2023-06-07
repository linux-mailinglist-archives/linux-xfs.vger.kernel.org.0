Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 755D9726363
	for <lists+linux-xfs@lfdr.de>; Wed,  7 Jun 2023 16:54:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241201AbjFGOyF (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 7 Jun 2023 10:54:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241204AbjFGOyC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Jun 2023 10:54:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ABE21FD6
        for <linux-xfs@vger.kernel.org>; Wed,  7 Jun 2023 07:53:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9A63264055
        for <linux-xfs@vger.kernel.org>; Wed,  7 Jun 2023 14:53:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F29E7C43443;
        Wed,  7 Jun 2023 14:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686149631;
        bh=nTCXDta0QRjDabyrNK7eEGeEo1FT4gI+T9EM0zWIf1I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JqENLhVwhQdl+/bvurAU8n+NGKaGTX75G8ULnBR9WKrLbTF42MjCMNkWijPr+QKaC
         K0hP1aLBtwDjvbznNpiwd5n2cqxbxqjBGH8LMVAUwx29g5KTk36BkHqMlKWN7gipwh
         pmhdnQIDrIBp/e58Ae5LZnC9/LSiJm7ro7wG2DqL3lewDamSbfF8VwJJc9crqq/SHL
         7wNF+xiwRUug9ywIo0bA1QUu8kzND1BQiYAzwKcZyWC+vK9efPIj1K3QrqY3/bk5Yu
         CYGstmOKEWaGP8TQE/MQFkUt8Ra+8Yvet/DQKvWmo4trpNdiTQt8ookJfEnwy1TFn9
         d/+w8NQgdlbVg==
Date:   Wed, 7 Jun 2023 07:53:50 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH V2] xfs: Comment out unreachable code within
 xchk_fscounters()
Message-ID: <20230607145350.GS1325469@frogsfrogsfrogs>
References: <20230606151122.853315-1-cem@kernel.org>
 <i5VjxsfPIrRyvOoqV6BqW6qno66Gxsc-zGbsc1RZ60MawgxcwuoRtOODkv1SKvanvnXaNriVpBuIGtR99YA_Vw==@protonmail.internalid>
 <ZIAmCHghf8Acr26I@infradead.org>
 <20230607073757.zwfhie3qbn7mox5i@andromeda>
 <k8Kj2sTeNZWAzveaTqq0fnhlyrNj59s_SwIZn82YJTtQHnnXOS7GM08VCbW5V8M4uXSjuMxVJ3umucWeAYqxLQ==@protonmail.internalid>
 <ZIA2NLCSw7nVMh6w@infradead.org>
 <20230607084804.vh3dz6qvgbkotjav@andromeda>
 <20230607142812.GR1325469@frogsfrogsfrogs>
 <ZICUn0Na/mqWEKkw@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZICUn0Na/mqWEKkw@infradead.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 07, 2023 at 07:30:55AM -0700, Christoph Hellwig wrote:
> On Wed, Jun 07, 2023 at 07:28:12AM -0700, Darrick J. Wong wrote:
> > *Someone* please just review the fixes for fscounters.c that I put on
> > the list two weeks ago.  The first two patches of the patchset are
> > sufficient to fix this problem.
> > 
> > https://lore.kernel.org/linux-xfs/168506061483.3732954.5178462816967376906.stgit@frogsfrogsfrogs/
> 
> That sounds like a way better idea indeed.  I'll get to it after my
> meetings.

FYI there's a parallel discussion about the same patch going on fsdevel:

https://lore.kernel.org/linux-fsdevel/20230522234200.GC11598@frogsfrogsfrogs/

--D
