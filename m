Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7975560BEA
	for <lists+linux-xfs@lfdr.de>; Wed, 29 Jun 2022 23:44:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229843AbiF2Vob (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 29 Jun 2022 17:44:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbiF2Voa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jun 2022 17:44:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBC4938181
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 14:44:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 98B59B8273A
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 21:44:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50356C34114;
        Wed, 29 Jun 2022 21:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656539067;
        bh=QTROXRoc58bgpwo1xZsyqKuYGk33ifcp29PrU9zEoLc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=D8VvOjbYL1aJL3DpiLLRF7Sqgxa6n8fVmePo3LEoFVFpAXZWXEdy7/JYJQ2nIo4PM
         GygrVxr4+7WIID1Mx/t0NR77s/Ymoe7v+6ltWbhnkSKKWm+3QSU3p4ZrftwXTZZzLd
         pMu4qqoH0V/SAmBUI0bCjK8reG5HEN+bl4tY02lUM+f0EmNPlTO23EOdwp/xR1HgQ0
         4Y6ic0SozBRJZoG97W3Io2ERCOXtHFqt0UWKRXPzOgxJfJvRRSkGEThVuGnKMctr4k
         f3Z0sgvbhR6KTm+efAg1piJbfFiDHArsh7Fzt0ixSjtiIVhV9dd2ExgD4JFZGE4+7C
         IGXTVGn9vHhpw==
Date:   Wed, 29 Jun 2022 14:44:26 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Theodore Tso <tytso@mit.edu>,
        Luis Chamberlain <mcgrof@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5.10] MAINTAINERS: add Amir as xfs maintainer for 5.10.y
Message-ID: <YrzHuqVgvSgj8gP6@magnolia>
References: <20220629213236.495647-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220629213236.495647-1-amir73il@gmail.com>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 30, 2022 at 12:32:36AM +0300, Amir Goldstein wrote:
> This is an attempt to direct the bots and human that are testing
> LTS 5.10.y towards the maintainer of xfs in the 5.10.y tree.
> 
> This is not an upstream MAINTAINERS entry and 5.15.y and 5.4.y will
> have their own LTS xfs maintainer entries.
> 
> Suggested-by: Darrick J. Wong <djwong@kernel.org>
> Link: https://lore.kernel.org/linux-xfs/Yrx6%2F0UmYyuBPjEr@magnolia/T/#t
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 7c118b507912..574151230386 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -19247,6 +19247,7 @@ F:	drivers/xen/*swiotlb*
>  
>  XFS FILESYSTEM
>  M:	Darrick J. Wong <darrick.wong@oracle.com>
> +M:	Amir Goldstein <amir73il@gmail.com>

Sounds good to me, though you might want to move your name to be first
in line. :)

--D

>  M:	linux-xfs@vger.kernel.org
>  L:	linux-xfs@vger.kernel.org
>  S:	Supported
> -- 
> 2.36.1
> 
