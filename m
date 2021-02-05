Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 142203101A6
	for <lists+linux-xfs@lfdr.de>; Fri,  5 Feb 2021 01:32:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232004AbhBEAcR (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 4 Feb 2021 19:32:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231987AbhBEAcQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Feb 2021 19:32:16 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B67DC0613D6
        for <linux-xfs@vger.kernel.org>; Thu,  4 Feb 2021 16:31:36 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id y18so6601213edw.13
        for <linux-xfs@vger.kernel.org>; Thu, 04 Feb 2021 16:31:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fishpost-de.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=edrDenfwcjKIeYqlJtjM3h8/3HcUtLioayFsaT4WDO8=;
        b=dXzlfKIN89imAcYRHgSXTybCs7abBR0Dny7Tc7uzlfferUFgPtqxpcu0iZTZetH504
         1VxP45JQilPE3IL72zQ3eX80eqfSIGWAEQ/8x14fVjv9eY1jrogo9gh8f9A9BT6a8eEL
         AjthVtMoKBFMHp8/CHrjr9DifTrXJNa9vGV2Flq/wEalKa7O4q2RxgWHCIL9+RM/kWuA
         NQK4OmwNslxlQeKVr+gqbW5SIupgfV8PUNAKlWu1TaVYhAC4kImfN+BQtRre41dxPMWt
         DiWHaGFQPOCrClUjr7pNp5s/7FnXEdUL2n7dzI38N5WbnnbtKeNbuyAOnGnHjpADuzE/
         O8pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=edrDenfwcjKIeYqlJtjM3h8/3HcUtLioayFsaT4WDO8=;
        b=bz0v8VEKMopPy/Lrv2fwUtwiwJQNvAzObk6M6ykAxBfH8E/Jwa05DNg1M4h3XBy1RV
         CFweLetd0w9TtInt1jvcEkYkKqnCKyNs6Gx5xCWbGtjkMcOKZ4dDAaRoZ/PR7ydcTiGf
         02RH53h7N4KDFrEFX/IklnZYvXdx8Qri49t92ojtxHWk+nyBez+RbecQt37N+Wum7MvO
         3ilyhfKwBmF2+oz3c5KOLmi3rWdRV1DuLLD2o0dE/IiEleu/tVoSSjsMwIZvXhgVNOYE
         AT803zpT0y9S5nCqrgu6Kqog+qOWq6epRYexXakXL//UGd6M+6kY23fpmvEzSYNl5Ree
         50mA==
X-Gm-Message-State: AOAM531xoCJcEuHkE3TVmQu7USmwqo5YrrLys9nMshD1yq/9zyc9ycuP
        YxFJiGDkI23Xb9UhjB2vhx/JrWZ1NKxXNR9J
X-Google-Smtp-Source: ABdhPJyTYyKZGunPyHe/qvXgDS64Y3ekhLjhUrNKMs90dWWqCGnWeo6QoWaGmq0l61Ro8K5KFBpbUg==
X-Received: by 2002:a50:8b66:: with SMTP id l93mr1074102edl.384.1612485094974;
        Thu, 04 Feb 2021 16:31:34 -0800 (PST)
Received: from thinkbage.fritz.box (p200300d06f355400ebbce7b10bde1433.dip0.t-ipconnect.de. [2003:d0:6f35:5400:ebbc:e7b1:bde:1433])
        by smtp.gmail.com with ESMTPSA id o10sm3202222eju.89.2021.02.04.16.31.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Feb 2021 16:31:34 -0800 (PST)
From:   Bastian Germann <bastiangermann@fishpost.de>
To:     linux-xfs@vger.kernel.org
Cc:     Bastian Germann <bastiangermann@fishpost.de>
Subject: [PATCH 0/3] debian: minor fixes
Date:   Fri,  5 Feb 2021 01:31:22 +0100
Message-Id: <20210205003125.24463-1-bastiangermann@fishpost.de>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This series contains unrelated changes for the xfsprogs Debian package.

Bastian Germann (3):
  debian: Drop unused dh-python from Build-Depends
  debian: Only build for Linux
  debian: Prevent installing duplicate changelog

 debian/changelog | 8 ++++++++
 debian/control   | 8 ++++----
 debian/rules     | 2 +-
 3 files changed, 13 insertions(+), 5 deletions(-)

-- 
2.30.0

