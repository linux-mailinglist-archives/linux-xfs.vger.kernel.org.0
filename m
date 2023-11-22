Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 045327F4F31
	for <lists+linux-xfs@lfdr.de>; Wed, 22 Nov 2023 19:20:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231470AbjKVSUx (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 22 Nov 2023 13:20:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235081AbjKVSUv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Nov 2023 13:20:51 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D7B6101
        for <linux-xfs@vger.kernel.org>; Wed, 22 Nov 2023 10:20:48 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71AE3C433C7;
        Wed, 22 Nov 2023 18:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1700677248;
        bh=cxoLuIy+DxzxtA/AcQKa1sqUbjSKg+q3pX+reb+600U=;
        h=From:To:Cc:Subject:Date:From;
        b=Ijr6Ew540auwut2nI/Ml7kQhVlE4D5F+zSopJazWgtltcfDi7JNRXYGdb8IMRlmv2
         MqF+R46SqI6dbJD8pwspPv1yqRr5t5YrclshSVhm6egN7xjVa7efed0M9elatowc3b
         j55kdqDtzn/gZnO3WI9rc89MdJjERSkvGTL8BfMMQ3yOgaPRKPpsw1j4Zhq2pagKlW
         /USaSY2vimrMOiT1ij+/M01YIOLLYZPyWj1NmRqCE87Lgv7HUEmStAqGrfx3b8AHYD
         Ls/CVtNw6zGAhmZEYx9cQnj7ekViW6ZA8lz0owzzNU0HOYbM+OLAv/hLPjNklW0bKj
         45wYHolrTU87g==
User-agent: mu4e 1.8.10; emacs 27.1
From:   Chandan Babu R <chandanbabu@kernel.org>
To:     chandanbabu@kernel.org
Cc:     djwong@kernel.org, hch@lst.de, linux-fsdevel@vger.kernel.org,
        linux-xfs@vger.kernel.org
Subject: xfs-linux: for-next updated to 9c235dfc3d3f
Date:   Wed, 22 Nov 2023 23:49:31 +0530
Message-ID: <87zfz5hcoz.fsf@debian-BULLSEYE-live-builder-AMD64>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

The for-next branch of the xfs-linux repository at:

	https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been updated.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.

The new head of the for-next branch is commit:

9c235dfc3d3f xfs: dquot recovery does not validate the recovered dquot

2 new commits:

Darrick J. Wong (2):
      [ed17f7da5f0c] xfs: clean up dqblk extraction
      [9c235dfc3d3f] xfs: dquot recovery does not validate the recovered dquot

Code Diffstat:

 fs/xfs/xfs_dquot.c              |  5 +++--
 fs/xfs/xfs_dquot_item_recover.c | 21 ++++++++++++++++++---
 2 files changed, 21 insertions(+), 5 deletions(-)
