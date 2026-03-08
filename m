Return-Path: <linux-xfs+bounces-31981-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id T/G3Oce/rWnm6wEAu9opvQ
	(envelope-from <linux-xfs+bounces-31981-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Sun, 08 Mar 2026 19:28:23 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 831332319D9
	for <lists+linux-xfs@lfdr.de>; Sun, 08 Mar 2026 19:28:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 7041C3004601
	for <lists+linux-xfs@lfdr.de>; Sun,  8 Mar 2026 18:28:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A23439283D;
	Sun,  8 Mar 2026 18:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="NHiKk7zw"
X-Original-To: linux-xfs@vger.kernel.org
Received: from pdx-out-012.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-012.esa.us-west-2.outbound.mail-perimeter.amazon.com [35.162.73.231])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E1C933E348;
	Sun,  8 Mar 2026 18:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.162.73.231
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772994500; cv=none; b=RruAe8I/LlndbkXelZhmSijmbVVLlK8zcM6seHgg6bPTYDFaSKu/kFjiKgP/oYd2c5iuNLpYUn9sKN239F1fHXedLiFFLCiO4xAB+JcJVl54A++lcLupHDNAdE4mfs6bIl7Tq9tDrIA6Q6VBDnON0VJAIKLW2P0EPRSvLYFXXy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772994500; c=relaxed/simple;
	bh=lNOK5ANUL1LUa+yFrwVIJkyfZsEPkwqEKPpuD8jiIvQ=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=WyuPyKo1RsMzPJtXgM95VDTg1Mxu8l+2dgVd3WMbfId2K31hJuzH5jMv+YAsgu/OoUz2KoYjpFoVtbqmgG8BJS6H08EOIwFqAvfXOD46USScaQhQlJFnsBkwmLQrXT5+Lp5qxmmQNzzrUhRDQKpRdTjiKX7ZKOPeen024+0cu4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=NHiKk7zw; arc=none smtp.client-ip=35.162.73.231
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1772994499; x=1804530499;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Gn+wo5+/If5mRGgzlhNBLxY31rnAKWopReu868U7ckg=;
  b=NHiKk7zw4HzUumgtODz+/zGQ7wt4xgNu9QaXypLTk9It5h5RRaobVPit
   DjfQK/NV9lepaOEpAOQNgKRx3lfJcrHjV9M624aryIdG3LCY+DG9XrnzQ
   iSUUPruKNEThz9zQoY0meoToXMRfOWhWs8gnU3lnkKuq2NYTyN1jQmWWO
   logTXi5a7RslQ1/7tWooVlzhHDuk1UWXj0kpsSC6y5pualCKYBwkIL9Rw
   CPH8NY1kzaAZcw83kI0BUWhKVCUg1s5df+sb2KBFvPy9dMNSqwd6YS80K
   54qMcwCCpLiWEqOb925TM5PpyksOjbZbl8tBVZLjFp1EAONz8SDjUrfLo
   w==;
X-CSE-ConnectionGUID: GAxpbzcjRlWKW+AxKkyztQ==
X-CSE-MsgGUID: kXwUEIToS6a2OyWEVUjEsg==
X-IronPort-AV: E=Sophos;i="6.23,109,1770595200"; 
   d="scan'208";a="14379157"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-012.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2026 18:28:16 +0000
Received: from EX19MTAUWA001.ant.amazon.com [205.251.233.182:4089]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.34.39:2525] with esmtp (Farcaster)
 id 775eb367-3392-4f1d-be0e-cddd18b8ce91; Sun, 8 Mar 2026 18:28:16 +0000 (UTC)
X-Farcaster-Flow-ID: 775eb367-3392-4f1d-be0e-cddd18b8ce91
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.218) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Sun, 8 Mar 2026 18:28:15 +0000
Received: from c889f3b07a0a.amazon.com (10.106.82.18) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Sun, 8 Mar 2026 18:28:14 +0000
From: Yuto Ohnuki <ytohnuki@amazon.com>
To: Carlos Maiolino <cem@kernel.org>, Dave Chinner <dchinner@redhat.com>
CC: "Darrick J . Wong" <darrick.wong@oracle.com>, Brian Foster
	<bfoster@redhat.com>, <linux-xfs@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Yuto Ohnuki <ytohnuki@amazon.com>
Subject: [PATCH v3 0/4] xfs: fix AIL push use-after-free during shutdown
Date: Sun, 8 Mar 2026 18:28:05 +0000
Message-ID: <20260308182804.33127-6-ytohnuki@amazon.com>
X-Mailer: git-send-email 2.50.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D036UWB004.ant.amazon.com (10.13.139.170) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 831332319D9
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-8.16 / 15.00];
	WHITELIST_DMARC(-7.00)[amazon.com:D:+];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[amazon.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74];
	R_DKIM_ALLOW(-0.20)[amazon.com:s=amazoncorp2];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[amazon.com:+];
	TAGGED_FROM(0.00)[bounces-31981-lists,linux-xfs=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ytohnuki@amazon.com,linux-xfs@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	NEURAL_HAM(-0.00)[-0.982];
	TAGGED_RCPT(0.00)[linux-xfs];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Action: no action

When a filesystem is shut down, background inode reclaim and the xfsaild
can race to abort and free dirty inodes. Since commit 90c60e164012
("xfs: xfs_iflush() is no longer necessary"), xfs_inode_item_push() no
longer holds ILOCK_SHARED while flushing, removing the protection that
prevented the inode from being reclaimed during the flush.

This results in use-after-free when dereferencing log items after
iop_push() returns, or when reacquiring the AIL lock via lip->li_ailp.

This series fixes the issue by:
1. Reordering unmount to stop reclaim before pushing the AIL
2. Factoring the push loop into a helper for readability
3. Capturing log item fields before push callbacks for tracepoints
4. Saving the ailp pointer before dropping the AIL lock

Changes in v3:
- Split into 4 patches as suggested by Dave Chinner
- Moved UAF-unsafe point comments to after xfs_buf_relse()
- Passed ailp instead of dev to tracepoints
- Moved xfs_ail_push_class definition after xfs_log_item_class events
- Factored xfsaild_push() loop body into xfsaild_process_logitem()
- Added xfsaild_push_item() header comment describing post-return lifetime
- Link to v2: https://lore.kernel.org/all/20260305185836.56478-2-ytohnuki@amazon.com/

Changes in v2:
- Reordered xfs_unmount_flush_inodes() to stop reclaim before pushing
  AIL suggested by Dave Chinner
- Introduced xfs_ail_push_class trace event to avoid dereferencing
  freed log items in tracepoints
- Added comments documenting that log items must not be referenced
  after iop_push() returns
- Saved ailp pointer in local variables in push functions
- Link to v1: https://lore.kernel.org/all/20260304162405.58017-2-ytohnuki@amazon.com/

Yuto Ohnuki (4):
  xfs: stop reclaim before pushing AIL during unmount
  xfs: refactor xfsaild_push loop into helper
  xfs: avoid dereferencing log items after push callbacks
  xfs: save ailp before dropping the AIL lock in push callbacks

 fs/xfs/xfs_dquot_item.c |   9 ++-
 fs/xfs/xfs_inode_item.c |   9 ++-
 fs/xfs/xfs_mount.c      |   4 +-
 fs/xfs/xfs_trace.h      |  36 ++++++++++--
 fs/xfs/xfs_trans_ail.c  | 124 +++++++++++++++++++++++-----------------
 5 files changed, 120 insertions(+), 62 deletions(-)

-- 
2.50.1




Amazon Web Services EMEA SARL, 38 avenue John F. Kennedy, L-1855 Luxembourg, R.C.S. Luxembourg B186284

Amazon Web Services EMEA SARL, Irish Branch, One Burlington Plaza, Burlington Road, Dublin 4, Ireland, branch registration number 908705




