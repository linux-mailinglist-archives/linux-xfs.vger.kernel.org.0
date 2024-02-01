Return-Path: <linux-xfs+bounces-3299-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BE778846117
	for <lists+linux-xfs@lfdr.de>; Thu,  1 Feb 2024 20:39:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7803228BC29
	for <lists+linux-xfs@lfdr.de>; Thu,  1 Feb 2024 19:39:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E83D8526E;
	Thu,  1 Feb 2024 19:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AUXW2VGF"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE6B88527C
	for <linux-xfs@vger.kernel.org>; Thu,  1 Feb 2024 19:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706816368; cv=none; b=HGhFYynUPmzZscC4H3/WPiVjhsf3ZBgocb0SIsxUL4lt43bLZF3AD/v2Iln4nqrDV81RN++C8eRbZ9cdTsz/dxjb2lZHF4f9Gm9myXdhFrsgicJRUz2JfCSCTj1q21S1kNBk+ErAZZ30iL8Nc6utDPeaqWhUWcWByWxFXQ3oAVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706816368; c=relaxed/simple;
	bh=nscbBJ1nRkShQy17zC9IBYpapT0cFoz4UiL9sJrTBZo=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=O/21kFsv93Eu8YvbVeWxXPKUl6DV4PDFr6iwAhTXKlOsGRfh1iO6js6cY5/7dA5EXrgJ2yLhXPDsrQqM24f1L1Wj0swBGeuB0OjnkI51XfDbRRjd1KDcy6uZspVy0uYVSEXy9kCh9fK4YoJDeABOi3hE+B50v9fwBuHMPEUzo5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AUXW2VGF; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37848C433C7;
	Thu,  1 Feb 2024 19:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706816368;
	bh=nscbBJ1nRkShQy17zC9IBYpapT0cFoz4UiL9sJrTBZo=;
	h=Date:Subject:From:To:Cc:From;
	b=AUXW2VGFEBnnVihKncemIycMKneT8JX0MeFT1uyArO169dude9Ww9wBls7Oyu1phq
	 4RyZH54eFZwq5Lzn6NLgcE5cibvKK4VWAP+D5jIYqOWlM8CHIENN4h/rzezYPQC7lV
	 G0JgiNF3LLLWSW3Ud6X2vEZlv8g/m7lnokWuiDPpL19uhqr9YA19txUty4rQRoPGX3
	 OZNBlbdQOJrmGs+6M1blFerzqqaOqi5/4HWgZJndSbZovG8FeL5ryrePGadDr25SRE
	 zgnHkovf2NRClRiqz8810YvcJYZN8DdtFcUFVIBFrorHjsNVtVcWYbB4cEfH//WX7y
	 5ISCxg1kKHBtw==
Date: Thu, 01 Feb 2024 11:39:27 -0800
Subject: [PATCHSET v29.2 4/8] xfs: btree readahead cleanups
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170681336120.1608096.10255376163152255295.stgit@frogsfrogsfrogs>
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

Minor cleanups for the btree block readahead code.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=btree-readahead-cleanups

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=btree-readahead-cleanups
---
Commits in this patchset:
 * xfs: remove xfs_btree_reada_bufl
 * xfs: remove xfs_btree_reada_bufs
 * xfs: move and rename xfs_btree_read_bufl
 * xfs: split xfs_buf_rele for cached vs uncached buffers
---
 fs/xfs/libxfs/xfs_bmap.c  |   33 +++++++++++----
 fs/xfs/libxfs/xfs_btree.c |   98 +++++++--------------------------------------
 fs/xfs/libxfs/xfs_btree.h |   36 -----------------
 fs/xfs/xfs_buf.c          |   46 ++++++++++++++-------
 fs/xfs/xfs_iwalk.c        |    6 ++-
 5 files changed, 76 insertions(+), 143 deletions(-)


