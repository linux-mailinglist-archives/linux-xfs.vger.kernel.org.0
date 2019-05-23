Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98439285E1
	for <lists+linux-xfs@lfdr.de>; Thu, 23 May 2019 20:25:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731337AbfEWSZS (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 23 May 2019 14:25:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:33770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731237AbfEWSZS (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 23 May 2019 14:25:18 -0400
Subject: Re: [GIT PULL] xfs: fixes for 5.2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558635917;
        bh=4swXZDyheX0+mVhMrRucUExxVjZCYez9cbpbOfSgUMA=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=TDkAY1qbMjR7TumFE0radCRAWxn8OnVCid5M71m2yOQndOkkrcZ4aq4Ijy/azVNiG
         hmShr6Nbt2CSgfHlPI3ZLrSJ72HWXeJ5vXZklm+xNO1ycxKe0oAX6VhVFInaCJYNSJ
         1kzyvGhL3WX/ldtyGLR4gqHP6efoOaVdLGaW+K7E=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20190523153346.GG5141@magnolia>
References: <20190523153346.GG5141@magnolia>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20190523153346.GG5141@magnolia>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git
 tags/xfs-5.2-fixes-1
X-PR-Tracked-Commit-Id: 5cd213b0fec640a46adc5e6e4dfc7763aa54b3b2
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 4dde821e4296e156d133b98ddc4c45861935a4fb
Message-Id: <155863591788.31149.9259350999930839889.pr-tracker-bot@kernel.org>
Date:   Thu, 23 May 2019 18:25:17 +0000
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     torvalds@linux-foundation.org,
        "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
        sandeen@sandeen.net, hch@lst.de
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The pull request you sent on Thu, 23 May 2019 08:33:46 -0700:

> git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-5.2-fixes-1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/4dde821e4296e156d133b98ddc4c45861935a4fb

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
