Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9D4B416908
	for <lists+linux-xfs@lfdr.de>; Fri, 24 Sep 2021 02:41:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243678AbhIXAmi (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 23 Sep 2021 20:42:38 -0400
Received: from sandeen.net ([63.231.237.45]:57286 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240863AbhIXAmh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 23 Sep 2021 20:42:37 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 5CEEB4901;
        Thu, 23 Sep 2021 19:40:38 -0500 (CDT)
To:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
References: <20210916013707.GQ2361455@dread.disaster.area>
 <20210916014649.1835564-1-david@fromorbit.com>
 <20210916014649.1835564-2-david@fromorbit.com>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 1/5] xfsprogs: introduce liburcu support
Message-ID: <5ca04624-581d-23da-ff18-a7e6c908efa1@sandeen.net>
Date:   Thu, 23 Sep 2021 19:41:03 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20210916014649.1835564-2-david@fromorbit.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 9/15/21 8:46 PM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
..

> Hence kernel code written with RCU algorithms and atomic variables
> will just slot straight into the userspace xfsprogs code without us
> having to think about whether the lockless algorithms will work in
> userspace or not. This reduces glue and hoop jumping, and gets us
> a step closer to having the entire userspace libxfs code MT safe.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

...

> diff --git a/m4/Makefile b/m4/Makefile
> index c6c73dc9bbee..7312053039f4 100644
> --- a/m4/Makefile
> +++ b/m4/Makefile
> @@ -24,6 +24,7 @@ LSRCFILES = \
>   	package_services.m4 \
>   	package_types.m4 \
>   	package_icu.m4 \
> +	package_urcu.m4 \

This new m4 file is missing from the patchset, I think?

Thanks,
-Eric

