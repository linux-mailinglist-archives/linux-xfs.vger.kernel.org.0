Return-Path: <linux-xfs+bounces-25801-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CCA8CB88082
	for <lists+linux-xfs@lfdr.de>; Fri, 19 Sep 2025 08:48:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 817CF627CD4
	for <lists+linux-xfs@lfdr.de>; Fri, 19 Sep 2025 06:48:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65CA929BDAD;
	Fri, 19 Sep 2025 06:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="sEu2b2GN"
X-Original-To: linux-xfs@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87DDB25A33A;
	Fri, 19 Sep 2025 06:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758264506; cv=none; b=b0/Vexrg53pC2Fcosa35qzYgUohDitlee2WNaWMpIfIqNYwC5ila47oKT4XbcLMSFxuvseTClkxZ2zivb3LIduzGdda626NYEFBRDhs35LQNV/DJbhC2KPNV2Szz/RKcNlG9nH4akSmgaxV0Ds9bKxd3g8JYYcAiz7eJlr7fzbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758264506; c=relaxed/simple;
	bh=p/lJeks8maYs2wRwqTBLGhIVXRz9P4BEtOTbrt/UBhI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kwBF6UZFKHrW190DqP3+AK9OgKuypI3qcB7iusw+yGT6hC2cAjIv01CK1U5B7hkUWPYgy707K6UdmeC9aEKqSfTzetMR5rcT/76nZFkwdEXFIlHxk4AloZn/2q0VMJUjQ4w+0CoPXE9T8dDwAcrfQ3t+SyglWsTtgsQe91WP0h4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=sEu2b2GN; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58J1pcIj011459;
	Fri, 19 Sep 2025 06:48:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=ZX79AQL6Vwm9BH3DfNk7vDVB87Dqmx7tyyrSRLc//
	+I=; b=sEu2b2GN8a1IZRGy2/wIsfbRALoIt/j3w4weCYUV0RMdZfZal9xOE8mEv
	ReOlZVuwUoskqCMDWELRR33VFshzwn9sqrKAxLHUn6R1JfP9Ydor+SdrYPhk8Yvv
	NQL0tTVB7/4gRet9GQssPT5ALD6C0c/mS0elYzn2lZTqdCn8gep/ADzC8DCqgGvm
	YdhrwyrArrL5laZXhKOsTkWvlH/wWMR6ZGtGsbXXdqnaZtB2QcaMrJX5m2wTXca0
	Q6P41Ukc119oGsqCuy+LquGcICUWfJJ04tvUhIGYG4ldMryB2mNSp2tVhMkoMdcd
	jhnUqybCdBJibp9+ixMe1XOlOjKMQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 497g4jey8n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 19 Sep 2025 06:48:14 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 58J6ZHOg027447;
	Fri, 19 Sep 2025 06:48:14 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 497g4jey8j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 19 Sep 2025 06:48:14 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58J4mduD029472;
	Fri, 19 Sep 2025 06:48:13 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 495kb1atnj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 19 Sep 2025 06:48:12 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58J6mBMU12190142
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 19 Sep 2025 06:48:11 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0AC4220043;
	Fri, 19 Sep 2025 06:48:11 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 779EE20040;
	Fri, 19 Sep 2025 06:48:07 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.124.215.51])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 19 Sep 2025 06:48:07 +0000 (GMT)
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Zorro Lang <zlang@redhat.com>, fstests@vger.kernel.org
Cc: Ritesh Harjani <ritesh.list@gmail.com>, djwong@kernel.org,
        john.g.garry@oracle.com, tytso@mit.edu, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: [PATCH v7 00/11] Add more tests for multi fs block atomic writes
Date: Fri, 19 Sep 2025 12:17:53 +0530
Message-ID: <cover.1758264169.git.ojaswin@linux.ibm.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=Qf5mvtbv c=1 sm=1 tr=0 ts=68ccfcae cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=yJojWOMRYYMA:10 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=yPCof4ZbAAAA:8
 a=RhRxWBKHx9l-Qd8VlncA:9
X-Proofpoint-ORIG-GUID: kfx3m9WDgkzZzsBmRhSH3TOGEpwbSmo_
X-Proofpoint-GUID: SwVC9rzFHYAD5Xhimknwegv1nU0byj2S
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDIwNCBTYWx0ZWRfX7Sj/XePoDbAp
 thtlhCmp7UZGaS8SsuxahpzJhG+YTDtHFszqEHChS/6V1pJu5wrc7XDOf59zGICP27RreS39rDI
 q/Otx8vna/aY5UIlauS93wh/SpI1s1vhAWle4bJ5luDpCxH102jcJ/qk4s9erTkXTpiAIBCV/Li
 13w1me8De99dF2S88VoGh5CWNgzHIRvEGZy23K9QHGb6XSqaq80KTZQWDDXZ/+yNZdypvWsqoFx
 5qGg1vMQvpQU+GlhsN4sWCnKiH6NVQEKMkgUoWSkEX2u2uK9Obahl49DhIWdEZhVSVFt+Oxgqk6
 kA9EOaWhSWVs74mLRX1Jux1lug9BF8WqDZbakvj5HZ5V4c/qzSa1TPLFEv8fmWQvzddWnlz0UWq
 Ighfc5Dy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-18_03,2025-09-19_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 clxscore=1015 phishscore=0 suspectscore=0 adultscore=0
 priorityscore=1501 malwarescore=0 bulkscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509160204

Changes in v7:
- Picked up reviews from John! (Thanks)
- [9/11] Change "integrity test.." -> "torn write test.." for better
  clarity

Changes in v6:[5]
- Picked up reviews from Darrick, Zorro and John! (Thanks)
- Added _require_fio_atomic_writes helper in patch 3 as a wrapper arounc
  __require_fio_version
- minor spelling and refactors

[5] https://lore.kernel.org/fstests/cover.1757610403.git.ojaswin@linux.ibm.com/

Changes in v5: (Thanks to John & Darrick for reviews)
- commor/rc: Add a _require_fio_version helper
- fsx: Switch atomic writes off if direct IO (-Z) not passed
- fio tests: better commit messages to explain what we are testing
- ext4/06{1..2}: Refactor code, also test only a few combinations of bs
  clustersize rather than every single

Changes in v4: (Thanks to Darrick, John and Zorro for the reviews) [4]

- g/1226,1227: Modify fio threads to not issue overlapping atomic writes
- g/1228: Use xfs_io -c "shutdown" instead of _scratch_shutdown to avoid
          bash overhead
- g/1229: Remove FSX_AVOID handling for bigalloc from common/rc. It is
          part of the specific test now
- ext4/063: add more clearer extent diagram
- ext4/064: Drop the test for now as im taking sometime to understand
            the behavior better.
- Removed test numbers from commit message
- For tests with significant changes I've removed the RVBs

[4] https://lore.kernel.org/fstests/0eb2703b-a862-4a40-b271-6b8bb27b4ad4@oracle.com/T/#mef34a8c13cbee466bfc162db637d6e1cf0a8b06d

Changes in v3 [3]:

- (2/13) use dumpe2fs to figure out if FS is bigalloc
- (9/13) generic/1230: Detect device speeds for more accurate testing. ALso
  speeds up the test
- fio tests - switch to write followed by verify approach to avoid false
  failures due to fio verify reads splitting and racing with atomic
  writes. Discussion thread:

  https://lore.kernel.org/fstests/0430bd73-e6c2-4ce9-af24-67b1e1fa9b5b@oracle.com/

  [3] https://lore.kernel.org/fstests/cover.1752329098.git.ojaswin@linux.ibm.com/

Changes in v2 [1]:

- (1/13) new patch with _min and _max helpers
- (2/13) remove setup_fs_options and add fsx specific helper
- (4/13) skip atomic write instead of falling back to normal write (fsx)
- (4/13) make atomic write default on instead of default off (fsx)
- (5,6/13) refactor and cleanup fio tests
- (7/13) refactored common code
- (8/13) dont ignore mmap writes for fsx with atomic writes
- (9/13) use od instead of xxd. handle cleanup of bg threads in _cleanup()
- (10-13/13) minor refactors
- change all tests use _fail for better consistency
- use higher tests numbers for easier merging

 [1] https://lore.kernel.org/fstests/cover.1750924903.git.ojaswin@linux.ibm.com/

* Original cover [2] *

These are the tests we were using to verify that filesystems are not
tearing multi fs block atomic writes. Infact some of the tests like
generic/772 (now: g/1230) actually helped us catch and fix issues in
ext4's early implementations of multi fs block atomic writes and hence
we feel these tests are useful to have in xfstests.

We have tested these with scsi debug as well as a real nvme device
supporting multi fs block atomic writes.

Thoughts and suggestions are welcome!

[2] rfc: https://lore.kernel.org/fstests/cover.1749629233.git.ojaswin@linux.ibm.com/


Ojaswin Mujoo (10):
  common/rc: Add _min() and _max() helpers
  common/rc: Add fio atomic write helpers
  common/rc: Add a helper to run fsx on a given file
  ltp/fsx.c: Add atomic writes support to fsx
  generic: Add atomic write test using fio crc check verifier
  generic: Add atomic write test using fio verify on file mixed mappings
  generic: Add atomic write multi-fsblock O_[D]SYNC tests
  generic: Stress fsx with atomic writes enabled
  generic: Add sudden shutdown tests for multi block atomic writes
  ext4: Atomic write test for extent split across leaf nodes

Ritesh Harjani (IBM) (2):
  ext4: Test atomic write and ioend codepaths with bigalloc
  ext4: Test atomic writes allocation and write codepaths with bigalloc

 common/rc              |  88 +++++++++-
 ltp/fsx.c              | 115 ++++++++++++-
 tests/ext4/061         | 155 +++++++++++++++++
 tests/ext4/061.out     |   2 +
 tests/ext4/062         | 203 +++++++++++++++++++++++
 tests/ext4/062.out     |   2 +
 tests/ext4/063         | 129 +++++++++++++++
 tests/ext4/063.out     |   2 +
 tests/generic/1226     | 108 ++++++++++++
 tests/generic/1226.out |   2 +
 tests/generic/1227     | 132 +++++++++++++++
 tests/generic/1227.out |   2 +
 tests/generic/1228     | 138 ++++++++++++++++
 tests/generic/1228.out |   2 +
 tests/generic/1229     |  68 ++++++++
 tests/generic/1229.out |   2 +
 tests/generic/1230     | 368 +++++++++++++++++++++++++++++++++++++++++
 tests/generic/1230.out |   2 +
 18 files changed, 1512 insertions(+), 8 deletions(-)
 create mode 100755 tests/ext4/061
 create mode 100644 tests/ext4/061.out
 create mode 100755 tests/ext4/062
 create mode 100644 tests/ext4/062.out
 create mode 100755 tests/ext4/063
 create mode 100644 tests/ext4/063.out
 create mode 100755 tests/generic/1226
 create mode 100644 tests/generic/1226.out
 create mode 100755 tests/generic/1227
 create mode 100644 tests/generic/1227.out
 create mode 100755 tests/generic/1228
 create mode 100644 tests/generic/1228.out
 create mode 100755 tests/generic/1229
 create mode 100644 tests/generic/1229.out
 create mode 100755 tests/generic/1230
 create mode 100644 tests/generic/1230.out

-- 
2.49.0


