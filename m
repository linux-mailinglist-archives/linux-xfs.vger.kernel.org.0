Return-Path: <linux-xfs+bounces-31085-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YKP1KRcKl2nvtwIAu9opvQ
	(envelope-from <linux-xfs+bounces-31085-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Thu, 19 Feb 2026 14:03:19 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DDF3415ED52
	for <lists+linux-xfs@lfdr.de>; Thu, 19 Feb 2026 14:03:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 473D43018588
	for <lists+linux-xfs@lfdr.de>; Thu, 19 Feb 2026 13:02:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F82433A037;
	Thu, 19 Feb 2026 13:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k/svY+de"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C08320C463;
	Thu, 19 Feb 2026 13:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771506130; cv=none; b=KxymIbpEsTJPWBy5aGdRmn/82Wf10SZaMQdaehtaEsyI68bZgEcVdU9qDqyIGau/4OkZQnD/8vwL1CKykVUSjdZulhJVD0FAYxO51cUg5KtWf35zm2/+hw1LEbaZy1sXcvGvN4KofvHwKDg3d6VcV/pJkMyovRNlXUHvUe0ymqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771506130; c=relaxed/simple;
	bh=QppXLEvgfZalvoa4uJG5b72ujwrROheC5T1TUvFb52E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L/0JqmAesfdNg6bq6GPynt82pVnwWDEw4fA89ar1qiQHruKb6RjNoMqlkytzFNdDglqQnxdrAMEnknVq63qxXaznafcgucmOOD9s1A2VDJJeTrz8uZubvF97ZSzGPVRMn/31IZKc8ZMCKM5tbYXYECEy2A1LwKQl/pCYqmIYV0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k/svY+de; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1611C4CEF7;
	Thu, 19 Feb 2026 13:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771506129;
	bh=QppXLEvgfZalvoa4uJG5b72ujwrROheC5T1TUvFb52E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=k/svY+deZ48Mge1381SVYO74baDsJUOeFPtttLGPhPgHxfGNroyQYwqbzSJ23B0wV
	 MKHtwjEhfLTCKEoxnLK+dVhs8DvmMTs5mguj3JhSvwTXvJ9xNdIZkXFHw1K8Geb1cn
	 xxsYX0rkhEuwU1A65jQukkDsjdEHLx0n1O7WQRD2gG2Xd1WgwXh8t66WZ+SCSINfVY
	 MsS6jZqNLZM37eTYKLVXtCGcLRJLwZYnUUeQ61ygDm8Lpay4+fu/rv9d61Y46A+AKx
	 YJ/ICjkD94Czz9sUyGtUHr7WlBblxda6VGgg1Asry4gl6n5NIj+W/woBd20J1NiBbv
	 sfpuIcUZCln9Q==
Date: Thu, 19 Feb 2026 14:02:06 +0100
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/6] xfs: fix xfs_group release bug in
 xfs_verify_report_losses
Message-ID: <aZcJEu9PjdfXPwIG@nidhogg.toxiclabs.cc>
References: <177145925377.401799.10773940743454980308.stgit@frogsfrogsfrogs>
 <177145925473.401799.4192737708449778278.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177145925473.401799.4192737708449778278.stgit@frogsfrogsfrogs>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-31085-lists,linux-xfs=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN_FAIL(0.00)[1.2.3.5.c.f.2.1.0.0.0.0.0.0.0.0.c.6.3.0.1.0.0.e.4.0.c.3.0.0.6.2.asn6.rspamd.com:server fail];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[cem@kernel.org,linux-xfs@vger.kernel.org];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	NEURAL_HAM(-0.00)[-0.999];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-xfs];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,nidhogg.toxiclabs.cc:mid]
X-Rspamd-Queue-Id: DDF3415ED52
X-Rspamd-Action: no action

On Wed, Feb 18, 2026 at 10:01:30PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Chris Mason reports that his AI tools noticed that we were using
> xfs_perag_put and xfs_group_put to release the group reference returned
> by xfs_group_next_range.  However, the iterator function returns an
> object with an active refcount, which means that we must use the correct
> function to release the active refcount, which is _rele.

The subject looks a copy/paste from the previous one, ditto for the
description.

The description matches the patch, but the subject doesn't.

If you're going to send me a PR with this series, please fix it. If I'm
pulling this series straight from the list, I'll fix it here.

Other than the description problems, the patch looks fine:

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> 
> Cc: <stable@vger.kernel.org> # v6.0
> Fixes: 6f643c57d57c56 ("xfs: implement ->notify_failure() for XFS")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  fs/xfs/xfs_notify_failure.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_notify_failure.c b/fs/xfs/xfs_notify_failure.c
> index 6be19fa1ebe262..64c8afb935c261 100644
> --- a/fs/xfs/xfs_notify_failure.c
> +++ b/fs/xfs/xfs_notify_failure.c
> @@ -304,7 +304,7 @@ xfs_dax_notify_dev_failure(
>  
>  			error = xfs_alloc_read_agf(pag, tp, 0, &agf_bp);
>  			if (error) {
> -				xfs_perag_put(pag);
> +				xfs_perag_rele(pag);
>  				break;
>  			}
>  
> @@ -340,7 +340,7 @@ xfs_dax_notify_dev_failure(
>  		if (rtg)
>  			xfs_rtgroup_unlock(rtg, XFS_RTGLOCK_RMAP);
>  		if (error) {
> -			xfs_group_put(xg);
> +			xfs_group_rele(xg);
>  			break;
>  		}
>  	}
> 
> 

