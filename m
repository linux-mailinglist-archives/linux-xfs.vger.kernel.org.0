Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEDC9287CC3
	for <lists+linux-xfs@lfdr.de>; Thu,  8 Oct 2020 22:02:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729811AbgJHUCJ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 8 Oct 2020 16:02:09 -0400
Received: from sandeen.net ([63.231.237.45]:47128 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725912AbgJHUCJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 8 Oct 2020 16:02:09 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id B239714427;
        Thu,  8 Oct 2020 15:01:07 -0500 (CDT)
To:     Ian Kent <raven@themaw.net>, xfs <linux-xfs@vger.kernel.org>
References: <160151439137.66595.8436234885474855194.stgit@mickey.themaw.net>
 <974aaec3-17e4-ecc0-2220-f34ce19348c8@sandeen.net>
 <200b30f514e30ecaebb754efb8a8ea5cb4d38fd3.camel@themaw.net>
 <f2dbe235ba34db4568e93c87edcd529a606e20ce.camel@themaw.net>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH] xfsprogs: ignore autofs mount table entries
Message-ID: <d4bb3e43-5ccf-8849-8b56-effc759d1f26@sandeen.net>
Date:   Thu, 8 Oct 2020 15:02:08 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <f2dbe235ba34db4568e93c87edcd529a606e20ce.camel@themaw.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 10/1/20 11:40 PM, Ian Kent wrote:
> On Fri, 2020-10-02 at 10:27 +0800, Ian Kent wrote:
>> On Thu, 2020-10-01 at 16:22 -0500, Eric Sandeen wrote:
> 
> snip ...
> 
>>>
>>> Backing up a bit, which xfsprogs utility saw this behavior with
>>> autofs mounts?
>>
>> IIRC the problem I saw ended up being with xfs_spaceman invoked
>> via udisksd on mount/umount activity. There may be other cases so
>> I'd rather not assume there won't be problems elsewhere but those
>> checks for an xfs fs that I didn't notice probably need to change.
> 
> Looking around further, there may be another assumption that's
> not right.
> 
> It looks like xfs_info is being called via udisksd -> libblockdev
> and the xfd_open() triggers the mount not a statfs() call as thought.
> 
> I can't see why I saw xfs_spaceman hanging around longer than I
> thought it should so I probably don't have the full story.

probably because recent xfs_info is a shell script that calls spaceman?

Tho I wonder what udisksd/libblockdev is doing with xfs_info info ...

*shrug*

-Eric

