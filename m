Return-Path: <linux-xfs+bounces-17061-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 663AB9F5F2A
	for <lists+linux-xfs@lfdr.de>; Wed, 18 Dec 2024 08:21:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7507E7A1543
	for <lists+linux-xfs@lfdr.de>; Wed, 18 Dec 2024 07:21:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE73615CD4A;
	Wed, 18 Dec 2024 07:21:09 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4061E20ED;
	Wed, 18 Dec 2024 07:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734506469; cv=none; b=XWCuqIWLAXYgjSLrZTQPzO85aUNCSiRNiYSfcuuRB5BqlHwQFao8GRSb6i+Xmll0waJgFsuFhUOLzwV8Jh/lP6k7+AYyYrYNbjQF0g2OVB7MOOM4Fbp1OjcSfI3PsK5+ntp1aCKyJAQa0pTr8/kZKb5sKxyamNEf+SE0fqh81IE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734506469; c=relaxed/simple;
	bh=oG8poyLUj/+Gz+rurwOMgKHMDxS8pPP9Q2M9U/K9AMc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Gr6X+rpvIw8mEwEFbI/+uYZstzJRiAOpg01cWIjYSwx/qyJRb5gpxXjQ7V00knNYtbpthfjETbnqK1zp3uADYakUx2jduGBbLKx47sYKjMoxsdf04qhP/luUIGfCl/7RbhRjWOBnCmdaz6chU42ImILY6LDozc7235KQPWdAuyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id A115A68AA6; Wed, 18 Dec 2024 08:21:00 +0100 (CET)
Date: Wed, 18 Dec 2024 08:21:00 +0100
From: Christoph Hellwig <hch@lst.de>
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: axboe@kernel.dk, hare@suse.de, kbusch@kernel.org, sagi@grimberg.me,
	linux-nvme@lists.infradead.org, willy@infradead.org,
	dave@stgolabs.net, david@fromorbit.com, djwong@kernel.org,
	john.g.garry@oracle.com, ritesh.list@gmail.com,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-mm@kvack.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, p.raghav@samsung.com, da.gomez@samsung.com,
	kernel@pankajraghav.com
Subject: Re: [PATCH 0/2] block size limit cleanups
Message-ID: <20241218072100.GB25990@lst.de>
References: <20241218020212.3657139-1-mcgrof@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241218020212.3657139-1-mcgrof@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

(the CC list feels a little excessive, though)

