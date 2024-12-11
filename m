Return-Path: <linux-xfs+bounces-16510-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 958C99ED6F0
	for <lists+linux-xfs@lfdr.de>; Wed, 11 Dec 2024 21:00:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BBE5F188427C
	for <lists+linux-xfs@lfdr.de>; Wed, 11 Dec 2024 19:59:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84A7F20B204;
	Wed, 11 Dec 2024 19:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rot+BtX0"
X-Original-To: linux-xfs@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D21BC1C3F27;
	Wed, 11 Dec 2024 19:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733947126; cv=none; b=Pr1a2TXgz0hdXqU/G/1gQ3NzHH06GxwBBkXSVuWdPy31R+5d3RImflvOLCKfHmkCPJmCsnIfxgp0CbRmjVR3YNiL4xmriNqlSLRCuRbcR58ps2/gB5d9qofZU4kBeS+pJPPz84p0fFqtWV/6GDYNm8Uu6MaI3mC4xDIC/X4jm+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733947126; c=relaxed/simple;
	bh=iLL7j+lhKXojSACcFUP2A1NPQsahr5PmalZuUhrk2LQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WrbxwQ3jxyE+DpWuWAfbG2+HfF/jaTyzVxxRexqkt1yJ+H5uRX5xV0dSNsFx20mTPnzdMg+VHUP+ZFbjqt1BwHyDSY5LMPW5DX3pSVFqQN/wqJouZTeIhoBT3dhIj4rw5uH82/TdR2ybd+u106lgF52DtAW0k+pR3zJvgisHQDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=rot+BtX0; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=BAIaH1HkkTf+nk+nd0kNKy4nHuwixpyhCxY3FdT7Iho=; b=rot+BtX03O5eoy+/W6CImZtpLF
	B2J+HV2MN9hpw14VUE8XYix2VFRVhGQU8H/uTM3J1mmZpjcjZp7yPIWLjQL1fJCi9+9N9/aSKmPZ/
	Svh5R+aTcGV3ygcwNilZsNAVDsJ2zFvQCiYdL7kDfBXZ3V2C5CYGv8x2wU8s4hZPyD/EiuABN8YZj
	Kbvi5qL3KMJmIBkEaHBKIyvBiaU19Mzyz/cvH7DnSDXMxSaaxq0KHZSPx7HYX5fjetwaV4T6jd1M3
	DfMnNSQkOFSGtn0znk++1yZeNqZ96gcm5m5YwlSWI8/9BGffEhtW9salGxQp8W3IeAWWpCYDTq41t
	YlPmnZVw==;
Received: from willy by casper.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tLSqt-00000000Yyl-1lLr;
	Wed, 11 Dec 2024 19:58:31 +0000
Date: Wed, 11 Dec 2024 19:58:31 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Bingwu Zhang <xtex@envs.net>
Cc: Jonathan Corbet <corbet@lwn.net>, Miklos Szeredi <miklos@szeredi.hu>,
	"Darrick J. Wong" <djwong@kernel.org>, Bingwu Zhang <xtex@aosc.io>,
	linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org,
	linux-xfs@vger.kernel.org, ~xtex/staging@lists.sr.ht
Subject: Re: [PATCH] Documentation: filesystems: fix two misspells
Message-ID: <Z1nu50C6grj5th7e@casper.infradead.org>
References: <20241208035447.162465-2-xtex@envs.net>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241208035447.162465-2-xtex@envs.net>

On Sun, Dec 08, 2024 at 11:54:47AM +0800, Bingwu Zhang wrote:
> From: Bingwu Zhang <xtex@aosc.io>
> 
> This fixes two small misspells in the filesystems documentation.

There's a couple of similar ones if you want to submit some bonus
patches:

$ git grep sytem
Documentation/devicetree/bindings/sound/amlogic,axg-sound-card.yaml:      Base PLL clocks of audio susbsytem, used to configure base clock
Documentation/devicetree/bindings/sound/amlogic,gx-sound-card.yaml:      Base PLL clocks of audio susbsytem, used to configure base clock
Documentation/filesystems/iomap/operations.rst:    Races can also happen if the filesytem allows concurrent writes.
drivers/gpu/drm/xe/xe_bo.c: * On successful completion, the object memory will be moved to sytem memory.
fs/freevxfs/vxfs_super.c: * @fc:                        filesytem context
fs/ocfs2/sysfile.c:                      * return NULL here so that ocfs2_get_sytem_file_inodes
scripts/spelling.txt:sytem||system


