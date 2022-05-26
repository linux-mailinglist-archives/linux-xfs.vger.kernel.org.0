Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A6BB53540D
	for <lists+linux-xfs@lfdr.de>; Thu, 26 May 2022 21:45:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343526AbiEZTo5 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 26 May 2022 15:44:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234094AbiEZTo5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 May 2022 15:44:57 -0400
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C0D5E69494
        for <linux-xfs@vger.kernel.org>; Thu, 26 May 2022 12:44:55 -0700 (PDT)
Received: from [10.0.0.146] (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 6252B2AEE;
        Thu, 26 May 2022 14:44:50 -0500 (CDT)
Message-ID: <418a926d-fcc9-c5f0-1693-6392aaaa4618@sandeen.net>
Date:   Thu, 26 May 2022 14:44:54 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.1
Content-Language: en-US
From:   Eric Sandeen <sandeen@sandeen.net>
To:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
References: <20220426234453.682296-1-david@fromorbit.com>
 <20220426234453.682296-5-david@fromorbit.com>
 <393627ac-be5e-276b-65fb-6701679b958c@sandeen.net>
Subject: Re: [PATCH 4/4] xfsprogs: autoconf modernisation
In-Reply-To: <393627ac-be5e-276b-65fb-6701679b958c@sandeen.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 5/26/22 1:49 PM, Eric Sandeen wrote:
>> Also, running autoupdate forces the minimum pre-req to be autoconf
>> 2.71 because it replaces other stuff...
> Bleah, to that part.  2.71 isn't even available on Fedora Core 35 which
> was released 6 months ago.
> I'm afraid this will break lots of builds in not-very-old environments.
> 
> I'm inclined to look into whether I can just replace the obsolete
> macros to shut up the warnings for now, does that seem reasonable?
> 
> And then bumping the 2.50 minimum to the 8-year-old 2.69 is probably wise ;)
> 
> Thanks,
> -Eric

Actually, I think that 2.71 from autoupdate is gratuitous, all your changes
seem fine under the (ancient) 2.69.

So I'm inclined to merge this patch as is, but with a 2.69 minimum, as the
current 2.50 version requirement is for something released around the turn
of the century...

Any concerns or complaints?

-Eric
