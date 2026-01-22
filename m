Return-Path: <linux-xfs+bounces-30149-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EC8JIdZQcmnpfAAAu9opvQ
	(envelope-from <linux-xfs+bounces-30149-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Thu, 22 Jan 2026 17:31:18 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id DD5BA69FAE
	for <lists+linux-xfs@lfdr.de>; Thu, 22 Jan 2026 17:31:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 2759530008B5
	for <lists+linux-xfs@lfdr.de>; Thu, 22 Jan 2026 16:31:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 196C33DDF01;
	Thu, 22 Jan 2026 16:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LstHP54K"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02E2B385EE0;
	Thu, 22 Jan 2026 16:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769098435; cv=none; b=bMpHxinbB6+9QdwxLIzQEjs7Gg34E4gZubnxcJ2OVQK0b9XKpvSoKksCe4xfbS8OuDipBoMljw3T+0VKlOeUPX1sBgAHkW13C0iytV+RqY2CT6bCKoCZ87lEyg2IPfQHOHhFYPhDRJqGTUlkJd1WdHDLbdkajlwCkAwx3r/Oi38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769098435; c=relaxed/simple;
	bh=zllRz3UfM+vuAEqf+tNuDFQqOfGs2/OqdAeb0cvaG4s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Bu8cp0vMA7UFK8rw3N8Qeq0ArTrLN9C/wuoQW+qMPMbsn4ngB/6IxCVLAnK0jljvTaxi6sFwZBx0JHB+KcKmwNG1hCooWx9NmWcVgodAK/ia07frBoUmAKWzgS5NuUsEfjhnY2lT2Gl4yjFhKW7P7pd2hJBc1naLAPlvP0hJC0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LstHP54K; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E0C3C116C6;
	Thu, 22 Jan 2026 16:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769098432;
	bh=zllRz3UfM+vuAEqf+tNuDFQqOfGs2/OqdAeb0cvaG4s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LstHP54K/ziqvFEwAxLg02y+M71YK62V1E8hjfkc7mb4a2+XI5xmO7RryZO6iNVL7
	 pQqY5hk5v88e2pLO6FrRFeKtA2edEWzZ6kLy5hsdvpI+3CxyiEy3+ykcrLXbKzdNR8
	 CARbmMrBTkLdasXIGPSghHKWPgq4uinjy9QhE3JmeITKOtIpK3IewErEzAEiOLItvZ
	 u4uEA/4chVTyBWaoEJc1dKSAH41I0+QoAGiE0IxGmwwbVPOoEoIE9usa2SsphR/rXo
	 FXaI6Pte9WVimB8whAeDHI75mPp8ChMG4kAyV9V7+WTjLu/HVRuK4RDGO6XO9R6qmi
	 p5Gn1mSGsSBCg==
Date: Thu, 22 Jan 2026 08:13:51 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zorro Lang <zlang@redhat.com>
Cc: fstests <fstests@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] misc: allow zero duration for fsstress and fsx
Message-ID: <20260122161351.GA5916@frogsfrogsfrogs>
References: <20260121012621.GE15541@frogsfrogsfrogs>
 <20260121155456.pf6jeprhzua3rdl3@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <20260121174601.GE5945@frogsfrogsfrogs>
 <20260122072100.2aynewdegsdz7stz@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260122072100.2aynewdegsdz7stz@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_ALL(0.00)[];
	TAGGED_FROM(0.00)[bounces-30149-lists,linux-xfs=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	MIME_TRACE(0.00)[0:+];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[djwong@kernel.org,linux-xfs@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[linux-xfs];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: DD5BA69FAE
X-Rspamd-Action: no action

On Thu, Jan 22, 2026 at 03:21:00PM +0800, Zorro Lang wrote:
> On Wed, Jan 21, 2026 at 09:46:01AM -0800, Darrick J. Wong wrote:
> > On Wed, Jan 21, 2026 at 11:54:56PM +0800, Zorro Lang wrote:
> > > On Tue, Jan 20, 2026 at 05:26:21PM -0800, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > 
> > > > Occasionally the common/fuzzy fuzz test helpers manage to time
> > > > something just right such that fsx or fsstress get invoked with a zero
> > > > second duration.  It's harmless to exit immediately without doing
> > > > anything, so allow this corner case.
> > > 
> > > Sure, duration=0 is harmless, I'm good with this patch.
> > > 
> > > Reviewed-by: Zorro Lang <zlang@redhat.com>
> > > 
> > > Please excuse my nitpicking. I'm curious about the semantics of "--duration=0".
> > > Looking at the output of `fsstress -v --duration=0`, it doesn't actually
> > > 'do nothing.' Instead, it behaves similarly to duration=1, where fsstress
> > > attempts to execute operations before timing out and exiting :-D
> > 
> > Yeah, I suppose it's possible to do a very small amount of work.
> > 
> > Would you mind changing that last sentence to read "It's harmless to
> > exit almost immediately having done very little work, so allow this
> > corner case." prior to commit?
> 
> Sure Darick, I can make that change prior to commit :) But I was just
> curious to hear your thoughts on:
> 
>   if (duration == 0) {
>           /* No action is taken if duration is 0 */
>           exit(0);
>   } else if (duration < 0) {
>           fprintf(stderr, "%lld: invalid duration\n", duration);
> 	  exit(88);
>   }
> 
> do you feel that makes more sense semantically :)

That would also work. Would you rather have the exits-immediately
version?  

--D

> Thanks,
> Zorro
> 
> > 
> > --D
> > 
> > > Thanks,
> > > Zorro
> > > 
> > > > 
> > > > Cc: <fstests@vger.kernel.org> # v2023.05.01
> > > > Fixes: 3e85dd4fe4236d ("misc: add duration for long soak tests")
> > > > Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> > > > ---
> > > >  ltp/fsstress.c |    2 +-
> > > >  ltp/fsx.c      |    2 +-
> > > >  2 files changed, 2 insertions(+), 2 deletions(-)
> > > > 
> > > > diff --git a/ltp/fsstress.c b/ltp/fsstress.c
> > > > index c17ac440414325..b51bd8ada2a3be 100644
> > > > --- a/ltp/fsstress.c
> > > > +++ b/ltp/fsstress.c
> > > > @@ -645,7 +645,7 @@ int main(int argc, char **argv)
> > > >  				exit(87);
> > > >  			}
> > > >  			duration = strtoll(optarg, NULL, 0);
> > > > -			if (duration < 1) {
> > > > +			if (duration < 0) {
> > > >  				fprintf(stderr, "%lld: invalid duration\n", duration);
> > > >  				exit(88);
> > > >  			}
> > > > diff --git a/ltp/fsx.c b/ltp/fsx.c
> > > > index 626976dd4f9f27..4f8a2d5ab1fc08 100644
> > > > --- a/ltp/fsx.c
> > > > +++ b/ltp/fsx.c
> > > > @@ -3375,7 +3375,7 @@ main(int argc, char **argv)
> > > >  				exit(87);
> > > >  			}
> > > >  			duration = strtoll(optarg, NULL, 0);
> > > > -			if (duration < 1) {
> > > > +			if (duration < 0) {
> > > >  				fprintf(stderr, "%lld: invalid duration\n", duration);
> > > >  				exit(88);
> > > >  			}
> > > > 
> > > 
> > > 
> > 
> 
> 

