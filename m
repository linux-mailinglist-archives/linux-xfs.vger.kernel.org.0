Return-Path: <linux-xfs+bounces-10884-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 96F6D940207
	for <lists+linux-xfs@lfdr.de>; Tue, 30 Jul 2024 02:22:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4F62F282C8B
	for <lists+linux-xfs@lfdr.de>; Tue, 30 Jul 2024 00:22:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1539E256E;
	Tue, 30 Jul 2024 00:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V0XGSs9Z"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C835F23C9
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722298948; cv=none; b=T0CMflRYXoJu90ZxtHhzpFgUVoX2h9IF1WnTBX/jiJSRB68TskkSfQ4Ya6Sbta4n8Y8AZhGwNsc28n3OUZVdPARMWI0icHmTKpfDlvdU/A7Ff9fqWyg6OBmzT+yIDm2a8G4VPK3fJes9mDyl5xFj4wP9+B9Jzw+awlF1HlRuZLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722298948; c=relaxed/simple;
	bh=p3tc0zvTT4/Nf+w+ll92c7Ygrnz8MIYA+zoUfKjEdbg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DYF6314mYqf1cLiKjoO7LgWkBbYnCsU16UbutlL+KKzco9cAM8+pW2hSR6NWD5KhJgLAQ6YEjdVjl1uKiXfGb6IZ2o33nnr/Q5tSXxgy9Q9EtJb8UQcvODkOwarvvuQOol2kxkS2O+2RMTs8XPKqFVcUMh5DPo7UTGiXyk6uUxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V0XGSs9Z; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9556CC32786;
	Tue, 30 Jul 2024 00:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722298948;
	bh=p3tc0zvTT4/Nf+w+ll92c7Ygrnz8MIYA+zoUfKjEdbg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=V0XGSs9ZlajO7wWIA9EneNV0/P1PYn/X41K0f1JNPi4j4xEOB0XBm5MK0x+9n/6xf
	 rOZPeM7CzdCBkWQN405YnM80dDgHSR6ynhE26xwkvgTf2BN1P9NT1YfGNJJsgTR9/2
	 0T5CWyeaqX2bgOjGH8C+zqucgzCK03VKsP5oe6uaqr/6k/Qnozu3lMQsysfzTWkGir
	 SyjBNbCazIOyFWx4Jr2wKiG4/zx+syazoVQZ4x5st1wG0G0fJ8qKHeRG5Frfk5SvqB
	 dQTYhx2qwOjPjsjqbtS9K0GuEijzEGcIPT4QPZHkVOeGoGiMQEnPvPRTlVhnhGPG9c
	 fT1e7x9ghHGLw==
Date: Mon, 29 Jul 2024 17:22:28 -0700
Subject: [PATCHSET v30.9 23/23] xfs_repair: fixes for kernel 6.10
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229852800.1353623.6368136045506828951.stgit@frogsfrogsfrogs>
In-Reply-To: <20240730001021.GD6352@frogsfrogsfrogs>
References: <20240730001021.GD6352@frogsfrogsfrogs>
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

Fix some incorrect validation problems in xfs_repair.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-fixes-6.10

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-fixes-6.10
---
Commits in this patchset:
 * xfs_repair: allow symlinks with short remote targets
---
 repair/dinode.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)


