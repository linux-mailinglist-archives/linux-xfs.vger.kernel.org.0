Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6358E74E3C9
	for <lists+linux-xfs@lfdr.de>; Tue, 11 Jul 2023 03:57:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230281AbjGKB5X (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 10 Jul 2023 21:57:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbjGKB5W (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Jul 2023 21:57:22 -0400
Received: from smtp1.onthe.net.au (smtp1.onthe.net.au [203.22.196.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A953CA4
        for <linux-xfs@vger.kernel.org>; Mon, 10 Jul 2023 18:57:19 -0700 (PDT)
Received: from localhost (smtp2.private.onthe.net.au [10.200.63.13])
        by smtp1.onthe.net.au (Postfix) with ESMTP id D61F9619B5
        for <linux-xfs@vger.kernel.org>; Tue, 11 Jul 2023 11:57:18 +1000 (EST)
Received: from smtp1.onthe.net.au ([10.200.63.11])
        by localhost (smtp.onthe.net.au [10.200.63.13]) (amavisd-new, port 10028)
        with ESMTP id FqcvHMtJ2b6j for <linux-xfs@vger.kernel.org>;
        Tue, 11 Jul 2023 11:57:18 +1000 (AEST)
Received: from athena.private.onthe.net.au (chris-gw2-vpn.private.onthe.net.au [10.9.3.2])
        by smtp1.onthe.net.au (Postfix) with ESMTP id A60DE6196C
        for <linux-xfs@vger.kernel.org>; Tue, 11 Jul 2023 11:57:18 +1000 (EST)
Received: by athena.private.onthe.net.au (Postfix, from userid 1026)
        id 1CF2F68061C; Tue, 11 Jul 2023 11:57:16 +1000 (AEST)
Date:   Tue, 11 Jul 2023 11:57:16 +1000
From:   Chris Dunlop <chris@onthe.net.au>
To:     linux-xfs@vger.kernel.org
Subject: Re: rm hanging, v6.1.35
Message-ID: <20230711015716.GA687252@onthe.net.au>
References: <20230710215354.GA679018@onthe.net.au>
 <20230711001331.GA683098@onthe.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230711001331.GA683098@onthe.net.au>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 11, 2023 at 10:13:31AM +1000, Chris Dunlop wrote:
> On Tue, Jul 11, 2023 at 07:53:54AM +1000, Chris Dunlop wrote:
>> Hi,
>>
>> This box is newly booted into linux v6.1.35 (2 days ago), it was 
>> previously running v5.15.118 without any problems (other than that 
>> fixed by "5e672cd69f0a xfs: non-blocking inodegc pushes", the reason 
>> for the upgrade).
>>
>> I have rm operations on two files that have been stuck for in excess 
>> of 22 hours and 18 hours respectively:
> ...
>> ...subsequent to starting writing all this down I have another two 
>> sets of rms stuck, again on unremarkable files, and on two more 
>> separate filesystems.
>>
>> ...oh. And an 'ls' on those files is hanging. The reboot has become 
>> more urgent.
>
> FYI, it's not 'ls' that's hanging, it's bash, because I used a 
> wildcard on the command line. The bash stack:
>
> $ cat /proc/24779/stack
> [<0>] iterate_dir+0x3e/0x180
> [<0>] __x64_sys_getdents64+0x71/0x100
> [<0>] do_syscall_64+0x34/0x80
> [<0>] entry_SYSCALL_64_after_hwframe+0x46/0xb0
>
> 'lsof' shows me it's trying to read one of the directories holding the 
> file that one of the newer hanging "rm"s is trying to remove.

Ugh. It wasn't just the "rm"s and bash hanging (and as it turns out, 
xfs_logprint), they were just obvious because that's what I was looking 
at.  It turns out there was a whole lot more hanging.

Full sysrq-w output at:

https://file.io/tg7F5OqIWo1B

Sorry if there's more I could be looking at, but I've gotta reboot this 
thing NOW...

Cheers,

Chris
