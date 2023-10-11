Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C120C7C587A
	for <lists+linux-xfs@lfdr.de>; Wed, 11 Oct 2023 17:49:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346776AbjJKPtl (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 11 Oct 2023 11:49:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235070AbjJKPtk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Oct 2023 11:49:40 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40DF0B6;
        Wed, 11 Oct 2023 08:49:39 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D78F6C433CA;
        Wed, 11 Oct 2023 15:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697039378;
        bh=XXRDRwSUqwJbcwzOjXaGJFweowuIRcYTDxSXcJxyu2s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SVa9pwNpg3W88IKEA33vm2tCyp5HYpsSDXbTjVhSkJxK2vbi9AVdHeNX0pLjuTgxb
         QpNTq2xKWcCIUW0/qQJrM9EWL/CHusnnHa5Zf2g0S6WkTFJJFnTL8PYP5gGgmD+3l5
         NXIpInmQMnrRif6G8IpDdytanjGNxY+Hgt+4Jx4QBOokSex1hN9Ny8qRGq5uRPyh13
         UTr7/jeQm6zbPgDdkHxrqVzWMpvZXm/echKXkNpHzp34X6vQ0BJT++SWK9hA6NYtAw
         OQ4SpKbGRGd5Hvk5G2tPC2xBDkp4Hq5dknA5vnk5SRZ5PbHnBVUbF5zHzUkGsgCFhW
         MSsAMkvazLsaw==
Date:   Wed, 11 Oct 2023 08:49:38 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Chandan Babu R <chandan.babu@oracle.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        linux-nfs@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        brauner@kernel.org
Subject: Re: [PATCH] xfs: reinstate the old i_version counter as
 STATX_CHANGE_COOKIE
Message-ID: <20231011154938.GL21298@frogsfrogsfrogs>
References: <20230929-xfs-iversion-v1-1-38587d7b5a52@kernel.org>
 <b4136500fe6c49ee689dba139ce25824684719f2.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b4136500fe6c49ee689dba139ce25824684719f2.camel@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 11, 2023 at 09:09:38AM -0400, Jeff Layton wrote:
> On Fri, 2023-09-29 at 14:43 -0400, Jeff Layton wrote:
> > The handling of STATX_CHANGE_COOKIE was moved into generic_fillattr in
> > commit 0d72b92883c6 (fs: pass the request_mask to generic_fillattr), but
> > we didn't account for the fact that xfs doesn't call generic_fillattr at
> > all.
> > 
> > Make XFS report its i_version as the STATX_CHANGE_COOKIE.
> > 
> > Fixes: 0d72b92883c6 (fs: pass the request_mask to generic_fillattr)
> > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > ---
> > I had hoped to fix this in a better way with the multigrain patches, but
> > it's taking longer than expected (if it even pans out at this point).
> > 
> > Until then, make sure we use XFS's i_version as the STATX_CHANGE_COOKIE,
> > even if it's bumped due to atime updates. Too many invalidations is
> > preferable to not enough.
> > ---
> >  fs/xfs/xfs_iops.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> > 
> > diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> > index 1c1e6171209d..2b3b05c28e9e 100644
> > --- a/fs/xfs/xfs_iops.c
> > +++ b/fs/xfs/xfs_iops.c
> > @@ -584,6 +584,11 @@ xfs_vn_getattr(
> >  		}
> >  	}
> >  
> > +	if ((request_mask & STATX_CHANGE_COOKIE) && IS_I_VERSION(inode)) {
> > +		stat->change_cookie = inode_query_iversion(inode);
> > +		stat->result_mask |= STATX_CHANGE_COOKIE;
> > +	}
> > +
> >  	/*
> >  	 * Note: If you add another clause to set an attribute flag, please
> >  	 * update attributes_mask below.
> > 
> > ---
> > base-commit: df964ce9ef9fea10cf131bf6bad8658fde7956f6
> > change-id: 20230929-xfs-iversion-819fa2c18591
> > 
> > Best regards,
> 
> Ping?
> 
> This patch is needed in v6.6 to prevent a regression when serving XFS
> via NFSD. I'd prefer this go in via the xfs tree, but let me know if
> you need me to get this merged this via a different one.

Oh!   Right, this is needed because the "hide a state in the high bit of
tv_nsec" stuff got reverted in -rc3, correct?  So now nfsd needs some
way to know that something changed in the file, and better to have too
many client invalidations than not enough?  And I guess bumping
i_version will keep nfsd sane for now?

If the answers are [yes, yes, yes] then:
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> Thanks,
> -- 
> Jeff Layton <jlayton@kernel.org>
