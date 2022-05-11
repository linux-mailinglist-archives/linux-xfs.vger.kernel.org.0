Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5B86522AC1
	for <lists+linux-xfs@lfdr.de>; Wed, 11 May 2022 06:21:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230202AbiEKEVM (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 11 May 2022 00:21:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbiEKEVL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 May 2022 00:21:11 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8513E3B3D5
        for <linux-xfs@vger.kernel.org>; Tue, 10 May 2022 21:21:08 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id g184so752015pgc.1
        for <linux-xfs@vger.kernel.org>; Tue, 10 May 2022 21:21:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jl1GZmm7QuKAbToF+dPGx7IgxaH6ShvhQAX01HB3wCc=;
        b=ltUc6hKbTACE4zlFPJKf6Z+hO3WQcTTeuwKVHECbtUXdc3XEatIzd0n7tiO638vGBN
         d/gZVhxS756AE2mPE3v7qYCixusH6wSltbX2Thocw8XnHb21P3uuEQBLfUeJnIrOH4Eb
         u58jlZJltai+LVOH5tktxfMFkiDVx3LdYDF539tWHb2I/zqOJOpnW3wOvkCZGgcpn+Sw
         MGS3qyclt4YGl06g+pdoTt82yqLPYimOr49UnkrgN4o98xHzmXwhJL/1vydGGNGYpLjh
         eh/n2GFpyXsYuS+ZkiPitXl6gdr0JSVEkfwkCEd0sbz377Yo6JrzXqqW4AOxftLzp6Tm
         I2GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jl1GZmm7QuKAbToF+dPGx7IgxaH6ShvhQAX01HB3wCc=;
        b=vIXqh/+Ine4uKmmPafjhylXfCDgmVDZrqZapb6SEfZbc5mI/RiBxwHp4d5wdMKsjWa
         PunmfozOThHALLlDj5zsvdzcvHMNBaZoj/06L0i/NUY87uFCOCWYGrYJyt4YprCDh24J
         M3ftfctgpsRPjY5AviIGJH4ZfOPw+km8WPoNm/j3O/78wBs9X/sfvhmCG1frsx6XP7gZ
         Uu1rZG3zbbZ2rV9XvFOIPe/oLYulk+Yzdvbz7naHkZMptmrPoSKwK6ZBp2VHj4pTLYdw
         v7ACKBxiXle48q+NiRx/51ZiXzAAiYmGvTOtZHwRjoAMYDEJ1AxI+6XIHUSOgA6sAbOZ
         rMKA==
X-Gm-Message-State: AOAM530egPdrzuNYdtaRsYvqld73T2FCMq02eauhNtgKjkyQCy3YkgqL
        m7+quiF63aavsHbX61UEb6tkb8xVbL+p1uL8PuXCAQ==
X-Google-Smtp-Source: ABdhPJw956CGNInPJoX0Sue0mYEmFyYdP4GE5ILyG00rRUkMD+8mKrIiV5I/p/QBznNriBkyTAqhRy7FXF8Omnk+4mA=
X-Received: by 2002:a05:6a00:22d4:b0:510:6d75:e3da with SMTP id
 f20-20020a056a0022d400b005106d75e3damr23699430pfj.3.1652242868060; Tue, 10
 May 2022 21:21:08 -0700 (PDT)
MIME-Version: 1.0
References: <20220508143620.1775214-1-ruansy.fnst@fujitsu.com>
 <20220511000352.GY27195@magnolia> <20220511014818.GE1098723@dread.disaster.area>
 <CAPcyv4h0a3aT3XH9qCBW3nbT4K3EwQvBSD_oX5W=55_x24-wFA@mail.gmail.com> <20220510192853.410ea7587f04694038cd01de@linux-foundation.org>
In-Reply-To: <20220510192853.410ea7587f04694038cd01de@linux-foundation.org>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Tue, 10 May 2022 21:20:57 -0700
Message-ID: <CAPcyv4ip6N6jvdb3LRjPnVr6xaFjiVg1OCE95pu9RiMG5_VNPw@mail.gmail.com>
Subject: Re: [PATCHSETS] v14 fsdax-rmap + v11 fsdax-reflink
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Dave Chinner <david@fromorbit.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Shiyang Ruan <ruansy.fnst@fujitsu.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Linux NVDIMM <nvdimm@lists.linux.dev>,
        Linux MM <linux-mm@kvack.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Jane Chu <jane.chu@oracle.com>,
        Goldwyn Rodrigues <rgoldwyn@suse.de>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Matthew Wilcox <willy@infradead.org>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>, linmiaohe@huawei.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 10, 2022 at 7:29 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> On Tue, 10 May 2022 18:55:50 -0700 Dan Williams <dan.j.williams@intel.com> wrote:
>
> > > It'll need to be a stable branch somewhere, but I don't think it
> > > really matters where al long as it's merged into the xfs for-next
> > > tree so it gets filesystem test coverage...
> >
> > So how about let the notify_failure() bits go through -mm this cycle,
> > if Andrew will have it, and then the reflnk work has a clean v5.19-rc1
> > baseline to build from?
>
> What are we referring to here?  I think a minimal thing would be the
> memremap.h and memory-failure.c changes from
> https://lkml.kernel.org/r/20220508143620.1775214-4-ruansy.fnst@fujitsu.com ?

Latest is here:
https://lore.kernel.org/all/20220508143620.1775214-1-ruansy.fnst@fujitsu.com/

> Sure, I can scoot that into 5.19-rc1 if you think that's best.  It
> would probably be straining things to slip it into 5.19.

Hmm, if it's straining things and XFS will also target v5.20 I think
the best course for all involved is just wait. Let some of the current
conflicts in -mm land in v5.19 and then I can merge the DAX baseline
and publish a stable branch for XFS and BTRFS to build upon for v5.20.

> The use of EOPNOTSUPP is a bit suspect, btw.  It *sounds* like the
> right thing, but it's a networking errno.  I suppose livable with if it
> never escapes the kernel, but if it can get back to userspace then a
> user would be justified in wondering how the heck a filesystem
> operation generated a networking errno?
