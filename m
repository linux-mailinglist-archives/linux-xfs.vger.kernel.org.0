Return-Path: <linux-xfs+bounces-31783-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KHmiL3T+pmk7bgAAu9opvQ
	(envelope-from <linux-xfs+bounces-31783-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Tue, 03 Mar 2026 16:29:56 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 29D761F2A34
	for <lists+linux-xfs@lfdr.de>; Tue, 03 Mar 2026 16:29:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 35AA5301A70B
	for <lists+linux-xfs@lfdr.de>; Tue,  3 Mar 2026 15:24:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 004F436607D;
	Tue,  3 Mar 2026 15:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="if7nqqvg"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6AB237CD22
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 15:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772551474; cv=none; b=QavizkmvVPNXr+w/23po1fouikyFYJ950lq1+8BufjYoFF/PmPnZIUk4mqnECbjBZXmldULE4mt06OAfrNyNhYecmDafEaPsW1BU94VpL17t9foxB4zx1ae1VmobYqkkC3OA/WQxUOGuJ46NnA1Z+Fh5pm8qXPNpOM7EhT8d8us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772551474; c=relaxed/simple;
	bh=o5tc2YfzNL3lUIiqpbrJMnDNYymhvSb7jFm3/5uHRRE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HlF77fY2xs8jNEkbZl3Yl+amoItht/0I5mkMiBaMgTutpbcCCWaFdWwa+tDco6xXx/uiIpSLCWNT8mEsDPujPsfw9ryk9H6qr+DzJMiuX9NiULSNgKXIuPg3V4jkwe46I3jbVDphnlVrQSvwwQMphC/TQJIuT4Vt+Sz/Tw/9DO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=if7nqqvg; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=jiMk52t21hpC8ZWhYIu/lw9114/V51HVv9xembWCrcc=; b=if7nqqvglVn7+x81YnUtwkSPBJ
	wX7m8xAVOrDr7opBtJhmo2+jzFOyaIqIQRgLAhGuRDmp2GeTAsYVNMl3dcK6eTRH1RzQLMrZoIV6v
	TDOGGT9bicBcAqbNXORUDBAZb4ySZgrIJrtxe3AWw6lqfWrvECvhJBTYy3BeKbxx6YHpSHHY1zXwV
	fqs3AwtLZ7q/2n5wwoXpWiZKFuONyXZ7MeN7PsRuhEZoT/A4kowEoGGebGgWZS5ssxi3SAueHYGTb
	T3toKSgtKk+8nc6Zo5EI2dJC0G2OHJcadMDj337di0JnfpQhSKJOQSf92HxJEyF833IppoyDsfiOk
	hLLBrzKQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vxRbq-0000000FQQQ-1G9O;
	Tue, 03 Mar 2026 15:24:30 +0000
Date: Tue, 3 Mar 2026 07:24:30 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Pankaj Raghav <p.raghav@samsung.com>
Cc: linux-xfs@vger.kernel.org, bfoster@redhat.com, dchinner@redhat.com,
	"Darrick J . Wong" <djwong@kernel.org>, gost.dev@samsung.com,
	pankaj.raghav@linux.dev, andres@anarazel.de, cem@kernel.org,
	hch@infradead.org, lucas@herbolt.com
Subject: Re: [RFC 1/2] xfs: add flags field to xfs_alloc_file_space
Message-ID: <aab9Lgt-HUaNq-FL@infradead.org>
References: <20260227140842.1437710-1-p.raghav@samsung.com>
 <20260227140842.1437710-2-p.raghav@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260227140842.1437710-2-p.raghav@samsung.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Queue-Id: 29D761F2A34
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[infradead.org,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[infradead.org:s=bombadil.20210309];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-31783-lists,linux-xfs=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	DKIM_TRACE(0.00)[infradead.org:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[hch@infradead.org,linux-xfs@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[11];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[linux-xfs];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,infradead.org:dkim,infradead.org:mid]
X-Rspamd-Action: no action

On Fri, Feb 27, 2026 at 03:08:41PM +0100, Pankaj Raghav wrote:
> Currently, xfs_alloc_file_space() hardcodes the XFS_BMAPI_PREALLOC flag
> when calling xfs_bmapi_write(). This restricts its capability to only
> allocating unwritten extents.
> 
> In preparation for adding FALLOC_FL_WRITE_ZEROES support, which needs to
> allocate space and simultaneously convert it to written and zeroed
> extents, introduce a 'flags' parameter to xfs_alloc_file_space(). This
> allows callers to explicitly pass the required XFS_BMAPI_* allocation
> flags.
> 
> Update all existing callers to pass XFS_BMAPI_PREALLOC to maintain the
> current behavior. No functional changes intended.
> 
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> ---
>  fs/xfs/xfs_bmap_util.c | 5 +++--
>  fs/xfs/xfs_bmap_util.h | 2 +-
>  fs/xfs/xfs_file.c      | 6 +++---
>  3 files changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 0ab00615f1ad..532200959d8d 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -646,7 +646,8 @@ int
>  xfs_alloc_file_space(
>  	struct xfs_inode	*ip,
>  	xfs_off_t		offset,
> -	xfs_off_t		len)
> +	xfs_off_t		len,
> +	uint32_t flags)

Messed up indentation.

Given that we've been through this for a lot of iterations, what
about you just take Lukas' existing patch and help improving it?


