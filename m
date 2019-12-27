Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DCEE12AFE1
	for <lists+linux-xfs@lfdr.de>; Fri, 27 Dec 2019 01:18:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726550AbfL0ASk (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 26 Dec 2019 19:18:40 -0500
Received: from mga02.intel.com ([134.134.136.20]:48430 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725909AbfL0ASj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 26 Dec 2019 19:18:39 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Dec 2019 16:18:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,360,1571727600"; 
   d="scan'208";a="208209940"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga007.jf.intel.com with ESMTP; 26 Dec 2019 16:18:36 -0800
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1ikdKu-0005u0-65; Fri, 27 Dec 2019 08:18:36 +0800
Date:   Fri, 27 Dec 2019 08:17:46 +0800
From:   kbuild test robot <lkp@intel.com>
To:     yu kuai <yukuai3@huawei.com>
Cc:     kbuild-all@lists.01.org, darrick.wong@oracle.com,
        bfoster@redhat.com, dchinner@redhat.com, sandeen@sandeen.net,
        cmaiolino@redhat.com, hch@lst.de, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, yukuai3@huawei.com,
        zhengbin13@huawei.com, yi.zhang@huawei.com, houtao1@huawei.com
Subject: Re: [PATCH 2/2] xfs: fix stale data exposure problem when punch
 hole, collapse range or zero range across a delalloc extent
Message-ID: <201912270810.Hlw06Rxu%lkp@intel.com>
References: <20191226134721.43797-3-yukuai3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191226134721.43797-3-yukuai3@huawei.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi yu,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on xfs-linux/for-next]
[cannot apply to djwong-xfs/djwong-devel v5.5-rc3 next-20191220]
[if your patch is applied to the wrong git tree, please drop us a note to help
improve the system. BTW, we also suggest to use '--base' option to specify the
base tree in git format-patch, please see https://stackoverflow.com/a/37406982]

url:    https://github.com/0day-ci/linux/commits/yu-kuai/fix-stale-data-exposure-problem/20191226-235515
base:   https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git for-next
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.1-129-g341daf20-dirty
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

>> fs/xfs/xfs_file.c:790:1: sparse: sparse: symbol 'try_split_da_extent' was not declared. Should it be static?

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                 Open Source Technology Center
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org Intel Corporation
