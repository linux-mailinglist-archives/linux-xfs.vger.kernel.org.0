Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75D7236E641
	for <lists+linux-xfs@lfdr.de>; Thu, 29 Apr 2021 09:49:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237247AbhD2Huf (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 29 Apr 2021 03:50:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232455AbhD2Hue (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Apr 2021 03:50:34 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A25C0C06138B
        for <linux-xfs@vger.kernel.org>; Thu, 29 Apr 2021 00:49:48 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id h7so5745441plt.1
        for <linux-xfs@vger.kernel.org>; Thu, 29 Apr 2021 00:49:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version:content-transfer-encoding;
        bh=q8l+Iceqh9PnoBjL9KiyRpedrtUUv2q5m4EWCqMapog=;
        b=Xxw6rKE29ugUJkAuUDHlV+6RVjOT3t78FpSgjrDKuXCKYId2UvKRHIgxBp/n9+/HCM
         +4IAhjId6MVxKzqg5atMxZqn/yHD2T1vhr2F7rI2G8OBKKpkVP8po8wLFjcTl8FNYmv+
         pUYlFdjaWU04jGhCa/44UOiTxKjqbp8PAe6UnKT4gNJxsAHK1fMjovNlC3zdf9uU0bcr
         CUx2NFtdMJ1SvCiyIYdaWac/R+lO/Q6w6/bak5C5BHXYwAaAHXDrLFJZkq7E+ECYj2TL
         a8hg5R+UUjy8iQq7AP/pLwaPUbP0Jplaeio+GrPpzJ9F5TuN0SeFr9vMYtcnia4I948k
         UDxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version:content-transfer-encoding;
        bh=q8l+Iceqh9PnoBjL9KiyRpedrtUUv2q5m4EWCqMapog=;
        b=SDwM53SKUYKiAOyNDiS5/h/vckBzde52URRYbqRRgXowJp8PTnjgVg9ijAQ6JT2kQM
         pgNhzHCL74PxK2nRzupS98kHyf5nS2qY57Fc1F2JPLiYP4wfJV5d1ij/E/H3GEoTN3g1
         t8jsudaqpCuapOuD/R2jEnYNFAit87JFm7OShlTW07g25Un7LK+/JPOdrxJa+15008HZ
         g2arwtZ/awKWjjIgSaZUbSVV+qDorb/fAYVVe5wOgcmuG76djLwmoogpdWpceHeoRwrV
         IQepdFV7bzxNLPYOPQjid9qv3Pqh9+abRAom8TTPlBt+uP5rjD/WK2gZnOpFogGprRKm
         rweQ==
X-Gm-Message-State: AOAM5304xUzFgO7Y/xQFjR3vKPEH8kNPN5QAIIOre+fiaMntSkm60u0n
        QknxzGGEtPM+lfDXbG642xrZdyQtXFU=
X-Google-Smtp-Source: ABdhPJxjyCAtT/dxG4yRBD90TZwPYyzmmXi9SAYy1XhahfOSfbZSFCiDjfhSpebgW7bRmo8m1JB8yQ==
X-Received: by 2002:a17:90a:4e81:: with SMTP id o1mr7928153pjh.7.1619682587748;
        Thu, 29 Apr 2021 00:49:47 -0700 (PDT)
Received: from garuda ([122.179.68.135])
        by smtp.gmail.com with ESMTPSA id c23sm1779702pgj.50.2021.04.29.00.49.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 29 Apr 2021 00:49:47 -0700 (PDT)
References: <20210428080919.20331-1-allison.henderson@oracle.com> <20210428080919.20331-11-allison.henderson@oracle.com>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v18 10/11] xfs: Add delay ready attr remove routines
In-reply-to: <20210428080919.20331-11-allison.henderson@oracle.com>
Date:   Thu, 29 Apr 2021 13:19:44 +0530
Message-ID: <87h7jpa5t3.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

On 28 Apr 2021 at 13:39, Allison Henderson wrote:
> This patch modifies the attr remove routines to be delay ready. This
> means they no longer roll or commit transactions, but instead return
> -EAGAIN to have the calling routine roll and refresh the transaction. In
> this series, xfs_attr_remove_args is merged with
> xfs_attr_node_removename become a new function, xfs_attr_remove_iter.
> This new version uses a sort of state machine like switch to keep track
> of where it was when EAGAIN was returned. A new version of
> xfs_attr_remove_args consists of a simple loop to refresh the
> transaction until the operation is completed. A new XFS_DAC_DEFER_FINISH
> flag is used to finish the transaction where ever the existing code used
> to.
>
> Calls to xfs_attr_rmtval_remove are replaced with the delay ready
> version __xfs_attr_rmtval_remove. We will rename
> __xfs_attr_rmtval_remove back to xfs_attr_rmtval_remove when we are
> done.
>
> xfs_attr_rmtval_remove itself is still in use by the set routines (used
> during a rename).  For reasons of preserving existing function, we
> modify xfs_attr_rmtval_remove to call xfs_defer_finish when the flag is
> set.  Similar to how xfs_attr_remove_args does here.  Once we transition
> the set routines to be delay ready, xfs_attr_rmtval_remove is no longer
> used and will be removed.
>
> This patch also adds a new struct xfs_delattr_context, which we will use
> to keep track of the current state of an attribute operation. The new
> xfs_delattr_state enum is used to track various operations that are in
> progress so that we know not to repeat them, and resume where we left
> off before EAGAIN was returned to cycle out the transaction. Other
> members take the place of local variables that need to retain their
> values across multiple function recalls.  See xfs_attr.h for a more
> detailed diagram of the states.
>

The error handling issues pointed out in the previous version of the this
patch have been fixed.

> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c        | 213 ++++++++++++++++++++++++++++------=
------
>  fs/xfs/libxfs/xfs_attr.h        | 131 ++++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_attr_leaf.c   |   2 +-
>  fs/xfs/libxfs/xfs_attr_remote.c |  48 +++++----
>  fs/xfs/libxfs/xfs_attr_remote.h |   2 +-
>  fs/xfs/xfs_attr_inactive.c      |   2 +-
>  6 files changed, 314 insertions(+), 84 deletions(-)
>
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 21f862e..a91fff6 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -57,7 +57,6 @@ STATIC int xfs_attr_node_addname(struct xfs_da_args *ar=
gs,
>  				 struct xfs_da_state *state);
>  STATIC int xfs_attr_node_addname_find_attr(struct xfs_da_args *args,
>  				 struct xfs_da_state **state);
> -STATIC int xfs_attr_node_removename(xfs_da_args_t *args);
>  STATIC int xfs_attr_node_addname_clear_incomplete(struct xfs_da_args *ar=
gs);
>  STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
>  				 struct xfs_da_state **state);
> @@ -241,6 +240,31 @@ xfs_attr_is_shortform(
>  		ip->i_afp->if_nextents =3D=3D 0);
>  }
>
> +/*
> + * Checks to see if a delayed attribute transaction should be rolled.  I=
f so,
> + * transaction is finished or rolled as needed.
> + */
> +int
> +xfs_attr_trans_roll(
> +	struct xfs_delattr_context	*dac)
> +{
> +	struct xfs_da_args		*args =3D dac->da_args;
> +	int				error;
> +
> +	if (dac->flags & XFS_DAC_DEFER_FINISH) {
> +		/*
> +		 * The caller wants us to finish all the deferred ops so that we
> +		 * avoid pinning the log tail with a large number of deferred
> +		 * ops.
> +		 */
> +		dac->flags &=3D ~XFS_DAC_DEFER_FINISH;
> +		error =3D xfs_defer_finish(&args->trans);
> +	} else
> +		error =3D xfs_trans_roll_inode(&args->trans, args->dp);
> +
> +	return error;
> +}
> +
>  STATIC int
>  xfs_attr_set_fmt(
>  	struct xfs_da_args	*args)
> @@ -544,16 +568,25 @@ xfs_has_attr(
>   */
>  int
>  xfs_attr_remove_args(
> -	struct xfs_da_args      *args)
> +	struct xfs_da_args	*args)
>  {
> -	if (!xfs_inode_hasattr(args->dp))
> -		return -ENOATTR;
> +	int				error;
> +	struct xfs_delattr_context	dac =3D {
> +		.da_args	=3D args,
> +	};
>
> -	if (args->dp->i_afp->if_format =3D=3D XFS_DINODE_FMT_LOCAL)
> -		return xfs_attr_shortform_remove(args);
> -	if (xfs_attr_is_leaf(args->dp))
> -		return xfs_attr_leaf_removename(args);
> -	return xfs_attr_node_removename(args);
> +	do {
> +		error =3D xfs_attr_remove_iter(&dac);
> +		if (error !=3D -EAGAIN)
> +			break;
> +
> +		error =3D xfs_attr_trans_roll(&dac);
> +		if (error)
> +			return error;
> +
> +	} while (true);
> +
> +	return error;
>  }
>
>  /*
> @@ -1197,14 +1230,16 @@ xfs_attr_leaf_mark_incomplete(
>   */
>  STATIC
>  int xfs_attr_node_removename_setup(
> -	struct xfs_da_args	*args,
> -	struct xfs_da_state	**state)
> +	struct xfs_delattr_context	*dac)
>  {
> -	int			error;
> +	struct xfs_da_args		*args =3D dac->da_args;
> +	struct xfs_da_state		**state =3D &dac->da_state;
> +	int				error;
>
>  	error =3D xfs_attr_node_hasname(args, state);
>  	if (error !=3D -EEXIST)
>  		return error;
> +	error =3D 0;
>
>  	ASSERT((*state)->path.blk[(*state)->path.active - 1].bp !=3D NULL);
>  	ASSERT((*state)->path.blk[(*state)->path.active - 1].magic =3D=3D
> @@ -1213,12 +1248,15 @@ int xfs_attr_node_removename_setup(
>  	if (args->rmtblkno > 0) {
>  		error =3D xfs_attr_leaf_mark_incomplete(args, *state);
>  		if (error)
> -			return error;
> +			goto out;
>
> -		return xfs_attr_rmtval_invalidate(args);
> +		error =3D xfs_attr_rmtval_invalidate(args);
>  	}
> +out:
> +	if (error)
> +		xfs_da_state_free(*state);
>
> -	return 0;
> +	return error;
>  }
>
>  STATIC int
> @@ -1241,70 +1279,123 @@ xfs_attr_node_remove_name(
>  }
>
>  /*
> - * Remove a name from a B-tree attribute list.
> + * Remove the attribute specified in @args.
>   *
>   * This will involve walking down the Btree, and may involve joining
>   * leaf nodes and even joining intermediate nodes up to and including
>   * the root node (a special case of an intermediate node).
> + *
> + * This routine is meant to function as either an in-line or delayed ope=
ration,
> + * and may return -EAGAIN when the transaction needs to be rolled.  Call=
ing
> + * functions will need to handle this, and recall the function until a
> + * successful error code is returned.
>   */
> -STATIC int
> -xfs_attr_node_removename(
> -	struct xfs_da_args	*args)
> +int
> +xfs_attr_remove_iter(
> +	struct xfs_delattr_context	*dac)
>  {
> -	struct xfs_da_state	*state;
> -	int			retval, error;
> -	struct xfs_inode	*dp =3D args->dp;
> +	struct xfs_da_args		*args =3D dac->da_args;
> +	struct xfs_da_state		*state =3D dac->da_state;
> +	int				retval, error;
> +	struct xfs_inode		*dp =3D args->dp;
>
>  	trace_xfs_attr_node_removename(args);
>
> -	error =3D xfs_attr_node_removename_setup(args, &state);
> -	if (error)
> -		goto out;
> +	switch (dac->dela_state) {
> +	case XFS_DAS_UNINIT:
> +		if (!xfs_inode_hasattr(dp))
> +			return -ENOATTR;
>
> -	/*
> -	 * If there is an out-of-line value, de-allocate the blocks.
> -	 * This is done before we remove the attribute so that we don't
> -	 * overflow the maximum size of a transaction and/or hit a deadlock.
> -	 */
> -	if (args->rmtblkno > 0) {
> -		error =3D xfs_attr_rmtval_remove(args);
> -		if (error)
> -			goto out;
> +		/*
> +		 * Shortform or leaf formats don't require transaction rolls and
> +		 * thus state transitions. Call the right helper and return.
> +		 */
> +		if (dp->i_afp->if_format =3D=3D XFS_DINODE_FMT_LOCAL)
> +			return xfs_attr_shortform_remove(args);
> +
> +		if (xfs_attr_is_leaf(dp))
> +			return xfs_attr_leaf_removename(args);
>
>  		/*
> -		 * Refill the state structure with buffers, the prior calls
> -		 * released our buffers.
> +		 * Node format may require transaction rolls. Set up the
> +		 * state context and fall into the state machine.
>  		 */
> -		error =3D xfs_attr_refillstate(state);
> -		if (error)
> -			goto out;
> -	}
> -	retval =3D xfs_attr_node_remove_name(args, state);
> +		if (!dac->da_state) {
> +			error =3D xfs_attr_node_removename_setup(dac);
> +			if (error)
> +				return error;
> +			state =3D dac->da_state;
> +		}
> +
> +		/* fallthrough */
> +	case XFS_DAS_RMTBLK:
> +		dac->dela_state =3D XFS_DAS_RMTBLK;
>
> -	/*
> -	 * Check to see if the tree needs to be collapsed.
> -	 */
> -	if (retval && (state->path.active > 1)) {
> -		error =3D xfs_da3_join(state);
> -		if (error)
> -			goto out;
> -		error =3D xfs_defer_finish(&args->trans);
> -		if (error)
> -			goto out;
>  		/*
> -		 * Commit the Btree join operation and start a new trans.
> +		 * If there is an out-of-line value, de-allocate the blocks.
> +		 * This is done before we remove the attribute so that we don't
> +		 * overflow the maximum size of a transaction and/or hit a
> +		 * deadlock.
>  		 */
> -		error =3D xfs_trans_roll_inode(&args->trans, dp);
> -		if (error)
> -			goto out;
> -	}
> +		if (args->rmtblkno > 0) {
> +			/*
> +			 * May return -EAGAIN. Roll and repeat until all remote
> +			 * blocks are removed.
> +			 */
> +			error =3D __xfs_attr_rmtval_remove(dac);
> +			if (error =3D=3D -EAGAIN)
> +				return error;
> +			else if (error)
> +				goto out;
>
> -	/*
> -	 * If the result is small enough, push it all into the inode.
> -	 */
> -	if (xfs_attr_is_leaf(dp))
> -		error =3D xfs_attr_node_shrink(args, state);
> +			/*
> +			 * Refill the state structure with buffers (the prior
> +			 * calls released our buffers) and close out this
> +			 * transaction before proceeding.
> +			 */
> +			ASSERT(args->rmtblkno =3D=3D 0);
> +			error =3D xfs_attr_refillstate(state);
> +			if (error)
> +				goto out;
> +			dac->dela_state =3D XFS_DAS_RM_NAME;
> +			dac->flags |=3D XFS_DAC_DEFER_FINISH;
> +			return -EAGAIN;
> +		}
> +
> +		/* fallthrough */
> +	case XFS_DAS_RM_NAME:
> +		retval =3D xfs_attr_node_remove_name(args, state);
>
> +		/*
> +		 * Check to see if the tree needs to be collapsed. If so, roll
> +		 * the transacton and fall into the shrink state.
> +		 */
> +		if (retval && (state->path.active > 1)) {
> +			error =3D xfs_da3_join(state);
> +			if (error)
> +				goto out;
> +
> +			dac->flags |=3D XFS_DAC_DEFER_FINISH;
> +			dac->dela_state =3D XFS_DAS_RM_SHRINK;
> +			return -EAGAIN;
> +		}
> +
> +		/* fallthrough */
> +	case XFS_DAS_RM_SHRINK:
> +		/*
> +		 * If the result is small enough, push it all into the inode.
> +		 * This is our final state so it's safe to return a dirty
> +		 * transaction.
> +		 */
> +		if (xfs_attr_is_leaf(dp))
> +			error =3D xfs_attr_node_shrink(args, state);
> +		ASSERT(error !=3D -EAGAIN);
> +		break;
> +	default:
> +		ASSERT(0);
> +		error =3D -EINVAL;
> +		goto out;
> +	}
>  out:
>  	if (state)
>  		xfs_da_state_free(state);
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index 2b1f619..32736d9 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -74,6 +74,133 @@ struct xfs_attr_list_context {
>  };
>
>
> +/*
> + * =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> + * Structure used to pass context around among the delayed routines.
> + * =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> + */
> +
> +/*
> + * Below is a state machine diagram for attr remove operations. The  XFS=
_DAS_*
> + * states indicate places where the function would return -EAGAIN, and t=
hen
> + * immediately resume from after being recalled by the calling function.=
 States
> + * marked as a "subroutine state" indicate that they belong to a subrout=
ine, and
> + * so the calling function needs to pass them back to that subroutine to=
 allow
> + * it to finish where it left off. But they otherwise do not have a role=
 in the
> + * calling function other than just passing through.
> + *
> + * xfs_attr_remove_iter()
> + *              =C3=A2=C2=94=C2=82
> + *              v
> + *        have attr to remove? =C3=A2=C2=94=C2=80=C3=A2=C2=94=C2=80n=C3=
=A2=C2=94=C2=80=C3=A2=C2=94=C2=80> done
> + *              =C3=A2=C2=94=C2=82
> + *              y
> + *              =C3=A2=C2=94=C2=82
> + *              v
> + *        are we short form? =C3=A2=C2=94=C2=80=C3=A2=C2=94=C2=80y=C3=A2=
=C2=94=C2=80=C3=A2=C2=94=C2=80> xfs_attr_shortform_remove =C3=A2=C2=94=C2=
=80=C3=A2=C2=94=C2=80> done
> + *              =C3=A2=C2=94=C2=82
> + *              n
> + *              =C3=A2=C2=94=C2=82
> + *              V
> + *        are we leaf form? =C3=A2=C2=94=C2=80=C3=A2=C2=94=C2=80y=C3=A2=
=C2=94=C2=80=C3=A2=C2=94=C2=80> xfs_attr_leaf_removename =C3=A2=C2=94=C2=80=
=C3=A2=C2=94=C2=80> done
> + *              =C3=A2=C2=94=C2=82
> + *              n
> + *              =C3=A2=C2=94=C2=82
> + *              V
> + *   =C3=A2=C2=94=C2=8C=C3=A2=C2=94=C2=80=C3=A2=C2=94=C2=80 need to setu=
p state?
> + *   =C3=A2=C2=94=C2=82          =C3=A2=C2=94=C2=82
> + *   n          y
> + *   =C3=A2=C2=94=C2=82          =C3=A2=C2=94=C2=82
> + *   =C3=A2=C2=94=C2=82          v
> + *   =C3=A2=C2=94=C2=82 find attr and get state
> + *   =C3=A2=C2=94=C2=82    attr has blks? =C3=A2=C2=94=C2=80=C3=A2=C2=94=
=C2=80=C3=A2=C2=94=C2=80n=C3=A2=C2=94=C2=80=C3=A2=C2=94=C2=80=C3=A2=C2=94=
=C2=80=C3=A2=C2=94=C2=80=C3=A2=C2=94=C2=90
> + *   =C3=A2=C2=94=C2=82          =C3=A2=C2=94=C2=82                v
> + *   =C3=A2=C2=94=C2=82          =C3=A2=C2=94=C2=82         find and inv=
alidate
> + *   =C3=A2=C2=94=C2=82          y         the blocks. mark
> + *   =C3=A2=C2=94=C2=82          =C3=A2=C2=94=C2=82         attr incompl=
ete
> + *   =C3=A2=C2=94=C2=82          =C3=A2=C2=94=C2=9C=C3=A2=C2=94=C2=80=C3=
=A2=C2=94=C2=80=C3=A2=C2=94=C2=80=C3=A2=C2=94=C2=80=C3=A2=C2=94=C2=80=C3=A2=
=C2=94=C2=80=C3=A2=C2=94=C2=80=C3=A2=C2=94=C2=80=C3=A2=C2=94=C2=80=C3=A2=C2=
=94=C2=80=C3=A2=C2=94=C2=80=C3=A2=C2=94=C2=80=C3=A2=C2=94=C2=80=C3=A2=C2=94=
=C2=80=C3=A2=C2=94=C2=80=C3=A2=C2=94=C2=80=C3=A2=C2=94=C2=98
> + *   =C3=A2=C2=94=C2=94=C3=A2=C2=94=C2=80=C3=A2=C2=94=C2=80=C3=A2=C2=94=
=C2=80=C3=A2=C2=94=C2=80=C3=A2=C2=94=C2=80=C3=A2=C2=94=C2=80=C3=A2=C2=94=C2=
=80=C3=A2=C2=94=C2=80=C3=A2=C2=94=C2=80=C3=A2=C2=94=C2=80=C3=A2=C2=94=E2=82=
=AC
> + *              =C3=A2=C2=94=C2=82
> + *              v
> + *      Have blks to remove? =C3=A2=C2=94=C2=80=C3=A2=C2=94=C2=80=C3=A2=
=C2=94=C2=80y=C3=A2=C2=94=C2=80=C3=A2=C2=94=C2=80=C3=A2=C2=94=C2=80=C3=A2=
=C2=94=C2=80=C3=A2=C2=94=C2=80=C3=A2=C2=94=C2=80=C3=A2=C2=94=C2=80=C3=A2=C2=
=94=C2=80=C3=A2=C2=94=C2=80=C3=A2=C2=94=C2=90
> + *              =C3=A2=C2=94=C2=82        ^          remove the blks
> + *              =C3=A2=C2=94=C2=82        =C3=A2=C2=94=C2=82            =
    =C3=A2=C2=94=C2=82
> + *              =C3=A2=C2=94=C2=82        =C3=A2=C2=94=C2=82            =
    v
> + *              =C3=A2=C2=94=C2=82  XFS_DAS_RMTBLK <=C3=A2=C2=94=C2=80n=
=C3=A2=C2=94=C2=80=C3=A2=C2=94=C2=80 done?
> + *              =C3=A2=C2=94=C2=82  re-enter with          =C3=A2=C2=94=
=C2=82
> + *              =C3=A2=C2=94=C2=82  one less blk to        y
> + *              =C3=A2=C2=94=C2=82      remove             =C3=A2=C2=94=
=C2=82
> + *              =C3=A2=C2=94=C2=82                         V
> + *              =C3=A2=C2=94=C2=82                  refill the state
> + *              n                         =C3=A2=C2=94=C2=82
> + *              =C3=A2=C2=94=C2=82                         v
> + *              =C3=A2=C2=94=C2=82                   XFS_DAS_RM_NAME
> + *              =C3=A2=C2=94=C2=82                         =C3=A2=C2=94=
=C2=82
> + *              =C3=A2=C2=94=C2=9C=C3=A2=C2=94=C2=80=C3=A2=C2=94=C2=80=
=C3=A2=C2=94=C2=80=C3=A2=C2=94=C2=80=C3=A2=C2=94=C2=80=C3=A2=C2=94=C2=80=C3=
=A2=C2=94=C2=80=C3=A2=C2=94=C2=80=C3=A2=C2=94=C2=80=C3=A2=C2=94=C2=80=C3=A2=
=C2=94=C2=80=C3=A2=C2=94=C2=80=C3=A2=C2=94=C2=80=C3=A2=C2=94=C2=80=C3=A2=C2=
=94=C2=80=C3=A2=C2=94=C2=80=C3=A2=C2=94=C2=80=C3=A2=C2=94=C2=80=C3=A2=C2=94=
=C2=80=C3=A2=C2=94=C2=80=C3=A2=C2=94=C2=80=C3=A2=C2=94=C2=80=C3=A2=C2=94=C2=
=80=C3=A2=C2=94=C2=80=C3=A2=C2=94=C2=80=C3=A2=C2=94=C2=98
> + *              =C3=A2=C2=94=C2=82
> + *              v
> + *       remove leaf and
> + *       update hash with
> + *   xfs_attr_node_remove_cleanup
> + *              =C3=A2=C2=94=C2=82
> + *              v
> + *           need to
> + *        shrink tree? =C3=A2=C2=94=C2=80n=C3=A2=C2=94=C2=80=C3=A2=C2=94=
=C2=90
> + *              =C3=A2=C2=94=C2=82         =C3=A2=C2=94=C2=82
> + *              y         =C3=A2=C2=94=C2=82
> + *              =C3=A2=C2=94=C2=82         =C3=A2=C2=94=C2=82
> + *              v         =C3=A2=C2=94=C2=82
> + *          join leaf     =C3=A2=C2=94=C2=82
> + *              =C3=A2=C2=94=C2=82         =C3=A2=C2=94=C2=82
> + *              v         =C3=A2=C2=94=C2=82
> + *      XFS_DAS_RM_SHRINK =C3=A2=C2=94=C2=82
> + *              =C3=A2=C2=94=C2=82         =C3=A2=C2=94=C2=82
> + *              v         =C3=A2=C2=94=C2=82
> + *       do the shrink    =C3=A2=C2=94=C2=82
> + *              =C3=A2=C2=94=C2=82         =C3=A2=C2=94=C2=82
> + *              v         =C3=A2=C2=94=C2=82
> + *          free state <=C3=A2=C2=94=C2=80=C3=A2=C2=94=C2=80=C3=A2=C2=94=
=C2=98
> + *              =C3=A2=C2=94=C2=82
> + *              v
> + *            done
> + *
> + */
> +
> +/*
> + * Enum values for xfs_delattr_context.da_state
> + *
> + * These values are used by delayed attribute operations to keep track  =
of where
> + * they were before they returned -EAGAIN.  A return code of -EAGAIN sig=
nals the
> + * calling function to roll the transaction, and then recall the subrout=
ine to
> + * finish the operation.  The enum is then used by the subroutine to jum=
p back
> + * to where it was and resume executing where it left off.
> + */
> +enum xfs_delattr_state {
> +	XFS_DAS_UNINIT		=3D 0,  /* No state has been set yet */
> +	XFS_DAS_RMTBLK,		      /* Removing remote blks */
> +	XFS_DAS_RM_NAME,	      /* Remove attr name */
> +	XFS_DAS_RM_SHRINK,	      /* We are shrinking the tree */
> +};
> +
> +/*
> + * Defines for xfs_delattr_context.flags
> + */
> +#define XFS_DAC_DEFER_FINISH		0x01 /* finish the transaction */
> +
> +/*
> + * Context used for keeping track of delayed attribute operations
> + */
> +struct xfs_delattr_context {
> +	struct xfs_da_args      *da_args;
> +
> +	/* Used in xfs_attr_node_removename to roll through removing blocks */
> +	struct xfs_da_state     *da_state;
> +
> +	/* Used to keep track of current state of delayed operation */
> +	unsigned int            flags;
> +	enum xfs_delattr_state  dela_state;
> +};
> +
>  /*=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>   * Function prototypes for the kernel.
>   *=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D*/
> @@ -92,6 +219,10 @@ int xfs_attr_set(struct xfs_da_args *args);
>  int xfs_attr_set_args(struct xfs_da_args *args);
>  int xfs_has_attr(struct xfs_da_args *args);
>  int xfs_attr_remove_args(struct xfs_da_args *args);
> +int xfs_attr_remove_iter(struct xfs_delattr_context *dac);
> +int xfs_attr_trans_roll(struct xfs_delattr_context *dac);
>  bool xfs_attr_namecheck(const void *name, size_t length);
> +void xfs_delattr_context_init(struct xfs_delattr_context *dac,
> +			      struct xfs_da_args *args);
>
>  #endif	/* __XFS_ATTR_H__ */
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index 556184b..d97de20 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -19,8 +19,8 @@
>  #include "xfs_bmap_btree.h"
>  #include "xfs_bmap.h"
>  #include "xfs_attr_sf.h"
> -#include "xfs_attr_remote.h"
>  #include "xfs_attr.h"
> +#include "xfs_attr_remote.h"
>  #include "xfs_attr_leaf.h"
>  #include "xfs_error.h"
>  #include "xfs_trace.h"
> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_rem=
ote.c
> index 48d8e9c..2f3c4cc 100644
> --- a/fs/xfs/libxfs/xfs_attr_remote.c
> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
> @@ -674,10 +674,12 @@ xfs_attr_rmtval_invalidate(
>   */
>  int
>  xfs_attr_rmtval_remove(
> -	struct xfs_da_args      *args)
> +	struct xfs_da_args		*args)
>  {
> -	int			error;
> -	int			retval;
> +	int				error;
> +	struct xfs_delattr_context	dac  =3D {
> +		.da_args	=3D args,
> +	};
>
>  	trace_xfs_attr_rmtval_remove(args);
>
> @@ -685,31 +687,29 @@ xfs_attr_rmtval_remove(
>  	 * Keep de-allocating extents until the remote-value region is gone.
>  	 */
>  	do {
> -		retval =3D __xfs_attr_rmtval_remove(args);
> -		if (retval && retval !=3D -EAGAIN)
> -			return retval;
> +		error =3D __xfs_attr_rmtval_remove(&dac);
> +		if (error && error !=3D -EAGAIN)
> +			break;
>
> -		/*
> -		 * Close out trans and start the next one in the chain.
> -		 */
> -		error =3D xfs_trans_roll_inode(&args->trans, args->dp);
> +		error =3D xfs_attr_trans_roll(&dac);
>  		if (error)
>  			return error;
> -	} while (retval =3D=3D -EAGAIN);
> +	} while (true);
>
> -	return 0;
> +	return error;
>  }
>
>  /*
>   * Remove the value associated with an attribute by deleting the out-of-=
line
> - * buffer that it is stored on. Returns EAGAIN for the caller to refresh=
 the
> + * buffer that it is stored on. Returns -EAGAIN for the caller to refres=
h the
>   * transaction and re-call the function
>   */
>  int
>  __xfs_attr_rmtval_remove(
> -	struct xfs_da_args	*args)
> +	struct xfs_delattr_context	*dac)
>  {
> -	int			error, done;
> +	struct xfs_da_args		*args =3D dac->da_args;
> +	int				error, done;
>
>  	/*
>  	 * Unmap value blocks for this attr.
> @@ -719,12 +719,20 @@ __xfs_attr_rmtval_remove(
>  	if (error)
>  		return error;
>
> -	error =3D xfs_defer_finish(&args->trans);
> -	if (error)
> -		return error;
> -
> -	if (!done)
> +	/*
> +	 * We don't need an explicit state here to pick up where we left off. We
> +	 * can figure it out using the !done return code. Calling function only
> +	 * needs to keep recalling this routine until we indicate to stop by
> +	 * returning anything other than -EAGAIN. The actual value of
> +	 * attr->xattri_dela_state may be some value reminiscent of the calling
> +	 * function, but it's value is irrelevant with in the context of this
> +	 * function. Once we are done here, the next state is set as needed
> +	 * by the parent
> +	 */
> +	if (!done) {
> +		dac->flags |=3D XFS_DAC_DEFER_FINISH;
>  		return -EAGAIN;
> +	}
>
>  	return error;
>  }
> diff --git a/fs/xfs/libxfs/xfs_attr_remote.h b/fs/xfs/libxfs/xfs_attr_rem=
ote.h
> index 9eee615..002fd30 100644
> --- a/fs/xfs/libxfs/xfs_attr_remote.h
> +++ b/fs/xfs/libxfs/xfs_attr_remote.h
> @@ -14,5 +14,5 @@ int xfs_attr_rmtval_remove(struct xfs_da_args *args);
>  int xfs_attr_rmtval_stale(struct xfs_inode *ip, struct xfs_bmbt_irec *ma=
p,
>  		xfs_buf_flags_t incore_flags);
>  int xfs_attr_rmtval_invalidate(struct xfs_da_args *args);
> -int __xfs_attr_rmtval_remove(struct xfs_da_args *args);
> +int __xfs_attr_rmtval_remove(struct xfs_delattr_context *dac);
>  #endif /* __XFS_ATTR_REMOTE_H__ */
> diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
> index bfad669..aaa7e66 100644
> --- a/fs/xfs/xfs_attr_inactive.c
> +++ b/fs/xfs/xfs_attr_inactive.c
> @@ -15,10 +15,10 @@
>  #include "xfs_da_format.h"
>  #include "xfs_da_btree.h"
>  #include "xfs_inode.h"
> +#include "xfs_attr.h"
>  #include "xfs_attr_remote.h"
>  #include "xfs_trans.h"
>  #include "xfs_bmap.h"
> -#include "xfs_attr.h"
>  #include "xfs_attr_leaf.h"
>  #include "xfs_quota.h"
>  #include "xfs_dir2.h"


--
chandan
