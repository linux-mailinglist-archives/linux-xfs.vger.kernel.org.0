Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 528A7237FC
	for <lists+linux-xfs@lfdr.de>; Mon, 20 May 2019 15:27:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730864AbfETN1u convert rfc822-to-8bit (ORCPT
        <rfc822;lists+linux-xfs@lfdr.de>); Mon, 20 May 2019 09:27:50 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43263 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729963AbfETN1u (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 May 2019 09:27:50 -0400
Received: by mail-wr1-f67.google.com with SMTP id r4so14583875wro.10
        for <linux-xfs@vger.kernel.org>; Mon, 20 May 2019 06:27:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=uZuRB6bCegPSknPVENZVLAvXlDpgg+/Q2IOxuM8r0Wc=;
        b=ULfT5CQ5h2ZS1EMfejL6muS+nNPlNtjwha6dA2E0pJUpZnlIwovBGAdo+U6b+H7MS1
         3kGi9Y8id+wtfbut1NWbZv54cqozYscOkIRhVhbKiFqsqAH3W5orT9y3B+L5Re4ytr8h
         IekETAOQHg5oW0gV/iT8fA1txgcYEF7xu3QzUmPndagb3EKgvHqGFim1sIOWLNW6PN+a
         5pITrv4L1d6/ZeUGPwozhiVHApW9M2yFMi8CLvE4CfgI5nmxzoOaLoeQDjUHMRz9JFMN
         bkR4MjBt9goGvVtEB0kOk8+XhVN0Au4mo4KpRXJshQPeHHGhy1QHL5eAdLF5DBO6sLao
         2xKQ==
X-Gm-Message-State: APjAAAXRUzf73oxOXdhD92stpSXTYovztfjCwm3jIrd3TqEjs7fxo1IS
        1PClDxMa1Xc6neVEuaBFC2yAcIwwzjXwlqSNC4tWRXh3Rqo=
X-Google-Smtp-Source: APXvYqzxj4+e0bn87ZeaenmOAaj+t+jEXy5advZw2ahKPIO/IOcdzt5Adt7mwiVuyRpNrDsVA/X/mI/aorIPP+OHXFk=
X-Received: by 2002:adf:fc44:: with SMTP id e4mr13411324wrs.243.1558358868220;
 Mon, 20 May 2019 06:27:48 -0700 (PDT)
MIME-Version: 1.0
References: <20190517073119.30178-1-hch@lst.de> <20190517073119.30178-12-hch@lst.de>
 <20190520131232.GB31317@bfoster> <20190520131946.GA8717@lst.de>
In-Reply-To: <20190520131946.GA8717@lst.de>
From:   Bryan Gurney <bgurney@redhat.com>
Date:   Mon, 20 May 2019 09:27:37 -0400
Message-ID: <CAHhmqcQaFiQjyfFq0yQQTHrEAMJ68JBN4dZfD6nXZ6DfKPtDiQ@mail.gmail.com>
Subject: Re: [PATCH 11/20] xfs: use a list_head for iclog callbacks
To:     Christoph Hellwig <hch@lst.de>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 20, 2019 at 9:20 AM Christoph Hellwig <hch@lst.de> wrote:
>
> On Mon, May 20, 2019 at 09:12:33AM -0400, Brian Foster wrote:
> > > +                           spin_unlock(&iclog->ic_callback_lock);
> > > +                           xlog_cil_process_commited(&tmp, aborted);
> >
> > s/commited/committed/ please.
>
> Ok.
>
> > > +   while ((ctx = list_first_entry_or_null(list,
> >
> > Are double braces necessary here?
>
> Without them gcc is unhappy:
>
> fs/xfs/xfs_log_cil.c: In function ‘xlog_cil_process_commited’:
> fs/xfs/xfs_log_cil.c:624:9: warning: suggest parentheses around assignment used as truth value [-Wparentheses]
>   while (ctx = list_first_entry_or_null(list,
>

It's probably to guard against an assignment in a while / if / etc. statement.

In other words: Are you sure you didn't intend the following?

     while (ctx == list_first_entry_or_null(list,
                     struct xfs_cil_ctx, iclog_entry)) {

(I've stumbled on a bug like this before, so I figured I'd ask, just
to be certain.)


Thanks,

Bryan

> > >     /* attach all the transactions w/ busy extents to iclog */
> >
> > Any idea what this ^ comment means? ISTM it's misplaced or stale. If so,
> > we might as well toss/replace it.
>
> No idea.  We can probbaly remove it.
