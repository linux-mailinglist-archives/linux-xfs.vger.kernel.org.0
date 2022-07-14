Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C1BF57412D
	for <lists+linux-xfs@lfdr.de>; Thu, 14 Jul 2022 04:03:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231218AbiGNCDN (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 13 Jul 2022 22:03:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbiGNCDM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Jul 2022 22:03:12 -0400
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 30DEB18B36
        for <linux-xfs@vger.kernel.org>; Wed, 13 Jul 2022 19:03:11 -0700 (PDT)
Received: from [10.0.0.146] (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 6C98A4435;
        Wed, 13 Jul 2022 21:02:49 -0500 (CDT)
Message-ID: <43a2bca7-f7ba-05f9-d3ce-135832a0f77b@sandeen.net>
Date:   Wed, 13 Jul 2022 21:03:09 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <165767457703.891854.2108521135190969641.stgit@magnolia>
 <165767459958.891854.15344618102582353193.stgit@magnolia>
 <2a452d57-9e2e-7908-b3f5-0444b6a62761@sandeen.net>
 <Ys94fFgxLGyGb/W4@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 4/4] mkfs: terminate getsubopt arrays properly
In-Reply-To: <Ys94fFgxLGyGb/W4@magnolia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 7/13/22 8:59 PM, Darrick J. Wong wrote:
> On Wed, Jul 13, 2022 at 08:39:24PM -0500, Eric Sandeen wrote:
>> On 7/12/22 8:09 PM, Darrick J. Wong wrote:
>>> From: Darrick J. Wong <djwong@kernel.org>
>>>
>>> Having not drank any (or maybe too much) coffee this morning, I typed:
>>>
>>> $ mkfs.xfs -d agcount=3 -d nrext64=0
>>> Segmentation fault
>>>
>>> I traced this down to getsubopt walking off the end of the dopts.subopts
>>> array.  The manpage says you're supposed to terminate the suboptions
>>
>> (the getsubopt(3) manpage for those following along at home)
>>
>>> string array with a NULL entry, but the structure definition uses
>>> MAX_SUBOPTS/D_MAX_OPTS directly, which means there is no terminator.
>>>
>>> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
>>> ---
>>>  mkfs/xfs_mkfs.c |    2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>>
>>> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
>>> index 61ac1a4a..9a58ff8b 100644
>>> --- a/mkfs/xfs_mkfs.c
>>> +++ b/mkfs/xfs_mkfs.c
>>> @@ -141,7 +141,7 @@ enum {
>>>  };
>>>  
>>>  /* Just define the max options array size manually right now */
>>> -#define MAX_SUBOPTS	D_MAX_OPTS
>>> +#define MAX_SUBOPTS	(D_MAX_OPTS + 1)
>>
>> Hah, I had not noticed this before. So this relies on there being more
>> suboptions for -d than anything else, I guess. What could go wrong?
>>
>> OK, so this fixes it because opt_params is a global, and it contains 
>> subopt_params[MAX_SUBOPTS];, so the last array entry will be null
>> (by virtue of globals being zeroed) and that's all perfectly clear :D
> 
> <nod>
> 
>> Well, it fixes it for now.  I'd like to add i.e.
>>
>> @@ -251,6 +251,7 @@ static struct opt_params bopts = {
>>         .ini_section = "block",
>>         .subopts = {
>>                 [B_SIZE] = "size",
>> +               [B_MAX_OPTS] = NULL,
>>         },
>>
>> etc to each suboption array to be explicit about it, sound ok? I can do
>> that on commit if it seems ok.
> 
> Oh, that /is/ a good idea, in case B_MAX_OPTS > D_MAX_OPTS ever happens.

I, uh, think that in that case, gcc will barf out with something like:

xfs_mkfs.c:311:3: error: array index in initializer exceeds array bounds
   [D_MAX_OPTS] = NULL,
   ^
xfs_mkfs.c:311:3: error: (near initialization for ‘dopts.subopts’)
xfs_mkfs.c:311:3: warning: excess elements in array initializer [enabled by default]
xfs_mkfs.c:311:3: warning: (near initialization for ‘dopts.subopts’) [enabled by default]
cc1: warning: unrecognized command line option "-Wno-address-of-packed-member" [enabled by default]
gmake[2]: *** [xfs_mkfs.o] Error 1
gmake[1]: *** [mkfs] Error 2
make: *** [default] Error 2

(with s/dopts/bopts/ in your case)

-Eric
