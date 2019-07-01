Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8838573A5
	for <lists+linux-xfs@lfdr.de>; Wed, 26 Jun 2019 23:30:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726341AbfFZVaq (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 26 Jun 2019 17:30:46 -0400
Received: from mail-yb1-f194.google.com ([209.85.219.194]:33031 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726227AbfFZVaq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Jun 2019 17:30:46 -0400
Received: by mail-yb1-f194.google.com with SMTP id n3so219219ybn.0
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jun 2019 14:30:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=editshare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=n89jGO3NmHHaYGYEUK0S3kZnLyat/XxScY2KIvg7qAU=;
        b=Z4Vx4Q1qlV9wFWKwV3DDTlZKvOge8sbi3dJ5ecTrTZWFJiWs4983LXATsHdzIMUD2p
         kUZ/yqlfxCGCOJEU8UcBcOlfJD5YH0595+agjv55HWO5V95BCGI39CHTloAZYN580rQh
         8dwCcRvHgtt2ZNkiIBeT943O+0TjfwD6yu7YS2uPerFVrZr14HfK5ztZJn3EcSzD/RpB
         IVSW48g80NDHl/r09YcM+Ffko9GtNbq/Il0QYo5Ps4CJtRItcjUv6vT6rV5nmqRgu3VF
         G45QacPtZvorm1ySJu6nBnTmYIkMrlz5z29c7ciaJf3AP/b4xMlyi+vMiX7oar0L+gUS
         hEWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=n89jGO3NmHHaYGYEUK0S3kZnLyat/XxScY2KIvg7qAU=;
        b=mtNbnTrTBVFbZzZwZvZmVeIQH1/1hIQ2u9IVyhzERvPs+sRcnCEOAcTGQb9J0zDtQp
         cska8ZrxoU7wNqZv0S3TYFqVsCrsDIMpUi0IkWb2kf1vSu1YCIeqwb6xU8InmgPr7/ES
         2yq8Q1Xsntddz3M2W0039wpiU5TLr2E4lAaoJloOv3wMPGDyT3cHJ0cxWJ2+DGmuhkfj
         wZwEpc9JvHiAmc/f4pFI2xcEMPZWCZmfOrGSdyb/hsG8sanOLNsiM824YvvfTCxKHqrs
         Mti/JKVWJc5J4m8hWHRANHoJqu0YPJfoYhpT2cOT9/WddtKPJec/sUC5VgtKR5Fjjwee
         Yk3A==
X-Gm-Message-State: APjAAAUjDUBQAMO0u1NBL91NA3vIFu0/cVHR6U/PKWTeX8GNKeTBk4zX
        e3tAXeQPLqMIRExKrB2NhYrscEjNozPT5B6EIFivuKUCqdOP2w==
X-Google-Smtp-Source: APXvYqwMURzk6263hm52HWe6J1ceAmE3OApcwoGSFkx+GZr58B/09UN5+nWnZiTh9cPaOwSJrbfdNvUxSecp2oXfFnA=
X-Received: by 2002:a25:df92:: with SMTP id w140mr390371ybg.71.1561584644842;
 Wed, 26 Jun 2019 14:30:44 -0700 (PDT)
MIME-Version: 1.0
References: <CAFVd4NsBRm_pbySuSc4U=a=G4wiowZ3gFBooLEQZGZJe9V748g@mail.gmail.com>
 <CAJCQCtRD2g1c5uyDurLbt7tedPM8g6f1-74ECAW9cA1Do1yNBQ@mail.gmail.com>
In-Reply-To: <CAJCQCtRD2g1c5uyDurLbt7tedPM8g6f1-74ECAW9cA1Do1yNBQ@mail.gmail.com>
From:   Rich Otero <rotero@editshare.com>
Date:   Wed, 26 Jun 2019 17:30:33 -0400
Message-ID: <CAFVd4NszdvQ0P4KPo9pRqtRRJxebhtMBqGVAZTmGAPBWe25nFg@mail.gmail.com>
Subject: Re: XFS Repair Error
To:     Chris Murphy <lists@colorremedies.com>
Cc:     xfs list <linux-xfs@vger.kernel.org>,
        Steve Alves <steve.alves@editshare.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> This applies
> http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

kernel version: 3.12.17
xfsprogs version: 3.1.7
number of CPUs: 12
contents of /proc/meminfo: 32 GiB RAM, 8 GiB swap, memory pressure on
this server is generally very low
contents of /proc/mounts: /dev/sdb1 /RAIDS/RAID_1 xfs
rw,noatime,attr2,inode64,logbsize=256k,sunit=512,swidth=2048,usrquota,grpquota
0 0
contents of /proc/partitions: 8       17 54690576384 sdb1
RAID layout: /dev/sdb is a 16-disk RAID-6 on a Broadcom MegaRAID
9361-series card
LVM configuration: none
type of disks you are using: WDC RE 4 TB SAS (WD4001FYYG-01SL3)
write cache status of drives: MegaRAID card has writeback enabled for this RAID
size of BBWC and mode it is running in: unknown
xfs_info output on the filesystem in question: no longer available
dmesg output showing all error messages and stack traces: no longer available

> Also, are the disk failures fixed? Is the RAID happy? I'm very
> skeptical of writing anything, including repairs, let alone rw
> mounting, a file system that's one a busted or questionably working
> storage stack. The storage stack needs to be in working order first.
> Is it?

This particular server is used for development purposes and the data
stored on it is replicated on other servers, so the integrity of the
data is not very important. We have used XFS in our storage products
for 15 years, mostly on RAID-5 and RAID-6 using LSI 3ware and Broadcom
MegaRAID cards. It is not uncommon for disks to fail and be replaced
and for the RAID to rebuild while the XFS is still in use, and we very
rarely experience XFS problems during or after the rebuild. In this
particular case, we suspected a malfunctioning RAID card and replaced
it, and we are replacing some faulty disks.

> OK why -L ? Was there a previous mount attempt and if so when kernel
> errors? Was there a previous repair attempt without -L? -L is a heavy
> hammer that shouldn't be needed unless the log is damaged and if the
> log is damaged or otherwise can't be replayed, you should get a kernel
> message about that.

Previously, mounting the XFS failed because the "structure must be
cleaned." That led to the first attempt at xfs_repair without -L,
which ended in an error complaining that the journal needed to be
replayed. But since I couldn't mount, that was impossible, so the
second xfs_repair attempt was with -L.

I needed to make this server functional again quickly, and since I
didn't care about losing the data, I simply reformatted the RAID
(`mkfs.xfs -f`), so I won't be able to reproduce the xfs_repair error.
In my eight years using XFS, I've never seen that error before, so I
thought it would be interesting to report to the list and see what I
could learn about it.

Regards,
Rich Otero
EditShare
rotero@editshare.com
617-782-0479

On Wed, Jun 26, 2019 at 5:04 PM Chris Murphy <lists@colorremedies.com> wrote:
>
> On Wed, Jun 26, 2019 at 2:32 PM Rich Otero <rotero@editshare.com> wrote:
> >
> > I have an XFS filesystem of approximately 56 TB on a RAID that has
> > been experiencing some disk failures. The disk problems seem to have
> > led to filesystem corruption, so I attempted to repair the filesystem
>
> This applies
> http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F
>
> Also, are the disk failures fixed? Is the RAID happy? I'm very
> skeptical of writing anything, including repairs, let alone rw
> mounting, a file system that's one a busted or questionably working
> storage stack. The storage stack needs to be in working order first.
> Is it?
>
> > with `xfs_repair -L <device>`. Xfs_repair finished with a message
> > stating that an error occurred and to report the bug.
>
> OK why -L ? Was there a previous mount attempt and if so when kernel
> errors? Was there a previous repair attempt without -L? -L is a heavy
> hammer that shouldn't be needed unless the log is damaged and if the
> log is damaged or otherwise can't be replayed, you should get a kernel
> message about that.
>
>
> --
> Chris Murphy
