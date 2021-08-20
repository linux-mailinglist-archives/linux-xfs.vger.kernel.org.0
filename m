Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71A863F2F69
	for <lists+linux-xfs@lfdr.de>; Fri, 20 Aug 2021 17:27:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241003AbhHTP2E (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 20 Aug 2021 11:28:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240961AbhHTP2D (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Aug 2021 11:28:03 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B658DC061575
        for <linux-xfs@vger.kernel.org>; Fri, 20 Aug 2021 08:27:25 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id n13-20020a17090a4e0d00b0017946980d8dso13981821pjh.5
        for <linux-xfs@vger.kernel.org>; Fri, 20 Aug 2021 08:27:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=s+pZady9bZxuI5ZV217HLh19NePVUH4NtT4PhDASe8A=;
        b=mxA9ryU8JJCE6xg91cuNIqjrL1JDkONo6P8+DLklfSN2yE7omlUTGVGqGsV1LSrJxc
         u4r8m32maq75ln8QSnsVjt9XX5dmqle4XU1My+eIZsS0jOx+vYDBuXsJbjmri79tSozC
         LWc4QxAU/S3MEO/w8soRt9iUyt6bsc+zdf16d1u6kn3PvO2WLVhSEOlzuAnzSFLZhcfH
         B7xmSABvYCijcB2WMf1CsVQQjTsozoby0hS/2FmN81TbxQ2/AsTb9+zM7cG/0oG/6pPx
         LBPeMmPGI0E0s2HAI/mpmtk5cMbx6dWGUpQvnNfM89CcP9e/Z3/7W8Y34lCUC92JOBNm
         UWnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=s+pZady9bZxuI5ZV217HLh19NePVUH4NtT4PhDASe8A=;
        b=O9GM6xV3xa2YVwLqoWhsfz4SllfWqSAC73GVTUKpyWn4OzvHx1bYwS8bjeiS4ERS1B
         y+re1VtYbHiFPMCVBcTqNXrH8kWHHfIrHCwmJ3y7YsV+uuqcrgBgigUGtbImpXN574KT
         PUNxlumclIV51rmvVMRtlIwWiJTb/7+BKxIfPMyB3Z23QlcJMW0jfawu7qFPJzH9p/Ha
         hUmUz+DiRPpc3uCNVy2IN25TjXdnW7GZJ7mFSRcn8ZY8wdy5Hfe+PzjqRIN6Eo7Hr3SR
         FCoRkesiD/Cg5nYZHlUlia6f8uC8KnpbdGOr/V+1BhHj0sMe3WQnuUu1HldhewCiw3Wr
         KLGw==
X-Gm-Message-State: AOAM532bhR6BER4x+pOhMUqPwM9q5QupHyfFPPBnJESzRpWSPpLTbYo/
        Be3Gxe5OGP8xuFUdhjRkfOgnyQFUhGt+pJZOnNCNkA==
X-Google-Smtp-Source: ABdhPJxF0RCYcUVUBwMvZeOpqalPa/B9+Q+bapkBeipJxdjltc3i6RXJVl+F7zMaJbsIi20VC25awiuka6Iizvicc98=
X-Received: by 2002:a17:90b:23d6:: with SMTP id md22mr4951556pjb.149.1629473245264;
 Fri, 20 Aug 2021 08:27:25 -0700 (PDT)
MIME-Version: 1.0
References: <20210809061244.1196573-1-hch@lst.de> <20210809061244.1196573-12-hch@lst.de>
 <CAPcyv4hbSYnOC6Pdi1QShRxGjBAteig7nN1h-5cEvsFDX9SuAQ@mail.gmail.com> <20210820041158.GA26417@lst.de>
In-Reply-To: <20210820041158.GA26417@lst.de>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Fri, 20 Aug 2021 08:27:14 -0700
Message-ID: <CAPcyv4iQgyPgQhjCwWv9JkA+kx18nRjOucVm+z79uw1zcAbhPg@mail.gmail.com>
Subject: Re: [PATCH 11/30] iomap: add the new iomap_iter model
To:     Christoph Hellwig <hch@lst.de>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Shiyang Ruan <ruansy.fnst@fujitsu.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux NVDIMM <nvdimm@lists.linux.dev>, cluster-devel@redhat.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 19, 2021 at 9:12 PM Christoph Hellwig <hch@lst.de> wrote:
>
> On Thu, Aug 19, 2021 at 02:25:52PM -0700, Dan Williams wrote:
> > Given most of the iomap_iter users don't care about srcmap, i.e. are
> > not COW cases, they are leaving srcmap zero initialized. Should the
> > IOMAP types be incremented by one so that there is no IOMAP_HOLE
> > confusion? In other words, fold something like this?
>
> A hole really means nothing to read from the source.  The existing code
> also relies on that.

Ok, I've since found iomap_iter_srcmap(). Sorry for the noise.
