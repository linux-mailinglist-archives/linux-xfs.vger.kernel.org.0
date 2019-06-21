Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA0554F01C
	for <lists+linux-xfs@lfdr.de>; Fri, 21 Jun 2019 22:47:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726049AbfFUUrn (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 21 Jun 2019 16:47:43 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:57174 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725985AbfFUUrm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jun 2019 16:47:42 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5LKiGCZ036871;
        Fri, 21 Jun 2019 20:47:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=cB3j3jUO4npHUl1vPHlKp72SNcc6xpZt9epQsAYGIZw=;
 b=ftLyj1RpGGOHxzamT5bB3n4I5+fNmZ/BZMIWYDCA+japXHG0HB0+PQ6PlKVL6nb0f/gM
 iZjTrtbQkK3HP0bQ77MIXnugJdEPSm+TZBEa1qX4uNAN0fw4KtI2+04RaPIIH1SSPJjP
 mL/q6RIsctBg3Zu8GumKNFYzS9PiKn3PvVF3rUf499Ma42GAN57ET/wO7yTMHUju/Z23
 nDDKajyZC4aBMLSP5hXYIKJlO2FKjMoZryoKsU1NNmgxfawzLcCkPSUUCEfomtCyA0/x
 7dPYxs0WBg8b4W9Mz9HWO1Krfm3BWqClccwmvI7dkys/y2iadbGKLEdpugO03LiAtqA/ bg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2t7809ras2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jun 2019 20:47:40 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5LKlGJG154551;
        Fri, 21 Jun 2019 20:47:39 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2t77ypd1f1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jun 2019 20:47:39 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5LKlclx004938;
        Fri, 21 Jun 2019 20:47:38 GMT
Received: from [192.168.1.226] (/70.176.225.12)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 21 Jun 2019 13:47:38 -0700
Subject: Re: [PATCH 3/4] xfs/016: calculate minimum log size and end locations
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Eryu Guan <guaneryu@gmail.com>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
References: <156089201978.345809.17444450351199726553.stgit@magnolia>
 <156089204146.345809.516891823391869532.stgit@magnolia>
 <20190621091851.GI15846@desktop>
 <fa6036a0-cc9d-7485-5636-8702a6fd1019@oracle.com>
 <20190621185130.GB5380@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <0b5898a6-f39c-fb7b-26bd-edb2a66d1f71@oracle.com>
Date:   Fri, 21 Jun 2019 13:47:37 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190621185130.GB5380@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9295 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906210156
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9295 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906210156
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 6/21/19 11:51 AM, Darrick J. Wong wrote:
> On Fri, Jun 21, 2019 at 09:24:05AM -0700, Allison Collins wrote:
>>
>>
>> On 6/21/19 2:18 AM, Eryu Guan wrote:
>>> On Tue, Jun 18, 2019 at 02:07:21PM -0700, Darrick J. Wong wrote:
>>>> From: Darrick J. Wong <darrick.wong@oracle.com>
>>>>
>>>> xfs/016 looks for corruption in the log when the log wraps.  However,
>>>> it hardcodes the minimum log size and the "95%" point where it wants to
>>>> start the "nudge and check for corruption" part of the test.  New
>>>> features require larger logs, which causes the test to fail when it
>>>> can't mkfs with the smaller log size and when that 95% point doesn't put
>>>> us within 20x "_log_traffic 2"s of the end of the log.
>>>>
>>>> Fix the first problem by using the new min log size helper and replace
>>>> the 95% figure with an estimate of where we need to be to guarantee that
>>>> the 20x loop wraps the log.
>>>>
>>>> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
>>>
>>> Call for reviews from other XFS folks :)
>>>
>>> Thanks!
>>>
>>> Eryu
>>>
>>>> ---
>>>>    tests/xfs/016     |   50 ++++++++++++++++++++++++++++++++++++++------------
>>>>    tests/xfs/016.out |    1 +
>>>>    2 files changed, 39 insertions(+), 12 deletions(-)
>>>>
>>>>
>>>> diff --git a/tests/xfs/016 b/tests/xfs/016
>>>> index 3407a4b1..aed37dca 100755
>>>> --- a/tests/xfs/016
>>>> +++ b/tests/xfs/016
>>>> @@ -44,10 +44,21 @@ _block_filter()
>>>>    _init()
>>>>    {
>>>> +    echo "*** determine log size"
>>>> +    local sz_mb=50
>>>> +    local dsize="-d size=${sz_mb}m"
>>>> +    local lsize="-l size=$(_scratch_find_xfs_min_logblocks $dsize)b"
>>>> +    local force_opts="$dsize $lsize"
>>>> +    _scratch_mkfs_xfs $force_opts >> $seqres.full 2>&1
>>>> +
>>>> +    # set log_size and log_size_bb globally
>>>> +    log_size_bb=`_log_size`
>>>> +    log_size=$((log_size_bb * 512))
>>>> +    echo "log_size_bb = $log_size_bb log_size = $log_size" >> $seqres.full
>>>> +
>>>>        echo "*** reset partition"
>>>> -    $here/src/devzero -b 2048 -n 50 -v 198 $SCRATCH_DEV
>>>> +    $here/src/devzero -b 2048 -n $sz_mb -v 198 $SCRATCH_DEV # write 0xc6
>>>>        echo "*** mkfs"
>>>> -    force_opts="-dsize=50m -lsize=$log_size"
>>>>        #
>>>>        # Do not discard blocks as we check for patterns in free space.
>>>>        #
>>>> @@ -65,6 +76,9 @@ _init()
>>>>        . $tmp.mkfs
>>>>        [ $logsunit -ne 0 ] && \
>>>>            _notrun "Cannot run this test using log MKFS_OPTIONS specified"
>>>> +
>>>> +    # quotas generate extra log traffic so force it off
>>>> +    _qmount_option noquota
>>>>    }
>>>>    _log_traffic()
>>>> @@ -157,6 +171,7 @@ _check_corrupt()
>>>>    # get standard environment, filters and checks
>>>>    . ./common/rc
>>>>    . ./common/filter
>>>> +. ./common/quota
>>>>    # real QA test starts here
>>>>    _supported_fs xfs
>>>> @@ -164,10 +179,6 @@ _supported_os Linux
>>>>    rm -f $seqres.full
>>>> -# mkfs sizes
>>>> -log_size=3493888
>>>> -log_size_bb=`expr $log_size / 512`
>>>> -
>>>>    _require_scratch
>>>>    _init
>>>> @@ -188,18 +199,29 @@ echo "log sunit = $lsunit"			>>$seqres.full
>>>>    [ $head -eq 2 -o $head -eq $((lsunit/512)) ] || \
>>>>        _fail "!!! unexpected initial log position $head vs. $((lsunit/512))"
>>>> -# find how how many blocks per op for 100 ops
>>>> +# find how how many blocks per op for 200 ops
>>>>    # ignore the fact that it will also include an unmount record etc...
>>>>    # this should be small overall
>>>>    echo "    lots of traffic for sampling" >>$seqres.full
>>>> -sample_size_ops=100
>>>> +sample_size_ops=200
>>>>    _log_traffic $sample_size_ops
>>>>    head1=`_log_head`
>>>>    num_blocks=`expr $head1 - $head`
>>>>    blocks_per_op=`echo "scale=3; $num_blocks / $sample_size_ops" | bc`
>>>> +echo "log position = $head1; old log position: $head" >> $seqres.full
>>>>    echo "blocks_per_op = $blocks_per_op" >>$seqres.full
>>>> -num_expected_ops=`echo "$log_size_bb / $blocks_per_op" | bc`
>>>> +
>>>> +# Since this is a log wrapping test, it's critical to push the log head to
>>>> +# the point where it will wrap around within twenty rounds of log traffic.
>>>> +near_end_min=$(echo "$log_size_bb - (10 * $blocks_per_op / 1)" | bc)
>> Is the 1 doing anything here?  It doesn't look like it really effects the
>> result.
> 
> Yes, it tricks bc into spitting out an integer output because
> blocks_per_op is a floating point number:
> 
> $ echo "23236 - (10 * 13.67682 / 1)" | bc
> 23100
> $ echo "23236 - (10 * 13.67682)" | bc
> 23099.23180
> 
> (bash loops do not deal well with floating point numbers)
> 
>>
>>>> +echo "near_end_min = $near_end_min" >>$seqres.full
>>>> +
>>>> +# Estimate the number of ops needed to get the log head close to but not past
>>>> +# near_end_min.  We'd rather fall short and have to step our way closer to the
>>>> +# end than run past the end.
>>>> +num_expected_ops=$(( 8 * $(echo "$log_size_bb / $blocks_per_op" | bc) / 10))
>> Also I was trying to figure out what the constants the 8 and 10 come from?
>> Maybe a few extra variables would clarify.  Thanks!
> 
> This test is trying to do a log wrap, so...
> 
> 1) First we format the fs.
> 
> 2) Then we do 200 operations to estimate how many log blocks are taken
>     up by a single operation.
> 
> 3) Then calculate how many ops are needed to get the log to 80% full.
> 
> 4) Do all those ops in one go. ($num_expected_ops)
> 
> 5) Slowly step our way to the log is ~10 operations shy of wrapping the
>     log. ($near_end_min)
> 
> 6) Then we do 20 more iterations to see what happens when we wrap the
>     log.
> 
> I'll see about straightening out the comments in this test, though I'm
> not the original author of this test.
> 
> --D

I see, ok then thanks for the explanation! You can add my review:
Reviewed-by: Allison Collins <allison.henderson@oracle.com>

> 
>>
>> Allison
>>
>>>>    echo "num_expected_ops = $num_expected_ops" >>$seqres.full
>>>> +
>>>>    num_expected_to_go=`echo "$num_expected_ops - $sample_size_ops" | bc`
>>>>    echo "num_expected_to_go = $num_expected_to_go" >>$seqres.full
>>>> @@ -208,13 +230,17 @@ _log_traffic $num_expected_to_go
>>>>    head=`_log_head`
>>>>    echo "log position = $head"                     >>$seqres.full
>>>> -# e.g. 3891
>>>> -near_end_min=`echo "0.95 * $log_size_bb" | bc | sed 's/\..*//'`
>>>> -echo "near_end_min = $near_end_min" >>$seqres.full
>>>> +# If we fell short of near_end_min, step our way towards it.
>>>> +while [ $head -lt $near_end_min ]; do
>>>> +	echo "    bump traffic from $head towards $near_end_min" >> $seqres.full
>>>> +	_log_traffic 10 > /dev/null 2>&1
>>>> +	head=$(_log_head)
>>>> +done
>>>>    [ $head -gt $near_end_min -a $head -lt $log_size_bb ] || \
>>>>        _fail "!!! unexpected near end log position $head"
>>>> +# Try to wrap the log, checking for corruption with each advance.
>>>>    for c in `seq 0 20`
>>>>    do
>>>>        echo "   little traffic"            >>$seqres.full
>>>> diff --git a/tests/xfs/016.out b/tests/xfs/016.out
>>>> index f7844cdf..f4c8f88d 100644
>>>> --- a/tests/xfs/016.out
>>>> +++ b/tests/xfs/016.out
>>>> @@ -1,4 +1,5 @@
>>>>    QA output created by 016
>>>> +*** determine log size
>>>>    *** reset partition
>>>>    Wrote 51200.00Kb (value 0xc6)
>>>>    *** mkfs
>>>>
