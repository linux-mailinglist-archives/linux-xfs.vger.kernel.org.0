Return-Path: <linux-xfs+bounces-10170-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3997591EE43
	for <lists+linux-xfs@lfdr.de>; Tue,  2 Jul 2024 07:24:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E02381F2254F
	for <lists+linux-xfs@lfdr.de>; Tue,  2 Jul 2024 05:24:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA037339B1;
	Tue,  2 Jul 2024 05:24:16 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 716922A1D7
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 05:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719897856; cv=none; b=rfDukSaIXBCF8Z81OlhYWGVt5cfMz3fdK6RDeVKipxloH3djq4yf5jUIUBZVWwJYbHt9b9lUZ05T7VmO6DhC+0ZvkMWlR5uW0zu/eRKiUnDSrD5vcN3bbPdlSiGAXeq0AI8F2PknahTpfi1101WxC/izLPTjphbQr8OXW6l1KjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719897856; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f2fQHcPc2HJzDlwlbE3x3b5QWFtvrL3EwtFi3EgN27ZjEGAracCFBvLRU6kCd5y6fwmZYt0rEzsWPaSvkXm+hXbWjipM4riuEVrAfkgqI3XYIfif12hxrq7iwzqt28E+1ZuvkmxAFbs444aKnh17sCcyzs7RLhvZK4WPtMVpLYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 831E068B05; Tue,  2 Jul 2024 07:24:12 +0200 (CEST)
Date: Tue, 2 Jul 2024 07:24:12 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 09/13] xfs_scrub: type-coerce the UNICRASH_* flags
Message-ID: <20240702052412.GL22536@lst.de>
References: <171988117591.2007123.4966781934074641923.stgit@frogsfrogsfrogs> <171988117748.2007123.4070255254924781803.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988117748.2007123.4070255254924781803.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


