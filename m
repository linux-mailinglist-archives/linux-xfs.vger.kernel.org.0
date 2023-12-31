Return-Path: <linux-xfs+bounces-1213-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BD38B820D32
	for <lists+linux-xfs@lfdr.de>; Sun, 31 Dec 2023 21:00:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5CA661F21F28
	for <lists+linux-xfs@lfdr.de>; Sun, 31 Dec 2023 20:00:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8FF7BA37;
	Sun, 31 Dec 2023 20:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O6UhDdP0"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80BA2BA22;
	Sun, 31 Dec 2023 20:00:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0604DC433C8;
	Sun, 31 Dec 2023 20:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704052833;
	bh=gvp1IkUBKQuOSKAsO8+1pNf5tkwopgTXz3/Z8MAfCiA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=O6UhDdP0yGwXl+ablASnvsO40w5k3XkYff/W+7zisP1XmEJ+NCVuw1dS9hjffvSmY
	 m94kDrofJtdHaUEfVJwUFmG+8V5O7akt9u5q6iAYs3cUgMvEetFnn6TE1pgTMc6r4y
	 f9z2Fl0W79/j98PT+KUNEE7c7XeLdK5YdiQg8vwFGUAZrI16lcZCyqVozL3Qhbwsln
	 DAMKu4c4uBal1WxPWsYkNkJQzo/EzQqOUkLqkWlq8g2bQiDT0D0qiZezhocUDuIQt6
	 uHBI1Acxohh38ET4lmETdKR/ONrX0NL00kHfGUG3ewp8p/2Ynjq7NKWHXFV/c9Y1pw
	 itndZiXDVC0WA==
Date: Sun, 31 Dec 2023 12:00:32 -0800
Subject: [PATCHSET v2.0 3/9] fstests: enable FITRIM for the realtime section
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: guan@eryu.me, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <170405030868.1826812.10067703094837693199.stgit@frogsfrogsfrogs>
In-Reply-To: <20231231182323.GU361584@frogsfrogsfrogs>
References: <20231231182323.GU361584@frogsfrogsfrogs>
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

One thing that's been missing for a long time is the ability to tell
underlying storage that it can unmap the unused space on the realtime
device.  This short series exposes this functionality through FITRIM.
Callers that want ranged FITRIM should be aware that the realtime space
exists in the offset range after the data device.  However, it is
anticipated that most callers pass in offset=0 len=-1ULL and will not
notice or care.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=realtime-discard

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=realtime-discard
---
 common/xfs    |   46 ++++++++++++++++++++++++++++++++++++++++++++--
 tests/xfs/176 |    4 ++--
 tests/xfs/187 |    6 +++---
 tests/xfs/541 |    6 ++----
 4 files changed, 51 insertions(+), 11 deletions(-)


