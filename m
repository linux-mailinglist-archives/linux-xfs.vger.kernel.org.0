Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DE633BA6C8
	for <lists+linux-xfs@lfdr.de>; Sat,  3 Jul 2021 04:58:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230427AbhGCDAp (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 2 Jul 2021 23:00:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:59730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230512AbhGCDAm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 2 Jul 2021 23:00:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D5E25613EB;
        Sat,  3 Jul 2021 02:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625281089;
        bh=dMnEdaPx9/EdrUMGVUrKTs1ZyPeyDqU7vPvS/9KdVc0=;
        h=Subject:From:To:Cc:Date:From;
        b=OqNkqmBrCyrYNNhEP5t3pMjb60tcDXA+dzjhIHBoUzvZuaIaHt7/f5X2HZGwhUuwA
         SLHJMSEEqkFToePrfXu7nUxzCCRN1OYlg1uymCww36WYwRHhvcRlcjEfWm7TpTOACy
         16sb0N+TqVvkumFWK1TAUBxWSVujhD0RjflOrC2WwBoT3jtaIkOIFjnu7ZhBfawuL3
         WpFr7Yoo3LU6wks6MgVwUkaNHzA77/t552dsMepupmcgxHPFZy3p9o/OIddIUdaVDa
         2qi8E2UYY8wPDGYFo6JIxHyd9lGPlKnpXQl3CCrh4nEVyhQS2/vV9tt097vwQjiBjG
         UWdce+qbU4tWA==
Subject: [PATCHSET 0/2] xfs_io: small fixes to fsmap command
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 02 Jul 2021 19:58:09 -0700
Message-ID: <162528108960.38807.10502298775223215201.stgit@locust>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

A couple of small fixes to the fsmap command.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=fsmap-fixes
---
 io/fsmap.c |   33 ++-------------------------------
 1 file changed, 2 insertions(+), 31 deletions(-)

