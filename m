Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 582C232A19D
	for <lists+linux-xfs@lfdr.de>; Tue,  2 Mar 2021 14:55:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344673AbhCBGlf (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 2 Mar 2021 01:41:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1574447AbhCBDfv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Mar 2021 22:35:51 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3D20C061756
        for <linux-xfs@vger.kernel.org>; Mon,  1 Mar 2021 19:33:38 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id v13so7051140edw.9
        for <linux-xfs@vger.kernel.org>; Mon, 01 Mar 2021 19:33:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QHkKhS85lTO/1ZkryMnHdjoXWEHU3orWJwuliOPijEg=;
        b=un1zylhUbUa9CBvR67wBcwPZvQL0x4JmNFowwQWRDdGYxu6J0OgWJEqn+3PtBd+4QC
         cqbNNIeSXYA8G6vSnR2uWbYjsgGQb5v/h7oL7jXxuD/VBFphR/pct3mB6r/X2pupGg/4
         SX0eqVTO0JkgI1bmn9LswXNbdaya2hfY4NIFZphT51UPaWZdFK1euP4fmMjsJ/0gWvHH
         5MQKmxtzMf+qFdDzOGUkl/xaAxZrFsRaD+xCnHywqcc6II2p9p2dKXMlqjkktBRuwj7O
         L/YYyNBuR6P8AD/3Fbh94FYwxPajGC5dQCIpOaLmcM/6zN0em2h1wm4dnam+wALgryIF
         VUzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QHkKhS85lTO/1ZkryMnHdjoXWEHU3orWJwuliOPijEg=;
        b=qQ30cCOaWrIlUt3AN+YuPSgQXBE/gP+5VtvONtVLPLq15BNAziCENOQvBkozdB9k+a
         cgXIIr+Vc1P8y2yHPArgBfIXj5n0YS3pX2HyRqz5+9SVHhx+6S0Y2N9Dupo6WKGL3+RH
         Zme4i7uuPUg8V110cxz+B66WQUY/BBkpxjLEM8rIswo9kC+AcBPsPs2CWBCrus15GXXm
         z90Iu6i/NsE+73F/QHUn4Ap9TVGLEc/WonhvekQjTjv2tb8OCrhgkNeNdG//3tIBG2my
         WmFRWtZhTbVSTaxm6Wnh75b2AKgkkjaikYe/v0FAbbt5FEOKshWrWBaJOhvBoyWw11WC
         mylA==
X-Gm-Message-State: AOAM531at8fFWQMVISne8aPDe6Imqu9r5yrCkPHE9R81I7LBkS8uqgPc
        tCoZDTgVYb1XGIuob2ZZAHISJe4/6P5I656HALNc6Q==
X-Google-Smtp-Source: ABdhPJy6/ka8tGagcwE2L5RBcYi+8/lqcA+6OxdF6mdgjEfsgOsYpbXmbns7gGEU/XAr64+OyUVXGqCAa0atgxuU9hs=
X-Received: by 2002:a05:6402:1152:: with SMTP id g18mr19307291edw.18.1614656017366;
 Mon, 01 Mar 2021 19:33:37 -0800 (PST)
MIME-Version: 1.0
References: <20210226205126.GX4662@dread.disaster.area> <CAPcyv4iDefA3Y0wUW=p080SYAsM_2TPJba-V-sxdK_BeJMkmsw@mail.gmail.com>
 <20210226212748.GY4662@dread.disaster.area> <CAPcyv4jryJ32R5vOwwEdoU3V8C0B7zu_pCt=7f6A3Gk-9h6Dfg@mail.gmail.com>
 <20210227223611.GZ4662@dread.disaster.area> <CAPcyv4h7XA3Jorcy_J+t9scw0A4KdT2WEwAhE-Nbjc=C2qmkMw@mail.gmail.com>
 <20210228223846.GA4662@dread.disaster.area> <CAPcyv4jzV2RUij2BEvDJLLiK_67Nf1v3M6-jRLKf32x4iOzqng@mail.gmail.com>
 <20210301224640.GG4662@dread.disaster.area> <CAPcyv4iTqDJApZY0o_Q0GKn93==d2Gta2NM5x=upf=3JtTia7Q@mail.gmail.com>
 <20210302024227.GH4662@dread.disaster.area>
In-Reply-To: <20210302024227.GH4662@dread.disaster.area>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Mon, 1 Mar 2021 19:33:28 -0800
Message-ID: <CAPcyv4ja8gnTR1E-Ge5etm+y69cHwdWN6Bg79wPPF4M=C-w79A@mail.gmail.com>
Subject: Re: Question about the "EXPERIMENTAL" tag for dax in XFS
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        "ruansy.fnst@fujitsu.com" <ruansy.fnst@fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "darrick.wong@oracle.com" <darrick.wong@oracle.com>,
        "willy@infradead.org" <willy@infradead.org>,
        "jack@suse.cz" <jack@suse.cz>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>,
        "hch@lst.de" <hch@lst.de>, "rgoldwyn@suse.de" <rgoldwyn@suse.de>,
        "y-goto@fujitsu.com" <y-goto@fujitsu.com>,
        "qi.fuli@fujitsu.com" <qi.fuli@fujitsu.com>,
        "fnstml-iaas@cn.fujitsu.com" <fnstml-iaas@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 1, 2021 at 6:42 PM Dave Chinner <david@fromorbit.com> wrote:
[..]
> We do not need a DAX specific mechanism to tell us "DAX device
> gone", we need a generic block device interface that tells us "range
> of block device is gone".

This is the crux of the disagreement. The block_device is going away
*and* the dax_device is going away. The dax_device removal implies one
set of actions (direct accessed pfns invalid) the block device removal
implies another (block layer sector access offline). corrupted_range
is blurring the notification for 2 different failure domains. Look at
the nascent idea to mount a filesystem on dax sans a block device.
Look at the existing plumbing for DM to map dax_operations through a
device stack. Look at the pushback Ruan got for adding a new
block_device operation for corrupted_range().

> The reason that the block device is gone is irrelevant to the
> filesystem. The type of block device is also irrelevant. If the
> filesystem isn't using DAX (e.g. dax=never mount option) even when
> it is on a DAX capable device, then it just doesn't care about
> invalidating DAX mappings because it has none. But it still may care
> about shutting down the filesystem because the block device is gone.

Sure, let's have a discussion about a block_device gone notification,
and a dax_device gone notification.

> This is why we need to communicate what error occurred, not what
> action a device driver thinks needs to be taken.

The driver is only an event producer in this model, whatever the
consumer does at the other end is not its concern. There may be a
generic consumer and a filesystem specific consumer.

> The error is
> important to the filesystem, the action might be completely
> irrelevant. And, as we know now, shutdown on DAX enable filesystems
> needs to imply DAX mapping invalidation in all cases, not just when
> the device disappears from under the filesystem.

Sure.
