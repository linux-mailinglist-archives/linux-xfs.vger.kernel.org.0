Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F1A83A63D
	for <lists+linux-xfs@lfdr.de>; Sun,  9 Jun 2019 15:46:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728741AbfFINqI (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 9 Jun 2019 09:46:08 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:47055 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727430AbfFINqI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 9 Jun 2019 09:46:08 -0400
Received: by mail-pl1-f193.google.com with SMTP id e5so2587835pls.13;
        Sun, 09 Jun 2019 06:46:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=v15QtU5C+DqTsmytBF5nMseQXjQJJ4oDXrKkO7mkYgg=;
        b=tdxhqQhq3y2BhJ9ippr5nE/EYVmaLlLp0hcX5hcsC3DdUuzSMsDmI5w0bZAucL8F53
         /7TEJ5cYgu5SSXYQw9yTy7f1H887rno+eVHtUQ6NWOD0jl24o5o+4a29iWbWJntF0EZU
         sKxTRb0mQ1Ysevlax1htpXwh6NbfOyUWINhvXoCYkj63NFY5u+ddQzzVZAryes7nmj0N
         MWwg65EqYRjLW48sZt1VIeK/3giATHCQ/wkRWIRClMrX19VPdz+TolC3eqtCOGw8gKZW
         y2nZZ4WNbigJqdWIqhPsA6CrgxDLv/jzJxeb209RIB/UY2H06x//TNuZWf1sMCzRSP1C
         fXxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=v15QtU5C+DqTsmytBF5nMseQXjQJJ4oDXrKkO7mkYgg=;
        b=hVcx4xPVgdKmnvevQftazi7MxdTnKBqeOyQpCHKe68e11aPWeWtGHg5czk3SXUGloO
         Ye4p+omw952eW275Uct2HG2PRcm1abGcLvEj5LA/OHoQbZpWhyAw5BKNfGr5cJIyJasU
         CURiFhfL+3Xud/2+LjYOh3cyMD/Uo62wEa2Hn4z7y4WY8cdT13w+JmaPSO1vYoDR1MzD
         FX0vt0/AdzG0q9kOUfj0HnKIgpXdzqiikZXk7cCu1rAm4Xg1dIPpqXmwhtQiZf4uJxJI
         UAnI77yOj88ZEJqilVeZGzqbsvGj1+b852W5eZUxwFDshIWv1dRo/pCJy5cg4elsgVyi
         GF3g==
X-Gm-Message-State: APjAAAUBEEk9dtyAfJRKymouAexYRqpW5M8v1Liumb8bqJdGD2gFz1pN
        7JVYViGvISO1ayMjJUq6Z7LGJd4Bovk=
X-Google-Smtp-Source: APXvYqzO+FhGfkwiJ8IgCXA9PkeSIhB9eGJLymT5pWaI6BkC4IfVWb9+EbkcoL8OPSs5yNgUqza87Q==
X-Received: by 2002:a17:902:121:: with SMTP id 30mr62986548plb.314.1560087967404;
        Sun, 09 Jun 2019 06:46:07 -0700 (PDT)
Received: from localhost ([47.254.35.144])
        by smtp.gmail.com with ESMTPSA id ce3sm7155861pjb.11.2019.06.09.06.46.06
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 09 Jun 2019 06:46:06 -0700 (PDT)
Date:   Sun, 9 Jun 2019 21:46:04 +0800
From:   Eryu Guan <guaneryu@gmail.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     "Darrick J . Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>,
        Olga Kornievskaia <olga.kornievskaia@gmail.com>,
        fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 0/6] fstests: copy_file_range() tests
Message-ID: <20190609134604.GX15846@desktop>
References: <20190602124114.26810-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190602124114.26810-1-amir73il@gmail.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jun 02, 2019 at 03:41:08PM +0300, Amir Goldstein wrote:
> Eryu,
> 
> This is a re-work of Dave Chinner's copy_file_range() tests which
> I used to verify the kernel fixes of the syscall [1].
> 
> The 2 first tests fix bugs in the interface, so they are appropriate
> for merge IMO.
> 
> The cross-device copy test checks a new functionality, so you may
> want to wait with merging it till after the work is merged upstream.
> 
> The bounds check test depend on a change that was only posted to
> xfsprogs [2]. Without two changes that were merge to xfsprogs v4.20,
> the original test (v1, v2) would hang. Requiring the new copy_range
> flag (copy_range -f) mitigates this problem.
> 
> You may want to wait until the xfs_io change is merged before merging
> the check for the new flag.

Thanks a lot for the detailed explanation! I applied the first three
patches for this week's update.

Thanks,
Eryu

> 
> Thanks,
> Amir.
> 
> [1] https://lore.kernel.org/linux-fsdevel/20190531164701.15112-1-amir73il@gmail.com/
> [2] https://marc.info/?l=linux-xfs&m=155912482124038&w=2
> 
> Changes from v2:
> - Change blockdev in test to loop and _require_loop (Olga)
> - Implement and use _require_xfs_io_command copy_range -f
> 
> Changes from v1:
> - Remove patch to test EINVAL behavior instead of short copy
> - Remove 'chmod -r' permission drop test case
> - Split out test for swap/immutable file copy
> - Split of cross-device copy test
> 
> 
> Amir Goldstein (6):
>   generic: create copy_range group
>   generic: copy_file_range immutable file test
>   generic: copy_file_range swapfile test
>   common/rc: check support for xfs_io copy_range -f N
>   generic: copy_file_range bounds test
>   generic: cross-device copy_file_range test
> 
>  common/rc             |   9 ++-
>  tests/generic/434     |   2 +
>  tests/generic/988     |  59 +++++++++++++++++++
>  tests/generic/988.out |   5 ++
>  tests/generic/989     |  56 ++++++++++++++++++
>  tests/generic/989.out |   4 ++
>  tests/generic/990     | 132 ++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/990.out |  37 ++++++++++++
>  tests/generic/991     |  56 ++++++++++++++++++
>  tests/generic/991.out |   4 ++
>  tests/generic/group   |  14 +++--
>  11 files changed, 372 insertions(+), 6 deletions(-)
>  create mode 100755 tests/generic/988
>  create mode 100644 tests/generic/988.out
>  create mode 100755 tests/generic/989
>  create mode 100644 tests/generic/989.out
>  create mode 100755 tests/generic/990
>  create mode 100644 tests/generic/990.out
>  create mode 100755 tests/generic/991
>  create mode 100644 tests/generic/991.out
> 
> -- 
> 2.17.1
> 
