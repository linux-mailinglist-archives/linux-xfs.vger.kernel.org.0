Return-Path: <linux-xfs+bounces-31077-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id lhWJBcr3lmn4swIAu9opvQ
	(envelope-from <linux-xfs+bounces-31077-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Thu, 19 Feb 2026 12:45:14 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 768FF15E651
	for <lists+linux-xfs@lfdr.de>; Thu, 19 Feb 2026 12:45:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 3636D3018C26
	for <lists+linux-xfs@lfdr.de>; Thu, 19 Feb 2026 11:45:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E1D5309F0E;
	Thu, 19 Feb 2026 11:45:11 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from mx0.herbolt.com (mx0.herbolt.com [5.59.97.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56D0430BB9B
	for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 11:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.59.97.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771501511; cv=none; b=UldliQfpER4PBp4oegTPPRQfIUHKRVkdHGY9HLrPvAHqOmr6D3xk1dYWd/HnCchqnrOgCjU8Lkd229xcNs1XRvTQX02ZgEMaoRBZiqJy7atvMG7k/DU/9/0cM7Oq0+ornGjzxEWqmaV3FPJsfspVHPxsgsshdSEE8Q/KeuMCtpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771501511; c=relaxed/simple;
	bh=eE1ky4J6GpPDttWS6GBJmgH7xpKFgiMVQLKevKhYmaw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NZ+QUnfVLR6q2XQXQF0SLHQqrfA+SXY/ccSMH++Wj1VokmSqdoQTdRgV45NbGZyej9Z5J7kq80N0dCth5Oi7gR3cGkqHRc2IEAlUExJmn6Oz2v4hE/b7zijSbVuWULoIlVannlyQRTHX70bqDCsSculDshj1YIQmP1nnnO5G5EQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com; spf=pass smtp.mailfrom=herbolt.com; arc=none smtp.client-ip=5.59.97.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=herbolt.com
Received: from mx0.herbolt.com (localhost [127.0.0.1])
	by mx0.herbolt.com (Postfix) with ESMTP id 880A9180F2E7;
	Thu, 19 Feb 2026 12:44:56 +0100 (CET)
Received: from trufa.intra.herbolt.com.com ([172.168.31.30])
	by mx0.herbolt.com with ESMTPSA
	id 2/CrGrj3lmlSEAkAKEJqOA
	(envelope-from <lukas@herbolt.com>); Thu, 19 Feb 2026 12:44:56 +0100
From: Lukas Herbolt <lukas@herbolt.com>
To: hch@infradead.org,
	aalbersh@redhat.com,
	cem@kernel.org
Cc: linux-xfs@vger.kernel.org,
	Lukas Herbolt <lukas@herbolt.com>
Subject: [PATCH 0/1] mkfs.xfs fix sunit size on 512e and 4kN disks.
Date: Thu, 19 Feb 2026 12:44:06 +0100
Message-ID: <20260219114405.31521-3-lukas@herbolt.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.04 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_SOME(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-31077-lists,linux-xfs=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[herbolt.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-xfs];
	FROM_NEQ_ENVFROM(0.00)[lukas@herbolt.com,linux-xfs@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-0.992];
	RCVD_COUNT_FIVE(0.00)[5];
	R_DKIM_NA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,herbolt.com:mid]
X-Rspamd-Queue-Id: 768FF15E651
X-Rspamd-Action: no action

Creating of XFS on 4kN or 512e disk result in suboptimal LSU/LSUNIT.
As of now we check if the sectorsize is bigger than XLOG_HEADER_SIZE
and so we set lsu to blocksize. But we do not check the the size if
lsunit can be bigger to fit the disk geometry.

It was laready discussed here:
 - https://lore.kernel.org/linux-xfs/aOX_TzJIxJWWC63x@infradead.org/

but it somehow fell of the plate.

Before:
modprobe scsi_debug inq_vendor=XFS_TEST physblk_exp=3 sector_size=512 \
opt_xferlen_exp=9 opt_blks=512 dev_size_mb=100 virtual_gb=1000; \
lsblk -tQ 'VENDOR == "XFS_TEST"'; \
mkfs.xfs -f $(lsblk -Q 'VENDOR == "XFS_TEST"' -no path) 2>/dev/null; sleep 1; \
modprobe -r scsi_debug
NAME ALIGNMENT MIN-IO OPT-IO PHY-SEC LOG-SEC ROTA SCHED RQ-SIZE  RA WSAME
sda          0 262144 262144    4096     512    0 bfq       256 512    0B
meta-data=/dev/sda               isize=512    agcount=32, agsize=8192000 blks
         =                       sectsz=4096  attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=1
         =                       reflink=1    bigtime=1 inobtcount=1 nrext64=1
         =                       exchange=0
data     =                       bsize=4096   blocks=262144000, imaxpct=25
         =                       sunit=64     swidth=64 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1, parent=0
log      =internal log           bsize=4096   blocks=128000, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=1
                                              ^^^^^^^^^^^^^^
realtime =none                   extsz=4096   blocks=0, rtextents=0

After:
modprobe scsi_debug inq_vendor=XFS_TEST physblk_exp=3 sector_size=512 \
opt_xferlen_exp=9 opt_blks=512 dev_size_mb=100 virtual_gb=1000; \
lsblk -tQ 'VENDOR == "XFS_TEST"'; \
mkfs.xfs -f $(lsblk -Q 'VENDOR == "XFS_TEST"' -no path) 2>/dev/null; sleep 1; \
modprobe -r scsi_debug
NAME ALIGNMENT MIN-IO OPT-IO PHY-SEC LOG-SEC ROTA SCHED RQ-SIZE  RA WSAME
sda          0 262144 262144    4096     512    0 bfq       256 512    0B
meta-data=/dev/sda               isize=512    agcount=32, agsize=8192000 blks
         =                       sectsz=4096  attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=1
         =                       reflink=1    bigtime=1 inobtcount=1 nrext64=1
         =                       exchange=0   metadir=0
data     =                       bsize=4096   blocks=262144000, imaxpct=25
         =                       sunit=64     swidth=64 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1, parent=0
log      =internal log           bsize=4096   blocks=128000, version=2
         =                       sectsz=4096  sunit=64 blks, lazy-count=1
                                              ^^^^^^^^^^^^^^
realtime =none                   extsz=4096   blocks=0, rtextents=0
         =                       rgcount=0    rgsize=0 extents
         =                       zoned=0      start=0 reserved=0

Lukas Herbolt (1):
  mkfs.xfs fix sunit size on 512e and 4kN disks.

 mkfs/xfs_mkfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
2.53.0


