Return-Path: <linux-xfs+bounces-31918-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MOc+MYoFqWlW0QAAu9opvQ
	(envelope-from <linux-xfs+bounces-31918-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Thu, 05 Mar 2026 05:24:42 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 67B9E20AC46
	for <lists+linux-xfs@lfdr.de>; Thu, 05 Mar 2026 05:24:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 13A2E3013A42
	for <lists+linux-xfs@lfdr.de>; Thu,  5 Mar 2026 04:24:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A8202253FC;
	Thu,  5 Mar 2026 04:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s9p/ktaO"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 488BE2AD16
	for <linux-xfs@vger.kernel.org>; Thu,  5 Mar 2026 04:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772684680; cv=none; b=qB4mM15WD1lLG6FkXYmZmS/2GUQziVm3qtYo2OWAZ15dFvenHH3NBqJ2I+HUCoqeksQL1Oq9UCOBdBGiXHkI1CftPEeicIcY4sqBNczCFjXvz+N8qgdPr2aT8ouaHDrCg5rNqhOR2AZjRbSTiVO7+s/HKe0LLSk3Q657fF0OXQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772684680; c=relaxed/simple;
	bh=B3N8DgGnG2oGLkuvXRSBkmZzPNdDQyOfv8Exg24IkZg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VQ4YWKgsqP8Ef4MawstBrCaLf6FUtDgJ1ygwS47aZsBVvkgv9Z1QomkjXRp0xhlQfkKs+CqCtoRqVvlss7yGXcgzjWerdkZ2vFHUQin/FzdEDFKUBos8RA7IKeZX9F7iwlGDBC0jfK6tcdweVz7Ea7Ub2Yn2MxjByqPwffKLxCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s9p/ktaO; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD1A4C116C6;
	Thu,  5 Mar 2026 04:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772684679;
	bh=B3N8DgGnG2oGLkuvXRSBkmZzPNdDQyOfv8Exg24IkZg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=s9p/ktaOA54Yp5Q8utcvySWx4JiO/7KTChWSc8Woa0AzrtfotKVfEyjHtUYaDaCqJ
	 OniEC8EMRDtEePfZBDpfP5KwWhImAQEBm1csJjnTERYpmZ5yEiRofwnHMgPgYhDeTR
	 rcnRuxrPJjwIYtaegSOl7pHzErGyGtTf59R7P1S3+Pk6ZLLbNRxjptXGIcXasNI83Z
	 P66gUBMfhWSekHNwfHb8L7RG9tgYAikaiGym2zBuO7wDdvWBTv5p63EFdvkB1dpnXN
	 LhR3iDFfnW05/EMX8UIBuGzhlTWyaOKDICCfaCjnfyA9Mo1KEux8HR/+4l0fdsG+VT
	 tRSFlIwnCKM3Q==
Date: Wed, 04 Mar 2026 20:24:39 -0800
Subject: [PATCH 3/4] mkfs: fix protofile data corruption when in/out file
 block sizes don't match
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <177268457065.1999857.17773222106097875153.stgit@frogsfrogsfrogs>
In-Reply-To: <177268456992.1999857.6319345892309281117.stgit@frogsfrogsfrogs>
References: <177268456992.1999857.6319345892309281117.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 67B9E20AC46
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-31918-lists,linux-xfs=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	MISSING_XM_UA(0.00)[];
	TO_DN_NONE(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[djwong@kernel.org,linux-xfs@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[4];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-xfs];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Action: no action

From: Darrick J. Wong <djwong@kernel.org>

As written in 73fb78e5ee8940, if libxfs_file_write is passed an
unaligned file range to write, it will zero the unaligned regions at the
head and tail of the block.  This is what we want for a newly allocated
(and hence unwritten) block, but this is definitely not what we want
if some other part of the block has already been written.

Fix this by extending the data/hole_pos range to be aligned to the block
size of the new filesystem.  This means we read slightly more, but we
never rewrite blocks in the new filesystem, sidestepping the behavior.

Found by xfs/841 when the test filesystem has a 1k fsblock size.

Cc: <linux-xfs@vger.kernel.org> # v6.13.0
Fixes: 73fb78e5ee8940 ("mkfs: support copying in large or sparse files")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 mkfs/proto.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)


diff --git a/mkfs/proto.c b/mkfs/proto.c
index 3241a066f72951..ee68a9e99e3153 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -374,6 +374,18 @@ writefile(
 			break;
 		}
 
+		/*
+		 * If we pass an unaligned range to libxfs_file_write, it will
+		 * zero the unaligned head and tail parts of each block.  If
+		 * the fd filesystem has a smaller blocksize, then we can end
+		 * up writing to the same block twice, causing unwanted zeroing
+		 * and hence data corruption.
+		 */
+		data_pos = rounddown_64(data_pos, mp->m_sb.sb_blocksize);
+		hole_pos = roundup_64(hole_pos, mp->m_sb.sb_blocksize);
+		if (hole_pos > statbuf.st_size)
+			hole_pos = statbuf.st_size;
+
 		writefile_range(ip, fname, fd, data_pos, hole_pos - data_pos);
 		data_pos = lseek(fd, hole_pos, SEEK_DATA);
 	}


