Return-Path: <linux-xfs+bounces-25058-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id C49B6B397DD
	for <lists+linux-xfs@lfdr.de>; Thu, 28 Aug 2025 11:11:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id A01834E344E
	for <lists+linux-xfs@lfdr.de>; Thu, 28 Aug 2025 09:11:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8914273800;
	Thu, 28 Aug 2025 09:11:31 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.gentoo.org (woodpecker.gentoo.org [140.211.166.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0854B1373
	for <linux-xfs@vger.kernel.org>; Thu, 28 Aug 2025 09:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=140.211.166.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756372291; cv=none; b=KIgEeidFnvNDuI/dzIMtTA22X4uggDOIAYvSZCRHrDygXPepvJnwfRBjuO/NFtt+C0XU+ZMO834I9EpOGips6BRucNs3FfJ4BSbq2lGpW0YF+ohN19utKnydcKe86l3bP/oVspnoNqSA2MB3LXYJ8m+nsU7AL09l+qbI5jGEomg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756372291; c=relaxed/simple;
	bh=wzsKs1Y2i1lU9kP367njU9Ckckne3CyOWo+z6O5i3A4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LlgGwwx6TfoBoWvwbjJN/Be4CBkmF5utBCF4S2wopgCrT5QmYSXHOwHdlAxRaHpolJFnARpvpGJV5hrdeiX/OBqdrpTtfshfJ26tieDgGsLaZ7P5Bxm/aCmAzqtKm9aXmYzAAeJNG6Az7iyTo2Gp4/ds31+U+1yviQuBDbt5HAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gentoo.org; spf=pass smtp.mailfrom=gentoo.org; arc=none smtp.client-ip=140.211.166.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gentoo.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gentoo.org
Received: from arkam (ip-213-220-240-96.bb.vodafone.cz [213.220.240.96])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: arkamar)
	by smtp.gentoo.org (Postfix) with ESMTPSA id DF829340CD7;
	Thu, 28 Aug 2025 09:11:27 +0000 (UTC)
Date: Thu, 28 Aug 2025 11:11:22 +0200
From: Petr =?utf-8?B?VmFuxJtr?= <arkamar@gentoo.org>
To: Johannes Nixdorf <johannes@nixdorf.dev>
Cc: XFS Development Team <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 1/2] configure: Base NEED_INTERNAL_STATX on libc headers
 first
Message-ID: <202582891122-aLAdOl_jIkYixlPu-arkamar@gentoo.org>
References: <20250809-musl-fixes-v1-0-d0958fffb1af@nixdorf.dev>
 <20250809-musl-fixes-v1-1-d0958fffb1af@nixdorf.dev>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250809-musl-fixes-v1-1-d0958fffb1af@nixdorf.dev>

On Sat, Aug 09, 2025 at 07:13:07PM +0200, Johannes Nixdorf wrote:
> At compile time the libc headers are preferred, and linux/stat.h is
> only included if the libc headers don't provide a definition for statx
> and its types (tested on STATX_TYPE). The configure test should be
> based on the same logic.
> 
> This fixes one cause for failing to compile against musl libc.
> 
> Signed-off-by: Johannes Nixdorf <johannes@nixdorf.dev>

Looks good, it solves the issue for us.

Reviewed-by: Petr Vaněk <arkamar@gentoo.org>

