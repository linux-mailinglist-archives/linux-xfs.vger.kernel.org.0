Return-Path: <linux-xfs+bounces-24642-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F11DB252AE
	for <lists+linux-xfs@lfdr.de>; Wed, 13 Aug 2025 20:00:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8E2EE5A8512
	for <lists+linux-xfs@lfdr.de>; Wed, 13 Aug 2025 17:58:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26AEC29B205;
	Wed, 13 Aug 2025 17:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kt1nG2rv"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB7CF29ACC2
	for <linux-xfs@vger.kernel.org>; Wed, 13 Aug 2025 17:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755107900; cv=none; b=iJIEqPWZLm5AOGwh+0aw11ijVWSUm1vBIpp73g/6KoGs8IpoLTAYhEK++k+8i+/xghaSLAsn5LtR5Del4aS2AU8vnuWTtBXT0KyfzpkUXdcaBolRBhs+f9wZFdcNP5AZGzH0wRGK+UPP+KmJFH95gdRfA7FWxWF9fI4dgCnDtRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755107900; c=relaxed/simple;
	bh=Wi2gxulqB3mOWHV8bposI4OVMCFM1zW6FTeHAXelSDM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m/6+W8MlGw0EIBbpuP4sie7UEBP2nq/WNC9ANZ3SiV4N6q+XWVLePL37pFH5EW+Ert+LCPZB4uE/SpL/homNgw3VU6NmwQsLQu2OQ0F3rwrF1l0Sj/EEy+f/8xvM6dY08EbGiKYWQYe0YVrA45zqYO5A9EqMvWBR+Vjzh4vnTCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kt1nG2rv; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD8C1C4CEEB;
	Wed, 13 Aug 2025 17:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755107900;
	bh=Wi2gxulqB3mOWHV8bposI4OVMCFM1zW6FTeHAXelSDM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kt1nG2rvSv9ghx5w8DGK5nUTqFWh4hgJTOGRv0R70K2IX/OYND1ftRZ2cGC7h/5z9
	 K3US5BfdLmVOz5MAXr9TtJnbqvn35//otxtWThRb5k71ep/rd6InXGQ/7RmdTfIt3x
	 0IxjRy1v5ZjvwbQZLXbgCGSjtzmSTXAf5JqZWrmBYgPuI4Vbr/iTE0VKebTL4ocnG8
	 zVBPUNPTzBpHUYYczafQfVSS6ywKseX4a3mGSiSuAKzV0YrJhu7HWlL1oOhGJnOdFZ
	 Qq7tMI1F+/wYSPq30vzs5Rac9vxHTpRSABFGn/qtHkgbZkZTm88jCgaz3Oc5w5IgvV
	 mnU2iu9U/ymZg==
Date: Wed, 13 Aug 2025 19:58:16 +0200
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH] xfs: Fix logbsize validation
Message-ID: <y7s7s4izmd457th2pjrgqly7gc2tseug6iicvk6b4ilfmn3lxg@53riwveulxmf>
References: <20250812124350.849381-1-cem@kernel.org>
 <JiCSSspf-x-3gGFloaKdzhXSAOa84v2GfYvqxB0i8saN-ccGtafdnD4Cwqf-NnjfgpVpp1fBOVnBlNQeG44FLA==@protonmail.internalid>
 <20250813021655.GQ7965@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250813021655.GQ7965@frogsfrogsfrogs>

On Tue, Aug 12, 2025 at 07:16:55PM -0700, Darrick J. Wong wrote:
> On Tue, Aug 12, 2025 at 02:43:41PM +0200, cem@kernel.org wrote:
> > From: Carlos Maiolino <cem@kernel.org>
> >
> > An user reported an inconsistency while mounting a V2 log filesystem
> > with logbsize equals to the stripe unit being used (192k).
> >
> > The current validation algorithm for the log buffer size enforces the
> > user to pass a power_of_2 value between [16k-256k].
> > The manpage dictates the log buffer size must be a multiple of the log
> > stripe unit, but doesn't specify it must be a power_of_2. Also, if
> > logbsize is not specified at mount time, it will be set to
> > max(32768, log_sunit), where log_sunit not necessarily is a power_of_2.
> >
> > It does seem to me then that logbsize being a power_of_2 constraint must
> > be relaxed if there is a configured log stripe unit, so this patch
> > updates the logbsize validation logic to ensure that:
> >
> > - It can only be set to a specific range [16k-256k]
> >
> > - Will be aligned to log stripe unit when the latter is set,
> >   and will be at least the same size as the log stripe unit.
> >
> > - Enforce it to be power_of_2 aligned when log stripe unit is not set.
> >
> > This is achieved by factoring out the logbsize validation to a separated
> > function to avoid a big chain of if conditionals
> >
> > While at it, update m_logbufs and m_logbsize conditionals in
> > xfs_fs_validate_params from:
> > 	(x != -1 && x != 0) to (x > 0)
> >
> > Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> > ---
> >
> > I am sending this as a RFC because although I did some basic testing,
> > xfstests is still running, so I can't tell yet if it will fail on some configuration even though I am not expecting it to.
> 
> Heheh, how did that go?

Tests looks mostly fine, there were a few extra failures which seemed
all related to tests which uses a custom geometry, not compatible with
those I was forcing on all the tests, I'll double check if there is
anything suspicious, and if everything is ok, I'll send a proper non-rfc
version.

> 
> >  fs/xfs/xfs_super.c | 57 ++++++++++++++++++++++++++++++++--------------
> >  1 file changed, 40 insertions(+), 17 deletions(-)
> >
> > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > index bb0a82635a77..38d3d8a0b026 100644
> > --- a/fs/xfs/xfs_super.c
> > +++ b/fs/xfs/xfs_super.c
> > @@ -1059,6 +1059,29 @@ xfs_fs_unfreeze(
> >  	return 0;
> >  }
> >
> > +STATIC int
> > +xfs_validate_logbsize(
> > +	struct xfs_mount	*mp)
> > +{
> > +	int			logbsize = mp->m_logbsize;
> > +	uint32_t		logsunit = mp->m_sb.sb_logsunit;
> 
> Why not access the fields directly instead of going through convenience
> variables?
> 
> > +	if (logsunit > 1) {
> > +		if (logbsize < logsunit ||
> > +		    logbsize % logsunit) {
> > +			xfs_warn(mp,
> > +		"logbuf size must be a multiple of the log stripe unit");
> > +			return -EINVAL;
> > +		}
> > +	} else {
> > +		if (!is_power_of_2(logbsize)) {
> > +		    xfs_warn(mp,
> 
> Odd indenting here  ^^^
> 
> > +		     "invalid logbufsize: %d [not a power of 2]", logbsize);
> > +		    return -EINVAL;
> > +		}
> > +	}
> > +	return 0;
> > +}
> >  /*
> >   * This function fills in xfs_mount_t fields based on mount args.
> >   * Note: the superblock _has_ now been read in.
> > @@ -1067,16 +1090,13 @@ STATIC int
> >  xfs_finish_flags(
> >  	struct xfs_mount	*mp)
> >  {
> > -	/* Fail a mount where the logbuf is smaller than the log stripe */
> >  	if (xfs_has_logv2(mp)) {
> > -		if (mp->m_logbsize <= 0 &&
> > -		    mp->m_sb.sb_logsunit > XLOG_BIG_RECORD_BSIZE) {
> > -			mp->m_logbsize = mp->m_sb.sb_logsunit;
> > -		} else if (mp->m_logbsize > 0 &&
> > -			   mp->m_logbsize < mp->m_sb.sb_logsunit) {
> > -			xfs_warn(mp,
> > -		"logbuf size must be greater than or equal to log stripe size");
> > -			return -EINVAL;
> > +		if (mp->m_logbsize > 0) {
> > +			if (xfs_validate_logbsize(mp))
> > +				return -EINVAL;
> 
> If you're going to have xfs_validate_logbsize return an errno, then
> capture it and return that, instead squashing them all to EINVAL.
> 
> AFAICT it's no big deal to have non-power-of-two log buffers, right?
> I *think* everything looks ok, but I'm no expert in the bottom levels of
> the xfs logging code. :/
> 
> --D
> 
> > +		} else {
> > +			if (mp->m_sb.sb_logsunit > XLOG_BIG_RECORD_BSIZE)
> > +				mp->m_logbsize = mp->m_sb.sb_logsunit;
> >  		}
> >  	} else {
> >  		/* Fail a mount if the logbuf is larger than 32K */
> > @@ -1628,8 +1648,7 @@ xfs_fs_validate_params(
> >  		return -EINVAL;
> >  	}
> >
> > -	if (mp->m_logbufs != -1 &&
> > -	    mp->m_logbufs != 0 &&
> > +	if (mp->m_logbufs > 0 &&
> >  	    (mp->m_logbufs < XLOG_MIN_ICLOGS ||
> >  	     mp->m_logbufs > XLOG_MAX_ICLOGS)) {
> >  		xfs_warn(mp, "invalid logbufs value: %d [not %d-%d]",
> > @@ -1637,14 +1656,18 @@ xfs_fs_validate_params(
> >  		return -EINVAL;
> >  	}
> >
> > -	if (mp->m_logbsize != -1 &&
> > -	    mp->m_logbsize !=  0 &&
> > +	/*
> > +	 * We have not yet read the superblock, so we can't check against
> > +	 * logsunit here.
> > +	 */
> > +	if (mp->m_logbsize > 0 &&
> >  	    (mp->m_logbsize < XLOG_MIN_RECORD_BSIZE ||
> > -	     mp->m_logbsize > XLOG_MAX_RECORD_BSIZE ||
> > -	     !is_power_of_2(mp->m_logbsize))) {
> > +	     mp->m_logbsize > XLOG_MAX_RECORD_BSIZE)) {
> >  		xfs_warn(mp,
> > -			"invalid logbufsize: %d [not 16k,32k,64k,128k or 256k]",
> > -			mp->m_logbsize);
> > +			"invalid logbufsize: %d [not in range %dk-%dk]",
> > +			mp->m_logbsize,
> > +			(XLOG_MIN_RECORD_BSIZE/1024),
> > +			(XLOG_MAX_RECORD_BSIZE/1024));
> >  		return -EINVAL;
> >  	}
> >
> > --
> > 2.50.1
> >
> >
> 

