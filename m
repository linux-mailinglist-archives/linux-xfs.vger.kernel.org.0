Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5D1427B8C0
	for <lists+linux-xfs@lfdr.de>; Tue, 29 Sep 2020 02:15:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbgI2APX (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 28 Sep 2020 20:15:23 -0400
Received: from sandeen.net ([63.231.237.45]:50014 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727073AbgI2APX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 28 Sep 2020 20:15:23 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 8D21E616658;
        Mon, 28 Sep 2020 16:49:32 -0500 (CDT)
Subject: Re: [PATCH 6/6] mkfs: remove a couple of unused function parameters
To:     Anthony Iliopoulos <ailiop@suse.com>
Cc:     linux-xfs@vger.kernel.org
References: <20200824203724.13477-1-ailiop@suse.com>
 <20200824203724.13477-7-ailiop@suse.com>
From:   Eric Sandeen <sandeen@sandeen.net>
Message-ID: <ed3ca14f-363b-9a4e-b48d-cb5d0cc7f8e7@sandeen.net>
Date:   Mon, 28 Sep 2020 16:50:16 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200824203724.13477-7-ailiop@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 8/24/20 3:37 PM, Anthony Iliopoulos wrote:
> initialise_mount does not use mkfs_params, and initialise_ag_headers
> does not use the xfs_sb param, remove them.
> 
> Signed-off-by: Anthony Iliopoulos <ailiop@suse.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  mkfs/xfs_mkfs.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 1f142f78e677..03bbe3b4697d 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -3243,7 +3243,6 @@ start_superblock_setup(
>  
>  static void
>  initialise_mount(
> -	struct mkfs_params	*cfg,
>  	struct xfs_mount	*mp,
>  	struct xfs_sb		*sbp)
>  {
> @@ -3431,7 +3430,6 @@ static void
>  initialise_ag_headers(
>  	struct mkfs_params	*cfg,
>  	struct xfs_mount	*mp,
> -	struct xfs_sb		*sbp,
>  	xfs_agnumber_t		agno,
>  	int			*worst_freelist,
>  	struct list_head	*buffer_list)
> @@ -3776,7 +3774,7 @@ main(
>  	 * provided functions to determine on-disk format information.
>  	 */
>  	start_superblock_setup(&cfg, mp, sbp);
> -	initialise_mount(&cfg, mp, sbp);
> +	initialise_mount(mp, sbp);
>  
>  	/*
>  	 * With the mount set up, we can finally calculate the log size
> @@ -3829,7 +3827,7 @@ main(
>  	 */
>  	INIT_LIST_HEAD(&buffer_list);
>  	for (agno = 0; agno < cfg.agcount; agno++) {
> -		initialise_ag_headers(&cfg, mp, sbp, agno, &worst_freelist,
> +		initialise_ag_headers(&cfg, mp, agno, &worst_freelist,
>  				&buffer_list);
>  
>  		if (agno % 16)
> 
