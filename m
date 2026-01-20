Return-Path: <linux-xfs+bounces-29943-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EP+9GSa/b2kOMQAAu9opvQ
	(envelope-from <linux-xfs+bounces-29943-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Tue, 20 Jan 2026 18:45:10 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 4808248C68
	for <lists+linux-xfs@lfdr.de>; Tue, 20 Jan 2026 18:45:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 0CFAB865110
	for <lists+linux-xfs@lfdr.de>; Tue, 20 Jan 2026 17:25:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF4943EDAC2;
	Tue, 20 Jan 2026 17:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="napCvG9p"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF7DF425CEC
	for <linux-xfs@vger.kernel.org>; Tue, 20 Jan 2026 17:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768929836; cv=none; b=BCA6T6KUE5QfvYd3DWnQvPloVpyYN1WO19BgiGjUSqdYgyoJQIfK8VuizLVMQ1AyQKPtD3RlgL2iHCMiF8MG/1p5PEfP2lN3L9dE0lkXBVQLwNaRp+kzrGi566ldVgD1yJqUXXEf+Jj4Kd6gAZeAdFibEsyMGJgEIUfY/icU5fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768929836; c=relaxed/simple;
	bh=r9B+o1VVJC/f9cfpYSHIQ2jtwhg722KVe/34I15Wa+U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cpHEOGsILFvh7AU3JwLxG/+zph7VdwU3Oux6D4Dtr9Myqzh5DHJHnuK6FrYbExV1igZHuqgXFIXjlkrWTRMTRSsVUq6DFmQx6gYmZXkfjd7I15PAhLQwUpfNtfaLSK4PYnV3EJCwEUrtkKq6eQ+cabSRk7+imx6N7gjXc3oEdiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=napCvG9p; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48FEFC16AAE;
	Tue, 20 Jan 2026 17:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768929836;
	bh=r9B+o1VVJC/f9cfpYSHIQ2jtwhg722KVe/34I15Wa+U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=napCvG9p3cWUO+EYd4zjLXeyYtWDrVb1lD4Xo0qDIdY/uMTbmDhJaC9BjZTxCou9T
	 77hEm4UyKFRAUKueHvjSOt23q/oxVWpx6/OZOJPoufdZijljVBhwmUUahjIPTwMXjQ
	 SrFWsp2jgDiMaoHROPhQisgqg7tvovddYNFXEVkF2b/q9KvXLL5YFVHY8UH/iBMHPO
	 XdhNXMC0nbNNs2QH7orGgH+IagMrWiWDG8R5g4NvnTOQvUmfX3rYwPfQvWpL24Y606
	 WEidNGt75WTbVXQ24TdUCnzaO8Iu9nR6IBUhQLqN7cNeequvPGZYtg6hQ4sokhfmq0
	 WFWzqE3NohhFw==
Date: Tue, 20 Jan 2026 09:23:55 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org
Cc: aalbersh@redhat.com, linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH 2/2] fsr: Always print error messages from
 xfrog_defragrange()
Message-ID: <20260120172355.GP15551@frogsfrogsfrogs>
References: <20260119142724.284933-1-cem@kernel.org>
 <20260119142724.284933-3-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260119142724.284933-3-cem@kernel.org>
X-Spamd-Result: default: False [-1.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DMARC_POLICY_ALLOW(0.00)[kernel.org,quarantine];
	TAGGED_FROM(0.00)[bounces-29943-lists,linux-xfs=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[djwong@kernel.org,linux-xfs@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[3];
	TO_DN_NONE(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-xfs];
	ASN(0.00)[asn:7979, ipnet:213.196.21.0/24, country:US];
	DBL_BLOCKED_OPENRESOLVER(0.00)[ams.mirrors.kernel.org:rdns,ams.mirrors.kernel.org:helo]
X-Rspamd-Queue-Id: 4808248C68
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Mon, Jan 19, 2026 at 03:26:51PM +0100, cem@kernel.org wrote:
> From: Carlos Maiolino <cem@kernel.org>
> 
> Error messages when xfrog_defragrange() are only printed when
> verbose/debug flages are used.
> 
> We had reports from users complaining it's hard to find out error
> messages in the middle of dozens of other informational messages.
> 
> Particularly I think error messages are better to be printed
> independently of verbose/debug flags, so unconditionally print those.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>

That seems like a reasonable behavior to me.  On some level these
errors probably ought to be printed to stderr instead of stdout, but
nothing else in packfile() seems to do that so maybe we just leave that
alone?

Anyway silently dropping "did not actually defrag the file" errors by
default seems counterintuitive so

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fsr/xfs_fsr.c | 10 +++-------
>  1 file changed, 3 insertions(+), 7 deletions(-)
> 
> diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
> index 8845ff172fcb..fadb53af062d 100644
> --- a/fsr/xfs_fsr.c
> +++ b/fsr/xfs_fsr.c
> @@ -1464,19 +1464,15 @@ packfile(
>  		case 0:
>  			break;
>  	case ENOTSUP:
> -		if (vflag || dflag)
> -			fsrprintf(_("%s: file type not supported\n"), fname);
> +		fsrprintf(_("%s: file type not supported\n"), fname);
>  		break;
>  	case EFAULT:
>  		/* The file has changed since we started the copy */
> -		if (vflag || dflag)
> -			fsrprintf(_("%s: file modified defrag aborted\n"),
> -					fname);
> +		fsrprintf(_("%s: file modified defrag aborted\n"), fname);
>  		break;
>  	case EBUSY:
>  		/* Timestamp has changed or mmap'ed file */
> -		if (vflag || dflag)
> -			fsrprintf(_("%s: file busy\n"), fname);
> +		fsrprintf(_("%s: file busy\n"), fname);
>  		break;
>  	default:
>  		fsrprintf(_("XFS_IOC_SWAPEXT failed: %s: %s\n"),
> -- 
> 2.52.0
> 
> 

