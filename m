Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4FF5F3E4D
	for <lists+linux-xfs@lfdr.de>; Fri,  8 Nov 2019 04:11:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726219AbfKHDLR (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 7 Nov 2019 22:11:17 -0500
Received: from mail.cn.fujitsu.com ([183.91.158.132]:6644 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725930AbfKHDLQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Nov 2019 22:11:16 -0500
X-IronPort-AV: E=Sophos;i="5.68,280,1569254400"; 
   d="scan'208";a="78040346"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 08 Nov 2019 11:10:57 +0800
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id A9B984B6AE15;
        Fri,  8 Nov 2019 11:02:52 +0800 (CST)
Received: from [10.167.225.140] (10.167.225.140) by
 G08CNEXCHPEKD01.g08.fujitsu.local (10.167.33.89) with Microsoft SMTP Server
 (TLS) id 14.3.439.0; Fri, 8 Nov 2019 11:11:05 +0800
Subject: Re: [RFC PATCH v2 0/7] xfs: reflink & dedupe for fsdax (read/write
 path).
To:     <linux-xfs@vger.kernel.org>, <linux-nvdimm@lists.01.org>,
        <darrick.wong@oracle.com>, <rgoldwyn@suse.de>, <hch@infradead.org>,
        <david@fromorbit.com>
CC:     <linux-kernel@vger.kernel.org>, <gujx@cn.fujitsu.com>,
        <qi.fuli@fujitsu.com>, <caoj.fnst@cn.fujitsu.com>
References: <20191030041358.14450-1-ruansy.fnst@cn.fujitsu.com>
From:   Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
Message-ID: <e33532a2-a9e5-1578-bdd8-a83d4710a151@cn.fujitsu.com>
Date:   Fri, 8 Nov 2019 11:10:56 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20191030041358.14450-1-ruansy.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.225.140]
X-yoursite-MailScanner-ID: A9B984B6AE15.AC5F9
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: ruansy.fnst@cn.fujitsu.com
X-Spam-Status: No
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Darrick, Dave,

Do you have any comment on this?

On 10/30/19 12:13 PM, Shiyang Ruan wrote:
> This patchset aims to take care of this issue to make reflink and dedupe
> work correctly (actually in read/write path, there still has some problems,
> such as the page->mapping and page->index issue, in mmap path) in XFS under
> fsdax mode.
> 
> It is based on Goldwyn's patchsets: "v4 Btrfs dax support" and the latest
> iomap.  I borrowed some patches related and made a few fix to make it
> basically works fine.
> 
> For dax framework:
>    1. adapt to the latest change in iomap (two iomaps).
> 
> For XFS:
>    1. distinguish dax write/zero from normal write/zero.
>    2. remap extents after COW.
>    3. add file contents comparison function based on dax framework.
>    4. use xfs_break_layouts() instead of break_layout to support dax.
> 
> 
> Goldwyn Rodrigues (3):
>    dax: replace mmap entry in case of CoW
>    fs: dedup file range to use a compare function
>    dax: memcpy before zeroing range
> 
> Shiyang Ruan (4):
>    dax: Introduce dax_copy_edges() for COW.
>    dax: copy data before write.
>    xfs: handle copy-on-write in fsdax write() path.
>    xfs: support dedupe for fsdax.
> 
>   fs/btrfs/ioctl.c       |   3 +-
>   fs/dax.c               | 211 +++++++++++++++++++++++++++++++++++++----
>   fs/iomap/buffered-io.c |   8 +-
>   fs/ocfs2/file.c        |   2 +-
>   fs/read_write.c        |  11 ++-
>   fs/xfs/xfs_bmap_util.c |   6 +-
>   fs/xfs/xfs_file.c      |  10 +-
>   fs/xfs/xfs_iomap.c     |   3 +-
>   fs/xfs/xfs_iops.c      |  11 ++-
>   fs/xfs/xfs_reflink.c   |  79 ++++++++-------
>   include/linux/dax.h    |  16 ++--
>   include/linux/fs.h     |   9 +-
>   12 files changed, 291 insertions(+), 78 deletions(-)
> 

-- 
Thanks,
Shiyang Ruan.


