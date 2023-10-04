Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 088217B7759
	for <lists+linux-xfs@lfdr.de>; Wed,  4 Oct 2023 07:06:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241063AbjJDFGy (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 4 Oct 2023 01:06:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235448AbjJDFGx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Oct 2023 01:06:53 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 785D9A9
        for <linux-xfs@vger.kernel.org>; Tue,  3 Oct 2023 22:06:50 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A21B4C433C8;
        Wed,  4 Oct 2023 05:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696396010;
        bh=tZMxq+e+AixKoaUvG0cHhHbZNXwEsXPQPW4xbZuCRzE=;
        h=References:From:To:Cc:Subject:Date:In-reply-to:From;
        b=HVpge43GB4rimecKpiWiw5VIYz2TIqNO02f4lSz1zyiExNy/iZAuVn0E9fK6ZdC3X
         +xdJjDMbACHIgpN2X52nbMIx1yTNQtzpoSC+5hI0RSfCw1wbduNZC5/EnrNOv28Vnf
         ASu2PWle/SiLhFTM8OOqOrpzheKn56j4Qes3I5NPp/YxMvM1eMeFIJAm5unRnspPgR
         U0RTD5BTEHF/0HYlanKU28fioBp2MeDF93tDM2NP7TK03JYHaYIyWGPHQmrSzf1iDS
         AD3aKL4dlN3aSFB8om5EedFfelXwrIZMNIFAi6WsC3CpiNjPeyP3116zhMEaKoej/B
         mxoO+2QRm9AbA==
References: <ZRygqkCkbH32I+x9@dread.disaster.area>
User-agent: mu4e 1.8.10; emacs 27.1
From:   Chandan Babu R <chandanbabu@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [GIT PULL] xfs: use busy extents for fstrim
Date:   Wed, 04 Oct 2023 10:33:22 +0530
In-reply-to: <ZRygqkCkbH32I+x9@dread.disaster.area>
Message-ID: <87o7hfq8m1.fsf@debian-BULLSEYE-live-builder-AMD64>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 04, 2023 at 10:15:54 AM +1100, Dave Chinner wrote:
> Hi Chandan,
>
> Can you please pull the changes to fstrim behaviour from the signed
> tag below? This has been rebased on 6.6-rc4 so should merge cleanly
> into a current tree.
>

Thank you. I have merged the changes and started an fstests run now. I will
push the changes to xfs-linux's for-next branch tomorrow if I do not encounter
any regressions.

-- 
Chandan
