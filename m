Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3855C58A4A0
	for <lists+linux-xfs@lfdr.de>; Fri,  5 Aug 2022 04:11:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233320AbiHECLU (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 4 Aug 2022 22:11:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230160AbiHECLU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Aug 2022 22:11:20 -0400
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3BF7122B04
        for <linux-xfs@vger.kernel.org>; Thu,  4 Aug 2022 19:11:19 -0700 (PDT)
Received: from [10.0.0.146] (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 376594C1502;
        Thu,  4 Aug 2022 21:10:18 -0500 (CDT)
Message-ID: <86691238-3de4-418d-5e94-981de043173e@sandeen.net>
Date:   Thu, 4 Aug 2022 21:11:16 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [RFC PATCH] libxfs: stop overriding MAP_SYNC in publicly exported
 header files
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     xfs <linux-xfs@vger.kernel.org>,
        Fabrice Fontaine <fontaine.fabrice@gmail.com>
References: <WVSe_1J22WBxe1bXs0u1-LcME14brH0fGDu5RCt5eBvqFJCSvxxAEPHIObGT4iqkEoCCZv4vpOzGZSrLjg8gcQ==@protonmail.internalid>
 <YtiPgDT3imEyU2aF@magnolia> <20220721121128.yyxnvkn4opjdgcln@orion>
 <e6ee2759-8b55-61a9-ff6c-6410d185d35e@gmail.com> <YuQBarhgxff8Hih6@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <YuQBarhgxff8Hih6@magnolia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 7/29/22 10:48 AM, Darrick J. Wong wrote:
>> Darrick, do you need to re-post, or can the maintainers pick up the patch directly?
> I already did:
> https://lore.kernel.org/linux-xfs/YtmB005kkkErb5uw@magnolia/
> 
> (It's August, so I think the xfsprogs maintainer might be on vacation?
> Either way, I'll make sure he's aware of it before the next release.)
> 
> --D
> 

Yep I was, picking it up now. Thanks for the pointer Darrick.

-Eric
