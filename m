Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5261B11BF5
	for <lists+linux-xfs@lfdr.de>; Thu,  2 May 2019 16:59:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726268AbfEBO71 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 2 May 2019 10:59:27 -0400
Received: from sandeen.net ([63.231.237.45]:36518 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726197AbfEBO71 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 2 May 2019 10:59:27 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id A59681165F;
        Thu,  2 May 2019 09:59:25 -0500 (CDT)
Subject: [PATCH V4] xfs: change some error-less functions to void types
From:   Eric Sandeen <sandeen@sandeen.net>
To:     Eric Sandeen <sandeen@redhat.com>,
        linux-xfs <linux-xfs@vger.kernel.org>
References: <a8eec37c-0cb1-0dc6-aa65-7248e367fc08@redhat.com>
 <c12bb330-bb07-ae9c-2812-4fb39e4262dd@sandeen.net>
Openpgp: preference=signencrypt
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 mQINBE6x99QBEADMR+yNFBc1Y5avoUhzI/sdR9ANwznsNpiCtZlaO4pIWvqQJCjBzp96cpCs
 nQZV32nqJBYnDpBDITBqTa/EF+IrHx8gKq8TaSBLHUq2ju2gJJLfBoL7V3807PQcI18YzkF+
 WL05ODFQ2cemDhx5uLghHEeOxuGj+1AI+kh/FCzMedHc6k87Yu2ZuaWF+Gh1W2ix6hikRJmQ
 vj5BEeAx7xKkyBhzdbNIbbjV/iGi9b26B/dNcyd5w2My2gxMtxaiP7q5b6GM2rsQklHP8FtW
 ZiYO7jsg/qIppR1C6Zr5jK1GQlMUIclYFeBbKggJ9mSwXJH7MIftilGQ8KDvNuV5AbkronGC
 sEEHj2khs7GfVv4pmUUHf1MRIvV0x3WJkpmhuZaYg8AdJlyGKgp+TQ7B+wCjNTdVqMI1vDk2
 BS6Rg851ay7AypbCPx2w4d8jIkQEgNjACHVDU89PNKAjScK1aTnW+HNUqg9BliCvuX5g4z2j
 gJBs57loTWAGe2Ve3cMy3VoQ40Wt3yKK0Eno8jfgzgb48wyycINZgnseMRhxc2c8hd51tftK
 LKhPj4c7uqjnBjrgOVaVBupGUmvLiePlnW56zJZ51BR5igWnILeOJ1ZIcf7KsaHyE6B1mG+X
 dmYtjDhjf3NAcoBWJuj8euxMB6TcQN2MrSXy5wSKaw40evooGwARAQABtCVFcmljIFIuIFNh
 bmRlZW4gPHNhbmRlZW5Ac2FuZGVlbi5uZXQ+iQI7BBMBAgAlAhsDBgsJCAcDAgYVCAIJCgsE
 FgIDAQIeAQIXgAUCUzMzbAIZAQAKCRAgrhaS4T3e4Fr7D/wO+fenqVvHjq21SCjDCrt8HdVj
 aJ28B1SqSU2toxyg5I160GllAxEHpLFGdbFAhQfBtnmlY9eMjwmJb0sCIrkrB6XNPSPA/B2B
 UPISh0z2odJv35/euJF71qIFgWzp2czJHkHWwVZaZpMWWNvsLIroXoR+uA9c2V1hQFVAJZyk
 EE4xzfm1+oVtjIC12B9tTCuS00pY3AUy21yzNowT6SSk7HAzmtG/PJ/uSB5wEkwldB6jVs2A
 sjOg1wMwVvh/JHilsQg4HSmDfObmZj1d0RWlMWcUE7csRnCE0ZWBMp/ttTn+oosioGa09HAS
 9jAnauznmYg43oQ5Akd8iQRxz5I58F/+JsdKvWiyrPDfYZtFS+UIgWD7x+mHBZ53Qjazszox
 gjwO9ehZpwUQxBm4I0lPDAKw3HJA+GwwiubTSlq5PS3P7QoCjaV8llH1bNFZMz2o8wPANiDx
 5FHgpRVgwLHakoCU1Gc+LXHXBzDXt7Cj02WYHdFzMm2hXaslRdhNGowLo1SXZFXa41KGTlNe
 4di53y9CK5ynV0z+YUa+5LR6RdHrHtgywdKnjeWdqhoVpsWIeORtwWGX8evNOiKJ7j0RsHha
 WrePTubr5nuYTDsQqgc2r4aBIOpeSRR2brlT/UE3wGgy9LY78L4EwPR0MzzecfE1Ws60iSqw
 Pu3vhb7h3bkCDQROsffUARAA0DrUifTrXQzqxO8aiQOC5p9Tz25Np/Tfpv1rofOwL8VPBMvJ
 X4P5l1V2yd70MZRUVgjmCydEyxLJ6G2YyHO2IZTEajUY0Up+b3ErOpLpZwhvgWatjifpj6bB
 SKuDXeThqFdkphF5kAmgfVAIkan5SxWK3+S0V2F/oxstIViBhMhDwI6XsRlnVBoLLYcEilxA
 2FlRUS7MOZGmRJkRtdGD5koVZSM6xVZQSmfEBaYQ/WJBGJQdPy94nnlAVn3lH3+N7pXvNUuC
 GV+t4YUt3tLcRuIpYBCOWlc7bpgeCps5Xa0dIZgJ8Louu6OBJ5vVXjPxTlkFdT0S0/uerCG5
 1u8p6sGRLnUeAUGkQfIUqGUjW2rHaXgWNvzOV6i3tf9YaiXKl3avFaNW1kKBs0T5M1cnlWZU
 Utl6k04lz5OjoNY9J/bGyV3DSlkblXRMK87iLYQSrcV6cFz9PRl4vW1LGff3xRQHngeN5fPx
 ze8X5NE3hb+SSwyMSEqJxhVTXJVfQWWW0dQxP7HNwqmOWYF/6m+1gK/Y2gY3jAQnsWTru4RV
 TZGnKwEPmOCpSUvsTRXsVHgsWJ70qd0yOSjWuiv4b8vmD3+QFgyvCBxPMdP3xsxN5etheLMO
 gRwWpLn6yNFq/xtgs+ECgG+gR78yXQyA7iCs5tFs2OrMqV5juSMGmn0kxJUAEQEAAYkCHwQY
 AQIACQUCTrH31AIbDAAKCRAgrhaS4T3e4BKwD/0ZOOmUNOZCSOLAMjZx3mtYtjYgfUNKi0ki
 YPveGoRWTqbis8UitPtNrG4XxgzLOijSdOEzQwkdOIp/QnZhGNssMejCnsluK0GQd+RkFVWN
 mcQT78hBeGcnEMAXZKq7bkIKzvc06GFmkMbX/gAl6DiNGv0UNAX+5FYh+ucCJZSyAp3sA+9/
 LKjxnTedX0aygXA6rkpX0Y0FvN/9dfm47+LGq7WAqBOyYTU3E6/+Z72bZoG/cG7ANLxcPool
 LOrU43oqFnD8QwcN56y4VfFj3/jDF2MX3xu4v2OjglVjMEYHTCxP3mpxesGHuqOit/FR+mF0
 MP9JGfj6x+bj/9JMBtCW1bY/aPeMdPGTJvXjGtOVYblGZrSjXRn5++Uuy36CvkcrjuziSDG+
 JEexGxczWwN4mrOQWhMT5Jyb+18CO+CWxJfHaYXiLEW7dI1AynL4jjn4W0MSiXpWDUw+fsBO
 Pk6ah10C4+R1Jc7dyUsKksMfvvhRX1hTIXhth85H16706bneTayZBhlZ/hK18uqTX+s0onG/
 m1F3vYvdlE4p2ts1mmixMF7KajN9/E5RQtiSArvKTbfsB6Two4MthIuLuf+M0mI4gPl9SPlf
 fWCYVPhaU9o83y1KFbD/+lh1pjP7bEu/YudBvz7F2Myjh4/9GUAijrCTNeDTDAgvIJDjXuLX pA==
Message-ID: <326a9ca4-1ad4-9d5e-c5fd-628130afe26d@sandeen.net>
Date:   Thu, 2 May 2019 09:59:26 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <c12bb330-bb07-ae9c-2812-4fb39e4262dd@sandeen.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

There are several functions which have no opportunity to return
an error, and don't contain any ASSERTs which could be argued
to be better constructed as error cases.  So, make them voids
to simplify the callers.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---

V2: Drop changes to xlog_bdstrat for now, as callers still need
(added) error checking, can do that as separate patch.

V3: Fix commit log typo, drop return at end of void function()

V4: *sigh* re-drop bdstrat.  Somebody take away my keys.

I had sent this a while back, and Darrick had concerns about a
few functions which maybe /should/ return errors; I tried to avoid
changing anything which was remotely close to that case, and stick
to the simple/obvious ones.

diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
index fb5bd9a804f6..88fa11071f9f 100644
--- a/fs/xfs/libxfs/xfs_dquot_buf.c
+++ b/fs/xfs/libxfs/xfs_dquot_buf.c
@@ -110,7 +110,7 @@ xfs_dqblk_verify(
 /*
  * Do some primitive error checking on ondisk dquot data structures.
  */
-int
+void
 xfs_dqblk_repair(
 	struct xfs_mount	*mp,
 	struct xfs_dqblk	*dqb,
@@ -133,8 +133,6 @@ xfs_dqblk_repair(
 		xfs_update_cksum((char *)dqb, sizeof(struct xfs_dqblk),
 				 XFS_DQUOT_CRC_OFF);
 	}
-
-	return 0;
 }
 
 STATIC bool
diff --git a/fs/xfs/libxfs/xfs_quota_defs.h b/fs/xfs/libxfs/xfs_quota_defs.h
index 4bfdd5f4c6af..b2113b17e53c 100644
--- a/fs/xfs/libxfs/xfs_quota_defs.h
+++ b/fs/xfs/libxfs/xfs_quota_defs.h
@@ -142,7 +142,7 @@ extern xfs_failaddr_t xfs_dquot_verify(struct xfs_mount *mp,
 extern xfs_failaddr_t xfs_dqblk_verify(struct xfs_mount *mp,
 		struct xfs_dqblk *dqb, xfs_dqid_t id, uint type);
 extern int xfs_calc_dquots_per_chunk(unsigned int nbblks);
-extern int xfs_dqblk_repair(struct xfs_mount *mp, struct xfs_dqblk *dqb,
+extern void xfs_dqblk_repair(struct xfs_mount *mp, struct xfs_dqblk *dqb,
 		xfs_dqid_t id, uint type);
 
 #endif	/* __XFS_QUOTA_H__ */
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 6fab49f6070b..e76a3e5d28d7 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -1085,7 +1085,7 @@ xfs_sync_sb_buf(
 	return error;
 }
 
-int
+void
 xfs_fs_geometry(
 	struct xfs_sb		*sbp,
 	struct xfs_fsop_geom	*geo,
@@ -1109,13 +1109,13 @@ xfs_fs_geometry(
 	memcpy(geo->uuid, &sbp->sb_uuid, sizeof(sbp->sb_uuid));
 
 	if (struct_version < 2)
-		return 0;
+		return;
 
 	geo->sunit = sbp->sb_unit;
 	geo->swidth = sbp->sb_width;
 
 	if (struct_version < 3)
-		return 0;
+		return;
 
 	geo->version = XFS_FSOP_GEOM_VERSION;
 	geo->flags = XFS_FSOP_GEOM_FLAGS_NLINK |
@@ -1159,7 +1159,7 @@ xfs_fs_geometry(
 	geo->dirblocksize = xfs_dir2_dirblock_bytes(sbp);
 
 	if (struct_version < 4)
-		return 0;
+		return;
 
 	if (xfs_sb_version_haslogv2(sbp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_LOGV2;
@@ -1167,11 +1167,9 @@ xfs_fs_geometry(
 	geo->logsunit = sbp->sb_logsunit;
 
 	if (struct_version < 5)
-		return 0;
+		return;
 
 	geo->version = XFS_FSOP_GEOM_VERSION_V5;
-
-	return 0;
 }
 
 /* Read a secondary superblock. */
diff --git a/fs/xfs/libxfs/xfs_sb.h b/fs/xfs/libxfs/xfs_sb.h
index 13564d69800a..92465a9a5162 100644
--- a/fs/xfs/libxfs/xfs_sb.h
+++ b/fs/xfs/libxfs/xfs_sb.h
@@ -33,7 +33,7 @@ extern void	xfs_sb_quota_from_disk(struct xfs_sb *sbp);
 extern int	xfs_update_secondary_sbs(struct xfs_mount *mp);
 
 #define XFS_FS_GEOM_MAX_STRUCT_VER	(4)
-extern int	xfs_fs_geometry(struct xfs_sb *sbp, struct xfs_fsop_geom *geo,
+extern void	xfs_fs_geometry(struct xfs_sb *sbp, struct xfs_fsop_geom *geo,
 				int struct_version);
 extern int	xfs_sb_read_secondary(struct xfs_mount *mp,
 				struct xfs_trans *tp, xfs_agnumber_t agno,
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 584648582ba7..3d0e0570e3aa 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -289,7 +289,7 @@ xfs_growfs_log(
  * exported through ioctl XFS_IOC_FSCOUNTS
  */
 
-int
+void
 xfs_fs_counts(
 	xfs_mount_t		*mp,
 	xfs_fsop_counts_t	*cnt)
@@ -302,7 +302,6 @@ xfs_fs_counts(
 	spin_lock(&mp->m_sb_lock);
 	cnt->freertx = mp->m_sb.sb_frextents;
 	spin_unlock(&mp->m_sb_lock);
-	return 0;
 }
 
 /*
diff --git a/fs/xfs/xfs_fsops.h b/fs/xfs/xfs_fsops.h
index d023db0862c2..92869f6ec8d3 100644
--- a/fs/xfs/xfs_fsops.h
+++ b/fs/xfs/xfs_fsops.h
@@ -8,7 +8,7 @@
 
 extern int xfs_growfs_data(xfs_mount_t *mp, xfs_growfs_data_t *in);
 extern int xfs_growfs_log(xfs_mount_t *mp, xfs_growfs_log_t *in);
-extern int xfs_fs_counts(xfs_mount_t *mp, xfs_fsop_counts_t *cnt);
+extern void xfs_fs_counts(xfs_mount_t *mp, xfs_fsop_counts_t *cnt);
 extern int xfs_reserve_blocks(xfs_mount_t *mp, uint64_t *inval,
 				xfs_fsop_resblks_t *outval);
 extern int xfs_fs_goingdown(xfs_mount_t *mp, uint32_t inflags);
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 4591598ca04d..71d216cf6f87 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1116,7 +1116,7 @@ xfs_droplink(
 /*
  * Increment the link count on an inode & log the change.
  */
-static int
+static void
 xfs_bumplink(
 	xfs_trans_t *tp,
 	xfs_inode_t *ip)
@@ -1126,7 +1126,6 @@ xfs_bumplink(
 	ASSERT(ip->i_d.di_version > 1);
 	inc_nlink(VFS_I(ip));
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-	return 0;
 }
 
 int
@@ -1235,9 +1234,7 @@ xfs_create(
 		if (error)
 			goto out_trans_cancel;
 
-		error = xfs_bumplink(tp, dp);
-		if (error)
-			goto out_trans_cancel;
+		xfs_bumplink(tp, dp);
 	}
 
 	/*
@@ -1454,9 +1451,7 @@ xfs_link(
 	xfs_trans_ichgtime(tp, tdp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
 	xfs_trans_log_inode(tp, tdp, XFS_ILOG_CORE);
 
-	error = xfs_bumplink(tp, sip);
-	if (error)
-		goto error_return;
+	xfs_bumplink(tp, sip);
 
 	/*
 	 * If this is a synchronous mount, make sure that the
@@ -3097,9 +3092,7 @@ xfs_cross_rename(
 				error = xfs_droplink(tp, dp2);
 				if (error)
 					goto out_trans_abort;
-				error = xfs_bumplink(tp, dp1);
-				if (error)
-					goto out_trans_abort;
+				xfs_bumplink(tp, dp1);
 			}
 
 			/*
@@ -3123,9 +3116,7 @@ xfs_cross_rename(
 				error = xfs_droplink(tp, dp1);
 				if (error)
 					goto out_trans_abort;
-				error = xfs_bumplink(tp, dp2);
-				if (error)
-					goto out_trans_abort;
+				xfs_bumplink(tp, dp2);
 			}
 
 			/*
@@ -3322,9 +3313,7 @@ xfs_rename(
 					XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
 
 		if (new_parent && src_is_directory) {
-			error = xfs_bumplink(tp, target_dp);
-			if (error)
-				goto out_trans_cancel;
+			xfs_bumplink(tp, target_dp);
 		}
 	} else { /* target_ip != NULL */
 		/*
@@ -3443,9 +3432,7 @@ xfs_rename(
 	 */
 	if (wip) {
 		ASSERT(VFS_I(wip)->i_nlink == 0);
-		error = xfs_bumplink(tp, wip);
-		if (error)
-			goto out_trans_cancel;
+		xfs_bumplink(tp, wip);
 		error = xfs_iunlink_remove(tp, wip);
 		if (error)
 			goto out_trans_cancel;
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 21d6f433c375..d7dfc13f30f5 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -788,11 +788,8 @@ xfs_ioc_fsgeometry(
 {
 	struct xfs_fsop_geom	fsgeo;
 	size_t			len;
-	int			error;
 
-	error = xfs_fs_geometry(&mp->m_sb, &fsgeo, struct_version);
-	if (error)
-		return error;
+	xfs_fs_geometry(&mp->m_sb, &fsgeo, struct_version);
 
 	if (struct_version <= 3)
 		len = sizeof(struct xfs_fsop_geom_v1);
@@ -2046,9 +2043,7 @@ xfs_file_ioctl(
 	case XFS_IOC_FSCOUNTS: {
 		xfs_fsop_counts_t out;
 
-		error = xfs_fs_counts(mp, &out);
-		if (error)
-			return error;
+		xfs_fs_counts(mp, &out);
 
 		if (copy_to_user(arg, &out, sizeof(out)))
 			return -EFAULT;
diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index 65997a6315e9..614fc6886d24 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -53,11 +53,8 @@ xfs_compat_ioc_fsgeometry_v1(
 	compat_xfs_fsop_geom_v1_t __user *arg32)
 {
 	struct xfs_fsop_geom	  fsgeo;
-	int			  error;
 
-	error = xfs_fs_geometry(&mp->m_sb, &fsgeo, 3);
-	if (error)
-		return error;
+	xfs_fs_geometry(&mp->m_sb, &fsgeo, 3);
 	/* The 32-bit variant simply has some padding at the end */
 	if (copy_to_user(arg32, &fsgeo, sizeof(struct compat_xfs_fsop_geom_v1)))
 		return -EFAULT;
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 3371d1ff27c4..9329f5adbfbe 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -5167,7 +5167,7 @@ xlog_recover_process_iunlinks(
 	}
 }
 
-STATIC int
+STATIC void
 xlog_unpack_data(
 	struct xlog_rec_header	*rhead,
 	char			*dp,
@@ -5190,8 +5190,6 @@ xlog_unpack_data(
 			dp += BBSIZE;
 		}
 	}
-
-	return 0;
 }
 
 /*
@@ -5206,11 +5204,9 @@ xlog_recover_process(
 	int			pass,
 	struct list_head	*buffer_list)
 {
-	int			error;
 	__le32			old_crc = rhead->h_crc;
 	__le32			crc;
 
-
 	crc = xlog_cksum(log, rhead, dp, be32_to_cpu(rhead->h_len));
 
 	/*
@@ -5249,9 +5245,7 @@ xlog_recover_process(
 			return -EFSCORRUPTED;
 	}
 
-	error = xlog_unpack_data(rhead, dp, log);
-	if (error)
-		return error;
+	xlog_unpack_data(rhead, dp, log);
 
 	return xlog_recover_process_data(log, rhash, rhead, dp, pass,
 					 buffer_list);
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 86c18f2232ca..7668d57c9218 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -448,7 +448,7 @@ struct proc_xfs_info {
 	char		*str;
 };
 
-STATIC int
+STATIC void
 xfs_showargs(
 	struct xfs_mount	*mp,
 	struct seq_file		*m)
@@ -527,9 +527,8 @@ xfs_showargs(
 
 	if (!(mp->m_qflags & XFS_ALL_QUOTA_ACCT))
 		seq_puts(m, ",noquota");
-
-	return 0;
 }
+
 static uint64_t
 xfs_max_file_offset(
 	unsigned int		blockshift)
@@ -1449,7 +1448,8 @@ xfs_fs_show_options(
 	struct seq_file		*m,
 	struct dentry		*root)
 {
-	return xfs_showargs(XFS_M(root->d_sb), m);
+	xfs_showargs(XFS_M(root->d_sb), m);
+	return 0;
 }
 
 /*



