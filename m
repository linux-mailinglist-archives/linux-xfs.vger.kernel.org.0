Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D78E329437B
	for <lists+linux-xfs@lfdr.de>; Tue, 20 Oct 2020 21:49:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438344AbgJTTtL (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 20 Oct 2020 15:49:11 -0400
Received: from sandeen.net ([63.231.237.45]:54530 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438320AbgJTTtL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 20 Oct 2020 15:49:11 -0400
Received: from liberator.local (unknown [10.0.1.163])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 6BC723248;
        Tue, 20 Oct 2020 14:49:09 -0500 (CDT)
Subject: Re: [PATCH] Polish translation update for xfsprogs 5.8.0
To:     Jakub Bogusz <qboosh@pld-linux.org>
Cc:     linux-xfs@vger.kernel.org
References: <20200905162726.GA32628@stranger.qboosh.pl>
 <d00997e1-c609-4692-8959-c8887a944a67@sandeen.net>
 <20201020194616.GA16307@mail>
From:   Eric Sandeen <sandeen@sandeen.net>
Message-ID: <6e0e5aaf-7007-f3e2-919e-b6e03c425582@sandeen.net>
Date:   Tue, 20 Oct 2020 14:49:09 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201020194616.GA16307@mail>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 10/20/20 2:46 PM, Jakub Bogusz wrote:
> On Tue, Oct 20, 2020 at 10:53:31AM -0500, Eric Sandeen wrote:
>> On 9/5/20 11:27 AM, Jakub Bogusz wrote:
>>> Hello,
>>>
>>> I prepared an update of Polish translation of xfsprogs 5.8.0.
>>> Because of size (whole file is ~551kB, diff is ~837kB),
>>> I'm sending just diff header to the list and whole file is available
>>> to download at:
>>> http://qboosh.pl/pl.po/xfsprogs-5.8.0.pl.po
>>> (sha256: 2f0946989b9ba885aa3d3d2b28c5568ce0463a5888b06cfa3f750dc925ceef01)
>>>
>>> Whole diff is available at:
>>> http://qboosh.pl/pl.po/xfsprogs-5.8.0-pl.po-update.patch
>>> (sha256: 355a68fcb9cd7b02b762becabdb100b9498ec8a0147efd5976dc9e743190b050)
>>>
>>> Please update.
>>
>> Jakub - thank you for this!
>>
>> I apologize for somehow missing it.  I can do my best to pull it in for upcoming 5.10,
>> or would you like to rebase it?
>>
>> One thing to note is that as of 5.9.0, xfs messages from libxfs/* should have been
>> added to the message catalog.
> 
> I updated translations for 5.9.0 (which seems to match current git master, if
> I see correctly).

Yep.  Thanks!  I will make it a point to merge this early in 5.10.

-Eric
