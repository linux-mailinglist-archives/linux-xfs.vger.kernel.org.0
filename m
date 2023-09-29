Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0278A7B35D3
	for <lists+linux-xfs@lfdr.de>; Fri, 29 Sep 2023 16:36:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233685AbjI2Ogp (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 29 Sep 2023 10:36:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233930AbjI2Ogc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 29 Sep 2023 10:36:32 -0400
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AD0411722
        for <linux-xfs@vger.kernel.org>; Fri, 29 Sep 2023 07:35:19 -0700 (PDT)
Received: from [10.0.0.71] (liberator.sandeen.net [10.0.0.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 7C70F4872F3;
        Fri, 29 Sep 2023 09:35:18 -0500 (CDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 sandeen.net 7C70F4872F3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net;
        s=default; t=1695998118;
        bh=g+ZA5v/kXk6nIq5L12ZmS8LPLX/T1PyBeGkzKBXRkqc=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=MOELGM6bCkJP2a0dttGByCcgDjDtc+JOYgmZ3V+gOb+9Zz3qel5BeSzozR3uYM4Gd
         /Zd8p2ZdkQevflkyvJY0OxKLKiDW9vZkRoAw1lkhuEGMuSD37oDmUyACISCuQ0mq/D
         8WUwYs8L+eOfJB0dbMT469C0vBsyUkhH08dig0KXvvKYrtuqDVe2yPgqvTQUZw6Y+z
         gaQ5Rm/qwOFdTSkHP3kK8XNhFqjmjvDXofw0508Z3/sAWWnbWxOfJMualkrr5Jkwea
         5WX15RK7n8s4MdOn0YLbI0kVoqAnEuidFBCMyKMalZ7O3YzPa+3Cde4c5f9e7qzric
         UkyY/ndhxE8qg==
Message-ID: <4c985608-39f6-1a6e-ec95-42d7c3581d8d@sandeen.net>
Date:   Fri, 29 Sep 2023 09:35:17 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.1
Subject: Re: [PATCH] xfs: drop experimental warning for FSDAX
To:     Chandan Babu R <chandanbabu@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Shiyang Ruan <ruansy.fnst@fujitsu.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org,
        nvdimm@lists.linux.dev, dan.j.williams@intel.com
References: <20230915063854.1784918-1-ruansy.fnst@fujitsu.com>
 <86167409-aa7f-4db4-8335-3f290d507f14@fujitsu.com>
 <20230926145519.GE11439@frogsfrogsfrogs>
 <ZROC8hEabAGS7orb@dread.disaster.area>
 <20230927014632.GE11456@frogsfrogsfrogs>
 <87fs306zs1.fsf@debian-BULLSEYE-live-builder-AMD64>
 <5c064cbd-13a3-4d55-9881-0a079476d865@fujitsu.com>
 <bc29af15-ae63-407d-8ca0-186c976acce7@fujitsu.com>
 <87y1gs83yq.fsf@debian-BULLSEYE-live-builder-AMD64>
 <20230927083034.90bd6336229dd00af601e0ef@linux-foundation.org>
 <9c3cbc0c-7135-4006-ad4a-2abce0a556b0@fujitsu.com>
 <20230928092052.9775e59262c102dc382513ef@linux-foundation.org>
 <87msx5f4a8.fsf@debian-BULLSEYE-live-builder-AMD64>
Content-Language: en-US
From:   Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <87msx5f4a8.fsf@debian-BULLSEYE-live-builder-AMD64>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 9/29/23 9:17 AM, Chandan Babu R wrote:
> On Thu, Sep 28, 2023 at 09:20:52 AM -0700, Andrew Morton wrote:
>> On Thu, 28 Sep 2023 16:44:00 +0800 Shiyang Ruan <ruansy.fnst@fujitsu.com> wrote:
>>
>>> But please pick the following patch[1] as well, which fixes failures of 
>>> xfs55[0-2] cases.
>>>
>>> [1] 
>>> https://lore.kernel.org/linux-xfs/20230913102942.601271-1-ruansy.fnst@fujitsu.com
>>
>> I guess I can take that xfs patch, as it fixes a DAX patch.  I hope the xfs team
>> are watching.
>>
>> But
>>
>> a) I'm not subscribed to linux-xfs and
>>
>> b) the changelog fails to describe the userspace-visible effects of
>>    the bug, so I (and others) are unable to determine which kernel
>>    versions should be patched.
>>
>> Please update that changelog and resend?
> 
> I will apply "xfs: correct calculation for agend and blockcount" patch to
> xfs-linux Git tree and include it for the next v6.6 pull request to Linus.
> 
> At the outset, It looks like I can pick "mm, pmem, xfs: Introduce
> MF_MEM_PRE_REMOVE for unbind"
> (i.e. https://lore.kernel.org/linux-xfs/20230928103227.250550-1-ruansy.fnst@fujitsu.com/T/#u)
> patch for v6.7 as well. But that will require your Ack. Please let me know
> your opinion.
> 
> Also, I will pick "xfs: drop experimental warning for FSDAX" patch for v6.7.

While I hate to drag it out even longer, it seems slightly optimistic to
drop experimental at the same time as the "last" fix, in case it's not
really the last fix.

But I don't have super strong feelings about it, and I would be happy to
finally see experimental go away. So if those who are more tuned into
the details are comfortable with that 6.7 plan, I'll defer to them on
the question.

Thanks,
-Eric

