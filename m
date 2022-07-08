Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 925A056BE06
	for <lists+linux-xfs@lfdr.de>; Fri,  8 Jul 2022 18:09:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232199AbiGHPyP (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 8 Jul 2022 11:54:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237941AbiGHPyP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Jul 2022 11:54:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE3422656B;
        Fri,  8 Jul 2022 08:54:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 631D161527;
        Fri,  8 Jul 2022 15:54:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B77C9C341CA;
        Fri,  8 Jul 2022 15:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657295653;
        bh=jRDcWS78yKGJslIY6crc1EZyTfTfEWx6hMY89/F+0J0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RT1U2BFhS0EXJSOp6Qhz6e2mCsUSfRY2uHW+ui+Vkn0a7MO/7O1XSPsBbFgUyN5CR
         s+Nr/+DhH80QQf6SCC9aaFu2krtPEullzpZGmCOQebrAAIeQeJrOvWWilZ1SFhor1t
         H0Ng+a2xkJ7y6YxGemdVgmp+OPS2V34BqTy1nxj0aSY2s3PKqROOVtpFW2VQ5A5QOm
         LQYWYN0BT8UvjvIeWkZCNsfBLrMeWUfO0LnMYvcsQfCBDz4FR4I2gkreoiscqns/xD
         jaECPJtxOAddWGL2lzONZ23bZzqAr20toSoNAaPOq4AAPDF6wqDxLhK/DSDQ1uBxk7
         qKg7AQxaoFsjA==
Date:   Fri, 8 Jul 2022 08:54:13 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     stable@vger.kernel.org, linux-xfs@vger.kernel.org,
        Ke Xu <kkexu@amazon.com>, Ayushman Dutta <ayudutta@amazon.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH stable 5.15] xfs: remove incorrect ASSERT in xfs_rename
Message-ID: <YshTJZVNkXpbGKsv@magnolia>
References: <20220707225835.32094-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220707225835.32094-1-kuniyu@amazon.com>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 07, 2022 at 03:58:35PM -0700, Kuniyuki Iwashima wrote:
> From: Eric Sandeen <sandeen@redhat.com>
> 
> commit e445976537ad139162980bee015b7364e5b64fff upstream.
> 
> Ayushman Dutta reported our 5.10 kernel hit the warning.  It was because
> the original commit misses a Fixes tag and was not backported to the stable
> tree.  The fix is merged in 5.16, so please backport it to 5.15 first.
> 
> This ASSERT in xfs_rename is a) incorrect, because
> (RENAME_WHITEOUT|RENAME_NOREPLACE) is a valid combination, and
> b) unnecessary, because actual invalid flag combinations are already
> handled at the vfs level in do_renameat2() before we get called.
> So, remove it.
> 
> Reported-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Fixes: 7dcf5c3e4527 ("xfs: add RENAME_WHITEOUT support")
> Reported-by: Ayushman Dutta <ayudutta@amazon.com>
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>

Looks good to me, but you really ought to send 5.10 patches to the 5.10
XFS maintainer (Amir, now cc'd).  (Yes, this is a recent change.) ;)

Acked-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
> I will send another patch for 4.9 - 5.4 because of a conflict with idmapped
> mount changes.
> ---
>  fs/xfs/xfs_inode.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 2477e301fa82..c19f3ca605af 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -3128,7 +3128,6 @@ xfs_rename(
>  	 * appropriately.
>  	 */
>  	if (flags & RENAME_WHITEOUT) {
> -		ASSERT(!(flags & (RENAME_NOREPLACE | RENAME_EXCHANGE)));
>  		error = xfs_rename_alloc_whiteout(mnt_userns, target_dp, &wip);
>  		if (error)
>  			return error;
> -- 
> 2.30.2
> 
