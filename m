Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E099889C1B
	for <lists+linux-xfs@lfdr.de>; Mon, 12 Aug 2019 12:59:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728128AbfHLK7h (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 12 Aug 2019 06:59:37 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:64218 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727936AbfHLK7h (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Aug 2019 06:59:37 -0400
Received: from fsav401.sakura.ne.jp (fsav401.sakura.ne.jp [133.242.250.100])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id x7CAxVls093718;
        Mon, 12 Aug 2019 19:59:31 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav401.sakura.ne.jp (F-Secure/fsigk_smtp/530/fsav401.sakura.ne.jp);
 Mon, 12 Aug 2019 19:59:31 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/530/fsav401.sakura.ne.jp)
Received: from [192.168.1.8] (softbank126227201116.bbtec.net [126.227.201.116])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id x7CAxUUH093713
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NO);
        Mon, 12 Aug 2019 19:59:31 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Subject: Re: [PATCH] fs: xfs: Remove KM_NOSLEEP and KM_SLEEP.
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
References: <62ec978e-c045-80ad-24a6-41da07d1b37d@i-love.sakura.ne.jp>
 <1564658887-12654-1-git-send-email-penguin-kernel@I-love.SAKURA.ne.jp>
 <20190801203945.GC7138@magnolia>
From:   Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Message-ID: <6e50eef5-434e-a81e-9001-f3deabfa7cc9@i-love.sakura.ne.jp>
Date:   Mon, 12 Aug 2019 19:59:30 +0900
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190801203945.GC7138@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2019/08/02 5:39, Darrick J. Wong wrote:
> On Thu, Aug 01, 2019 at 08:28:07PM +0900, Tetsuo Handa wrote:
>> Since no caller is using KM_NOSLEEP and no callee branches on KM_SLEEP,
>> we can remove KM_NOSLEEP and replace KM_SLEEP with 0.
>>
>> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> 
> Ahh, right, KM_{NO,}SLEEP are mutually exclusive values encoded
> alongside a bit flag set (ala fallocate mode)....
> 
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> --D

Thank you. Please apply to xfs tree.
