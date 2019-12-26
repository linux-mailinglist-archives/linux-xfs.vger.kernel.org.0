Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B836512AC72
	for <lists+linux-xfs@lfdr.de>; Thu, 26 Dec 2019 14:48:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726475AbfLZNsI (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 26 Dec 2019 08:48:08 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:8196 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726074AbfLZNsI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 26 Dec 2019 08:48:08 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 1951A97D24DC772E1786;
        Thu, 26 Dec 2019 21:48:02 +0800 (CST)
Received: from huawei.com (10.175.124.28) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.439.0; Thu, 26 Dec 2019
 21:47:54 +0800
From:   yu kuai <yukuai3@huawei.com>
To:     <darrick.wong@oracle.com>, <bfoster@redhat.com>,
        <dchinner@redhat.com>, <sandeen@sandeen.net>,
        <cmaiolino@redhat.com>, <hch@lst.de>
CC:     <linux-xfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yukuai3@huawei.com>, <zhengbin13@huawei.com>,
        <yi.zhang@huawei.com>, <houtao1@huawei.com>
Subject: [PATCH 0/2] fix stale data exposure problem
Date:   Thu, 26 Dec 2019 21:47:19 +0800
Message-ID: <20191226134721.43797-1-yukuai3@huawei.com>
X-Mailer: git-send-email 2.17.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.124.28]
X-CFilter-Loop: Reflected
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The problem was found by generic/042, however, I have no idea why the
problem didn't get fixed.

yu kuai (2):
  xfs: introduce xfs_bmap_split_da_extent
  xfs: fix stale data exposure problem when punch hole, collapse range
    or zero range across a delalloc extent

 fs/xfs/libxfs/xfs_bmap.c | 26 ++++++++++++++++++++--
 fs/xfs/libxfs/xfs_bmap.h |  1 +
 fs/xfs/xfs_file.c        | 47 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 72 insertions(+), 2 deletions(-)

-- 
2.17.2

