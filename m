Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F045186BA1
	for <lists+linux-xfs@lfdr.de>; Mon, 16 Mar 2020 14:00:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730896AbgCPNAE (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 16 Mar 2020 09:00:04 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:45318 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731062AbgCPNAE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 16 Mar 2020 09:00:04 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id D8A62BE7DC834D9E09AC;
        Mon, 16 Mar 2020 21:00:01 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.487.0; Mon, 16 Mar 2020
 20:59:55 +0800
From:   Zheng Bin <zhengbin13@huawei.com>
To:     <bfoster@redhat.com>, <dchinner@redhat.com>, <sandeen@sandeen.net>,
        <darrick.wong@oracle.com>, <linux-xfs@vger.kernel.org>
CC:     <yi.zhang@huawei.com>, <houtao1@huawei.com>
Subject: [PATCH 0/2] xfs: always init fdblocks in mount and avoid f_bfree overflow
Date:   Mon, 16 Mar 2020 21:07:06 +0800
Message-ID: <1584364028-122886-1-git-send-email-zhengbin13@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Use buffer io to test xfs mount point:
cp file1M /mnt  -->just check fdblocks
sync            -->find suiteable AG, agf->agf_freeblks & agf->agf_longest

fdblocks may not be correct, if hackers use xfs_db to modify it, always
init fdblocks in mount, also avoid f_bfree overflow.

Zheng Bin (2):
  xfs: always init fdblocks in mount
  xfs: avoid f_bfree overflow

 fs/xfs/xfs_mount.c | 39 ++++++---------------------------------
 fs/xfs/xfs_super.c |  3 ++-
 2 files changed, 8 insertions(+), 34 deletions(-)

--
2.7.4

