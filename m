Return-Path: <linux-xfs+bounces-2331-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 91638821279
	for <lists+linux-xfs@lfdr.de>; Mon,  1 Jan 2024 01:51:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A55821C21CC4
	for <lists+linux-xfs@lfdr.de>; Mon,  1 Jan 2024 00:51:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A36FC80D;
	Mon,  1 Jan 2024 00:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="juZspp4F"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CDD37F9;
	Mon,  1 Jan 2024 00:50:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D7B5C433C7;
	Mon,  1 Jan 2024 00:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704070257;
	bh=zWcZvK5otpvmqwZPIb6vjxtYz/oRQJU1IbLgCJ+PSUg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=juZspp4FyEFBXsU0bHmBcJyNb23zIOU+B3nAhIzHLohqo0fF4o4HTS0VrRbqW2pPS
	 woxIpvNZtwLn+D21kruflOUe05bfWJm9VjlpTOgwkPMe6h7k1T95Xus03TDiLGS8Tq
	 4Zl9MZPFGjSDvrTPhr1Ry24NBIJHbrfDJEZb3tFDIWLN21yxoVaz02xxLr20IQMBQh
	 tdODUtuFb2mpYFbDdGKwzISjjbMc+8K1ilt5iAIdtLARcCLbf/Vgd0YIB7//L1+3Gp
	 VVb9yLzXQXx9b0wJQ203wVJ7bfz3cR3nyANmE4emRBH2aFQwoX0vqazAWMs5mCpiUV
	 FpMC9JziXeiig==
Date: Sun, 31 Dec 2023 16:50:56 +9900
Subject: [PATCH 04/11] common/repair: patch up repair sb inode value
 complaints
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: guan@eryu.me, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <170405029902.1826032.4276950154935936731.stgit@frogsfrogsfrogs>
In-Reply-To: <170405029843.1826032.12205800164831698648.stgit@frogsfrogsfrogs>
References: <170405029843.1826032.12205800164831698648.stgit@frogsfrogsfrogs>
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

Now that we've refactored xfs_repair to be more consistent in how it
reports unexpected superblock inode pointer values, we have to fix up
the fstests repair filters to emulate the old golden output.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/repair |    4 ++++
 1 file changed, 4 insertions(+)


diff --git a/common/repair b/common/repair
index 8945d0028c..c3afcfb3e6 100644
--- a/common/repair
+++ b/common/repair
@@ -28,6 +28,10 @@ _filter_repair()
 	perl -ne '
 # for sb
 /- agno = / && next;	# remove each AG line (variable number)
+s/realtime bitmap inode pointer/realtime bitmap ino pointer/;
+s/sb realtime bitmap inode value/sb realtime bitmap inode/;
+s/realtime summary inode pointer/realtime summary ino pointer/;
+s/sb realtime summary inode value/sb realtime summary inode/;
 s/(pointer to) (\d+)/\1 INO/;
 # Changed inode output in 5.5.0
 s/sb root inode value /sb root inode /;


