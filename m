Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9D72187A11
	for <lists+linux-xfs@lfdr.de>; Tue, 17 Mar 2020 07:58:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725871AbgCQG6A (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 17 Mar 2020 02:58:00 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:37534 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725872AbgCQG6A (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 17 Mar 2020 02:58:00 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 8D9DC6CD8F4119B984BE;
        Tue, 17 Mar 2020 14:57:55 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.487.0; Tue, 17 Mar 2020
 14:57:49 +0800
From:   Zheng Bin <zhengbin13@huawei.com>
To:     <bfoster@redhat.com>, <dchinner@redhat.com>, <sandeen@sandeen.net>,
        <darrick.wong@oracle.com>, <linux-xfs@vger.kernel.org>
CC:     <yi.zhang@huawei.com>, <houtao1@huawei.com>
Subject: [PATCH v2 0/2] xfs: always init fdblocks in mount and avoid f_bfree overflow
Date:   Tue, 17 Mar 2020 15:05:00 +0800
Message-ID: <1584428702-127436-1-git-send-email-zhengbin13@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

v1->v2: modify comment, add is agf inited judge in xfs_ag_resv_init

Zheng Bin (2):
  xfs: always init fdblocks in mount
  xfs: avoid f_bfree overflow

 fs/xfs/libxfs/xfs_ag_resv.c | 11 +++++++----
 fs/xfs/xfs_mount.c          | 39 ++++++---------------------------------
 fs/xfs/xfs_super.c          |  3 ++-
 3 files changed, 15 insertions(+), 38 deletions(-)

--
2.7.4

