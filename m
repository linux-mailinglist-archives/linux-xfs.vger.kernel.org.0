Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6FA26637B
	for <lists+linux-xfs@lfdr.de>; Fri, 12 Jul 2019 03:52:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728853AbfGLBwF (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 11 Jul 2019 21:52:05 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:49538 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726587AbfGLBwF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Jul 2019 21:52:05 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6C1mu3t141178;
        Fri, 12 Jul 2019 01:51:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=Pi2T60jCwtSzyn8dBzmjwtKZ8LJ068DlMvjyaTxYNjk=;
 b=BeJZZYSGW69w7ExKWlHYHRkzxspIS8wEFe+Mz6la2aDR9D+Cyp61X+mjYTIPjqWuWhlt
 HK5H4EEkoLKgwe3U2Z+kVy/A3C9L5h4eQPdpXwn7vR5qf6YeYuEMXO59Tkvj6SiZbDN7
 eSXudMO6H9IAL+w4YfXS4tfkoUKwu9UOT92L5C7Y/faNP4tpFmC9Hg5fWtseNeLdyXbK
 AQkKd8AjaklCW8+UX2ATIMsxHvbwFbTsX/FSVQmclIycc/N1pPu6ET8t3+0BmyjgVH2F
 5E3X3TD5AwmHmK2EgqaaWhUVqJ9oFuppPyMlqDGtV4Vf2Mp/yVDx8iTiFhPfbVg26ekE AQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2tjm9r30jt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Jul 2019 01:51:44 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6C1mOFg093454;
        Fri, 12 Jul 2019 01:51:44 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2tnc8tvpma-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Jul 2019 01:51:44 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x6C1ph5t032669;
        Fri, 12 Jul 2019 01:51:43 GMT
Received: from localhost (/10.159.154.209)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 11 Jul 2019 18:51:43 -0700
Date:   Thu, 11 Jul 2019 18:51:42 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Zorro Lang <zlang@redhat.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: project quota ineritance flag test
Message-ID: <20190712015142.GX1404256@magnolia>
References: <20190619101047.3149-1-zlang@redhat.com>
 <20190711143516.GG5167@magnolia>
 <20190711153812.GA19443@dhcp-12-102.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190711153812.GA19443@dhcp-12-102.nay.redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9315 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907120021
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9315 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907120021
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 11, 2019 at 11:38:12PM +0800, Zorro Lang wrote:
> On Thu, Jul 11, 2019 at 07:35:16AM -0700, Darrick J. Wong wrote:
> > On Wed, Jun 19, 2019 at 06:10:47PM +0800, Zorro Lang wrote:
> > > This case is used to cover xfsprogs bug "b136f48b xfs_quota: fix
> > > false error reporting of project inheritance flag is not set" at
> > > first. Then test more behavior when project ineritance flag is
> > > set or removed.
> > > 
> > > Signed-off-by: Zorro Lang <zlang@redhat.com>
> > > ---
> > 
> > <skipping to the good part>
> > 
> > > diff --git a/tests/xfs/507.out b/tests/xfs/507.out
> > > new file mode 100644
> > > index 00000000..c8c09d3f
> > > --- /dev/null
> > > +++ b/tests/xfs/507.out
> > > @@ -0,0 +1,23 @@
> > > +QA output created by 507
> > > +== The parent directory has Project inheritance bit by default ==
> > > +Checking project test (path [SCR_MNT]/dir)...
> > > +Processed 1 ([PROJECTS_FILE] and cmdline) paths for project test with recursion depth infinite (-1).
> > > +
> > > +Write SCRATCH_MNT/dir/foo, expect ENOSPC:
> > > +pwrite: No space left on device
> > > +Write SCRATCH_MNT/dir/dir_inherit/foo, expect ENOSPC:
> > > +pwrite: No space left on device
> > > +
> > > +== After removing parent directory has Project inheritance bit ==
> > > +Checking project test (path [SCR_MNT]/dir)...
> > > +[SCR_MNT]/dir - project inheritance flag is not set
> > > +[SCR_MNT]/dir/foo - project identifier is not set (inode=0, tree=10)
> > > +[SCR_MNT]/dir/dir_uninherit - project identifier is not set (inode=0, tree=10)
> > > +[SCR_MNT]/dir/dir_uninherit - project inheritance flag is not set
> > > +[SCR_MNT]/dir/dir_uninherit/foo - project identifier is not set (inode=0, tree=10)
> > > +Processed 1 ([PROJECTS_FILE] and cmdline) paths for project test with recursion depth infinite (-1).
> > > +
> > > +Write SCRATCH_MNT/dir/foo, expect Success:
> > > +Write SCRATCH_MNT/dir/dir_inherit/foo, expect ENOSPC:
> > > +pwrite: No space left on device
> > 
> > I keep seeing this test failure:
> > 
> > --- a/xfs/508.out      2019-06-30 08:32:32.216174715 -0700
> > +++ b/xfs/508.out.bad    2019-07-11 07:32:30.488000000 -0700
> > @@ -19,5 +19,5 @@
> >  
> >  Write SCRATCH_MNT/dir/foo, expect Success:
> >  Write SCRATCH_MNT/dir/dir_inherit/foo, expect ENOSPC:
> > -pwrite: No space left on device
> > +/opt/dir/dir_inherit/foo: Disk quota exceeded
> 
> Hmm... I never saw this issue. I tested on RHEL-7, RHEL-8.0 and latest upstream
> xfsprogs & xfs-linux, all passed.
> 
> >  Write SCRATCH_MNT/dir/dir_uninherit/foo, expect Success:
> > 
> > IIRC EDQUOT is the correct error code for running out of /project/
> > quota (and I tried with a modern V5 fs and a V4 fs too) both with
> > setting no quota options at all and turning on every quota type
> > supported by the fs.
> > 
> > Under what circumstances does xfs_io spit out ENOSPC?
> 
> I didn't test with any special test arguments, all as default. For example, as
> below test on
> xfsprogs: HEAD: 8bfb5eac (HEAD -> for-next, origin/for-next) xfs_quota: fix built-in help for project setup
> xfs-linux: HEAD: 036f463fe15d (HEAD -> for-next, tag: xfs-5.3-merge-10, origin/xfs-5.3-merge, origin/for-next) xfs: online scrub needn't bother zeroing its temporary buffer
> 
> # ./check xfs/508
> FSTYP         -- xfs (debug)
> PLATFORM      -- Linux/x86_64 xxx-xxxxxx-xxx 5.2.0-rc4-xfs-for-next
> MKFS_OPTIONS  -- -f -bsize=4096 /dev/mapper/xfscratch
> MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 /dev/mapper/xfscratch /mnt/scratch
> 
> xfs/508 5s ...  5s
> Ran: xfs/508
> Passed all 1 tests
> 
> # xfs_io -V
> xfs_io version 5.1.0-rc0
> 
> # xfs_info /dev/mapper/xfscratch
> meta-data=/dev/mapper/xfscratch isize=512    agcount=4, agsize=5570560 blks
>          =                       sectsz=512   attr=2, projid32bit=1
>          =                       crc=1        finobt=1, sparse=1, rmapbt=0
>          =                       reflink=1
> data     =                       bsize=4096   blocks=22282240, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
> log      =internal log           bsize=4096   blocks=10880, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> Do you need me to provide anything else?

HAH.  Oops.  I was testing my dev tree, not upstream, so clearly there's
a bug in there somewhere.  Uh, good test! :)

Sorry for the noise.

--D

> Thanks,
> Zorro
> 
> > 
> > --D
> > 
> > > +Write SCRATCH_MNT/dir/dir_uninherit/foo, expect Success:
> > > diff --git a/tests/xfs/group b/tests/xfs/group
> > > index ffe4ae12..46200752 100644
> > > --- a/tests/xfs/group
> > > +++ b/tests/xfs/group
> > > @@ -504,3 +504,4 @@
> > >  504 auto quick mkfs label
> > >  505 auto quick spaceman
> > >  506 auto quick health
> > > +507 auto quick quota
> > > -- 
> > > 2.17.2
> > > 
