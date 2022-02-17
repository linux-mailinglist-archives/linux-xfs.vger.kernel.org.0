Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B21714BA3DE
	for <lists+linux-xfs@lfdr.de>; Thu, 17 Feb 2022 15:59:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbiBQO7p (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 17 Feb 2022 09:59:45 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242282AbiBQO7o (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Feb 2022 09:59:44 -0500
Received: from Ishtar.sc.tlinx.org (ishtar.tlinx.org [173.164.175.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AAA329E94E
        for <linux-xfs@vger.kernel.org>; Thu, 17 Feb 2022 06:59:24 -0800 (PST)
Received: from [192.168.3.12] (Athenae [192.168.3.12])
        by Ishtar.sc.tlinx.org (8.14.7/8.14.4/SuSE Linux 0.8) with ESMTP id 21HEwV8r067737;
        Thu, 17 Feb 2022 06:58:33 -0800
Message-ID: <620E62B1.2030801@tlinx.org>
Date:   Thu, 17 Feb 2022 06:58:57 -0800
From:   L A Walsh <xfs@tlinx.org>
User-Agent: Thunderbird
MIME-Version: 1.0
To:     Eric Sandeen <sandeen@sandeen.net>
CC:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [ANNOUNCE] xfsdump 3.1.10 released
References: <f2ce57bd-8558-b7dc-8379-9cf97f07f578@sandeen.net> <62087125.2020704@tlinx.org> <31eec545-8d42-2147-59bf-5eaffaa230d1@sandeen.net>
In-Reply-To: <31eec545-8d42-2147-59bf-5eaffaa230d1@sandeen.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2022/02/14 06:28, Eric Sandeen wrote:
> On 2/12/22 8:47 PM, L A Walsh wrote:
>>
>> On 2022/02/11 12:59, Eric Sandeen wrote:
>>> Hi folks,
>>> because I don't want to stall on getting the fix for the root inode
>>> problems out there any longer. It's been ... quite long enough.
>>>
>>> Next release we can think about the dmapi junk, and possibly the
>>> workaround for the broken dumps with the root inode problem.
>>>
>>> This should at least be generating valid dumps on those filesystems
>>> with "interesting" geometry, again.
>> ----
>>
>> Thanks for the Cc.
>>
>>  As near as I understand your comments, this should generate new dumps that won't
>> have the problem I'm seeing, but will still leave previous dumps in the old format
>> that may show problems upon restoration.
> 
> Correct, I want to spend more time on the workaround to be sure we have confidence
> in it, sorry.
---

	No need to apologize, Fixing the problem in stages is perfectly logical
Even if some existing dumps have inconsistencies in them, cutting off the source
of them will guarantee the number of those existing dumps will 
decrease, eventually, assuming recycling of dump-space to zero.  :-)

