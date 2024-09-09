Return-Path: <linux-xfs+bounces-12769-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 66A98971348
	for <lists+linux-xfs@lfdr.de>; Mon,  9 Sep 2024 11:21:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 919871C21CA1
	for <lists+linux-xfs@lfdr.de>; Mon,  9 Sep 2024 09:21:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABD8B1B4C5B;
	Mon,  9 Sep 2024 09:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c2FS0g9g"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 632951B2EF7;
	Mon,  9 Sep 2024 09:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725873568; cv=none; b=iMg2igITgGRij0c0QaEuXBdj4y2ALLen9JvAwHzzI1S/gXQxJFyrapaujo2QQHlom6xUiBAaBIQFO1lmhgrzxccTX7gb11gqWUtixwJkIqBm0SgvlpUQ4Sf9VMHk0kAmXf6Zkq2AaP7cM2K1Oi+rQ6q6ocqQCWbhreUCvRpHeKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725873568; c=relaxed/simple;
	bh=rBgDXl+sMJWoi4IlWZ39qit9bOpo+BZpvDPH4uJAQ7s=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=VLvQYAYzi1UCXHu3d/9rgpbdGQDl6MO6M1zd8slMnP8/ofBsATKzKJc6SZvza5neGcDMEZnBDpBOaqLEbVgg4z2sRjymE1+49iyRYP/UdECQmcK0uF3JBNJ9G/6cAdOMRm7s26qLTmmHhXT4CCiF0aDdSboLczZ/ks5m1z0xEg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c2FS0g9g; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A059BC4CEC6;
	Mon,  9 Sep 2024 09:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725873567;
	bh=rBgDXl+sMJWoi4IlWZ39qit9bOpo+BZpvDPH4uJAQ7s=;
	h=From:To:Cc:Subject:Date:From;
	b=c2FS0g9grPYFQgwMLOykf4g/B+AgeeVMM1o/Immn5DaXxkdaF4EN2cUTCEWfQWSQc
	 tLWmzmR+N9ExWyeW0ql6n52x1QUn7Y80/J/ahdRGFHts8kWttKJ0TGz72lJXn2JYJh
	 kv+1Hts82fA2jjS1I5qfzdZy9ozmYA9aTq+2vbbHnYhE0LvixezZIeCMcxnNg07g2/
	 N6139csqFHzFToypCJs8yxlAG8JSIk9oSJVcMOgOWV0QJW3oE1TXsx+UEOcrqbPWsV
	 OXBvWc/pFk83xVjn/GdwXELlRcrz2P/DzS9SJ/1pjS4y3Jkm1lpLRIZzRok/9tzrHM
	 Lh9kVOB5DJ0eg==
From: Arnd Bergmann <arnd@kernel.org>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Anthony Iliopoulos <ailiop@suse.com>,
	Lukas Bulwahn <lukas.bulwahn@gmail.com>,
	Kees Cook <kees@kernel.org>,
	Kent Overstreet <kent.overstreet@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Jan Kara <jack@suse.cz>,
	Amir Goldstein <amir73il@gmail.com>,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] xfs: add CONFIG_MMU dependency
Date: Mon,  9 Sep 2024 11:19:00 +0000
Message-Id: <20240909111922.249159-1-arnd@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

XFS no longer builds on kernels with MMU disabled:

arm-linux-gnueabi-ld: fs/xfs/xfs_file.o: in function `xfs_write_fault.constprop.0':
xfs_file.c:(.text.xfs_write_fault.constprop.0+0xc): undefined reference to `filemap_fsnotify_fault'

It's rather unlikely that anyone is using this combination,
so just add a Kconfig dependency.

Fixes: 436df5326f57 ("xfs: add pre-content fsnotify hook for write faults")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 fs/xfs/Kconfig    | 1 +
 lib/Kconfig.debug | 1 +
 2 files changed, 2 insertions(+)

diff --git a/fs/xfs/Kconfig b/fs/xfs/Kconfig
index fffd6fffdce0..1834932a512d 100644
--- a/fs/xfs/Kconfig
+++ b/fs/xfs/Kconfig
@@ -2,6 +2,7 @@
 config XFS_FS
 	tristate "XFS filesystem support"
 	depends on BLOCK
+	depends on MMU
 	select EXPORTFS
 	select LIBCRC32C
 	select FS_IOMAP
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 7c0546480078..8906e2cd1ed5 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -2862,6 +2862,7 @@ config TEST_KMOD
 	depends on NETDEVICES && NET_CORE && INET # for TUN
 	depends on BLOCK
 	depends on PAGE_SIZE_LESS_THAN_256KB # for BTRFS
+	depends on MMU # for XFS_FS
 	select TEST_LKM
 	select XFS_FS
 	select TUN
-- 
2.39.2


