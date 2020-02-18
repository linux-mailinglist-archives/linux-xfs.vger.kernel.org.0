Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 842A51635A1
	for <lists+linux-xfs@lfdr.de>; Tue, 18 Feb 2020 23:02:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726339AbgBRWCo (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 18 Feb 2020 17:02:44 -0500
Received: from sandeen.net ([63.231.237.45]:36748 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726352AbgBRWCo (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 18 Feb 2020 17:02:44 -0500
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id F04B22A78;
        Tue, 18 Feb 2020 16:02:28 -0600 (CST)
Subject: Re: [PATCH 1/2] generic: per-type quota timers set/get test
From:   Eric Sandeen <sandeen@sandeen.net>
To:     Zorro Lang <zlang@redhat.com>, fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org
References: <20200216181631.22560-1-zlang@redhat.com>
 <01255cda-adee-1f0d-8e35-62d3b39813b5@sandeen.net>
 <af69203a-3e6f-31a3-d083-acd1f6654fbb@sandeen.net>
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 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 pA==
Message-ID: <9b442ccc-a32f-2199-c682-16a403caf9f2@sandeen.net>
Date:   Tue, 18 Feb 2020 16:02:41 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <af69203a-3e6f-31a3-d083-acd1f6654fbb@sandeen.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2/18/20 3:44 PM, Eric Sandeen wrote:
> 
> 
> On 2/18/20 3:41 PM, Eric Sandeen wrote:
>> On 2/16/20 12:16 PM, Zorro Lang wrote:
>>> Set different grace time, make sure each of quota (user, group and
>>> project) timers can be set (by setquota) and get (by repquota)
>>> correctly.
>>>
>>> Signed-off-by: Zorro Lang <zlang@redhat.com>
>>> ---
>>>
>>> Hi,
>>>
>>> This case test passed on ext4, but on XFS (xfs-linux for-next branch with
>>> Eric's patchset: [PATCH 0/4] xfs: enable per-type quota timers and warn limits)
>>> I got below different output:
>>
>> *sigh* I wish we didn't have so many different quota tools & interfaces.
>>
>> Behold:
>>
>> # export MIN=60
>> # setquota -t -g $((30 * MIN)) $((40 * MIN)) /mnt/scratch
>>
>>
>> # ./repquota -g /mnt/scratch
>> *** Report for group quotas on device /dev/pmem0p2
>> Block grace time: 00:00; Inode grace time: 00:00
>> ...
>>
>>
>> # xfs_quota -x -c "state -g"  /mnt/scratch
>> Group quota state on /mnt/scratch (/dev/pmem0p2)
>>   Accounting: ON
>>   Enforcement: ON
>>   Inode: #132 (1 blocks, 1 extents)
>> Blocks grace time: [0 days 00:30:00]
>> Inodes grace time: [0 days 00:40:00]
>> Realtime Blocks grace time: [--------]
>>
>> seems like this may actually be a bug in the quota/repquota code, trying to dig through
>> that now.
>>
>> repquota actually calls & gets group quota grace, but perhaps it gets overwritten with the subsequent call for the (empty) user quota:
>>
>> # strace -v -e quotactl ./repquota -g /mnt/scratch 2>&1 | grep "STAT|"
>> quotactl(Q_XGETQSTAT|USRQUOTA, "/dev/pmem0p2", 0, {version=1, flags=XFS_QUOTA_UDQ_ACCT|XFS_QUOTA_UDQ_ENFD|XFS_QUOTA_GDQ_ACCT|XFS_QUOTA_GDQ_ENFD, incoredqs=60, u_ino=131, u_nblks=1, u_nextents=1, g_ino=132, g_nblks=1, g_nextents=1, btimelimit=0, itimelimit=0, rtbtimelimit=0, bwarnlimit=0, iwarnlimit=0}) = 0
>> quotactl(Q_XGETQSTAT|GRPQUOTA, "/dev/pmem0p2", 0, {version=1, flags=XFS_QUOTA_UDQ_ACCT|XFS_QUOTA_UDQ_ENFD|XFS_QUOTA_GDQ_ACCT|XFS_QUOTA_GDQ_ENFD, incoredqs=60, u_ino=131, u_nblks=1, u_nextents=1, g_ino=132, g_nblks=1, g_nextents=1, btimelimit=1800, itimelimit=2400, rtbtimelimit=0, bwarnlimit=0, iwarnlimit=0}) = 0
>> quotactl(Q_XGETQSTAT|PRJQUOTA, "/dev/pmem0p2", 0, {version=1, flags=XFS_QUOTA_UDQ_ACCT|XFS_QUOTA_UDQ_ENFD|XFS_QUOTA_GDQ_ACCT|XFS_QUOTA_GDQ_ENFD, incoredqs=60, u_ino=131, u_nblks=1, u_nextents=1, g_ino=132, g_nblks=1, g_nextents=1, btimelimit=0, itimelimit=0, rtbtimelimit=0, bwarnlimit=0, iwarnlimit=0}) = 0
>> quotactl(Q_XGETQSTAT|USRQUOTA, "/dev/pmem0p2", 0, {version=1, flags=XFS_QUOTA_UDQ_ACCT|XFS_QUOTA_UDQ_ENFD|XFS_QUOTA_GDQ_ACCT|XFS_QUOTA_GDQ_ENFD, incoredqs=60, u_ino=131, u_nblks=1, u_nextents=1, g_ino=132, g_nblks=1, g_nextents=1, btimelimit=0, itimelimit=0, rtbtimelimit=0, bwarnlimit=0, iwarnlimit=0}) = 0
>>
>> but why doesn't this happen for ext4 ...
> 
> ... because on ext4, it makes different quotactl calls... of course :( :
> 
> quotactl(Q_GETINFO|GRPQUOTA, "/dev/pmem0p2", 0, {bgrace=1800, igrace=2400, flags=0, valid=IIF_BGRACE|IIF_IGRACE|IIF_FLAGS}) = 0

Ok, repquota only ever inits the quota info for this purpose with type 0 (i.e. usrquota)

I guess this fixes it:

diff --git a/quotaio_xfs.c b/quotaio_xfs.c
index 56daf89..b22c7b4 100644
--- a/quotaio_xfs.c
+++ b/quotaio_xfs.c
@@ -81,7 +81,7 @@ static int xfs_init_io(struct quota_handle *h)
        struct xfs_mem_dqinfo info;
        int qcmd;
 
-       qcmd = QCMD(Q_XFS_GETQSTAT, 0);
+       qcmd = QCMD(Q_XFS_GETQSTAT, h->qh_type);
        memset(&info, 0, sizeof(struct xfs_mem_dqinfo));
        if (quotactl(qcmd, h->qh_quotadev, 0, (void *)&info) < 0)
                return -1;

and I need to see what's going on here, but probably this too:

diff --git a/quotaon_xfs.c b/quotaon_xfs.c
index d557a75..d137240 100644
--- a/quotaon_xfs.c
+++ b/quotaon_xfs.c
@@ -32,7 +32,7 @@ static int xfs_state_check(int qcmd, int type, int flags, const char *dev, int r
        if (flags & STATEFLAG_ALL)
                return 0;       /* noop */
 
-       if (quotactl(QCMD(Q_XFS_GETQSTAT, 0), dev, 0, (void *)&info) < 0) {
+       if (quotactl(QCMD(Q_XFS_GETQSTAT, type), dev, 0, (void *)&info) < 0) {
                errstr(_("quotactl() on %s: %s\n"), dev, strerror(errno));
                return -1;
        }

