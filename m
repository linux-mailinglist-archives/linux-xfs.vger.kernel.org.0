Return-Path: <linux-xfs+bounces-13-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 20F897F587C
	for <lists+linux-xfs@lfdr.de>; Thu, 23 Nov 2023 07:42:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CA9991F20D5A
	for <lists+linux-xfs@lfdr.de>; Thu, 23 Nov 2023 06:42:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB512125AC;
	Thu, 23 Nov 2023 06:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="zmRR7yRi"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73918AD
	for <linux-xfs@vger.kernel.org>; Wed, 22 Nov 2023 22:42:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=bSyuy2Rbc2/IazR5iHXJPTI+mQPjlcC9ptsNZbrwUOE=; b=zmRR7yRilw8KOY7erXTtefesM8
	bmjzcAssiFHeDHZ20JvpN+D3XO9FmM0JPQDuJzc4TwP1Zqx28lrzCeT3fAG6FbFGK2H0lraHNkwzK
	TsD+76Rl6eUKOEmSnoyL61mo+OGRIBEsPChlBceAsjzZZeXB1OveR2aNPB+Qtv5McsWTcLnVWKWVf
	LM/yL8jDgOb4UKkzykHUrj0jpELZCWOZU0ioWkQc6wBeVhgJYdjddAtkjMx59ugKURt7f+KlAvUHC
	4i0x7VhNu4HbbxlFwFeosTUBsFR9gIWoevRRQ2Cjca2fXgmeyP2GJU+JZl5nBF9xy/J2Ukrv8eY05
	Grp+M3fg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1r63Q8-003w2n-17;
	Thu, 23 Nov 2023 06:42:40 +0000
Date: Wed, 22 Nov 2023 22:42:40 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 8/9] xfs_mdrestore: EXTERNALLOG is a compat value, not
 incompat
Message-ID: <ZV70YNvPWauYckC4@infradead.org>
References: <170069440815.1865809.15572181471511196657.stgit@frogsfrogsfrogs>
 <170069445376.1865809.6391643475229742760.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170069445376.1865809.6391643475229742760.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Nov 22, 2023 at 03:07:33PM -0800, Darrick J. Wong wrote:
> @@ -280,10 +278,8 @@ read_header_v2(
>  	if (h->v2.xmh_reserved != 0)
>  		fatal("Metadump header's reserved field has a non-zero value\n");
>  
> -	want_external_log = !!(be32_to_cpu(h->v2.xmh_incompat_flags) &
> -			XFS_MD2_COMPAT_EXTERNALLOG);
> -
> -	if (want_external_log && !mdrestore.external_log)
> +	if ((h->v2.xmh_compat_flags & cpu_to_be32(XFS_MD2_COMPAT_EXTERNALLOG)) &&
> +	    !mdrestore.external_log)

Nit: overly long line.  Trivially fixable by just inverting the
conditions :)

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

