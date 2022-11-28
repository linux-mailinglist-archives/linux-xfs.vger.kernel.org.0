Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E61E63A944
	for <lists+linux-xfs@lfdr.de>; Mon, 28 Nov 2022 14:17:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231725AbiK1NRR (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 28 Nov 2022 08:17:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231772AbiK1NQz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Nov 2022 08:16:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1439D120A3
        for <linux-xfs@vger.kernel.org>; Mon, 28 Nov 2022 05:14:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 38A8EB80BA6
        for <linux-xfs@vger.kernel.org>; Mon, 28 Nov 2022 13:14:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21252C433D6
        for <linux-xfs@vger.kernel.org>; Mon, 28 Nov 2022 13:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669641283;
        bh=8fxIdF2vIO8wwiJZTRUhnMBr0mdlnxo7vXb3BTP8rwU=;
        h=From:To:Subject:Date:From;
        b=HmfEQdjiQdFETDE10Gji6tfw8jIHO/a/SqD+hOgjMlPQPCagjwaZzIDSA5GIF5QWb
         lQS1Z8ip0MBNbEJMhCTWvdyoEqxUOSxJkSjWhpsJMMqFgKxW8nAK9iqYBuLEg6gVaM
         3QN/veYW/mQ8l/xeB6ES5qR8Y7yiOjvtpaNYNLVwRlqrrLNmBts0copm/3La+wt+8B
         EJu7yMDlg1w3mbdvY2O9aaVomsc+IaiAaMQonVkJ7XCvmVVUst5xlA+sPLRK9WAZBk
         rv30IyUc0Q+2idpsb5IFR4lxQQvqM5qhAXMRQLFvbOP6xqt8Op/d0vfuXtircV+xXs
         DGJUmbxOTPT9g==
From:   cem@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [PATCH V2 0/2] xfsprogs: fix covscan issues
Date:   Mon, 28 Nov 2022 14:14:32 +0100
Message-Id: <20221128131434.21496-1-cem@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Carlos Maiolino <cem@kernel.org>

Fix a couple of minor issues found by covscan

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>

Carlos Maiolino (2):
  xfs_repair: Fix check_refcount() error path
  xfs_repair: Fix rmaps_verify_btree() error path

 repair/rmap.c | 43 ++++++++++++++++++++-----------------------
 1 file changed, 20 insertions(+), 23 deletions(-)

-- 
2.30.2

