Return-Path: <linux-xfs+bounces-31494-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IBAmLJido2k3IQUAu9opvQ
	(envelope-from <linux-xfs+bounces-31494-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Sun, 01 Mar 2026 02:59:52 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C1D21CC89C
	for <lists+linux-xfs@lfdr.de>; Sun, 01 Mar 2026 02:59:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 1ABA330E1213
	for <lists+linux-xfs@lfdr.de>; Sun,  1 Mar 2026 01:53:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7643F2D838A;
	Sun,  1 Mar 2026 01:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cBowaXm8"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 535F0274B5F;
	Sun,  1 Mar 2026 01:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772329918; cv=none; b=BTNeyj31hKT87SWaxklHnVKZeEvEOuwAjtm+l5hVuprimEHZUmq1Np5wwI91XTPd2ANtg1E2mcbgXY8w1gFbLSVhc+viLafRRYVwHkW8E6eWnmJIxwhEDb3jGovXjdiluCVoRJ/L9cAH7u+U8G2rnDkjAZOELswY8OyUWeqZ+10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772329918; c=relaxed/simple;
	bh=3rW31b317G7OQ/V3VCj7WARqiPw91tKoxmkjtZhett8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JAtsjpG5+GAhP3cv2znYVZINJHri5U4Jd002UGacgzY/aY6gpaTrGUImU+Gsce6I7uJplZpLQ5/LXhZr21/pKXWh8IU0R+SSUQuz1gyYdDLg20f1n9i66uw5R7bi4nRaAjzMYrX8fF0yQlkHLViuxUHY9qlj1yZttcJGSb3JEiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cBowaXm8; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF4A4C19421;
	Sun,  1 Mar 2026 01:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772329918;
	bh=3rW31b317G7OQ/V3VCj7WARqiPw91tKoxmkjtZhett8=;
	h=From:To:Cc:Subject:Date:From;
	b=cBowaXm8dPz8wEY8BUBYX97KVa2FbtGArngBygNYujdIqkwJbmUK9dJ17U5mI4FuA
	 y9QzXSW4BTaM0xA+2s9jbqZ/DUW9ioeM3E1rU8Dnptij1F8E7CCy3sgMXUY5dM7YSt
	 cRkepLOrmDoGYTZviyrT+L+RVlhg9MSYhCnisCj+VlaBvKD7yFRD8iTlHUTFVdzyvV
	 uzNJGVeN/44vW+clIAqrfGdMtpm/jJhMI2wIwAHe2M1Eu7VU5kEDxNJHEbgrVaCngN
	 +fDmGoANzNX2r1ccwIYV9ekTqO7u4REeSYFeeXibAJJ6GZwDG+U8jwS++thwJWvVPm
	 8QKDvricPRhBA==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>,
	linux-xfs@vger.kernel.org
Subject: FAILED: Patch "xfs: delete attr leaf freemap entries when empty" failed to apply to 5.15-stable tree
Date: Sat, 28 Feb 2026 20:51:54 -0500
Message-ID: <20260301015156.1718329-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-31494-lists,linux-xfs=lfdr.de];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCPT_COUNT_THREE(0.00)[4];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sashal@kernel.org,linux-xfs@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-xfs];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 1C1D21CC89C
X-Rspamd-Action: no action

The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Thanks,
Sasha

------------------ original commit in Linus's tree ------------------

From 6f13c1d2a6271c2e73226864a0e83de2770b6f34 Mon Sep 17 00:00:00 2001
From: "Darrick J. Wong" <djwong@kernel.org>
Date: Fri, 23 Jan 2026 09:27:30 -0800
Subject: [PATCH] xfs: delete attr leaf freemap entries when empty

Back in commit 2a2b5932db6758 ("xfs: fix attr leaf header freemap.size
underflow"), Brian Foster observed that it's possible for a small
freemap at the end of the end of the xattr entries array to experience
a size underflow when subtracting the space consumed by an expansion of
the entries array.  There are only three freemap entries, which means
that it is not a complete index of all free space in the leaf block.

This code can leave behind a zero-length freemap entry with a nonzero
base.  Subsequent setxattr operations can increase the base up to the
point that it overlaps with another freemap entry.  This isn't in and of
itself a problem because the code in _leaf_add that finds free space
ignores any freemap entry with zero size.

However, there's another bug in the freemap update code in _leaf_add,
which is that it fails to update a freemap entry that begins midway
through the xattr entry that was just appended to the array.  That can
result in the freemap containing two entries with the same base but
different sizes (0 for the "pushed-up" entry, nonzero for the entry
that's actually tracking free space).  A subsequent _leaf_add can then
allocate xattr namevalue entries on top of the entries array, leading to
data loss.  But fixing that is for later.

For now, eliminate the possibility of confusion by zeroing out the base
of any freemap entry that has zero size.  Because the freemap is not
intended to be a complete index of free space, a subsequent failure to
find any free space for a new xattr will trigger block compaction, which
regenerates the freemap.

It looks like this bug has been in the codebase for quite a long time.

Cc: <stable@vger.kernel.org> # v2.6.12
Fixes: 1da177e4c3f415 ("Linux-2.6.12-rc2")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_attr_leaf.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 6061230b17ef5..c8c9737f04563 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -1580,6 +1580,19 @@ xfs_attr3_leaf_add_work(
 				min_t(uint16_t, ichdr->freemap[i].size,
 						sizeof(xfs_attr_leaf_entry_t));
 		}
+
+		/*
+		 * Don't leave zero-length freemaps with nonzero base lying
+		 * around, because we don't want the code in _remove that
+		 * matches on base address to get confused and create
+		 * overlapping freemaps.  If we end up with no freemap entries
+		 * then the next _add will compact the leaf block and
+		 * regenerate the freemaps.
+		 */
+		if (ichdr->freemap[i].size == 0 && ichdr->freemap[i].base > 0) {
+			ichdr->freemap[i].base = 0;
+			ichdr->holes = 1;
+		}
 	}
 	ichdr->usedbytes += xfs_attr_leaf_entsize(leaf, args->index);
 }
-- 
2.51.0





