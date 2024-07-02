Return-Path: <linux-xfs+bounces-10252-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0EC6E91EF5C
	for <lists+linux-xfs@lfdr.de>; Tue,  2 Jul 2024 08:49:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 92552B22FFE
	for <lists+linux-xfs@lfdr.de>; Tue,  2 Jul 2024 06:49:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 717ED7D405;
	Tue,  2 Jul 2024 06:49:22 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20D3E5C5F3
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 06:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719902962; cv=none; b=Cdt4n2ZJhsH9fmHuTeb4DTpuq7/OQGx1p/qIDA+0FndfLzctLCvAXhJgfTrd+MVL9goCFlG87lqya0Zu9e3sK9rC/L67sRW6VixgjqRnAcqPUGhtDV413jyhFZO94r1z+B4gEHREY58FpdXaUNyDeHgV0xky8myMFRBM/uUC2sE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719902962; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SV15FvGyAoRfdyxdeQrFBaTe6xhhv1ZTyuTThPzCpZjJAcLlWWjcmmoU7h5mNjaET3+h/x9V5lEKNzrguTFOpgHBBdLxqTQRQQ0oIanOQ/AVBYwj1vESBTpYo8vKg3BV4dGa1qb/sXwnP7IM5Jx6P0nGGNF8tahL9l6JtJzFc4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 8022D68B05; Tue,  2 Jul 2024 08:49:18 +0200 (CEST)
Date: Tue, 2 Jul 2024 08:49:18 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 4/5] xfs_scrub: detect and repair directory tree
 corruptions
Message-ID: <20240702064918.GD25817@lst.de>
References: <171988122691.2012320.13207835630113271818.stgit@frogsfrogsfrogs> <171988122757.2012320.11258096209141176786.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988122757.2012320.11258096209141176786.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

