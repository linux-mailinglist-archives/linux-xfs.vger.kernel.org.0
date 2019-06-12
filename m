Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F1F9429FC
	for <lists+linux-xfs@lfdr.de>; Wed, 12 Jun 2019 16:55:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406459AbfFLOzI (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 12 Jun 2019 10:55:08 -0400
Received: from mail-wm1-f45.google.com ([209.85.128.45]:38463 "EHLO
        mail-wm1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405540AbfFLOzI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Jun 2019 10:55:08 -0400
Received: by mail-wm1-f45.google.com with SMTP id s15so6879759wmj.3
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jun 2019 07:55:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=hlGiQBArlVoL/5llA8kBn4kNgFmgEGlGCeNoGqWjGYg=;
        b=LZSWH4aj+PGjbTTX7GK6MY89zYTOInp2AfwS8HdiVDuyjSRZNW2Z+xdx23/BiwzNYg
         Tx5houaQ7YZGqxXvyINwfMRpvE5CZd5F175G0IhzxlGa2BDmKOpALp4ikpPZgu0uWJ4v
         RC0Ksjy5G6mT+lxD7p9STXrjxnGWKKCqbF0/nnudES+4/0xGOLtUNtvisNevKOBkWooq
         DNh61Ufvpcp0PQGcfFZo7hdl043OdqHPlBitx+yGZzyJxeWYR/7ymsodHWKET5/QAdy/
         3JNR8e3qY/5Yz2M0gUFrgFs1praFswnp5mn1hXsaWCxXjTR19dRwR5b/INb7OXcE0OFP
         46jw==
X-Gm-Message-State: APjAAAVz8QKcKyre+paIb3CR6D60Ri+p1NbdhO/NdZBgrUdn6PpWPyE0
        g6HOiBI4846zzu61SXEHZd24PRHUpCCIPpa8HtLj7ydaK14=
X-Google-Smtp-Source: APXvYqwz4MVrDCZJsG/8A2vloEV2xFFe4kCsej5CqQ7FNlAbW3X7lQAwFwpkOeh4tVp2gOFbCX6mAvOXJLfp/OsW0Bw=
X-Received: by 2002:a1c:4484:: with SMTP id r126mr23206336wma.27.1560351306656;
 Wed, 12 Jun 2019 07:55:06 -0700 (PDT)
MIME-Version: 1.0
From:   Jan Tulak <jtulak@redhat.com>
Date:   Wed, 12 Jun 2019 16:54:55 +0200
Message-ID: <CACj3i738v-pRy4ihQX=Yp17Rgh5uaroMsZAX-vcsthNrdL=bog@mail.gmail.com>
Subject: xfsdump cleaning scripts (and thanks for all the fish)
To:     linux-xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi guys

I'm leaving Red Hat and won't have the time to work on the xfsdump
cleaning anymore. So, in case anyone else wants to pick it up, I
uploaded my cleaning scripts on Github [1] together with some basic
readme. (Including changes that I didn't manage to polish and get them
merged to xfs) Hopefully it will be useful.

It was nice to meet you guys and let XFS rule! :-)

Cheers,
Jan

[1] https://github.com/jtulak/xfsdump-style-scripts

PS: In case you want to contact me after this week, you can reach me
at: jan@tulak.me

-- 
Jan Tulak
