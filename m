Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F07E3E3566
	for <lists+linux-xfs@lfdr.de>; Thu, 24 Oct 2019 16:20:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393869AbfJXOU6 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 24 Oct 2019 10:20:58 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:37788 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391402AbfJXOU6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Oct 2019 10:20:58 -0400
Received: by mail-pg1-f195.google.com with SMTP id p1so14352515pgi.4;
        Thu, 24 Oct 2019 07:20:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=IE9ff3ODZNtdyrJxTa2j6twZTxfT2Tw9miw6eiqwQVw=;
        b=Do8+DYiyiaFb4x2hZSUMZ+bbjS+ASOTODY00GeZhW9+YLM7OJq9iRxnIwSewFT5jvM
         8MoRjayWhSQCNj7/G6CpI0TSp29gjRbQlpQ0bte41LjTg+Mw5ZazyovUTEWfSuEhPUz7
         4hhLtjpimAv34Vzmu7VwHMioPrRaxcFqNbENSlXKJ+0TN1R6mEDqvN8asKcC3WH/MNMt
         zibwOA8/Df/znwpB1Ppj8fSG4nkD87bIWJNcdQyoNeCwRAle2TTPFOuOwbPcPXarGVnx
         n5ojAAGGXES4Kg1qS3e2ElvwHNy1ERek5RcwDxGDR4yxNSRu/Sh9ZgJm0Y2xPs2tNL9u
         nRFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=IE9ff3ODZNtdyrJxTa2j6twZTxfT2Tw9miw6eiqwQVw=;
        b=UO5IiNB7Mco8EqwypZ+YrLnxNsfbGD8X8lE8FiJZRVIpZREHMJdVuQ7u0uPadA9zkn
         Vp6PjGiCZEfD/sRL6NBpmqt4fKXGreaQxj6yF5wtnCOEoxL5YT2c1zPdwGsuJwdl6ZCu
         NJ4ehHsyyvGj7svgRujLUax9UGxz6+QkRg9A6yGOUQmZwnKvoWdb51peKK1twpnSSznz
         MIFC6qJfAQcrAp1+P3AwVngkpq5hEU2g2FTqIOj2VAniP1Cw5DboTm+f9a8Z0TGt5JXa
         lkS6S3TnHyXpCkrbHghekovFCZ02czg7k5QDisL3CKSOFPcaX8hsPCpO8uykTdLdYpMc
         jiVg==
X-Gm-Message-State: APjAAAUxqMffRvxVuy6MSdmxWLm8/lyt7s3xvEbF52ppzaZRSg1Tc0Wa
        qKDo/XJQE5ItTRs8jI9bkKjLCKctzEiz
X-Google-Smtp-Source: APXvYqyQcTVHahIi4rQI0WOe987iVxWxnkIHALxYnFun4L4yz0Ey3zRWOfI/WB6KhrpiGYO9m/kg/g==
X-Received: by 2002:a65:564b:: with SMTP id m11mr16712203pgs.133.1571926856987;
        Thu, 24 Oct 2019 07:20:56 -0700 (PDT)
Received: from he-cluster.localdomain (67.216.221.250.16clouds.com. [67.216.221.250])
        by smtp.gmail.com with ESMTPSA id i11sm24368284pgd.7.2019.10.24.07.20.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Oct 2019 07:20:56 -0700 (PDT)
From:   kaixuxia <xiakaixu1987@gmail.com>
X-Google-Original-From: kaixuxia <kaixuxia@tencent.com>
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, guaneryu@gmail.com, bfoster@redhat.com,
        newtongao@tencent.com, jasperwang@tencent.com
Subject: [PATCH 0/4] xfstests: add deadlock between the AGI and AGF with RENAME_WHITEOUT test
Date:   Thu, 24 Oct 2019 22:20:47 +0800
Message-Id: <cover.1571926790.git.kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

There is ABBA deadlock bug between the AGI and AGF when performing
rename() with RENAME_WHITEOUT flag, so add test to check that whether
the rename() call works well. We add the renameat2 syscall support to
fsstress, and then reproduce the deadlock problem by using fsstress.

kaixuxia (4):
  fsstress: show the real file id and parid in rename_f()
  fsstress: add NOREPLACE and WHITEOUT renameat2 support
  fsstress: add EXCHANGE renameat2 support
  xfs: test the deadlock between the AGI and AGF with RENAME_WHITEOUT

 ltp/fsstress.c        | 197 ++++++++++++++++++++++++++++++++++++++++----------
 tests/generic/579     |  56 ++++++++++++++
 tests/generic/579.out |   2 +
 tests/generic/group   |   1 +
 4 files changed, 217 insertions(+), 39 deletions(-)
 create mode 100755 tests/generic/579
 create mode 100644 tests/generic/579.out

-- 
1.8.3.1

