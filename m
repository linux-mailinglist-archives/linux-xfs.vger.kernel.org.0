Return-Path: <linux-xfs+bounces-1906-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 09211821066
	for <lists+linux-xfs@lfdr.de>; Mon,  1 Jan 2024 00:01:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4B2FF1C21B76
	for <lists+linux-xfs@lfdr.de>; Sun, 31 Dec 2023 23:01:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74D57C2C0;
	Sun, 31 Dec 2023 23:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cz6l8Aol"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40DD7C127
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:00:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAE24C433C8;
	Sun, 31 Dec 2023 23:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704063656;
	bh=FfrCLFJa6ALaVXkisSKixa5IlJR7IXXSAf5Y9rGJhDk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=cz6l8AolNF9ko+HZY8AIaeW6b9Tqh6prw3VQ4FCvQsBfBQcSs8FxXSI1RRi7IGmQ4
	 ATQA/NNF8xt0cEygT1oqjLMc9gas/WXY+O5uCzDhQcOlJwFtvr+iEpcTlIlzjD0p9A
	 5UJEE2zt4RPvscmmsxMnG8r8u41ePijAI1MsWLKfjhms//HUdsMQQqhyAqzgqsyWG2
	 ZEwYEXF3fe97R+S8sN9BiVmUXcJLEKzBj0PfI62/tWzpMvMf/lVuKszblcT02/uL4P
	 4pI9SbRaNIqEpOVI8YAzd8W2InYc+0+znimT0+SdVY5ACxk9Mt7ndNWSCUkXYxKTa1
	 VKtW70hKf7WzA==
Date: Sun, 31 Dec 2023 15:00:56 -0800
Subject: [PATCH 3/3] debian: enable xfs_scrub systemd services by default
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405003752.1801869.16508218005203672874.stgit@frogsfrogsfrogs>
In-Reply-To: <170405003711.1801869.9864337837460047947.stgit@frogsfrogsfrogs>
References: <170405003711.1801869.9864337837460047947.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Now that we're finished building online fsck, enable the background
services by default.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 debian/rules |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/debian/rules b/debian/rules
index 97fbbbfa1ab..c040b460c44 100755
--- a/debian/rules
+++ b/debian/rules
@@ -109,7 +109,7 @@ binary-arch: checkroot built
 	dh_compress
 	dh_fixperms
 	dh_makeshlibs
-	dh_installsystemd -p xfsprogs --no-enable --no-start --no-restart-after-upgrade --no-stop-on-upgrade
+	dh_installsystemd -p xfsprogs
 	dh_installdeb
 	dh_shlibdeps
 	dh_gencontrol


