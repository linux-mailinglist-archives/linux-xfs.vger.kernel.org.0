Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49D272F5F2B
	for <lists+linux-xfs@lfdr.de>; Thu, 14 Jan 2021 11:46:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727857AbhANKqB (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 14 Jan 2021 05:46:01 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:50201 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727778AbhANKqB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Jan 2021 05:46:01 -0500
Received: from ip5f5af0a0.dynamic.kabel-deutschland.de ([95.90.240.160] helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1l007v-00065N-2G; Thu, 14 Jan 2021 10:45:19 +0000
Date:   Thu, 14 Jan 2021 11:45:11 +0100
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix up non-directory creation in SGID directories
Message-ID: <20210114104511.kekdiqumjvo2lo7v@wittgenstein>
References: <20210113184630.2285768-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210113184630.2285768-1-hch@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 13, 2021 at 07:46:30PM +0100, Christoph Hellwig wrote:
> XFS always inherits the SGID bit if it is set on the parent inode, while
> the generic inode_init_owner does not do this in a few cases where it can
> create a possible security problem, see commit 0fa3ecd87848
> ("Fix up non-directory creation in SGID directories") for details.
> 
> Switch XFS to use the generic helper for the normal path to fix this,
> just keeping the simple field inheritance open coded for the case of the
> non-sgid case with the bsdgrpid mount option.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Reported-by: Christian Brauner <christian.brauner@ubuntu.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Christian Brauner <christian.brauner@ubuntu.com>

I ran the idmapped mounts xfstests on this patchset. With this patch
applied I was able to remove the special casing for xfs (apart from the
irix compatibility check) and got clean test runs:


1. with regular setgid inheritance rules
root@f2-vm:/xfstests# ./check generic/622
FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/x86_64 f2-vm 5.11.0-rc3-brauner-idmapped-mounts-xfs #311 SMP Thu Jan 14 09:55:14 UTC 2021
MKFS_OPTIONS  -- -f -bsize=4096 /dev/loop7
MOUNT_OPTIONS -- /dev/loop7 /mnt/scratch

generic/622 1s ...  2s
Ran: generic/622
Passed all 1 tests

2. with irix_sgid_inherit setgid inheritance rules
root@f2-vm:/xfstests# echo 1 > /proc/sys/fs/xfs/irix_sgid_inherit
root@f2-vm:/xfstests# ./check generic/622
FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/x86_64 f2-vm 5.11.0-rc3-brauner-idmapped-mounts-xfs #311 SMP Thu Jan 14 09:55:14 UTC 2021
MKFS_OPTIONS  -- -f -bsize=4096 /dev/loop7
MOUNT_OPTIONS -- /dev/loop7 /mnt/scratch

generic/622 2s ...  1s
Ran: generic/622
Passed all 1 tests

Thanks!
Christian
