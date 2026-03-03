Return-Path: <linux-xfs+bounces-31799-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YLJgN30Dp2k7bgAAu9opvQ
	(envelope-from <linux-xfs+bounces-31799-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Tue, 03 Mar 2026 16:51:25 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FA561F2F67
	for <lists+linux-xfs@lfdr.de>; Tue, 03 Mar 2026 16:51:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 147DB30770B9
	for <lists+linux-xfs@lfdr.de>; Tue,  3 Mar 2026 15:49:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AF9949218A;
	Tue,  3 Mar 2026 15:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PfOGGlIr"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B35C3E7158
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 15:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772552975; cv=none; b=DNqAOjbzDqv5NJPbL9+dkQFnQC66NgPM7O1wwB6afopRdYfFmEFUgGirt/2Aqa3TeWW2HTv5nVPAuqYn3e0LQ9rns1JREcDTeoSgyl018rxHcKcLP7g8Of9GjWkbMEqe+kD+3vIu8bKC8N+sX3Slvy8sZJas2N3B7YrPFAC1Kns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772552975; c=relaxed/simple;
	bh=Vxu1qfFIgN1qOocAjpP3vFPSriuOZkmj/+SDoGdRR2I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZZYEwPyqGyD2AMfK5fcSfPKoEgJcLyK0pqfP2DD7eB2XwyOai/wKNt29/CwwmOHHkmqma7YnNeSR6qm+zCIvnvlCfzURf7eoxLJfLgWIYf7tp52DIByvfFH7rCg9wQ+DS31yEHALQxkBfYk/yVj2SJ3txX+MBijQpBqg2bvCHbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=PfOGGlIr; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Buu74u41vICdvAQiIxStiE+5/GgUvF0ZwGzIxNeXnzc=; b=PfOGGlIr2ya2As8WIPdxp1Kyl6
	mhvJCfuCVBigxBE3vZa1NY2jB6ohRHL9SaiiDWfna3zD0sbpWac3sEnP+OFCpLGeOK+duO6k8eg9X
	36FSQqud1wqHCwtZ7MSP+p8QzCKzTlcQFKL35crd6hNFM2ITQCcahuP1bbvR2efaVUtfU8wh+4/ZC
	+uhSoy9gmy1Jd2FD9WHlUKH/tSSWI7ojrn2Z3BjI0hOU1jT76ZazEpXU+McZ/qoLcGNq7IfNUKH9L
	DctXTXdKpXXkYmZ60pjH8MexRItQQaHjAeLDR4nDMrZJQj4EifhhaKwqxV2K80S7bIKN/rz4uzGZ5
	UjqPuB3w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vxS05-0000000FT3y-2eHC;
	Tue, 03 Mar 2026 15:49:33 +0000
Date: Tue, 3 Mar 2026 07:49:33 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/26] xfs_healer: create a service to start the
 per-mount healer service
Message-ID: <aacDDXudwf9ygIkQ@infradead.org>
References: <177249783165.482027.209169366483011357.stgit@frogsfrogsfrogs>
 <177249783527.482027.17759904859193601740.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177249783527.482027.17759904859193601740.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Queue-Id: 6FA561F2F67
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[infradead.org,none];
	R_DKIM_ALLOW(-0.20)[infradead.org:s=bombadil.20210309];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[infradead.org:+];
	TAGGED_FROM(0.00)[bounces-31799-lists,linux-xfs=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[hch@infradead.org,linux-xfs@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[linux-xfs];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[infradead.org:dkim,infradead.org:mid,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Action: no action

> +/* Start healer services for existing XFS mounts. */
> +static int
> +start_existing_mounts(
> +	int			mnt_ns_fd)
> +{
> +	struct mnt_id_req	req = {
> +		.size		= sizeof(struct mnt_id_req),
> +#ifdef HAVE_LISTMOUNT_NS_FD
> +		.mnt_ns_fd	= mnt_ns_fd,
> +#else
> +		.spare		= mnt_ns_fd,
> +#endif
> +		.mnt_id		= LSMT_ROOT,
> +	};
> +	uint64_t		mnt_ids[32];
> +	int			i;


> +	while ((ret = syscall(SYS_listmount, &req, &mnt_ids, 32, 0)) > 0) {

Should this use a wrapper so we can switch to the type safe libc
version once it becomes available?


