Return-Path: <linux-xfs+bounces-365-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 55FF7802B1A
	for <lists+linux-xfs@lfdr.de>; Mon,  4 Dec 2023 05:55:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8C573280CB1
	for <lists+linux-xfs@lfdr.de>; Mon,  4 Dec 2023 04:55:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 471B2539A;
	Mon,  4 Dec 2023 04:55:33 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04991F2
	for <linux-xfs@vger.kernel.org>; Sun,  3 Dec 2023 20:55:30 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 13AB5227AA8; Mon,  4 Dec 2023 05:55:27 +0100 (CET)
Date: Mon, 4 Dec 2023 05:55:26 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: chandanbabu@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: make rextslog computation consistent with mkfs
Message-ID: <20231204045526.GA26073@lst.de>
References: <170162990622.3038044.5313475096294285406.stgit@frogsfrogsfrogs> <170162990643.3038044.15276614586917381582.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170162990643.3038044.15276614586917381582.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

> + */
> +uint8_t
> +xfs_compute_rextslog(
> +	xfs_rtbxlen_t		rtextents)
> +{
> +	return rtextents ? xfs_highbit32(rtextents) : 0;

It might just be a personal pet peeve, but I find a good old if much
more readable for this:

	if (!rtextents)
		return 0;
	return xfs_highbit32(rtextents);

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


