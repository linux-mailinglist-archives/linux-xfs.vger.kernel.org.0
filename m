Return-Path: <linux-xfs+bounces-6773-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E8FF68A5F2D
	for <lists+linux-xfs@lfdr.de>; Tue, 16 Apr 2024 02:24:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2FE241C20C79
	for <lists+linux-xfs@lfdr.de>; Tue, 16 Apr 2024 00:24:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61F901849;
	Tue, 16 Apr 2024 00:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X0ptDEK8"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 221AD17F0
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 00:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713227068; cv=none; b=Muq9r3R/sLHhKL5dP7qrPDVG8eM76kmVDe8A2z5zw10XRhHQvMFUnKrxDvuP0HIZytQrWrgndHo8hPI0wBMgspV7+J3CfnHLHZhjnVd5bm6CDx4JcjCLqmNjxU5AmICuxDiOQbrFA2TmKxbYF+3pgweiSkol7tZOCFHnBBlYXAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713227068; c=relaxed/simple;
	bh=8OC1gd1eahvDHfbQHp0f/FnOOo9Iwgr1764gxVIeRpc=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=mRSzR2efCUBtnUmFBhjhlB4EZ6tUZf0uogZ9BDDtqWUGKJM2//K9xmMJXSnkRnEIACqsIWb/QM8mxd2lNrIKkddzsZMyUfof+jfBb8u2Q7I6onnLtNowtP9BQ33M6PjsPROvG7GMEWHgLyvXpZzZG2kxNrPXK2ZWcCQVwKoe1QA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X0ptDEK8; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3499C113CC;
	Tue, 16 Apr 2024 00:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713227068;
	bh=8OC1gd1eahvDHfbQHp0f/FnOOo9Iwgr1764gxVIeRpc=;
	h=Date:From:To:Cc:Subject:From;
	b=X0ptDEK8GQw3hKS2ni1tXuECQdChi4PKfLoyqN5IXAeUM/+Wsmbbc49mdx63IKUlR
	 1k03UDGXk/ddeOhcxuGVGc+nVOG9ATdJwtTV5zBtyBffsNJx+Nq9/2RxSzDONqifUk
	 V8AolApuL3Tzsw3FSmwR4sgidCGUy88ka2FaQ+uSLr1Q84mPZnUYVqmlDGrCPpe+A/
	 AZ5lBgdtzySm/QLpqORwbdKgNI8iGf62KGv9ncdKgGovlxETD7avZnTZaeJFvkxVwQ
	 C9CbEKiTzy/TvqnBIVsBC2h0HZNP+QFSzE/h/zyOMNnNa3aMkr+ksrVSsRgzMXxLaJ
	 j7cQsHoQudZOw==
Date: Mon, 15 Apr 2024 17:24:27 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Chandan Babu R <chandanbabu@kernel.org>
Cc: xfs <linux-xfs@vger.kernel.org>
Subject: [GIT PULLBOMB v30.3] xfs: online repair, part 1 is done
Message-ID: <20240416002427.GB11972@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Chandan,

Please accept these pull requests for all the fully reviewed patchsets
that I have in my development tree.  The first fourteen pulls will
complete online repair part 1; the last two are from the parent pointers
patchset, which is part 2.  I will be resending the unfinished patchsets
of part 2 later on to try to wrap up the last few patches that have not
completed review.

--D

