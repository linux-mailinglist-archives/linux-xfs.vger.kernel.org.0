Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84DA1312865
	for <lists+linux-xfs@lfdr.de>; Mon,  8 Feb 2021 00:37:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbhBGXhA (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 7 Feb 2021 18:37:00 -0500
Received: from sandeen.net ([63.231.237.45]:49508 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229611AbhBGXg7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 7 Feb 2021 18:36:59 -0500
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id A888914A07;
        Sun,  7 Feb 2021 17:34:04 -0600 (CST)
From:   Eric Sandeen <sandeen@sandeen.net>
To:     Dave Chinner <david@fromorbit.com>,
        bugzilla-daemon@bugzilla.kernel.org
Cc:     linux-xfs@vger.kernel.org, Pavel Reichl <preichl@redhat.com>
References: <bug-211605-201763@https.bugzilla.kernel.org/>
 <20210207221505.GW4662@dread.disaster.area>
 <e83dce44-6120-e688-fec2-b0109cc6f617@sandeen.net>
Subject: Re: [Bug 211605] New: Re-mount XFS causes "noattr2 mount option is
 deprecated" warning
Message-ID: <8031e859-0889-8053-8348-5ab9a704eafe@sandeen.net>
Date:   Sun, 7 Feb 2021 17:36:17 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <e83dce44-6120-e688-fec2-b0109cc6f617@sandeen.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2/7/21 4:53 PM, Eric Sandeen wrote:
> 
> Pavel, can you fix this up, since your patch did the deprecations? I guess we
> missed this on review.

Scratch that, Dave points out that they need to stay until they are removed.
 
> Ideally the xfs(5) man page in xfsprogs should be updated as well to reflect the
> deprecated items.

man page probably should still be updated tho (unless I missed a patch...)

-Eric
