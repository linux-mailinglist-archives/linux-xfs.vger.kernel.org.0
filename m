Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A332C6D8B78
	for <lists+linux-xfs@lfdr.de>; Thu,  6 Apr 2023 02:10:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233303AbjDFAKF (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 5 Apr 2023 20:10:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231441AbjDFAKB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Apr 2023 20:10:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46ABB2115
        for <linux-xfs@vger.kernel.org>; Wed,  5 Apr 2023 17:09:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D739360B67
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 00:09:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47B4FC433EF;
        Thu,  6 Apr 2023 00:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680739796;
        bh=GQxV3vpu/YaAWsoRLtw6jxKjppy5yOyS+NC1TZe/Bcs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=dQnAl+b+cH4TfIsKsKc/BYX55lPOsfTrXeUaXqXrQTe4Rl8L5PRjpsZ6gMuO6y6Tf
         CBc1BAqTvD6R7Yx6tLVTCqThoQ2fNqboOuBwvzgoj0N6lSmrDM3m5qPX/y9Ud3m7of
         BUrZkTZCtpEK9Lv8/sl9Pjjn2F5rdd1tOabk6j6ITc+oEUoRPQMgS8CJara9/yU2TA
         heuaDmhJnc4mGsb0ic2tY8Ek/xWNGySD8SRGL7kT1kOqgKVc05wnvwQseEvukF1fHm
         SmGAMsyJjc18ewj5UYm7bCMDJVNDAdc12/lQk0mFZmV+DiAhyfW3zemHLQiRboT5MD
         BFgMGjKFYaXww==
Subject: [PATCH 4/6] xfs_db: fix metadump name obfuscation for ascii-ci
 filesystems
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Date:   Wed, 05 Apr 2023 17:09:55 -0700
Message-ID: <168073979582.1656666.4211101901014947969.stgit@frogsfrogsfrogs>
In-Reply-To: <168073977341.1656666.5994535770114245232.stgit@frogsfrogsfrogs>
References: <168073977341.1656666.5994535770114245232.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_FILL_THIS_FORM_SHORT autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Now that we've stabilized the dirent hash function for ascii-ci
filesystems, adapt the metadump name obfuscation code to detect when
it's obfuscating a directory entry name on an ascii-ci filesystem and
spit out names that actually have the same hash.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/metadump.c |   77 ++++++++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 68 insertions(+), 9 deletions(-)


diff --git a/db/metadump.c b/db/metadump.c
index 317ff728..4f8b3adb 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -817,13 +817,17 @@ static void
 obfuscate_name(
 	xfs_dahash_t	hash,
 	size_t		name_len,
-	unsigned char	*name)
+	unsigned char	*name,
+	bool		is_dirent)
 {
-	unsigned char	*newp = name;
+	unsigned char	*oldname = NULL;
+	unsigned char	*newp;
 	int		i;
-	xfs_dahash_t	new_hash = 0;
+	xfs_dahash_t	new_hash;
 	unsigned char	*first;
 	unsigned char	high_bit;
+	int		tries = 0;
+	bool		is_ci_name = is_dirent && xfs_has_asciici(mp);
 	int		shift;
 
 	/*
@@ -836,6 +840,24 @@ obfuscate_name(
 	if (name_len < 5)
 		return;
 
+	if (is_ci_name) {
+		oldname = alloca(name_len);
+		memcpy(oldname, name, name_len);
+	}
+
+again:
+	newp = name;
+	new_hash = 0;
+
+	/*
+	 * If we cannot generate a ci-compatible obfuscated name after 1000
+	 * tries, don't bother obfuscating the name.
+	 */
+	if (tries++ > 1000) {
+		memcpy(name, oldname, name_len);
+		return;
+	}
+
 	/*
 	 * The beginning of the obfuscated name can be pretty much
 	 * anything, so fill it in with random characters.
@@ -843,7 +865,11 @@ obfuscate_name(
 	 */
 	for (i = 0; i < name_len - 5; i++) {
 		*newp = random_filename_char();
-		new_hash = *newp ^ rol32(new_hash, 7);
+		if (is_ci_name)
+			new_hash = xfs_ascii_ci_xfrm(*newp) ^
+							rol32(new_hash, 7);
+		else
+			new_hash = *newp ^ rol32(new_hash, 7);
 		newp++;
 	}
 
@@ -867,6 +893,17 @@ obfuscate_name(
 			high_bit = 0x80;
 		} else
 			high_bit = 0;
+
+		/*
+		 * If ascii-ci is enabled, uppercase characters are converted
+		 * to lowercase characters while computing the name hash.  If
+		 * any of the necessary correction bytes are uppercase, the
+		 * hash of the new name will not match.  Try again with a
+		 * different prefix.
+		 */
+		if (is_ci_name && xfs_ascii_ci_need_xfrm(*newp))
+			goto again;
+
 		ASSERT(!is_invalid_char(*newp));
 		newp++;
 	}
@@ -880,6 +917,10 @@ obfuscate_name(
 	 */
 	if (high_bit) {
 		*first ^= 0x10;
+
+		if (is_ci_name && xfs_ascii_ci_need_xfrm(*first))
+			goto again;
+
 		ASSERT(!is_invalid_char(*first));
 	}
 }
@@ -1177,6 +1218,24 @@ handle_duplicate_name(xfs_dahash_t hash, size_t name_len, unsigned char *name)
 	return 1;
 }
 
+static inline xfs_dahash_t
+dirattr_hashname(
+	bool		is_dirent,
+	const uint8_t	*name,
+	int		namelen)
+{
+	if (is_dirent) {
+		struct xfs_name	xname = {
+			.name	= name,
+			.len	= namelen,
+		};
+
+		return libxfs_dir2_hashname(mp, &xname);
+	}
+
+	return libxfs_da_hashname(name, namelen);
+}
+
 static void
 generate_obfuscated_name(
 	xfs_ino_t		ino,
@@ -1205,9 +1264,9 @@ generate_obfuscated_name(
 
 	/* Obfuscate the name (if possible) */
 
-	hash = libxfs_da_hashname(name, namelen);
-	obfuscate_name(hash, namelen, name);
-	ASSERT(hash == libxfs_da_hashname(name, namelen));
+	hash = dirattr_hashname(ino != 0, name, namelen);
+	obfuscate_name(hash, namelen, name, ino != 0);
+	ASSERT(hash == dirattr_hashname(ino != 0, name, namelen));
 
 	/*
 	 * Make sure the name is not something already seen.  If we
@@ -1320,7 +1379,7 @@ obfuscate_path_components(
 			/* last (or single) component */
 			namelen = strnlen((char *)comp, len);
 			hash = libxfs_da_hashname(comp, namelen);
-			obfuscate_name(hash, namelen, comp);
+			obfuscate_name(hash, namelen, comp, false);
 			ASSERT(hash == libxfs_da_hashname(comp, namelen));
 			break;
 		}
@@ -1332,7 +1391,7 @@ obfuscate_path_components(
 			continue;
 		}
 		hash = libxfs_da_hashname(comp, namelen);
-		obfuscate_name(hash, namelen, comp);
+		obfuscate_name(hash, namelen, comp, false);
 		ASSERT(hash == libxfs_da_hashname(comp, namelen));
 		comp += namelen + 1;
 		len -= namelen + 1;

