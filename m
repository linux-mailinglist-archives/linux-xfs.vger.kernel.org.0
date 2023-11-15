Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 236FF7DE058
	for <lists+linux-xfs@lfdr.de>; Wed,  1 Nov 2023 12:30:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235225AbjKALaz (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 1 Nov 2023 07:30:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235207AbjKALay (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Nov 2023 07:30:54 -0400
Received: from esa9.hc1455-7.c3s2.iphmx.com (esa9.hc1455-7.c3s2.iphmx.com [139.138.36.223])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AF43121;
        Wed,  1 Nov 2023 04:30:51 -0700 (PDT)
X-IronPort-AV: E=McAfee;i="6600,9927,10880"; a="126581274"
X-IronPort-AV: E=Sophos;i="6.03,268,1694703600"; 
   d="scan'208";a="126581274"
Received: from unknown (HELO yto-r1.gw.nic.fujitsu.com) ([218.44.52.217])
  by esa9.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Nov 2023 20:30:49 +0900
Received: from yto-m1.gw.nic.fujitsu.com (yto-nat-yto-m1.gw.nic.fujitsu.com [192.168.83.64])
        by yto-r1.gw.nic.fujitsu.com (Postfix) with ESMTP id E7ECDD9DA9;
        Wed,  1 Nov 2023 20:30:46 +0900 (JST)
Received: from kws-ab3.gw.nic.fujitsu.com (kws-ab3.gw.nic.fujitsu.com [192.51.206.21])
        by yto-m1.gw.nic.fujitsu.com (Postfix) with ESMTP id 39C19CFA5A;
        Wed,  1 Nov 2023 20:30:46 +0900 (JST)
Received: from edo.cn.fujitsu.com (edo.cn.fujitsu.com [10.167.33.5])
        by kws-ab3.gw.nic.fujitsu.com (Postfix) with ESMTP id A83FB20077827;
        Wed,  1 Nov 2023 20:30:45 +0900 (JST)
Received: from [192.168.50.5] (unknown [10.167.226.34])
        by edo.cn.fujitsu.com (Postfix) with ESMTP id 3C78C1A006F;
        Wed,  1 Nov 2023 19:30:44 +0800 (CST)
Message-ID: <88e9bc61-ac74-4503-a29a-d4f8dba841c1@fujitsu.com>
Date:   Wed, 1 Nov 2023 19:30:43 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ANNOUNCE] xfs-linux: for-next updated to 22c2699cb068
To:     Chandan Babu R <chandanbabu@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, catherine.hoang@oracle.com,
        cheng.lin130@zte.com.cn, dan.j.williams@intel.com,
        dchinner@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-xfs@vger.kernel.org, osandov@fb.com,
        "Darrick J. Wong" <djwong@kernel.org>
References: <87fs1s3bk6.fsf@debian-BULLSEYE-live-builder-AMD64>
 <20231031090242.GA25889@lst.de> <20231031164359.GA1041814@frogsfrogsfrogs>
 <875y2mk9fo.fsf@debian-BULLSEYE-live-builder-AMD64>
From:   Shiyang Ruan <ruansy.fnst@fujitsu.com>
In-Reply-To: <875y2mk9fo.fsf@debian-BULLSEYE-live-builder-AMD64>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSS-9.1.0.1417-9.0.0.1002-27970.007
X-TM-AS-User-Approved-Sender: Yes
X-TMASE-Version: IMSS-9.1.0.1417-9.0.1002-27970.007
X-TMASE-Result: 10--12.676000-10.000000
X-TMASE-MatchedRID: mafpUJSAc1CPvrMjLFD6eHchRkqzj/bEC/ExpXrHizxBqLOmHiM3w/tl
        NRuGlPT/GApc67FGFgwxeHwgHyVfP9MMbVgJKQCJatGCGdi/nWoxXH/dlhvLv8v8BP3RkorXVhY
        Zjy1spv54uAitfy71buI0KIuLJPBCh2Em++ruuH+OtWfhyZ77DithirXYhZk5Uqcf/uZ2V1ijxY
        yRBa/qJQYnglAWdCYb9BIhiTDfOc3YoM82yqmFMvoLR4+zsDTtD12T7q2dIUtO7oA8A9JhHuM6H
        GE5OQFKwFdBRkLAn2brh8DF2dbkaQ==
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



在 2023/11/1 1:02, Chandan Babu R 写道:
> On Tue, Oct 31, 2023 at 09:43:59 AM -0700, Darrick J. Wong wrote:
>> On Tue, Oct 31, 2023 at 10:02:42AM +0100, Christoph Hellwig wrote:
>>> Can you also pick up:
>>>
>>> "xfs: only remap the written blocks in xfs_reflink_end_cow_extent"
>>>
>>> ?
>>>
>>> Also this seems to a bit of a mix of fixes for 6.7 and big stuff that
>>> is too late for the merge window.
>>
>> If by 'big stuff' you mean the MF_MEM_PRE_REMOVE patch, then yes, I
>> agree that it's too late to be changing code outside xfs.  Bumping that
>> to 6.8 will disappoint Shiyang, regrettably.
>>
> 
> I am sorry Shiyang, I will have to postpone your "mm, pmem, xfs: Introduce
> MF_MEM_PRE_REMOVE for unbind" patch for v6.8. The delay was my
> mistake. Apologies once again.

Never mind~  Then we'll have more time to test it, make sure the 
functionality is good.


--
Thanks,
Ruan.

> 
> I have updated xfs-linux's for-next branch and I will be sending an
> announcement shortly.
> 
