Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2189101CB
	for <lists+linux-xfs@lfdr.de>; Tue, 30 Apr 2019 23:26:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726061AbfD3V0Q (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 30 Apr 2019 17:26:16 -0400
Received: from mail-io1-f44.google.com ([209.85.166.44]:38513 "EHLO
        mail-io1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726048AbfD3V0Q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Apr 2019 17:26:16 -0400
Received: by mail-io1-f44.google.com with SMTP id y6so13520630ior.5
        for <linux-xfs@vger.kernel.org>; Tue, 30 Apr 2019 14:26:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=Fhpq4dEUU4+wakHbGtp6CxFMV6hP2xykbGkk3K1MIow=;
        b=JUD+/982NCdE0TP9Huvg/FetqIqY1SzzRdnWX/ArlGwjUGKCAaoDYlURALOrJvMjbV
         4bEOMUnab6U2ZEJP3qC/lFWq7wcZJMTsBHxrS2ufwKBjSwbGYIL9M9Y4Qr58jvMuAgVz
         5XJaGRkt7cggLGuukQ5wr6LJXBfW94WZB5qnFg0m70IXBzblRBlX8qVJt/OEFESL1+kr
         tbRqC0JHygwCbu5+BhB/7vq/pck3LAEDwoxD/BO0Ihl8S+SESTqu+PcbnHsmNJxT2itC
         e2DVXyREuReyTudOshfJc490RKWD6JxUMX78H0dNl/DBknUtVcl4F6xCFYk4PISmgHnd
         AL2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=Fhpq4dEUU4+wakHbGtp6CxFMV6hP2xykbGkk3K1MIow=;
        b=SpZV1CPrh9NEcp1eb4qb4FRVCBhdWKSlpEKDJglMm2xRcasQcsFo30Bb6GwTwVZAWh
         YjvG4cdkLfzSuIbCt1JW5N6mdRR4Ac6oET7IfwTxOuQYy0Ko0X5qnh6NuZVD9huHUp/0
         kWG1DoBSy9XNYu8AKMHJCxLb37fP6YUS1K4RBjuj38aY4mAbkNeimEaSEkbHJmFbwHSg
         vnP7Qu5g/ckAynUO/UPyyiEPpcH9aoryxvXfP0ElIlq2AXahjnas3G47kCjtvS8akJRh
         0qGPY5qiGLbBuQODVgREJMjBeGFF655QzzIh5ebXs+YVZB/v1Waj6pMo5vFTRQIn4nQX
         X7kQ==
X-Gm-Message-State: APjAAAUMWI6OuHwbLWGos51hv4axBiMxT0wB0DbzvpOconc43q+C+rZ3
        6c8SPf3+QcLMYmoLHbnfwr+hicU8oYckSLI9BKaj8TWm
X-Google-Smtp-Source: APXvYqwYVhC2Oz6rM2PQEwcny1Xe80eo9IhYgaidUwfLb9avc2x/Rn1lkKaPul7Sl2zeEOi61Eq14YtZ8i/8ECFChAE=
X-Received: by 2002:a6b:ea0e:: with SMTP id m14mr34857018ioc.86.1556659575079;
 Tue, 30 Apr 2019 14:26:15 -0700 (PDT)
MIME-Version: 1.0
From:   Michael Allison <trailhounds@gmail.com>
Date:   Tue, 30 Apr 2019 16:26:04 -0500
Message-ID: <CA+nYfY_TkSbXZ5kCbAeQN-PthsV5suomdrMqJ3H0tbNx2ZQ3xQ@mail.gmail.com>
Subject: XFS performance decrease as filesystem approaches full
To:     linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello,


Many filesystems begin to show decreased performance as the available
free space in the defined filesystem approaches the maximum available
blocks. Are there any guidelines about this sort of performance drag
available for XFS?


Thanks,


Mike

michael allison | 303-817-9002 | My LinkedIn Profile
