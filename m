Return-Path: <linux-xfs+bounces-8473-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 61E3E8CB8FC
	for <lists+linux-xfs@lfdr.de>; Wed, 22 May 2024 04:33:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 91C551C22970
	for <lists+linux-xfs@lfdr.de>; Wed, 22 May 2024 02:33:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEDE379D1;
	Wed, 22 May 2024 02:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ld+4Zd9D"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D92623BE
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 02:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716345222; cv=none; b=Fbeq5Yf/xYb+u5xoMMzMOckX2mX3H0bZFnXgDAg55wtsKapFtVKeCmnGswCZmUEZgGLyclWZ+718+BVyH8rzw4+WR1LdG1peLHZCyAWDXMLTdF1zRTWRs3eiGKWJeXUpIenUYFrurk9fEcEVvuwV2J0JTwLr4ux7PL2JOljnIeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716345222; c=relaxed/simple;
	bh=vas4Sa/XBJvAs8wRncuu51QGrgZl8ZOwHNrYadaa44o=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=oKo+UUKXA9nEQHZ8u7anPn8m0ABGZ5bpM6dIz4TEjsXGHazhrJfAfAs+nj+budpR8MwDhChKtU51rA+iccQXg1zVvfnG2J2TW/rUGLwcaHc/+udeizqX3Q1J/qahDrJKc1a8LjZNArT6eQTFTcUQBKTh+M4Y0EyZ9HxaeYcNL/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ld+4Zd9D; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDF42C2BD11;
	Wed, 22 May 2024 02:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716345221;
	bh=vas4Sa/XBJvAs8wRncuu51QGrgZl8ZOwHNrYadaa44o=;
	h=Date:From:To:Cc:Subject:From;
	b=ld+4Zd9DmhZCXLqcOr0Xr4YjaXNpWU0uOeK8UYqp6/3Z86le6PWn3HCGHuK+ptXp1
	 7zoCGHy6auPpJiSDq0RX4npuuvkc/1rOjADrXx/k8xhSkuIiSbSSe62XIc50wbwkKQ
	 9/sNC0/YuU0X/bM/XCeBki1VXWTaE+hw5D3MmS+rZBDHRe4bsq/V5wu71bySMAcnt8
	 7rvHEBqfnmGEwRz7FemtP2hQ6rTl6Pgxh8YZyDY9wK7Ek5yOVq7xAkk8OKlDaJ2BS0
	 8V9HoNXO9EXI3b1iPPSo2fna2UoJweovqGSlWL1r3K2QttGyc9Wl88CMxv4yMRJ54Q
	 XbmvWmxYCBTOg==
Date: Tue, 21 May 2024 19:33:41 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>
Subject: [PATCHBOMB] xfsprogs: catch us up to 6.9
Message-ID: <20240522023341.GB25546@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Carlos,

This patchbomb contains all the patches that I have prepared for
xfsprogs 6.9; it has been rebased against last Friday's 6.8 release.
The entire patchbomb has been reviewed EXCEPT:

[PATCHSET v30.3 02/10] libxfs: sync with 6.9
  [PATCH 090/111] libxfs: partition memfd files to avoid using too many

This patch drew some comments in an earlier posting.  I revised the
patch and its commit message and resent it, but nobody has replied.
I can send pull requests for all 10 patchsets and 138 patches once this
review completes, or per your instruction.

--D

