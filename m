Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 205C0262485
	for <lists+linux-xfs@lfdr.de>; Wed,  9 Sep 2020 03:35:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726369AbgIIBfH (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 8 Sep 2020 21:35:07 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:49472 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726002AbgIIBfG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Sep 2020 21:35:06 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0891Z0oq041740;
        Wed, 9 Sep 2020 01:35:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=2Ed0e2rsOofftALNBcr05eMVKXUvpwjl/G2k5EfYRos=;
 b=WMw86EUUnj5f4+mtaezc6LA4DMb/4BfX0kqEzdJjdxOWSMS7MSRc6zEXKT1rZyaZ+0IL
 tY4Qxm8HWblfW/UeSmCK/KdzX/9rioJLvZnWZuQKN24p4FakHZ0KHitoQyY7gnZhokHs
 DefDj+JpaXTOtT6utNOjkeVIAaq9Ozs1vORAnuIYVORC9QYHSGhgi8ozjYjqHcKc+B1d
 cTgkgXPOg+4rEdLcoU7q+crnHKDQsei6Bp/eN0BteNXeRBIdLLiFuVORqctRFXx2Ycif
 0nLqXPwW+hOfhhfygzmd9Ak3hYS3ffxmwmD+KgK7rAgYkqVA3p4+qCHrFXfNwrgLrmiD JA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 33c2mkxsub-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 09 Sep 2020 01:35:00 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0891QLq4079245;
        Wed, 9 Sep 2020 01:32:59 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 33cmkwvbdm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Sep 2020 01:32:59 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0891Wr5R024820;
        Wed, 9 Sep 2020 01:32:53 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 08 Sep 2020 18:32:53 -0700
Date:   Tue, 8 Sep 2020 18:32:51 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Jan Kara <jack@suse.cz>
Cc:     linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        xfs <linux-xfs@vger.kernel.org>, hch@lst.de
Subject: [PATCH v3] quota: widen timestamps for the fs_disk_quota structure
Message-ID: <20200909013251.GG7955@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9738 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 suspectscore=1
 spamscore=0 mlxlogscore=999 adultscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009090011
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9738 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 priorityscore=1501
 phishscore=0 adultscore=0 bulkscore=0 clxscore=1015 mlxlogscore=999
 malwarescore=0 suspectscore=1 lowpriorityscore=0 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009090012
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Soon, XFS will support quota grace period expiration timestamps beyond
the year 2038, widen the timestamp fields to handle the extra time bits.
Internally, XFS now stores unsigned 34-bit quantities, so the extra 8
bits here should work fine.  (Note that XFS is the only user of this
structure.)

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v3: remove the old rt_spc_timer assignment statement
v2: fix calling conventions, widen timestamps
---
 fs/quota/quota.c               |   44 +++++++++++++++++++++++++++++++++++-----
 include/uapi/linux/dqblk_xfs.h |   11 +++++++++-
 2 files changed, 48 insertions(+), 7 deletions(-)

diff --git a/fs/quota/quota.c b/fs/quota/quota.c
index 47f9e151988b..77abd1d9f02f 100644
--- a/fs/quota/quota.c
+++ b/fs/quota/quota.c
@@ -481,6 +481,14 @@ static inline u64 quota_btobb(u64 bytes)
 	return (bytes + (1 << XFS_BB_SHIFT) - 1) >> XFS_BB_SHIFT;
 }
 
+static inline s64 copy_from_xfs_dqblk_ts(const struct fs_disk_quota *d,
+		__s32 timer, __s8 timer_hi)
+{
+	if (d->d_fieldmask & FS_DQ_BIGTIME)
+		return (u32)timer | (s64)timer_hi << 32;
+	return timer;
+}
+
 static void copy_from_xfs_dqblk(struct qc_dqblk *dst, struct fs_disk_quota *src)
 {
 	dst->d_spc_hardlimit = quota_bbtob(src->d_blk_hardlimit);
@@ -489,14 +497,17 @@ static void copy_from_xfs_dqblk(struct qc_dqblk *dst, struct fs_disk_quota *src)
 	dst->d_ino_softlimit = src->d_ino_softlimit;
 	dst->d_space = quota_bbtob(src->d_bcount);
 	dst->d_ino_count = src->d_icount;
-	dst->d_ino_timer = src->d_itimer;
-	dst->d_spc_timer = src->d_btimer;
+	dst->d_ino_timer = copy_from_xfs_dqblk_ts(src, src->d_itimer,
+						  src->d_itimer_hi);
+	dst->d_spc_timer = copy_from_xfs_dqblk_ts(src, src->d_btimer,
+						  src->d_btimer_hi);
 	dst->d_ino_warns = src->d_iwarns;
 	dst->d_spc_warns = src->d_bwarns;
 	dst->d_rt_spc_hardlimit = quota_bbtob(src->d_rtb_hardlimit);
 	dst->d_rt_spc_softlimit = quota_bbtob(src->d_rtb_softlimit);
 	dst->d_rt_space = quota_bbtob(src->d_rtbcount);
-	dst->d_rt_spc_timer = src->d_rtbtimer;
+	dst->d_rt_spc_timer = copy_from_xfs_dqblk_ts(src, src->d_rtbtimer,
+						     src->d_rtbtimer_hi);
 	dst->d_rt_spc_warns = src->d_rtbwarns;
 	dst->d_fieldmask = 0;
 	if (src->d_fieldmask & FS_DQ_ISOFT)
@@ -588,10 +599,28 @@ static int quota_setxquota(struct super_block *sb, int type, qid_t id,
 	return sb->s_qcop->set_dqblk(sb, qid, &qdq);
 }
 
+static inline void copy_to_xfs_dqblk_ts(const struct fs_disk_quota *d,
+		__s32 *timer_lo, __s8 *timer_hi, s64 timer)
+{
+	*timer_lo = timer;
+	if (d->d_fieldmask & FS_DQ_BIGTIME)
+		*timer_hi = timer >> 32;
+	else
+		*timer_hi = 0;
+}
+
+static inline bool want_bigtime(s64 timer)
+{
+	return timer > S32_MAX || timer < S32_MIN;
+}
+
 static void copy_to_xfs_dqblk(struct fs_disk_quota *dst, struct qc_dqblk *src,
 			      int type, qid_t id)
 {
 	memset(dst, 0, sizeof(*dst));
+	if (want_bigtime(src->d_ino_timer) || want_bigtime(src->d_spc_timer) ||
+	    want_bigtime(src->d_rt_spc_timer))
+		dst->d_fieldmask |= FS_DQ_BIGTIME;
 	dst->d_version = FS_DQUOT_VERSION;
 	dst->d_id = id;
 	if (type == USRQUOTA)
@@ -606,14 +635,17 @@ static void copy_to_xfs_dqblk(struct fs_disk_quota *dst, struct qc_dqblk *src,
 	dst->d_ino_softlimit = src->d_ino_softlimit;
 	dst->d_bcount = quota_btobb(src->d_space);
 	dst->d_icount = src->d_ino_count;
-	dst->d_itimer = src->d_ino_timer;
-	dst->d_btimer = src->d_spc_timer;
+	copy_to_xfs_dqblk_ts(dst, &dst->d_itimer, &dst->d_itimer_hi,
+			     src->d_ino_timer);
+	copy_to_xfs_dqblk_ts(dst, &dst->d_btimer, &dst->d_btimer_hi,
+			     src->d_spc_timer);
 	dst->d_iwarns = src->d_ino_warns;
 	dst->d_bwarns = src->d_spc_warns;
 	dst->d_rtb_hardlimit = quota_btobb(src->d_rt_spc_hardlimit);
 	dst->d_rtb_softlimit = quota_btobb(src->d_rt_spc_softlimit);
 	dst->d_rtbcount = quota_btobb(src->d_rt_space);
-	dst->d_rtbtimer = src->d_rt_spc_timer;
+	copy_to_xfs_dqblk_ts(dst, &dst->d_rtbtimer, &dst->d_rtbtimer_hi,
+			     src->d_rt_spc_timer);
 	dst->d_rtbwarns = src->d_rt_spc_warns;
 }
 
diff --git a/include/uapi/linux/dqblk_xfs.h b/include/uapi/linux/dqblk_xfs.h
index 03d890b80ebc..16d73f54376d 100644
--- a/include/uapi/linux/dqblk_xfs.h
+++ b/include/uapi/linux/dqblk_xfs.h
@@ -66,7 +66,10 @@ typedef struct fs_disk_quota {
 	__s32		d_btimer;	/* similar to above; for disk blocks */
 	__u16	  	d_iwarns;       /* # warnings issued wrt num inodes */
 	__u16	  	d_bwarns;       /* # warnings issued wrt disk blocks */
-	__s32		d_padding2;	/* padding2 - for future use */
+	__s8		d_itimer_hi;	/* upper 8 bits of timer values */
+	__s8		d_btimer_hi;
+	__s8		d_rtbtimer_hi;
+	__s8		d_padding2;	/* padding2 - for future use */
 	__u64		d_rtb_hardlimit;/* absolute limit on realtime blks */
 	__u64		d_rtb_softlimit;/* preferred limit on RT disk blks */
 	__u64		d_rtbcount;	/* # realtime blocks owned */
@@ -121,6 +124,12 @@ typedef struct fs_disk_quota {
 #define FS_DQ_RTBCOUNT		(1<<14)
 #define FS_DQ_ACCT_MASK		(FS_DQ_BCOUNT | FS_DQ_ICOUNT | FS_DQ_RTBCOUNT)
 
+/*
+ * Quota expiration timestamps are 40-bit signed integers, with the upper 8
+ * bits encoded in the _hi fields.
+ */
+#define FS_DQ_BIGTIME		(1<<15)
+
 /*
  * Various flags related to quotactl(2).
  */
