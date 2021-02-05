Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09A9931042D
	for <lists+linux-xfs@lfdr.de>; Fri,  5 Feb 2021 05:51:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230163AbhBEEuV (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 4 Feb 2021 23:50:21 -0500
Received: from sandeen.net ([63.231.237.45]:47540 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229852AbhBEEuU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 4 Feb 2021 23:50:20 -0500
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 17657483503;
        Thu,  4 Feb 2021 22:47:30 -0600 (CST)
Subject: Re: [PATCH 1/3] debian: Drop unused dh-python from Build-Depends
To:     "Darrick J. Wong" <djwong@kernel.org>,
        Bastian Germann <bastiangermann@fishpost.de>
Cc:     linux-xfs@vger.kernel.org, Helmut Grohne <helmut@subdivi.de>
References: <20210205003125.24463-1-bastiangermann@fishpost.de>
 <20210205003125.24463-2-bastiangermann@fishpost.de>
 <20210205005100.GK7193@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Message-ID: <98d08567-8584-3730-a680-a1481347ce63@sandeen.net>
Date:   Thu, 4 Feb 2021 22:49:38 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210205005100.GK7193@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2/4/21 6:51 PM, Darrick J. Wong wrote:
> On Fri, Feb 05, 2021 at 01:31:23AM +0100, Bastian Germann wrote:
>> xfsprogs participates in dependency loops relevant to architecture
>> bootstrap. Identifying easily droppable dependencies, it was found
>> that xfsprogs does not use dh-python in any way.
> 
> scrub/xfs_scrub_all.in and tools/xfsbuflock.py are the only python
> scripts in xfsprogs.  We ship the first one as-is in the xfsprogs
> package and we don't ship the second one at all (it's a debugger tool).
> 
> AFAICT neither of them really use dh-python, right?

right, hence the dependency drop, so I think you're in violent agreement
and as one of our resident debian-heads you could RVB this one too,
Darrick? ;)

-Eric
