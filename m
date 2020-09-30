Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EDE227EE1A
	for <lists+linux-xfs@lfdr.de>; Wed, 30 Sep 2020 18:00:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725385AbgI3QAl (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 30 Sep 2020 12:00:41 -0400
Received: from sandeen.net ([63.231.237.45]:53870 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725355AbgI3QAl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 30 Sep 2020 12:00:41 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 649CB14A11;
        Wed, 30 Sep 2020 10:59:53 -0500 (CDT)
Subject: Re: [PATCH] xfs_repair: be more helpful if rtdev is not specified for
 rt subvol
To:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
References: <ee05a000-4c9d-ad5d-66d0-48655cb69e95@redhat.com>
 <20200930155945.GM49547@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Message-ID: <2b620072-ecf6-549a-c9e0-1dfff7150b6a@sandeen.net>
Date:   Wed, 30 Sep 2020 11:00:40 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20200930155945.GM49547@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 9/30/20 10:59 AM, Darrick J. Wong wrote:
> On Wed, Sep 30, 2020 at 10:54:42AM -0500, Eric Sandeen wrote:
>> Today, if one tries to repair a filesystem with a realtime subvol but
>> forgets to specify the rtdev on the command line, the result sounds dire:
>>
>> Phase 1 - find and verify superblock...
>> xfs_repair: filesystem has a realtime subvolume
>> xfs_repair: realtime device init failed
>> xfs_repair: cannot repair this filesystem.  Sorry.
>>
>> We can be a bit more helpful, following the log device example:
>>
>> Phase 1 - find and verify superblock...
>> This filesystem has a realtime subvolume.  Specify rt device with the -r option.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
>> diff --git a/libxfs/init.c b/libxfs/init.c
>> index cb8967bc..65cc3d4c 100644
>> --- a/libxfs/init.c
>> +++ b/libxfs/init.c
>> @@ -429,9 +429,9 @@ rtmount_init(
>>  	if (sbp->sb_rblocks == 0)
>>  		return 0;
>>  	if (mp->m_rtdev_targp->dev == 0 && !(flags & LIBXFS_MOUNT_DEBUGGER)) {
>> -		fprintf(stderr, _("%s: filesystem has a realtime subvolume\n"),
>> -			progname);
>> -		return -1;
>> +		fprintf(stderr, _("This filesystem has a realtime subvolume.  "
>> +			   "Specify rt device with the -r option.\n"));
> 
> _("%s: realtime subvolume must be specified.\n")?

except if we were called by xfs_copy, it can't handle it at all.

I'll need to move this to repair-specific code.

> --D
> 
>> +		exit(1);
>>  	}
>>  	mp->m_rsumlevels = sbp->sb_rextslog + 1;
>>  	mp->m_rsumsize =
>>
> 
