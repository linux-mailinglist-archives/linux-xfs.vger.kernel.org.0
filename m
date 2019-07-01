Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 880004EEEE
	for <lists+linux-xfs@lfdr.de>; Fri, 21 Jun 2019 20:51:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726220AbfFUSvh (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 21 Jun 2019 14:51:37 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:60190 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726017AbfFUSvg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jun 2019 14:51:36 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5LId7UE045981;
        Fri, 21 Jun 2019 18:51:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=4BDYGxnVu22b+Nm87uKnrrO7aOPYKtuiAjWtKpGFpHs=;
 b=hStlTHtfqODXywT3ivhey6e1qIl4UB6OEHf9p7vUOaEnOSKljkb5jd7bjYHyG1BpyJFP
 IGFupbQlyHcY2SjOjanmLYotOaczc2uZh+qYaTo/G4SNZn2O8YYEcq+gpyM6S+YhoUDY
 18zJiylqKOxfz7QDXLHQ0tFJHYUoo7n8Begu00C1ayGKlyueHOC7A219atUuqWEDTNXd
 Z//l1U6R5RYEsz2jOrLcgn86qWB1I0VR1Rhwwz65Aovrckx+Ep1W5M0TvHNf3TzmQ/ZK
 cj7M03KEIaZv+wSGAUyfrtrpbXeDKqM5TA90eAsDQzMf3K9BiTiZagIz3pOR3UXU17hh 0Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2t7809qycj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jun 2019 18:51:34 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5LIpFkO101953;
        Fri, 21 Jun 2019 18:51:33 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2t77ypbnax-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jun 2019 18:51:33 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5LIpW6P010747;
        Fri, 21 Jun 2019 18:51:32 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 21 Jun 2019 11:51:32 -0700
Date:   Fri, 21 Jun 2019 11:51:30 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     Eryu Guan <guaneryu@gmail.com>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs/016: calculate minimum log size and end locations
Message-ID: <20190621185130.GB5380@magnolia>
References: <156089201978.345809.17444450351199726553.stgit@magnolia>
 <156089204146.345809.516891823391869532.stgit@magnolia>
 <20190621091851.GI15846@desktop>
 <fa6036a0-cc9d-7485-5636-8702a6fd1019@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fa6036a0-cc9d-7485-5636-8702a6fd1019@oracle.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9295 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906210142
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9295 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906210142
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 21, 2019 at 09:24:05AM -0700, Allison Collins wrote:
> 
> 
> On 6/21/19 2:18 AM, Eryu Guan wrote:
> > On Tue, Jun 18, 2019 at 02:07:21PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > xfs/016 looks for corruption in the log when the log wraps.  However,
> > > it hardcodes the minimum log size and the "95%" point where it wants to
> > > start the "nudge and check for corruption" part of the test.  New
> > > features require larger logs, which causes the test to fail when it
> > > can't mkfs with the smaller log size and when that 95% point doesn't put
> > > us within 20x "_log_traffic 2"s of the end of the log.
> > > 
> > > Fix the first problem by using the new min log size helper and replace
> > > the 95% figure with an estimate of where we need to be to guarantee that
> > > the 20x loop wraps the log.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Call for reviews from other XFS folks :)
> > 
> > Thanks!
> > 
> > Eryu
> > 
> > > ---
> > >   tests/xfs/016     |   50 ++++++++++++++++++++++++++++++++++++++------------
> > >   tests/xfs/016.out |    1 +
> > >   2 files changed, 39 insertions(+), 12 deletions(-)
> > > 
> > > 
> > > diff --git a/tests/xfs/016 b/tests/xfs/016
> > > index 3407a4b1..aed37dca 100755
> > > --- a/tests/xfs/016
> > > +++ b/tests/xfs/016
> > > @@ -44,10 +44,21 @@ _block_filter()
> > >   _init()
> > >   {
> > > +    echo "*** determine log size"
> > > +    local sz_mb=50
> > > +    local dsize="-d size=${sz_mb}m"
> > > +    local lsize="-l size=$(_scratch_find_xfs_min_logblocks $dsize)b"
> > > +    local force_opts="$dsize $lsize"
> > > +    _scratch_mkfs_xfs $force_opts >> $seqres.full 2>&1
> > > +
> > > +    # set log_size and log_size_bb globally
> > > +    log_size_bb=`_log_size`
> > > +    log_size=$((log_size_bb * 512))
> > > +    echo "log_size_bb = $log_size_bb log_size = $log_size" >> $seqres.full
> > > +
> > >       echo "*** reset partition"
> > > -    $here/src/devzero -b 2048 -n 50 -v 198 $SCRATCH_DEV
> > > +    $here/src/devzero -b 2048 -n $sz_mb -v 198 $SCRATCH_DEV # write 0xc6
> > >       echo "*** mkfs"
> > > -    force_opts="-dsize=50m -lsize=$log_size"
> > >       #
> > >       # Do not discard blocks as we check for patterns in free space.
> > >       #
> > > @@ -65,6 +76,9 @@ _init()
> > >       . $tmp.mkfs
> > >       [ $logsunit -ne 0 ] && \
> > >           _notrun "Cannot run this test using log MKFS_OPTIONS specified"
> > > +
> > > +    # quotas generate extra log traffic so force it off
> > > +    _qmount_option noquota
> > >   }
> > >   _log_traffic()
> > > @@ -157,6 +171,7 @@ _check_corrupt()
> > >   # get standard environment, filters and checks
> > >   . ./common/rc
> > >   . ./common/filter
> > > +. ./common/quota
> > >   # real QA test starts here
> > >   _supported_fs xfs
> > > @@ -164,10 +179,6 @@ _supported_os Linux
> > >   rm -f $seqres.full
> > > -# mkfs sizes
> > > -log_size=3493888
> > > -log_size_bb=`expr $log_size / 512`
> > > -
> > >   _require_scratch
> > >   _init
> > > @@ -188,18 +199,29 @@ echo "log sunit = $lsunit"			>>$seqres.full
> > >   [ $head -eq 2 -o $head -eq $((lsunit/512)) ] || \
> > >       _fail "!!! unexpected initial log position $head vs. $((lsunit/512))"
> > > -# find how how many blocks per op for 100 ops
> > > +# find how how many blocks per op for 200 ops
> > >   # ignore the fact that it will also include an unmount record etc...
> > >   # this should be small overall
> > >   echo "    lots of traffic for sampling" >>$seqres.full
> > > -sample_size_ops=100
> > > +sample_size_ops=200
> > >   _log_traffic $sample_size_ops
> > >   head1=`_log_head`
> > >   num_blocks=`expr $head1 - $head`
> > >   blocks_per_op=`echo "scale=3; $num_blocks / $sample_size_ops" | bc`
> > > +echo "log position = $head1; old log position: $head" >> $seqres.full
> > >   echo "blocks_per_op = $blocks_per_op" >>$seqres.full
> > > -num_expected_ops=`echo "$log_size_bb / $blocks_per_op" | bc`
> > > +
> > > +# Since this is a log wrapping test, it's critical to push the log head to
> > > +# the point where it will wrap around within twenty rounds of log traffic.
> > > +near_end_min=$(echo "$log_size_bb - (10 * $blocks_per_op / 1)" | bc)
> Is the 1 doing anything here?  It doesn't look like it really effects the
> result.

Yes, it tricks bc into spitting out an integer output because
blocks_per_op is a floating point number:

$ echo "23236 - (10 * 13.67682 / 1)" | bc
23100
$ echo "23236 - (10 * 13.67682)" | bc
23099.23180

(bash loops do not deal well with floating point numbers)

> 
> > > +echo "near_end_min = $near_end_min" >>$seqres.full
> > > +
> > > +# Estimate the number of ops needed to get the log head close to but not past
> > > +# near_end_min.  We'd rather fall short and have to step our way closer to the
> > > +# end than run past the end.
> > > +num_expected_ops=$(( 8 * $(echo "$log_size_bb / $blocks_per_op" | bc) / 10))
> Also I was trying to figure out what the constants the 8 and 10 come from?
> Maybe a few extra variables would clarify.  Thanks!

This test is trying to do a log wrap, so...

1) First we format the fs.

2) Then we do 200 operations to estimate how many log blocks are taken
   up by a single operation.

3) Then calculate how many ops are needed to get the log to 80% full.

4) Do all those ops in one go. ($num_expected_ops)

5) Slowly step our way to the log is ~10 operations shy of wrapping the
   log. ($near_end_min)

6) Then we do 20 more iterations to see what happens when we wrap the
   log.

I'll see about straightening out the comments in this test, though I'm
not the original author of this test.

--D

> 
> Allison
> 
> > >   echo "num_expected_ops = $num_expected_ops" >>$seqres.full
> > > +
> > >   num_expected_to_go=`echo "$num_expected_ops - $sample_size_ops" | bc`
> > >   echo "num_expected_to_go = $num_expected_to_go" >>$seqres.full
> > > @@ -208,13 +230,17 @@ _log_traffic $num_expected_to_go
> > >   head=`_log_head`
> > >   echo "log position = $head"                     >>$seqres.full
> > > -# e.g. 3891
> > > -near_end_min=`echo "0.95 * $log_size_bb" | bc | sed 's/\..*//'`
> > > -echo "near_end_min = $near_end_min" >>$seqres.full
> > > +# If we fell short of near_end_min, step our way towards it.
> > > +while [ $head -lt $near_end_min ]; do
> > > +	echo "    bump traffic from $head towards $near_end_min" >> $seqres.full
> > > +	_log_traffic 10 > /dev/null 2>&1
> > > +	head=$(_log_head)
> > > +done
> > >   [ $head -gt $near_end_min -a $head -lt $log_size_bb ] || \
> > >       _fail "!!! unexpected near end log position $head"
> > > +# Try to wrap the log, checking for corruption with each advance.
> > >   for c in `seq 0 20`
> > >   do
> > >       echo "   little traffic"            >>$seqres.full
> > > diff --git a/tests/xfs/016.out b/tests/xfs/016.out
> > > index f7844cdf..f4c8f88d 100644
> > > --- a/tests/xfs/016.out
> > > +++ b/tests/xfs/016.out
> > > @@ -1,4 +1,5 @@
> > >   QA output created by 016
> > > +*** determine log size
> > >   *** reset partition
> > >   Wrote 51200.00Kb (value 0xc6)
> > >   *** mkfs
> > > 
