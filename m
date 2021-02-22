Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34AA5322214
	for <lists+linux-xfs@lfdr.de>; Mon, 22 Feb 2021 23:20:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230008AbhBVWUX (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 22 Feb 2021 17:20:23 -0500
Received: from sandeen.net ([63.231.237.45]:37628 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229518AbhBVWUX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 22 Feb 2021 17:20:23 -0500
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id E6DE9324E5E;
        Mon, 22 Feb 2021 16:19:28 -0600 (CST)
To:     Pavel Reichl <preichl@redhat.com>, linux-xfs@vger.kernel.org
References: <20210220221549.290538-1-preichl@redhat.com>
 <20210220221549.290538-3-preichl@redhat.com>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 1/1] xfs: Skip repetitive warnings about mount options
Message-ID: <61f66b91-4343-f28e-dd47-6b6c70ee8b96@sandeen.net>
Date:   Mon, 22 Feb 2021 16:19:41 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210220221549.290538-3-preichl@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


On 2/20/21 4:15 PM, Pavel Reichl wrote:
> Skip the warnings about mount option being deprecated if we are
> remounting and deprecated option state is not changing.
> 
> Bug: https://bugzilla.kernel.org/show_bug.cgi?id=211605
> Fix-suggested-by: Eric Sandeen <sandeen@redhat.com>
> Signed-off-by: Pavel Reichl <preichl@redhat.com>
> ---
>  fs/xfs/xfs_super.c | 23 +++++++++++++++++++----
>  1 file changed, 19 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 813be879a5e5..6724a7018d1f 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1169,6 +1169,13 @@ xfs_fs_parse_param(
>  	struct fs_parse_result	result;
>  	int			size = 0;
>  	int			opt;
> +	uint64_t                prev_m_flags = 0; /* Mount flags of prev. mount */
> +	bool			remounting = fc->purpose & FS_CONTEXT_FOR_RECONFIGURE;
> +
> +	/* if reconfiguring then get mount flags of previous flags */
> +	if (remounting) {
> +		prev_m_flags  = XFS_M(fc->root->d_sb)->m_flags;

I wonder, does mp->m_flags work just as well for this purpose? I do get lost
in how the mount api stashes things. I /think/ that the above is just a
long way of getting to mp->m_flags.

> +	}
>  
>  	opt = fs_parse(fc, xfs_fs_parameters, param, &result);
>  	if (opt < 0)
> @@ -1294,19 +1301,27 @@ xfs_fs_parse_param(
>  #endif
>  	/* Following mount options will be removed in September 2025 */
>  	case Opt_ikeep:
> -		xfs_warn(mp, "%s mount option is deprecated.", param->key);
> +		if (!remounting ||  !(prev_m_flags & XFS_MOUNT_IKEEP)) {

while we're nitpicking whitespace, ^^ 2 spaces there

as for the prev_m_flags usage, does:

+		if (!remounting || !(mp->m_flags & XFS_MOUNT_IKEEP)) {

work just as well here or no?

> +			xfs_warn(mp, "%s mount option is deprecated.", param->key);
> +		}
>  		mp->m_flags |= XFS_MOUNT_IKEEP;
>  		return 0;
>  	case Opt_noikeep:
> -		xfs_warn(mp, "%s mount option is deprecated.", param->key);
> +		if (!remounting || prev_m_flags & XFS_MOUNT_IKEEP) {

and I dunno, I think I'd like parentheses for clarity here i.e.:

+		if (!remounting || (prev_m_flags & XFS_MOUNT_IKEEP)) {

Thanks,
-Eric


> +			xfs_warn(mp, "%s mount option is deprecated.", param->key);
> +		}
>  		mp->m_flags &= ~XFS_MOUNT_IKEEP;
>  		return 0;
>  	case Opt_attr2:
> -		xfs_warn(mp, "%s mount option is deprecated.", param->key);
> +		if (!remounting || !(prev_m_flags & XFS_MOUNT_ATTR2)) {
> +			xfs_warn(mp, "%s mount option is deprecated.", param->key);
> +		}
>  		mp->m_flags |= XFS_MOUNT_ATTR2;
>  		return 0;
>  	case Opt_noattr2:
> -		xfs_warn(mp, "%s mount option is deprecated.", param->key);
> +		if (!remounting || !(prev_m_flags & XFS_MOUNT_NOATTR2)) {
> +			xfs_warn(mp, "%s mount option is deprecated.", param->key);
> +		}
>  		mp->m_flags &= ~XFS_MOUNT_ATTR2;
>  		mp->m_flags |= XFS_MOUNT_NOATTR2;
>  		return 0;
> 
