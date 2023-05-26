Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89B6D711B6B
	for <lists+linux-xfs@lfdr.de>; Fri, 26 May 2023 02:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbjEZAkO (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 25 May 2023 20:40:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235302AbjEZAkN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 20:40:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE93A1B1
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 17:40:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3D577616EF
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 00:40:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A21E1C433EF;
        Fri, 26 May 2023 00:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685061607;
        bh=ERXUDJ8BBbOZTVPOfPOfxMLu/IphqZcrdK0gCplH8s0=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=Cvb3ZNrrZaAPzMzUzei/iKRLZhGjrsv7RaSQa4A4FHV59ko8oLqL9mu1EhBJSwBla
         YDVOhh/NNPATbWsW3Q1DlrnbEQcG1/rdHW0cCvL2eVv3TzoWqCO0xrbDCfWUbpdo2/
         l2rkKcculqnSCvwZ/4z0LqQsO0Nc7xLb3VpMa8pYzH4u7GpxdlIIjP9HGWwed8oK0p
         JEZteZJzF6ONUGaRICOXemxpZ8EM2Ep6hHoanyn9uoVTaecQiCb1ci/FU6BUf4Jme9
         Z8ylNhy6zu79+K1JDXYf6XEvvj/n/Q6rNlex0nxRO0A8SOk/4g5h2tBxZyqaF0B13m
         /g9oPRi0SGmcQ==
Date:   Thu, 25 May 2023 17:40:07 -0700
Subject: [PATCHSET v25.0 0/4] xfs_scrub_all: fixes for systemd services
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506074176.3745941.5054006111815853213.stgit@frogsfrogsfrogs>
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

This patchset ties up some problems in the xfs_scrub_all program and
service, which are essential for finding mounted filesystems to scrub
and creating the background service instances that do the scrub.

First, we need to fix various errors in pathname escaping, because
systemd does /not/ like slashes in service names.  Then, teach
xfs_scrub_all to deal with systemd restarts causing it to think that a
scrub has finished before the service actually finishes.  Finally,
implement a signal handler so that SIGINT (console ^C) and SIGTERM
(systemd stopping the service) shut down the xfs_scrub@ services
correctly.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scruball-service-fixes
---
 scrub/xfs_scrub_all.in |  157 ++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 125 insertions(+), 32 deletions(-)

