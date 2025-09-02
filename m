Return-Path: <linux-xfs+bounces-25167-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 88A27B3F55F
	for <lists+linux-xfs@lfdr.de>; Tue,  2 Sep 2025 08:23:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 42E18482217
	for <lists+linux-xfs@lfdr.de>; Tue,  2 Sep 2025 06:23:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB56A2E2F0E;
	Tue,  2 Sep 2025 06:23:11 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA4AA2D5955
	for <linux-xfs@vger.kernel.org>; Tue,  2 Sep 2025 06:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756794191; cv=none; b=o1yg1JUSIF8FlgR2AYwocHCagG5yezoOdY351f+Nq1awwdSk0eqgnP1cbwMgBO25zb/OdP/0gqfd3OE/30gjgyypRhHIxfZyo8dqZOSlKmWK8EAHXfHXuccUK93C/z6wiSC9Kxrt9xeRwNUHQxYBBLM4KGUSCP7i2fO0ur9qlJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756794191; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W843Sg1/Vv1Gu+gfmvhKuz8YMTIW5mHGFQmliUJlYlHwvOuDlZ9GcPpGKzaX+ROcxxAqMTjv5mmF/JpBPhrJvt9yrkqS8TZghiTnlzOGGLyDCu6iWq042tbwpyJ2WKkfBc6jTVLiLs41RYE9rbTxo1FWfEUF6F/MYXuxhcel15w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C5C4068AA6; Tue,  2 Sep 2025 08:23:04 +0200 (CEST)
Date: Tue, 2 Sep 2025 08:23:04 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/9] xfs: prepare reaping code for dynamic limits
Message-ID: <20250902062304.GA12229@lst.de>
References: <175639126389.761138.3915752172201973808.stgit@frogsfrogsfrogs> <175639126461.761138.5633907133608492664.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <175639126461.761138.5633907133608492664.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


