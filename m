Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13A73520EF
	for <lists+linux-xfs@lfdr.de>; Tue, 25 Jun 2019 05:12:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727043AbfFYDMM (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 24 Jun 2019 23:12:12 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:59174 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726712AbfFYDMM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jun 2019 23:12:12 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5P39W9C003426;
        Tue, 25 Jun 2019 03:11:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=PEhZtHCVs4aboU4VDFNy/o93v30UFpEZ7tbpfz0Xa2E=;
 b=ddKLScTvf70LDIuubFvIJq7Hdd6BtByV9CpeRdWfggNU1c7vFQWnN3Z6IQoa4wIc0xjw
 wFTRaDDgFN0ANoPG7JVKngbOtpItyO8aRmerV5HVSmMqt+SsdlooTND/lC1rh3psZ8DO
 2BJ55yJLAcTNR1VIu2RSqhGtoV9uN6xXGXtWZSNwmq6n/XVnfstYvxqn4IDM4bVpPBXF
 JyiSfFAFZFl8FHMRQhBWZCwWPoaA1mKJRjCODzesuCCW5cNDOkLsuC9FUyVMbp2d5gHw
 13C67PsIuHba8KjYQVmgKIasYVYJkijoJOvlfNCsdo+dcjWNwVhoVeMwTUZF/o8XBJCm RQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2t9cyq9fhs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jun 2019 03:11:51 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5P3AhBo115456;
        Tue, 25 Jun 2019 03:11:50 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2t9p6tx5h8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jun 2019 03:11:50 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5P3Bmh0020856;
        Tue, 25 Jun 2019 03:11:49 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 24 Jun 2019 20:11:48 -0700
Date:   Mon, 24 Jun 2019 20:11:47 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Dave Chinner <david@fromorbit.com>,
        Eric Sandeen <sandeen@redhat.com>,
        linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 2/2] xfs: convert extents in place for ZERO_RANGE
Message-ID: <20190625031147.GD5387@magnolia>
References: <ace9a6b9-3833-ec15-e3df-b9d88985685e@redhat.com>
 <25a2ebbc-0ec9-f5dd-eba0-4101c80837dd@sandeen.net>
 <20190625023954.GF7777@dread.disaster.area>
 <2b135e00-3bfd-f41a-7c43-a0518fc756fe@sandeen.net>
 <20190625030018.GC5387@magnolia>
 <3f8037f0-08ff-98b2-6995-230e7bf33372@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f8037f0-08ff-98b2-6995-230e7bf33372@sandeen.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9298 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906250024
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9298 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906250024
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 24, 2019 at 10:05:51PM -0500, Eric Sandeen wrote:
> On 6/24/19 10:00 PM, Darrick J. Wong wrote:
> > On Mon, Jun 24, 2019 at 09:52:03PM -0500, Eric Sandeen wrote:
> >> On 6/24/19 9:39 PM, Dave Chinner wrote:
> >>> On Mon, Jun 24, 2019 at 07:48:11PM -0500, Eric Sandeen wrote:
> >>>> Rather than completely removing and re-allocating a range
> >>>> during ZERO_RANGE fallocate calls, convert whole blocks in the
> >>>> range using xfs_alloc_file_space(XFS_BMAPI_PREALLOC|XFS_BMAPI_CONVERT)
> >>>> and then zero the edges with xfs_zero_range()
> >>>
> >>> That's what I originally used to implement ZERO_RANGE and that
> >>> had problems with zeroing the partial blocks either side and
> >>> unexpected inode size changes. See commit:
> >>>
> >>> 5d11fb4b9a1d xfs: rework zero range to prevent invalid i_size updates
> >>
> >> Yep I did see that.  It had a lot of hand-rolled partial block stuff
> >> that seems more complex than this, no?  That commit didn't indicate
> >> what the root cause of the failure actually was, AFAICT.
> >>
> >> (funny thought that I skimmed that commit just to see why we had
> >> what we have, but didn't really intentionally re-implement it...
> >> even though I guess I almost did...)
> > 
> > FWIW the complaint I had about the fragmentary behavior really only
> > applied to fun and games when one fallocated an ext4 image and then ran
> > mkfs.ext4 which uses zero range which fragmented the image...
> > 
> >>> I also remember discussion about zero range being inefficient on
> >>> sparse files and fragmented files - the current implementation
> >>> effectively defragments such files, whilst using XFS_BMAPI_CONVERT
> >>> just leaves all the fragments behind.
> >>
> >> That's true - and it fragments unfragmented files.  Is ZERO_RANGE
> >> supposed to be a defragmenter?
> > 
> > ...so please remember, the key point we were talking about when we
> > discussed this a year ago was that if the /entire/ zero range maps to a
> > single extent within eof then maybe we ought to just convert it to
> > unwritten.
> 
> I remember you mentioning that, but honestly it seems like
> overcomplication to say "ZERO_RANGE will also defragment extents
> in the process, if it can..."

Well we could just do what we usually do and not write anything down
anywhere so 2022 Eric can argue with 2022 Dave and 2022 me about WTF
zero range is supposed to do.

Really, zero range doesn't specify the effects on the physical mapping.
All it says is that subsequent reads will return zeroes; that holes
will be filled with preallocations; and that preferably it converts to
unwritten extents.

It's that last part where it seems weird that we'd go out of our way to
punch and reallocate for a simple corner case where we could just
convert.

> > Note also that for pmem there's a slightly different optimization --
> > if the entire range is mapped by written extents (not necessarily
> > contiguous, just no holes/cow/delalloc/unwritten bits) then we can use
> > blkdev_issue_zeroout to zero memory and clear hwpoison cheaply.
> > 
> >>>> (Note that this changes the rounding direction of the
> >>>> xfs_alloc_file_space range, because we only want to hit whole
> >>>> blocks within the range.)
> >>>>
> >>>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> >>>> ---
> >>>>
> >>>> <currently running fsx ad infinitum, so far so good>
> >>
> >> <still running, so far so good (4k blocks)>
> >>
> >>>> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> >>>> index 0a96c4d1718e..eae202bfe134 100644
> >>>> --- a/fs/xfs/xfs_bmap_util.c
> >>>> +++ b/fs/xfs/xfs_bmap_util.c
> >>>> @@ -1164,23 +1164,25 @@ xfs_zero_file_space(
> >>>>  
> >>>>  	blksize = 1 << mp->m_sb.sb_blocklog;
> >>>>  
> >>>> +	error = xfs_flush_unmap_range(ip, offset, len);
> >>>> +	if (error)
> >>>> +		return error;
> >>>>  	/*
> >>>> -	 * Punch a hole and prealloc the range. We use hole punch rather than
> >>>> -	 * unwritten extent conversion for two reasons:
> >>>> -	 *
> >>>> -	 * 1.) Hole punch handles partial block zeroing for us.
> >>>> -	 *
> >>>> -	 * 2.) If prealloc returns ENOSPC, the file range is still zero-valued
> >>>> -	 * by virtue of the hole punch.
> >>>> +	 * Convert whole blocks in the range to unwritten, then call iomap
> >>>> +	 * via xfs_zero_range to zero the range.  iomap will skip holes and
> >>>> +	 * unwritten extents, and just zero the edges if needed.  If conversion
> >>>> +	 * fails, iomap will simply write zeros to the whole range.
> >>>> +	 * nb: always_cow doesn't support unwritten extents.
> >>>>  	 */
> >>>> -	error = xfs_free_file_space(ip, offset, len);
> >>>> -	if (error || xfs_is_always_cow_inode(ip))
> >>>> -		return error;
> >>>> +	if (!xfs_is_always_cow_inode(ip))
> >>>> +		xfs_alloc_file_space(ip, round_up(offset, blksize),
> >>>> +				     round_down(offset + len, blksize) -
> >>>> +				     round_up(offset, blksize),
> >>>> +				     XFS_BMAPI_PREALLOC|XFS_BMAPI_CONVERT);
> >>>
> >>> If this fails with, say, corruption we should abort with an error,
> >>> not ignore it. I think we can only safely ignore ENOSPC and maybe
> >>> EDQUOT here...
> >>
> >> Yes, I suppose so, though if this encounters corruption I'd guess
> >> xfs_zero_range probably would as well but that's just handwaving.
> > 
> > <nod>
> > 
> >>>> -	return xfs_alloc_file_space(ip, round_down(offset, blksize),
> >>>> -				     round_up(offset + len, blksize) -
> >>>> -				     round_down(offset, blksize),
> >>>> -				     XFS_BMAPI_PREALLOC);
> >>>> +	error = xfs_zero_range(ip, offset, len);
> >>>
> >>> What prevents xfs_zero_range() from changing the file size if
> >>> offset + len is beyond EOF and there are allocated extents (from
> >>> delalloc conversion) beyond EOF? (i.e. FALLOC_FL_KEEP_SIZE is set by
> >>> the caller).
> >>
> >> nothing, but AFAIK it does the same today... even w/o extents past
> >> EOF:
> >>
> >> $ xfs_io -f -c "truncate 0" -c "fzero 0 1m" testfile
> > 
> > fzero -k ?
> 
> $ xfs_io -f -c "truncate 0" -c "fzero -k 0 1m" testfile
> 
> $ ls -lh testfile
> -rw-------. 1 sandeen sandeen 0 Jun 24 22:02 testfile
> 
> with or without my patches.
> 
> (with or without it also seems to allocate 1M past EOF...)

ok cool.

--D

> -Eric
> 
