Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13B07B89F4
	for <lists+linux-xfs@lfdr.de>; Fri, 20 Sep 2019 06:24:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404428AbfITEYO (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 20 Sep 2019 00:24:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45658 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404405AbfITEYO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 20 Sep 2019 00:24:14 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A9F771DCD;
        Fri, 20 Sep 2019 04:24:13 +0000 (UTC)
Received: from localhost (dhcp-12-102.nay.redhat.com [10.66.12.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 285F15C1B5;
        Fri, 20 Sep 2019 04:24:12 +0000 (UTC)
Date:   Fri, 20 Sep 2019 12:31:39 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] common/xfs: wipe the XFS superblock of each AGs
Message-ID: <20190920043139.GO7239@dhcp-12-102.nay.redhat.com>
References: <20190919150024.8346-1-zlang@redhat.com>
 <66503981-2ff3-f28b-fd06-9d6360c930fe@cn.fujitsu.com>
 <20190920024836.GO2229799@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190920024836.GO2229799@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.71]); Fri, 20 Sep 2019 04:24:13 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 19, 2019 at 07:48:36PM -0700, Darrick J. Wong wrote:
> On Fri, Sep 20, 2019 at 09:52:11AM +0800, Yang Xu wrote:
> > 
> > 
> > on 2019/09/19 23:00, Zorro Lang wrote:
> > > xfs/030 always fails after d0e484ac699f ("check: wipe scratch devices
> > > between tests") get merged.
> > > 
> > > Due to xfs/030 does a sized(100m) mkfs. Before we merge above commit,
> > > mkfs.xfs detects an old primary superblock, it will write zeroes to
> > > all superblocks before formatting the new filesystem. But this won't
> > > be done if we wipe the first superblock(by merging above commit).
> > > 
> > > That means if we make a (smaller) sized xfs after wipefs, those *old*
> > > superblocks which created by last time mkfs.xfs will be left on disk.
> > > Then when we do xfs_repair, if xfs_repair can't find the first SB, it
> > > will go to find those *old* SB at first. When it finds them,
> > > everyting goes wrong.
> > > 
> > > So I try to get XFS AG geometry(by default) and then try to erase all
> > > superblocks. Thanks Darrick J. Wong helped to analyze this issue.
> > Feel free to add Reported-by.
> > > 
> > > Signed-off-by: Zorro Lang <zlang@redhat.com>
> > > ---
> > >   common/rc  |  4 ++++
> > >   common/xfs | 23 +++++++++++++++++++++++
> > >   2 files changed, 27 insertions(+)
> > > 
> > > diff --git a/common/rc b/common/rc
> > > index 66c7fd4d..fe13f659 100644
> > > --- a/common/rc
> > > +++ b/common/rc
> > > @@ -4048,6 +4048,10 @@ _try_wipe_scratch_devs()
> > >   	for dev in $SCRATCH_DEV_POOL $SCRATCH_DEV $SCRATCH_LOGDEV $SCRATCH_RTDEV; do
> > >   		test -b $dev && $WIPEFS_PROG -a $dev
> > >   	done
> > > +
> > > +	if [ "$FSTYP" = "xfs" ];then
> > > +		try_wipe_scratch_xfs
> > I think we should add a simple comment for why we add it.
> > 
> > ps:_scratch_mkfs_xfs also can make case pass. We can use it and add comment.
> > the  try_wipe_scratch_xfs method and the _scratch_mkfs_xfs method are all
> > acceptable for me.
> 
> Yes, I suppose formatting and then wiping per below would also achieve
> our means, but it would come at the extra cost of zeroing the log.  I'm
> not too eager to increase xfstest runtime even more.
> 
> Hmmm, I wonder if xfs_db could just grow a 'wipe all superblocks'
> command....

Haha, I was thinking about that too, and I tried this:
--
agc=`_scratch_xfs_get_sb_field agcount`
wipe_xfs_cmd="$XFS_DB_PROG -x"
for ((i=0; i<agc; i++)); do
	wipe_xfs_cmd="$wipe_xfs_cmd -c \"sb $i\" -c \"write -c magicnum 0x00000000\""
done
wipe_xfs_cmd="$wipe_xfs_cmd $SCRATCH_DEV"
eval $wipe_xfs_cmd
--

The only one problem about this, I think it's the max length of bash command:)

Thanks,
Zorro

> 
> --D
> 
> > > +	fi
> > >   }
> > >   # Only run this on xfs if xfs_scrub is available and has the unicode checker
> > > diff --git a/common/xfs b/common/xfs
> > > index 1bce3c18..34516f82 100644
> > > --- a/common/xfs
> > > +++ b/common/xfs
> > > @@ -884,3 +884,26 @@ _xfs_mount_agcount()
> > >   {
> > >   	$XFS_INFO_PROG "$1" | grep agcount= | sed -e 's/^.*agcount=\([0-9]*\),.*$/\1/g'
> > >   }
> > > +
> > > +# wipe the superblock of each XFS AGs
> > > +try_wipe_scratch_xfs()
> > > +{
> > > +	local tmp=`mktemp -u`
> > > +
> > > +	_scratch_mkfs_xfs -N 2>/dev/null | perl -ne '
> > > +		if (/^meta-data=.*\s+agcount=(\d+), agsize=(\d+) blks/) {
> > > +			print STDOUT "agcount=$1\nagsize=$2\n";
> > > +		}
> > > +		if (/^data\s+=\s+bsize=(\d+)\s/) {
> > > +			print STDOUT "dbsize=$1\n";
> > > +		}' > $tmp.mkfs
> > > +
> > > +	. $tmp.mkfs
> > > +	if [ -n "$agcount" -a -n "$agsize" -a -n "$dbsize" ];then
> > > +		for ((i = 0; i < agcount; i++)); do
> > > +			$XFS_IO_PROG -c "pwrite $((i * dbsize * agsize)) $dbsize" \
> > > +				$SCRATCH_DEV >/dev/null;
> > > +		done
> > > +       fi
> > > +       rm -f $tmp.mkfs
> > > +}
> > > 
> > 
> > 
