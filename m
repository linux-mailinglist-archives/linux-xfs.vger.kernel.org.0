Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B85A716BC0
	for <lists+linux-xfs@lfdr.de>; Tue,  7 May 2019 21:55:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbfEGTzQ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 7 May 2019 15:55:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:53074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726706AbfEGTzP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 7 May 2019 15:55:15 -0400
Subject: Re: [GIT PULL] xfs: new features for 5.2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557258915;
        bh=XzCqZnL3HN5KGhwuaOlL2x8iE8dcCN9mo/yUtriWIhk=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=L8rkaXFzBD49+xPy1guliprNDW4mbr52IaOdJ9liaoBvJej6Uocij2s87KgxTkv+I
         qTwBHP8i1f1Wyny6fGeUcodlJGmLriADd3mR/A5rO5vL7clx8TEw0gezhEpI7v0ljj
         nKNGE5Pz8yf1glf9akN8wj8Q0X6fdCh1JnsvSwbo=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20190507154635.GT5207@magnolia>
References: <20190507154635.GT5207@magnolia>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20190507154635.GT5207@magnolia>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git
 tags/xfs-5.2-merge-4
X-PR-Tracked-Commit-Id: 910832697cf85536c7fe26edb8bc6f830c4b9bb6
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: aa26690fab1380735442e027ce4b17849a24493f
Message-Id: <155725891523.4809.3872123512989253384.pr-tracker-bot@kernel.org>
Date:   Tue, 07 May 2019 19:55:15 +0000
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     torvalds@linux-foundation.org, Dave Chinner <david@fromorbit.com>,
        linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
        sandeen@sandeen.net, hch@lst.de
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The pull request you sent on Tue, 7 May 2019 08:46:35 -0700:

> git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-5.2-merge-4

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/aa26690fab1380735442e027ce4b17849a24493f

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
