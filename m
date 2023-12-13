Return-Path: <linux-xfs+bounces-507-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 34671807EB0
	for <lists+linux-xfs@lfdr.de>; Thu,  7 Dec 2023 03:38:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DB9DA282604
	for <lists+linux-xfs@lfdr.de>; Thu,  7 Dec 2023 02:38:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 651EB1847;
	Thu,  7 Dec 2023 02:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lQP895E/"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1296A1841
	for <linux-xfs@vger.kernel.org>; Thu,  7 Dec 2023 02:38:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D20B5C433C9;
	Thu,  7 Dec 2023 02:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701916714;
	bh=N+UZY7/z4DWqjA1x+7nNUN7vt03krXA6k4Q+g0ar3oY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=lQP895E/UrjtCgM9w9YWc+4yzeEpfzzmkmF3RqXESU3XFR19IvcIua63Z673rz0ns
	 Pe57ei0gXcqdRbDEaBnGpdp8EG2DiWDTIRwSwi0u0eZWJu7/R3ZSvO5dz3627V6rDJ
	 0oPSzXC2/8tRFYKt5CalKL2nZ/MEDX/W7851ypdlW0oHH0UGlb9qUp18vfgQ2MDWhx
	 NyBgqfW0J4FuCblC9cPm5c4qME2kLKgcl0wSGznz0Vc8YxhnzxTGEIEOdwe5uVZOxH
	 Kb8Cs7ni3OrEpttJcHvxZQiejggaKjiSTGExbS+eXo8ek4GEkL7eHzZMYyYc5/UXf6
	 iPub5UMz4gazQ==
Date: Wed, 06 Dec 2023 18:38:34 -0800
Subject: [PATCH 1/6] xfs: force all buffers to be written during btree bulk
 load
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170191665162.1180191.12974934587540936095.stgit@frogsfrogsfrogs>
In-Reply-To: <170191665134.1180191.6683537290321625529.stgit@frogsfrogsfrogs>
References: <170191665134.1180191.6683537290321625529.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

While stress-testing online repair of btrees, I noticed periodic
assertion failures from the buffer cache about buffers with incorrect
DELWRI_Q state.  Looking further, I observed this race between the AIL
trying to write out a btree block and repair zapping a btree block after
the fact:

AIL:    Repair0:

pin buffer X
delwri_queue:
set DELWRI_Q
add to delwri list

        stale buf X:
        clear DELWRI_Q
        does not clear b_list
        free space X
        commit

delwri_submit   # oops

Worse yet, I discovered that running the same repair over and over in a
tight loop can result in a second race that cause data integrity
problems with the repair:

AIL:    Repair0:        Repair1:

pin buffer X
delwri_queue:
set DELWRI_Q
add to delwri list

        stale buf X:
        clear DELWRI_Q
        does not clear b_list
        free space X
        commit

                        find free space X
                        get buffer
                        rewrite buffer
                        delwri_queue:
                        set DELWRI_Q
                        already on a list, do not add
                        commit

                        BAD: committed tree root before all blocks written

delwri_submit   # too late now

I traced this to my own misunderstanding of how the delwri lists work,
particularly with regards to the AIL's buffer list.  If a buffer is
logged and committed, the buffer can end up on that AIL buffer list.  If
btree repairs are run twice in rapid succession, it's possible that the
first repair will invalidate the buffer and free it before the next time
the AIL wakes up.  Marking the buffer stale clears DELWRI_Q from the
buffer state without removing the buffer from its delwri list.  The
buffer doesn't know which list it's on, so it cannot know which lock to
take to protect the list for a removal.

If the second repair allocates the same block, it will then recycle the
buffer to start writing the new btree block.  Meanwhile, if the AIL
wakes up and walks the buffer list, it will ignore the buffer because it
can't lock it, and go back to sleep.

When the second repair calls delwri_queue to put the buffer on the
list of buffers to write before committing the new btree, it will set
DELWRI_Q again, but since the buffer hasn't been removed from the AIL's
buffer list, it won't add it to the bulkload buffer's list.

This is incorrect, because the bulkload caller relies on delwri_submit
to ensure that all the buffers have been sent to disk /before/
committing the new btree root pointer.  This ordering requirement is
required for data consistency.

Worse, the AIL won't clear DELWRI_Q from the buffer when it does finally
drop it, so the next thread to walk through the btree will trip over a
debug assertion on that flag.

To fix this, create a new function that waits for the buffer to be
removed from any other delwri lists before adding the buffer to the
caller's delwri list.  By waiting for the buffer to clear both the
delwri list and any potential delwri wait list, we can be sure that
repair will initiate writes of all buffers and report all write errors
back to userspace instead of committing the new structure.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_btree_staging.c |    4 +--
 fs/xfs/xfs_buf.c                  |   44 ++++++++++++++++++++++++++++++++++---
 fs/xfs/xfs_buf.h                  |    1 +
 3 files changed, 42 insertions(+), 7 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_btree_staging.c b/fs/xfs/libxfs/xfs_btree_staging.c
index dd75e208b543e..29e3f8ccb1852 100644
--- a/fs/xfs/libxfs/xfs_btree_staging.c
+++ b/fs/xfs/libxfs/xfs_btree_staging.c
@@ -342,9 +342,7 @@ xfs_btree_bload_drop_buf(
 	if (*bpp == NULL)
 		return;
 
-	if (!xfs_buf_delwri_queue(*bpp, buffers_list))
-		ASSERT(0);
-
+	xfs_buf_delwri_queue_here(*bpp, buffers_list);
 	xfs_buf_relse(*bpp);
 	*bpp = NULL;
 }
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 545c7991b9b58..ec4bd7a24d88c 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -2049,6 +2049,14 @@ xfs_alloc_buftarg(
 	return NULL;
 }
 
+static inline void
+xfs_buf_list_del(
+	struct xfs_buf		*bp)
+{
+	list_del_init(&bp->b_list);
+	wake_up_var(&bp->b_list);
+}
+
 /*
  * Cancel a delayed write list.
  *
@@ -2066,7 +2074,7 @@ xfs_buf_delwri_cancel(
 
 		xfs_buf_lock(bp);
 		bp->b_flags &= ~_XBF_DELWRI_Q;
-		list_del_init(&bp->b_list);
+		xfs_buf_list_del(bp);
 		xfs_buf_relse(bp);
 	}
 }
@@ -2119,6 +2127,34 @@ xfs_buf_delwri_queue(
 	return true;
 }
 
+/*
+ * Queue a buffer to this delwri list as part of a data integrity operation.
+ * If the buffer is on any other delwri list, we'll wait for that to clear
+ * so that the caller can submit the buffer for IO and wait for the result.
+ * Callers must ensure the buffer is not already on the list.
+ */
+void
+xfs_buf_delwri_queue_here(
+	struct xfs_buf		*bp,
+	struct list_head	*buffer_list)
+{
+	/*
+	 * We need this buffer to end up on the /caller's/ delwri list, not any
+	 * old list.  This can happen if the buffer is marked stale (which
+	 * clears DELWRI_Q) after the AIL queues the buffer to its list but
+	 * before the AIL has a chance to submit the list.
+	 */
+	while (!list_empty(&bp->b_list)) {
+		xfs_buf_unlock(bp);
+		wait_var_event(&bp->b_list, list_empty(&bp->b_list));
+		xfs_buf_lock(bp);
+	}
+
+	ASSERT(!(bp->b_flags & _XBF_DELWRI_Q));
+
+	xfs_buf_delwri_queue(bp, buffer_list);
+}
+
 /*
  * Compare function is more complex than it needs to be because
  * the return value is only 32 bits and we are doing comparisons
@@ -2181,7 +2217,7 @@ xfs_buf_delwri_submit_buffers(
 		 * reference and remove it from the list here.
 		 */
 		if (!(bp->b_flags & _XBF_DELWRI_Q)) {
-			list_del_init(&bp->b_list);
+			xfs_buf_list_del(bp);
 			xfs_buf_relse(bp);
 			continue;
 		}
@@ -2201,7 +2237,7 @@ xfs_buf_delwri_submit_buffers(
 			list_move_tail(&bp->b_list, wait_list);
 		} else {
 			bp->b_flags |= XBF_ASYNC;
-			list_del_init(&bp->b_list);
+			xfs_buf_list_del(bp);
 		}
 		__xfs_buf_submit(bp, false);
 	}
@@ -2255,7 +2291,7 @@ xfs_buf_delwri_submit(
 	while (!list_empty(&wait_list)) {
 		bp = list_first_entry(&wait_list, struct xfs_buf, b_list);
 
-		list_del_init(&bp->b_list);
+		xfs_buf_list_del(bp);
 
 		/*
 		 * Wait on the locked buffer, check for errors and unlock and
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index c86e164196568..b470de08a46ca 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -319,6 +319,7 @@ extern void xfs_buf_stale(struct xfs_buf *bp);
 /* Delayed Write Buffer Routines */
 extern void xfs_buf_delwri_cancel(struct list_head *);
 extern bool xfs_buf_delwri_queue(struct xfs_buf *, struct list_head *);
+void xfs_buf_delwri_queue_here(struct xfs_buf *bp, struct list_head *bl);
 extern int xfs_buf_delwri_submit(struct list_head *);
 extern int xfs_buf_delwri_submit_nowait(struct list_head *);
 extern int xfs_buf_delwri_pushbuf(struct xfs_buf *, struct list_head *);


