Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45ED04766E6
	for <lists+linux-xfs@lfdr.de>; Thu, 16 Dec 2021 01:21:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230469AbhLPAVS (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 15 Dec 2021 19:21:18 -0500
Received: from sandeen.net ([63.231.237.45]:49404 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229517AbhLPAVS (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Dec 2021 19:21:18 -0500
Received: from [10.0.0.146] (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 3486948F7;
        Wed, 15 Dec 2021 18:20:56 -0600 (CST)
Message-ID: <d797a746-dc8f-c74a-bb15-637b6b3ecbe7@sandeen.net>
Date:   Wed, 15 Dec 2021 18:21:16 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.0
Subject: Re: [PATCH] xfs: check sb_meta_uuid for dabuf buffer recovery
Content-Language: en-US
To:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
References: <20211216001709.3451729-1-david@fromorbit.com>
From:   Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <20211216001709.3451729-1-david@fromorbit.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 12/15/21 6:17 PM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Got a report that a repeated crash test of a container host would
> eventually fail with a log recovery error preventing the system from
> mounting the root filesystem. It manifested as a directory leaf node
> corruption on writeback like so:
> 
>   XFS (loop0): Mounting V5 Filesystem
>   XFS (loop0): Starting recovery (logdev: internal)
>   XFS (loop0): Metadata corruption detected at xfs_dir3_leaf_check_int+0x99/0xf0, xfs_dir3_leaf1 block 0x12faa158
>   XFS (loop0): Unmount and run xfs_repair
>   XFS (loop0): First 128 bytes of corrupted metadata buffer:
>   00000000: 00 00 00 00 00 00 00 00 3d f1 00 00 e1 9e d5 8b  ........=.......
>   00000010: 00 00 00 00 12 fa a1 58 00 00 00 29 00 00 1b cc  .......X...)....
>   00000020: 91 06 78 ff f7 7e 4a 7d 8d 53 86 f2 ac 47 a8 23  ..x..~J}.S...G.#
>   00000030: 00 00 00 00 17 e0 00 80 00 43 00 00 00 00 00 00  .........C......
>   00000040: 00 00 00 2e 00 00 00 08 00 00 17 2e 00 00 00 0a  ................
>   00000050: 02 35 79 83 00 00 00 30 04 d3 b4 80 00 00 01 50  .5y....0.......P
>   00000060: 08 40 95 7f 00 00 02 98 08 41 fe b7 00 00 02 d4  .@.......A......
>   00000070: 0d 62 ef a7 00 00 01 f2 14 50 21 41 00 00 00 0c  .b.......P!A....
>   XFS (loop0): Corruption of in-memory data (0x8) detected at xfs_do_force_shutdown+0x1a/0x20 (fs/xfs/xfs_buf.c:1514).  Shutting down.
>   XFS (loop0): Please unmount the filesystem and rectify the problem(s)
>   XFS (loop0): log mount/recovery failed: error -117
>   XFS (loop0): log mount failed
> 
> Tracing indicated that we were recovering changes from a transaction
> at LSN 0x29/0x1c16 into a buffer that had an LSN of 0x29/0x1d57.
> That is, log recovery was overwriting a buffer with newer changes on
> disk than was in the transaction. Tracing indicated that we were
> hitting the "recovery immediately" case in
> xfs_buf_log_recovery_lsn(), and hence it was ignoring the LSN in the
> buffer.
> 
> The code was extracting the LSN correctly, then ignoring it because
> the UUID in the buffer did not match the superblock UUID. The
> problem arises because the UUID check uses the wrong UUID - it
> should be checking the sb_meta_uuid, not sb_uuid. This filesystem
> has sb_uuid != sb_meta_uuid (which is fine), and the buffer has the
> correct matching sb_meta_uuid in it, it's just the code checked it
> against the wrong superblock uuid.
> 
> The is no corruption in the filesystem, and failing to recover the
> buffer due to a write verifier failure means the recovery bug did
> not propagate the corruption to disk. Hence there is no corruption
> before or after this bug has manifested, the impact is limited
> simply to an unmountable filesystem....
> 
> This was missed back in 2015 during an audit of incorrect sb_uuid
> usage that resulted in commit fcfbe2c4ef42 ("xfs: log recovery needs
> to validate against sb_meta_uuid") that fixed the magic32 buffers to
> validate against sb_meta_uuid instead of sb_uuid. It missed the
> magicda buffers....
> 
> Fixes: ce748eaa65f2 ("xfs: create new metadata UUID field and incompat flag")
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Kind of amazing it took so long to turn up and get found, eh?

Thanks Dave,

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>   fs/xfs/xfs_buf_item_recover.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
> index 70ca5751b13e..e484251dc9c8 100644
> --- a/fs/xfs/xfs_buf_item_recover.c
> +++ b/fs/xfs/xfs_buf_item_recover.c
> @@ -816,7 +816,7 @@ xlog_recover_get_buf_lsn(
>   	}
>   
>   	if (lsn != (xfs_lsn_t)-1) {
> -		if (!uuid_equal(&mp->m_sb.sb_uuid, uuid))
> +		if (!uuid_equal(&mp->m_sb.sb_meta_uuid, uuid))
>   			goto recover_immediately;
>   		return lsn;
>   	}
