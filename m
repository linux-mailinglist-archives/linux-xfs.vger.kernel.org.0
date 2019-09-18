Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 504C4B5F12
	for <lists+linux-xfs@lfdr.de>; Wed, 18 Sep 2019 10:24:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726975AbfIRIY6 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 18 Sep 2019 04:24:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49484 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726131AbfIRIY6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 18 Sep 2019 04:24:58 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3E255A3D389;
        Wed, 18 Sep 2019 08:24:58 +0000 (UTC)
Received: from pegasus.maiolino.com (ovpn-204-62.brq.redhat.com [10.40.204.62])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 54C4A5D9D5;
        Wed, 18 Sep 2019 08:24:57 +0000 (UTC)
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     bfoster@redhat.com, david@fromorbit.com
Subject: [PATCH RFC 0/2] A small improvement in the allocation algorithm
Date:   Wed, 18 Sep 2019 10:24:51 +0200
Message-Id: <20190918082453.25266-1-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.68]); Wed, 18 Sep 2019 08:24:58 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is totally based on the discussion between Brian, Dave and me regarding the
issues we have on the allocation mechanism, and this patchset is just used to
put the ideas together.

Dave, this is a small improvement based on your hack on your original patch, to
'fix' the total number. And based on my last reply to the thread

It still does need improvement, and I need to check the math, but I think we
should maybe start here.

I just removed the hack from your patch, and moved the args.total fix to the 2nd
patch.

What you guys think about it?

Carlos Maiolino (1):
  xfs: Limit total allocation request to maximum possible

Dave Chinner (1):
  xfs: cap longest free extent to maximum allocatable

 fs/xfs/libxfs/xfs_alloc.c | 3 ++-
 fs/xfs/libxfs/xfs_bmap.c  | 5 +++++
 2 files changed, 7 insertions(+), 1 deletion(-)

-- 
2.20.1

