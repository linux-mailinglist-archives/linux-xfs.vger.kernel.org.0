Return-Path: <linux-xfs+bounces-356-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8DAEC802AED
	for <lists+linux-xfs@lfdr.de>; Mon,  4 Dec 2023 05:37:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B47ED1C208DE
	for <lists+linux-xfs@lfdr.de>; Mon,  4 Dec 2023 04:37:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51C0381E;
	Mon,  4 Dec 2023 04:37:27 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E289392
	for <linux-xfs@vger.kernel.org>; Sun,  3 Dec 2023 20:37:21 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
	id AFD3D227A8E; Mon,  4 Dec 2023 05:37:18 +0100 (CET)
Date: Mon, 4 Dec 2023 05:37:18 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH, RFC] libxfs: check the size of on-disk data structures
Message-ID: <20231204043718.GA25793@lst.de>
References: <20231108163316.493089-1-hch@lst.de> <20231109195233.GH1205143@frogsfrogsfrogs> <20231110050846.GA24953@lst.de> <20231201020658.GU361584@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231201020658.GU361584@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Nov 30, 2023 at 06:06:58PM -0800, Darrick J. Wong wrote:
> I copy-pasta'd the whole mess from compiler_types.h and build_bug.h into
> include/xfs.h.  It works, but it might be kinda egregious though.

Oh.  I actually have a local patch to simply switch to static_assert
as that completly relies on the compiler and gives better output.  I
haven't even written a proper commit log, but this is it:

diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
index 2f24bd42ac1dd7..3a5581ecb36d4c 100644
--- a/fs/xfs/xfs_ondisk.h
+++ b/fs/xfs/xfs_ondisk.h
@@ -7,16 +7,16 @@
 #define __XFS_ONDISK_H
 
 #define XFS_CHECK_STRUCT_SIZE(structname, size) \
-	BUILD_BUG_ON_MSG(sizeof(structname) != (size), "XFS: sizeof(" \
-		#structname ") is wrong, expected " #size)
+	static_assert(sizeof(structname) == (size), \
+		"XFS: sizeof(" #structname ") is wrong, expected " #size)
 
 #define XFS_CHECK_OFFSET(structname, member, off) \
-	BUILD_BUG_ON_MSG(offsetof(structname, member) != (off), \
+	static_assert(offsetof(structname, member) == (off), \
 		"XFS: offsetof(" #structname ", " #member ") is wrong, " \
 		"expected " #off)
 
 #define XFS_CHECK_VALUE(value, expected) \
-	BUILD_BUG_ON_MSG((value) != (expected), \
+	static_assert((value) == (expected), \
 		"XFS: value of " #value " is wrong, expected " #expected)
 
 static inline void __init

