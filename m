Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B72CE284E41
	for <lists+linux-xfs@lfdr.de>; Tue,  6 Oct 2020 16:47:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbgJFOrw (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 6 Oct 2020 10:47:52 -0400
Received: from sandeen.net ([63.231.237.45]:39552 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725946AbgJFOrw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 6 Oct 2020 10:47:52 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 0842048C688;
        Tue,  6 Oct 2020 09:46:54 -0500 (CDT)
To:     Anthony Iliopoulos <ailiop@suse.com>
Cc:     linux-xfs@vger.kernel.org
References: <20201006100149.32740-1-ailiop@suse.com>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH] xfs_repair: remove obsolete code for handling mountpoint
 inodes
Message-ID: <243d4aaa-8386-b42d-2db8-64c7f4af43eb@sandeen.net>
Date:   Tue, 6 Oct 2020 09:47:50 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201006100149.32740-1-ailiop@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 10/6/20 5:01 AM, Anthony Iliopoulos wrote:
> The S_IFMNT file type was never supported in Linux, remove the related
> code that was supposed to deal with it, along with the translation file
> entries.

> Signed-off-by: Anthony Iliopoulos <ailiop@suse.com>

Seems fine.

Fun fact, this was /almost/ all removed way back in 2003 ;)

-#define        IFMNT           0160000         /* mount point */

...

-       case IFMNT:
-               type = XR_INO_MOUNTPOINT;
-               break;

I don't think there's any point to a Fixes: tag here though ;)

Thanks,

Reviewed-by: Eric Sandeen <sandeen@redhat.com>



