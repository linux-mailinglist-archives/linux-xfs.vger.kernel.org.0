Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5978727B8BF
	for <lists+linux-xfs@lfdr.de>; Tue, 29 Sep 2020 02:15:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727094AbgI2APX (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 28 Sep 2020 20:15:23 -0400
Received: from sandeen.net ([63.231.237.45]:50012 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726944AbgI2APX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 28 Sep 2020 20:15:23 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 5C7D1616653;
        Mon, 28 Sep 2020 16:49:08 -0500 (CDT)
Subject: Re: [PATCH 5/6] mkfs: remove redundant assignment of cli sb options
 on failure
To:     Anthony Iliopoulos <ailiop@suse.com>
Cc:     linux-xfs@vger.kernel.org
References: <20200824203724.13477-1-ailiop@suse.com>
 <20200824203724.13477-6-ailiop@suse.com>
From:   Eric Sandeen <sandeen@sandeen.net>
Message-ID: <cd2b2f0a-11a5-b0ff-779b-149f133605b1@sandeen.net>
Date:   Mon, 28 Sep 2020 16:49:51 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200824203724.13477-6-ailiop@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 8/24/20 3:37 PM, Anthony Iliopoulos wrote:
> rmapbt and reflink are incompatible with realtime devices and mkfs bails
> out on such configurations.  Switching them off in the cli params after
> exit is dead code, remove it.
> 
> Signed-off-by: Anthony Iliopoulos <ailiop@suse.com>

I'll go ahead & pull patches 5 & 6 since they're standalone fixes.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>


> ---
>  mkfs/xfs_mkfs.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 75e910dd4a30..1f142f78e677 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -1995,14 +1995,12 @@ _("cowextsize not supported without reflink support\n"));
>  		fprintf(stderr,
>  _("reflink not supported with realtime devices\n"));
>  		usage();
> -		cli->sb_feat.reflink = false;
>  	}
>  
>  	if (cli->sb_feat.rmapbt && cli->xi->rtname) {
>  		fprintf(stderr,
>  _("rmapbt not supported with realtime devices\n"));
>  		usage();
> -		cli->sb_feat.rmapbt = false;
>  	}
>  
>  	if (cli->sb_feat.reflink && ft->dax) {
> 
