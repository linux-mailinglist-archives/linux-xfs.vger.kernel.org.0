Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A9172BA6B2
	for <lists+linux-xfs@lfdr.de>; Fri, 20 Nov 2020 10:57:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727118AbgKTJ4M (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 20 Nov 2020 04:56:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727043AbgKTJ4L (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Nov 2020 04:56:11 -0500
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8547AC061A04
        for <linux-xfs@vger.kernel.org>; Fri, 20 Nov 2020 01:56:11 -0800 (PST)
Received: by mail-wm1-x344.google.com with SMTP id d142so9767814wmd.4
        for <linux-xfs@vger.kernel.org>; Fri, 20 Nov 2020 01:56:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=65HrmNqKftUnE1asqIayt2cnQblLlYt2XJU4abNkW2c=;
        b=cIig+mZbWoziis9QAEDrcbFB/GOPYHBGkq8UJPfrMuHlRHA1uJlZUg8f7WhD8KenMR
         81/gLvFGeeEBXJjDhsMMENeHrnWQTkCblsMZLAlIKI8XYReN/YfTx4TFLK4x62j8vMcv
         NMAQZYA3LmtaSpp4bf8bDO41FIZ2kz913tElM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=65HrmNqKftUnE1asqIayt2cnQblLlYt2XJU4abNkW2c=;
        b=LEnnibfwfBioQa7gXripETCOwy6sFTvumzwH5P0d63Yl482rJNl6S7usdtD/ojPWQf
         zkSVexFcVaM+ed4amsXcAEiwtBtM/XDZeeXL4uyeoeobenqjll/9sKFnCnz4tEVKbiec
         Gsn+qnTju7BIK4bJZZ1rQHWBM7hyZxPro/Q8FcA9aGid+vpDrCiyFHsui8Tz2PLD04y1
         KGYXqIufUxY7xTbpFaTGGYMcmQhmv/YSxHkG1e3La600ZrIn+L9OPs7j0/LJBibS1cup
         oAFav7NEO3vO4Vop+AUeKR9xkXroiIfhiEXJxqwcHnBL2eKZegLOiq8E9rdSLqSH7zh0
         qnjQ==
X-Gm-Message-State: AOAM5336ZMD8AvD+FaNE0PfiIlkOkh6lJRW/CT/US/rWtVvkspA+Sgxp
        9+ej82esdR6l/P+m4ZwjJKSccA==
X-Google-Smtp-Source: ABdhPJyxRsNqKBpDLy2jcbxhd6SI4PAi8++rl2ervW+Oj/NwJ6Q8RtMk6ldX7hjCBVGGsevXbc8h9w==
X-Received: by 2002:a7b:c772:: with SMTP id x18mr9460582wmk.185.1605866170156;
        Fri, 20 Nov 2020 01:56:10 -0800 (PST)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id t9sm4500208wrr.49.2020.11.20.01.56.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2020 01:56:09 -0800 (PST)
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
To:     DRI Development <dri-devel@lists.freedesktop.org>
Cc:     Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        linux-mm@kvack.org, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 0/3] mmu_notifier fs fs_reclaim lockdep annotations
Date:   Fri, 20 Nov 2020 10:54:41 +0100
Message-Id: <20201120095445.1195585-1-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

I've finally gotten around to polish of my lockdep anntotation patches
from a while ago:

https://lore.kernel.org/dri-devel/20200610194101.1668038-1-daniel.vetter@ffwll.ch/

That patch has been in -mm for a few days already, but it immediately hit
some issues with xfs.

Changes since v2:
- Now hopefully the bug that bombed xfs fixed.
- With unit-tests (that's the part I really wanted and never got to)
- might_alloc() helper thrown in for good.

The unit test stuff was the major drag until I figured out how to make
this very easy with the locking selftests.

Comments, review, testing all very much welcome.

Cheers, Daniel

Daniel Vetter (3):
  mm: Track mmu notifiers in fs_reclaim_acquire/release
  mm: Extract might_alloc() debug check
  locking/selftests: Add testcases for fs_reclaim

 include/linux/sched/mm.h | 16 ++++++++++++++
 lib/locking-selftest.c   | 47 ++++++++++++++++++++++++++++++++++++++++
 mm/mmu_notifier.c        |  7 ------
 mm/page_alloc.c          | 31 ++++++++++++++++----------
 mm/slab.h                |  5 +----
 mm/slob.c                |  6 ++---
 6 files changed, 86 insertions(+), 26 deletions(-)

-- 
2.29.2

