Return-Path: <linux-xfs+bounces-19573-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A1A3BA3471E
	for <lists+linux-xfs@lfdr.de>; Thu, 13 Feb 2025 16:31:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C245918911F4
	for <lists+linux-xfs@lfdr.de>; Thu, 13 Feb 2025 15:25:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38ABC1411DE;
	Thu, 13 Feb 2025 15:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZZngH7jJ"
X-Original-To: linux-xfs@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8192B146588
	for <linux-xfs@vger.kernel.org>; Thu, 13 Feb 2025 15:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460300; cv=none; b=MgWJDCFfd/Giw9RwPb2QFXhBdo44vpywLeJ5q+B5OWD00kIyPVwEfxCpNIqF4Ugo6aROMaMZRX6ooFlwgdogqUok6X+lUxK86iB/UV3jvB7zo2p/MeXfTYQnnVv8hnFfhMeYoCRMvTNGGYWIdswdhxPuU2BzhfiaMcCX98KfW20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460300; c=relaxed/simple;
	bh=hFyGp/Eg80nyAboL8LuIFjshUMLGFsUswB0uf6lF/jA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J2hHMEDiqF+s4xvKcAdp6mH8wVUB7VDBAKHfqS6Hre0wlWAA5vy9LDPZyazyYEvK8OIgLNCLLSicIBlk36Fh2Bb2K1fpB/I9Fb3fuH//Vf+VqVQ2hA1cWfThKWCDnU8Q4jOee02PoP7PTK8OP1PsWz3Ah22GogMUDR45o1T6Y5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZZngH7jJ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739460297;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=i4Tw6QD+476TH3jdgkW3TNg9gzO7dlh/ltoiIiLZQbI=;
	b=ZZngH7jJJfsne+eJu7n5eLref3Zo8oACR2pBheVCxBZE8HMtngTnpUvp9GJwS2dhhvmk0r
	HBfyYnlQ8cF0a1divUyy+J0JthCVvFAsMBLlYxOIZMhXkYDhgHLzs0LZEBsHkuKYrUWziU
	kyzffdhaMKA1PRxncamRLs++6yHnp9k=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-692-SKQjzEB6OQereMW9-vvF5A-1; Thu,
 13 Feb 2025 10:24:56 -0500
X-MC-Unique: SKQjzEB6OQereMW9-vvF5A-1
X-Mimecast-MFC-AGG-ID: SKQjzEB6OQereMW9-vvF5A
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id ED5BE19373D8;
	Thu, 13 Feb 2025 15:24:53 +0000 (UTC)
Received: from bfoster (unknown [10.22.88.88])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0B1C3300018D;
	Thu, 13 Feb 2025 15:24:52 +0000 (UTC)
Date: Thu, 13 Feb 2025 10:27:18 -0500
From: Brian Foster <bfoster@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	"Darrick J . Wong" <djwong@kernel.org>
Subject: Re: [PATCH 04/10] dax: advance the iomap_iter in the read/write path
Message-ID: <Z64PVpTOVhxfFPZm@bfoster>
References: <20250212135712.506987-1-bfoster@redhat.com>
 <20250212135712.506987-5-bfoster@redhat.com>
 <Z62XUFHMtNkXJpDi@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z62XUFHMtNkXJpDi@infradead.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Wed, Feb 12, 2025 at 10:55:12PM -0800, Christoph Hellwig wrote:
> On Wed, Feb 12, 2025 at 08:57:06AM -0500, Brian Foster wrote:
> > DAX reads and writes flow through dax_iomap_iter(), which has one or
> > more subtleties in terms of how it processes a range vs. what is
> > specified in the iomap_iter. To keep things simple and remove the
> > dependency on iomap_iter() advances, convert a positive return from
> > dax_iomap_iter() to the new advance and status return semantics. The
> > advance can be pushed further down in future patches.
> 
> Looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> (and looking forward to the future patches..)
> 

Thanks. The patch to push this down a level seems to be working now so
I'll include it in v2.

Brian


