Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D4134A935F
	for <lists+linux-xfs@lfdr.de>; Fri,  4 Feb 2022 06:24:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238443AbiBDFXO (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 4 Feb 2022 00:23:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237461AbiBDFXN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Feb 2022 00:23:13 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86EDEC061714
        for <linux-xfs@vger.kernel.org>; Thu,  3 Feb 2022 21:23:13 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id c194so4129001pfb.12
        for <linux-xfs@vger.kernel.org>; Thu, 03 Feb 2022 21:23:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QRfoBad6xaNnxHl59RhSeOObo1h7VnZyGCv6jI7PtEQ=;
        b=fwyKmh86FlojrU+sd/TBHHZ4viFDON2ToZwJPOhNkKpDr0mbFr4tYNZo9B+ah9HkMJ
         eC/vGB496MmU85JHlh/wA7cnxT6CWKSIKEYN6RBpJqF+Gg87BRxvkgUaNBpTOeP7XU7v
         id7fM+Ws+4WgGbSfppglJk/Mu9k+KUKzlgFQY1hKjEuPGWkkH7pXvDIeGF+JcF6XH27I
         8w9twYyX909qLSaaktr2++ubwjGOP7j/nwROAYSzc4K9FkmnwQxpldgrkmFwB2MDVKN1
         2kcwbVXFUOa1ih+lNCQjv7PlCFKgmOLQkO0DTT3jDapPfhx3nczdJKDflj6W6aiubI0p
         E+QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QRfoBad6xaNnxHl59RhSeOObo1h7VnZyGCv6jI7PtEQ=;
        b=t8qMJI7+tj8wSF3+Gne5fttg5WTPQQYbNe1KAhs3yBimkrAbDiyxiJtAf3IsiDq7wF
         5Ll1Bs4N4+LUOX2JANM2YI4Yjri8um28oXMPHnKnUAowRxOkXkiOwX+ANoTtjd5//7oX
         GnH3TTu82zA7O1wl/tHTBToH7xM6HdUNUv43jKf60aMdmFCD8KGbjFOtlZVNq/zvdU7Z
         bdQXcdv6B9N5957UaqXjFCtQb9ZbMGkQl9HZv57x35Wi7Si0CxkGT/JUYu/zikkZPyer
         1Y4tymx5CrVDwRg5w1NsS90uq246i82x/tzJL/+R7Nao3WqpGt7L58TNfGtL/gSF5T6h
         EqGw==
X-Gm-Message-State: AOAM530vDnarga/ss/OxlLn3AVi/HXqjDHBQ1rArIbuj6tlaeMlqVYms
        LeHY2YOK+qKdSOhpiGdMNzc1idnAkWrkD7oCynizSA==
X-Google-Smtp-Source: ABdhPJwHAc/oiydG42zh/YFy2yhojJMwzDJLfd2gzwA9VgAmUNWeZj1OWMAW4bLiBRXQIgjKFgKxpvZwQ+knnx1pEdw=
X-Received: by 2002:a05:6a00:1508:: with SMTP id q8mr1395954pfu.3.1643952193051;
 Thu, 03 Feb 2022 21:23:13 -0800 (PST)
MIME-Version: 1.0
References: <20220128213150.1333552-1-jane.chu@oracle.com> <20220128213150.1333552-2-jane.chu@oracle.com>
 <YfqFWjFcdJSwjRaU@infradead.org> <d0fecaaa-8613-92d2-716d-9d462dbd3888@oracle.com>
 <950a3e4e-573c-2d9f-b277-d1283c7256cd@oracle.com> <YfvbyKdu812To3KY@infradead.org>
In-Reply-To: <YfvbyKdu812To3KY@infradead.org>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Thu, 3 Feb 2022 21:23:00 -0800
Message-ID: <CAPcyv4g7Vqp6Z2+EXHdv95oqQxfdvPDAnzBiRG2KqobaHzOAsg@mail.gmail.com>
Subject: Re: [PATCH v5 1/7] mce: fix set_mce_nospec to always unmap the whole page
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Jane Chu <jane.chu@oracle.com>,
        "david@fromorbit.com" <david@fromorbit.com>,
        "djwong@kernel.org" <djwong@kernel.org>,
        "vishal.l.verma@intel.com" <vishal.l.verma@intel.com>,
        "dave.jiang@intel.com" <dave.jiang@intel.com>,
        "agk@redhat.com" <agk@redhat.com>,
        "snitzer@redhat.com" <snitzer@redhat.com>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "ira.weiny@intel.com" <ira.weiny@intel.com>,
        "willy@infradead.org" <willy@infradead.org>,
        "vgoyal@redhat.com" <vgoyal@redhat.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 3, 2022 at 5:42 AM Christoph Hellwig <hch@infradead.org> wrote:
>
> On Wed, Feb 02, 2022 at 11:07:37PM +0000, Jane Chu wrote:
> > On 2/2/2022 1:20 PM, Jane Chu wrote:
> > >> Wouldn't it make more sense to move these helpers out of line rather
> > >> than exporting _set_memory_present?
> > >
> > > Do you mean to move
> > >     return change_page_attr_set(&addr, numpages, __pgprot(_PAGE_PRESENT), 0);
> > > into clear_mce_nospec() for the x86 arch and get rid of _set_memory_present?
> > > If so, sure I'll do that.
> >
> > Looks like I can't do that.  It's either exporting
> > _set_memory_present(), or exporting change_page_attr_set().  Perhaps the
> > former is more conventional?
>
> These helpers above means set_mce_nospec and clear_mce_nospec.  If they
> are moved to normal functions instead of inlines, there is no need to
> export the internals at all.

Agree, {set,clear}_mce_nospec() can just move to arch/x86/mm/pat/set_memory.c.
