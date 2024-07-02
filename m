Return-Path: <linux-xfs+bounces-10191-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 722DD91EE69
	for <lists+linux-xfs@lfdr.de>; Tue,  2 Jul 2024 07:38:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2E14A2830D8
	for <lists+linux-xfs@lfdr.de>; Tue,  2 Jul 2024 05:38:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58EFE74047;
	Tue,  2 Jul 2024 05:38:02 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 042E56A032
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 05:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719898682; cv=none; b=Bwra61J5hNjvBv5zwEM30TOhFB5rZnQEoe2eHTWDkXAfJFJksoopbfzeHTk8Ss3PsN90/M7yTBDnpcX/NuBf6hKruKYvKtIQm5NkuUZ5PnTL5zxVcMJRfWYdmLi93Pq8Zy5Z1hCSJRJZLcblOM8t/+ru9zFoku7cegiKIrSrCaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719898682; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pQg3qRi66NPOxO8hWONtGyVzqze+tciY1dOk+Dy2Is12WeXT3DXotapNerNtIhuSUAotzxyh8cOijW5I0MxkYufq8SKVdgKlcepZWXrIz0xjh4+if60NNjR10k1/cqD0PBMBlyRAcn/YkJjI09P2LHxFJfvzANpppF9ZwsqWvhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 2747468B05; Tue,  2 Jul 2024 07:37:58 +0200 (CEST)
Date: Tue, 2 Jul 2024 07:37:58 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 6/6] xfs_scrub_all: tighten up the security on the
 background systemd service
Message-ID: <20240702053757.GC23155@lst.de>
References: <171988118996.2008208.13502268616736256245.stgit@frogsfrogsfrogs> <171988119097.2008208.5897497587818401006.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988119097.2008208.5897497587818401006.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


