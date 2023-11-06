Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 120497E2FD2
	for <lists+linux-xfs@lfdr.de>; Mon,  6 Nov 2023 23:28:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233058AbjKFW2A (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 6 Nov 2023 17:28:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232005AbjKFW17 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Nov 2023 17:27:59 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CF341BC
        for <linux-xfs@vger.kernel.org>; Mon,  6 Nov 2023 14:27:57 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30287C433C8;
        Mon,  6 Nov 2023 22:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1699309677;
        bh=YoKNm/ixirXXBD8bsKh0OidCV7LojtKe7WmjY7Vjs50=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=E/zVZgmOOxDesbACsGDnrKI1L16Aoy+v1zHWImGuWpYcWruwS83FGJxxlpWteZdm2
         8+/POTDEr72Sa33AV/fQz7zGoRDMwBugppCSrWW0l4E7ZpqYFSsFmWWSN09z4kbQLb
         jPUNc2O3QLuaYB33GpVqcNrIKIxCZntIdE67yQA2vAiH/xbVFdffwFD3Zu7StvT6lz
         cyvrmLWn5+xJwzrhZ+WbecgAXYFQx68ShCpKyvkDh37O0teZNsQDQT27G+XkuwlgRw
         JFgQcvrlnMSS6ZbwhMq+uUnot1yFECJ80b2bNPIE3XUwCwWEjHNyXCRgpbFtM2zdUl
         2jTXi9UsgG2xg==
Date:   Mon, 6 Nov 2023 14:27:56 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Anthony Iliopoulos <ailiop@suse.com>
Cc:     linux-xfs@vger.kernel.org,
        Holger =?iso-8859-1?Q?Hoffst=E4tte?= 
        <holger@applied-asynchrony.com>
Subject: Re: [PATCH] xfs: fix again select in kconfig XFS_ONLINE_SCRUB_STATS
Message-ID: <20231106222756.GK1205143@frogsfrogsfrogs>
References: <20231105192318.121783-1-ailiop@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20231105192318.121783-1-ailiop@suse.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Nov 05, 2023 at 08:23:18PM +0100, Anthony Iliopoulos wrote:
> Commit 57c0f4a8ea3a attempted to fix the select in the kconfig entry
> XFS_ONLINE_SCRUB_STATS by selecting XFS_DEBUG, but the original
> intention was to select DEBUG_FS, since the feature relies on debugfs to
> export the related scrub statistics.
> 
> Fixes: 57c0f4a8ea3a ("xfs: fix select in config XFS_ONLINE_SCRUB_STATS")
> 
> Reported-by: Holger Hoffstätte <holger@applied-asynchrony.com>
> Signed-off-by: Anthony Iliopoulos <ailiop@suse.com>

Yep.  Sorry about that garbledygook.
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/Kconfig b/fs/xfs/Kconfig
> index ed0bc8cbc703..567fb37274d3 100644
> --- a/fs/xfs/Kconfig
> +++ b/fs/xfs/Kconfig
> @@ -147,7 +147,7 @@ config XFS_ONLINE_SCRUB_STATS
>  	bool "XFS online metadata check usage data collection"
>  	default y
>  	depends on XFS_ONLINE_SCRUB
> -	select XFS_DEBUG
> +	select DEBUG_FS
>  	help
>  	  If you say Y here, the kernel will gather usage data about
>  	  the online metadata check subsystem.  This includes the number
> -- 
> 2.42.0
> 
