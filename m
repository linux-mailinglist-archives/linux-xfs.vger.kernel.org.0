Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5CAF375302
	for <lists+linux-xfs@lfdr.de>; Thu,  6 May 2021 13:27:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234649AbhEFL2A (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 6 May 2021 07:28:00 -0400
Received: from mga01.intel.com ([192.55.52.88]:63999 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234603AbhEFL17 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 6 May 2021 07:27:59 -0400
IronPort-SDR: xhTtluWHTamktyPN/ySjC/epT76QVmW4VZkwjaeubkbfFf7kNJ+TJW664jeqmfZhO3O8JWS+Yf
 wFUDW0ITLXqQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9975"; a="219326572"
X-IronPort-AV: E=Sophos;i="5.82,277,1613462400"; 
   d="scan'208";a="219326572"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2021 04:27:01 -0700
IronPort-SDR: ma4refdrUEcA//IvsdpvB2LkXR/TJ43aRKVtXoqJRigf79XbwIVGrgtRjtq5cMgRAjScT4GAeG
 ZTDGHYTW/uFA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,277,1613462400"; 
   d="scan'208";a="397057222"
Received: from lkp-server01.sh.intel.com (HELO a48ff7ddd223) ([10.239.97.150])
  by fmsmga007.fm.intel.com with ESMTP; 06 May 2021 04:27:01 -0700
Received: from kbuild by a48ff7ddd223 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1lec9k-000AZP-FE; Thu, 06 May 2021 11:27:00 +0000
Date:   Thu, 6 May 2021 19:26:42 +0800
From:   kernel test robot <lkp@intel.com>
To:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Cc:     kbuild-all@lists.01.org
Subject: [RFC PATCH] xfs: xfs_dialloc_ag can be static
Message-ID: <20210506112642.GA60902@79c811f72acc>
References: <20210506072054.271157-20-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210506072054.271157-20-david@fromorbit.com>
X-Patchwork-Hint: ignore
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

fs/xfs/libxfs/xfs_ialloc.c:1432:1: warning: symbol 'xfs_dialloc_ag' was not declared. Should it be static?

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: kernel test robot <lkp@intel.com>
---
 xfs_ialloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 2c0ef2dd46d91..1c3fb08186743 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -1428,7 +1428,7 @@ xfs_dialloc_ag_update_inobt(
  * The caller selected an AG for us, and made sure that free inodes are
  * available.
  */
-int
+static int
 xfs_dialloc_ag(
 	struct xfs_trans	*tp,
 	struct xfs_buf		*agbp,
