Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97FE32CF54A
	for <lists+linux-xfs@lfdr.de>; Fri,  4 Dec 2020 21:09:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730545AbgLDUIb (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 4 Dec 2020 15:08:31 -0500
Received: from sandeen.net ([63.231.237.45]:38872 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728623AbgLDUIa (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 4 Dec 2020 15:08:30 -0500
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id E61F8335020;
        Fri,  4 Dec 2020 14:07:29 -0600 (CST)
To:     Brian Foster <bfoster@redhat.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <160679383892.447856.12907477074923729733.stgit@magnolia>
 <160679385127.447856.3129099457617444604.stgit@magnolia>
 <20201201161812.GD1205666@bfoster>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 2/3] xfs: define a new "needrepair" feature
Message-ID: <2a5ce5a2-9df4-5c19-13d3-f0a16d8030ba@sandeen.net>
Date:   Fri, 4 Dec 2020 14:07:49 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201201161812.GD1205666@bfoster>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 12/1/20 10:18 AM, Brian Foster wrote:
> On Mon, Nov 30, 2020 at 07:37:31PM -0800, Darrick J. Wong wrote:
>> From: Darrick J. Wong <darrick.wong@oracle.com>
>>
>> Define an incompat feature flag to indicate that the filesystem needs to
>> be repaired.  While libxfs will recognize this feature, the kernel will
>> refuse to mount if the feature flag is set, and only xfs_repair will be
>> able to clear the flag.  The goal here is to force the admin to run
>> xfs_repair to completion after upgrading the filesystem, or if we
>> otherwise detect anomalies.
>>
>> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
>> ---
> IIUC, we're using an incompat bit to intentionally ensure the filesystem
> cannot mount, even on kernels that predate this particular "needs
> repair" feature. The only difference is that an older kernel would
> complain about an unknown feature and return a different error code.
> Right?
> 
> That seems reasonable, but out of curiousity is there a need/reason for
> using an incompat bit over an ro_compat bit?

I'm a fan of a straight-up incompat, because we don't really know what
format changes in the future might require this flag to be set; nothing
guarantees that future changes will be ro-compat-safe, right?

-Eric
