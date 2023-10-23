Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F352A7D2AAA
	for <lists+linux-xfs@lfdr.de>; Mon, 23 Oct 2023 08:44:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233337AbjJWGoz (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 23 Oct 2023 02:44:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbjJWGoz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Oct 2023 02:44:55 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C57B188
        for <linux-xfs@vger.kernel.org>; Sun, 22 Oct 2023 23:44:53 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AFEDC433C7;
        Mon, 23 Oct 2023 06:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698043493;
        bh=s6+QL/68ySi2pWQJnF+ckifZkSPZDH7SnhRj9/CDotg=;
        h=References:From:To:Cc:Subject:Date:In-reply-to:From;
        b=Vm7PdqWT14+CYosSvWUhgULso7o0Oer35tGoNzE6VLcoq97WKgF7XvEdI2rYWF50e
         WEkWL2yj5AIzxIG9hloW4IZ9910BKS/Q9GCLLvKo7TUKH5mHJ5xKPQK272PxWWnGBN
         uVcE1WaJQDOmM/n2XJaTb4bc7oVc3r4cWoTCnIs36oubK/WfNX73Ikhd+tKBp8zbNa
         xgXJ2BiseSH/1TXmMgHoHYqqTLYHxM6qr9PA1bFzmEnr5Lc8uIn+A9XDqfLJsR5x+u
         ovelKt8GkSQsD94yKPbRPYpHhG24IV5cQolCgT23Fqsh1Xw5FEs42vramrma37yzap
         7gFFM3fJ/Cm7Q==
References: <20231017201208.18127-1-catherine.hoang@oracle.com>
 <ZS8fztyv43GKNdZR@dread.disaster.area>
User-agent: mu4e 1.8.10; emacs 27.1
From:   Chandan Babu R <chandanbabu@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Catherine Hoang <catherine.hoang@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4] xfs: allow read IO and FICLONE to run concurrently
Date:   Mon, 23 Oct 2023 12:12:46 +0530
In-reply-to: <ZS8fztyv43GKNdZR@dread.disaster.area>
Message-ID: <87il6xzvku.fsf@debian-BULLSEYE-live-builder-AMD64>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


On Wed, Oct 18, 2023 at 10:59:10 AM +1100, Dave Chinner wrote:
> On Tue, Oct 17, 2023 at 01:12:08PM -0700, Catherine Hoang wrote:
>> One of our VM cluster management products needs to snapshot KVM image
>> files so that they can be restored in case of failure. Snapshotting is
>> done by redirecting VM disk writes to a sidecar file and using reflink
>> on the disk image, specifically the FICLONE ioctl as used by
>> "cp --reflink". Reflink locks the source and destination files while it
>> operates, which means that reads from the main vm disk image are blocked,
>> causing the vm to stall. When an image file is heavily fragmented, the
>> copy process could take several minutes. Some of the vm image files have
>> 50-100 million extent records, and duplicating that much metadata locks
>> the file for 30 minutes or more. Having activities suspended for such
>> a long time in a cluster node could result in node eviction.
>> 
>> Clone operations and read IO do not change any data in the source file,
>> so they should be able to run concurrently. Demote the exclusive locks
>> taken by FICLONE to shared locks to allow reads while cloning. While a
>> clone is in progress, writes will take the IOLOCK_EXCL, so they block
>> until the clone completes.
>> 
>> Link: https://lore.kernel.org/linux-xfs/8911B94D-DD29-4D6E-B5BC-32EAF1866245@oracle.com/
>> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
>> ---
>>  fs/xfs/xfs_file.c    | 67 +++++++++++++++++++++++++++++++++++---------
>>  fs/xfs/xfs_inode.c   | 17 +++++++++++
>>  fs/xfs/xfs_inode.h   |  9 ++++++
>>  fs/xfs/xfs_reflink.c |  4 +++
>>  4 files changed, 84 insertions(+), 13 deletions(-)
>
> All looks OK - one minor nit below.
>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
>
>> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
>> index 203700278ddb..3b9500e18f90 100644
>> --- a/fs/xfs/xfs_file.c
>> +++ b/fs/xfs/xfs_file.c
>> @@ -214,6 +214,47 @@ xfs_ilock_iocb(
>>  	return 0;
>>  }
>>  
>> +static int
>> +xfs_ilock_iocb_for_write(
>> +	struct kiocb		*iocb,
>> +	unsigned int		*lock_mode)
>> +{
>> +	ssize_t			ret;
>> +	struct xfs_inode	*ip = XFS_I(file_inode(iocb->ki_filp));
>> +
>> +	ret = xfs_ilock_iocb(iocb, *lock_mode);
>> +	if (ret)
>> +		return ret;
>> +
>> +	if (*lock_mode == XFS_IOLOCK_EXCL)
>> +		return 0;
>> +	if (!xfs_iflags_test(ip, XFS_IREMAPPING))
>> +		return 0;
>> +
>> +	xfs_iunlock(ip, *lock_mode);
>> +	*lock_mode = XFS_IOLOCK_EXCL;
>> +	ret = xfs_ilock_iocb(iocb, *lock_mode);
>> +	if (ret)
>> +		return ret;
>> +
>> +	return 0;
>
> This last bit could simply be:
>
> 	xfs_iunlock(ip, *lock_mode);
> 	*lock_mode = XFS_IOLOCK_EXCL;
> 	return xfs_ilock_iocb(iocb, *lock_mode);
>

Catherine, I have made the modifications suggested above and I have committed
the patch onto my local Git tree.

-- 
Chandan
