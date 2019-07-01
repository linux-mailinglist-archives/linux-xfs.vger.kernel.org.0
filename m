Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E0E95C37F
	for <lists+linux-xfs@lfdr.de>; Mon,  1 Jul 2019 21:12:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726587AbfGATMQ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 1 Jul 2019 15:12:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8087 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726509AbfGATMQ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 1 Jul 2019 15:12:16 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 723FD3097052;
        Mon,  1 Jul 2019 19:12:11 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1B62A194AE;
        Mon,  1 Jul 2019 19:12:11 +0000 (UTC)
Date:   Mon, 1 Jul 2019 15:12:09 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 00/11] xfs: rework extent allocation
Message-ID: <20190701191209.GC45202@bfoster>
References: <20190522180546.17063-1-bfoster@redhat.com>
 <20190621151835.GX5387@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190621151835.GX5387@magnolia>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Mon, 01 Jul 2019 19:12:16 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 21, 2019 at 08:18:35AM -0700, Darrick J. Wong wrote:
> On Wed, May 22, 2019 at 02:05:35PM -0400, Brian Foster wrote:
> > Hi all,
> > 
> > This is v2 of the extent allocation rework series. The changes in this
> > version are mostly associated with code factoring, based on feedback to
> > v1. The small mode helper refactoring has been isolated and pulled to
> > the start of the series. The active flag that necessitated the btree
> > cursor container structure has been pushed into the xfs_btree_cur
> > private area. The resulting high level allocation code in
> > xfs_ag_alloc_vextent() has been cleaned up to remove an unnecessary
> > level of abstraction. Finally, there are various minor cleanups and
> > fixes.
> 
> Hmmm.  Just for fun I decided to apply this series to see what would
> happen, and on a 1k block filesystem shook out a test failure that seems
> like it could be related?
> 

I had reproduced this earlier on and eventually determined it was kind
of circumstantial with respect to this series. I had eliminated some of
the operations from generic/223 for more quick reproduction/RCA and
ultimately reproduced the same behavior on upstream (at the time, which
was probably a month or two ago by now) with a slightly different
workload. That lead to the following series:

https://marc.info/?l=linux-xfs&m=155671950608062&w=2

... which IIRC addressed the problem in both scenarios. Thoughts on
those patches?

Brian

> MKFS_OPTIONS='-f -m reflink=1,rmapbt=1 -i sparse=1, -b size=1024, /dev/sdf'
> MOUNT_OPTIONS='-o usrquota,grpquota,prjquota /dev/sdf /opt'
> 
> --D
> 
> --- generic/223.out
> +++ generic/223.out.bad
> @@ -48,7 +48,7 @@
>  === Testing size 1g falloc on 8k stripe ===
>  SCRATCH_MNT/file-1g-falloc: well-aligned
>  === Testing size 1073745920 falloc on 8k stripe ===
> -SCRATCH_MNT/file-1073745920-falloc: well-aligned
> +SCRATCH_MNT/file-1073745920-falloc: Start block 197673 not multiple of sunit 2
>  === mkfs with su 4 blocks x 4 ===
>  === Testing size 1*16k on 16k stripe ===
>  SCRATCH_MNT/file-1-16384-falloc: well-aligned
> @@ -98,7 +98,7 @@
>  === Testing size 1g falloc on 16k stripe ===
>  SCRATCH_MNT/file-1g-falloc: well-aligned
>  === Testing size 1073745920 falloc on 16k stripe ===
> -SCRATCH_MNT/file-1073745920-falloc: well-aligned
> +SCRATCH_MNT/file-1073745920-falloc: Start block 197673 not multiple of sunit 4
>  === mkfs with su 8 blocks x 4 ===
>  === Testing size 1*32k on 32k stripe ===
>  SCRATCH_MNT/file-1-32768-falloc: well-aligned
> @@ -148,7 +148,7 @@
>  === Testing size 1g falloc on 32k stripe ===
>  SCRATCH_MNT/file-1g-falloc: well-aligned
>  === Testing size 1073745920 falloc on 32k stripe ===
> -SCRATCH_MNT/file-1073745920-falloc: well-aligned
> +SCRATCH_MNT/file-1073745920-falloc: Start block 197673 not multiple of sunit 8
>  === mkfs with su 16 blocks x 4 ===
>  === Testing size 1*64k on 64k stripe ===
>  SCRATCH_MNT/file-1-65536-falloc: well-aligned
> @@ -198,7 +198,7 @@
>  === Testing size 1g falloc on 64k stripe ===
>  SCRATCH_MNT/file-1g-falloc: well-aligned
>  === Testing size 1073745920 falloc on 64k stripe ===
> -SCRATCH_MNT/file-1073745920-falloc: well-aligned
> +SCRATCH_MNT/file-1073745920-falloc: Start block 197665 not multiple of sunit 16
>  === mkfs with su 32 blocks x 4 ===
>  === Testing size 1*128k on 128k stripe ===
>  SCRATCH_MNT/file-1-131072-falloc: well-aligned
