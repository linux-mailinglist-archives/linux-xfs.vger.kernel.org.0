Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80F3056CFF
	for <lists+linux-xfs@lfdr.de>; Wed, 26 Jun 2019 17:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726723AbfFZPAX (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 26 Jun 2019 11:00:23 -0400
Received: from mail-yw1-f65.google.com ([209.85.161.65]:36354 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726029AbfFZPAW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Jun 2019 11:00:22 -0400
Received: by mail-yw1-f65.google.com with SMTP id t126so1331934ywf.3;
        Wed, 26 Jun 2019 08:00:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3R92D16GNiEuIXdVSumZ83s8cF2XaEdd6LMhhMa1ZxM=;
        b=JEgO7l0fcqg3UES+hyW08OZdHJsoBiH6Pkk6zhy+07T1qAN6wTTfhZ4bWO+lhjI4Wn
         Ja+xcL+e36KDIrylK/yox98o/AoFJB3dNzkmr3PnfV5oJ9abIxbvW0SbbmqB+DoDnSdU
         U9nzfI2X3ScJo6PmwTESVeK4lRpYEbwZhe4NkAzPOm2LZOadvP7nBaaUMVdKULooeUQs
         5fKAqzMjDAcWqIcgM/4KHgGMGC83SGxT2cK4AKrzzaUoJPZnc7anL5lyN6+OTE8tnyZV
         Qh3YxbgmWS5h64wXfz2kPrqVjrta+3lvf65//DtHbCK0ZIICruh/uAqih9Kz5CNKoktY
         mGLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3R92D16GNiEuIXdVSumZ83s8cF2XaEdd6LMhhMa1ZxM=;
        b=KlsV8bJoI0CuXnYrI3M8xlGo2eLXdkZST1cGE4Cw5O8kzu3k91O1WJXSzwzYDacSdA
         fro7cfPOfJmXmJ7wzw4tG33tCsV7jWkYHypzOENaeDYVEd2CZ91iibsV0WrVv/m8+bhX
         frRlH1AcHTnicM8jdLfwXW4QxqX4iCLVs2PQP/3HeL6vdlt2gHHyPB3oC8dZUUuDyGQV
         h/LH5hXl1QG/FbV1RhmI3sbud0jYZ1luU56Lc1Ah6wZr0RqLaM4UdXfGR0n/fUPiEXtn
         vHX2csSKdHkIGVt1FTMe0xoCE7PUQEJt1+pw65oVyTNm/qOYsVX6rmG64RuopL8fS0C8
         tHYA==
X-Gm-Message-State: APjAAAXOufpM0pr9/2X5eS2VhucqUi7xy2U8scn8ZZkmScEnP0jgyGi5
        /+95REKPpqB77XyJeK7gyjBG9rIXme1DoIa1+lue2LI4
X-Google-Smtp-Source: APXvYqwhgUDVZTFOqj92/kzM+8HoySreqzLQwBEzZF6bWMhx7PbJ/rqNAWKivDH/GpusAhMNyLw5b/cGZajbd6HaZVE=
X-Received: by 2002:a81:50d5:: with SMTP id e204mr2998511ywb.379.1561561221358;
 Wed, 26 Jun 2019 08:00:21 -0700 (PDT)
MIME-Version: 1.0
References: <20190626061711.27690-1-amir73il@gmail.com> <fe818d07-f539-4b2c-fe26-dbc18003e3e2@sandeen.net>
In-Reply-To: <fe818d07-f539-4b2c-fe26-dbc18003e3e2@sandeen.net>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 26 Jun 2019 18:00:08 +0300
Message-ID: <CAOQ4uxj12x4+FDfcA4t72nYEvXAsV7FhgYQLDSA068Tdyz-Tsw@mail.gmail.com>
Subject: Re: [PATCH] xfs_io: reorganize source file handling in copy_range
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     "Darrick J . Wong" <darrick.wong@oracle.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 26, 2019 at 5:51 PM Eric Sandeen <sandeen@sandeen.net> wrote:
>
> rename and rearrange some of the vars related to using an open
> file number as the source file, so that we don't temporarily
> store a non-fd number in a var called "fd," and do the fd
> assignment in a consistent code location.
>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
>
> Amir, what do you think about this tweak, just for maintainability
> I'd prefer to only assign an actual fd to "fd," and handle that
> assignment in the same code location for both invocation options.
> Thoughts?  Not a big deal either way.

I think that looks much better.

...

> +       } else
> +               fd = filetable[src_file_nr].fd;

I would match else { } to if { }.
 Other than that, looks good.

You may add:
Reviewed-by: Amir Goldstein <amir73il@gmail.com>

Thanks,
Amir.
