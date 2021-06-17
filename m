Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B17EF3AA801
	for <lists+linux-xfs@lfdr.de>; Thu, 17 Jun 2021 02:22:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230211AbhFQAYM (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 16 Jun 2021 20:24:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:57954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229636AbhFQAYL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 16 Jun 2021 20:24:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB0E760041;
        Thu, 17 Jun 2021 00:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623889324;
        bh=DiMCn/bhtFcK2rV9zLL3KA8/eH81oFsrcQ54BpPBqxU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QoVm3aCFpW0+z9twOJv5sIca44AN/mtMEVIPgkaLCuM3YtBQM/JjGLeRVN+E/AkEw
         qXf6EzIiUdxpqr8BazvvfiVWGDouQ3fhtTASVdOf/GTRGWAUtcHZdSRvbIHFFmV5e6
         v4zEdV3TnVN81VW93mlC9UgJmZIYfuByxxcAfoke/qTAzC/25xr7MYmfXLgTIjNQ47
         Zkd69KgCGR07wnXx6H/HBR2hM6jq4uwqw3l8o4+LoTcFMbgcDkzxVrL0U0YDOtvw9O
         wHX5D0wq6BEkvgfHRH4SXsmJJYntzkM0MO0HhfPuqaKtQaruLRuqvbwQdjA/e7sAwK
         f0h/6mg/wu1Jw==
Date:   Wed, 16 Jun 2021 17:22:04 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: New Defects reported by Coverity Scan for linux-next weekly scan
Message-ID: <20210617002204.GB158232@locust>
References: <60c8c255db7df_c93642aabada739a0965bf@prd-scan-dashboard-0.mail>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <60c8c255db7df_c93642aabada739a0965bf@prd-scan-dashboard-0.mail>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hey Allison,

Would you mind taking a look at this static checker report from the
build robot and fixing whatever it's complaining about, please? :)

--D

> ** CID 1505244:  Uninitialized variables  (UNINIT)
> /fs/xfs/libxfs/xfs_attr.c: 1481 in xfs_attr_remove_iter()
> 
> 
> ________________________________________________________________________________________________________
> *** CID 1505244:  Uninitialized variables  (UNINIT)
> /fs/xfs/libxfs/xfs_attr.c: 1481 in xfs_attr_remove_iter()
> 1475     		 * If the result is small enough, push it all into the inode.
> 1476     		 * This is our final state so it's safe to return a dirty
> 1477     		 * transaction.
> 1478     		 */
> 1479     		if (xfs_attr_is_leaf(dp))
> 1480     			error = xfs_attr_node_shrink(args, state);
> >>>     CID 1505244:  Uninitialized variables  (UNINIT)
> >>>     Using uninitialized value "error".
> 1481     		ASSERT(error != -EAGAIN);
> 1482     		break;
> 1483     	default:
> 1484     		ASSERT(0);
> 1485     		error = -EINVAL;
> 1486     		goto out;
> 
