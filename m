Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B527E3E52DA
	for <lists+linux-xfs@lfdr.de>; Tue, 10 Aug 2021 07:24:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233947AbhHJFZR (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 10 Aug 2021 01:25:17 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:41433 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234316AbhHJFZR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Aug 2021 01:25:17 -0400
Received: from dread.disaster.area (pa49-195-182-146.pa.nsw.optusnet.com.au [49.195.182.146])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 004CE10482DE
        for <linux-xfs@vger.kernel.org>; Tue, 10 Aug 2021 15:24:54 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mDKFy-00GZfR-EX
        for linux-xfs@vger.kernel.org; Tue, 10 Aug 2021 15:24:54 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1mDKFy-000ApY-3y
        for linux-xfs@vger.kernel.org; Tue, 10 Aug 2021 15:24:54 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 00/16 v2] xfs: rework feature flags
Date:   Tue, 10 Aug 2021 15:24:35 +1000
Message-Id: <20210810052451.41578-1-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=QpfB3wCSrn/dqEBSktpwZQ==:117 a=QpfB3wCSrn/dqEBSktpwZQ==:17
        a=MhDmnRu9jo8A:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=Ejrl2BXn8bQHwYoJSLEA:9 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

With the shutdown rework, it became very clear that we needed to
make atomic state changes to the mount so that shutdown would be run
once and once only. To do this, we used the mp->m_sb_lock as a
serialisation mechanism rather than introduce a new single use
spinlock for this purpose.

However, what we really need to is to separate the operational state
changes from static feature flag information kept in the mp->m_flags
field. This would allow the m_flags field to remain largely
read-only, and we can make the operational state use atomic bit
operations to set, check and clear the current state.

This separation between state and features was done for the log as
part of the shutdown cleanup work. Reworking the way the xfs mount
feature flags are used is a much bigger undertaking, hence this
separate patchset.

One of the big things we need to address is that features for the
xfs mount can come from multiple sources. They can come from on-disk
state via flags in the superblock, mount options, proc and sysfs
variables, and so on. Each different mechanism has it's own special
way of setting what is effectively read-only boolean state in the
xfs mount that is then checked at runtime by executing code.

In some cases, these boolean checks can be expensive because we have
to do multiple cheaks and mask variables in the superblock to get
the flag information. The naming can be verbose, and the combination
of open coded flag checks vs wrapper based flag checks does little
to improve the readability of the code.

To clean all this up, introduce a m_features field and a m_opstate
field. The m_features field holds all the features the filesysetm
has enabled or disabled, and the m_opstate field holds all the
atomic operational state. m_features is currently a 64 bit variable
with on-disk features starting at bit 0 counting up and mount
features starting at bit 63 and counting down. At the end of the
series, we have roughly 26 on-disk and 16 mount feature flags used,
so there's still plenty of flag space available for future
additions.

The result of moving all the feature flags to the mount is that we
get rid of all the xfs_sb_version_has() wrappers in
libxfs/xfs_format.h. We really want this file to contain the on-disk
format defintion, not code used to access or interpret it. This gets
rid of a large amount of boiler plate wrappers from this file and
replaces them with mount features checks which are much simpler and
lower overhead.

Getting rid of all the sueprblock feature checks reduces the code
size by about 5kB on x86-64. There are about 400
xfs_sb_version_has() feature checks in the code, so saving a few
instructions on every check ends up making a substantial difference
to code size. It also means this patchset is rather large....

There are a few cleanups needed before the patch set starts. We need
to fix up the attr2/noattr2 mount option/superblock bit issues, as
well as properly namespace some internal attribute code so we can
use the global "xfs_" namespace for global feature and operational
state functions.

There are many further cleanups that can be done following on from
this patch set. e.g the xfs_mount has several boolean state/flag
fields that can be moved into the m_opstate and/or m_features
variables, we can shadow state and or features into the log fields
so the log doesn't need to access the xfs_mount to check current
state, runtime quota state can move into the m_opstate field instead
of needing separate flags, etc.

This passes fstests for all the simple configurations (defaults,
quotas, different directory block sizes, etc) without regressions,
so nothing has been obviously broken. There may be corner cases that
I haven't exercises where issues are present, but so far I haven't
found anything.

Version 2:
- rebased on 5.14-rc4 + for-next + "xfs: strictly order log start records"
- added comment about not using bp->b_bn directly for the buffer disk address.
- fix typos in commit messages
- Fixed incorrect feature flag macro definitions in original introduction patch
  rather than fixing them in a subsequent patch.
- Updated open coded superblock checks to check sparse inodes directly instead
  of via xfs_sb_has_incompat_feature().
- use xfs_has_v3inodes() consistently in inode size/version checks.

Version 1:
- https://lore.kernel.org/linux-xfs/20210714041912.2625692-1-david@fromorbit.com/
- based on 5.14-rc1 + "xfs: strictly order log start records"

