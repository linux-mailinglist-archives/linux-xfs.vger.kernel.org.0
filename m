Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9B7597521
	for <lists+linux-xfs@lfdr.de>; Wed, 21 Aug 2019 10:38:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727790AbfHUIiY (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 21 Aug 2019 04:38:24 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:43640 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727788AbfHUIiY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Aug 2019 04:38:24 -0400
Received: from dread.disaster.area (pa49-195-190-67.pa.nsw.optusnet.com.au [49.195.190.67])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 336E83615A7
        for <linux-xfs@vger.kernel.org>; Wed, 21 Aug 2019 18:38:22 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i0M7G-0004zd-UJ
        for linux-xfs@vger.kernel.org; Wed, 21 Aug 2019 18:37:14 +1000
Received: from dave by discord.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i0M8N-00036u-J1
        for linux-xfs@vger.kernel.org; Wed, 21 Aug 2019 18:38:23 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 0/3] xfs: avoid IO issues unaligned memory allocation
Date:   Wed, 21 Aug 2019 18:38:17 +1000
Message-Id: <20190821083820.11725-1-david@fromorbit.com>
X-Mailer: git-send-email 2.23.0.rc1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0
        a=TR82T6zjGmBjdfWdGgpkDw==:117 a=TR82T6zjGmBjdfWdGgpkDw==:17
        a=FmdZ9Uzk2mMA:10 a=Nz5SjAYpqZ1Qj0xnSxkA:9
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

These patches fix the issue reported by Vishal on 5.3-rc1 with pmem,
reproduced on brd, and previously seen with xenblk.

The core issue is that when memory allocation debugging is turned
on, heap memory is no longer naturally aligned and that means
we attach memory with large memory regions with random alignment to
bios. Some block drivers only support 512 byte aligned memory
buffers, and these then silently break when fed an unaligned
buffers.

This happens silently because nothing in the block or driver layers
actually validates that memory buffers containing kernel memory
are correctly aligned. Buffers may be bounced in the drivers if
they are unaligned, but not all driver support this, hence the
breakage.

This patchset added memory allocation tracing, 512 byte aligned
allocation support via kmem_alloc_io(), and a re-implementation of
bio_add_page() to add memory buffer alignment verification. The last
patch causes unaligned allocations to fail fast, noisily and safely,
such that any developer running KASAN will immediately notice if
XFS attaches an unaligned mmemory buffer to a bio....

Cheers,

Dave.


