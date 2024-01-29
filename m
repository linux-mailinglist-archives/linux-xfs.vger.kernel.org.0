Return-Path: <linux-xfs+bounces-3089-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B0A9083FE26
	for <lists+linux-xfs@lfdr.de>; Mon, 29 Jan 2024 07:20:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6C5EC281835
	for <lists+linux-xfs@lfdr.de>; Mon, 29 Jan 2024 06:20:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B4944C60E;
	Mon, 29 Jan 2024 06:20:43 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C43A4BABE;
	Mon, 29 Jan 2024 06:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706509243; cv=none; b=jBNiESgIhefzXuVHaz/dmCZdXx471c2h8nt0EE/IMxpDYoN7MB/CJFHGzbpIMtYbjrZhMH1xQn52uelbGNcyG/kBwYfviJvszYebJwEfHJ/SKxOQFVrou5MwGqk/D73S8Ic0tmnw2q+YYQxdzT7AY5YX2HiSeQ4oC87pP9CDJ9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706509243; c=relaxed/simple;
	bh=a3ABtJCzIyYgu9Y0K7TLjoHutY0PL9Nh7ra7xgZiwb4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OiFXPqE1frxXp7p6hj25V3Go63XbrKIkR0L69FTxxskll67ow6MDlZNakiiC0JqYEqt6twCUs+DSqQFPJ1HGMZxJESlkzBiXI4JSgDH8Kw4BWlClrlvZBHKhR/nYoDKZdowXf/mxO4/17stK+4XSgtOtWNnukjjKxLdAAgUiqAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 95A9768B05; Mon, 29 Jan 2024 07:20:35 +0100 (CET)
Date: Mon, 29 Jan 2024 07:20:35 +0100
From: Christoph Hellwig <hch@lst.de>
To: John Garry <john.g.garry@oracle.com>
Cc: Keith Busch <kbusch@kernel.org>, axboe@kernel.dk, hch@lst.de,
	sagi@grimberg.me, jejb@linux.ibm.com, martin.petersen@oracle.com,
	djwong@kernel.org, viro@zeniv.linux.org.uk, brauner@kernel.org,
	dchinner@redhat.com, jack@suse.cz, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	tytso@mit.edu, jbongio@google.com, linux-scsi@vger.kernel.org,
	ming.lei@redhat.com, ojaswin@linux.ibm.com, bvanassche@acm.org,
	Alan Adamson <alan.adamson@oracle.com>
Subject: Re: [PATCH v3 15/15] nvme: Ensure atomic writes will be executed
 atomically
Message-ID: <20240129062035.GB19796@lst.de>
References: <20240124113841.31824-1-john.g.garry@oracle.com> <20240124113841.31824-16-john.g.garry@oracle.com> <ZbGwv4uFdJyfKtk5@kbusch-mbp.dhcp.thefacebook.com> <dbb3ad13-7524-4861-8006-b2ea426fbacd@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dbb3ad13-7524-4861-8006-b2ea426fbacd@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Jan 25, 2024 at 11:28:22AM +0000, John Garry wrote:
> We have limits checks in XFS iomap and fops.c, but we would also want to 
> ensure that the the block layer is not doing anything it shouldn't be doing 
> after submit_bio_noacct(), like merging atomic write BIOs which straddle a 
> boundary or exceed atomic_max (if there were any merging).
>
> The SCSI standard already has provision for error'ing an atomic write 
> command which exceeds the target atomic write capabilities, while NVMe 
> doesn't.

Can you get Oracle to propose this for NVMe?  It always helps if these
suggestions come from a large buyer of NVMe equipment.

> BTW, Christoph did mention that he would like to see this:
> https://lore.kernel.org/linux-nvme/20231109153603.GA2188@lst.de/

I can probably live with a sufficiently low-level block layer check.

