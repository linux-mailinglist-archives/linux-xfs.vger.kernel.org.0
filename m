Return-Path: <linux-xfs+bounces-32037-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YInbNfcNr2njNAIAu9opvQ
	(envelope-from <linux-xfs+bounces-32037-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Mon, 09 Mar 2026 19:14:15 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 682D623E659
	for <lists+linux-xfs@lfdr.de>; Mon, 09 Mar 2026 19:14:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9D2473032048
	for <lists+linux-xfs@lfdr.de>; Mon,  9 Mar 2026 18:08:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3913B28C2DD;
	Mon,  9 Mar 2026 18:08:55 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from mx0.herbolt.com (mx0.herbolt.com [5.59.97.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C3782BEC45
	for <linux-xfs@vger.kernel.org>; Mon,  9 Mar 2026 18:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.59.97.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773079735; cv=none; b=OKLqgl2XdmsQbDxMQHM8AfuDJ/LwRu6kpsBNoaOOUilZfXHT78+wH0GrzDILKrBzpWrHwX0uipMJKln4Br772MiTSaA5b6/sHfToMwkUowBKECm6TMyu931e6Cr/VvNonR0JpUb1BpPIt1zwAWa0ZyJ9L0XjDdmx+W1q+C24ayg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773079735; c=relaxed/simple;
	bh=5e61FGdTKFWzwwXd37zfObaZ7O1U1d7+PGufJKnsuNE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uQUEW32o0ENgkQTeY9MKIRpBxoZoMTdRLE2DQzsWFl/jn5EC2kdLG7Rq3SOAb0xddigNBUPYillMOb5UkEeR8qbol94f53YXdQGKZ5TI86BHvrZkODVI8TAJhgvqJ1aQE3H2lOqJkUyFiL5tZVgUH0tXoo4zGxi89GQ8Wz/a9uM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com; spf=pass smtp.mailfrom=herbolt.com; arc=none smtp.client-ip=5.59.97.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=herbolt.com
Received: from mx0.herbolt.com (localhost [127.0.0.1])
	by mx0.herbolt.com (Postfix) with ESMTP id C8C51180F243;
	Mon, 09 Mar 2026 19:08:39 +0100 (CET)
Received: from trufa.intra.herbolt.com ([172.168.31.30])
	by mx0.herbolt.com with ESMTPSA
	id 8vDcK6cMr2k66h0AKEJqOA
	(envelope-from <lukas@herbolt.com>); Mon, 09 Mar 2026 19:08:39 +0100
From: Lukas Herbolt <lukas@herbolt.com>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org,
	hch@infradead.org,
	djwong@kernel.org,
	p.raghav@samsung.com
Subject: [PATCH 0/2] Addadd FALLOC_FL_WRITE_ZEROES support to xfs
Date: Mon,  9 Mar 2026 19:07:07 +0100
Message-ID: <20260309180708.427553-2-lukas@herbolt.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 682D623E659
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.04 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-32037-lists,linux-xfs=lfdr.de];
	RCVD_COUNT_FIVE(0.00)[5];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DMARC_NA(0.00)[herbolt.com];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FROM_NEQ_ENVFROM(0.00)[lukas@herbolt.com,linux-xfs@vger.kernel.org];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	NEURAL_HAM(-0.00)[-0.978];
	TO_DN_NONE(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	R_DKIM_NA(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[linux-xfs];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,herbolt.com:mid]
X-Rspamd-Action: no action

This is addtion of the FALLOC_FL_WRITE_ZEROES into the XFS.

As suggested this is split into two patches firts one introduce the 
bmapi_flags for xfs_alloc_file_space. Second patch implements the 
FALLOC_FL_WRITE_ZEROES doing it in two steps, first preallocates 
and then converts it to zeroed. Sending first patch as v0 and second 
as v11 to make the changes visible.

The first patch is just changes to
Doing the tho phase allocation t
Lukas Herbolt (2):
  xfs: Introduce 'bmapi_flags' parameter to xfs_alloc_file_space()
  xfs: add FALLOC_FL_WRITE_ZEROES to XFS code base

 fs/xfs/xfs_bmap_util.c |  5 +++--
 fs/xfs/xfs_bmap_util.h |  2 +-
 fs/xfs/xfs_file.c      | 47 ++++++++++++++++++++++++++++++------------
 3 files changed, 38 insertions(+), 16 deletions(-)

-- 
2.53.0


