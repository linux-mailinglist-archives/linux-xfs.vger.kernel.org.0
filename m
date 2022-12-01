Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0962B63EC94
	for <lists+linux-xfs@lfdr.de>; Thu,  1 Dec 2022 10:34:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbiLAJeR (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 1 Dec 2022 04:34:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbiLAJeR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Dec 2022 04:34:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D9A8B8D
        for <linux-xfs@vger.kernel.org>; Thu,  1 Dec 2022 01:34:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4C648B81E62
        for <linux-xfs@vger.kernel.org>; Thu,  1 Dec 2022 09:34:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71520C433D6
        for <linux-xfs@vger.kernel.org>; Thu,  1 Dec 2022 09:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669887253;
        bh=NzR4YmC4wNoG/JMH14Br7Rx64Sq8quigbqIfa97zkuU=;
        h=From:To:Subject:Date:From;
        b=tCPaOCOlqszl6fsuo4GhAy1mLQlQgaj3IeYYn0UHLWHFBJT0HZthGjirIVMRZTAls
         H5+Euv8FDpDFZzUuACA6F2GIcngbUU4zQ8wZtorhswe83HeFEUWdbB2qmAM7VPvKH6
         U/yYZHiIZBGBZnCGvUwtN3uNVUSaGYwd461jGvHkSOsU8U2MFJXt7W0RHsGoBTHbq5
         vE6nmhnQft7wgpiwPK65tD6HtgZOto249w6FgrLFeVMNbQGXLWHMoe11Y6nbSxaNVI
         C5nR3ghDh6YdeCmjokWG6hwdlwvbacKABYxx00f22I9u4/aHmPqp4upeBxWVS6jQje
         Kn/yoRtstSZjw==
From:   cem@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [PATCH V3 0/2] xfsprogs: fix covscan issues
Date:   Thu,  1 Dec 2022 10:34:06 +0100
Message-Id: <20221201093408.87820-1-cem@kernel.org>
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

From: Carlos Maiolino <cmaiolino@redhat.com>

Fix a couple of minor issues found by covscan

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>

Carlos Maiolino (2):
  xfs_repair: Fix check_refcount() error path
  xfs_repair: Fix rmaps_verify_btree() error path

 repair/rmap.c | 43 ++++++++++++++++++++-----------------------
 1 file changed, 20 insertions(+), 23 deletions(-)

-- 
2.30.2

