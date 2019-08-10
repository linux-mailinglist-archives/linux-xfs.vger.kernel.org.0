Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D346188E95
	for <lists+linux-xfs@lfdr.de>; Sat, 10 Aug 2019 23:51:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726223AbfHJVvc (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sat, 10 Aug 2019 17:51:32 -0400
Received: from mail02.iobjects.de ([188.40.134.68]:60444 "EHLO
        mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726212AbfHJVvc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 10 Aug 2019 17:51:32 -0400
X-Greylist: delayed 355 seconds by postgrey-1.27 at vger.kernel.org; Sat, 10 Aug 2019 17:51:31 EDT
Received: from tux.wizards.de (pD9EBFAAB.dip0.t-ipconnect.de [217.235.250.171])
        by mail02.iobjects.de (Postfix) with ESMTPSA id 9532B4164FC2;
        Sat, 10 Aug 2019 23:45:35 +0200 (CEST)
Received: from [192.168.100.223] (ragnarok.applied-asynchrony.com [192.168.100.223])
        by tux.wizards.de (Postfix) with ESMTP id 42ED2F01582;
        Sat, 10 Aug 2019 23:45:35 +0200 (CEST)
Subject: Re: [PATCH V2] xfs: allocate xattr buffer on demand
To:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
References: <20190724045911.GU7689@dread.disaster.area>
From:   =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Organization: Applied Asynchrony, Inc.
Message-ID: <403e606b-1b7b-5983-d8e5-a7fecee84702@applied-asynchrony.com>
Date:   Sat, 10 Aug 2019 23:45:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190724045911.GU7689@dread.disaster.area>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


Hi Dave -

great patch but I found something that seems off in xfs_attr3_leaf_getvalue:

> @@ -2378,31 +2403,23 @@ xfs_attr3_leaf_getvalue((..snip..)
> +	if (args->flags & ATTR_KERNOVAL) {
>   		args->valuelen = args->rmtvaluelen;
> +		return 0;
>   	}
> -	return 0;
> +	return xfs_attr_copy_value(args, NULL, args->rmtvaluelen);

With gcc9 I get:

   CC      fs/xfs/libxfs/xfs_attr_leaf.o
In function 'xfs_attr_copy_value',
     inlined from 'xfs_attr3_leaf_getvalue' at fs/xfs/libxfs/xfs_attr_leaf.c:2425:9:
fs/xfs/libxfs/xfs_attr_leaf.c:421:2: warning: argument 2 null where non-null expected [-Wnonnull]
   421 |  memcpy(args->value, value, valuelen);
       |  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
In file included from ./arch/x86/include/asm/string.h:5,
                  from ./include/linux/string.h:20,
                  from ./include/linux/uuid.h:12,
                  from ./fs/xfs/xfs_linux.h:10,
                  from ./fs/xfs/xfs.h:22,
                  from fs/xfs/libxfs/xfs_attr_leaf.c:7:
fs/xfs/libxfs/xfs_attr_leaf.c: In function 'xfs_attr3_leaf_getvalue':
./arch/x86/include/asm/string_64.h:14:14: note: in a call to function 'memcpy' declared here
    14 | extern void *memcpy(void *to, const void *from, size_t len);
       |              ^~~~~~

and sure enough, the NULL "value" arg is and passed as-is to memcpy in
xfs_attr_copy_value. Maybe you meant to sanitize the value when it's NULL?

Holger
