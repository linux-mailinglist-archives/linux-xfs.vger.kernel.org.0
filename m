Return-Path: <linux-xfs+bounces-13049-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DDB697D4D0
	for <lists+linux-xfs@lfdr.de>; Fri, 20 Sep 2024 13:26:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C4ACE282F77
	for <lists+linux-xfs@lfdr.de>; Fri, 20 Sep 2024 11:26:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9745913E020;
	Fri, 20 Sep 2024 11:26:46 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8290A14290
	for <linux-xfs@vger.kernel.org>; Fri, 20 Sep 2024 11:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726831606; cv=none; b=Al/M6F1M3Gfzupwz2hM6aEqgYaqQ73hbdkm2rylWnRD5ke8ptD/lZVyS8WEf9ZvapOX+23CF+R7K0HAfDh1NWaYaPSaQS/A0phufV06imdoYZuVqifiuan+JCn3FMRavhDOr/EEFp1e6FDT7RCGpBrnPD8JHjTq2f5CPx6n1Rco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726831606; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JahFXKRFpjEkzDOVfcPFlnFIYMo31y93mQn5xQP5n4rC11guDroQBuYm+USlhsJgl7ZtC/bx3K2eaaxbjMVCypRIqF467wBBhpiQO+Gv/nz5S+DUwmnmyzF1xncy5+CbpZMIPxtGc5pyZ6DqGiln/OCZHaSnxA5Iw4qTiH662Go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 296A3227AA8; Fri, 20 Sep 2024 13:26:41 +0200 (CEST)
Date: Fri, 20 Sep 2024 13:26:40 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 2/2] libfrog: emulate deprecated attrlist functionality
 in libattr
Message-ID: <20240920112640.GB24193@lst.de>
References: <172678988199.4013721.16925840378603009022.stgit@frogsfrogsfrogs> <172678988232.4013721.6771483228393251863.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172678988232.4013721.6771483228393251863.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


