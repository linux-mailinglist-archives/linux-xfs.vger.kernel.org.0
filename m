Return-Path: <linux-xfs+bounces-18292-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 79A1DA118DF
	for <lists+linux-xfs@lfdr.de>; Wed, 15 Jan 2025 06:21:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 913961685DF
	for <lists+linux-xfs@lfdr.de>; Wed, 15 Jan 2025 05:21:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E96EB1547D5;
	Wed, 15 Jan 2025 05:21:05 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 284804C6C
	for <linux-xfs@vger.kernel.org>; Wed, 15 Jan 2025 05:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736918465; cv=none; b=CVx2N7DE/VVRU9JZIXAZXU/4u1DyhSKhKMgCkpEWkw1dYAhZGf5ka1npGaoEzd0FoZ+Wle3A43Y8E6UMS4p4Fn85/r5t1VMF+rAqaH/F2kivQLw1hH1yVBS0odcb0A9TZQx/WfyMoLlGHVIhqPf5wHHnBYoAeo8bJppfnkUaSnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736918465; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hkkZ5kqU5KjAiamZru//Sr6Sp1M45OFnpdUKW5fRsZtP8l9H3WDVpQda3GG1ZpVbeWJNi4OGGBjOqL/VYApTyBOzdSZGrb5XCJT/AYUcE2qLblLGoc/s9eziJAX3CsEV7y9YUrTkzoRUZxuq5qOae8RHSljmcYNJfjztIBlOSag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 32E7368B05; Wed, 15 Jan 2025 06:21:00 +0100 (CET)
Date: Wed, 15 Jan 2025 06:20:59 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] m4: fix statx override selection if /usr/include
 doesn't define it
Message-ID: <20250115052059.GC28609@lst.de>
References: <173689081879.3476119.15344563789813181160.stgit@frogsfrogsfrogs> <173689081926.3476119.12874616172883806766.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173689081926.3476119.12874616172883806766.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


