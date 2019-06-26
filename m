Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CAA256A33
	for <lists+linux-xfs@lfdr.de>; Wed, 26 Jun 2019 15:17:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727323AbfFZNRy (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 26 Jun 2019 09:17:54 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:45065 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727181AbfFZNRy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Jun 2019 09:17:54 -0400
Received: by mail-oi1-f193.google.com with SMTP id m206so1848254oib.12
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jun 2019 06:17:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WqdD5BglIz2bjpJLm9xusDo7QNINbb60fVv8fvyF9fM=;
        b=gxwF8HzxIMv4jMLbvZCWz0M+uJrd+aumgVQaVUWzKvsgnrx2VA0JgcYZRpnm/j0iq8
         /82TytOkijpl8LxuJVWvLYpa+fAnzN7ZeGpsdv/3sFSGSmwdtdEBP8C7fSlpp/QwvMg7
         l7Z8rALELFxu0GAa0JQil1Wgi7XECa5SUV8EzYg3sopfghE5kNccsDYSQeW3hM1Q2oo3
         jwHjKhV07BBRCi/lv2qxEM47MeDD//kdaF8ONDgqTMRXifLOA59kDWwqNg73CvPgzwGQ
         bY7Jk+4oX4D6zVV1Tzm/fNBX5FbsOM4iHZHRvLmWYhK0uWeeoJFkHzhvchMg2kvD6AGn
         V7EQ==
X-Gm-Message-State: APjAAAVpuWvfDkNDmw63EI7CucvenOmXOnTWQYgd1NPG9aK53XSU7zS3
        Kd9p1QJkFwM9g3y7ZFslXxw7pkbBFcYTDmcHrfe8KA==
X-Google-Smtp-Source: APXvYqy5bRoQuv2KPD9FNgGoEEIj898miACPAEp8kvaWAT78qxVLLGsyqiFSwuc3jqzugKz4zH1MYrfKjHMZGZ9BxOg=
X-Received: by 2002:aca:b58b:: with SMTP id e133mr1722182oif.147.1561555073935;
 Wed, 26 Jun 2019 06:17:53 -0700 (PDT)
MIME-Version: 1.0
References: <20190626120333.13310-1-agruenba@redhat.com> <20190626125502.GB4744@lst.de>
In-Reply-To: <20190626125502.GB4744@lst.de>
From:   Andreas Gruenbacher <agruenba@redhat.com>
Date:   Wed, 26 Jun 2019 15:17:42 +0200
Message-ID: <CAHc6FU5suCE2-TtNMR4mGZ5DHB+3diVL=uUwccKES=eHwSPYkA@mail.gmail.com>
Subject: Re: [PATCH 1/2] iomap: don't mark the inode dirty in iomap_write_end
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        cluster-devel <cluster-devel@redhat.com>,
        linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, 26 Jun 2019 at 14:55, Christoph Hellwig <hch@lst.de> wrote:
> Doesn't the series also need a third patch reducing the amount
> of mark_inode_dirty calls as per your initial proposal?

The page dirtying already reduces from once per page to once per
mapping, so that should be good enough.

Thanks,
Andreas
