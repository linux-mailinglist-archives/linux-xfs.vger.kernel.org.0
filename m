Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4828D2F043E
	for <lists+linux-xfs@lfdr.de>; Sun, 10 Jan 2021 00:07:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726262AbhAIXGq (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sat, 9 Jan 2021 18:06:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726254AbhAIXGq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 Jan 2021 18:06:46 -0500
Received: from buxtehude.debian.org (buxtehude.debian.org [IPv6:2607:f8f0:614:1::1274:39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B108DC061786
        for <linux-xfs@vger.kernel.org>; Sat,  9 Jan 2021 15:06:05 -0800 (PST)
Received: from debbugs by buxtehude.debian.org with local (Exim 4.92)
        (envelope-from <debbugs@buxtehude.debian.org>)
        id 1kyNJ5-000721-58; Sat, 09 Jan 2021 23:06:03 +0000
X-Loop: owner@bugs.debian.org
Subject: Bug#979653: xfsprogs: Incomplete debian/copyright
Reply-To: Eric Sandeen <sandeen@sandeen.net>, 979653@bugs.debian.org
X-Loop: owner@bugs.debian.org
X-Debian-PR-Message: followup 979653
X-Debian-PR-Package: src:xfsprogs
X-Debian-PR-Keywords: 
References: <90d12c70-6679-85aa-b835-e2db9d1eb441@fishpost.de> <90d12c70-6679-85aa-b835-e2db9d1eb441@fishpost.de> <90d12c70-6679-85aa-b835-e2db9d1eb441@fishpost.de> <59b797fa-21b2-b733-88b2-81735bc7d2f5@fishpost.de> <90d12c70-6679-85aa-b835-e2db9d1eb441@fishpost.de>
X-Debian-PR-Source: xfsprogs
Received: via spool by 979653-submit@bugs.debian.org id=B979653.161023336525360
          (code B ref 979653); Sat, 09 Jan 2021 23:06:01 +0000
Received: (at 979653) by bugs.debian.org; 9 Jan 2021 23:02:45 +0000
X-Spam-Checker-Version: SpamAssassin 3.4.2-bugs.debian.org_2005_01_02
        (2018-09-13) on buxtehude.debian.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=4.0 tests=BAYES_00,HAS_BUG_NUMBER,
        NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.2-bugs.debian.org_2005_01_02
X-Spam-Bayes: score:0.0000 Tokens: new, 35; hammy, 131; neutral, 49; spammy,
        3. spammytokens:0.938-+--LLC, 0.907-+--individuals, 0.857-+--llc
        hammytokens:0.000-+--H*u:78.0, 0.000-+--H*u:78.6.0,
        0.000-+--H*UA:78.6.0, 0.000-+--Germann, 0.000-+--germann
Received: from sandeen.net ([63.231.237.45]:52064)
        by buxtehude.debian.org with esmtp (Exim 4.92)
        (envelope-from <sandeen@sandeen.net>)
        id 1kyNFt-0006ar-FL
        for 979653@bugs.debian.org; Sat, 09 Jan 2021 23:02:45 +0000
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id A83833325EB;
        Sat,  9 Jan 2021 16:51:39 -0600 (CST)
To:     Bastian Germann <bastiangermann@fishpost.de>,
        979653@bugs.debian.org
From:   Eric Sandeen <sandeen@sandeen.net>
Message-ID: <a7a0a016-c031-4532-1292-ad12d16415cf@sandeen.net>
Date:   Sat, 9 Jan 2021 16:53:08 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <59b797fa-21b2-b733-88b2-81735bc7d2f5@fishpost.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Greylist: delayed 574 seconds by postgrey-1.36 at buxtehude; Sat, 09 Jan 2021 23:02:45 UTC
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 1/9/21 2:42 PM, Bastian Germann wrote:
> On Sat, 9 Jan 2021 19:31:50 +0100 Bastian Germann <bastiangermann@fishpost.de> wrote:
>> xfsprogs' debian/copyright only mentions Silicon Graphics, Inc.'s copyright. There are other copyright holders, e.g. Oracle, Red Hat, Google LLC, and several individuals. Please provide a complete copyright file and convert it to the machine-readable format.
> 
> Please find a copyright file enclosed.

Hi Bastian -

I'll take an update to this file, but what are the /minimum/ requirements
per Debian policy?

Tracking everything by file+name(s)+year seems rather pointless - it's all
present in the accompanying source, and keeping it up to date at this
granularity seems like make-work doomed to be perpetually out of sync.

I'd prefer to populate it with the minimum required information in
order to minimize churn and maximize ongoing correctness if possible.

Thanks,
-Eric
