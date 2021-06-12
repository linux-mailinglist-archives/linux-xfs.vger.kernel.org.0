Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE1563A4BCF
	for <lists+linux-xfs@lfdr.de>; Sat, 12 Jun 2021 02:53:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbhFLAzT (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 11 Jun 2021 20:55:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:56826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229942AbhFLAzS (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 11 Jun 2021 20:55:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3EFFA61287;
        Sat, 12 Jun 2021 00:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623459199;
        bh=aToDz5Br7iOoXq9+eOXI8LiZMYSzbIG64qK/83p84Lo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oSMasUgZq4jl3EZO32n8L/DW3IgFRp0sl1x4avkDZw432nmfXNVIyJJQUhunLCOol
         sA/WKRfPsZEvOdgXQXzlyc1cWdmy/f65/zquiePdoAGRPtSOMCFBlSDHXGlxRJSbXw
         WlBNQUibpRgYRSWM1AzMKRrLWiJ8ZAAH3F0OJveM4C9oQWBGXzorkfPlUupZrOsQ5H
         q0Iii9kRjcWk/POAStLuAwcOpalu506PKQL1FTJQMlnRgDBqy9FJGh139eBvoBCoy/
         7lGwmIgqBpNzb5rs3G7QY6s/O8iaHclbCeT0NB48b+zQx0oYXtp0+9gAKvajcrAMve
         bvpkRfLMylwFQ==
Date:   Fri, 11 Jun 2021 17:53:18 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Shaokun Zhang <zhangshaokun@hisilicon.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: remove redundant initialization of variable error
Message-ID: <20210612005318.GJ2945738@locust>
References: <1622883170-33317-1-git-send-email-zhangshaokun@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1622883170-33317-1-git-send-email-zhangshaokun@hisilicon.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jun 05, 2021 at 04:52:50PM +0800, Shaokun Zhang wrote:
> 'error' will be initialized, so clean up the redundant initialization.
> 
> Cc: "Darrick J. Wong" <djwong@kernel.org>
> Signed-off-by: Shaokun Zhang <zhangshaokun@hisilicon.com>

Looks ok,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_buf.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 592800c8852f..59991c8c7127 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -707,7 +707,7 @@ xfs_buf_get_map(
>  {
>  	struct xfs_buf		*bp;
>  	struct xfs_buf		*new_bp;
> -	int			error = 0;
> +	int			error;
>  
>  	*bpp = NULL;
>  	error = xfs_buf_find(target, map, nmaps, flags, NULL, &bp);
> -- 
> 2.7.4
> 
