Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEDBB3B3AE5
	for <lists+linux-xfs@lfdr.de>; Fri, 25 Jun 2021 04:31:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233004AbhFYCdW (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 24 Jun 2021 22:33:22 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:49523 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232973AbhFYCdV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Jun 2021 22:33:21 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 16D6D86292E;
        Fri, 25 Jun 2021 12:30:59 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lwbcP-00GgUM-P4; Fri, 25 Jun 2021 12:30:57 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1lwbcP-006BG2-En; Fri, 25 Jun 2021 12:30:57 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 0/3] mm, xfs: memory allocation improvements
Date:   Fri, 25 Jun 2021 12:30:26 +1000
Message-Id: <20210625023029.1472466-1-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=r6YtysWOX24A:10 a=_MWFLEjnuH9FteaNsk4A:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

We're slowly trying to move the XFS code closer to the common memory
allocation routines everyone else uses. This patch set addresses a
regression from a previous set of changes (kmem_realloc() removal)
and removes another couple of kmem wrappers from within the XFS
code.

The first patch addresses a regression - using large directory
blocks triggers a warning when calling krealloc() recombine a buffer
split across across two log records into a single contiguous
memory buffer. this results in krealloc() being called to allocate a
64kB buffer with __GFP_NOFAIL being set. This warning is trivially
reproduced by generic/040 and generic/041 when run with 64kB
directory block sizes on a 4kB page size machine.

Log recovery really needs to use kvmalloc() like all the other
"allocate up to 64kB and can't fail" cases in filesystem code (e.g.
for xattrs), but there's no native kvrealloc() function that
provides us with the necessary semantics. So rather than add a new
wrapper, the first patch adds this helper to the common code and
converts XFS to use it for log recovery.

The latter two patches are removing what are essentially kvmalloc()
wrappers from XFS. With the more widespread use of
memalloc_nofs_save/restore(), we can call kvmalloc(GFP_KERNEL) and
just have it do the right thing because GFP_NOFS contexts are
covered by PF_MEMALLOC_NOFS task flags now. Hence we don't need
kmem_alloc_large() anymore. And with the slab code guaranteeing at
least 512 byte alignment for sector and block sized heap
allocations, we no longer need the kmem_alloc_io() variant of
kmem_alloc_large() for IO buffers. So these wrappers can all go
away...

Cheers,

Dave.

