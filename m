Return-Path: <linux-xfs+bounces-10216-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E7C7791EEF0
	for <lists+linux-xfs@lfdr.de>; Tue,  2 Jul 2024 08:26:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 266D61C20B46
	for <lists+linux-xfs@lfdr.de>; Tue,  2 Jul 2024 06:26:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8ECE74047;
	Tue,  2 Jul 2024 06:26:04 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16C2360BBE
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 06:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719901564; cv=none; b=Wf5SndMW8piMt72RZuk3lmBSvhidW05kCumnGpiZHcry6tyyAQvREdp8xIJMmV9R4Td1GpEJsGHzyDrk9k0/tzgNMnzdkiBmTL3OlmloQFxv08uLIcO4W3XtR9jA/3ZxDcQ++OWIlStv4wYtg/PX0wUoLbiJ2DD1qWsVB3wC1dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719901564; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HwnDbX/y36ghA+8xrD9xMUr4zP1JIAyCmHmURw0Y38Bdzq45utnwJrYReVq8/kb3p2K1bzaO8LyvDI2xn2kZIDpThs9umSBqJfydpNL/esg//rrjj7SVbkbf5HPFQa+R6sKW64hqICg+yBiRIitLcQ/5rYYNbULhSIfo9fSE6Mw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 2D4D868B05; Tue,  2 Jul 2024 08:26:00 +0200 (CEST)
Date: Tue, 2 Jul 2024 08:26:00 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
	allison.henderson@oracle.com, hch@lst.de
Subject: Re: [PATCH 06/24] libfrog: add parent pointer support code
Message-ID: <20240702062600.GF24089@lst.de>
References: <171988121023.2009260.1161835936170460985.stgit@frogsfrogsfrogs> <171988121155.2009260.6759812584905155328.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988121155.2009260.6759812584905155328.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

