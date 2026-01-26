Return-Path: <linux-xfs+bounces-30332-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kIH1BwzEd2nckgEAu9opvQ
	(envelope-from <linux-xfs+bounces-30332-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Mon, 26 Jan 2026 20:44:12 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2CFF78CB6F
	for <lists+linux-xfs@lfdr.de>; Mon, 26 Jan 2026 20:44:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id B61C8300602C
	for <lists+linux-xfs@lfdr.de>; Mon, 26 Jan 2026 19:44:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27E6A28488D;
	Mon, 26 Jan 2026 19:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s6oaaP+p"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04DAF23A9B0;
	Mon, 26 Jan 2026 19:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769456646; cv=none; b=fsh3v7Lb7Y7lCFgzaAWntWO3vCjiwUFLTNKAWYyiWkr+0l9ZLCr5SlKbMRjNW7de/cf33MMkMvhNDifEjkoq4q9F2rw9YygDD3ytmjEjK3SRbrzXm/JVvhAg8XyTooVQgvnUZh4Fl72rjDpSP/XPwTDDJgB4kLgWt1LbsWRZwQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769456646; c=relaxed/simple;
	bh=ZJ/UdBnJ9+yQhlizIaIK0KPoFhrOURHRZyFfM0bw2u0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HI1M9fOVjUdPa6IwCb60rHLBX/QWAqzzeDVyA5ChiEEkxOSsJlxcMkbWFhaLWb4vGj2cSkiKpxSOL5jxgqxVHw9Yd19HGj6CUBJPS5sXkHRE50D4v/GepXXj+/s6W6e5r362v/vnjm9NH6EnTNoTlpxqbSALAR9x4IbOoJQG9+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s6oaaP+p; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B481C116C6;
	Mon, 26 Jan 2026 19:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769456645;
	bh=ZJ/UdBnJ9+yQhlizIaIK0KPoFhrOURHRZyFfM0bw2u0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=s6oaaP+p0iyceThyCgyu2k6eW18vdbN68cE7OXjuQ8kcQ6VxdpE8tyvKKHefPaNpD
	 EU9O9qeQT7RZZ/bTy8WrxUCWroRQcVVopS0e1ww6zWvm7x6dDmEJ/bM84EVBGW6bVg
	 7x7iDZZ5tzSwzBjpAwjmEco7jaYTtVG+H+P5yCC6e7Eb9YT463gn6bRilAQSzQ5rGT
	 LhAt4WNqdumozIqzmWzC2tmhgOB819Mt3VWJidLiciJ1ISwRTeiZyM02TjL5VxyXdG
	 6uIJnA0Nl1zmdldG/iCeAa06DV5myKE6kAIJe2HYwbgtY5s8SirJfClsF0DuW8x5mQ
	 g6XBdqwAXEelA==
Date: Mon, 26 Jan 2026 11:44:04 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: zlang@kernel.org, linux-xfs@vger.kernel.org,
	fstests <fstests@vger.kernel.org>
Subject: Re: [PATCH] xfs/841: fix the fsstress invocation
Message-ID: <20260126194404.GY5945@frogsfrogsfrogs>
References: <20260126130816.11494-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260126130816.11494-1-hch@lst.de>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-30332-lists,linux-xfs=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[djwong@kernel.org,linux-xfs@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[linux-xfs];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[lst.de:email,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 2CFF78CB6F
X-Rspamd-Action: no action

[cc fstests]

On Mon, Jan 26, 2026 at 02:08:16PM +0100, Christoph Hellwig wrote:
> xfs/841 fails for me with:
> 
> +/root/xfstests-dev/tests/xfs/841: line 79: -f: command not found
> 
> Looks like the recent edits missed a \ escape.  Fix that.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Doh!
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  tests/xfs/841 | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tests/xfs/841 b/tests/xfs/841
> index b4bf538f1526..ee2368d4a746 100755
> --- a/tests/xfs/841
> +++ b/tests/xfs/841
> @@ -64,7 +64,7 @@ _create_proto_dir()
>  	rm -rf "$PROTO_DIR"
>  	mkdir -p "$PROTO_DIR"
>  
> -	FSSTRESS_ARGS=`_scale_fsstress_args -d $PROTO_DIR -s 1 -n 2000 -p 2 -z
> +	FSSTRESS_ARGS=`_scale_fsstress_args -d $PROTO_DIR -s 1 -n 2000 -p 2 -z \
>  		-f creat=15 \
>  		-f mkdir=8 \
>  		-f write=15 \
> -- 
> 2.47.3
> 
> 

