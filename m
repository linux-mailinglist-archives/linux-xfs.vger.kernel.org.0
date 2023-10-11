Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 147E07C54F0
	for <lists+linux-xfs@lfdr.de>; Wed, 11 Oct 2023 15:09:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234906AbjJKNJn (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 11 Oct 2023 09:09:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232308AbjJKNJn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Oct 2023 09:09:43 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B762D3;
        Wed, 11 Oct 2023 06:09:41 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCDF0C433C8;
        Wed, 11 Oct 2023 13:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697029780;
        bh=KxOJWQx0gCXD+pvd94GVAroIZnfAUS0u3K1gpuBGf6o=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=aRAi+5McYCClvfpkyuLVNSRKObTbg5YMEbrvQb/UgBgTLvPbVNBb6+AOfyZHAgEk2
         YbG3EkDYiO+3E0fJpfAGKfP9Vgs+Q3kSfIO3PNipLfGn7iiH1TSCAE2QD16f2uYtgX
         dwe2+ItGt/iKUP5+rxK5WOIJ+br55O6zAvW0z9id4qSDKfes+LylDqmUOY4UB5FK4w
         hgAtuWaUwtv4nHJ8/HYhA0R5LuodFiVSDJkf7B+YEQF6NRDPm1m/0n01Pb93QEKCH6
         plXcvPfw8jvC0o+IFYcXU9l445hjfrTcMFEfP7UpMt7m4MQQHmIicj/eHzUfAIyC41
         aHb2RdWpamXkg==
Message-ID: <b4136500fe6c49ee689dba139ce25824684719f2.camel@kernel.org>
Subject: Re: [PATCH] xfs: reinstate the old i_version counter as
 STATX_CHANGE_COOKIE
From:   Jeff Layton <jlayton@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>
Cc:     linux-nfs@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        brauner@kernel.org
Date:   Wed, 11 Oct 2023 09:09:38 -0400
In-Reply-To: <20230929-xfs-iversion-v1-1-38587d7b5a52@kernel.org>
References: <20230929-xfs-iversion-v1-1-38587d7b5a52@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.module_f38+17164+63eeee4a) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, 2023-09-29 at 14:43 -0400, Jeff Layton wrote:
> The handling of STATX_CHANGE_COOKIE was moved into generic_fillattr in
> commit 0d72b92883c6 (fs: pass the request_mask to generic_fillattr), but
> we didn't account for the fact that xfs doesn't call generic_fillattr at
> all.
>=20
> Make XFS report its i_version as the STATX_CHANGE_COOKIE.
>=20
> Fixes: 0d72b92883c6 (fs: pass the request_mask to generic_fillattr)
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
> I had hoped to fix this in a better way with the multigrain patches, but
> it's taking longer than expected (if it even pans out at this point).
>=20
> Until then, make sure we use XFS's i_version as the STATX_CHANGE_COOKIE,
> even if it's bumped due to atime updates. Too many invalidations is
> preferable to not enough.
> ---
>  fs/xfs/xfs_iops.c | 5 +++++
>  1 file changed, 5 insertions(+)
>=20
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 1c1e6171209d..2b3b05c28e9e 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -584,6 +584,11 @@ xfs_vn_getattr(
>  		}
>  	}
> =20
> +	if ((request_mask & STATX_CHANGE_COOKIE) && IS_I_VERSION(inode)) {
> +		stat->change_cookie =3D inode_query_iversion(inode);
> +		stat->result_mask |=3D STATX_CHANGE_COOKIE;
> +	}
> +
>  	/*
>  	 * Note: If you add another clause to set an attribute flag, please
>  	 * update attributes_mask below.
>=20
> ---
> base-commit: df964ce9ef9fea10cf131bf6bad8658fde7956f6
> change-id: 20230929-xfs-iversion-819fa2c18591
>=20
> Best regards,

Ping?

This patch is needed in v6.6 to prevent a regression when serving XFS
via NFSD. I'd prefer this go in via the xfs tree, but let me know if
you need me to get this merged this via a different one.

Thanks,
--=20
Jeff Layton <jlayton@kernel.org>
