Return-Path: <linux-xfs+bounces-171-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0576E7FB60B
	for <lists+linux-xfs@lfdr.de>; Tue, 28 Nov 2023 10:40:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 578C6B215FF
	for <lists+linux-xfs@lfdr.de>; Tue, 28 Nov 2023 09:40:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88DFB49F94;
	Tue, 28 Nov 2023 09:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="XcOGbW0y"
X-Original-To: linux-xfs@vger.kernel.org
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2999410D2
	for <linux-xfs@vger.kernel.org>; Tue, 28 Nov 2023 01:39:57 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id d2e1a72fcca58-6cbb71c3020so4388013b3a.1
        for <linux-xfs@vger.kernel.org>; Tue, 28 Nov 2023 01:39:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1701164396; x=1701769196; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NeHZtBvmgEVffu6Pbw7kKyeRlzxbAWt8wPJwPKikjYc=;
        b=XcOGbW0yUNa6NQzKhKsthBcPh1BVRTcyCSLcKbxE6pyPETkCYy8edpk6h0b8aM6EVO
         ZrgfT64y/Bvfv3OchAOia+uZNVHhtvpx6a6JJhBP5sh9/idS9ckZkjGct/g5itKjLVwG
         yw2a1fXDIUzZBst3gd7B/mABjbNOih5cvbmtMFpLksVOocDh8ARQfcPci8H+tpYja0y8
         YQwcVA0S6tatLdVfjJgGjosxdKWTtmk1LKrvunKOaLChFIi/pwrXjfThmTMhqXJB9fW/
         ZAVVheO6wyQQSVZ5hgdbKcFKd3zRHb1MEScXKkszYULHTwHPPype05LQdl4A/7eGMWxD
         cwXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701164396; x=1701769196;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=NeHZtBvmgEVffu6Pbw7kKyeRlzxbAWt8wPJwPKikjYc=;
        b=JpboyekfE50QQ7fL52i8Tj+8CfCr7Wh/kF2ENejaIev7cz+O5/MmrBqAqOO6Hot7Sa
         vf9Q9uRfMhjPd5itm2pD5OACfnkJYbxrVLpjbF1OJjRN8hplFlw4+rOFLoZVg55u9W91
         MxfUh8mbZ5Qyowd/OCKwnTgJkH0GX4OotbIyI+U+y6iFFyV2XG5AyJrRvEtQAN9HXzCF
         njQRyT1bKwmQpJaWqjS59TmbYcR830lCTX7ecT0XalnY8TRbrSiAChhBTR9fZgWUt8EY
         +5czmPM29hQ8R2shxs6qKVUa7WsI7+wuOUffc4LvOq+kV10iu0dXMR1voNE32i18j6aF
         LGNw==
X-Gm-Message-State: AOJu0YwcmZdWkz8q9iSSjM4lv/vHbAPfSSJU4MBX3+yCg04hTbIQLsaP
	e02J7EcAD69p8bnyC6AWb+gLoQ==
X-Google-Smtp-Source: AGHT+IGJiWG3nlRzwHHhr2F3nKKnI+nGhKfgVz18h5EOlX1qdv89D9Y38y/IAiHXXbT3QRYVqihiHg==
X-Received: by 2002:a05:6a21:a5a0:b0:17a:4871:63fd with SMTP id gd32-20020a056a21a5a000b0017a487163fdmr24686577pzc.0.1701164396523;
        Tue, 28 Nov 2023 01:39:56 -0800 (PST)
Received: from [10.3.205.193] ([61.213.176.11])
        by smtp.gmail.com with ESMTPSA id u26-20020a62ed1a000000b006cbcd08ed56sm8521050pfh.56.2023.11.28.01.39.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Nov 2023 01:39:56 -0800 (PST)
Message-ID: <39b76473-fe00-0f1b-62e3-ae349a9f80d3@bytedance.com>
Date: Tue, 28 Nov 2023 17:39:50 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.1
Subject: [PATCH 2/2] xfs: update dir3 leaf block metadata after swap
To: Christoph Hellwig <hch@infradead.org>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
 "Darrick J. Wong" <djwong@kernel.org>, Dave Chinner <dchinner@redhat.com>,
 Allison Henderson <allison.henderson@oracle.com>,
 Zhang Tianci <zhangtianci.1997@bytedance.com>,
 Brian Foster <bfoster@redhat.com>, Ben Myers <bpm@sgi.com>,
 linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 xieyongji@bytedance.com, me@jcix.top
References: <20231128053202.29007-1-zhangjiachen.jaycee@bytedance.com>
 <20231128053202.29007-3-zhangjiachen.jaycee@bytedance.com>
 <ZWWnQYo73yHnctvi@infradead.org>
From: Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>
In-Reply-To: <ZWWnQYo73yHnctvi@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2023/11/28 16:39, Christoph Hellwig wrote:
> On Tue, Nov 28, 2023 at 01:32:02PM +0800, Jiachen Zhang wrote:
>> From: Zhang Tianci <zhangtianci.1997@bytedance.com>
>>
>> xfs_da3_swap_lastblock() copy the last block content to the dead block,
>> but do not update the metadata in it. We need update some metadata
>> for some kinds of type block, such as dir3 leafn block records its
>> blkno, we shall update it to the dead block blkno. Otherwise,
>> before write the xfs_buf to disk, the verify_write() will fail in
>> blk_hdr->blkno != xfs_buf->b_bn, then xfs will be shutdown.
> 
> Do you have a reproducer for this?  It would be very helpful to add it
> to xfstests.

Hi Christoph,

Thanks for the review!

It's hard to reproduce the issue. Currently we can reproduce it with
some kernel code changes. We forcely reserve 0 t_blk_res for xfs_remove
on kernel version 4.19:

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index f2d06e1e4906..c8f84b95a0ec 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2551,13 +2551,8 @@ xfs_remove(
          * insert tries to happen, instead trimming the LAST
          * block from the directory.
          */
-       resblks = XFS_REMOVE_SPACE_RES(mp);
-       error = xfs_trans_alloc(mp, &M_RES(mp)->tr_remove, resblks, 0, 
0, &tp);
-       if (error == -ENOSPC) {
-               resblks = 0;
-               error = xfs_trans_alloc(mp, &M_RES(mp)->tr_remove, 0, 0, 0,
-                               &tp);
-       }
+       resblks = 0;
+       error = xfs_trans_alloc(mp, &M_RES(mp)->tr_remove, 0, 0, 0, &tp);
         if (error) {
                 ASSERT(error != -ENOSPC);
                 goto std_return


After insmod the new modified xfs.ko, run the following scripts, and it
can reproduce the problem consistently on the final `umount mnt`:

fallocate -l 1G xfs.img
mkfs.xfs -f xfs.img
mkdir -p mnt
losetup /dev/loop0 xfs.img
mount -t xfs /dev/loop0 mnt
pushd mnt
mkdir dir3
prefix="a_"
for j in $(seq 0 13); do
     for i in $(seq 0 2800); do
             touch dir3/${prefix}_${i}_${j}
     done
     for i in $(seq 0 2500); do
             rm -f dir3/${prefix}_${i}_${j}
             if [ "$i" == "2094" ] && [ "$j" == "13" ]; then
                     echo "should reproduce now, so break here!"
                     break;
             fi
     done
done
popd
umount mnt


We are still trying to make a reproducer without any kernel changes. Do
you have any suggestions on this?


> 
>>
>> We will get this warning:
>>
>>    XFS (dm-0): Metadata corruption detected at xfs_dir3_leaf_verify+0xa8/0xe0 [xfs], xfs_dir3_leafn block 0x178
>>    XFS (dm-0): Unmount and run xfs_repair
>>    XFS (dm-0): First 128 bytes of corrupted metadata buffer:
>>    00000000e80f1917: 00 80 00 0b 00 80 00 07 3d ff 00 00 00 00 00 00  ........=.......
>>    000000009604c005: 00 00 00 00 00 00 01 a0 00 00 00 00 00 00 00 00  ................
>>    000000006b6fb2bf: e4 44 e3 97 b5 64 44 41 8b 84 60 0e 50 43 d9 bf  .D...dDA..`.PC..
>>    00000000678978a2: 00 00 00 00 00 00 00 83 01 73 00 93 00 00 00 00  .........s......
>>    00000000b28b247c: 99 29 1d 38 00 00 00 00 99 29 1d 40 00 00 00 00  .).8.....).@....
>>    000000002b2a662c: 99 29 1d 48 00 00 00 00 99 49 11 00 00 00 00 00  .).H.....I......
>>    00000000ea2ffbb8: 99 49 11 08 00 00 45 25 99 49 11 10 00 00 48 fe  .I....E%.I....H.
>>    0000000069e86440: 99 49 11 18 00 00 4c 6b 99 49 11 20 00 00 4d 97  .I....Lk.I. ..M.
>>    XFS (dm-0): xfs_do_force_shutdown(0x8) called from line 1423 of file fs/xfs/xfs_buf.c.  Return address = 00000000c0ff63c1
>>    XFS (dm-0): Corruption of in-memory data detected.  Shutting down filesystem
>>    XFS (dm-0): Please umount the filesystem and rectify the problem(s)
>>
>> >From the log above, we know xfs_buf->b_no is 0x178, but the block's hdr record
>> its blkno is 0x1a0.
>>
>> Fixes: 24df33b45ecf ("xfs: add CRC checking to dir2 leaf blocks")
>> Signed-off-by: Zhang Tianci <zhangtianci.1997@bytedance.com>
>> ---
>>   fs/xfs/libxfs/xfs_da_btree.c | 12 +++++++++++-
>>   1 file changed, 11 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
>> index e576560b46e9..35f70e4c6447 100644
>> --- a/fs/xfs/libxfs/xfs_da_btree.c
>> +++ b/fs/xfs/libxfs/xfs_da_btree.c
>> @@ -2318,8 +2318,18 @@ xfs_da3_swap_lastblock(
>>   	 * Copy the last block into the dead buffer and log it.
>>   	 */
>>   	memcpy(dead_buf->b_addr, last_buf->b_addr, args->geo->blksize);
>> -	xfs_trans_log_buf(tp, dead_buf, 0, args->geo->blksize - 1);
>>   	dead_info = dead_buf->b_addr;
>> +	/*
>> +	 * Update the moved block's blkno if it's a dir3 leaf block
>> +	 */
>> +	if (dead_info->magic == cpu_to_be16(XFS_DIR3_LEAF1_MAGIC) ||
>> +	    dead_info->magic == cpu_to_be16(XFS_DIR3_LEAFN_MAGIC) ||
>> +	    dead_info->magic == cpu_to_be16(XFS_ATTR3_LEAF_MAGIC)) {
>> +		struct xfs_da3_blkinfo *dap = (struct xfs_da3_blkinfo *)dead_info;
>> +
>> +		dap->blkno = cpu_to_be64(dead_buf->b_bn);
>> +	}
>> +	xfs_trans_log_buf(tp, dead_buf, 0, args->geo->blksize - 1);
> 
> The fix here looks correct to me, but also a little ugly and ad-hoc.
> 
> At last we should be using container_of and not casts for getting from a
> xfs_da_blkinfo to a xfs_da3_blkinfo (even if there is bad precedence
> for the cast in existing code).
> 

Thanks, we will optimize the code in the next version of the patchset.

> But I think it would be useful to add a helper that stamps in the blkno
> in for a caller that only has as xfs_da_blkinfo but no xfs_da3_blkinfo
> and use in all the places that do it currently in an open coded fashion
> e.g. xfs_da3_root_join, xfs_da3_root_split, xfs_attr3_leaf_to_node.
> 
> That should probably be done on top of the small backportable fix.
> 

I think the idea to add helper is great, and we can do it after this
fixes patch is merged.


Thanks,
Jiachen


