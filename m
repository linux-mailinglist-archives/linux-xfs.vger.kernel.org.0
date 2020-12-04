Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33E412CF5B4
	for <lists+linux-xfs@lfdr.de>; Fri,  4 Dec 2020 21:35:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726441AbgLDUfl (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 4 Dec 2020 15:35:41 -0500
Received: from sandeen.net ([63.231.237.45]:40118 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726021AbgLDUfl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 4 Dec 2020 15:35:41 -0500
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id A726F48C6A0;
        Fri,  4 Dec 2020 14:34:40 -0600 (CST)
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <160679383892.447856.12907477074923729733.stgit@magnolia>
 <160679385732.447856.1039349578089907881.stgit@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 3/3] xfs: enable the needsrepair feature
Message-ID: <66b614ce-62ea-efc5-0682-e34d291b20ce@sandeen.net>
Date:   Fri, 4 Dec 2020 14:35:00 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <160679385732.447856.1039349578089907881.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 11/30/20 9:37 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Make it so that libxfs recognizes the needsrepair feature.  Note that
> the kernel will still refuse to mount these.

Not sure it needs to be a separate patch from the prior one, but it
looks fine.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

But maybe give me a chance to play with userspace in anger before you
merge these? ;)

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_format.h |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index 5d8ba609ac0b..f64eed3ccfed 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -473,7 +473,8 @@ xfs_sb_has_ro_compat_feature(
>  		(XFS_SB_FEAT_INCOMPAT_FTYPE|	\
>  		 XFS_SB_FEAT_INCOMPAT_SPINODES|	\
>  		 XFS_SB_FEAT_INCOMPAT_META_UUID| \
> -		 XFS_SB_FEAT_INCOMPAT_BIGTIME)
> +		 XFS_SB_FEAT_INCOMPAT_BIGTIME| \
> +		 XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR)
>  
>  #define XFS_SB_FEAT_INCOMPAT_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_ALL
>  static inline bool
> 
