Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28F2E34E0AD
	for <lists+linux-xfs@lfdr.de>; Tue, 30 Mar 2021 07:32:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230244AbhC3Fbd (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 30 Mar 2021 01:31:33 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:53967 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229567AbhC3FbD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Mar 2021 01:31:03 -0400
Received: from dread.disaster.area (pa49-181-239-12.pa.nsw.optusnet.com.au [49.181.239.12])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id 550172428
        for <linux-xfs@vger.kernel.org>; Tue, 30 Mar 2021 16:31:02 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lR6xx-008N43-AL
        for linux-xfs@vger.kernel.org; Tue, 30 Mar 2021 16:31:01 +1100
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1lR6xx-005cnf-13
        for linux-xfs@vger.kernel.org; Tue, 30 Mar 2021 16:31:01 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 0/4] xfs: fix eager attr fork init regressions
Date:   Tue, 30 Mar 2021 16:30:55 +1100
Message-Id: <20210330053059.1339949-1-david@fromorbit.com>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0 cx=a_idp_x
        a=gO82wUwQTSpaJfP49aMSow==:117 a=gO82wUwQTSpaJfP49aMSow==:17
        a=dESyimp9J3IA:10 a=1Tsw_b6L3zzIHSBBH24A:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

These are the fixes for the attr fork regressions in the current
for-next tree. The got through testing because none of my test
regression VMs had selinux enabled on them, while my perf test VMs
did. Hence it was never exercised by the fstests runs I did.

I've re-enabled selinux on some of my test VMs, and run it through
fstests ofor v4 and v5 filesystems with selinux enabled.

The first 3 patches are the fixes that address the regressions. The
last patch is an optimisation I noticed that avoids recalculating a
static, fixed value on every call to xfs_default_attroffset(). It is
not needed for the bugs to be fixed, but is definitely a for-next
candidate while I'm touching that code again.

Cheers,

Dave.

