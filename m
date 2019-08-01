Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B430A7E4A5
	for <lists+linux-xfs@lfdr.de>; Thu,  1 Aug 2019 23:13:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731636AbfHAVNf (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 1 Aug 2019 17:13:35 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:65395 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731215AbfHAVNf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Aug 2019 17:13:35 -0400
Received: from fsav101.sakura.ne.jp (fsav101.sakura.ne.jp [27.133.134.228])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id x71LDQRC016054;
        Fri, 2 Aug 2019 06:13:26 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav101.sakura.ne.jp (F-Secure/fsigk_smtp/530/fsav101.sakura.ne.jp);
 Fri, 02 Aug 2019 06:13:26 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/530/fsav101.sakura.ne.jp)
Received: from [192.168.1.8] (softbank126012062002.bbtec.net [126.12.62.2])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id x71LDGtw016009
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NO);
        Fri, 2 Aug 2019 06:13:26 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Subject: Re: [PATCH] fs: xfs: xfs_log: Don't use KM_MAYFAIL at
 xfs_log_reserve().
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
        Brian Foster <bfoster@redhat.com>
References: <20190729215657.GI7777@dread.disaster.area>
 <1564653995-9004-1-git-send-email-penguin-kernel@I-love.SAKURA.ne.jp>
 <20190801185057.GT30113@42.do-not-panic.com>
From:   Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Message-ID: <e901d22d-18b5-abde-15d1-777a6417f6c8@i-love.sakura.ne.jp>
Date:   Fri, 2 Aug 2019 06:13:12 +0900
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190801185057.GT30113@42.do-not-panic.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2019/08/02 3:50, Luis Chamberlain wrote:
> That's quite an opaque commit log for what started off as a severe email
> thread of potential leak of information. As such, can you expand on this
> commit log considerably to explain the situation a bit better? Your
> initial thread here provided much clearer evidence of the issue. As-is
> this commit log tells the reader *nothing* about the potential harm in
> not applying this patch.
> 
> You had mentioned you identified this issue present on at least
> 4.18 till 5.3-rc1. So, I'm at least inclined to consider this for
> stable for at least v4.19.
> 
> However, what about older kernels? Now that you have identified
> a fix, were the flag changed in prior commits, is it a regression
> that perhaps added KM_MAYFAIL at some point?

I only checked 4.18+ so that RHEL8 will backport this patch. According to
Brian Foster, commit eb01c9cd87 ("[XFS] Remove the xlog_ticket allocator")
( https://git.kernel.org/linus/eb01c9cd87 ) which dates back to April 2008
added KM_MAYFAIL flag for this allocation

-	buf = (xfs_caddr_t) kmem_zalloc(PAGE_SIZE, KM_SLEEP);
+	tic = kmem_zone_zalloc(xfs_log_ticket_zone, KM_SLEEP|KM_MAYFAIL);

though Dave Chinner thinks that the log ticket rework is irrelevant.
Do we need to find which commit made this problem visible?
