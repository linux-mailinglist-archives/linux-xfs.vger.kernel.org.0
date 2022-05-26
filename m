Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4278853538F
	for <lists+linux-xfs@lfdr.de>; Thu, 26 May 2022 20:49:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343791AbiEZStk (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 26 May 2022 14:49:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345467AbiEZStg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 May 2022 14:49:36 -0400
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6224655228
        for <linux-xfs@vger.kernel.org>; Thu, 26 May 2022 11:49:35 -0700 (PDT)
Received: from [10.0.0.146] (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 45FA878D2;
        Thu, 26 May 2022 13:49:29 -0500 (CDT)
Message-ID: <393627ac-be5e-276b-65fb-6701679b958c@sandeen.net>
Date:   Thu, 26 May 2022 13:49:32 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.1
Content-Language: en-US
To:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
References: <20220426234453.682296-1-david@fromorbit.com>
 <20220426234453.682296-5-david@fromorbit.com>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 4/4] xfsprogs: autoconf modernisation
In-Reply-To: <20220426234453.682296-5-david@fromorbit.com>
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

On 4/26/22 6:44 PM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Because apparently AC_TRY_COMPILE and AC_TRY_LINK has been
> deprecated and made obsolete.
> 
> .....
> configure.ac:164: warning: The macro `AC_TRY_COMPILE' is obsolete.
> configure.ac:164: You should run autoupdate.
> ./lib/autoconf/general.m4:2847: AC_TRY_COMPILE is expanded from...
> m4/package_libcdev.m4:68: AC_HAVE_GETMNTENT is expanded from...
> configure.ac:164: the top level
> configure.ac:165: warning: The macro `AC_TRY_LINK' is obsolete.
> configure.ac:165: You should run autoupdate.
> ./lib/autoconf/general.m4:2920: AC_TRY_LINK is expanded from...
> m4/package_libcdev.m4:84: AC_HAVE_FALLOCATE is expanded from...
> configure.ac:165: the top level
> .....
> 
> But "autoupdate" does nothing to fix this, so I have to manually do
> these conversions:
> 
> 	- AC_TRY_COMPILE -> AC_COMPILE_IFELSE
> 	- AC_TRY_LINK -> AC_LINK_IFELSE
> 
> because I have nothing better to do than fix currently working
> code.
> 
> Also, running autoupdate forces the minimum pre-req to be autoconf
> 2.71 because it replaces other stuff...

Bleah, to that part.  2.71 isn't even available on Fedora Core 35 which
was released 6 months ago.
I'm afraid this will break lots of builds in not-very-old environments.

I'm inclined to look into whether I can just replace the obsolete
macros to shut up the warnings for now, does that seem reasonable?

And then bumping the 2.50 minimum to the 8-year-old 2.69 is probably wise ;)

Thanks,
-Eric
