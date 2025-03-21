Return-Path: <linux-xfs+bounces-21044-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2EDDDA6C519
	for <lists+linux-xfs@lfdr.de>; Fri, 21 Mar 2025 22:26:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 81D337AA3B6
	for <lists+linux-xfs@lfdr.de>; Fri, 21 Mar 2025 21:25:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46606230D0F;
	Fri, 21 Mar 2025 21:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q15KZOao"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01ADB1EF08D;
	Fri, 21 Mar 2025 21:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742592381; cv=none; b=KYXeslii+wKGA64xKObttvkPfo5GwB2+LWlMFS9L4ElK4uLjIH+LeDvu/MdCk5I+WoGPKBxl7CYAw5YKE2VJptikhQzJ/f499NYwlasKNH9fo+mGRelE+bKlKoanjQfMNJO50RlWjbyR+3DlAcWBoXK/EZzDSO1xhJhnzjTgUK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742592381; c=relaxed/simple;
	bh=628Yg7HRHNU8WEXTG1C7sESkvQBQqRCzYDJEJcwSULM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BuHODEIA/UnJJoQrO/YlI+MLT388G8iqC9J3Eb/TDZwiBaDOb9eQIW7M/V90mWCt0rV/20WWCHes2/WRNYFNT47eLh73ONLOtle5gy4DDmO3vZCfhkyZ5Bdg1I+SKTQqfjLJTo0DigAG8fPvEDOMfEwwoYDXtKwodo9H9vMVij0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q15KZOao; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D18CAC4CEE3;
	Fri, 21 Mar 2025 21:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742592380;
	bh=628Yg7HRHNU8WEXTG1C7sESkvQBQqRCzYDJEJcwSULM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=q15KZOao8Jr/c6IQOyw3aTHWVG+9AuO56HFVjx6bQRW3tH+dw+ndbIbMUKjhKwyj+
	 BkGNgNZOAMv2rO02e9yeSfKXrQOriGUZVeakK9W0cvKqMKh1rREJmfVddXP+qDl6PV
	 u9GoYVGl9Fxn1VzCpsI6rQTcOY0HGPP4+F55d/+fjtMuHOoKWIQGyefHpy/BRP0K3S
	 GJoiVn0YRjxE0B8NvYGAnPN/Br5Sij7KK/g5pGRfeWc/LEhzBr6XEZ2OfhvCweVFc6
	 mW/BEow75ddYJ5vwD/lK2QWegqAr4yaqaUc4xUJ/zsbWiitlye6eDz8tbvOwWzPpzS
	 qQzlAkl4RSPfA==
Date: Fri, 21 Mar 2025 14:26:20 -0700
Subject: [PATCHSET 1/3] fstests: test dumping fs directory trees
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <174259233514.743419.14108043386932063353.stgit@frogsfrogsfrogs>
In-Reply-To: <20250321212508.GH4001511@frogsfrogsfrogs>
References: <20250321212508.GH4001511@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Here's a functional test for recovering parts or entire filesystem
trees with xfs_db.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=rdump

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=rdump
---
Commits in this patchset:
 * xfs: test filesystem recovery with rdump
---
 tests/xfs/1895     |  153 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1895.out |    6 ++
 2 files changed, 159 insertions(+)
 create mode 100755 tests/xfs/1895
 create mode 100644 tests/xfs/1895.out


