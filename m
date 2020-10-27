Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 659CD29C39F
	for <lists+linux-xfs@lfdr.de>; Tue, 27 Oct 2020 18:49:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1822334AbgJ0RtM (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 27 Oct 2020 13:49:12 -0400
Received: from sandeen.net ([63.231.237.45]:50342 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1822328AbgJ0RtK (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 27 Oct 2020 13:49:10 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id CCF21328A00;
        Tue, 27 Oct 2020 12:48:57 -0500 (CDT)
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <160375511371.879169.3659553317719857738.stgit@magnolia>
 <160375511989.879169.8816363379781873320.stgit@magnolia>
 <d59f5cbc-42b0-70f0-5471-210f87bf0fe3@sandeen.net>
 <20201027174026.GA1061252@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 1.5/5] mkfs: clarify valid "inherit" option values
Message-ID: <707758fc-f3a3-de2c-a8ef-81ec4c939b7c@sandeen.net>
Date:   Tue, 27 Oct 2020 12:49:08 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201027174026.GA1061252@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 10/27/20 12:40 PM, Darrick J. Wong wrote:
> On Tue, Oct 27, 2020 at 12:24:29PM -0500, Eric Sandeen wrote:
>> Clarify which values are valid for the various *inherit= mkfs
>> options.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
>> diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
>> index 0a785874..a2be066b 100644
>> --- a/man/man8/mkfs.xfs.8
>> +++ b/man/man8/mkfs.xfs.8
>> @@ -377,21 +377,21 @@ This option disables automatic geometry detection and creates the filesystem
>>  without stripe geometry alignment even if the underlying storage device provides
>>  this information.
>>  .TP
>> -.BI rtinherit= value
>> -If set, all inodes created by
>> +.BI rtinherit= [0|1]
>> +If set to 1, all inodes created by
>>  .B mkfs.xfs
>>  will be created with the realtime flag set.
>>  Directories will pass on this flag to newly created regular files and
>>  directories.
>>  .TP
>> -.BI projinherit= value
>> +.BI projinherit= projid
>>  All inodes created by
>>  .B mkfs.xfs
>>  will be assigned this project quota id.
>>  Directories will pass on the project id to newly created regular files and
>>  directories.
>>  .TP
>> -.BI extszinherit= value
>> +.BI extszinherit= extentsize
> 
> Hmm... if you're going to make this change to extszinherit, you might as
> well do the same for cowextsize.

Well, "inherit=" /sounds/ like a boolean, so I figured that one needed clarification,
whereas "size=" seems pretty clear to me, and is described already?

But perhaps it would be more consistent to keep it all as "=value" and then just
more clearly describe the valid *inherit= values in the explanatory text... let me try
a V2 ;)

> With that fixed,
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> --D
> 
>
