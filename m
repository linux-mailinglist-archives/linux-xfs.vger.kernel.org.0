Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4D8C252228
	for <lists+linux-xfs@lfdr.de>; Tue, 25 Aug 2020 22:48:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726149AbgHYUsQ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 25 Aug 2020 16:48:16 -0400
Received: from sandeen.net ([63.231.237.45]:44602 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726666AbgHYUsP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 25 Aug 2020 16:48:15 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 1174B2ACC;
        Tue, 25 Aug 2020 15:48:05 -0500 (CDT)
Subject: Re: [PATCH] xfs: initialize the shortform attr header padding entry
To:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
Cc:     Eric Sandeen <sandeen@redhat.com>
References: <20200825202853.GE6096@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Message-ID: <1c61a2a6-42aa-55b9-49e3-57541b7dae80@sandeen.net>
Date:   Tue, 25 Aug 2020 15:48:13 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.1.1
MIME-Version: 1.0
In-Reply-To: <20200825202853.GE6096@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 8/25/20 3:28 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Don't leak kernel memory contents into the shortform attr fork.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

I noticed this too, thanks.

thought I wonder if 

a) others lurk and
b) if we should just be memsetting if_data to zero to avoid the need
   to carefully initialize all of everything always?

Anyway it fixes the problem we noticed so

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  fs/xfs/libxfs/xfs_attr_leaf.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index 8623c815164a..e1a3d225a77d 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -656,6 +656,7 @@ xfs_attr_shortform_create(
>  	hdr = (xfs_attr_sf_hdr_t *)ifp->if_u1.if_data;
>  	hdr->count = 0;
>  	hdr->totsize = cpu_to_be16(sizeof(*hdr));
> +	hdr->padding = 0;
>  	xfs_trans_log_inode(args->trans, dp, XFS_ILOG_CORE | XFS_ILOG_ADATA);
>  }
>  
> 
