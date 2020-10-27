Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F31B929C113
	for <lists+linux-xfs@lfdr.de>; Tue, 27 Oct 2020 18:22:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1818666AbgJ0RWh (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 27 Oct 2020 13:22:37 -0400
Received: from sandeen.net ([63.231.237.45]:49068 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1818683AbgJ0RW1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 27 Oct 2020 13:22:27 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 52314324E5E;
        Tue, 27 Oct 2020 12:22:14 -0500 (CDT)
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <160375511371.879169.3659553317719857738.stgit@magnolia>
 <160375511989.879169.8816363379781873320.stgit@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 1/5] mkfs: allow users to specify rtinherit=0
Message-ID: <be9be8b9-55ab-3e13-fa42-c9f5a5275252@sandeen.net>
Date:   Tue, 27 Oct 2020 12:22:25 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <160375511989.879169.8816363379781873320.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 10/26/20 6:31 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> mkfs has quite a few boolean options that can be specified in several
> ways: "option=1" (turn it on), "option" (turn it on), or "option=0"
> (turn it off).  For whatever reason, rtinherit sticks out as the only
> mkfs parameter that doesn't behave that way.  Let's make it behave the
> same as all the other boolean variables.

Seems fine; tho looking over mkfs.xfs.8, I think we could clarify what all
the valid ${FOO}inherit=[value] values are, in general.

Reviewed-by: Eric Sandeen <sandeen@redhat.com> 

-Eric

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  mkfs/xfs_mkfs.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 8fe149d74b0a..908d520df909 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -349,7 +349,7 @@ static struct opt_params dopts = {
>  		},
>  		{ .index = D_RTINHERIT,
>  		  .conflicts = { { NULL, LAST_CONFLICT } },
> -		  .minval = 1,
> +		  .minval = 0,
>  		  .maxval = 1,
>  		  .defaultval = 1,
>  		},
> @@ -1429,6 +1429,8 @@ data_opts_parser(
>  	case D_RTINHERIT:
>  		if (getnum(value, opts, subopt))
>  			cli->fsx.fsx_xflags |= FS_XFLAG_RTINHERIT;
> +		else
> +			cli->fsx.fsx_xflags &= ~FS_XFLAG_RTINHERIT;
>  		break;
>  	case D_PROJINHERIT:
>  		cli->fsx.fsx_projid = getnum(value, opts, subopt);
> 
