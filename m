Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3F71754327
	for <lists+linux-xfs@lfdr.de>; Fri, 14 Jul 2023 21:18:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236379AbjGNTSH (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 14 Jul 2023 15:18:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235765AbjGNTSG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 14 Jul 2023 15:18:06 -0400
Received: from ms.lwn.net (ms.lwn.net [IPv6:2600:3c01:e000:3a1::42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E63535AE
        for <linux-xfs@vger.kernel.org>; Fri, 14 Jul 2023 12:18:06 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:281:8300:73::5f6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id 5DB6C2DC;
        Fri, 14 Jul 2023 19:18:05 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 5DB6C2DC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
        t=1689362285; bh=2adsFMlPN2Cw8BzJsCpFmXH2rTYTk8dkWaLRE1JkIbQ=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=jmV8kMGnS9ZoUzDYAhX6Knks+QmJ9PmR6J3vVFyspAjpZW7ui3G8Ib/UCfSaZjQ0I
         b7xa8XuJA8E8/s3o9v5WnttO6EG/J127/kEM3k2QYjPp9E+DxrwW6R/FEG0Asbgw92
         O526GaL2Rk9ADfD1Ogobv7/dvBXW46m6LHdA50ysliIeZd3SjVstsTOIzARknsLDKw
         FPtQMWri+65gxbJ7sv/RZhVyIdSDB2VWZtU3HZcNua7i1uOgfS97cZ7yMllRtSLEzb
         BiOjvhy0BAodVnvk+On35Bwtkh3bbzohirESyC0zWNjCvUYobRMEKeEJT5OB229QTj
         0j1l0uU9RAhyA==
From:   Jonathan Corbet <corbet@lwn.net>
To:     Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH v3] Documentation: admin-guide: correct "it's" to
 possessive "its"
In-Reply-To: <20230703232024.8069-1-rdunlap@infradead.org>
References: <20230703232024.8069-1-rdunlap@infradead.org>
Date:   Fri, 14 Jul 2023 13:18:04 -0600
Message-ID: <87edlaz4ib.fsf@meer.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Randy Dunlap <rdunlap@infradead.org> writes:

> Correct 2 uses of "it's" to the possessive "its" as needed.
>
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Darrick J. Wong <djwong@kernel.org>
> Cc: linux-xfs@vger.kernel.org
> Cc: linux-mm@kvack.org
> Cc: Jonathan Corbet <corbet@lwn.net>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> ---
> v2: add Rev-by: Darrick
> v3: rebase/resend
>
>  Documentation/admin-guide/mm/numa_memory_policy.rst |    2 +-
>  Documentation/admin-guide/xfs.rst                   |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)

Applied, thanks.

jon
