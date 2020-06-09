Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5C531F3E09
	for <lists+linux-xfs@lfdr.de>; Tue,  9 Jun 2020 16:24:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730562AbgFIOYj (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 9 Jun 2020 10:24:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730004AbgFIOYi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Jun 2020 10:24:38 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6422EC05BD1E
        for <linux-xfs@vger.kernel.org>; Tue,  9 Jun 2020 07:24:38 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id d10so10386648pgn.4
        for <linux-xfs@vger.kernel.org>; Tue, 09 Jun 2020 07:24:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZFX1F3OkHqup99RqOqaVUUo0fic7h5CCqWt4it2jh1Q=;
        b=HSecd4ecZ3UA+zI6MzbenOSWVoKXAlu1ABWz+qjvdksjTeobJG/ggM5a0nhVSydxb9
         O72+lp9sN+EyghhHvCZ7JnOUNvhtbJhSJ46noyAbdvcNZhBQSGPpj7Va2qIBMYL7m5xw
         T/HP8Acjf2f0et4Uyg6jUKHHAPl6ek6VmskpYpdejHBDWKlF6Sw/TdM/R16Zt9o3cR37
         ZKVEFBjNJ2rF/8XFWAquMItj3hjwGbqr5Mkw0FdiE7kjv37WRcZ9X8BUI23Mj1jevmOL
         MfmurNPDm0G5CXnb4kgqs6c5iD1niQ3it+5iwy1OaB/0xIwlwzi1gtar+LhS9i9oLPS2
         3bZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZFX1F3OkHqup99RqOqaVUUo0fic7h5CCqWt4it2jh1Q=;
        b=EK96+mfkjtgZU9r3vyy1dKDYmRZ4cuP2WhALP8sbQra118XvX21g+EjH7ulYvquh9Z
         Vq8NoQV/u3hXtwM0ItW9g0XarD8T7J8IF/v9awXCaL8GZWoST985y4AkVslD06+gwlpx
         zf8ANYOjHVPz3K1fqtIQQ1JJq4QduepfGZUxnpmacFZsTFCIjk1buHMHL3Jsi8NP+2vh
         yNC0uSOEfMjYCwzwXFAjPCJwFSLn1X00HOj3kMDDXC1iLcNKw3tWApTvzQAofd3VwbdY
         ym+9m3DNIFvc/SLBsIy14iRJRRXe6Riy6k060qABGvhE33PKHzbl0hGQD4DWuKSe7ipc
         qK3Q==
X-Gm-Message-State: AOAM5305ncKObAlHsbbtQOnVuPXDiEzWaUCfcy0kTAx9AWhbRY8LI+Ej
        HsKcUvgip+bkUabxL2zl3yg=
X-Google-Smtp-Source: ABdhPJyzs8a1cneCtGu62ejodi/pgQRRMyKkUiMJ+gr2ghwtGzJt79l+/h7pVDIoSGnVRa247VVggg==
X-Received: by 2002:a65:5285:: with SMTP id y5mr25810497pgp.271.1591712677997;
        Tue, 09 Jun 2020 07:24:37 -0700 (PDT)
Received: from garuda.localnet ([171.48.18.33])
        by smtp.gmail.com with ESMTPSA id m10sm2817036pjs.27.2020.06.09.07.24.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2020 07:24:37 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, bfoster@redhat.com,
        hch@infradead.org
Subject: Re: [PATCH 0/7] xfs: Extend per-inode extent counters.
Date:   Tue, 09 Jun 2020 19:52:20 +0530
Message-ID: <4246468.YyLm5IjERU@garuda>
In-Reply-To: <20200608173103.GH1334206@magnolia>
References: <20200606082745.15174-1-chandanrlinux@gmail.com> <20200608173103.GH1334206@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Monday 8 June 2020 11:01:03 PM IST Darrick J. Wong wrote:
> On Sat, Jun 06, 2020 at 01:57:38PM +0530, Chandan Babu R wrote:
> > The commit xfs: fix inode fork extent count overflow
> > (3f8a4f1d876d3e3e49e50b0396eaffcc4ba71b08) mentions that 10 billion
> > per-inode data fork extents should be possible to create. However the
> > corresponding on-disk field has an signed 32-bit type. Hence this
> > patchset extends the on-disk field to 64-bit length out of which only
> > the first 47-bits are valid.
> > 
> > Also, XFS has a per-inode xattr extent counter which is 16 bits
> > wide. A workload which
> > 1. Creates 1 million 255-byte sized xattrs,
> > 2. Deletes 50% of these xattrs in an alternating manner,
> > 3. Tries to insert 400,000 new 255-byte sized xattrs
> > causes the following message to be printed on the console,
> > 
> > XFS (loop0): xfs_iflush_int: detected corrupt incore inode 131, total extents = -19916, nblocks = 102937, ptr ffff9ce33b098c00
> > XFS (loop0): xfs_do_force_shutdown(0x8) called from line 3739 of file fs/xfs/xfs_inode.c. Return address = ffffffffa4a94173
> > 
> > This indicates that we overflowed the 16-bits wide xattr extent
> > counter.
> > 
> > I have been informed that there are instances where a single file
> > has > 100 million hardlinks. With parent pointers being stored in xattr,
> > we will overflow the 16-bits wide xattr extent counter when large
> > number of hardlinks are created. Hence this patchset extends the
> > on-disk field to 32-bit length.
> > 
> > This patchset also includes the previously posted "Fix log reservation
> > calculation for xattr insert operation" patch as a bug fix. It
> > replaces the xattr set "mount" and "runtime" reservations with just
> > one static reservation. Hence we don't need the functionality to
> > calculate maximum sized 'xattr set' reservation separately anymore.
> > 
> > The patches can also be obtained from
> > https://github.com/chandanr/linux.git at branch xfs-extend-extent-counters.
> > 
> > Chandan Babu R (7):
> >   xfs: Fix log reservation calculation for xattr insert operation
> 
> What happened to that whole patchset with struct xfs_attr_set_resv
> and whatnot?  Did all that get condensed down to this single patch?

Yes, with the new method, we have just one static log reservation rather than
having "mount" and "runtime" reservations for the xattr set operation. The
single static log reservation takes into account the worst case
possible. i.e.
- Double split of the Dabtree for large local xattrs.
- Bmbt blocks required for mapping the contents of a maximum sized
  (i.e. XATTR_SIZE_MAX bytes in size) remote attribute.

-- 
chandan



