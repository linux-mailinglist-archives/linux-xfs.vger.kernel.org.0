Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8F1C7DA47
	for <lists+linux-xfs@lfdr.de>; Thu,  1 Aug 2019 13:28:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728259AbfHAL1y (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 1 Aug 2019 07:27:54 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:54597 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725790AbfHAL1y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Aug 2019 07:27:54 -0400
Received: from fsav405.sakura.ne.jp (fsav405.sakura.ne.jp [133.242.250.104])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id x71BRpsb083591;
        Thu, 1 Aug 2019 20:27:51 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav405.sakura.ne.jp (F-Secure/fsigk_smtp/530/fsav405.sakura.ne.jp);
 Thu, 01 Aug 2019 20:27:51 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/530/fsav405.sakura.ne.jp)
Received: from [192.168.1.8] (softbank126012062002.bbtec.net [126.12.62.2])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id x71BRpkD083585
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NO);
        Thu, 1 Aug 2019 20:27:51 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Subject: Re: [PATCH] fs: xfs: Remove unused KM_NOSLEEP, change KM_SLEEP to 0.
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
References: <1564654042-9088-1-git-send-email-penguin-kernel@I-love.SAKURA.ne.jp>
 <20190801105537.GM7777@dread.disaster.area>
From:   Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Message-ID: <62ec978e-c045-80ad-24a6-41da07d1b37d@i-love.sakura.ne.jp>
Date:   Thu, 1 Aug 2019 20:27:47 +0900
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190801105537.GM7777@dread.disaster.area>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2019/08/01 19:55, Dave Chinner wrote:
> On Thu, Aug 01, 2019 at 07:07:22PM +0900, Tetsuo Handa wrote:
>> Since no caller is using KM_NOSLEEP and no callee branches on KM_SLEEP,
>> but removing KM_SLEEP requires modification of 97 locations, let's remove
>> KM_NOSLEEP branch and (for now) change KM_SLEEP to 0.
> 
> Just remove KM_SLEEP. It's trivial to do with a couple of quick sed
> scripts.

If you don't mind dropping "(__force xfs_km_flags_t)" cast, I can do it
within this patch (and will post as a reply to this message).
