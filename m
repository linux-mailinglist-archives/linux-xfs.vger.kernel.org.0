Return-Path: <linux-xfs+bounces-20755-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F4E1A5E80F
	for <lists+linux-xfs@lfdr.de>; Thu, 13 Mar 2025 00:11:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 201FC7A8B5A
	for <lists+linux-xfs@lfdr.de>; Wed, 12 Mar 2025 23:10:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 684881F12F1;
	Wed, 12 Mar 2025 23:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ds8VO3VA"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24C321B0406;
	Wed, 12 Mar 2025 23:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741821078; cv=none; b=go76RjQ5P6wv9kxCbZMYImU0GotRTcvOTvN5CyQdwr9m3oMw4Xq+mblN/jJCFwqI3l/IMDbsxFO8uCK6lmmZROcKxDSZal6PK12PSjtCeSewFmRXVJjzSC8p2KI3aLpmv2Gt2WASNUiZx87RtAiseqEFHddNzXNFE+GvOdzm2qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741821078; c=relaxed/simple;
	bh=hiGP1mWkzO1j/vuvD2DoUJUoJ7NROn6vzpJHgOXDS8I=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Od7k77z3daRBCo+gcAE5ALG7vpRctHO6s/cH3uZUf17AT/69y46E8IzpTEdh1d53a1+Ua84VTpkKMCQJ8w/VJxnr+U4Gv4kCqlzntNm3yANLrq45WkmhTGvwydH69X+bZ7Bu1bnDEfL3tW9Sk/KIUVWDREUAG45HXME6oUz+i4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ds8VO3VA; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95009C4CEDD;
	Wed, 12 Mar 2025 23:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741821077;
	bh=hiGP1mWkzO1j/vuvD2DoUJUoJ7NROn6vzpJHgOXDS8I=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Ds8VO3VArF1sMg8/bqRfpslz6D72FVkhH4ygPl7j0WgjSmek83HmuxYhrF7ZsL8im
	 9tJbYA/D2tJpO6BPn0BDQ+YYyo8aayxjw0eB9vksEZ4eTHGRr92S2cHDflYYaGk1+O
	 lAZBqoJTDMDnjqfjNavVcMNIeWC/TAAtRirnl34yKcNOHGuGKasCvbn0EvmwQmRama
	 5nPJlDFPu0UzJORq1jQJSjtsQ18OPYpWLEB9evHduDvmK4f9GTVjvwgjHZR5RBmp1U
	 i8wGNJ61eUyZkWXwIljjcrc7IxM9ic6GulBDqMbFn/HCkbmmPiIqqBPNTU3Mzlbl7L
	 bOceMFm5iOLFQ==
Date: Wed, 12 Mar 2025 16:11:17 -0700
Subject: [PATCH 1/1] generic/45[34]: add colored emoji variants to unicode
 tests
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <174182088890.1400612.13102226252912367653.stgit@frogsfrogsfrogs>
In-Reply-To: <174182088871.1400612.1677368898700125822.stgit@frogsfrogsfrogs>
References: <174182088871.1400612.1677368898700125822.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Ted told me this morning about a recent problem with kernel Unicode name
casefolding vs. emoji -- initially, someone decided that zero-width
joiners should be stripped out of filenames during comparisons, which
lead to malicious git pulls of branches containing "<zwj>.git/config"
files overwriting git repo config files.  A quick fix was to stop
ignoring the "ignorable" code points, but that broke emoji in filenames,
because emoji use zero-width joiners to combine simpler emoji into more
complex ones, or alter skin tones, or colors, etc.  Reportedly the
casefolding code will also fold a red heart into a black one.

So.  To our filename support test, let's add various colors of heart
emoji and various skin tones of heart-hands; and compound emoji
consisting of multiple emoji glued together with zero width joiners.
This actually caused a buffer overflow in the string-escaping functions
of xfs_scrub phase 5 because I hadn't anticipated that we'd end up with
a filename consisting *entirely* of nonprinting bytes.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 tests/generic/453 |   55 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/454 |   55 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 110 insertions(+)


diff --git a/tests/generic/453 b/tests/generic/453
index 04945ad1085b2d..bd5ce8b2bb11d9 100755
--- a/tests/generic/453
+++ b/tests/generic/453
@@ -203,6 +203,36 @@ setf "job offer.pdf" "actual period"
 setf "llamapirate\xf3\xa0\x80\x81\xf3\xa0\x81\x94\xf3\xa0\x81\xa8\xf3\xa0\x81\xa5\xf3\xa0\x80\xa0\xf3\xa0\x81\xb3\xf3\xa0\x81\xa1\xf3\xa0\x81\xac\xf3\xa0\x81\xa5\xf3\xa0\x81\xb3\xf3\xa0\x80\xa0\xf3\xa0\x81\xa6\xf3\xa0\x81\xaf\xf3\xa0\x81\xb2\xf3\xa0\x80\xa0\xf3\xa0\x81\x93\xf3\xa0\x81\xa5\xf3\xa0\x81\xa1\xf3\xa0\x81\xb4\xf3\xa0\x81\xb4\xf3\xa0\x81\xac\xf3\xa0\x81\xa5\xf3\xa0\x80\xa0\xf3\xa0\x81\xb7\xf3\xa0\x81\xa5\xf3\xa0\x81\xb2\xf3\xa0\x81\xa5\xf3\xa0\x80\xa0\xf3\xa0\x81\x95\xf3\xa0\x81\x93\xf3\xa0\x81\x84\xf3\xa0\x80\xa0\xf3\xa0\x80\xb1\xf3\xa0\x80\xb2\xf3\xa0\x80\xb0\xf3\xa0\x80\xb0\xf3\xa0\x80\xb0\xf3\xa0\x80\xb0\xf3\xa0\x81\xbf"
 setf "llamapirate"
 
+# colored heart emoji to check if casefolding whacks emoji
+setf "\xf0\x9f\x92\x9c" "purple"
+setf "\xf0\x9f\x92\x99" "blue"
+setf "\xf0\x9f\x92\x9a" "green"
+setf "\xf0\x9f\x92\x9b" "yellow"
+setf "\xf0\x9f\xab\x80" "heart"
+setf "\xe2\x9d\xa4\xef\xb8\x8f" "red"
+setf "\xf0\x9f\xa4\x8e" "brown"
+setf "\xf0\x9f\xa4\x8d" "white"
+setf "\xf0\x9f\x96\xa4" "black"
+setf "\xf0\x9f\xa7\xa1" "orange"
+setf "\xe2\x99\xa5\xef\xb8\x8f" "red suit"
+
+# zero width joiners exist in the middle of emoji sequences aren't supposed
+# to be normalized to nothing, but apparently this caused issues with
+# casefolding on ext4; also the mending heart caused a crash in xfs_scrub
+setf "\xf0\x9f\x92\x94" "broken heart"
+setf "\xe2\x9d\xa4\xef\xb8\x8f\xe2\x80\x8d\xf0\x9f\xa9\xb9" "mending heart"
+setf "\xf0\x9f\xa7\x91\xf0\x9f\x8f\xbb\xe2\x80\x8d\xe2\x9d\xa4\xef\xb8
+\x8f\xe2\x80\x8d\xf0\x9f\xa7\x91\xf0\x9f\x8f\xbc" "couple with heart"
+setf "\xf0\x9f\xa7\x91\xf0\x9f\x8f\xbb\xe2\x80\x8d\xe2\x9d\xa4\xef\xb8\x8f\xe2\x80\x8d\xf0\x9f\xa7\x91\xf0\x9f\x8f\xbf" "couple with heart, light and dark skin tone"
+
+# emoji heart hands with skin tone variations
+setf "\xf0\x9f\xab\xb6\xf0\x9f\x8f\xbf" "dark"
+setf "\xf0\x9f\xab\xb6\xf0\x9f\x8f\xbe" "medium dark"
+setf "\xf0\x9f\xab\xb6\xf0\x9f\x8f\xbd" "medium"
+setf "\xf0\x9f\xab\xb6\xf0\x9f\x8f\xbc" "medium light"
+setf "\xf0\x9f\xab\xb6\xf0\x9f\x8f\xbb" "light"
+setf "\xf0\x9f\xab\xb6" "neutral"
+
 ls -laR $testdir >> $seqres.full
 
 echo "Test files"
@@ -276,6 +306,31 @@ testf "job offer.pdf" "actual period"
 testf "llamapirate\xf3\xa0\x80\x81\xf3\xa0\x81\x94\xf3\xa0\x81\xa8\xf3\xa0\x81\xa5\xf3\xa0\x80\xa0\xf3\xa0\x81\xb3\xf3\xa0\x81\xa1\xf3\xa0\x81\xac\xf3\xa0\x81\xa5\xf3\xa0\x81\xb3\xf3\xa0\x80\xa0\xf3\xa0\x81\xa6\xf3\xa0\x81\xaf\xf3\xa0\x81\xb2\xf3\xa0\x80\xa0\xf3\xa0\x81\x93\xf3\xa0\x81\xa5\xf3\xa0\x81\xa1\xf3\xa0\x81\xb4\xf3\xa0\x81\xb4\xf3\xa0\x81\xac\xf3\xa0\x81\xa5\xf3\xa0\x80\xa0\xf3\xa0\x81\xb7\xf3\xa0\x81\xa5\xf3\xa0\x81\xb2\xf3\xa0\x81\xa5\xf3\xa0\x80\xa0\xf3\xa0\x81\x95\xf3\xa0\x81\x93\xf3\xa0\x81\x84\xf3\xa0\x80\xa0\xf3\xa0\x80\xb1\xf3\xa0\x80\xb2\xf3\xa0\x80\xb0\xf3\xa0\x80\xb0\xf3\xa0\x80\xb0\xf3\xa0\x80\xb0\xf3\xa0\x81\xbf"
 testf "llamapirate"
 
+testf "\xf0\x9f\x92\x9c" "purple"
+testf "\xf0\x9f\x92\x99" "blue"
+testf "\xf0\x9f\x92\x9a" "green"
+testf "\xf0\x9f\x92\x9b" "yellow"
+testf "\xf0\x9f\xab\x80" "heart"
+testf "\xe2\x9d\xa4\xef\xb8\x8f" "red"
+testf "\xf0\x9f\xa4\x8e" "brown"
+testf "\xf0\x9f\xa4\x8d" "white"
+testf "\xf0\x9f\x96\xa4" "black"
+testf "\xf0\x9f\xa7\xa1" "orange"
+testf "\xe2\x99\xa5\xef\xb8\x8f" "red suit"
+
+testf "\xf0\x9f\x92\x94" "broken heart"
+testf "\xe2\x9d\xa4\xef\xb8\x8f\xe2\x80\x8d\xf0\x9f\xa9\xb9" "mending heart"
+testf "\xf0\x9f\xa7\x91\xf0\x9f\x8f\xbb\xe2\x80\x8d\xe2\x9d\xa4\xef\xb8
+\x8f\xe2\x80\x8d\xf0\x9f\xa7\x91\xf0\x9f\x8f\xbc" "couple with heart"
+testf "\xf0\x9f\xa7\x91\xf0\x9f\x8f\xbb\xe2\x80\x8d\xe2\x9d\xa4\xef\xb8\x8f\xe2\x80\x8d\xf0\x9f\xa7\x91\xf0\x9f\x8f\xbf" "couple with heart, light and dark skin tone"
+
+testf "\xf0\x9f\xab\xb6\xf0\x9f\x8f\xbf" "dark"
+testf "\xf0\x9f\xab\xb6\xf0\x9f\x8f\xbe" "medium dark"
+testf "\xf0\x9f\xab\xb6\xf0\x9f\x8f\xbd" "medium"
+testf "\xf0\x9f\xab\xb6\xf0\x9f\x8f\xbc" "medium light"
+testf "\xf0\x9f\xab\xb6\xf0\x9f\x8f\xbb" "light"
+testf "\xf0\x9f\xab\xb6" "neutral"
+
 echo "Uniqueness of inodes?"
 stat -c '%i' "${testdir}/"* | sort | uniq -c | while read nr inum; do
 	if [ "${nr}" -gt 1 ]; then
diff --git a/tests/generic/454 b/tests/generic/454
index aec8beb8b43ca0..9f6ddb4a0e48b2 100755
--- a/tests/generic/454
+++ b/tests/generic/454
@@ -124,6 +124,36 @@ setf "combmark_\xe1\x80\x9c\xe1\x80\xaf\xe1\x80\xad.txt" "combining marks"
 setf "llamapirate\xf3\xa0\x80\x81\xf3\xa0\x81\x94\xf3\xa0\x81\xa8\xf3\xa0\x81\xa5\xf3\xa0\x80\xa0\xf3\xa0\x81\xb3\xf3\xa0\x81\xa1\xf3\xa0\x81\xac\xf3\xa0\x81\xa5\xf3\xa0\x81\xb3\xf3\xa0\x80\xa0\xf3\xa0\x81\xa6\xf3\xa0\x81\xaf\xf3\xa0\x81\xb2\xf3\xa0\x80\xa0\xf3\xa0\x81\x93\xf3\xa0\x81\xa5\xf3\xa0\x81\xa1\xf3\xa0\x81\xb4\xf3\xa0\x81\xb4\xf3\xa0\x81\xac\xf3\xa0\x81\xa5\xf3\xa0\x80\xa0\xf3\xa0\x81\xb7\xf3\xa0\x81\xa5\xf3\xa0\x81\xb2\xf3\xa0\x81\xa5\xf3\xa0\x80\xa0\xf3\xa0\x81\x95\xf3\xa0\x81\x93\xf3\xa0\x81\x84\xf3\xa0\x80\xa0\xf3\xa0\x80\xb1\xf3\xa0\x80\xb2\xf3\xa0\x80\xb0\xf3\xa0\x80\xb0\xf3\xa0\x80\xb0\xf3\xa0\x80\xb0\xf3\xa0\x81\xbf" "secret instructions"
 setf "llamapirate" "no secret instructions"
 
+# colored heart emoji to check if casefolding whacks emoji
+setf "\xf0\x9f\x92\x9c" "purple"
+setf "\xf0\x9f\x92\x99" "blue"
+setf "\xf0\x9f\x92\x9a" "green"
+setf "\xf0\x9f\x92\x9b" "yellow"
+setf "\xf0\x9f\xab\x80" "heart"
+setf "\xe2\x9d\xa4\xef\xb8\x8f" "red"
+setf "\xf0\x9f\xa4\x8e" "brown"
+setf "\xf0\x9f\xa4\x8d" "white"
+setf "\xf0\x9f\x96\xa4" "black"
+setf "\xf0\x9f\xa7\xa1" "orange"
+setf "\xe2\x99\xa5\xef\xb8\x8f" "red suit"
+
+# zero width joiners exist in the middle of emoji sequences aren't supposed
+# to be normalized to nothing, but apparently this caused issues with
+# casefolding on ext4; also the mending heart caused a crash in xfs_scrub
+setf "\xf0\x9f\x92\x94" "broken heart"
+setf "\xe2\x9d\xa4\xef\xb8\x8f\xe2\x80\x8d\xf0\x9f\xa9\xb9" "mending heart"
+setf "\xf0\x9f\xa7\x91\xf0\x9f\x8f\xbb\xe2\x80\x8d\xe2\x9d\xa4\xef\xb8
+\x8f\xe2\x80\x8d\xf0\x9f\xa7\x91\xf0\x9f\x8f\xbc" "couple with heart"
+setf "\xf0\x9f\xa7\x91\xf0\x9f\x8f\xbb\xe2\x80\x8d\xe2\x9d\xa4\xef\xb8\x8f\xe2\x80\x8d\xf0\x9f\xa7\x91\xf0\x9f\x8f\xbf" "couple with heart, light and dark skin tone"
+
+# emoji heart hands with skin tone variations
+setf "\xf0\x9f\xab\xb6\xf0\x9f\x8f\xbf" "dark"
+setf "\xf0\x9f\xab\xb6\xf0\x9f\x8f\xbe" "medium dark"
+setf "\xf0\x9f\xab\xb6\xf0\x9f\x8f\xbd" "medium"
+setf "\xf0\x9f\xab\xb6\xf0\x9f\x8f\xbc" "medium light"
+setf "\xf0\x9f\xab\xb6\xf0\x9f\x8f\xbb" "light"
+setf "\xf0\x9f\xab\xb6" "neutral"
+
 _getfattr --absolute-names -d "${testfile}" >> $seqres.full
 
 echo "Test files"
@@ -174,6 +204,31 @@ testf "combmark_\xe1\x80\x9c\xe1\x80\xaf\xe1\x80\xad.txt" "combining marks"
 testf "llamapirate\xf3\xa0\x80\x81\xf3\xa0\x81\x94\xf3\xa0\x81\xa8\xf3\xa0\x81\xa5\xf3\xa0\x80\xa0\xf3\xa0\x81\xb3\xf3\xa0\x81\xa1\xf3\xa0\x81\xac\xf3\xa0\x81\xa5\xf3\xa0\x81\xb3\xf3\xa0\x80\xa0\xf3\xa0\x81\xa6\xf3\xa0\x81\xaf\xf3\xa0\x81\xb2\xf3\xa0\x80\xa0\xf3\xa0\x81\x93\xf3\xa0\x81\xa5\xf3\xa0\x81\xa1\xf3\xa0\x81\xb4\xf3\xa0\x81\xb4\xf3\xa0\x81\xac\xf3\xa0\x81\xa5\xf3\xa0\x80\xa0\xf3\xa0\x81\xb7\xf3\xa0\x81\xa5\xf3\xa0\x81\xb2\xf3\xa0\x81\xa5\xf3\xa0\x80\xa0\xf3\xa0\x81\x95\xf3\xa0\x81\x93\xf3\xa0\x81\x84\xf3\xa0\x80\xa0\xf3\xa0\x80\xb1\xf3\xa0\x80\xb2\xf3\xa0\x80\xb0\xf3\xa0\x80\xb0\xf3\xa0\x80\xb0\xf3\xa0\x80\xb0\xf3\xa0\x81\xbf" "secret instructions"
 testf "llamapirate" "no secret instructions"
 
+testf "\xf0\x9f\x92\x9c" "purple"
+testf "\xf0\x9f\x92\x99" "blue"
+testf "\xf0\x9f\x92\x9a" "green"
+testf "\xf0\x9f\x92\x9b" "yellow"
+testf "\xf0\x9f\xab\x80" "heart"
+testf "\xe2\x9d\xa4\xef\xb8\x8f" "red"
+testf "\xf0\x9f\xa4\x8e" "brown"
+testf "\xf0\x9f\xa4\x8d" "white"
+testf "\xf0\x9f\x96\xa4" "black"
+testf "\xf0\x9f\xa7\xa1" "orange"
+testf "\xe2\x99\xa5\xef\xb8\x8f" "red suit"
+
+testf "\xf0\x9f\x92\x94" "broken heart"
+testf "\xe2\x9d\xa4\xef\xb8\x8f\xe2\x80\x8d\xf0\x9f\xa9\xb9" "mending heart"
+testf "\xf0\x9f\xa7\x91\xf0\x9f\x8f\xbb\xe2\x80\x8d\xe2\x9d\xa4\xef\xb8
+\x8f\xe2\x80\x8d\xf0\x9f\xa7\x91\xf0\x9f\x8f\xbc" "couple with heart"
+testf "\xf0\x9f\xa7\x91\xf0\x9f\x8f\xbb\xe2\x80\x8d\xe2\x9d\xa4\xef\xb8\x8f\xe2\x80\x8d\xf0\x9f\xa7\x91\xf0\x9f\x8f\xbf" "couple with heart, light and dark skin tone"
+
+testf "\xf0\x9f\xab\xb6\xf0\x9f\x8f\xbf" "dark"
+testf "\xf0\x9f\xab\xb6\xf0\x9f\x8f\xbe" "medium dark"
+testf "\xf0\x9f\xab\xb6\xf0\x9f\x8f\xbd" "medium"
+testf "\xf0\x9f\xab\xb6\xf0\x9f\x8f\xbc" "medium light"
+testf "\xf0\x9f\xab\xb6\xf0\x9f\x8f\xbb" "light"
+testf "\xf0\x9f\xab\xb6" "neutral"
+
 echo "Uniqueness of keys?"
 crazy_keys="$(_getfattr --absolute-names -d "${testfile}" | grep -E -c '(french_|chinese_|greek_|arabic_|urk)')"
 expected_keys=11


