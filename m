Return-Path: <linux-xfs+bounces-173-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E5387FB9EB
	for <lists+linux-xfs@lfdr.de>; Tue, 28 Nov 2023 13:10:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D9549B21D2E
	for <lists+linux-xfs@lfdr.de>; Tue, 28 Nov 2023 12:09:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2551F4F8A9;
	Tue, 28 Nov 2023 12:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UxZhaiDK"
X-Original-To: linux-xfs@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53E8BD59;
	Tue, 28 Nov 2023 04:09:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701173393; x=1732709393;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=mtIu5f1hDVaKzrp3gZyRN6bomQimaf0cxFp5LllKoNg=;
  b=UxZhaiDK4zs6A/BpUWP+RqLVQoFykZWA4dqfeUaxIBZGmbfwCTW81cx3
   9f2Duj0JEEGUm7ddoTq4JaQ6e5RWXZYx4WeOMjyBx1FrfkPxsuYIE46dH
   N+Gd+BLRAkzu2AanFwBXmcPq/e9xzF7kN7H/CNF2/S247tBL8kqtY48+S
   Uk3e9deLVI7ABb0v02V6OtezUd/uZS1bYQ0BBDpACdQN06Zs4oSVJgP7O
   ec6tkCY5ShnkXixO4egn2dqMg72zMafP2vdx95lNlL2w93R5m/ObJ9Flf
   GN4MvGxNJRvrvdQq1P2VJaDZ2wqgN+a9KJIA70ocrTaVRDehtU2jLpG+x
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10907"; a="391783864"
X-IronPort-AV: E=Sophos;i="6.04,233,1695711600"; 
   d="scan'208";a="391783864"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2023 04:09:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10907"; a="772294330"
X-IronPort-AV: E=Sophos;i="6.04,233,1695711600"; 
   d="scan'208";a="772294330"
Received: from lkp-server01.sh.intel.com (HELO d584ee6ebdcc) ([10.239.97.150])
  by fmsmga007.fm.intel.com with ESMTP; 28 Nov 2023 04:09:47 -0800
Received: from kbuild by d584ee6ebdcc with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1r7wuP-0007Xk-0i;
	Tue, 28 Nov 2023 12:09:45 +0000
Date: Tue, 28 Nov 2023 20:08:36 +0800
From: kernel test robot <lkp@intel.com>
To: Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>,
	Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: oe-kbuild-all@lists.linux.dev, Dave Chinner <dchinner@redhat.com>,
	Allison Henderson <allison.henderson@oracle.com>,
	Zhang Tianci <zhangtianci.1997@bytedance.com>,
	Brian Foster <bfoster@redhat.com>, Ben Myers <bpm@sgi.com>,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	xieyongji@bytedance.com, me@jcix.top
Subject: Re: [PATCH 2/2] xfs: update dir3 leaf block metadata after swap
Message-ID: <202311281904.r45MkLJq-lkp@intel.com>
References: <20231128053202.29007-3-zhangjiachen.jaycee@bytedance.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231128053202.29007-3-zhangjiachen.jaycee@bytedance.com>

Hi Jiachen,

kernel test robot noticed the following build errors:

[auto build test ERROR on xfs-linux/for-next]
[also build test ERROR on linus/master v6.7-rc3 next-20231128]
[cannot apply to djwong-xfs/djwong-devel]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Jiachen-Zhang/xfs-ensure-tmp_logflags-is-initialized-in-xfs_bmap_del_extent_real/20231128-135955
base:   https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git for-next
patch link:    https://lore.kernel.org/r/20231128053202.29007-3-zhangjiachen.jaycee%40bytedance.com
patch subject: [PATCH 2/2] xfs: update dir3 leaf block metadata after swap
config: i386-randconfig-141-20231128 (https://download.01.org/0day-ci/archive/20231128/202311281904.r45MkLJq-lkp@intel.com/config)
compiler: clang version 16.0.4 (https://github.com/llvm/llvm-project.git ae42196bc493ffe877a7e3dff8be32035dea4d07)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20231128/202311281904.r45MkLJq-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202311281904.r45MkLJq-lkp@intel.com/

All errors (new ones prefixed by >>):

>> fs/xfs/libxfs/xfs_da_btree.c:2330:38: error: no member named 'b_bn' in 'struct xfs_buf'
                   dap->blkno = cpu_to_be64(dead_buf->b_bn);
                                            ~~~~~~~~  ^
   include/linux/byteorder/generic.h:92:21: note: expanded from macro 'cpu_to_be64'
   #define cpu_to_be64 __cpu_to_be64
                       ^
   include/uapi/linux/byteorder/little_endian.h:38:53: note: expanded from macro '__cpu_to_be64'
   #define __cpu_to_be64(x) ((__force __be64)__swab64((x)))
                                                       ^
   include/uapi/linux/swab.h:128:54: note: expanded from macro '__swab64'
   #define __swab64(x) (__u64)__builtin_bswap64((__u64)(x))
                                                        ^
   1 error generated.


vim +2330 fs/xfs/libxfs/xfs_da_btree.c

  2254	
  2255	/*
  2256	 * Ick.  We need to always be able to remove a btree block, even
  2257	 * if there's no space reservation because the filesystem is full.
  2258	 * This is called if xfs_bunmapi on a btree block fails due to ENOSPC.
  2259	 * It swaps the target block with the last block in the file.  The
  2260	 * last block in the file can always be removed since it can't cause
  2261	 * a bmap btree split to do that.
  2262	 */
  2263	STATIC int
  2264	xfs_da3_swap_lastblock(
  2265		struct xfs_da_args	*args,
  2266		xfs_dablk_t		*dead_blknop,
  2267		struct xfs_buf		**dead_bufp)
  2268	{
  2269		struct xfs_da_blkinfo	*dead_info;
  2270		struct xfs_da_blkinfo	*sib_info;
  2271		struct xfs_da_intnode	*par_node;
  2272		struct xfs_da_intnode	*dead_node;
  2273		struct xfs_dir2_leaf	*dead_leaf2;
  2274		struct xfs_da_node_entry *btree;
  2275		struct xfs_da3_icnode_hdr par_hdr;
  2276		struct xfs_inode	*dp;
  2277		struct xfs_trans	*tp;
  2278		struct xfs_mount	*mp;
  2279		struct xfs_buf		*dead_buf;
  2280		struct xfs_buf		*last_buf;
  2281		struct xfs_buf		*sib_buf;
  2282		struct xfs_buf		*par_buf;
  2283		xfs_dahash_t		dead_hash;
  2284		xfs_fileoff_t		lastoff;
  2285		xfs_dablk_t		dead_blkno;
  2286		xfs_dablk_t		last_blkno;
  2287		xfs_dablk_t		sib_blkno;
  2288		xfs_dablk_t		par_blkno;
  2289		int			error;
  2290		int			w;
  2291		int			entno;
  2292		int			level;
  2293		int			dead_level;
  2294	
  2295		trace_xfs_da_swap_lastblock(args);
  2296	
  2297		dead_buf = *dead_bufp;
  2298		dead_blkno = *dead_blknop;
  2299		tp = args->trans;
  2300		dp = args->dp;
  2301		w = args->whichfork;
  2302		ASSERT(w == XFS_DATA_FORK);
  2303		mp = dp->i_mount;
  2304		lastoff = args->geo->freeblk;
  2305		error = xfs_bmap_last_before(tp, dp, &lastoff, w);
  2306		if (error)
  2307			return error;
  2308		if (XFS_IS_CORRUPT(mp, lastoff == 0))
  2309			return -EFSCORRUPTED;
  2310		/*
  2311		 * Read the last block in the btree space.
  2312		 */
  2313		last_blkno = (xfs_dablk_t)lastoff - args->geo->fsbcount;
  2314		error = xfs_da3_node_read(tp, dp, last_blkno, &last_buf, w);
  2315		if (error)
  2316			return error;
  2317		/*
  2318		 * Copy the last block into the dead buffer and log it.
  2319		 */
  2320		memcpy(dead_buf->b_addr, last_buf->b_addr, args->geo->blksize);
  2321		dead_info = dead_buf->b_addr;
  2322		/*
  2323		 * Update the moved block's blkno if it's a dir3 leaf block
  2324		 */
  2325		if (dead_info->magic == cpu_to_be16(XFS_DIR3_LEAF1_MAGIC) ||
  2326		    dead_info->magic == cpu_to_be16(XFS_DIR3_LEAFN_MAGIC) ||
  2327		    dead_info->magic == cpu_to_be16(XFS_ATTR3_LEAF_MAGIC)) {
  2328			struct xfs_da3_blkinfo *dap = (struct xfs_da3_blkinfo *)dead_info;
  2329	
> 2330			dap->blkno = cpu_to_be64(dead_buf->b_bn);
  2331		}
  2332		xfs_trans_log_buf(tp, dead_buf, 0, args->geo->blksize - 1);
  2333		/*
  2334		 * Get values from the moved block.
  2335		 */
  2336		if (dead_info->magic == cpu_to_be16(XFS_DIR2_LEAFN_MAGIC) ||
  2337		    dead_info->magic == cpu_to_be16(XFS_DIR3_LEAFN_MAGIC)) {
  2338			struct xfs_dir3_icleaf_hdr leafhdr;
  2339			struct xfs_dir2_leaf_entry *ents;
  2340	
  2341			dead_leaf2 = (xfs_dir2_leaf_t *)dead_info;
  2342			xfs_dir2_leaf_hdr_from_disk(dp->i_mount, &leafhdr,
  2343						    dead_leaf2);
  2344			ents = leafhdr.ents;
  2345			dead_level = 0;
  2346			dead_hash = be32_to_cpu(ents[leafhdr.count - 1].hashval);
  2347		} else {
  2348			struct xfs_da3_icnode_hdr deadhdr;
  2349	
  2350			dead_node = (xfs_da_intnode_t *)dead_info;
  2351			xfs_da3_node_hdr_from_disk(dp->i_mount, &deadhdr, dead_node);
  2352			btree = deadhdr.btree;
  2353			dead_level = deadhdr.level;
  2354			dead_hash = be32_to_cpu(btree[deadhdr.count - 1].hashval);
  2355		}
  2356		sib_buf = par_buf = NULL;
  2357		/*
  2358		 * If the moved block has a left sibling, fix up the pointers.
  2359		 */
  2360		if ((sib_blkno = be32_to_cpu(dead_info->back))) {
  2361			error = xfs_da3_node_read(tp, dp, sib_blkno, &sib_buf, w);
  2362			if (error)
  2363				goto done;
  2364			sib_info = sib_buf->b_addr;
  2365			if (XFS_IS_CORRUPT(mp,
  2366					   be32_to_cpu(sib_info->forw) != last_blkno ||
  2367					   sib_info->magic != dead_info->magic)) {
  2368				error = -EFSCORRUPTED;
  2369				goto done;
  2370			}
  2371			sib_info->forw = cpu_to_be32(dead_blkno);
  2372			xfs_trans_log_buf(tp, sib_buf,
  2373				XFS_DA_LOGRANGE(sib_info, &sib_info->forw,
  2374						sizeof(sib_info->forw)));
  2375			sib_buf = NULL;
  2376		}
  2377		/*
  2378		 * If the moved block has a right sibling, fix up the pointers.
  2379		 */
  2380		if ((sib_blkno = be32_to_cpu(dead_info->forw))) {
  2381			error = xfs_da3_node_read(tp, dp, sib_blkno, &sib_buf, w);
  2382			if (error)
  2383				goto done;
  2384			sib_info = sib_buf->b_addr;
  2385			if (XFS_IS_CORRUPT(mp,
  2386					   be32_to_cpu(sib_info->back) != last_blkno ||
  2387					   sib_info->magic != dead_info->magic)) {
  2388				error = -EFSCORRUPTED;
  2389				goto done;
  2390			}
  2391			sib_info->back = cpu_to_be32(dead_blkno);
  2392			xfs_trans_log_buf(tp, sib_buf,
  2393				XFS_DA_LOGRANGE(sib_info, &sib_info->back,
  2394						sizeof(sib_info->back)));
  2395			sib_buf = NULL;
  2396		}
  2397		par_blkno = args->geo->leafblk;
  2398		level = -1;
  2399		/*
  2400		 * Walk down the tree looking for the parent of the moved block.
  2401		 */
  2402		for (;;) {
  2403			error = xfs_da3_node_read(tp, dp, par_blkno, &par_buf, w);
  2404			if (error)
  2405				goto done;
  2406			par_node = par_buf->b_addr;
  2407			xfs_da3_node_hdr_from_disk(dp->i_mount, &par_hdr, par_node);
  2408			if (XFS_IS_CORRUPT(mp,
  2409					   level >= 0 && level != par_hdr.level + 1)) {
  2410				error = -EFSCORRUPTED;
  2411				goto done;
  2412			}
  2413			level = par_hdr.level;
  2414			btree = par_hdr.btree;
  2415			for (entno = 0;
  2416			     entno < par_hdr.count &&
  2417			     be32_to_cpu(btree[entno].hashval) < dead_hash;
  2418			     entno++)
  2419				continue;
  2420			if (XFS_IS_CORRUPT(mp, entno == par_hdr.count)) {
  2421				error = -EFSCORRUPTED;
  2422				goto done;
  2423			}
  2424			par_blkno = be32_to_cpu(btree[entno].before);
  2425			if (level == dead_level + 1)
  2426				break;
  2427			xfs_trans_brelse(tp, par_buf);
  2428			par_buf = NULL;
  2429		}
  2430		/*
  2431		 * We're in the right parent block.
  2432		 * Look for the right entry.
  2433		 */
  2434		for (;;) {
  2435			for (;
  2436			     entno < par_hdr.count &&
  2437			     be32_to_cpu(btree[entno].before) != last_blkno;
  2438			     entno++)
  2439				continue;
  2440			if (entno < par_hdr.count)
  2441				break;
  2442			par_blkno = par_hdr.forw;
  2443			xfs_trans_brelse(tp, par_buf);
  2444			par_buf = NULL;
  2445			if (XFS_IS_CORRUPT(mp, par_blkno == 0)) {
  2446				error = -EFSCORRUPTED;
  2447				goto done;
  2448			}
  2449			error = xfs_da3_node_read(tp, dp, par_blkno, &par_buf, w);
  2450			if (error)
  2451				goto done;
  2452			par_node = par_buf->b_addr;
  2453			xfs_da3_node_hdr_from_disk(dp->i_mount, &par_hdr, par_node);
  2454			if (XFS_IS_CORRUPT(mp, par_hdr.level != level)) {
  2455				error = -EFSCORRUPTED;
  2456				goto done;
  2457			}
  2458			btree = par_hdr.btree;
  2459			entno = 0;
  2460		}
  2461		/*
  2462		 * Update the parent entry pointing to the moved block.
  2463		 */
  2464		btree[entno].before = cpu_to_be32(dead_blkno);
  2465		xfs_trans_log_buf(tp, par_buf,
  2466			XFS_DA_LOGRANGE(par_node, &btree[entno].before,
  2467					sizeof(btree[entno].before)));
  2468		*dead_blknop = last_blkno;
  2469		*dead_bufp = last_buf;
  2470		return 0;
  2471	done:
  2472		if (par_buf)
  2473			xfs_trans_brelse(tp, par_buf);
  2474		if (sib_buf)
  2475			xfs_trans_brelse(tp, sib_buf);
  2476		xfs_trans_brelse(tp, last_buf);
  2477		return error;
  2478	}
  2479	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

