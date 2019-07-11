Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB99B65044
	for <lists+linux-xfs@lfdr.de>; Thu, 11 Jul 2019 04:45:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727263AbfGKCpk (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 10 Jul 2019 22:45:40 -0400
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:57498 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725977AbfGKCpk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Jul 2019 22:45:40 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R831e4;CH=green;DM=||false|;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01f04446;MF=alvin@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0TWaWugr_1562813136;
Received: from 30.1.89.131(mailfrom:Alvin@linux.alibaba.com fp:SMTPD_---0TWaWugr_1562813136)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 11 Jul 2019 10:45:36 +0800
Subject: Re: [PATCH] Fix the inconsistency between the code and the manual
 page of mkfs.xfs.
To:     Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org,
        sandeen@redhat.com
Cc:     caspar@linux.alibaba.com
References: <1560421580-22920-1-git-send-email-Alvin@linux.alibaba.com>
 <aa442f3b-e0ee-ea55-efcd-9aa3a499fdec@sandeen.net>
 <821e1d22-06ef-9ec9-f1ff-155792f8beb9@sandeen.net>
From:   Alvin Zheng <Alvin@linux.alibaba.com>
Message-ID: <e7b0a106-8b74-ee19-977c-0888f15516c8@linux.alibaba.com>
Date:   Thu, 11 Jul 2019 10:45:36 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <821e1d22-06ef-9ec9-f1ff-155792f8beb9@sandeen.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


On 2019/7/11 5:49, Eric Sandeen wrote:
> To save time, I'll merge this with my edits if you agree:

Please merge it with your edits, thanks.

Best regards,

Alvin

>
>
> mkfs.xfs.8: Fix an inconsistency between the code and the man page.
>
> From: Alvin Zheng <Alvin@linux.alibaba.com>
>
> The man page currently states that block and sector size units cannot
> be used for other option values unless they are explicitly specified,
> when in fact the default sizes will be used in that case.
>
> Change the man page to clarify this.
>
> Signed-off-by: Alvin Zheng <Alvin@linux.alibaba.com>
> [sandeen: sector/block values do not need to be specified first]
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
> ---
>
> diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
> index 78b15015..9d762a43 100644
> --- a/man/man8/mkfs.xfs.8
> +++ b/man/man8/mkfs.xfs.8
> @@ -115,9 +115,9 @@ When specifying parameters in units of sectors or filesystem blocks, the
>   .B \-s
>   option or the
>   .B \-b
> -option first needs to be added to the command line.
> -Failure to specify the size of the units will result in illegal value errors
> -when parameters are quantified in those units.
> +option may be used to specify the size of the sector or block.
> +If the size of the block or sector is not specified, the default sizes
> +(block: 4KiB, sector: 512B) will be used.
>   .PP
>   Many feature options allow an optional argument of 0 or 1, to explicitly
>   disable or enable the functionality.
> @@ -136,10 +136,6 @@ The filesystem block size is specified with a
>   in bytes. The default value is 4096 bytes (4 KiB), the minimum is 512, and the
>   maximum is 65536 (64 KiB).
>   .IP
> -To specify any options on the command line in units of filesystem blocks, this
> -option must be specified first so that the filesystem block size is
> -applied consistently to all options.
> -.IP
>   Although
>   .B mkfs.xfs
>   will accept any of these values and create a valid filesystem,
> @@ -901,10 +897,6 @@ is 512 bytes. The minimum value for sector size is
>   .I sector_size
>   must be a power of 2 size and cannot be made larger than the
>   filesystem block size.
> -.IP
> -To specify any options on the command line in units of sectors, this
> -option must be specified first so that the sector size is
> -applied consistently to all options.
>   .RE
>   .TP
>   .BI \-L " label"
