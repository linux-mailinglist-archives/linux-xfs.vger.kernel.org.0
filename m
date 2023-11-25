Return-Path: <linux-xfs+bounces-84-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 914217F8888
	for <lists+linux-xfs@lfdr.de>; Sat, 25 Nov 2023 06:53:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4B264281B45
	for <lists+linux-xfs@lfdr.de>; Sat, 25 Nov 2023 05:53:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66E9B4433;
	Sat, 25 Nov 2023 05:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ztAqCz0j"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1FCD10F4
	for <linux-xfs@vger.kernel.org>; Fri, 24 Nov 2023 21:53:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=n6Zpegjkpjlvaq4qwxzDzN6jY/+zG2RZg6MGIP03X/U=; b=ztAqCz0jY2YQ9qdTbfNw82qQyK
	+srDrt4B2ynJ+2XP9uR+3AAo55OsYUpsjb6m526Mo7nO1sh+7AvgiwvUv3TxYwmhvD629I14M4/o7
	iTacBfPxao3ZvWoL+Ypb6jd5RN8goTA1G4NhHa22+XwHdcVkQMC8YurN+UjFbGlQn+JGQ9ZcQnm8K
	nRx7wg3TwV2rbgSLu0C6UdGEFKOWgNWpNv9KEVU+mycvj+pX1o21o2200QiS4A5VvMk+j1izBDrv9
	USUBknIN2++46ZLzUszxrG2DW1ZdUSQTDkxylKaDRDFaB8ztwixr5c+r30o5CLjpKCOiv1kjU58nr
	BD1gyBXQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1r6lbm-008dR9-2B;
	Sat, 25 Nov 2023 05:53:38 +0000
Date: Fri, 24 Nov 2023 21:53:38 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: constrain dirty buffers while formatting a
 staged btree
Message-ID: <ZWGL4tBoNDoGND7F@infradead.org>
References: <170086926569.2770816.7549813820649168963.stgit@frogsfrogsfrogs>
 <170086926640.2770816.12781452338907572006.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170086926640.2770816.12781452338907572006.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> @@ -480,7 +500,7 @@ xfs_btree_bload_node(
>  
>  		ASSERT(!xfs_btree_ptr_is_null(cur, child_ptr));
>  
> -		ret = xfs_btree_get_buf_block(cur, child_ptr, &child_block,
> +		ret = xfs_btree_read_buf_block(cur, child_ptr, 0, &child_block,
>  				&child_bp);

How is this (and making xfs_btree_read_buf_block outside of xfs_buf.c)
related to the dirty limit?


