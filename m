Return-Path: <linux-xfs+bounces-31027-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MNGbMP+olmmTiQIAu9opvQ
	(envelope-from <linux-xfs+bounces-31027-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Thu, 19 Feb 2026 07:09:03 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E0B715C4FC
	for <lists+linux-xfs@lfdr.de>; Thu, 19 Feb 2026 07:09:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 01FDC3009F2E
	for <lists+linux-xfs@lfdr.de>; Thu, 19 Feb 2026 06:09:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F27A62E541E;
	Thu, 19 Feb 2026 06:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="bIT3q4BQ"
X-Original-To: linux-xfs@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0AC2238C16;
	Thu, 19 Feb 2026 06:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771481338; cv=none; b=Gkhsrz+mPdMfBAK+RZZQcqBYuSoVpi7NpZVkagHpw9/RGsKO6YI15UyhMHcYhbzUOhurO9qrmEBS/KBEMWw1k+DKKaOHy/AWuFOn6AlXEc7cTjcVtTzD3AJARmhZIZ1BGcPxXIkZfAmCq3YR+a/qep7xNjGDjfxyxZr4cwSvhZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771481338; c=relaxed/simple;
	bh=UxAADwJd7MEPoH5XrK7wQIU6G5VNW2mvilYVeow0aWE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GtMEBWTKUAxTDZCVj3sA5I4UKOIXYNKrEzU/+0m9Q1Nixar+ymA6yvL82NqaPZTNWSODralXxLBQzpZEkI36Y8vovmrZgQsnNUguUwUS27ntJSIi6cnPCRSjt5w77w9gSkjyqw9V/heF8Ja3aPAx3mBYvhLS+vgnG59AAuS9TjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=bIT3q4BQ; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61J4x2Mj3447192;
	Thu, 19 Feb 2026 06:08:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=6vFz2eccRolxH6sNX
	UR0xgCrJrNddxfppe2mx/XtP6o=; b=bIT3q4BQxrIPijc7M0/vSvJx1VQDXH5d+
	JU2UbtvpjsPmpOW+Ir5ZHNBqPKn0ZiCyVpSPx/qGRcoy2KPT5iSUKFzBPDTJfCrV
	AU8gglt1LgFBNYy3uB34f/wxvd4u7LMdD+k/5tds/BeN3Tq/uXHkxWVS6aFhJ110
	b5HYGbZnwyutttJ5dFvT1YOlMnTUtNumOMJiDsXG0oh0TWC0fiDp1bzikHOYTl9q
	Ar0FIZ48POnC/U1AhRpvi3Gl/h04fIXW4kymCLfsYPKn3xz3BYliszmSo/z4CgFC
	3WG3RpGhJAm97YK2DbrAZhhAAvIU//hKf2zzlx/1SZOjb90Iro1LQ==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4caj6s4p9s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Feb 2026 06:08:49 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61J3R3Ma015679;
	Thu, 19 Feb 2026 06:08:48 GMT
Received: from smtprelay06.wdc07v.mail.ibm.com ([172.16.1.73])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4ccb45b0a0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Feb 2026 06:08:48 +0000
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
	by smtprelay06.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61J68kpX50725160
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Feb 2026 06:08:47 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B3ED358055;
	Thu, 19 Feb 2026 06:08:46 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 918DC58043;
	Thu, 19 Feb 2026 06:08:43 +0000 (GMT)
Received: from citest-1.. (unknown [9.124.222.193])
	by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 19 Feb 2026 06:08:43 +0000 (GMT)
From: "Nirjhar Roy (IBM)" <nirjhar@linux.ibm.com>
To: djwong@kernel.org, hch@infradead.org, cem@kernel.org, david@fromorbit.com,
        zlang@kernel.org
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org, ritesh.list@gmail.com,
        ojaswin@linux.ibm.com, nirjhar@linux.ibm.com,
        nirjhar.roy.lists@gmail.com, hsiangkao@linux.alibaba.com
Subject: [PATCH v1] xfs_growfs: Allow shrink of realtime XFS
Date: Thu, 19 Feb 2026 06:08:18 +0000
Message-Id: <5b9057407e6fb45e48f19a876299052358333448.1770039755.git.nirjhar.roy.lists@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260219055737.769860-1-nirjhar@linux.ibm.com>
References: <20260219055737.769860-1-nirjhar@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=dvvWylg4 c=1 sm=1 tr=0 ts=6996a8f1 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=pGLkceISAAAA:8 a=S1XVEghoFnJWmtdSiEcA:9
X-Proofpoint-GUID: b4oACg9OAlpSY0xCsZKD5tI-4TIRYrwO
X-Proofpoint-ORIG-GUID: pCMDvtsSop5glBey0IucfEvUWeAe6vEh
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjE5MDA1NCBTYWx0ZWRfX8Mt1F0wfVoJk
 zF2UNeYBKnB4xSqGc6w3iguYAm6l0eF8cWoq8lBn8krZ2voXIX+8kZoHvimnn1j2dREwVQAAG73
 zTZxBs6+iPs4m4zXcoPK4M5Ry5b/l2k8Gjs7ZXqMPfF7eqWkQHHaUX7z+esDLBP7ofw8esRcYYS
 5W5yG3u1z+5zoNEzVpWciQleKRSBn7Bqu7thdgoNhTnnX8d5LhROnVUmGXadTxW8QXgpXsWksjR
 K3iDT33Svw1bKGVdat3b3+d6u+XmjrP1NtbHE0trCJ67bW51FBA+kVolH3qGEwNAAVwBjM11Ov4
 d+gByLizhjLsflNKetwqffS1IS+9Mk32LhAzSCTEoGv8GPzr2liEc3dq7sDCxPnvDwEx5q3dO8h
 fIe6dSsIBryoJ5bFzdjXJLObUbEWVKQNGEA1Yxtxl+un206YS+flxOqzek8Cx0dkf6+wpEyiWzc
 BOQJWzdw+8jRl/S5Qdw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-19_01,2026-02-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 lowpriorityscore=0 impostorscore=0 adultscore=0
 priorityscore=1501 clxscore=1011 malwarescore=0 phishscore=0 suspectscore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2602190054
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-31027-lists,linux-xfs=lfdr.de];
	FROM_HAS_DN(0.00)[];
	TO_DN_NONE(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com,linux.ibm.com,linux.alibaba.com];
	MIME_TRACE(0.00)[0:+];
	FROM_NEQ_ENVFROM(0.00)[nirjhar@linux.ibm.com,linux-xfs@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns];
	DKIM_TRACE(0.00)[ibm.com:+];
	TAGGED_RCPT(0.00)[linux-xfs];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCPT_COUNT_TWELVE(0.00)[12];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Queue-Id: 3E0B715C4FC
X-Rspamd-Action: no action

From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>

This patch allows shrinking of realtime XFS ioctl to be
passed to the kernel.

Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
---
 growfs/xfs_growfs.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/growfs/xfs_growfs.c b/growfs/xfs_growfs.c
index 0d0b2ae3..18174ea2 100644
--- a/growfs/xfs_growfs.c
+++ b/growfs/xfs_growfs.c
@@ -296,11 +296,12 @@ _("[EXPERIMENTAL] try to shrink unused space %lld, old size is %lld\n"),
 			error = 1;
 		}
 		if (!error && rsize < geo.rtblocks) {
-			fprintf(stderr, _(
-			"realtime size %lld too small, old size is %lld\n"),
+			fprintf(stderr,
+_("[EXPERIMENTAL] try to shrink realtime unused space %lld, old size is %lld\n"),
 				(long long)rsize, (long long)geo.rtblocks);
-			error = 1;
-		} else if (!error && rsize == geo.rtblocks) {
+                }
+
+		if (!error && rsize == geo.rtblocks) {
 			if (rflag)
 				fprintf(stderr, _(
 					"realtime size unchanged, skipping\n"));
-- 
2.34.1


