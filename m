Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F213064AF2
	for <lists+linux-xfs@lfdr.de>; Wed, 10 Jul 2019 18:48:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727348AbfGJQsI (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 10 Jul 2019 12:48:08 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:34123 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727165AbfGJQsI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Jul 2019 12:48:08 -0400
Received: by mail-wr1-f66.google.com with SMTP id 31so3232135wrm.1
        for <linux-xfs@vger.kernel.org>; Wed, 10 Jul 2019 09:48:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:cc;
        bh=DmhfL6ON6C18JVEVd0mandHcPzF0xyYucy5q6z94Wok=;
        b=w9WLC8zSsX5JZBtJ1FkUgidBLreaICoUbmATcrSAI+Bv+mlIbQv29DB59s9JAYrvw+
         /NJQcz0e0IiMjSdFMFGbVezjJKn/Vmhf6AqxeGXT7IfdbaZwgHipfMkaXIfa/Iv7GnTo
         a0iHDGAa5H53n5J2SssL9q5yTGTqkAZ7sxQJ9yN83/yUlAI9AVz58z1u3xbcitzBSY7s
         d3Jo4EP04h6d/0YcPkh0DAvSovfX278hgmbKUn4DIl0sH6mPVGCI5aC5uNgrBI50/h8b
         hJkmROt8vCVMrgi8uQ4SesfWvUeoih4MRP4N24JdLzIeEXX8L/y6B9wPb9kiwEAyqFSU
         FHWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:cc;
        bh=DmhfL6ON6C18JVEVd0mandHcPzF0xyYucy5q6z94Wok=;
        b=AiMAmbhHWvI25lCslOwavuqqfXkb0h8zH+38fh+uhW+MULgXByngSF8EvWHAuiZz4g
         t3PJrO9k2UN2zdfXagTh45M0sa6/MsWf4nnJ5smM29anEea9gKYoFE2perBey13U3K1x
         87FS0xRdH83bN+a4vRb8HM5Hl0yCdlm1dx0Rsk9kXxzoCdUSZofhwktq3DNEknDe/29z
         6RGT+eP7gGoAT3DzMsp1jkfYUmGHV+McRoXzI6i9SvI48JPP0BR7sduqb0lzT+VhvJ61
         9cdmSmD2ydAMZRAfKh4Nip6Ti1Tal3x6ogzc5wH+QpHgeOTrWNGRiQkr3fzMa8tC0qnU
         3lAQ==
X-Gm-Message-State: APjAAAWfpuMG7SpPwqwH4vt9F3dKzToVdYxVuOctPCZXmCUW9PBMRzur
        NsM26z6ZndqPkB0RBbvghJmgxY/J3cjqOB9F8/Va3A==
X-Received: by 2002:a5d:4403:: with SMTP id z3mt29677100wrq.29.1562777286117;
 Wed, 10 Jul 2019 09:48:06 -0700 (PDT)
MIME-Version: 1.0
References: <958316946.20190710124710@a-j.ru> <CAJCQCtTpdGxB4r04wPNE+PRV5Jx_m95kShwvLJ5zxdmfw2fnEw@mail.gmail.com>
 <1373677058.20190710182851@a-j.ru> <CAJCQCtSpkAS086zSDCfB1jMQXZuacfE-SfyqQ2td4Ven4GwAzg@mail.gmail.com>
 <1015034894.20190710190746@a-j.ru> <CAJCQCtSTPaor-Wo6b1NF3QT_Pi2rO7B9QMbfudZS=9TEt-Oemw@mail.gmail.com>
In-Reply-To: <CAJCQCtSTPaor-Wo6b1NF3QT_Pi2rO7B9QMbfudZS=9TEt-Oemw@mail.gmail.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Wed, 10 Jul 2019 10:47:55 -0600
Message-ID: <CAJCQCtQn17ktjatXU5vvFjfsfEJx8EDrq1+b8+O1yvAf7ij96w@mail.gmail.com>
Subject: Re: Need help to recover root filesystem after a power supply issue
Cc:     Andrey Zhunev <a-j@a-j.ru>, xfs list <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 10, 2019 at 10:46 AM Chris Murphy <lists@colorremedies.com> wrote:
>
> # smartctl -l scterc,900,100
> # echo 180 > /sys/block/sda/device/timeout


smartctl command above does need a drive specified...



-- 
Chris Murphy
