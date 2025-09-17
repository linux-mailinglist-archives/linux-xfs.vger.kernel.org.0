Return-Path: <linux-xfs+bounces-25743-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0AE8CB7EAAA
	for <lists+linux-xfs@lfdr.de>; Wed, 17 Sep 2025 14:57:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DB33D3B05C9
	for <lists+linux-xfs@lfdr.de>; Wed, 17 Sep 2025 12:53:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 110A722D78A;
	Wed, 17 Sep 2025 12:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OFh8hl1E"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8857F37C0EB
	for <linux-xfs@vger.kernel.org>; Wed, 17 Sep 2025 12:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113464; cv=none; b=DLYuEqVSLvWj4G29gJstFtIV5XCTufD4sGOoKR+1BYIjGTPO39SwWzsGNDB0vmvwyOogdK1tT9hvufE+Gi01+44VuB5BMFzQGj72KhNXQzIBukd+F2mgw3MGI3H3itdV6Amt373QP8BgOJcfyfMHChGV/7x5P67siGzKJd73uTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113464; c=relaxed/simple;
	bh=T5htFBd2cyjbYlEXt2LzuFuMA0jah1HHmQy7O9LW9us=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jcME12pc0L943HTQQ10AoHhfe3CN7VtpFNKV0brkRsnveLMHzAFos2tTf2xwwQ8xCnQXDLmphUsalqelVkSjw6M71C26TcA0Ss/7D3+Gns6/WiwgY7u9fiA6zTZkKl1p442cUTG4cuCFrwB8dj2b8b/f9wd7XvghLbr32Oos03U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OFh8hl1E; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85361C4CEF0;
	Wed, 17 Sep 2025 12:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758113464;
	bh=T5htFBd2cyjbYlEXt2LzuFuMA0jah1HHmQy7O9LW9us=;
	h=From:To:Cc:Subject:Date:From;
	b=OFh8hl1EDy/7QSDDzldva8BCplpCoSWWKLk/H828xjnojDlyCf2rQWVkjc8L0KKjB
	 bkAfqL82b8Wc0uJWpsH3ZSB/u6lxSN/u92425R+MzXPlZVOt4I2JD/OknQg26h9MZx
	 KFlhHIRa118JFrUPoIgxs1Tnh+193O2lFgFxJY7z99SxnmQoKMrLHGp0KIzv7wGKMC
	 WTRi2a7Oy4+qBeWMRTn7Y37x/fWPE/ImvvasgrClVNSqgLsKGgxtIPN+aVL2isyLWF
	 wFo3HPNX0dwhEjvUNidOIVnRatx7+9xFSsWb1EOaRA8jbEo1o/ipoNU7v4fT3voSal
	 8igy7zyQNPL4Q==
From: Damien Le Moal <dlemoal@kernel.org>
To: Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 0/2] Some minor improvements for zoned mode
Date: Wed, 17 Sep 2025 21:48:00 +0900
Message-ID: <20250917124802.281686-1-dlemoal@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A couple of patches to improve a mount meaasge and to improve (reduce)
the default maximum number of open zones for large capacity regular
devices using the zoned allocatror.

Damien Le Moal (2):
  xfs: Improve zone statistics message
  xfs: Improve default maximum number of open zones

 fs/xfs/libxfs/xfs_zones.h | 7 +++++++
 fs/xfs/xfs_zone_alloc.c   | 4 ++--
 2 files changed, 9 insertions(+), 2 deletions(-)

-- 
2.51.0


