Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C1EA55EFE9
	for <lists+linux-xfs@lfdr.de>; Tue, 28 Jun 2022 22:49:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbiF1Uty (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 28 Jun 2022 16:49:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229869AbiF1Utx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Jun 2022 16:49:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91EE43056A
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jun 2022 13:49:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 31A6D6182E
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jun 2022 20:49:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F721C341C8;
        Tue, 28 Jun 2022 20:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656449391;
        bh=VJ7hM0QuquUdy+zO65j5FqpidSxcufAMD5WBSPmYU/E=;
        h=Subject:From:To:Cc:Date:From;
        b=uzwrOD/OYegtGXIUKDuG7B7BCkEz4Hvxqx5UWm43ZE/s3lbYG5Sj/WutOA2wD5q4X
         0xSBWhEy6nAJIpdW3MbmhbQ5iXPktGhQupwBq37Xd4ev44UNW3IDkAfcRrrgG8ACVS
         9XNQWABnbiPl4EZnxB6CU8vqWnMsNVWaxVRHWSWy2nEYmV8H5dcicnrKSbIABUawIm
         y+HCf1v8rsXmyxqSnu/i7CvW4ItiUCtP3e1/K2LemPpIPJBg+zWeMegSBz9hyf3wpM
         TMkXLdhW5cW7qAz3u0sPhbDv9A8dsetQZw7W872Xqo2XkKI7iGdLteVuA04lrAGodU
         /arWpsMUYEOGA==
Subject: [PATCHSET v3 0/2] xfs_repair: enable upgrading to nrext64
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>,
        Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Date:   Tue, 28 Jun 2022 13:49:51 -0700
Message-ID: <165644939119.1091400.7396096341976707391.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This patchset enables sysadmins to upgrade an existing filesystem to use
large extent counts.

v3: don't allow upgrades for filesystems that are more than 90% full
    because we just dont want to go there
v2: pull in patches from chandan/dave

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=nrext64-upgrade
---
 include/libxfs.h         |    1 
 include/xfs_mount.h      |    1 
 libxfs/init.c            |   24 +++--
 libxfs/libxfs_api_defs.h |    3 +
 man/man8/xfs_admin.8     |    7 +
 repair/globals.c         |    1 
 repair/globals.h         |    1 
 repair/phase2.c          |  234 ++++++++++++++++++++++++++++++++++++++++++++--
 repair/xfs_repair.c      |   11 ++
 9 files changed, 266 insertions(+), 17 deletions(-)

