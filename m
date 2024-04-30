Return-Path: <linux-xfs+bounces-7912-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 737108B6900
	for <lists+linux-xfs@lfdr.de>; Tue, 30 Apr 2024 05:37:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A42941C21AEE
	for <lists+linux-xfs@lfdr.de>; Tue, 30 Apr 2024 03:37:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F60B10A0C;
	Tue, 30 Apr 2024 03:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PfdWtAcM"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 072C5DDA6;
	Tue, 30 Apr 2024 03:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714448261; cv=none; b=eDciIoiqxCtt7REbDEY3nZNPjEF8QuKZD93MyCI/a54LmjuSB5/Iy6Vbw9U4D1NSI38qtTkuF+1YWZvntJbRVqpR08wJDjxIZea4C5YigBdqKPvy65mdlKguzHNSx/WczqraJkC7ap4Hudjwl7xJGNdz3yh5vjOOKogbgosAdYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714448261; c=relaxed/simple;
	bh=Hq9bAAzXVOfUtqOv92GE9o97z+9N6P/Hzhx43UZJysI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FwzaTv2Uuy8AymZjcSebruhtHOYseXI+JI2ma1FTaJUqaQrHXzrhI9/gz+NvJ7Jvy52GD792sBsJePLgoTc+QBMSlRggeDsfE4Uqm+RcxSqCGTkiMs2Oc2tbnW+5P11K21ZIA6LrWCgvpy7//tNzLp/GSNkezeQmJMwKr6yUJCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PfdWtAcM; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 874CEC116B1;
	Tue, 30 Apr 2024 03:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714448260;
	bh=Hq9bAAzXVOfUtqOv92GE9o97z+9N6P/Hzhx43UZJysI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=PfdWtAcMTMm+YLbcTV/Qf5OHqS9gMxHNsAVnpU/P3HESloZsw8bMnQtpmKjBpFp+H
	 lAT/uPLzXGELGdg4JOEgaVGt3lHNz1CtEv1wP8dsT1Igy13OhurcYxcE9oqfzPeUi+
	 4kQGkeG6VO1fqkoKUjmFC5ySJk8AqB24YexM0cB7oHU/cvi9/cvPQnu3VE4DQHtdiI
	 LLSpH3xTwCTSolYP+CC+XA7vQtQSPIh2vKemnIbQqNyRxILqqaZeRljcHbYskaUdSw
	 DJBR18NK+YObHbFv73dJYA8zR4UtaBa2lLW4NifDYB8G3X6yRM9fhZzEGi+c30Rg55
	 hl1XMn1ASPlVw==
Date: Mon, 29 Apr 2024 20:37:40 -0700
Subject: [PATCH 26/38] xfs_db: dump the inode verity flag
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@redhat.com, ebiggers@kernel.org, cem@kernel.org,
 djwong@kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
 fsverity@lists.linux.dev
Message-ID: <171444683510.960383.11746420992762795794.stgit@frogsfrogsfrogs>
In-Reply-To: <171444683053.960383.12871831441554683674.stgit@frogsfrogsfrogs>
References: <171444683053.960383.12871831441554683674.stgit@frogsfrogsfrogs>
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

Display the verity iflag.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/inode.c |    3 +++
 1 file changed, 3 insertions(+)


diff --git a/db/inode.c b/db/inode.c
index d7ce7eb77365..6a6bb43dc15a 100644
--- a/db/inode.c
+++ b/db/inode.c
@@ -213,6 +213,9 @@ const field_t	inode_v3_flds[] = {
 	{ "metadir", FLDT_UINT1,
 	  OI(COFF(flags2) + bitsz(uint64_t) - XFS_DIFLAG2_METADIR_BIT-1), C1,
 	  0, TYP_NONE },
+	{ "verity", FLDT_UINT1,
+	  OI(COFF(flags2) + bitsz(uint64_t) - XFS_DIFLAG2_VERITY_BIT-1), C1,
+	  0, TYP_NONE },
 	{ NULL }
 };
 


