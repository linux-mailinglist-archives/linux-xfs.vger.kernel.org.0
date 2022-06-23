Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0F50556F26
	for <lists+linux-xfs@lfdr.de>; Thu, 23 Jun 2022 01:31:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235512AbiFVXa6 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 22 Jun 2022 19:30:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377285AbiFVXa5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Jun 2022 19:30:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A93F427E8
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jun 2022 16:30:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1C6D5B8204E
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jun 2022 23:30:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAEA3C34114;
        Wed, 22 Jun 2022 23:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655940653;
        bh=wR2e2CaCXjYV/RO7a36vmsj40v8xpkBo1x6ilQfv0+o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WLsFPIWbZi24NY1k4eO1v8ioeflafnPQENVnB0pyukee2JbOIfcsALh3EBuJ/BrcA
         4NmuD2cu0n9vZ3870zpVvqLWXgCXhddyme2Ng+mnsbOU5Oj6HAnIa6dI1KjQpk1BO+
         r9I/WY0KyqFGs3dFjdKgjkST3g2ft0Gzsp0/3hbkT6hyKWPwRLQDeaaasLqNyjbh1a
         JWA1hO5NFq54seTROWJUfIxptdM8ZPJvmnjZWcm4eezxjZiwrVJKl/ps885Z63Gzha
         pidfS1SqZW6FbnTBtMaIsq1g/newYVbpGxaImPksAVuPy6o6pCaOpcrfAAHasrg0+r
         tLub5lNTEQQoQ==
Date:   Wed, 22 Jun 2022 16:30:53 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH V2] xfs: add selinux labels to whiteout inodes
Message-ID: <YrOmLRfS0eIrMCDl@magnolia>
References: <1655765731-21078-1-git-send-email-sandeen@redhat.com>
 <1655775516-8936-1-git-send-email-sandeen@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1655775516-8936-1-git-send-email-sandeen@redhat.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 20, 2022 at 08:38:36PM -0500, Eric Sandeen wrote:
> We got a report that "renameat2() with flags=RENAME_WHITEOUT doesn't
> apply an SELinux label on xfs" as it does on other filesystems
> (for example, ext4 and tmpfs.)  While I'm not quite sure how labels
> may interact w/ whiteout files, leaving them as unlabeled seems
> inconsistent at best. Now that xfs_init_security is not static,
> rename it to xfs_inode_init_security per dchinner's suggestion.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

Looks fine to me.  I wondered slightly if the label creation needs to be
atomic with the file creation, but quickly realized that /never/
happens.  Assuming this isn't high priority 5.19 stuff, I'll just roll
this into 5.20 if that's ok?

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_inode.c | 14 +++++++++++++-
>  fs/xfs/xfs_iops.c  | 11 +++++------
>  fs/xfs/xfs_iops.h  |  3 +++
>  3 files changed, 21 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 52d6f2c..58513a1 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -3046,10 +3046,12 @@ struct xfs_iunlink {
>  static int
>  xfs_rename_alloc_whiteout(
>  	struct user_namespace	*mnt_userns,
> +	struct xfs_name		*src_name,
>  	struct xfs_inode	*dp,
>  	struct xfs_inode	**wip)
>  {
>  	struct xfs_inode	*tmpfile;
> +	struct qstr		name;
>  	int			error;
>  
>  	error = xfs_create_tmpfile(mnt_userns, dp, S_IFCHR | WHITEOUT_MODE,
> @@ -3057,6 +3059,15 @@ struct xfs_iunlink {
>  	if (error)
>  		return error;
>  
> +	name.name = src_name->name;
> +	name.len = src_name->len;
> +	error = xfs_inode_init_security(VFS_I(tmpfile), VFS_I(dp), &name);
> +	if (error) {
> +		xfs_finish_inode_setup(tmpfile);
> +		xfs_irele(tmpfile);
> +		return error;
> +	}
> +
>  	/*
>  	 * Prepare the tmpfile inode as if it were created through the VFS.
>  	 * Complete the inode setup and flag it as linkable.  nlink is already
> @@ -3107,7 +3118,8 @@ struct xfs_iunlink {
>  	 * appropriately.
>  	 */
>  	if (flags & RENAME_WHITEOUT) {
> -		error = xfs_rename_alloc_whiteout(mnt_userns, target_dp, &wip);
> +		error = xfs_rename_alloc_whiteout(mnt_userns, src_name,
> +						  target_dp, &wip);
>  		if (error)
>  			return error;
>  
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 29f5b8b8..6720b60 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -75,9 +75,8 @@
>   * these attrs can be journalled at inode creation time (along with the
>   * inode, of course, such that log replay can't cause these to be lost).
>   */
> -
> -STATIC int
> -xfs_init_security(
> +int
> +xfs_inode_init_security(
>  	struct inode	*inode,
>  	struct inode	*dir,
>  	const struct qstr *qstr)
> @@ -122,7 +121,7 @@
>  
>  	/* Oh, the horror.
>  	 * If we can't add the ACL or we fail in
> -	 * xfs_init_security we must back out.
> +	 * xfs_inode_init_security we must back out.
>  	 * ENOSPC can hit here, among other things.
>  	 */
>  	xfs_dentry_to_name(&teardown, dentry);
> @@ -208,7 +207,7 @@
>  
>  	inode = VFS_I(ip);
>  
> -	error = xfs_init_security(inode, dir, &dentry->d_name);
> +	error = xfs_inode_init_security(inode, dir, &dentry->d_name);
>  	if (unlikely(error))
>  		goto out_cleanup_inode;
>  
> @@ -424,7 +423,7 @@
>  
>  	inode = VFS_I(cip);
>  
> -	error = xfs_init_security(inode, dir, &dentry->d_name);
> +	error = xfs_inode_init_security(inode, dir, &dentry->d_name);
>  	if (unlikely(error))
>  		goto out_cleanup_inode;
>  
> diff --git a/fs/xfs/xfs_iops.h b/fs/xfs/xfs_iops.h
> index 2789490..cb5fc68 100644
> --- a/fs/xfs/xfs_iops.h
> +++ b/fs/xfs/xfs_iops.h
> @@ -17,4 +17,7 @@
>  int xfs_vn_setattr_size(struct user_namespace *mnt_userns,
>  		struct dentry *dentry, struct iattr *vap);
>  
> +int xfs_inode_init_security(struct inode *inode, struct inode *dir,
> +		const struct qstr *qstr);
> +
>  #endif /* __XFS_IOPS_H__ */
> -- 
> 1.8.3.1
> 
