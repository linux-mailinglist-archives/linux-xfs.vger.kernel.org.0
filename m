Return-Path: <linux-xfs+bounces-18373-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3476FA1458E
	for <lists+linux-xfs@lfdr.de>; Fri, 17 Jan 2025 00:25:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 953A47A2506
	for <lists+linux-xfs@lfdr.de>; Thu, 16 Jan 2025 23:24:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65030232438;
	Thu, 16 Jan 2025 23:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WBStNmKM"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 206CC158520;
	Thu, 16 Jan 2025 23:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737069896; cv=none; b=QYNrwhnaX8XItF1O0N7gc6FWY5ancgzfXlpX62apxCFs7Tso2S6BcB+LM72D0kmq/Mth58kYszW1ZbN4WFy//JhT404FQvP2BQsmYqQ7X4PRaLuTO2YXmriQq73CKS/sJLuWcUO+pIsW2pEnWgsD/c4edwvLMQlh6th4BNZhqt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737069896; c=relaxed/simple;
	bh=hzePJna68kwsS8iSgk7DCf+cK++f5ojyD76UV4uJK0Y=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eEbOG/BfAHqhI88Vfv3x4nqSRjCjiXhv/7TP2QJTd/4kbaWUk2bb3q+miQNKrb9gh8T42hakvqIOgc+mC1EnDwpCb8fHprFobDZnZLcr5kEiRcSDfQccLrmv0sZgE9MH2fiDTVdTeBBlxj8+nb1B2HG8ZpM8gKQHy3vTb/NLZjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WBStNmKM; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4393C4CED6;
	Thu, 16 Jan 2025 23:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737069895;
	bh=hzePJna68kwsS8iSgk7DCf+cK++f5ojyD76UV4uJK0Y=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=WBStNmKMg/PDrUbiAOtcNuKxFUPK/V6yo2rhNcKvQhLlj+PwXCKHHdJf/SudNyFDx
	 PLIJ1LV39xnIYQGTbe0R7wAusD0vjrD+A7iUlXoNEsrA1J/1a4akwqhKhzlS0C992r
	 kvPQkElIeqY6MSul2G2Bm+TcLhRi8Y8cREDoeuxw1DVe04xfpy49ENpIANpbbLXxXP
	 LQ7vDK9kloL6gecL2xd1kC/EV+AgD3dG7KXmyNl0Cu9dKsbxrdc0vyYwj5+iy5XWxG
	 q2ZXrqHp/kPm+LkdD7iIv8iFlNCwRyRqFDrAn7yXSSKPrqjoLF9SQJ0X4AahvLbBzY
	 pvcw/u2QlVeNw==
Date: Thu, 16 Jan 2025 15:24:55 -0800
Subject: [PATCHSET v6.2 6/7] fstests: store quota files in the metadir
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173706976640.1929311.7118885570179440699.stgit@frogsfrogsfrogs>
In-Reply-To: <20250116232151.GH3557695@frogsfrogsfrogs>
References: <20250116232151.GH3557695@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Store the quota files in the metadata directory tree instead of the superblock.
Since we're introducing a new incompat feature flag, let's also make the mount
process bring up quotas in whatever state they were when the filesystem was
last unmounted, instead of requiring sysadmins to remember that themselves.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=metadir-quotas

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=metadir-quotas

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=metadir-quotas
---
Commits in this patchset:
 * xfs: update tests for quota files in the metadir
 * xfs: test persistent quota flags
 * xfs: fix quota detection in fuzz tests
 * xfs: fix tests for persistent qflags
---
 common/quota              |    1 
 common/rc                 |    1 
 common/xfs                |   21 ++++++
 tests/generic/563         |    8 ++
 tests/xfs/007             |    2 -
 tests/xfs/096             |    1 
 tests/xfs/096.out         |    2 -
 tests/xfs/106             |    2 -
 tests/xfs/116             |   13 ++++
 tests/xfs/116.cfg         |    1 
 tests/xfs/116.out.default |    0 
 tests/xfs/116.out.metadir |    3 +
 tests/xfs/152             |    2 -
 tests/xfs/1891            |  128 +++++++++++++++++++++++++++++++++++++++
 tests/xfs/1891.out        |  147 +++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/263             |    1 
 tests/xfs/263.out         |    2 -
 tests/xfs/425             |    5 +-
 tests/xfs/426             |    5 +-
 tests/xfs/427             |    5 +-
 tests/xfs/428             |    5 +-
 tests/xfs/429             |    5 +-
 tests/xfs/430             |    5 +-
 tests/xfs/487             |    5 +-
 tests/xfs/488             |    5 +-
 tests/xfs/489             |    5 +-
 tests/xfs/779             |    5 +-
 tests/xfs/780             |    5 +-
 tests/xfs/781             |    5 +-
 29 files changed, 376 insertions(+), 19 deletions(-)
 create mode 100644 tests/xfs/116.cfg
 rename tests/xfs/{116.out => 116.out.default} (100%)
 create mode 100644 tests/xfs/116.out.metadir
 create mode 100755 tests/xfs/1891
 create mode 100644 tests/xfs/1891.out


