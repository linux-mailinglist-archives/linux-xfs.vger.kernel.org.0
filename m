Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D16692928A1
	for <lists+linux-xfs@lfdr.de>; Mon, 19 Oct 2020 15:54:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728425AbgJSNy3 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 19 Oct 2020 09:54:29 -0400
Received: from sandeen.net ([63.231.237.45]:38804 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728277AbgJSNy3 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 19 Oct 2020 09:54:29 -0400
Received: from liberator.local (unknown [10.0.1.163])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 883332541;
        Mon, 19 Oct 2020 08:53:08 -0500 (CDT)
To:     xiakaixu1987@gmail.com, linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, Kaixu Xia <kaixuxia@tencent.com>
References: <1603100845-12205-1-git-send-email-kaixuxia@tencent.com>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH] xfs: remove the unused BBMASK macro
Message-ID: <c1453fb1-3e84-677c-15ab-7f51ca758862@sandeen.net>
Date:   Mon, 19 Oct 2020 08:54:28 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <1603100845-12205-1-git-send-email-kaixuxia@tencent.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 10/19/20 4:47 AM, xiakaixu1987@gmail.com wrote:
> From: Kaixu Xia <kaixuxia@tencent.com>
> 
> There are no callers of the BBMASK macro, so remove it.
> 
> Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
> ---
>  fs/xfs/libxfs/xfs_fs.h | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> index 2a2e3cfd94f0..8fd1e20f0d73 100644
> --- a/fs/xfs/libxfs/xfs_fs.h
> +++ b/fs/xfs/libxfs/xfs_fs.h
> @@ -847,7 +847,6 @@ struct xfs_scrub_metadata {
>   */
>  #define BBSHIFT		9
>  #define BBSIZE		(1<<BBSHIFT)
> -#define BBMASK		(BBSIZE-1)
>  #define BTOBB(bytes)	(((__u64)(bytes) + BBSIZE - 1) >> BBSHIFT)
>  #define BTOBBT(bytes)	((__u64)(bytes) >> BBSHIFT)
>  #define BBTOB(bbs)	((bbs) << BBSHIFT)


This header is shared with userspace, and the macro is used there,
though only once.

This header is also shipped as part of the "install-dev" fileset, and
defines a public API, though I don't think BBMSK is actually used
in any userspace interface.

-Eric
