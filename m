Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B13351F8F9
	for <lists+linux-xfs@lfdr.de>; Wed, 15 May 2019 18:51:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727069AbfEOQvi (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 15 May 2019 12:51:38 -0400
Received: from sandeen.net ([63.231.237.45]:59776 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726325AbfEOQvi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 May 2019 12:51:38 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 5144C1170D;
        Wed, 15 May 2019 11:51:20 -0500 (CDT)
Subject: Re: [PATCH] xfs_db: add extent count and file size histograms
To:     Jorge Guerra <jorge.guerra@gmail.com>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org,
        Omar Sandoval <osandov@osandov.com>,
        Jorge Guerra <jorgeguerra@fb.com>
References: <20190514185026.73788-1-jorgeguerra@gmail.com>
 <20190514233119.GS29573@dread.disaster.area>
 <CAEFkGAxFuh5qLrfSTreVLHGaaP9VtxTbfeePEwq2iqm0OLamxA@mail.gmail.com>
 <731994db-9f24-a3a8-02a9-eb92535b93f5@sandeen.net>
 <CAEFkGAwdx6DC1YS_NaChYqz0Zp1+GxtrgpcQ262eLgYfX5U35w@mail.gmail.com>
From:   Eric Sandeen <sandeen@sandeen.net>
Openpgp: preference=signencrypt
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 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 pA==
Message-ID: <cd58e171-8b41-38c2-3ed9-639db82c080a@sandeen.net>
Date:   Wed, 15 May 2019 11:51:37 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <CAEFkGAwdx6DC1YS_NaChYqz0Zp1+GxtrgpcQ262eLgYfX5U35w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 5/15/19 11:47 AM, Jorge Guerra wrote:
> On Wed, May 15, 2019 at 9:24 AM Eric Sandeen <sandeen@sandeen.net> wrote:
>>>> For example, xfs_db is not the right tool for probing online, active
>>>> filesystems. It is not coherent with the active kernel filesystem,
>>>> and is quite capable of walking off into la-la land as a result of
>>>> mis-parsing the inconsistent filesystem that is on disk underneath
>>>> active mounted filesystems. This does not make for a robust, usable
>>>> tool, let alone one that can make use of things like rmap for
>>>> querying usage and ownership information really quickly.
>>>
>>> I see your point, that the FS is constantly changing and that we might
>>> see an inconsistent view.  But if we are generating bucketed
>>> histograms we are anyways approximating the stats.
>>
>> I think that Dave's "inconsistency" concern is literal - if the on-disk
>> metadata is not consistent, you may wander into what looks like corruption
>> if you try to traverse every inode while mounted.
>>
>> It's pretty much never valid for userspace to try to traverse or read
>> the filesystem while mounted.
> 
> Sure, I understand this point.  Then can we:
> 
> 1) Abort scan if the we detect "corrupt" metadata, the user would then
> either restart the scan or decide not to.
> 2) Have a mechanism which detects if the FS changed will scan was in
> progress and tell the user the results might be stale?

none of that should be shoehorned into xfs_db, tbh.  It's fine to use it
while unmounted.  If you want to gather these stats on a mounted filesystem,
xfs_db is the wrong tool for the job.  It's an offline inspection tool.
The fact that "-r" exists is because developers may need
it, but normal admin-facing tools should not be designed around it.

>>
>>>> To solve this problem, we now have the xfs_spaceman tool and the
>>>> GETFSMAP ioctl for running usage queries on mounted filesystems.
>>>> That avoids all the coherency and crash problems, and for rmap
>>>> enabled filesystems it does not require scanning the entire
>>>> filesystem to work out this information (i.e. it can all be derived
>>>> from the contents of the rmap tree).
>>>>
>>>> So I'd much prefer that new online filesystem queries go into
>>>> xfs-spaceman and use GETFSMAP so they can be accelerated on rmap
>>>> configured filesystems rather than hoping xfs_db will parse the
>>>> entire mounted filesystem correctly while it is being actively
>>>> changed...
>>>
>>> Good to know, I wasn't aware of this tool.  However I seems like I
>>> don't have that ioctl in my systems yet :(
>>
>> It was added in 2017, in kernel-4.12 I believe.
>> What kernel did you test?
> 
> Yeap, that's it we tested in 4.11.

Catch up!  *grin*

-Eric
