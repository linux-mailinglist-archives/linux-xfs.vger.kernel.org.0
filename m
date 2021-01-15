Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55F8A2F8489
	for <lists+linux-xfs@lfdr.de>; Fri, 15 Jan 2021 19:36:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726136AbhAOSgT (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 15 Jan 2021 13:36:19 -0500
Received: from sandeen.net ([63.231.237.45]:59562 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725946AbhAOSgT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 15 Jan 2021 13:36:19 -0500
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 18766483503;
        Fri, 15 Jan 2021 12:34:00 -0600 (CST)
Subject: Re: [PATCH 0/6] debian: xfsprogs package clean-up
To:     nathans@redhat.com, "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Bastian Germann <bastiangermann@fishpost.de>
Cc:     xfs <linux-xfs@vger.kernel.org>
References: <20210114183747.2507-1-bastiangermann@fishpost.de>
 <CAFMei7Pg2b1vs7WkV=JEUA_sZQ_8bedCaDcc+=eur-EaEwF7=w@mail.gmail.com>
From:   Eric Sandeen <sandeen@sandeen.net>
Message-ID: <dd74a5e9-c0e9-96f0-740a-0b4ade685b2f@sandeen.net>
Date:   Fri, 15 Jan 2021 12:35:38 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <CAFMei7Pg2b1vs7WkV=JEUA_sZQ_8bedCaDcc+=eur-EaEwF7=w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 1/14/21 9:40 PM, Nathan Scott wrote:
> Heya,
> 
> On Fri, Jan 15, 2021 at 5:39 AM Bastian Germann
> <bastiangermann@fishpost.de> wrote:
>>
>> Apply some minor changes to the xfsprogs debian packages, including
>> missing copyright notices that are required by Debian Policy.
>>
>> Bastian Germann (6):
>>   debian: cryptographically verify upstream tarball
>>   debian: remove dependency on essential util-linux
>>   debian: remove "Priority: extra"
>>   debian: use Package-Type over its predecessor
>>   debian: add missing copyright info
>>   debian: new changelog entry
> 
> Having reviewed each of these, please add for each:
> 
> Signed-off-by: Nathan Scott <nathans@debian.org>

Do you maybe mean Reviewed-by: ?

-Eric
