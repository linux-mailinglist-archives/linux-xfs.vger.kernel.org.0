Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4295B4ED24B
	for <lists+linux-xfs@lfdr.de>; Thu, 31 Mar 2022 06:35:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229801AbiCaER0 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 31 Mar 2022 00:17:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230255AbiCaEQp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Mar 2022 00:16:45 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 566A5B0D09;
        Wed, 30 Mar 2022 21:01:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648699267; x=1680235267;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=OrABZZQsphOZMKOKeJf4BcfF52I9DRZYnIsBfmD8D2Q=;
  b=aTX0p1JLPgGoKYLT2dpsiGWsOvFbGbn0C2F4ynn8qBwX7YS7lWUHTRVG
   8bdIFXfkD9CeXjwBkinBaGXGHi2HYx1sLXZvzqnPCoVMZCbbxUpkVaMz5
   6xxpcZffsYhSJm0nUxv7VHp3f1XSigE3BHOl6bwFFBVf1q/OTnimIqK6e
   0Jg8HarnsfKqxS4dhbbdtgjRaKXiEzmj+yV8NKKCE8NN4wqcxo4c39DuR
   ZKEG3tTAbRUib4giCnJIGeKguFuAB7EvVFBaasBqebAWDwK1KW7jcRJAO
   MVFk3v7lfX+xyoWqbQmM246I0B2MX0QPAyxOirZJys8F/hKs2d5hMUcAT
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10302"; a="258539615"
X-IronPort-AV: E=Sophos;i="5.90,224,1643702400"; 
   d="scan'208";a="258539615"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2022 20:07:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,224,1643702400"; 
   d="scan'208";a="547118109"
Received: from lkp-server02.sh.intel.com (HELO 56431612eabd) ([10.239.97.151])
  by orsmga007.jf.intel.com with ESMTP; 30 Mar 2022 20:07:51 -0700
Received: from kbuild by 56431612eabd with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nZlA6-0000nI-O1;
        Thu, 31 Mar 2022 03:07:50 +0000
Date:   Thu, 31 Mar 2022 11:07:35 +0800
From:   kernel test robot <lkp@intel.com>
To:     Yi Wang <wang.yi59@zte.com.cn>, djwong@kernel.org
Cc:     kbuild-all@lists.01.org, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, xue.zhihong@zte.com.cn,
        wang.yi59@zte.com.cn, wang.liang82@zte.com.cn,
        Cheng Lin <cheng.lin130@zte.com.cn>
Subject: Re: [PATCH] xfs: getattr ignore blocks beyond eof
Message-ID: <202203311022.9gnVNhj6-lkp@intel.com>
References: <20220331080256.1874-1-wang.yi59@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220331080256.1874-1-wang.yi59@zte.com.cn>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Yi,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on xfs-linux/for-next]
[also build test ERROR on v5.17 next-20220330]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Yi-Wang/xfs-getattr-ignore-blocks-beyond-eof/20220331-082944
base:   https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git for-next
config: sparc-randconfig-r005-20220330 (https://download.01.org/0day-ci/archive/20220331/202203311022.9gnVNhj6-lkp@intel.com/config)
compiler: sparc-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/e560188227f8fed285a1bd736e5708de984f0596
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Yi-Wang/xfs-getattr-ignore-blocks-beyond-eof/20220331-082944
        git checkout e560188227f8fed285a1bd736e5708de984f0596
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=sparc SHELL=/bin/bash fs/xfs/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   fs/xfs/xfs_bmap_util.c: In function 'xfs_free_eofblocks':
>> fs/xfs/xfs_bmap_util.c:756:26: error: 'end_fsb' undeclared (first use in this function)
     756 |         ip->i_last_fsb = end_fsb;
         |                          ^~~~~~~
   fs/xfs/xfs_bmap_util.c:756:26: note: each undeclared identifier is reported only once for each function it appears in


vim +/end_fsb +756 fs/xfs/xfs_bmap_util.c

   710	
   711	/*
   712	 * This is called to free any blocks beyond eof. The caller must hold
   713	 * IOLOCK_EXCL unless we are in the inode reclaim path and have the only
   714	 * reference to the inode.
   715	 */
   716	int
   717	xfs_free_eofblocks(
   718		struct xfs_inode	*ip)
   719	{
   720		struct xfs_trans	*tp;
   721		struct xfs_mount	*mp = ip->i_mount;
   722		int			error;
   723	
   724		/* Attach the dquots to the inode up front. */
   725		error = xfs_qm_dqattach(ip);
   726		if (error)
   727			return error;
   728	
   729		/* Wait on dio to ensure i_size has settled. */
   730		inode_dio_wait(VFS_I(ip));
   731	
   732		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0, 0, 0, &tp);
   733		if (error) {
   734			ASSERT(xfs_is_shutdown(mp));
   735			return error;
   736		}
   737	
   738		xfs_ilock(ip, XFS_ILOCK_EXCL);
   739		xfs_trans_ijoin(tp, ip, 0);
   740	
   741		/*
   742		 * Do not update the on-disk file size.  If we update the on-disk file
   743		 * size and then the system crashes before the contents of the file are
   744		 * flushed to disk then the files may be full of holes (ie NULL files
   745		 * bug).
   746		 */
   747		error = xfs_itruncate_extents_flags(&tp, ip, XFS_DATA_FORK,
   748					XFS_ISIZE(ip), XFS_BMAPI_NODISCARD);
   749		if (error)
   750			goto err_cancel;
   751	
   752		error = xfs_trans_commit(tp);
   753		if (error)
   754			goto out_unlock;
   755	
 > 756		ip->i_last_fsb = end_fsb;
   757		xfs_inode_clear_eofblocks_tag(ip);
   758		goto out_unlock;
   759	
   760	err_cancel:
   761		/*
   762		 * If we get an error at this point we simply don't
   763		 * bother truncating the file.
   764		 */
   765		xfs_trans_cancel(tp);
   766	out_unlock:
   767		xfs_iunlock(ip, XFS_ILOCK_EXCL);
   768		return error;
   769	}
   770	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
