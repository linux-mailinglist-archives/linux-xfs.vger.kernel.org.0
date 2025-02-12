Return-Path: <linux-xfs+bounces-19466-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 60403A31CF4
	for <lists+linux-xfs@lfdr.de>; Wed, 12 Feb 2025 04:39:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DF7183A6AB9
	for <lists+linux-xfs@lfdr.de>; Wed, 12 Feb 2025 03:39:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E81A31D86E8;
	Wed, 12 Feb 2025 03:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="grr7gBAz"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4430271839;
	Wed, 12 Feb 2025 03:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739331541; cv=none; b=fb0cGkFDe9m/AH/k4vXVhoBYf3dN7CRal7xahlqfZoOBY2nuxSoTV3jHBZEOelNq7yMQ8T+TqMlcczVLtBxGjJx15jCrIj+vvpLIhbArXuXBuPN02SyC3FYgd/s77tJUIPN6gCXw7B1azL6QxcpNwsI8zguLdkvOjwWbhUPjTyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739331541; c=relaxed/simple;
	bh=RL6FioP+uYWr7OQkW6jY+H2nPZnogWHf+FxOF0UrEJY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SEEm9Ntt2hpOfiy/K/pZDLvxXdtxj1UPW3GpK5RAxU469zO/VKzHuXEc7FNtSvB3LJOXLZuykC3V7UayHgil6pfm5p4itu6pUZyNekJ1p4spcv73cxPQU8Aoec1S2rQfVBBL2CxmJL3EP7Q/ke2VFcTY0TehlBkAawbeBoPlsVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=grr7gBAz; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FD8AC4CEDF;
	Wed, 12 Feb 2025 03:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739331541;
	bh=RL6FioP+uYWr7OQkW6jY+H2nPZnogWHf+FxOF0UrEJY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=grr7gBAzQ0hHZ0oB+5YH8/vX9dAl+V9rFysLO2Chjw9o6QwMrT6rcMV7S+RoUXrpj
	 9+vBQ8FnmqTeB49sR5/IcyhbEVMlFenJgvlyl2U7MeJV5plxB/K6bD8+oZUeJpuUKt
	 PZwTbZmdBme1vqlFzdPOYNvpn9d/biHTPjY6v1M6PUtU/vBmBJf2yC41uH+UhbGs+i
	 gjOmTq3RgrGRdKMnNGfpcZyctezb2JX0zrcqxByiVkKakZTUDLITiyhCwYJP2poZCN
	 9wkQm/RwOOpWlwMxvbpazclGL6si3ZZY50E4LUnnnUcrLWFoO9Grkz7bfwTUKTAwi4
	 Yks+KMqwyZW2Q==
Date: Tue, 11 Feb 2025 19:39:01 -0800
Subject: [PATCH 32/34] common/config: add $here to FSSTRESS_PROG
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: dchinner@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173933094844.1758477.496172113293722060.stgit@frogsfrogsfrogs>
In-Reply-To: <173933094308.1758477.194807226568567866.stgit@frogsfrogsfrogs>
References: <173933094308.1758477.194807226568567866.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

In general we're supposed to specify full paths to fstests binaries with
$here so that subtests can change the current working directory without
issues.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 common/config |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/common/config b/common/config
index 77f3fc153eb731..ae9aa3f4b0b8fc 100644
--- a/common/config
+++ b/common/config
@@ -128,7 +128,7 @@ export MOUNT_PROG="$(type -P mount)"
 export UMOUNT_PROG="$(type -P umount)"
 [ "$UMOUNT_PROG" = "" ] && _fatal "umount not found"
 
-export FSSTRESS_PROG="./ltp/fsstress"
+export FSSTRESS_PROG="$here/ltp/fsstress"
 [ ! -x $FSSTRESS_PROG ] && _fatal "fsstress not found or executable"
 
 export PERL_PROG="$(type -P perl)"


