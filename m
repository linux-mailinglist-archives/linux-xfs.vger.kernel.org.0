Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B9D2388DB7
	for <lists+linux-xfs@lfdr.de>; Wed, 19 May 2021 14:13:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353345AbhESMOs (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 19 May 2021 08:14:48 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:41481 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1353358AbhESMOp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 May 2021 08:14:45 -0400
Received: from dread.disaster.area (pa49-195-118-180.pa.nsw.optusnet.com.au [49.195.118.180])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 92C5980B77B
        for <linux-xfs@vger.kernel.org>; Wed, 19 May 2021 22:13:20 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ljL4i-002m1H-3c
        for linux-xfs@vger.kernel.org; Wed, 19 May 2021 22:13:20 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1ljL4h-002SHM-SI
        for linux-xfs@vger.kernel.org; Wed, 19 May 2021 22:13:19 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 19/39] xfs: log ticket region debug is largely useless
Date:   Wed, 19 May 2021 22:12:57 +1000
Message-Id: <20210519121317.585244-20-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210519121317.585244-1-david@fromorbit.com>
References: <20210519121317.585244-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=xcwBwyABtj18PbVNKPPJDQ==:117 a=xcwBwyABtj18PbVNKPPJDQ==:17
        a=5FLXtPjwQuUA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
        a=hXrHYZd4HXSh28dySQwA:9 a=ZBBUq1ay7XXbTIux:21 a=PseHVoqCgIdsv_9O:21
        a=AjGcO6oz07-iQ99wixmX:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

xlog_tic_add_region() is used to trace the regions being added to a
log ticket to provide information in the situation where a ticket
reservation overrun occurs. The information gathered is stored int
the ticket, and dumped if xlog_print_tic_res() is called.

For a front end struct xfs_trans overrun, the ticket only contains
reservation tracking information - the ticket is never handed to the
log so has no regions attached to it. The overrun debug information in this
case comes from xlog_print_trans(), which walks the items attached
to the transaction and dumps their attached formatted log vectors
directly. It also dumps the ticket state, but that only contains
reservation accounting and nothing else. Hence xlog_print_tic_res()
never dumps region or overrun information from this path.

xlog_tic_add_region() is actually called from xlog_write(), which
means it is being used to track the regions seen in a
CIL checkpoint log vector chain. In looking at CIL behaviour
recently, I've seen 32MB checkpoints regularly exceed 250,000
regions in the LV chain. The log ticket debug code can track *15*
regions. IOWs, if there is a ticket overrun in the CIL code, the
ticket region tracking code is going to be completely useless for
determining what went wrong. The only thing it can tell us is how
much of an overrun occurred, and we really don't need extra debug
information in the log ticket to tell us that.

Indeed, the main place we call xlog_tic_add_region() is also adding
up the number of regions and the space used so that xlog_write()
knows how much will be written to the log. This is exactly the same
information that log ticket is storing once we take away the useless
region tracking array. Hence xlog_tic_add_region() is not useful,
but can be called 250,000 times a CIL push...

Just strip all that debug "information" out of the of the log ticket
and only have it report reservation space information when an
overrun occurs. This also reduces the size of a log ticket down by
about 150 bytes...

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_log.c      | 107 +++---------------------------------------
 fs/xfs/xfs_log_priv.h |  20 --------
 2 files changed, 6 insertions(+), 121 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 48890fb6122e..e849f15e9e04 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -377,30 +377,6 @@ xlog_grant_head_check(
 	return error;
 }
 
-static void
-xlog_tic_reset_res(xlog_ticket_t *tic)
-{
-	tic->t_res_num = 0;
-	tic->t_res_arr_sum = 0;
-	tic->t_res_num_ophdrs = 0;
-}
-
-static void
-xlog_tic_add_region(xlog_ticket_t *tic, uint len, uint type)
-{
-	if (tic->t_res_num == XLOG_TIC_LEN_MAX) {
-		/* add to overflow and start again */
-		tic->t_res_o_flow += tic->t_res_arr_sum;
-		tic->t_res_num = 0;
-		tic->t_res_arr_sum = 0;
-	}
-
-	tic->t_res_arr[tic->t_res_num].r_len = len;
-	tic->t_res_arr[tic->t_res_num].r_type = type;
-	tic->t_res_arr_sum += len;
-	tic->t_res_num++;
-}
-
 bool
 xfs_log_writable(
 	struct xfs_mount	*mp)
@@ -450,8 +426,6 @@ xfs_log_regrant(
 	xlog_grant_push_ail(log, tic->t_unit_res);
 
 	tic->t_curr_res = tic->t_unit_res;
-	xlog_tic_reset_res(tic);
-
 	if (tic->t_cnt > 0)
 		return 0;
 
@@ -2077,63 +2051,11 @@ xlog_print_tic_res(
 	struct xfs_mount	*mp,
 	struct xlog_ticket	*ticket)
 {
-	uint i;
-	uint ophdr_spc = ticket->t_res_num_ophdrs * (uint)sizeof(xlog_op_header_t);
-
-	/* match with XLOG_REG_TYPE_* in xfs_log.h */
-#define REG_TYPE_STR(type, str)	[XLOG_REG_TYPE_##type] = str
-	static char *res_type_str[] = {
-	    REG_TYPE_STR(BFORMAT, "bformat"),
-	    REG_TYPE_STR(BCHUNK, "bchunk"),
-	    REG_TYPE_STR(EFI_FORMAT, "efi_format"),
-	    REG_TYPE_STR(EFD_FORMAT, "efd_format"),
-	    REG_TYPE_STR(IFORMAT, "iformat"),
-	    REG_TYPE_STR(ICORE, "icore"),
-	    REG_TYPE_STR(IEXT, "iext"),
-	    REG_TYPE_STR(IBROOT, "ibroot"),
-	    REG_TYPE_STR(ILOCAL, "ilocal"),
-	    REG_TYPE_STR(IATTR_EXT, "iattr_ext"),
-	    REG_TYPE_STR(IATTR_BROOT, "iattr_broot"),
-	    REG_TYPE_STR(IATTR_LOCAL, "iattr_local"),
-	    REG_TYPE_STR(QFORMAT, "qformat"),
-	    REG_TYPE_STR(DQUOT, "dquot"),
-	    REG_TYPE_STR(QUOTAOFF, "quotaoff"),
-	    REG_TYPE_STR(LRHEADER, "LR header"),
-	    REG_TYPE_STR(UNMOUNT, "unmount"),
-	    REG_TYPE_STR(COMMIT, "commit"),
-	    REG_TYPE_STR(TRANSHDR, "trans header"),
-	    REG_TYPE_STR(ICREATE, "inode create"),
-	    REG_TYPE_STR(RUI_FORMAT, "rui_format"),
-	    REG_TYPE_STR(RUD_FORMAT, "rud_format"),
-	    REG_TYPE_STR(CUI_FORMAT, "cui_format"),
-	    REG_TYPE_STR(CUD_FORMAT, "cud_format"),
-	    REG_TYPE_STR(BUI_FORMAT, "bui_format"),
-	    REG_TYPE_STR(BUD_FORMAT, "bud_format"),
-	};
-	BUILD_BUG_ON(ARRAY_SIZE(res_type_str) != XLOG_REG_TYPE_MAX + 1);
-#undef REG_TYPE_STR
-
 	xfs_warn(mp, "ticket reservation summary:");
-	xfs_warn(mp, "  unit res    = %d bytes",
-		 ticket->t_unit_res);
-	xfs_warn(mp, "  current res = %d bytes",
-		 ticket->t_curr_res);
-	xfs_warn(mp, "  total reg   = %u bytes (o/flow = %u bytes)",
-		 ticket->t_res_arr_sum, ticket->t_res_o_flow);
-	xfs_warn(mp, "  ophdrs      = %u (ophdr space = %u bytes)",
-		 ticket->t_res_num_ophdrs, ophdr_spc);
-	xfs_warn(mp, "  ophdr + reg = %u bytes",
-		 ticket->t_res_arr_sum + ticket->t_res_o_flow + ophdr_spc);
-	xfs_warn(mp, "  num regions = %u",
-		 ticket->t_res_num);
-
-	for (i = 0; i < ticket->t_res_num; i++) {
-		uint r_type = ticket->t_res_arr[i].r_type;
-		xfs_warn(mp, "region[%u]: %s - %u bytes", i,
-			    ((r_type <= 0 || r_type > XLOG_REG_TYPE_MAX) ?
-			    "bad-rtype" : res_type_str[r_type]),
-			    ticket->t_res_arr[i].r_len);
-	}
+	xfs_warn(mp, "  unit res    = %d bytes", ticket->t_unit_res);
+	xfs_warn(mp, "  current res = %d bytes", ticket->t_curr_res);
+	xfs_warn(mp, "  original count  = %d", ticket->t_ocnt);
+	xfs_warn(mp, "  remaining count = %d", ticket->t_cnt);
 }
 
 /*
@@ -2198,7 +2120,6 @@ xlog_write_calc_vec_length(
 	uint			optype)
 {
 	struct xfs_log_vec	*lv;
-	int			headers = 0;
 	int			len = 0;
 	int			i;
 
@@ -2207,17 +2128,9 @@ xlog_write_calc_vec_length(
 		if (lv->lv_buf_len == XFS_LOG_VEC_ORDERED)
 			continue;
 
-		headers += lv->lv_niovecs;
-
-		for (i = 0; i < lv->lv_niovecs; i++) {
-			struct xfs_log_iovec	*vecp = &lv->lv_iovecp[i];
-
-			len += vecp->i_len;
-			xlog_tic_add_region(ticket, vecp->i_len, vecp->i_type);
-		}
+		for (i = 0; i < lv->lv_niovecs; i++)
+			len += lv->lv_iovecp[i].i_len;
 	}
-	ticket->t_res_num_ophdrs += headers;
-
 	return len;
 }
 
@@ -2276,7 +2189,6 @@ xlog_write_setup_copy(
 
 	/* account for new log op header */
 	ticket->t_curr_res -= sizeof(struct xlog_op_header);
-	ticket->t_res_num_ophdrs++;
 
 	return sizeof(struct xlog_op_header);
 }
@@ -2973,9 +2885,6 @@ xlog_state_get_iclog_space(
 	 */
 	if (log_offset == 0) {
 		ticket->t_curr_res -= log->l_iclog_hsize;
-		xlog_tic_add_region(ticket,
-				    log->l_iclog_hsize,
-				    XLOG_REG_TYPE_LRHEADER);
 		head->h_cycle = cpu_to_be32(log->l_curr_cycle);
 		head->h_lsn = cpu_to_be64(
 			xlog_assign_lsn(log->l_curr_cycle, log->l_curr_block));
@@ -3055,7 +2964,6 @@ xfs_log_ticket_regrant(
 	xlog_grant_sub_space(log, &log->l_write_head.grant,
 					ticket->t_curr_res);
 	ticket->t_curr_res = ticket->t_unit_res;
-	xlog_tic_reset_res(ticket);
 
 	trace_xfs_log_ticket_regrant_sub(log, ticket);
 
@@ -3066,7 +2974,6 @@ xfs_log_ticket_regrant(
 		trace_xfs_log_ticket_regrant_exit(log, ticket);
 
 		ticket->t_curr_res = ticket->t_unit_res;
-		xlog_tic_reset_res(ticket);
 	}
 
 	xfs_log_ticket_put(ticket);
@@ -3529,8 +3436,6 @@ xlog_ticket_alloc(
 	if (permanent)
 		tic->t_flags |= XLOG_TIC_PERM_RESERV;
 
-	xlog_tic_reset_res(tic);
-
 	return tic;
 }
 
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index e4e3e71b2b1b..301c36165974 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -136,19 +136,6 @@ enum xlog_iclog_state {
 #define XLOG_ICL_NEED_FLUSH	(1 << 0)	/* iclog needs REQ_PREFLUSH */
 #define XLOG_ICL_NEED_FUA	(1 << 1)	/* iclog needs REQ_FUA */
 
-/* Ticket reservation region accounting */ 
-#define XLOG_TIC_LEN_MAX	15
-
-/*
- * Reservation region
- * As would be stored in xfs_log_iovec but without the i_addr which
- * we don't care about.
- */
-typedef struct xlog_res {
-	uint	r_len;	/* region length		:4 */
-	uint	r_type;	/* region's transaction type	:4 */
-} xlog_res_t;
-
 typedef struct xlog_ticket {
 	struct list_head   t_queue;	 /* reserve/write queue */
 	struct task_struct *t_task;	 /* task that owns this ticket */
@@ -159,13 +146,6 @@ typedef struct xlog_ticket {
 	char		   t_ocnt;	 /* original count		 : 1  */
 	char		   t_cnt;	 /* current count		 : 1  */
 	char		   t_flags;	 /* properties of reservation	 : 1  */
-
-        /* reservation array fields */
-	uint		   t_res_num;                    /* num in array : 4 */
-	uint		   t_res_num_ophdrs;		 /* num op hdrs  : 4 */
-	uint		   t_res_arr_sum;		 /* array sum    : 4 */
-	uint		   t_res_o_flow;		 /* sum overflow : 4 */
-	xlog_res_t	   t_res_arr[XLOG_TIC_LEN_MAX];  /* array of res : 8 * 15 */ 
 } xlog_ticket_t;
 
 /*
-- 
2.31.1

