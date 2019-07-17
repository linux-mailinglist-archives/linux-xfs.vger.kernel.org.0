Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A84F06BC87
	for <lists+linux-xfs@lfdr.de>; Wed, 17 Jul 2019 14:44:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725873AbfGQMoc (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 17 Jul 2019 08:44:32 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:38422 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725906AbfGQMoc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 Jul 2019 08:44:32 -0400
Received: by mail-ot1-f66.google.com with SMTP id d17so24875184oth.5
        for <linux-xfs@vger.kernel.org>; Wed, 17 Jul 2019 05:44:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=33PekZZX1s4b2ZllhlMgDgDyRoxO59g4JGmElbfr7Vw=;
        b=i9WrRmUHCMPx5CIgO9MvNvuqelIReDRkDbYfm7iFG7TO05iKBgsFn1KUe2MmUNOV9R
         EBlnTuMQkCltx7biGpVOkiNCsDYvKZXo4+2f5EL/WZrF8/LAb6OtVYfqV/fX3pbWBhTf
         0LLmHaMjvJbZyNAKzWz52SPYWj60KvBOQnkvRwXdrpYPkzYcJsvRNcpXctSqkVXo+w2K
         oqin5IodaWrHKIjnKijGSi8DVfWNqgeYqZA+JQQ1OgfUvyw/oHxjjPiDw7vb/KeKVAML
         CT58YXKLnvRwMf+ddzglPI0YDNhQxkREGFMAtydhaDQAPUuBEUpG5egN68FdQeekW9ro
         y5WA==
X-Gm-Message-State: APjAAAUFwjZJlx/qByWp6G/g/BheTxqsT4UsHchdX40lv3tRS+7TqR4a
        8fZ+atDaWD/pyAZz4s+1FM8A2ZIdgHK2YHyIxUcWYw==
X-Google-Smtp-Source: APXvYqxTboKktRDuhxOsaQEmorwPS3R3wx8c0OouH7uGXFFPrpKfocRMCEVwVcgh6Xhf9YhtXgbqZlv20udAQTRmdNI=
X-Received: by 2002:a9d:2c47:: with SMTP id f65mr29976162otb.185.1563367471220;
 Wed, 17 Jul 2019 05:44:31 -0700 (PDT)
MIME-Version: 1.0
References: <156321356040.148361.7463881761568794395.stgit@magnolia>
 <156321358581.148361.8774330141606166898.stgit@magnolia> <20190717050118.GD7113@infradead.org>
In-Reply-To: <20190717050118.GD7113@infradead.org>
From:   Andreas Gruenbacher <agruenba@redhat.com>
Date:   Wed, 17 Jul 2019 14:44:20 +0200
Message-ID: <CAHc6FU7A3U1FZXwXfvJRL1FazUu=zfJ4=AwpggNG5QWvsywt2A@mail.gmail.com>
Subject: Re: [PATCH 4/9] iomap: move the SEEK_HOLE code into a separate file
To:     Christoph Hellwig <hch@infradead.org>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, 17 Jul 2019 at 07:01, Christoph Hellwig <hch@infradead.org> wrote:
> > diff --git a/fs/iomap/seek.c b/fs/iomap/seek.c
> > new file mode 100644
> > index 000000000000..0c36bef46522
> > --- /dev/null
> > +++ b/fs/iomap/seek.c
> > @@ -0,0 +1,214 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * Copyright (C) 2010 Red Hat, Inc.
> > + * Copyright (c) 2016-2018 Christoph Hellwig.
> > + */
>
> This looks a little odd.  There is nothing in here from Daves original
> iomap prototype.  It did start out with code from Andreas though which
> might or might not be RH copyright.  So we'll need Andreas and/or RH
> legal to chime in.

That code should be Copyright (C) 2017 Red Hat, Inc.

> Otherwise looks good:
>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks,
Andreas
