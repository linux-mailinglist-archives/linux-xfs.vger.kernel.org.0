Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5E3F51D4ED
	for <lists+linux-xfs@lfdr.de>; Fri,  6 May 2022 11:46:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1390617AbiEFJtt (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 6 May 2022 05:49:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390678AbiEFJtn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 May 2022 05:49:43 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 15DB665D13
        for <linux-xfs@vger.kernel.org>; Fri,  6 May 2022 02:46:00 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id B524353461C
        for <linux-xfs@vger.kernel.org>; Fri,  6 May 2022 19:45:57 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nmuX6-008fMC-H4
        for linux-xfs@vger.kernel.org; Fri, 06 May 2022 19:45:56 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1nmuX6-0029Sn-G4
        for linux-xfs@vger.kernel.org;
        Fri, 06 May 2022 19:45:56 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: 
Date:   Fri,  6 May 2022 19:45:36 +1000
Message-Id: <20220506094553.512973-1-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=6274ee55
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=oZkIemNP1mAA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=q30YGFRHdTyF80sAfkgA:9 a=xo5jKAKm-U-Zyk2_beg_:22
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

[PATCH 00/17 V3] XFS: LARP state machine and recovery rework

This patchset aims to simplify the state machine that the new logged
attributes require to do their stuff. It also reworks the
attribute logging and recovery algorithms to simplify them and to
avoid leaving incomplete attributes around after recovery.

When I first dug into this code, I modified the state machine
to try to simplify the set and replace operations as there was
a lot of duplicate code in them. I also wasn't completely happy with
the different transistions for replace operations when larp mode was
enabled. I simplified the state machien and renumbered the states so
that we can iterate through the same state progression for different
attr formats just by having different inital leaf and node states.

Once I'd largely done this and started testing it, I realised that
recovery wasn't setting the initial state properly, so I started
digging into the recovery code. At this point, I realised the
recovery code didn't work correctly in all cases and could often
leave unremovable incomplete attrs sitting around. The issues are
larger documented in the last patch in the series, so I won't go
over them here, just read that patch.

However, to get, the whole replace operation for LARP=1 needed to
change. Luckily, that turned out to be pretty simple because it was
largely already broken down into component operations in the state
machine. hence I just needed to add new "remove" initial states to
the set_iter state machine, and that allowed the new algorithm to
function.

Then I realised that I'd just implemented the remove_iter algorithm
in the set_iter state machine, so I removed the remove_iter code and
it's states altogether and just pointed remove ops at the set-iter
remove initial states. The code now uses the XFS_DA_OP_RENAME flag
to determine if it should follow up an add or remove with a remove
or add, and it all largely just works. All runtime algorithms run
throught he same state machine just with different initial states
and state progressions.

And with the last patch in the series, attr item log recovery uses
that same state machine, too. It has a few quirks that need to be
handled, so I added the XFS_DA_OP_RECOVERY flag to allow the right
thing to be done with the INCOMPLETE flag deep in the guts of the
attr lookup code. And so recovery with LARP=1 now seems to mostly
work.

This version passes fstests, several recoveryloop passes and the
targeted error injection based attr recovery test that Catherine
wrote. There's a fair bit of re-org in the patch series since V2,
but most of that is pulling stuff from the last patch and putting it
in the right place in the series. hence the only real logic iand bug
fixes changes occurred in the last patch that changes the logging 
and recovery algorithm.

Comments, reviews and, most especially, testing welcome.

A compose of the patchset I've been testing based on the current
for-next tree can be found here:

git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git xfs-5.19-compose

Version 3:
- rebased on 5.18-rc2 + for-next + rebased larp v29
- added state asserts to xfs_attr_dela_state_set_replace()
- only roll the transactions in ALLOC_RMT when we need to do more
  extent allocation for the remote attr value container.
- removed unnecessary attr->xattri_blkcnt check in ALLOC_RMT
- added comments to commit message to explain why we are combining
  the set and remove paths.
- preserved and isolated the state path save/restore code for
  avoiding repeated name entry path lookups when rolling transactins
  across remove operations.  Left a big comment for Future Dave to
  re-enable the optimisation.
- fixed a transient attr fork removal bug in
  xfs_attr3_leaf_to_shortform() in the new removal algorithm which
  can result in the attr fork being removed between the remove and
  set ops in a REPLACE operation.
- moved defer operation setup changes ("split replace from set op")
  to early on in the series and combined it with the refactoring
  done immediately afterwards in the last patch of the series. This
  allows for cleanly fixing the log recovery state initialisation
  problem the patchset had.
- pulled the state initialisation for log recovery up into the
  patches that introduce the state machine changes for the given
  operations.
- Lots of changes to log recovery algorithm change in last patch.

Version 2:
https://lore.kernel.org/linux-xfs/20220414094434.2508781-1-david@fromorbit.com/
- fixed attrd initialisation for LARP=1 mode
- fixed REPLACE->REMOVE_OLD state transition for LARP=1 mode
- added more comments to describe the assumptions that allow
  xfs_attr_remove_leaf_attr() to work for both modes

