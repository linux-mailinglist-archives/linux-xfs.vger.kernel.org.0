Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52AE86773A
	for <lists+linux-xfs@lfdr.de>; Sat, 13 Jul 2019 02:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727522AbfGMA1g (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 12 Jul 2019 20:27:36 -0400
Received: from mail-lf1-f53.google.com ([209.85.167.53]:36379 "EHLO
        mail-lf1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727525AbfGMA1f (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 12 Jul 2019 20:27:35 -0400
Received: by mail-lf1-f53.google.com with SMTP id q26so7550316lfc.3
        for <linux-xfs@vger.kernel.org>; Fri, 12 Jul 2019 17:27:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Nfl0wnnWuYc24xUzw/EVGY+2MfERMWxbutDcZnI1BQA=;
        b=CjNajGQKwwF6Ge8LXYLMNdlEDTDz2Lqd7XOtYZTwXuzl/zfscI8s6S/wpHGG0DUgHD
         ogxbG4UCpQD9D8aJw7ND3Sw6f9EqWbP+NsgM2LUaWE4zMgqeLAM3/IwjO6cCYSy3rLa1
         aSvD/8JCjn9fsqH0aeQRhQvk0HyydNbnoQlrc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Nfl0wnnWuYc24xUzw/EVGY+2MfERMWxbutDcZnI1BQA=;
        b=omkzXnEqq3z+Rwj6BTzO4WYmpfGwvK/Zkd0NXVOCQGxtrlUlVCcfVuk2eTtWh4CSDG
         puf8qzh3+Ux808ZS2lW3iVWuDDXJYfj9WuUBMh8bMLc2uLjZ6ljfYkt6fnuN39XctjXt
         0qUye+Nd0HkuTlZvZ4cPUlnOtE65aVmG1AboslJar/dpQIF/SidzWPNSxI62Q0iQQZ4Z
         FLJ/qrjUsKqHLhBnfIuO9MosDHLmV5m5OwiZ6Ss+IJ+prWEzC3YCjl60nw2CW0rPk5z7
         vlwXlIDy68N7mU8s9AceqUOJ5ZGUFw7q2+KnLviTF5ovlU7MlBPg8hzm4FNp36cgTXQV
         OBMQ==
X-Gm-Message-State: APjAAAVXHx/w26eueYfVOmItYacRtttsUv0OYw7YSYjWcW/i7PLCgUV6
        zEd1ym/DMM1Beb8gj1IfwFSekpYxfbQ=
X-Google-Smtp-Source: APXvYqwmtPl5iA2x7SfpXYgkQmT1TeSyXF4eX84fNRvAYWYVtfrye8ZhROnrb+ZwPqX10WrXHCFHmA==
X-Received: by 2002:ac2:4152:: with SMTP id c18mr6224553lfi.144.1562977652506;
        Fri, 12 Jul 2019 17:27:32 -0700 (PDT)
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com. [209.85.167.49])
        by smtp.gmail.com with ESMTPSA id p76sm1684558ljb.49.2019.07.12.17.27.31
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 12 Jul 2019 17:27:31 -0700 (PDT)
Received: by mail-lf1-f49.google.com with SMTP id q26so7550290lfc.3
        for <linux-xfs@vger.kernel.org>; Fri, 12 Jul 2019 17:27:31 -0700 (PDT)
X-Received: by 2002:ac2:44c5:: with SMTP id d5mr6224027lfm.134.1562977651157;
 Fri, 12 Jul 2019 17:27:31 -0700 (PDT)
MIME-Version: 1.0
References: <20190712180205.GA5347@magnolia>
In-Reply-To: <20190712180205.GA5347@magnolia>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 12 Jul 2019 17:27:15 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiK8_nYEM2B8uvPELdUziFhp_+DqPN=cNSharQqpBZ6qg@mail.gmail.com>
Message-ID: <CAHk-=wiK8_nYEM2B8uvPELdUziFhp_+DqPN=cNSharQqpBZ6qg@mail.gmail.com>
Subject: Re: [GIT PULL] xfs: new features for 5.3
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Linux List Kernel Mailing <linux-kernel@vger.kernel.org>,
        Eric Sandeen <sandeen@sandeen.net>,
        Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 12, 2019 at 11:02 AM Darrick J. Wong <djwong@kernel.org> wrote:
>
> The branch merges cleanly against this morning's HEAD and survived an
> overnight run of xfstests.  The merge was completely straightforward, so
> please let me know if you run into anything weird.

Hmm. I don't know what you merged against, but it got a (fairly
trivial) conflict for me due to

  79d08f89bb1b ("block: fix .bi_size overflow")

from the block merge (from Tuesday) touching a line next to one changed by

  a24737359667 ("xfs: simplify xfs_chain_bio")

from this pull.

So it wasn't an entirely clean merge for me.

Was it a complex merge conflict? No. I'm just confused by the "merges
cleanly against this morning's HEAD", which makes me wonder what you
tried to merge against..

            Linus
