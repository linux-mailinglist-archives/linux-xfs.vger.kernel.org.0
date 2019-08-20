Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3413396A15
	for <lists+linux-xfs@lfdr.de>; Tue, 20 Aug 2019 22:21:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729156AbfHTUVd (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 20 Aug 2019 16:21:33 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:33876 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727358AbfHTUVd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Aug 2019 16:21:33 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7KKJ3iU143537;
        Tue, 20 Aug 2019 20:21:28 GMT
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2ue90th3qh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Aug 2019 20:21:27 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7KKIK3C043131;
        Tue, 20 Aug 2019 20:21:27 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2ugj7pn60v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Aug 2019 20:21:26 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7KKLPrW012599;
        Tue, 20 Aug 2019 20:21:26 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 20 Aug 2019 13:21:25 -0700
Subject: [PATCH 1/1] common: remove old ioctl typedef usage
From:   "Darrick J. Wong" <djwong@maple.djwong.org>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 20 Aug 2019 13:21:24 -0700
Message-ID: <156633248463.1207676.7759376831498692189.stgit@magnolia>
In-Reply-To: <156633247851.1207676.6729479783498588132.stgit@magnolia>
References: <156633247851.1207676.6729479783498588132.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9355 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908200181
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9355 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1034
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908200181
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Convert old xfs_foo_t typedef usage to struct xfs_foo to prepare for the
removal of old ioctl typedefs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/content_inode.h |    4 +--
 common/fs.c            |    2 +
 common/hsmapi.c        |   18 ++++++-----
 common/hsmapi.h        |    6 ++--
 common/util.c          |   30 +++++++++----------
 common/util.h          |   12 ++++----
 doc/xfsdump.html       |    6 ++--
 dump/content.c         |   76 ++++++++++++++++++++++++------------------------
 dump/inomap.c          |   48 +++++++++++++++---------------
 9 files changed, 101 insertions(+), 101 deletions(-)


diff --git a/common/content_inode.h b/common/content_inode.h
index e1885fd..2106c75 100644
--- a/common/content_inode.h
+++ b/common/content_inode.h
@@ -150,8 +150,8 @@ typedef struct timestruct timestruct_t;
 
 /* bstat_t - bulk stat structure
  *
- * used in filehdr_t below. derived from xfs_bstat_t, to achieve independence
- * from changes to xfs_bstat_t.
+ * used in filehdr_t below. derived from struct xfs_bstat, to achieve independence
+ * from changes to struct xfs_bstat.
  */
 #define BSTAT_SZ	128
 #define MODE_SZ		4
diff --git a/common/fs.c b/common/fs.c
index a4c175c..ff8c75a 100644
--- a/common/fs.c
+++ b/common/fs.c
@@ -204,7 +204,7 @@ fs_mounted(char *typs, char *chrs, char *mnts, uuid_t *idp)
 int
 fs_getid(char *mnts, uuid_t *idb)
 {
-	xfs_fsop_geom_v1_t geo;
+	struct xfs_fsop_geom_v1 geo;
 	int fd;
 
 	fd = open(mnts, O_RDONLY);
diff --git a/common/hsmapi.c b/common/hsmapi.c
index e3e18a7..14e6c83 100644
--- a/common/hsmapi.c
+++ b/common/hsmapi.c
@@ -108,7 +108,7 @@ typedef	struct {
 #define	DM_EVENT_TRUNCATE	18
 #define	DM_EVENT_DESTROY	20
 
- /* Interesting bit combinations within the bs_dmevmask field of xfs_bstat_t:
+ /* Interesting bit combinations within the bs_dmevmask field of struct xfs_bstat:
  * OFL, UNM, and PAR files have exactly these bits set.
  * DUL and MIG files have all but the DM_EVENT_READ bit set */
 #define DMF_EV_BITS	((1<<DM_EVENT_DESTROY) | \
@@ -270,7 +270,7 @@ extern int
 HsmEstimateFileSpace(
 	hsm_fs_ctxt_t	*fscontextp,
 	hsm_f_ctxt_t	*fcontextp,
-const	xfs_bstat_t	*statp,
+const	struct xfs_bstat	*statp,
 	off64_t		*bytes,
 	int		accurate)
 {
@@ -353,7 +353,7 @@ const	xfs_bstat_t	*statp,
 extern int
 HsmEstimateFileOffset(
 	hsm_fs_ctxt_t	*contextp,
-const	xfs_bstat_t	*statp,
+const	struct xfs_bstat	*statp,
 	off64_t		bytecount,
 	off64_t		*byteoffset)
 {
@@ -458,7 +458,7 @@ HsmDeleteFileContext(
 extern int
 HsmInitFileContext(
 	hsm_f_ctxt_t	*contextp,
-const	xfs_bstat_t	*statp)
+const	struct xfs_bstat	*statp)
 {
 	dmf_f_ctxt_t	*dmf_f_ctxtp = (dmf_f_ctxt_t *)contextp;
 	XFSattrvalue0_t	*dmfattrp;
@@ -492,7 +492,7 @@ const	xfs_bstat_t	*statp)
 	attr_op.am_flags     = ATTR_ROOT;
 
 	error = jdm_attr_multi(dmf_f_ctxtp->fsys.fshanp,
-			       (xfs_bstat_t *)statp,
+			       (struct xfs_bstat *)statp,
 			       (char *)&attr_op,
 			       1,
 			       0);
@@ -538,22 +538,22 @@ const	xfs_bstat_t	*statp)
 
 /******************************************************************************
 * Name
-*	HsmModifyInode - modify a xfs_bstat_t to make a file appear offline
+*	HsmModifyInode - modify a struct xfs_bstat to make a file appear offline
 *
 * Description
 *	HsmModifyInode uses the context provided by a previous
-*	HsmInitFileContext call to determine how to modify a xfs_bstat_t
+*	HsmInitFileContext call to determine how to modify a struct xfs_bstat
 *	structure to make a dual-residency HSM file appear to be offline.
 *
 * Returns
-*	!= 0, xfs_bstat_t structure was modified.
+*	!= 0, struct xfs_bstat structure was modified.
 *	== 0, if something is wrong with the file and it should not be dumped.
 ******************************************************************************/
 
 extern int
 HsmModifyInode(
 	hsm_f_ctxt_t	*contextp,
-	xfs_bstat_t	*statp)
+	struct xfs_bstat	*statp)
 {
 	dmf_f_ctxt_t	*dmf_f_ctxtp = (dmf_f_ctxt_t *)contextp;
 
diff --git a/common/hsmapi.h b/common/hsmapi.h
index 63933af..4b88c16 100644
--- a/common/hsmapi.h
+++ b/common/hsmapi.h
@@ -186,15 +186,15 @@ const	struct xfs_bstat	*statp);
 
 /******************************************************************************
 * Name
-*	HsmModifyInode - modify a xfs_bstat_t to make a file appear offline
+*	HsmModifyInode - modify a struct xfs_bstat to make a file appear offline
 *
 * Description
 *	HsmModifyInode uses the context provided by a previous
-*	HsmInitFileContext call to determine how to modify a xfs_bstat_t
+*	HsmInitFileContext call to determine how to modify a struct xfs_bstat
 *	structure to make a dual-residency HSM file appear to be offline.
 *
 * Returns
-*	!= 0, xfs_bstat_t structure was modified.
+*	!= 0, struct xfs_bstat structure was modified.
 *	== 0, if something is wrong with the file and it should not be dumped.
 ******************************************************************************/
 
diff --git a/common/util.c b/common/util.c
index 05a5cb8..bcd7db9 100644
--- a/common/util.c
+++ b/common/util.c
@@ -125,14 +125,14 @@ bigstat_iter(jdm_fshandle_t *fshandlep,
 	      void * seek_arg1,
 	      int *statp,
 	      bool_t (pfp)(int),
-	      xfs_bstat_t *buf,
+	      struct xfs_bstat *buf,
 	      size_t buflenin)
 {
 	__s32 buflenout;
 	xfs_ino_t lastino;
 	int saved_errno;
 	int bulkstatcnt;
-        xfs_fsop_bulkreq_t bulkreq;
+        struct xfs_fsop_bulkreq bulkreq;
 
 	/* stat set with return from callback func
 	 */
@@ -162,8 +162,8 @@ bigstat_iter(jdm_fshandle_t *fshandlep,
 	bulkreq.ubuffer = buf;
 	bulkreq.ocount = &buflenout;
 	while (!ioctl(fsfd, XFS_IOC_FSBULKSTAT, &bulkreq)) {
-		xfs_bstat_t *p;
-		xfs_bstat_t *endp;
+		struct xfs_bstat *p;
+		struct xfs_bstat *endp;
 
 		if (buflenout == 0) {
 			mlog(MLOG_NITTY + 1,
@@ -254,9 +254,9 @@ bigstat_iter(jdm_fshandle_t *fshandlep,
 int
 bigstat_one(int fsfd,
 	     xfs_ino_t ino,
-	     xfs_bstat_t *statp)
+	     struct xfs_bstat *statp)
 {
-        xfs_fsop_bulkreq_t bulkreq;
+        struct xfs_fsop_bulkreq bulkreq;
 	int count = 0;
 
 	assert(ino > 0);
@@ -274,23 +274,23 @@ int
 inogrp_iter(int fsfd,
 	     int (*fp)(void *arg1,
 				int fsfd,
-				xfs_inogrp_t *inogrp),
+				struct xfs_inogrp *inogrp),
 	     void * arg1,
 	     int *statp)
 {
 	xfs_ino_t lastino;
 	int inogrpcnt;
-	xfs_inogrp_t *igrp;
-        xfs_fsop_bulkreq_t bulkreq;
+	struct xfs_inogrp *igrp;
+        struct xfs_fsop_bulkreq bulkreq;
 
 	/* stat set with return from callback func */
 	*statp = 0;
 
-	igrp = malloc(INOGRPLEN * sizeof(xfs_inogrp_t));
+	igrp = malloc(INOGRPLEN * sizeof(struct xfs_inogrp));
 	if (!igrp) {
 		mlog(MLOG_NORMAL | MLOG_ERROR,
 		     _("malloc of stream context failed (%d bytes): %s\n"),
-		     INOGRPLEN * sizeof(xfs_inogrp_t),
+		     INOGRPLEN * sizeof(struct xfs_inogrp),
 		     strerror(errno));
 		return -1;
 	}
@@ -302,7 +302,7 @@ inogrp_iter(int fsfd,
 	bulkreq.ubuffer = igrp;
 	bulkreq.ocount = &inogrpcnt;
 	while (!ioctl(fsfd, XFS_IOC_FSINUMBERS, &bulkreq)) {
-		xfs_inogrp_t *p, *endp;
+		struct xfs_inogrp *p, *endp;
 
 		if (inogrpcnt == 0) {
 			free(igrp);
@@ -339,11 +339,11 @@ inogrp_iter(int fsfd,
 int
 diriter(jdm_fshandle_t *fshandlep,
 	 int fsfd,
-	 xfs_bstat_t *statp,
+	 struct xfs_bstat *statp,
 	 int (*cbfp)(void *arg1,
 			     jdm_fshandle_t *fshandlep,
 			     int fsfd,
-			     xfs_bstat_t *statp,
+			     struct xfs_bstat *statp,
 			     char *namep),
 	 void *arg1,
 	 int *cbrvalp,
@@ -428,7 +428,7 @@ diriter(jdm_fshandle_t *fshandlep,
 		      assert(nread >= 0),
 		      p = (struct dirent *)((char *)p + reclen),
 		      reclen = (size_t)p->d_reclen) {
-			xfs_bstat_t statbuf;
+			struct xfs_bstat statbuf;
 			assert(scrval == 0);
 			assert(cbrval == 0);
 
diff --git a/common/util.h b/common/util.h
index 9e8bb6f..a7692e0 100644
--- a/common/util.h
+++ b/common/util.h
@@ -87,7 +87,7 @@ extern char *strncpyterm(char *s1, char *s2, size_t n);
 typedef int (*bstat_cbfp_t)(void *arg1,
 				 jdm_fshandle_t *fshandlep,
 				 int fsfd,
-				 xfs_bstat_t *statp);
+				 struct xfs_bstat *statp);
 
 typedef xfs_ino_t (*bstat_seekfp_t)(void *arg1,
 				    xfs_ino_t lastino);
@@ -102,17 +102,17 @@ extern int bigstat_iter(jdm_fshandle_t *fshandlep,
 			      void * seek_arg1,
 			      int *statp,
 			      bool_t (pfp)(int), /* preemption chk func */
-			      xfs_bstat_t *buf,
+			      struct xfs_bstat *buf,
 			      size_t buflen);
 
 extern int bigstat_one(int fsfd,
 			     xfs_ino_t ino,
-			     xfs_bstat_t *statp);
+			     struct xfs_bstat *statp);
 
 extern int inogrp_iter(int fsfd,
 			     int (*fp)(void *arg1,
 				     		int fsfd,
-						xfs_inogrp_t *inogrp),
+						struct xfs_inogrp *inogrp),
 			     void * arg1,
 			     int *statp);
 
@@ -131,11 +131,11 @@ extern int inogrp_iter(int fsfd,
  */
 extern int diriter(jdm_fshandle_t *fshandlep,
 			 int fsfd,
-			 xfs_bstat_t *statp,
+			 struct xfs_bstat *statp,
 			 int (*cbfp)(void *arg1,
 					     jdm_fshandle_t *fshandlep,
 					     int fsfd,
-					     xfs_bstat_t *statp,
+					     struct xfs_bstat *statp,
 					     char *namep),
 			 void *arg1,
 			 int *cbrvalp,
diff --git a/doc/xfsdump.html b/doc/xfsdump.html
index 8cc02d4..6aa09f0 100644
--- a/doc/xfsdump.html
+++ b/doc/xfsdump.html
@@ -513,9 +513,9 @@ create inode-ranges for multi-stream dumps if pertinent.
       - bigstat_init on cb_add()
 	  - loops doing bulkstats (using syssgi() or ioctl())
 	    until system call returns non-zero value
-	  - each bulkstat returns a buffer of xfs_bstat_t records
+	  - each bulkstat returns a buffer of struct xfs_bstat records
 	    (buffer of size bulkreq.ocount)
-	  - loop thru each xfs_bstat_t record for an inode  
+	  - loop thru each struct xfs_bstat record for an inode  
 	    calling cb_add()
 	  * cb_add
 	    - looks at latest mtime|ctime and 
@@ -629,7 +629,7 @@ create inode-ranges for multi-stream dumps if pertinent.
         * dump_filehdr()
           - write out 256 padded file header
           - header = &lt;offset, flags, checksum, 128-byte bulk stat structure &gt;
-          - bulkstat struct derived from xfs_bstat_t 
+          - bulkstat struct derived from struct xfs_bstat 
             - stnd. stat stuff + extent size, #of extents, DMI stuff
           - if HSM context then 
             - modify bstat struct to make it offline
diff --git a/dump/content.c b/dump/content.c
index d9a53d1..98aa226 100644
--- a/dump/content.c
+++ b/dump/content.c
@@ -262,30 +262,30 @@ extern size_t pgsz;
 /* file dumpers
  */
 static rv_t dump_dirs(ix_t strmix,
-		       xfs_bstat_t *bstatbufp,
+		       struct xfs_bstat *bstatbufp,
 		       size_t bstatbuflen,
 		       void *inomap_contextp);
 static rv_t dump_dir(ix_t strmix,
 		      jdm_fshandle_t *,
 		      int,
-		      xfs_bstat_t *);
+		      struct xfs_bstat *);
 static rv_t dump_file(void *,
 		       jdm_fshandle_t *,
 		       int,
-		       xfs_bstat_t *);
+		       struct xfs_bstat *);
 static rv_t dump_file_reg(drive_t *drivep,
 			   context_t *contextp,
 			   content_inode_hdr_t *scwhdrp,
 			   jdm_fshandle_t *,
-			   xfs_bstat_t *,
+			   struct xfs_bstat *,
 			   bool_t *);
 static rv_t dump_file_spec(drive_t *drivep,
 			    context_t *contextp,
 			    jdm_fshandle_t *,
-			    xfs_bstat_t *);
+			    struct xfs_bstat *);
 static rv_t dump_filehdr(drive_t *drivep,
 			  context_t *contextp,
-			  xfs_bstat_t *,
+			  struct xfs_bstat *,
 			  off64_t,
 			  int);
 static rv_t dump_extenthdr(drive_t *drivep,
@@ -296,18 +296,18 @@ static rv_t dump_extenthdr(drive_t *drivep,
 			    off64_t);
 static rv_t dump_dirent(drive_t *drivep,
 			 context_t *contextp,
-			 xfs_bstat_t *,
+			 struct xfs_bstat *,
 			 xfs_ino_t,
 			 gen_t,
 			 char *,
 			 size_t);
 static rv_t init_extent_group_context(jdm_fshandle_t *,
-				       xfs_bstat_t *,
+				       struct xfs_bstat *,
 				       extent_group_context_t *);
 static void cleanup_extent_group_context(extent_group_context_t *);
 static rv_t dump_extent_group(drive_t *drivep,
 			       context_t *contextp,
-			       xfs_bstat_t *,
+			       struct xfs_bstat *,
 			       extent_group_context_t *,
 			       off64_t,
 			       off64_t,
@@ -352,15 +352,15 @@ static bool_t check_complete_flags(void);
 static rv_t dump_extattrs(drive_t *drivep,
 			   context_t *contextp,
 	       		   jdm_fshandle_t *fshandlep,
-			   xfs_bstat_t *statp);
+			   struct xfs_bstat *statp);
 static rv_t dump_extattr_list(drive_t *drivep,
 			       context_t *contextp,
 	       		       jdm_fshandle_t *fshandlep,
-			       xfs_bstat_t *statp,
+			       struct xfs_bstat *statp,
 			       attrlist_t *listp,
 			       int flag,
 			       bool_t *abortprp);
-static char *dump_extattr_buildrecord(xfs_bstat_t *statp,
+static char *dump_extattr_buildrecord(struct xfs_bstat *statp,
 				       char *dumpbufp,
 				       char *dumpbufendp,
 				       char *namesrcp,
@@ -369,7 +369,7 @@ static char *dump_extattr_buildrecord(xfs_bstat_t *statp,
 				       char **valuepp);
 static rv_t dump_extattrhdr(drive_t *drivep,
 			     context_t *contextp,
-			     xfs_bstat_t *statp,
+			     struct xfs_bstat *statp,
 			     size_t recsz,
 			     size_t valoff,
 			     ix_t flags,
@@ -432,7 +432,7 @@ static jdm_fshandle_t *sc_fshandlep = 0;
 static int sc_fsfd = -1;
 	/* open file descriptor for root directory
 	 */
-static xfs_bstat_t *sc_rootxfsstatp = 0;
+static struct xfs_bstat *sc_rootxfsstatp = 0;
 	/* pointer to loaded bulkstat for root directory
 	 */
 static startpt_t *sc_startptp = 0;
@@ -1382,7 +1382,7 @@ content_init(int argc,
 	}
 
 	/* figure out the ino for the root directory of the fs
-	 * and get its xfs_bstat_t for inomap_build().  This could
+	 * and get its struct xfs_bstat for inomap_build().  This could
 	 * be a bind mount; don't ask for the mount point inode,
 	 * find the actual lowest inode number in the filesystem.
 	 */
@@ -1390,7 +1390,7 @@ content_init(int argc,
 		stat64_t rootstat;
 		xfs_ino_t lastino = 0;
 		int ocount = 0;
-		xfs_fsop_bulkreq_t bulkreq;
+		struct xfs_fsop_bulkreq bulkreq;
 
 		/* Get the inode of the mount point */
 		rval = fstat64(sc_fsfd, &rootstat);
@@ -1401,7 +1401,7 @@ content_init(int argc,
 			return BOOL_FALSE;
 		}
 		sc_rootxfsstatp =
-			(xfs_bstat_t *)calloc(1, sizeof(xfs_bstat_t));
+			(struct xfs_bstat *)calloc(1, sizeof(struct xfs_bstat));
 		assert(sc_rootxfsstatp);
 
 		/* Get the first valid (i.e. root) inode in this fs */
@@ -2119,7 +2119,7 @@ content_stream_dump(ix_t strmix)
 	bool_t empty_mediafile;
 	time_t elapsed;
 	inv_stmtoken_t inv_stmt;
-	xfs_bstat_t *bstatbufp;
+	struct xfs_bstat *bstatbufp;
 	const size_t bstatbuflen = BSTATBUFLEN;
 	int rval;
 	rv_t rv;
@@ -2130,8 +2130,8 @@ content_stream_dump(ix_t strmix)
 
 	/* allocate a buffer for use by bstat_iter
 	 */
-	bstatbufp = (xfs_bstat_t *)calloc(bstatbuflen,
-					     sizeof(xfs_bstat_t));
+	bstatbufp = (struct xfs_bstat *)calloc(bstatbuflen,
+					     sizeof(struct xfs_bstat));
 	assert(bstatbufp);
 
 	/* allocate an inomap context */
@@ -2806,13 +2806,13 @@ update_cc_Media_useterminatorpr(drive_t *drivep, context_t *contextp)
 
 static rv_t
 dump_dirs(ix_t strmix,
-	   xfs_bstat_t *bstatbufp,
+	   struct xfs_bstat *bstatbufp,
 	   size_t bstatbuflen,
 	   void *inomap_contextp)
 {
 	xfs_ino_t lastino;
 	size_t bulkstatcallcnt;
-        xfs_fsop_bulkreq_t bulkreq;
+        struct xfs_fsop_bulkreq bulkreq;
 
 	inomap_reset_context(inomap_contextp);
 
@@ -2820,8 +2820,8 @@ dump_dirs(ix_t strmix,
 	 */
 	lastino = 0;
 	for (bulkstatcallcnt = 0 ; ; bulkstatcallcnt++) {
-		xfs_bstat_t *p;
-		xfs_bstat_t *endp;
+		struct xfs_bstat *p;
+		struct xfs_bstat *endp;
 		__s32 buflenout;
 		int rval;
 
@@ -2928,7 +2928,7 @@ static rv_t
 dump_dir(ix_t strmix,
 	  jdm_fshandle_t *fshandlep,
 	  int fsfd,
-	  xfs_bstat_t *statp)
+	  struct xfs_bstat *statp)
 {
 	context_t *contextp = &sc_contextp[strmix];
 	drive_t *drivep = drivepp[strmix];
@@ -3110,7 +3110,7 @@ dump_dir(ix_t strmix,
 			 * if it's not there, we have to get it the slow way.
 			 */
 			if (inomap_get_gen(NULL, p->d_ino, &gen)) {
-				xfs_bstat_t statbuf;
+				struct xfs_bstat statbuf;
 				int scrval;
 
 				scrval = bigstat_one(fsfd,
@@ -3169,7 +3169,7 @@ static rv_t
 dump_extattrs(drive_t *drivep,
 	       context_t *contextp,
 	       jdm_fshandle_t *fshandlep,
-	       xfs_bstat_t *statp)
+	       struct xfs_bstat *statp)
 {
 	ix_t pass;
 	int flag;
@@ -3269,7 +3269,7 @@ static rv_t
 dump_extattr_list(drive_t *drivep,
 		   context_t *contextp,
 		   jdm_fshandle_t *fshandlep,
-		   xfs_bstat_t *statp,
+		   struct xfs_bstat *statp,
 		   attrlist_t *listp,
 		   int flag,
 		   bool_t *abortprp)
@@ -3572,7 +3572,7 @@ dump_extattr_list(drive_t *drivep,
 }
 
 static char *
-dump_extattr_buildrecord(xfs_bstat_t *statp,
+dump_extattr_buildrecord(struct xfs_bstat *statp,
 			  char *dumpbufp,
 			  char *dumpbufendp,
 			  char *namesrcp,
@@ -3655,7 +3655,7 @@ dump_extattr_buildrecord(xfs_bstat_t *statp,
 static rv_t
 dump_extattrhdr(drive_t *drivep,
 		 context_t *contextp,
-		 xfs_bstat_t *statp,
+		 struct xfs_bstat *statp,
 		 size_t recsz,
 		 size_t valoff,
 		 ix_t flags,
@@ -3712,7 +3712,7 @@ static rv_t
 dump_file(void *arg1,
 	   jdm_fshandle_t *fshandlep,
 	   int fsfd,
-	   xfs_bstat_t *statp)
+	   struct xfs_bstat *statp)
 {
 	ix_t strmix = (ix_t)arg1;
 	context_t *contextp = &sc_contextp[strmix];
@@ -3942,7 +3942,7 @@ dump_file_reg(drive_t *drivep,
 	       context_t *contextp,
 	       content_inode_hdr_t *scwhdrp,
 	       jdm_fshandle_t *fshandlep,
-	       xfs_bstat_t *statp,
+	       struct xfs_bstat *statp,
 	       bool_t *file_skippedp)
 {
 	startpt_t *startptp = &scwhdrp->cih_startpt;
@@ -4163,7 +4163,7 @@ static rv_t
 dump_file_spec(drive_t *drivep,
 		context_t *contextp,
 		jdm_fshandle_t *fshandlep,
-		xfs_bstat_t *statp)
+		struct xfs_bstat *statp)
 {
 	int rval;
 	rv_t rv;
@@ -4277,7 +4277,7 @@ dump_file_spec(drive_t *drivep,
  */
 static rv_t
 init_extent_group_context(jdm_fshandle_t *fshandlep,
-			   xfs_bstat_t *statp,
+			   struct xfs_bstat *statp,
 			   extent_group_context_t *gcp)
 {
 	bool_t isrealtime;
@@ -4340,7 +4340,7 @@ cleanup_extent_group_context(extent_group_context_t *gcp)
 static rv_t
 dump_extent_group(drive_t *drivep,
 		   context_t *contextp,
-		   xfs_bstat_t *statp,
+		   struct xfs_bstat *statp,
 		   extent_group_context_t *gcp,
 		   off64_t maxcnt,
 		   off64_t stopoffset,
@@ -4932,7 +4932,7 @@ dump_extent_group(drive_t *drivep,
 
 /* Note: assumes the pad fields in dst have been zeroed. */
 static void
-copy_xfs_bstat(bstat_t *dst, xfs_bstat_t *src)
+copy_xfs_bstat(bstat_t *dst, struct xfs_bstat *src)
 {
 	dst->bs_ino = src->bs_ino;
 	dst->bs_mode = src->bs_mode;
@@ -4963,7 +4963,7 @@ copy_xfs_bstat(bstat_t *dst, xfs_bstat_t *src)
 static rv_t
 dump_filehdr(drive_t *drivep,
 	      context_t *contextp,
-	      xfs_bstat_t *statp,
+	      struct xfs_bstat *statp,
 	      off64_t offset,
 	      int flags)
 {
@@ -5086,7 +5086,7 @@ dump_extenthdr(drive_t *drivep,
 static rv_t
 dump_dirent(drive_t *drivep,
 	     context_t *contextp,
-	     xfs_bstat_t *statp,
+	     struct xfs_bstat *statp,
 	     xfs_ino_t ino,
 	     gen_t gen,
 	     char *name,
diff --git a/dump/inomap.c b/dump/inomap.c
index 86d6072..85f76df 100644
--- a/dump/inomap.c
+++ b/dump/inomap.c
@@ -79,9 +79,9 @@ static int cb_context(bool_t last,
 			    bool_t,
 			    bool_t *);
 static void cb_context_free(void);
-static int cb_count_inogrp(void *, int, xfs_inogrp_t *);
-static int cb_add_inogrp(void *, int, xfs_inogrp_t *);
-static int cb_add(void *, jdm_fshandle_t *, int, xfs_bstat_t *);
+static int cb_count_inogrp(void *, int, struct xfs_inogrp *);
+static int cb_add_inogrp(void *, int, struct xfs_inogrp *);
+static int cb_add(void *, jdm_fshandle_t *, int, struct xfs_bstat *);
 static bool_t cb_inoinresumerange(xfs_ino_t);
 static bool_t cb_inoresumed(xfs_ino_t);
 static void cb_accuminit_sz(void);
@@ -89,14 +89,14 @@ static void cb_spinit(void);
 static int cb_startpt(void *,
 			    jdm_fshandle_t *,
 			    int,
-			    xfs_bstat_t *);
+			    struct xfs_bstat *);
 static int supprt_prune(void *,
 			      jdm_fshandle_t *,
 			      int,
-			      xfs_bstat_t *,
+			      struct xfs_bstat *,
 			      char *);
-static off64_t quantity2offset(jdm_fshandle_t *, xfs_bstat_t *, off64_t);
-static off64_t estimate_dump_space(xfs_bstat_t *);
+static off64_t quantity2offset(jdm_fshandle_t *, struct xfs_bstat *, off64_t);
+static off64_t estimate_dump_space(struct xfs_bstat *);
 
 /* inomap primitives
  */
@@ -110,16 +110,16 @@ static void inomap_set_gen(void *, xfs_ino_t, gen_t);
 static int subtree_descend_cb(void *,
 				    jdm_fshandle_t *,
 				    int fsfd,
-				    xfs_bstat_t *,
+				    struct xfs_bstat *,
 				    char *);
 static int subtreelist_parse_cb(void *,
 				      jdm_fshandle_t *,
 				      int fsfd,
-				      xfs_bstat_t *,
+				      struct xfs_bstat *,
 				      char *);
 static int subtreelist_parse(jdm_fshandle_t *,
 				   int,
-				   xfs_bstat_t *,
+				   struct xfs_bstat *,
 				   char *[],
 				   ix_t);
 
@@ -144,7 +144,7 @@ static uint64_t inomap_exclude_skipattr = 0;
 bool_t
 inomap_build(jdm_fshandle_t *fshandlep,
 	      int fsfd,
-	      xfs_bstat_t *rootstatp,
+	      struct xfs_bstat *rootstatp,
 	      bool_t last,
 	      time32_t lasttime,
 	      bool_t resume,
@@ -161,7 +161,7 @@ inomap_build(jdm_fshandle_t *fshandlep,
 	      size64_t statcnt,
 	      size64_t *statdonep)
 {
-	xfs_bstat_t *bstatbufp;
+	struct xfs_bstat *bstatbufp;
 	size_t bstatbuflen;
 	bool_t pruneneeded = BOOL_FALSE;
 	int igrpcnt = 0;
@@ -185,10 +185,10 @@ inomap_build(jdm_fshandle_t *fshandlep,
 	/* allocate a bulkstat buf
 	 */
 	bstatbuflen = BSTATBUFLEN;
-	bstatbufp = (xfs_bstat_t *)memalign(pgsz,
+	bstatbufp = (struct xfs_bstat *)memalign(pgsz,
 					       bstatbuflen
 					       *
-					       sizeof(xfs_bstat_t));
+					       sizeof(struct xfs_bstat));
 	assert(bstatbufp);
 
 	/* count the number of inode groups, which will serve as a
@@ -488,7 +488,7 @@ cb_context_free(void)
 }
 
 static int
-cb_count_inogrp(void *arg1, int fsfd, xfs_inogrp_t *inogrp)
+cb_count_inogrp(void *arg1, int fsfd, struct xfs_inogrp *inogrp)
 {
 	int *count = (int *)arg1;
 	(*count)++;
@@ -505,7 +505,7 @@ static int
 cb_add(void *arg1,
 	jdm_fshandle_t *fshandlep,
 	int fsfd,
-	xfs_bstat_t *statp)
+	struct xfs_bstat *statp)
 {
 	register time32_t mtime = statp->bs_mtime.tv_sec;
 	register time32_t ctime = statp->bs_ctime.tv_sec;
@@ -691,7 +691,7 @@ static bool_t			/* false, used as diriter callback */
 supprt_prune(void *arg1,	/* ancestors marked as changed? */
 	      jdm_fshandle_t *fshandlep,
 	      int fsfd,
-	      xfs_bstat_t *statp,
+	      struct xfs_bstat *statp,
 	      char *name)
 {
 	static bool_t cbrval = BOOL_FALSE;
@@ -812,7 +812,7 @@ static int
 cb_startpt(void *arg1,
 	    jdm_fshandle_t *fshandlep,
 	    int fsfd,
-	    xfs_bstat_t *statp)
+	    struct xfs_bstat *statp)
 {
 	register int state;
 
@@ -1116,7 +1116,7 @@ inomap_lastseg(int hnkoff)
  * order. adds a new segment to the inomap and ino-to-gen map.
  */
 static int
-cb_add_inogrp(void *arg1, int fsfd, xfs_inogrp_t *inogrp)
+cb_add_inogrp(void *arg1, int fsfd, struct xfs_inogrp *inogrp)
 {
 	hnk_t *hunk;
 	seg_t *segp;
@@ -1472,7 +1472,7 @@ inomap_dump(drive_t *drivep)
 static int
 subtreelist_parse(jdm_fshandle_t *fshandlep,
 		   int fsfd,
-		   xfs_bstat_t *rootstatp,
+		   struct xfs_bstat *rootstatp,
 		   char *subtreebuf[],
 		   ix_t subtreecnt)
 {
@@ -1513,7 +1513,7 @@ static int
 subtreelist_parse_cb(void *arg1,
 		      jdm_fshandle_t *fshandlep,
 		      int fsfd,
-		      xfs_bstat_t *statp,
+		      struct xfs_bstat *statp,
 		      char *name)
 {
 	int cbrval = 0;
@@ -1596,7 +1596,7 @@ static int
 subtree_descend_cb(void *arg1,
 		    jdm_fshandle_t *fshandlep,
 		    int fsfd,
-		    xfs_bstat_t *statp,
+		    struct xfs_bstat *statp,
 		    char *name)
 {
 	int cbrval = 0;
@@ -1624,7 +1624,7 @@ subtree_descend_cb(void *arg1,
 #define BMAP_LEN	512
 
 static off64_t
-quantity2offset(jdm_fshandle_t *fshandlep, xfs_bstat_t *statp, off64_t qty)
+quantity2offset(jdm_fshandle_t *fshandlep, struct xfs_bstat *statp, off64_t qty)
 {
 	int fd;
 	getbmapx_t bmap[BMAP_LEN];
@@ -1699,7 +1699,7 @@ quantity2offset(jdm_fshandle_t *fshandlep, xfs_bstat_t *statp, off64_t qty)
 
 
 static off64_t
-estimate_dump_space(xfs_bstat_t *statp)
+estimate_dump_space(struct xfs_bstat *statp)
 {
 	switch (statp->bs_mode & S_IFMT) {
 	case S_IFREG:

