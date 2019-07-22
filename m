Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DC5B70A61
	for <lists+linux-xfs@lfdr.de>; Mon, 22 Jul 2019 22:12:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732457AbfGVUMe (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 22 Jul 2019 16:12:34 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:35256 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732448AbfGVUMe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Jul 2019 16:12:34 -0400
Received: by mail-oi1-f196.google.com with SMTP id a127so30539189oii.2
        for <linux-xfs@vger.kernel.org>; Mon, 22 Jul 2019 13:12:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SKpNvjyeav2TkrWNw26KJV5Yk/ocQzfpVIZmY2lx9vA=;
        b=lDQJMz4xmZQMr7L/yPFc3AlHRQP9KzlvWkrdcIImOX55gl2BU4eHdDig9W7/ZWX4dI
         Juu2Y2hK84J5hsP25PfijR3jaeqVuIGwjhhbAmHIAA+xDBRlSOYOY4ZET2gAPdye2Vbl
         bYo1ktLZU3gCpHd5kefhqkwEkd0gsEUc6928bDSJZAjH1DtSrI0ueBOX2X94sOAkzsNw
         zVcAWgnOwyEPdruEBuca5d1ywQyWorIt2Tlhg8Gzzvf0v7mYDzugMFkdU52kngdC5rwK
         gVxD3RlcAdmu4y9BHirbQj1iuBQqPE/VdX6j00bkjaAU1YCrvPaYMBqbDg/RT4l0We+0
         shYg==
X-Gm-Message-State: APjAAAXSZKeaW4Pb/2JVH9c1pQ+W9pokk7qOtaO829jICnNENEfTej12
        c15HgUoJw95A0Z8en74pgKtb8f05EIvl+0pVqSKKccQp01o=
X-Google-Smtp-Source: APXvYqyhRxhuqfN9NPb1NOuvkt5AsL/yran3Id9FVtnziQurnms/xJCxtrVqV/RaSFxGA3nruRayA2spZawkzf5B0Mg=
X-Received: by 2002:aca:72d0:: with SMTP id p199mr22915331oic.178.1563826353288;
 Mon, 22 Jul 2019 13:12:33 -0700 (PDT)
MIME-Version: 1.0
References: <20190722095024.19075-1-hch@lst.de>
In-Reply-To: <20190722095024.19075-1-hch@lst.de>
From:   Andreas Gruenbacher <agruenba@redhat.com>
Date:   Mon, 22 Jul 2019 22:12:21 +0200
Message-ID: <CAHc6FU6oAsVGDA_7zMRiU=gR6EDh-P2x8sbjxr7XcKn4epS3UQ@mail.gmail.com>
Subject: Re: lift the xfs writepage code into iomap v3
To:     Christoph Hellwig <hch@lst.de>
Cc:     "Darrick J . Wong" <darrick.wong@oracle.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        linux-xfs@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Christoph,

On Mon, 22 Jul 2019 at 11:50, Christoph Hellwig <hch@lst.de> wrote:
> this series cleans up the xfs writepage code and then lifts it to
> fs/iomap.c so that it could be use by other file system.  I've been
> wanting to this for a while so that I could eventually convert gfs2
> over to it, but I never got to it.  Now Damien has a new zonefs
> file system for semi-raw access to zoned block devices that would
> like to use the iomap code instead of reinventing it, so I finally
> had to do the work.
>
>
> Changes since v2:
>  - rebased to v5.3-rc1
>  - folded in a few changes from the gfs2 enablement series

thanks for the much appreciated update.

I've added that and the remaining gfs2 iomap patches to this branch:

  git://git.kernel.org/pub/scm/linux/kernel/git/gfs2/linux-gfs2.git iomap

Your final patch on this branch, "gfs2: use iomap for buffered I/O in
ordered and writeback mode", still causes the following four xfstest
failures:

  generic/311 generic/322 generic/393 generic/418

The bug in generic/393 is that in the nobh case, when unstuffing an
inode, we fail to dirty the unstuffed page and so the page is never
written. This should be easy to fix. The other failures have other
causes (still investigating).

> Changes since v1:
>  - rebased to the latest xfs for-next tree
>  - keep the preallocated transactions for size updates
>  - rename list_pop to list_pop_entry and related cleanups
>  - better document the nofs context handling
>  - document that the iomap tracepoints are not a stable API

Thanks,
Andreas
