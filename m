Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0CA949CD7
	for <lists+linux-xfs@lfdr.de>; Tue, 18 Jun 2019 11:16:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729187AbfFRJQ6 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 18 Jun 2019 05:16:58 -0400
Received: from mail-yw1-f65.google.com ([209.85.161.65]:38960 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728385AbfFRJQ5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Jun 2019 05:16:57 -0400
Received: by mail-yw1-f65.google.com with SMTP id u134so6421525ywf.6;
        Tue, 18 Jun 2019 02:16:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EgH+0hq0YnjXqGjF0aXkEFSjqfx4EZKgDy/fxHAuwwM=;
        b=AhAJc336o778yLcOAem6gsoFUANsKHQy3uLNMMvGsW2J28GgDKk6qA7xeTqH3W1i51
         oopLRbnch9bdkXbo48DqOAL4XYHKbL4HBBGqh5JuDNFVIfAwmyM0s49SyM+i5ovZ5/Im
         N7SjwYW8d1nWErIVhN0U0a9erh010qW01XhfUaatqXEGQOgXREmjE754un/suXoqDuzf
         qXz/6gZL8xyQLBF91RJ6//f2H49yJ+dJA6nfGDyGJ+9a9m5bGshHYVq6RRvAoUoF00E1
         BP8LduNfi45+LSCrALQFvIlMWdLU7Cw8Niybj+hAiqd4Wt4LudeRyaRVCZEc6db6G2Dt
         Maow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EgH+0hq0YnjXqGjF0aXkEFSjqfx4EZKgDy/fxHAuwwM=;
        b=ZC6EelDcpqzFEadG3u/rAzL+WMwk3k+I9zgIuttlrlk8oVyEgz9jNYQSy2tOzmxwID
         KGYvXo6xbR2vqLyqyZKwZNcMIrUt/oETFYqWrKanq/yj0O4pIfxHZsHj9OXKjmzO1sg6
         hHLXczINpzb782lT4aPaU63JhEQ+j7WbCVqfyFnWIBmnxKK61VxepycSBbLupkLqIkBl
         Kp3umwThn9Jf62OnC64okwbPqWv2baqRy63C+zoDKyVAfXX8oFU834kWDZRmqosDs3Fo
         7TQ762LTbeMiY6I26opdd+xscR42VSP3C4hDDhaxfLnfQgATQuFDxmaifThWOWoRAr90
         Zr5Q==
X-Gm-Message-State: APjAAAWz31HwH6PFztQKXGajHJAVD4QvUo/zqQs8jDZBDMx1CH+WbWjM
        18Lye7RUVF2M4sm8HdM5yTTtmo9x9Er/Yn1MzFmCZA==
X-Google-Smtp-Source: APXvYqzZicZH/gxCg7dVyL/loyCekufiBbfhlruZlwI9+ZmYl3ApnjRZvo886UgpnfTcsUh/fHxe8xTP2S/pSuvbxtI=
X-Received: by 2002:a81:13d4:: with SMTP id 203mr33779371ywt.181.1560849416858;
 Tue, 18 Jun 2019 02:16:56 -0700 (PDT)
MIME-Version: 1.0
References: <20190611153916.13360-1-amir73il@gmail.com> <20190611153916.13360-2-amir73il@gmail.com>
 <20190618090238.kmeocxasyxds7lzg@XZHOUW.usersys.redhat.com>
In-Reply-To: <20190618090238.kmeocxasyxds7lzg@XZHOUW.usersys.redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 18 Jun 2019 12:16:45 +0300
Message-ID: <CAOQ4uxhePeTzR1t3e67xY+H0vcvh5toB3S=vdYVKm-skJrM00g@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] generic/554: test only copy to active swap file
To:     Murphy Zhou <jencce.kernel@gmail.com>
Cc:     fstests <fstests@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 18, 2019 at 12:02 PM Murphy Zhou <jencce.kernel@gmail.com> wrote:
>
> On Tue, Jun 11, 2019 at 06:39:16PM +0300, Amir Goldstein wrote:
> > Depending on filesystem, copying from active swapfile may be allowed,
> > just as read from swapfile may be allowed.
>
> ...snip..
>
> > +# This is a regression test for kernel commit:
> > +#   a31713517dac ("vfs: introduce generic_file_rw_checks()")
>
> Would you mind updating sha1 after it get merged to Linus tree?
>
> That would be helpful for people tracking this issue.
>

This is the commit id in linux-next and expected to stay the same
when the fix is merged to Linus tree for 5.3.

Thanks,
Amir.
