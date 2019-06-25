Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A08D5581D
	for <lists+linux-xfs@lfdr.de>; Tue, 25 Jun 2019 21:50:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726628AbfFYTuA (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 25 Jun 2019 15:50:00 -0400
Received: from sandeen.net ([63.231.237.45]:51492 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726274AbfFYTuA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 25 Jun 2019 15:50:00 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 5A7CE182F2;
        Tue, 25 Jun 2019 14:49:49 -0500 (CDT)
Subject: Re: Want help with messed-up dump
To:     Una Thompson <una@unascribed.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
References: <2fE_FncH_93Kynhm46N3zVvFfq26C-AMOypRvdJX2gQM9UPDFVqsyW6svbeS_v1PWpH1lNG7P2cRBL81XDNXn8qioH18PY6aQYwn9_LHwBw=@unascribed.com>
 <df58093d-9b7f-a6e2-5859-bcab9e9617e1@sandeen.net>
 <E0REDMxgD0Z9MMDCXHS6GANHPUbjnE1afm9LzPBon36dr_WRyN0GNZsm9y1Yeagb2HoCqGq60LqFgmAscZvqSKF6mAVTUN8PluTThvD2s2c=@unascribed.com>
From:   Eric Sandeen <sandeen@sandeen.net>
Openpgp: preference=signencrypt
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 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 pA==
Message-ID: <b519068c-4b52-f234-56d9-af327ecd6de5@sandeen.net>
Date:   Tue, 25 Jun 2019 14:49:57 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <E0REDMxgD0Z9MMDCXHS6GANHPUbjnE1afm9LzPBon36dr_WRyN0GNZsm9y1Yeagb2HoCqGq60LqFgmAscZvqSKF6mAVTUN8PluTThvD2s2c=@unascribed.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 6/25/19 2:04 PM, Una Thompson wrote:
> On Tuesday, June 25, 2019 6:06 AM, Eric Sandeen wrote:
> 
>> On 6/25/19 12:00 AM, Una Thompson wrote:
>>
>>> Hi,
>>> Years ago (around 2015, if I remember correctly), while shrinking a 4.3TiB XFS partition on a RAID5 array, I attempted to perform a dump/restore cycle and lost exactly half of my data. (I was shrinking the partition by a few MB to make room for LUKS metadata to encrypt the filesystem.)
>>> The array had 4 disks (3 online, 1 spare) - I took two disks out, degrading the array, to make room for the dump. Rather than join the two disks into a JBOD, I used xfsdump's ability to write two files, as the disks were 3.7TiB each and the filesystem was nearly full. As said, this was years ago, I forget the exact invocation.
>>
>> Unfortunately xfsdump doesn't have a lot of experts anymore, but we can at least try.
>>
>> Just to be clear, you did something like
>>
>> xfsdump .... -f file1 -f file2 ?
> 
> Probably something like that; I can't be sure, this was years ago and the system that used to own this array that would have the .bash_history has since failed.
> 
>>
>> and
>>
>> "The split is done in filesystem inode number (ino) order, at boundaries selected
>> to equalize the size of each stream."
>>
>> and now you only have file2, and file1 is lost?
> 
> Yes. However, as far as I can tell, I successfully restored file1 at the time, and still have the restored files.
> 
>>
>>> After restoring the dump to the new filesystem with the desired smaller size, I realized the filesystem was only half full. I looked around and a bunch of directories and files were missing. I tried xfsrestore again in various ways to try and get it to read both halves of the dump, but it'd always abort with an error when it finished with the first half.
>>> I fully accept this was my fault and is user error, and I chalked it up as a learning experience at the time, and to avoid losing any more data, rejoined the disk with the first part of the dump to the array. However, now, I'm attempting to find some important files from 2011 or so that were on the array that were lost during this messed up dump/restore.
>>> The spare was never used, and still has the second part of the dump on it; the part I believe didn't get restored correctly. The first part is now gone, after the RAID resync and LUKS format.
>>> I've run photorec on the dump in an attempt to recover the files I'm looking for. I've found a few things that are familiar, but I'm mainly looking for a directory, not an archive, and photorec has been little help. Running xfsrestore on the orphaned half of the dump gives an error about a missing directory dump.
>>
>> sharing the exact error you get when you try would be helpful.
> 
> Knew I forgot something; sorry.
> 
>     xfsrestore: using file dump (drive_simple) strategy
>     xfsrestore: version 3.1.6 (dump format 3.0) - type ^C for status and control
>     xfsrestore: searching media for dump
>     xfsrestore: examining media file 0
>     xfsrestore: dump description:
>     xfsrestore: hostname: phi
>     xfsrestore: mount point: /mnt/big
>     xfsrestore: volume: /dev/md0
>     xfsrestore: session time: Wed May 31 06:26:20 2017
>     xfsrestore: level: 0
>     xfsrestore: session label: ""
>     xfsrestore: media label: ""
>     xfsrestore: file system id: 19672483-ca53-4536-a1ff-eaf79740df38
>     xfsrestore: session id: 8cbb75f6-8739-40ba-97fc-880780463595
>     xfsrestore: media id: 9736ac42-07a4-4622-82c8-1a2bdf3e7f0b
>     xfsrestore: searching media for directory dump
>     xfsrestore: ERROR: no directory dump found
>     xfsrestore: restore complete: 0 seconds elapsed
>     xfsrestore: Restore Summary:
>     xfsrestore:   stream 0 /mnt/foo/bigdump2 ERROR (operator error or resource exhaustion)
>     xfsrestore: Restore Status: SUCCESS
> 
> Evidently, I did this in 2017. My time perception's pretty warped.

Ok, so, the directory structure was (I guess) in the first file.  There is surely a way to hack up xfsrestore to just spit out files into 1 top-level dir, maybe with inode numbers appended or something, but it'd take some hackery to do so, and I can't really guarantee that I have the time to look anytime soon, I'm afraid.

If I do have some downtime I'll try to look but can't make any promises for now.

-Eric
