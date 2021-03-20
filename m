Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC62E342EB6
	for <lists+linux-xfs@lfdr.de>; Sat, 20 Mar 2021 19:02:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbhCTSCB (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sat, 20 Mar 2021 14:02:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbhCTSBr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 20 Mar 2021 14:01:47 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64CD5C061574
        for <linux-xfs@vger.kernel.org>; Sat, 20 Mar 2021 11:01:47 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id b10so9568131iot.4
        for <linux-xfs@vger.kernel.org>; Sat, 20 Mar 2021 11:01:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=xv0/FXo7vLB8EP9ZpwwhF3boJq4xF+sC7ED2yZjHieI=;
        b=kfYBuUCB4nNH0hIplm/v7ZW41YFISEOH3u1dZyZWIMITx23M8CCckERSuXDLbp+tmK
         9yrol4khawdpqzVs6rHCrCM86H1Q0wmxTJhcpqLCfIyzBA5XZE9c6cokDVYW+417sCzR
         Adb7ZZmrt+4rUk6w/zma2w9aGsgsKFfvmH25Re+1XyA3RLbKBJVSDhjQQLv1gZfPmdp/
         Svt/4HkWe7cW7s1215u357Mcfd94ztXzKf1XHqlxF2edRAoBOaVBkctXKtT1D+YzMWfg
         a+/04A8N0zd80MNDJrT+88srRlrWRn58HVUpfx7XE6jzltVMq4caS1dIJW2GqxsNEi02
         iqJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=xv0/FXo7vLB8EP9ZpwwhF3boJq4xF+sC7ED2yZjHieI=;
        b=diDFLDqTZ0xu0PJbfwrYW76ROEVvDLXJNKHXJ45rDVWD9mwwH3e5DUxRSXXIBwS3y+
         0b36x79P/jSkMlYcdZNohuS3pb/zPyo1eYjm5U+wQaErw+bR0iPZl2oqu+oBB8CPdqql
         zDyyZxMfQwJa7lB6QrKy7hS09GPfmt44J2s4n2KVJ1Sw41RmzBYrmM5L/HoYAnW0s9R1
         iaeGYS7+AysubZO5ivVQVA6TPLZLUTQIe253HUPbeL0mzH5AHltVAqKKvV3osG6YCEim
         07RDyLw8eowQkmfgdeIAuTsUCnPCzvs5xpCDnMBccLPGJB1Nbs2VwK5S0YFzc+TMFnCE
         ZvWQ==
X-Gm-Message-State: AOAM530ZM12BSxyIJ4ZTmYMMHeirmZtW3UxM3DnJsZNK3rkwWN+IiFue
        a6bHAPrOkBhGpqJSyvtCDFiZh84pOJ6yjWXHp4io+Vc5SJ6kIw==
X-Google-Smtp-Source: ABdhPJwidLGWpTF8vM4NWQo4XXLZP3+QGwBh5uT+/Rx/ohaAUMoSx8qpiGOqmAlvdhZkbOxxEnCYFh2n/tR0urWdjLk=
X-Received: by 2002:a02:cd33:: with SMTP id h19mr5617819jaq.88.1616263306714;
 Sat, 20 Mar 2021 11:01:46 -0700 (PDT)
MIME-Version: 1.0
From:   =?UTF-8?Q?Ralf_Gro=C3=9F?= <ralf.gross+xfs@gmail.com>
Date:   Sat, 20 Mar 2021 19:01:37 +0100
Message-ID: <CANSSxym1ob76jW9i-1ZLfEe4KSHA5auOnZhtXykRQg0efAL+WA@mail.gmail.com>
Subject: memory requirements for a 400TB fs with reflinks
To:     linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

I plan to deploy a couple of Linux (RHEL 8.x) server as Veeam backup
repositories. Base for this might be high density server with 58 x
16TB disks, 2x  RAID 60, each with its own raid controller and 28
disks. So each RAID 6 has 14 disks, + 2 globale spare.

I wonder what memory requirement such a server would have, is there
any special requirement regarding reflinks? I remember that xfs_repair
has been a problem in the past, but my experience with this is from 10
years ago. Currently I plan to use 192GB RAM, this would be perfect as
it utilizes 6 memory channels and 16GB DIMMs are not so expensive.

Thanks - Ralf
