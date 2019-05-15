Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A31061E5DF
	for <lists+linux-xfs@lfdr.de>; Wed, 15 May 2019 02:06:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726380AbfEOAGy (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 14 May 2019 20:06:54 -0400
Received: from sandeen.net ([63.231.237.45]:39752 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726265AbfEOAGy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 14 May 2019 20:06:54 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 96BFF1726A;
        Tue, 14 May 2019 19:06:36 -0500 (CDT)
Subject: Re: [PATCH] xfs_db: add extent count and file size histograms
To:     Dave Chinner <david@fromorbit.com>,
        Jorge Guerra <jorge.guerra@gmail.com>
Cc:     linux-xfs@vger.kernel.org, osandov@osandov.com,
        Jorge Guerra <jorgeguerra@fb.com>
References: <20190514185026.73788-1-jorgeguerra@gmail.com>
 <20190514233119.GS29573@dread.disaster.area>
From:   Eric Sandeen <sandeen@sandeen.net>
Openpgp: preference=signencrypt
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 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 pA==
Message-ID: <f121a7d3-ef90-2777-3074-dee302a3ad28@sandeen.net>
Date:   Tue, 14 May 2019 19:06:52 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190514233119.GS29573@dread.disaster.area>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 5/14/19 6:31 PM, Dave Chinner wrote:
> On Tue, May 14, 2019 at 11:50:26AM -0700, Jorge Guerra wrote:
>> From: Jorge Guerra <jorgeguerra@fb.com>
>>
>> In this change we add two feature to the xfs_db 'frag' command:
>>
>> 1) Extent count histogram [-e]: This option enables tracking the
>>    number of extents per inode (file) as the we traverse the file
>>    system.  The end result is a histogram of the number of extents per
>>    file in power of 2 buckets.
>>
>> 2) File size histogram and file system internal fragmentation stats
>>    [-s]: This option enables tracking file sizes both in terms of what
>>    has been physically allocated and how much has been written to the
>>    file.  In addition, we track the amount of internal fragmentation
>>    seen per file.  This is particularly useful in the case of real
>>    time devices where space is allocated in units of fixed sized
>>    extents.
> 
> I can see the usefulness of having such information, but xfs_db is
> the wrong tool/interface for generating such usage reports.
> 
>> The man page for xfs_db has been updated to reflect these new command
>> line arguments.
>>
>> Tests:
>>
>> We tested this change on several XFS file systems with different
>> configurations:
>>
>> 1) regular XFS:
>>
>> [root@m1 ~]# xfs_info /mnt/d0
>> meta-data=/dev/sdb1              isize=256    agcount=10, agsize=268435455 blks
>>          =                       sectsz=4096  attr=2, projid32bit=1
>>          =                       crc=0        finobt=0, sparse=0, rmapbt=0
>>          =                       reflink=0
>> data     =                       bsize=4096   blocks=2441608704, imaxpct=100
>>          =                       sunit=0      swidth=0 blks
>> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
>> log      =internal log           bsize=4096   blocks=521728, version=2
>>          =                       sectsz=4096  sunit=1 blks, lazy-count=1
>> realtime =none                   extsz=4096   blocks=0, rtextents=0
>> [root@m1 ~]# echo "frag -e -s" | xfs_db -r /dev/sdb1
>> xfs_db> actual 494393, ideal 489246, fragmentation factor 1.04%
> 
> For example, xfs_db is not the right tool for probing online, active
> filesystems.

yes, the usage example is poor.  (I almost wonder if we should disallow
certain operations with -r ...)

> It is not coherent with the active kernel filesystem,
> and is quite capable of walking off into la-la land as a result of
> mis-parsing the inconsistent filesystem that is on disk underneath
> active mounted filesystems. This does not make for a robust, usable
> tool, let alone one that can make use of things like rmap for
> querying usage and ownership information really quickly.
> 
> To solve this problem, we now have the xfs_spaceman tool and the
> GETFSMAP ioctl for running usage queries on mounted filesystems.
> That avoids all the coherency and crash problems, and for rmap
> enabled filesystems it does not require scanning the entire
> filesystem to work out this information (i.e. it can all be derived
> from the contents of the rmap tree).
> 
> So I'd much prefer that new online filesystem queries go into
> xfs-spaceman and use GETFSMAP so they can be accelerated on rmap
> configured filesystems rather than hoping xfs_db will parse the
> entire mounted filesystem correctly while it is being actively
> changed...

Yeah fair point.

>> Maximum extents in a file 14
>> Histogram of number of extents per file:
>>     bucket =       count        % of total
>> <=       1 =      350934        97.696 %
>> <=       2 =        6231        1.735 %
>> <=       4 =        1001        0.279 %
>> <=       8 =         953        0.265 %
>> <=      16 =          92        0.026 %
>> Maximum file size 26.508 MB
>> Histogram of file size:
>>     bucket =    allocated           used        overhead(bytes)
>> <=    4 KB =           0              62           314048512 0.13%
>> <=    8 KB =           0          119911        127209263104 53.28%
>> <=   16 KB =           0           14543         15350194176 6.43%
>> <=   32 KB =         909           12330         11851161600 4.96%
>> <=   64 KB =          92            6704          6828642304 2.86%
>> <=  128 KB =           1            7132          6933372928 2.90%
>> <=  256 KB =           0           10013          8753799168 3.67%
>> <=  512 KB =           0           13616          9049227264 3.79%
>> <=    1 MB =           1           15056          4774912000 2.00%
>> <=    2 MB =      198662           17168          9690226688 4.06%
>> <=    4 MB =       28639           21073         11806654464 4.94%
>> <=    8 MB =       35169           29878         14200553472 5.95%
>> <=   16 MB =       95667           91633         11939287040 5.00%
>> <=   32 MB =          71              62            28471742 0.01%
>> capacity used (bytes): 1097735533058 (1022.346 GB)
>> capacity allocated (bytes): 1336497410048 (1.216 TB)
>> block overhead (bytes): 238761885182 (21.750 %)
> 
> BTW, "bytes" as a display unit is stupidly verbose and largely
> unnecessary. The byte count is /always/ going to be a multiple of
> the filesystem block size, and the first thing anyone who wants to
> use this for diagnosis is going to have to do is return the byte
> count to filesystem blocks (which is what the filesystem itself
> tracks everything in. ANd then when you have PB scale filesystems,
> anything more than 3 significant digits is just impossible to read
> and compare - that "overhead" column (what the "overhead" even
> mean?) is largely impossible to read and determine what the actual
> capacity used is without counting individual digits in each number.

But if the whole point is trying to figure out "internal fragmentation"
then it's the only unit that makes sense, right?  This is the "15 bytes"
of a 15 byte file (or extent) allocated into a 4k block.

OTOH, for any random file distribution it's going to trend towards half
a block, so I'm not sure how useful this is in the end.

(however your example seems to show roughly 200x the waste expected,
so I kind of wonder if that points to a bug somewhere in your patch...)

> FWIW, we already have extent histogram code in xfs_spaceman
> (in spaceman/freesp.c) and in xfs_db (db/freesp.c) so we really
> don't need re-implementation of the same functionality we already
> have duplicate copies of. I'd suggest that the histogram code should
> be factored and moved to libfrog/ and then enhanced if new histogram
> functionality is required...

Also a fair point, I had forgotten about that.

Thanks,
-Eric

> Cheers,
> 
> Dave.
> 
