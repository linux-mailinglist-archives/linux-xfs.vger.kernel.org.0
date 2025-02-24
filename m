Return-Path: <linux-xfs+bounces-20116-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D1284A42C5A
	for <lists+linux-xfs@lfdr.de>; Mon, 24 Feb 2025 20:09:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 80E2D3AFCE6
	for <lists+linux-xfs@lfdr.de>; Mon, 24 Feb 2025 19:07:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DA8C1E5B82;
	Mon, 24 Feb 2025 19:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BqswBGmC"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E75916CD1D
	for <linux-xfs@vger.kernel.org>; Mon, 24 Feb 2025 19:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740424042; cv=none; b=fjzUa6i7xrz31983+cn/MX16Wy6kSLkbaY4K3TMH/mufeY39YrnUriI01dnd0LniPLDjs4Lk22RALXhkpWsNZtyGbS18Wa1d6hZMkkYW+zQkw974qMPq8nbbM6LcWUOsA45RtQ09BXKoOpEKN8sCPUxaD2COBeXmZx9iVId3YNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740424042; c=relaxed/simple;
	bh=xTTAr9GXAfynynYzcgjpSuJLzorii5bcd4ZGKkJeiNE=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=K9fGEC/SCRaWCPqfDbLAQYAKVHwFiuY3eIgEs8dtMX+3yt4Z81QJfGVO00qFrRJ1Sc2q8Z77AHEzHgJvbIAHWXQaZPXBxd7nBhVGnkTnkA9eKFe16TPV4PciWn8zDDKUhWJsb3GBsvPnCeVnO2ceuDPTdSNswcVlQuFB/wDj6sM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BqswBGmC; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87884C4CED6;
	Mon, 24 Feb 2025 19:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740424041;
	bh=xTTAr9GXAfynynYzcgjpSuJLzorii5bcd4ZGKkJeiNE=;
	h=Date:Subject:From:To:Cc:From;
	b=BqswBGmCAn0DvJMCxuvpkzn3S2yNnBvOCiIN7tWpvJjf2QlOJqDANXVtfxgdKW68s
	 x21N0i/QIdQU1GwPS+51bYGGKxqoXWH0yGd457AoNFKMm5sganZKosI5OtpEtn8bfD
	 sTyRSfBfR0zcm1XajRqxfZAALy1BT9NbaLnvuIQlNX9QMHA3qygc1C9dO02vQtfD3F
	 PwSx8RZgiH3VWuj6QwNlD9CqDvWjdglqg8gN3d2yD5r1UzXmPVwApfZRRAkQF1kxcu
	 1Ysag1tCY7S4CzVzdfnrIL/K38foBvNGiW3gsRY9PKlfWVeMhl2O4EBspD9dEDvJda
	 0pzdebV+16zaQ==
Date: Mon, 24 Feb 2025 11:07:20 -0800
Subject: [PATCHSET] xfsprogs: handle emoji filenames better
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <174042401261.1205942.2400336290900827299.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Ted told me about some bugs that the ext4 Unicode casefolding code has
suffered over the past year -- they tried stripping out zero width
joiner (ZWJ) codepoints to try to eliminate casefolded lookup comparison
issues, but doing so corrupts compound emoji handling in filenames.

XFS of course persists names with byte accuracy (aka it doesn't do
casefolding or normalization) so it's not affected by those problems.
However, xfs_scrub has the ability to warn about confusing names and
other utf8 shenanigans so I decided to expand fstests.

I wired up Ted's confusing names into generic/453 in fstests and it
promptly crashed when trying to warn about filenames that consist
entirely of compound emoji (e.g. heart + zwj + bandaid render as a heart
with a bandaid over it).  So there's a patch to fix that buffer
overflow.  There's a second patch to avoid complaining about ZWJ unless
it results in confusing names in the same namespace.  The third patch
fixes a minor reporting problem when parent pointers are enabled.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-emoji-fixes
---
Commits in this patchset:
 * xfs_scrub: fix buffer overflow in string_escape
 * xfs_scrub: don't warn about zero width joiner control characters
 * xfs_scrub: use the display mountpoint for reporting file corruptions
---
 scrub/common.c   |   52 ++++++++++++++++++++++++++++++++++++++++++++++++++--
 scrub/unicrash.c |   10 ++++++++--
 2 files changed, 58 insertions(+), 4 deletions(-)


