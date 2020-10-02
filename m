Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CDE3281654
	for <lists+linux-xfs@lfdr.de>; Fri,  2 Oct 2020 17:15:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388074AbgJBPPU (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 2 Oct 2020 11:15:20 -0400
Received: from sandeen.net ([63.231.237.45]:39030 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726017AbgJBPPU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 2 Oct 2020 11:15:20 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 573542ACC;
        Fri,  2 Oct 2020 10:14:29 -0500 (CDT)
To:     Ian Kent <raven@themaw.net>, xfs <linux-xfs@vger.kernel.org>
References: <160151439137.66595.8436234885474855194.stgit@mickey.themaw.net>
 <974aaec3-17e4-ecc0-2220-f34ce19348c8@sandeen.net>
 <200b30f514e30ecaebb754efb8a8ea5cb4d38fd3.camel@themaw.net>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH] xfsprogs: ignore autofs mount table entries
Message-ID: <bb1c53a5-5f96-e1cb-502d-e8e4c1e2a9f3@sandeen.net>
Date:   Fri, 2 Oct 2020 10:15:19 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <200b30f514e30ecaebb754efb8a8ea5cb4d38fd3.camel@themaw.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 10/1/20 9:27 PM, Ian Kent wrote:
>> I'm mostly ok with just always and forever filtering out anything
>> that matches
>> "autofs" but if it's unnecessary (like the first case I think?) it
>> may lead
>> to confusion for future code readers.
> I've got feedback from Darrick too, so let me think about what should
> be done.
> 
> What I want out of this is that autofs mounts don't get triggered when
> I start autofs for testing when xfs is the default (root) file system.
> If it isn't the default file system this behaviour mostly doesn't
> happen.

Yep I'm totally on board with that plan in general, thanks.

I wouldn't worry about refactoring in service of the goal, I just wanted
to be sure that we were being strategic/surgical about the changes.

Thanks,
-Eric

> My basic test setup has a couple of hundred direct autofs mounts in
> two or three maps and they all get mounted when starting autofs.
> 
> I'm surprised we haven't had complaints about it TBH but people might
> not have noticed it since they expire away if they don't actually
> get used.
> 
> Ian
> 
