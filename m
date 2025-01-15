Return-Path: <linux-xfs+bounces-18291-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D8321A118DE
	for <lists+linux-xfs@lfdr.de>; Wed, 15 Jan 2025 06:20:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0430A1685FC
	for <lists+linux-xfs@lfdr.de>; Wed, 15 Jan 2025 05:20:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BF331547D5;
	Wed, 15 Jan 2025 05:20:50 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E1EA801
	for <linux-xfs@vger.kernel.org>; Wed, 15 Jan 2025 05:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736918450; cv=none; b=iRoihvFf1nQFUoezRjUckQmGjywXrgeFF4vdjWZv6uHHrN4ecJkj/G5YnhN3UMOaD/I4NMNr50Aw86AlP/K4e/GNzrPQ+uL1WuCXLFSK8S1RlsyZJByKNvM6cOhUErxBECgfB1PXAZoqyWjG3n/9QhrttgrCn/tPXulsK0TBZXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736918450; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mfJJUZBUGB5YSaCvz1FCtkKhaoVgqppvbhB+7i9oKIZuoHKa91kIwT6N0CaAUz/n/qVn+YBc7OXLjseiRR9WxFnBYbtogOObL2/j+KS96wnAy4w6ntRpFUxwW/MiL5MFUgo9UpD6W+DQV+HbuDP0/YbvPXTV3B6spFV9dOIWql8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 640ED68B05; Wed, 15 Jan 2025 06:20:44 +0100 (CET)
Date: Wed, 15 Jan 2025 06:20:43 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/5] mkfs: fix parsing of value-less -d/-l concurrency
 cli option
Message-ID: <20250115052043.GB28609@lst.de>
References: <173689081879.3476119.15344563789813181160.stgit@frogsfrogsfrogs> <173689081910.3476119.11332577729920649286.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173689081910.3476119.11332577729920649286.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


