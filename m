Return-Path: <linux-xfs+bounces-4107-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A0BBE862177
	for <lists+linux-xfs@lfdr.de>; Sat, 24 Feb 2024 02:09:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3A2A71F24404
	for <lists+linux-xfs@lfdr.de>; Sat, 24 Feb 2024 01:09:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCB044416;
	Sat, 24 Feb 2024 01:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IsU/NJjR"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F20417FE;
	Sat, 24 Feb 2024 01:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708736928; cv=none; b=pUfI28oQNAUYgB5ydEh/bYc1wsmOXSLPuMEPIDHPEH99klcliugZOHgXYLuwuluSx1fRj/vX3/gZBVNugtocoyuQjP2Ns6FY3fCGYzVqUp5SHjHDAp/yNkhEtwYRgXnfKL5fWXlJggfFBUdeRtwUkW/Tj1wfizwBrQHY7/U97Yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708736928; c=relaxed/simple;
	bh=t9V5kxYGwm3sv9nKxOBv3qZ/E3QJVhqTaxQJMIIzN5E=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Wd+YMNtVoAK/gorG6gfMenJJRIIFsM8AOAJAzWTwiqclzHL5S0vrj4MQX3r2IwsVR7IbaT1CZeqh/dodpwZZ+OAm58xHwBkbAFpFH+QIc+e6MFGK+S1HWsTwxcrlIxFDLx5YFpY/oeE2xRuHDzxKLz5hBXpupwRa0w/KAkRIAdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IsU/NJjR; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02CA5C433C7;
	Sat, 24 Feb 2024 01:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708736928;
	bh=t9V5kxYGwm3sv9nKxOBv3qZ/E3QJVhqTaxQJMIIzN5E=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=IsU/NJjRd9GLzt/RghDW/HlovoMRwVjWQztgQTA2xmUvUE0922OXjcKOyOcQRqc+S
	 7oA5ypFQBQbY+yK0KRuFdoMFMpoN08DJ8X61GTBG9yMn0sFGEFS+oNYufmOyrmH7M3
	 UgNmfbD5wcQD8p+DXN+JJvv+IzfvT+rHDOYkZaSc5SysA4Y1RD/9OqyI9LMSVO0EwJ
	 DJzOL/T1TZZh6ZyycX4FNea6PC8yeBZ7jgMfrfTb6h2RiDE5DI/QPGwImVvj+w2+tk
	 mztu+zCN5g5EIFpaD+a/Ir/dNpGcX9LwlREOQy0H7lYFpx7k2plZwa7v/qTcRs3JXH
	 o44+8uZLRGstA==
Date: Fri, 23 Feb 2024 17:08:47 -0800
Subject: [PATCHSET 5/6] thread_with_file: cleanups and fixes
From: "Darrick J. Wong" <djwong@kernel.org>
To: akpm@linux-foundation.org, daniel@gluo.nz, kent.overstreet@linux.dev,
 djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-bcachefs@vger.kernel.org,
 linux-kernel@vger.kernel.org
Message-ID: <170873669390.1861696.14195299906744951144.stgit@frogsfrogsfrogs>
In-Reply-To: <20240224010017.GM6226@frogsfrogsfrogs>
References: <20240224010017.GM6226@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

This series fixes some problems with the thread_with_file code -- namely
that blocking stdout writes attempt a non-atomic memory allocation while
holding a spinlock.  It also cleans up the ops handling so that we can
support ioctls on the thread_with_file itself.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=twf-cleanups
---
Commits in this patchset:
 * thread_with_file: allow creation of readonly files
 * thread_with_file: fix various printf problems
 * thread_with_file: create ops structure for thread_with_stdio
 * thread_with_file: allow ioctls against these files
 * thread_with_file: Fix missing va_end()
---
 fs/bcachefs/chardev.c            |   18 ++++--
 include/linux/thread_with_file.h |   20 +++++--
 lib/thread_with_file.c           |  113 ++++++++++++++++++++++++++++++--------
 3 files changed, 115 insertions(+), 36 deletions(-)


