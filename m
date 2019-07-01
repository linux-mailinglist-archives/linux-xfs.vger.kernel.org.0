Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 464BA5225F
	for <lists+linux-xfs@lfdr.de>; Tue, 25 Jun 2019 07:00:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727604AbfFYFAc (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 25 Jun 2019 01:00:32 -0400
Received: from mail2.protonmail.ch ([185.70.40.22]:25498 "EHLO
        mail2.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727443AbfFYFAc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Jun 2019 01:00:32 -0400
Date:   Tue, 25 Jun 2019 05:00:24 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=unascribed.com;
        s=protonmail; t=1561438829;
        bh=WRjlQtYG0+8YY9eqfzyOZA8vhzp6CS1XjtY6K5wCYao=;
        h=Date:To:From:Reply-To:Subject:Feedback-ID:From;
        b=NahOcLixQfOH1yTyjDhoyjZmMcnptCNz668df1vsuwxqPwgCJwS7ZTMPYLC3d+YCw
         YtEJ7Sh2NECg1iU6Hr1VWHg+w4oyyRHUOdyyBzEsvK1TDziF/EJHac67CzJ3YBZPez
         k6rbz45RiEawuuoy4s8uEePFvNlzGjTW0LEg4Jjs=
To:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
From:   Una Thompson <una@unascribed.com>
Reply-To: Una Thompson <una@unascribed.com>
Subject: Want help with messed-up dump
Message-ID: <2fE_FncH_93Kynhm46N3zVvFfq26C-AMOypRvdJX2gQM9UPDFVqsyW6svbeS_v1PWpH1lNG7P2cRBL81XDNXn8qioH18PY6aQYwn9_LHwBw=@unascribed.com>
Feedback-ID: WbWEJzREqFRHYBskk46jB4PIVj9gSIzrRxxXcmjS0nAXoZwOQfg0r21eCCI22IVfOM1cGyScAbDWnkbv2ekK-Q==:Ext:ProtonMail
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=7.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF autolearn=ham
        autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.protonmail.ch
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

Years ago (around 2015, if I remember correctly), while shrinking a 4.3TiB =
XFS partition on a RAID5 array, I attempted to perform a dump/restore cycle=
 and lost exactly half of my data. (I was shrinking the partition by a few =
MB to make room for LUKS metadata to encrypt the filesystem.)

The array had 4 disks (3 online, 1 spare) - I took two disks out, degrading=
 the array, to make room for the dump. Rather than join the two disks into =
a JBOD, I used xfsdump's ability to write two files, as the disks were 3.7T=
iB each and the filesystem was nearly full. As said, this was years ago, I =
forget the exact invocation.

After restoring the dump to the new filesystem with the desired smaller siz=
e, I realized the filesystem was only half full. I looked around and a bunc=
h of directories and files were missing. I tried xfsrestore again in variou=
s ways to try and get it to read both halves of the dump, but it'd always a=
bort with an error when it finished with the first half.

I fully accept this was my fault and is user error, and I chalked it up as =
a learning experience at the time, and to avoid losing any more data, rejoi=
ned the disk with the first part of the dump to the array. However, now, I'=
m attempting to find some important files from 2011 or so that were on the =
array that were lost during this messed up dump/restore.

The spare was never used, and still has the second part of the dump on it; =
the part I believe didn't get restored correctly. The first part is now gon=
e, after the RAID resync and LUKS format.

I've run photorec on the dump in an attempt to recover the files I'm lookin=
g for. I've found a few things that are familiar, but I'm mainly looking fo=
r a directory, not an archive, and photorec has been little help. Running x=
fsrestore on the orphaned half of the dump gives an error about a missing d=
irectory dump.

Is there anything at all I may be able to do to restore the data from this =
dump? I've tried everything I can think of and have been unsuccessful. I ha=
ve a feeling by losing the first half of the dump I've made any recovery im=
possible, but I figured if anyone knew a way for me to climb out of this ho=
le I've dug for myself, it'd be someone on the XFS list.

Thanks
