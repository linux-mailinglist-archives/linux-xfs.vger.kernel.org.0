Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03C7658EE16
	for <lists+linux-xfs@lfdr.de>; Wed, 10 Aug 2022 16:19:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbiHJOTJ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 10 Aug 2022 10:19:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231360AbiHJOTB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Aug 2022 10:19:01 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2678672864
        for <linux-xfs@vger.kernel.org>; Wed, 10 Aug 2022 07:19:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660141140; x=1691677140;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=gwpElo91nbJLMfbT69BfgrP5tFToewBa8v3FMTAjvII=;
  b=aZUdv2lCikVtWsJ2mNjpAJ0LGsM4d8kQgdEzO5ZNqbMCxQIgt6XhneQ1
   HHGqRmGI1U6f7yFhm8O/SOtnOvjGCKifL3+HyDvqixZ54mQKq7v/rMh7r
   j3rW1VieYhMekjWb+B8QVnlLhGN5CPVsz1DuleG+XHiRCCAA6pxN/2ZEn
   TFYNOCB6KJSQQTa6qW+VWQei1Io9YbKv4AmLNOoJbkfuI7X5J7sNb9ZTn
   yRcXROxCr8YeJcZBOW7O+T3faL3O+JBQG0hPZhDtK9O1dTWSlw6ZMFE6l
   8gRtfLEGrCGe36amcxeXC7jZW/r30PtriMERYj2/Y3bpudoO1+Mj+b1rs
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10435"; a="289846887"
X-IronPort-AV: E=Sophos;i="5.93,227,1654585200"; 
   d="scan'208";a="289846887"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2022 07:18:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,227,1654585200"; 
   d="scan'208";a="932904241"
Received: from lkp-server02.sh.intel.com (HELO 5d6b42aa80b8) ([10.239.97.151])
  by fmsmga005.fm.intel.com with ESMTP; 10 Aug 2022 07:18:50 -0700
Received: from kbuild by 5d6b42aa80b8 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oLmXp-0000KR-1g;
        Wed, 10 Aug 2022 14:18:49 +0000
Date:   Wed, 10 Aug 2022 22:17:53 +0800
From:   kernel test robot <lkp@intel.com>
To:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Cc:     kbuild-all@lists.01.org
Subject: Re: [PATCH 1/9] xfs: move and xfs_trans_committed_bulk
Message-ID: <202208102203.TPVkxa2S-lkp@intel.com>
References: <20220809230353.3353059-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220809230353.3353059-2-david@fromorbit.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Dave,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on xfs-linux/for-next]
[also build test WARNING on linus/master next-20220810]
[cannot apply to v5.19]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Dave-Chinner/xfs-byte-base-grant-head-reservation-tracking/20220810-072405
base:   https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git for-next
config: i386-allyesconfig (https://download.01.org/0day-ci/archive/20220810/202208102203.TPVkxa2S-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-3) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/f02000d53b0e6d6ac32e63c1ac72be9aa7c1b69c
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Dave-Chinner/xfs-byte-base-grant-head-reservation-tracking/20220810-072405
        git checkout f02000d53b0e6d6ac32e63c1ac72be9aa7c1b69c
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=i386 SHELL=/bin/bash fs/xfs/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> fs/xfs/xfs_log_cil.c:729:1: warning: no previous prototype for 'xlog_cil_ail_insert' [-Wmissing-prototypes]
     729 | xlog_cil_ail_insert(
         | ^~~~~~~~~~~~~~~~~~~


vim +/xlog_cil_ail_insert +729 fs/xfs/xfs_log_cil.c

   707	
   708	/*
   709	 * Take the checkpoint's log vector chain of items and insert the attached log
   710	 * items into the the AIL. This uses bulk insertion techniques to minimise AIL
   711	 * lock traffic.
   712	 *
   713	 * If we are called with the aborted flag set, it is because a log write during
   714	 * a CIL checkpoint commit has failed. In this case, all the items in the
   715	 * checkpoint have already gone through iop_committed and iop_committing, which
   716	 * means that checkpoint commit abort handling is treated exactly the same as an
   717	 * iclog write error even though we haven't started any IO yet. Hence in this
   718	 * case all we need to do is iop_committed processing, followed by an
   719	 * iop_unpin(aborted) call.
   720	 *
   721	 * The AIL cursor is used to optimise the insert process. If commit_lsn is not
   722	 * at the end of the AIL, the insert cursor avoids the need to walk the AIL to
   723	 * find the insertion point on every xfs_log_item_batch_insert() call. This
   724	 * saves a lot of needless list walking and is a net win, even though it
   725	 * slightly increases that amount of AIL lock traffic to set it up and tear it
   726	 * down.
   727	 */
   728	void
 > 729	xlog_cil_ail_insert(
   730		struct xlog		*log,
   731		struct list_head	*lv_chain,
   732		xfs_lsn_t		commit_lsn,
   733		bool			aborted)
   734	{
   735	#define LOG_ITEM_BATCH_SIZE	32
   736		struct xfs_ail		*ailp = log->l_ailp;
   737		struct xfs_log_item	*log_items[LOG_ITEM_BATCH_SIZE];
   738		struct xfs_log_vec	*lv;
   739		struct xfs_ail_cursor	cur;
   740		int			i = 0;
   741	
   742		spin_lock(&ailp->ail_lock);
   743		xfs_trans_ail_cursor_last(ailp, &cur, commit_lsn);
   744		spin_unlock(&ailp->ail_lock);
   745	
   746		/* unpin all the log items */
   747		list_for_each_entry(lv, lv_chain, lv_list) {
   748			struct xfs_log_item	*lip = lv->lv_item;
   749			xfs_lsn_t		item_lsn;
   750	
   751			if (aborted)
   752				set_bit(XFS_LI_ABORTED, &lip->li_flags);
   753	
   754			if (lip->li_ops->flags & XFS_ITEM_RELEASE_WHEN_COMMITTED) {
   755				lip->li_ops->iop_release(lip);
   756				continue;
   757			}
   758	
   759			if (lip->li_ops->iop_committed)
   760				item_lsn = lip->li_ops->iop_committed(lip, commit_lsn);
   761			else
   762				item_lsn = commit_lsn;
   763	
   764			/* item_lsn of -1 means the item needs no further processing */
   765			if (XFS_LSN_CMP(item_lsn, (xfs_lsn_t)-1) == 0)
   766				continue;
   767	
   768			/*
   769			 * if we are aborting the operation, no point in inserting the
   770			 * object into the AIL as we are in a shutdown situation.
   771			 */
   772			if (aborted) {
   773				ASSERT(xlog_is_shutdown(ailp->ail_log));
   774				if (lip->li_ops->iop_unpin)
   775					lip->li_ops->iop_unpin(lip, 1);
   776				continue;
   777			}
   778	
   779			if (item_lsn != commit_lsn) {
   780	
   781				/*
   782				 * Not a bulk update option due to unusual item_lsn.
   783				 * Push into AIL immediately, rechecking the lsn once
   784				 * we have the ail lock. Then unpin the item. This does
   785				 * not affect the AIL cursor the bulk insert path is
   786				 * using.
   787				 */
   788				spin_lock(&ailp->ail_lock);
   789				if (XFS_LSN_CMP(item_lsn, lip->li_lsn) > 0)
   790					xfs_trans_ail_update(ailp, lip, item_lsn);
   791				else
   792					spin_unlock(&ailp->ail_lock);
   793				if (lip->li_ops->iop_unpin)
   794					lip->li_ops->iop_unpin(lip, 0);
   795				continue;
   796			}
   797	
   798			/* Item is a candidate for bulk AIL insert.  */
   799			log_items[i++] = lv->lv_item;
   800			if (i >= LOG_ITEM_BATCH_SIZE) {
   801				xlog_cil_ail_insert_batch(ailp, &cur, log_items,
   802						LOG_ITEM_BATCH_SIZE, commit_lsn);
   803				i = 0;
   804			}
   805		}
   806	
   807		/* make sure we insert the remainder! */
   808		if (i)
   809			xlog_cil_ail_insert_batch(ailp, &cur, log_items, i, commit_lsn);
   810	
   811		spin_lock(&ailp->ail_lock);
   812		xfs_trans_ail_cursor_done(&cur);
   813		spin_unlock(&ailp->ail_lock);
   814	}
   815	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
