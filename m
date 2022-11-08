Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 086B1620650
	for <lists+linux-xfs@lfdr.de>; Tue,  8 Nov 2022 02:50:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233035AbiKHBue (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 7 Nov 2022 20:50:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232308AbiKHBue (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Nov 2022 20:50:34 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FB591CFC8
        for <linux-xfs@vger.kernel.org>; Mon,  7 Nov 2022 17:50:32 -0800 (PST)
Received: from kwepemi500019.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4N5rdm0KhYz15MSd;
        Tue,  8 Nov 2022 09:50:20 +0800 (CST)
Received: from [10.174.177.238] (10.174.177.238) by
 kwepemi500019.china.huawei.com (7.221.188.117) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 8 Nov 2022 09:50:29 +0800
Message-ID: <1afe73bb-481c-01b3-8c61-3d208e359f40@huawei.com>
Date:   Tue, 8 Nov 2022 09:50:29 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.2
Subject: Re: [PATCH] xfs: fix incorrect usage of xfs_btree_check_block
To:     "Darrick J. Wong" <djwong@kernel.org>
CC:     <dchinner@redhat.com>, <linux-xfs@vger.kernel.org>,
        <houtao1@huawei.com>, <jack.qiu@huawei.com>, <fangwei1@huawei.com>,
        <yi.zhang@huawei.com>, <zhengbin13@huawei.com>,
        <leo.lilong@huawei.com>, <zengheng4@huawei.com>
References: <20221103113709.251669-1-guoxuenan@huawei.com>
 <Y2k5NTjTRdsDAuhN@magnolia>
From:   Guo Xuenan <guoxuenan@huawei.com>
In-Reply-To: <Y2k5NTjTRdsDAuhN@magnolia>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.238]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemi500019.china.huawei.com (7.221.188.117)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2022/11/8 0:58, Darrick J. Wong wrote:
> On Thu, Nov 03, 2022 at 07:37:09PM +0800, Guo Xuenan wrote:
>> xfs_btree_check_block contains a tag XFS_ERRTAG_BTREE_CHECK_{L,S}BLOCK,
>> it is a fault injection tag, better not use it in the macro ASSERT.
>>
>> Since with XFS_DEBUG setting up, we can always trigger assert by `echo 1
>>> /sys/fs/xfs/${disk}/errortag/btree_chk_{s,l}blk`.
>> It's confusing and strange.
> Please be more specific about how this is confusing or strange.
I meant in current code, the ASSERT will alway happen,when we
`echo 1 > /sys/fs/xfs/${disk}/errortag/btree_chk_{s,l}blk`.
xfs_btree_islastblock
   ->ASSERT(block && xfs_btree_check_block(cur, block, level, bp) == 0);
     ->xfs_btree_check_{l/s}block
       ->XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BTREE_CHECK_{S,L}BLOCK)
we can use error injection to trigger this ASSERT.
I think ASERRT macro and error injection are to find some effective 
problems,
not to create some kernel panic. So, putting the error injection 
function in
ASSERT is a little strange.

>> Instead of using it in ASSERT, replace it with
>> xfs_warn.
>>
>> Fixes: 27d9ee577dcc ("xfs: actually check xfs_btree_check_block return in xfs_btree_islastblock")
>> Signed-off-by: Guo Xuenan <guoxuenan@huawei.com>
>> ---
>>   fs/xfs/libxfs/xfs_btree.h | 7 +++++--
>>   1 file changed, 5 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
>> index eef27858a013..637513087c18 100644
>> --- a/fs/xfs/libxfs/xfs_btree.h
>> +++ b/fs/xfs/libxfs/xfs_btree.h
>> @@ -556,8 +556,11 @@ xfs_btree_islastblock(
>>   	struct xfs_buf		*bp;
>>   
>>   	block = xfs_btree_get_block(cur, level, &bp);
>> -	ASSERT(block && xfs_btree_check_block(cur, block, level, bp) == 0);
>> -
>> +	ASSERT(block);
>> +#if defined(DEBUG) || defined(XFS_WARN)
>> +	if (xfs_btree_check_block(cur, block, level, bp))
>> +		xfs_warn(cur->bc_mp, "%s: xfs_btree_check_block() error.", __func__);
>> +#endif
> ...because this seems like open-coding ASSERT, possibly without the
> panic on errors part.
yes，exactly！I also think it can be deleted, but i have no idea if this 
is necessary,
I just retain it in this fix patch; looking forward to your decision :)
> --D
>
>>   	if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
>>   		return block->bb_u.l.bb_rightsib == cpu_to_be64(NULLFSBLOCK);
>>   	return block->bb_u.s.bb_rightsib == cpu_to_be32(NULLAGBLOCK);
>> -- 
>> 2.31.1
>>
> .

-- 
Guo Xuenan [OS Kernel Lab]
-----------------------------
Email: guoxuenan@huawei.com

