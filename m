Return-Path: <linux-xfs+bounces-22645-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 914AEABFFCF
	for <lists+linux-xfs@lfdr.de>; Thu, 22 May 2025 00:41:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E10F91BC14DE
	for <lists+linux-xfs@lfdr.de>; Wed, 21 May 2025 22:41:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D68B239E9B;
	Wed, 21 May 2025 22:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="guoYyZz0"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48E5D1754B;
	Wed, 21 May 2025 22:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747867260; cv=none; b=gYPVM04+0IazxuPLsjEl+Q4cGli+Nl0kTt0hewIlYGufV5OMFiVxU2o7KuRfbb/dQkjNoTPCtuXAAgzQVy6rA+c/UEtSqtyAj1p5CyuqwOeS1oA3nSiRRIbuO3xaPcbvDNCgjGxM8BxHrhuC43NPwjH8cikb2TCf9NNw6lmpug0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747867260; c=relaxed/simple;
	bh=XR0P1B8yBVgx8yZieSRe58DRxnqLDxKrV4mE4bGspqA=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=l2NKJ4QpFvF1qE1bRm3cY90UI9bQrnXP4Acnq0wS9NC5tuIehwzvzSIRHRk6xu1jU20Ckgb7Q928GETpb53RRnVbYNO/9kWUWw4zhtO4UTFfFMlTuBqcOngMZEA4VX98bnOvu8Lfgq9C1AACoG9ll73wKzbVR2NNX+dA29DcvHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=guoYyZz0; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF75BC4CEE4;
	Wed, 21 May 2025 22:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747867259;
	bh=XR0P1B8yBVgx8yZieSRe58DRxnqLDxKrV4mE4bGspqA=;
	h=Date:Subject:From:To:Cc:From;
	b=guoYyZz0IeptXLqFfjUwdNSVh+P8/6bWwaSsGqq36arbIbwI32dssA5vPDmSchcud
	 eflzyYbhkt6FqCn8WnTRzFKszjadGypKJY4TPOwEwfalGD+iF/3GAgvNA2nPwouCji
	 mJmn/A0ZLSaAENZNNTDoQw09OQKw6YY/vU2WyqC8exnIWeyMSsMNnPL0JgN7Ag8t4M
	 CKRGL/2jQHkFzAaCAgQbEBLdOslYgEfj/DYmhD8XcnWtD/Tq4AoxHUYiN3H17CMXro
	 jknWAxVqPURtjWjqMYAov5mPsJ3Dt/YzhA83Y+T1bdgCD/dNxRLRXpMhcx5gcZhYs+
	 7LmOdKHkIfT9w==
Date: Wed, 21 May 2025 15:40:59 -0700
Subject: [PATCHSET 2/2] fstests: more random fixes for v2025.05.11
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: fstests@vger.kernel.org, fstests@vger.kernel.org,
 linux-xfs@vger.kernel.org
Message-ID: <174786719678.1398933.16005683028409620583.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Here's the usual odd fixes for fstests.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=random-fixes

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=random-fixes

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=random-fixes
---
Commits in this patchset:
 * generic/251: fix infinite looping if fstrim_loop configuration fails
 * generic/251: skip this test if fstrim geometry detection fails
 * check: unbreak iam
 * check: check and fix the test filesystem after failed tests
---
 check             |    9 +++++++--
 tests/generic/251 |   29 +++++++++++++++++------------
 2 files changed, 24 insertions(+), 14 deletions(-)


