Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A278659DFB
	for <lists+linux-xfs@lfdr.de>; Sat, 31 Dec 2022 00:19:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235634AbiL3XTh (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 30 Dec 2022 18:19:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbiL3XTe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:19:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 690B4FCCB;
        Fri, 30 Dec 2022 15:19:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1A025B81DA2;
        Fri, 30 Dec 2022 23:19:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F510C433EF;
        Fri, 30 Dec 2022 23:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672442370;
        bh=6ykR7/NmFqVpHWdYiVo7fndZbz8/Cmv7bXMSi21t0e8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=l6FeM4BErW91QQEVQvh4WJc0qZ7ETPM1pSUbBps9kwkjIgX+0CWkG2P63xboe1muM
         YyRZAFl6f/4nP27Bdr8exz1PPcvn4e2e6PQCLcLqSMDIdqoVr+H7ehWPMnqN9fbCbN
         zZMsR8YqMBreOz5EbAhM4/jmsjE999SBHGeDgJRq+NCeTM9lZwuns79DzL526FAEM/
         4q8w0jEsmLVAh8LnvMA/hGVszAb0Nc7/JUyiqQ/3AWja5s1hIAANvqrD2HKVDmsfoQ
         5/Q/4qD+0gtXnMryAsjx3mtUyzSPPzgEC5Ro2fjUCecYAy80drQu3AfS4Cl2qV1Gns
         a6KBG0UjzI/BA==
Subject: [PATCHSET v24.0 0/1] fstests: online repair of extended attributes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:19:54 -0800
Message-ID: <167243879487.732747.6068603679875314716.stgit@magnolia>
In-Reply-To: <Y69Unb7KRM5awJoV@magnolia>
References: <Y69Unb7KRM5awJoV@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series employs atomic extent swapping to enable safe reconstruction
of extended attribute data attached to a file.  Because xattrs do not
have any redundant information to draw off of, we can at best salvage
as much data as we can and build a new structure.

Rebuilding an extended attribute structure consists of these three
steps:

First, we walk the existing attributes to salvage as many of them as we
can, by adding them as new attributes attached to the repair tempfile.
We need to add a new xfile-based data structure to hold blobs of
arbitrary length to stage the xattr names and values.

Second, we write the salvaged attributes to a temporary file, and use
atomic extent swaps to exchange the entire attribute fork between the
two files.

Finally, we reap the old xattr blocks (which are now in the temporary
file) as carefully as we can.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-xattrs

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-xattrs

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=repair-xattrs
---
 tests/xfs/814     |   40 ++++++++++++++++++++++++++++++++++++++++
 tests/xfs/814.out |    2 ++
 2 files changed, 42 insertions(+)
 create mode 100755 tests/xfs/814
 create mode 100644 tests/xfs/814.out

