Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3907240EE65
	for <lists+linux-xfs@lfdr.de>; Fri, 17 Sep 2021 02:39:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241734AbhIQAlL (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 16 Sep 2021 20:41:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:35130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241826AbhIQAlL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 16 Sep 2021 20:41:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3D996611EE;
        Fri, 17 Sep 2021 00:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631839190;
        bh=X6Jr/3dIVyjEi4pk/fJ4pEehD70agYrnBZFEwfot6w4=;
        h=Subject:From:To:Cc:Date:From;
        b=e0FrVEzQUA04Z7M184L8MHuc+E/eTIv2PAogsfjUyCUIfLJ+DDPVUCnD+tI+1rCUj
         hZEHHHc2f941gg7AsgQHni64fM+OY2ZYKfmi3aBLldOFwRByCEwiHofoFUZTUBymiS
         BXgt5IrntPlglpSIpoC161z56SdotZiN3oawsdDHHEXGSpSUHCKQ8yf/uUyAD+Jrzd
         5IsGCUuLIUupEPrQfzcCDcQXVNCc4DIFsbsYKBQQISIbpCWq45QmYL/gINhdAsFNkf
         V0O5hCR79g7t5gdy0KY9bGUJXazi3meRcq6OU1ldE859KML7k1Tfqj9myLeU9bT0/x
         mDzlgeWR7zTTg==
Subject: [PATCHSET 0/3] fstests: various cleanups to ./new script
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Thu, 16 Sep 2021 17:39:50 -0700
Message-ID: <163183918998.953189.9876855385681643134.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

In the process of reviewing the group name documentation, it became
obvious that there were quite a few cleanups that could be applied to
the ./new script.  Rather than lengthen the group name doc series, I've
moved them all to a separate patchset that cleans up the group name
validation code, tidies up some of the old bashisms with new ones, and
then disallows the creation of new tests in the 'other' group.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=new-script-cleanups
---
 new |   76 +++++++++++++++++++++++++++++++++++++------------------------------
 1 file changed, 42 insertions(+), 34 deletions(-)

