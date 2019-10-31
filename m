Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09BC9EAAAF
	for <lists+linux-xfs@lfdr.de>; Thu, 31 Oct 2019 07:41:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726535AbfJaGl4 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 31 Oct 2019 02:41:56 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:41138 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726479AbfJaGlz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Oct 2019 02:41:55 -0400
Received: by mail-pl1-f194.google.com with SMTP id t10so2228809plr.8;
        Wed, 30 Oct 2019 23:41:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=HqT2lfwH9vF3mI3l/9cnfOWwzgG+Q3Lp7m9mnecJdU8=;
        b=ofpLPCfgvI7awkrJdps3SE5O7mBqOQ9aHrOf4Gb6rcinq19jmqF8Y2iiRHSDyHMDkZ
         Xbi1/ok/MHAcMMoh6AiikVKojBTX3YRLkrUZqYLT0gqRhFxGlC2qtVflXta6ZmLpnIHq
         CTqKSBojfzrWQ4pAI4tx+RJftEX6N51fx2AsPV+yc7+mT5LJ5eRrhv7n7G1hOH1Rv1Bk
         fv48B8sUCUJ+51dZ6895nOzIktxmXmw5Dxsqc/n0PNuUpmM+xP9yrqDj7DF/Pnm6sIsI
         yQQFcN+QsO0dpN8zn5ttb1pQ4xuXjaAUA1HERtLC/9m2XnsWwAEtW7eW/aWSKDZH/C3v
         VblA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=HqT2lfwH9vF3mI3l/9cnfOWwzgG+Q3Lp7m9mnecJdU8=;
        b=Ot90/5Ek+z1fWUW+TxToFDGLcSLzqUUiPAt7S8WcRcwmrXOlgzPAhrLMekBBkLS9nV
         3y/wcuL/yHdIfj/JjDnqu54OOWKL1aUSja3mmu7XtwKLUKkR/KryVpwP87Qjfwr1E+ZK
         +LAi1w8j83rPuKa+I109FBv6iNnn8riuAg6Nxu1CpguFXRg4Lb0Hyyt/hI1ni3ffna1f
         1Hbu54fT6/aEPSrxgES/CV1FlRyXrn6Glk5aslhL1re90Xp0jsKrn9hOun+MoEUd/pBn
         NapjBwzrgcuiJNaIw9hbVn8tpPFAoBFec7kpPDI7U0dzhhuck73a2Ph3a8JGiDS48Acc
         2YOg==
X-Gm-Message-State: APjAAAXKQbCIrr9WU7nkyXAN93oB0WOBiN6y6qJLPYCFB9hDuCSJHkYd
        1iVrnUsfXqv7gBxGzXWckHTsYlwspA==
X-Google-Smtp-Source: APXvYqxO0EG0ggs2qlFZmaXbdieuJCPKz2JaZuL6nUl+pmpPG0EY8XAeNPvG4iP5+vINh2QTW9fmfA==
X-Received: by 2002:a17:902:fe96:: with SMTP id x22mr4568572plm.72.1572504114970;
        Wed, 30 Oct 2019 23:41:54 -0700 (PDT)
Received: from he-cluster.localdomain (67.216.221.250.16clouds.com. [67.216.221.250])
        by smtp.gmail.com with ESMTPSA id x7sm2218815pff.0.2019.10.30.23.41.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 30 Oct 2019 23:41:54 -0700 (PDT)
From:   kaixuxia <xiakaixu1987@gmail.com>
X-Google-Original-From: kaixuxia <kaixuxia@tencent.com>
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, guaneryu@gmail.com, bfoster@redhat.com,
        newtongao@tencent.com, jasperwang@tencent.com
Subject: [PATCH v3 0/4] xfstests: add deadlock between the AGI and AGF with RENAME_WHITEOUT test
Date:   Thu, 31 Oct 2019 14:41:45 +0800
Message-Id: <cover.1572503039.git.kaixuxia@tencent.com>
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

Changes for v3:
 - Add ancestor-descendant relationship checks for two dirs
   in RENAME_EXCHANGE.
 - Rebase the patchset to the latest xfstests.

Changes for v2: 
 - Fix the xattr_count value of the original devnode in
   RENAME_WHITEOUT.
 - Fix the parent ids swap problem in RENAME_EXCHANGE.
 - Add the necessary comments.

kaixuxia (4):
  fsstress: show the real file id and parid in rename_f()
  fsstress: add NOREPLACE and WHITEOUT renameat2 support
  fsstress: add EXCHANGE renameat2 support
  xfs: test the deadlock between the AGI and AGF with RENAME_WHITEOUT

 ltp/fsstress.c        | 231 +++++++++++++++++++++++++++++++++++++++++---------
 tests/generic/585     |  56 ++++++++++++
 tests/generic/585.out |   2 +
 tests/generic/group   |   1 +
 4 files changed, 251 insertions(+), 39 deletions(-)
 create mode 100755 tests/generic/585
 create mode 100644 tests/generic/585.out

-- 
1.8.3.1

