Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF310711B36
	for <lists+linux-xfs@lfdr.de>; Fri, 26 May 2023 02:31:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbjEZAbE (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 25 May 2023 20:31:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjEZAbD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 20:31:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53A5B194
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 17:31:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DB21964B2A
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 00:31:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A44EC433EF;
        Fri, 26 May 2023 00:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685061061;
        bh=hhZ2u+d3Is3UKhGh5NnYcwQbtsTeaE0qNHixaA4HBIE=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=Z8ZiD7W/EiXxy7o7jJFbxuYxXO4Mh6eZE1IjAVVkznZc/4qlMdxZIFj9WSbPxszsv
         66vfDZZEjB9sUp3t/aaBTtmbTx9KjTYQC4R+KBeodtIYRgEtKwaEDSXjJx3zTJDaS/
         5dXlM+WHtbSl8LPn15fg94lHXysvheKbWb3xoa0ZshsfJdEI5KXfAMkPj62vtxYHtP
         NqgIHaB+ILZPbjFUFPPD2jI1V2kVwmqL/VrXEgJimI55XzL2oeDD+B1Ptuk04cG0am
         k5eZs5QcD6aFJanD1IG9zhYYVKwDRDm0kVqLWuJ9MgOjmWRpg7JFIXobB9YETnJbwU
         c5h1hQjJT16hA==
Date:   Thu, 25 May 2023 17:31:00 -0700
Subject: [PATCHSET v25.0 0/4] xfs: live inode scans for online fsck
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506059451.3730949.8525428478120924050.stgit@frogsfrogsfrogs>
In-Reply-To: <20230526000020.GJ11620@frogsfrogsfrogs>
References: <20230526000020.GJ11620@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

The design document discusses the need for a specialized inode scan
cursor to manage walking every file on a live filesystem to build
replacement metadata objects while receiving updates about the files
already scanned.  This series adds two pieces of infrastructure -- the
scan cursor, and live hooks to deliver information about updates going
on in other parts of the filesystem.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=scrub-iscan
---
 fs/xfs/Kconfig       |   37 ++++
 fs/xfs/Makefile      |    6 +
 fs/xfs/scrub/iscan.c |  498 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/iscan.h |   63 ++++++
 fs/xfs/scrub/trace.c |    1 
 fs/xfs/scrub/trace.h |  106 +++++++++++
 fs/xfs/xfs_hooks.c   |   94 +++++++++
 fs/xfs/xfs_hooks.h   |   72 +++++++
 fs/xfs/xfs_iwalk.c   |   13 -
 fs/xfs/xfs_linux.h   |    1 
 10 files changed, 879 insertions(+), 12 deletions(-)
 create mode 100644 fs/xfs/scrub/iscan.c
 create mode 100644 fs/xfs/scrub/iscan.h
 create mode 100644 fs/xfs/xfs_hooks.c
 create mode 100644 fs/xfs/xfs_hooks.h

