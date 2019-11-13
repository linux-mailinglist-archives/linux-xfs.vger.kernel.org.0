Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CA3BFB111
	for <lists+linux-xfs@lfdr.de>; Wed, 13 Nov 2019 14:08:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727137AbfKMNII (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 13 Nov 2019 08:08:08 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:38290 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726186AbfKMNIH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 13 Nov 2019 08:08:07 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id E4392C1CE9603A61D42E;
        Wed, 13 Nov 2019 21:08:04 +0800 (CST)
Received: from [127.0.0.1] (10.173.220.96) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.439.0; Wed, 13 Nov 2019
 21:07:54 +0800
Subject: Re: question about xfs tests involved logprint
To:     <linux-xfs@vger.kernel.org>, <fstests@vger.kernel.org>
CC:     "zhangyi (F)" <yi.zhang@huawei.com>,
        "zhengbin (A)" <zhengbin13@huawei.com>, <houtao1@huawei.com>
References: <f072d0a9-5380-115f-129e-a806227e34e4@huawei.com>
From:   "yukuai (C)" <yukuai3@huawei.com>
Message-ID: <49254d5b-5250-e25f-8629-e2cc83fba05f@huawei.com>
Date:   Wed, 13 Nov 2019 21:07:53 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <f072d0a9-5380-115f-129e-a806227e34e4@huawei.com>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.220.96]
X-CFilter-Loop: Reflected
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi list,
I'm testing xfs filesytem recently, and I think some tests is wrong.

for example: xfs/018
At first, this test mkfs with '-l version=1' without setting 'crc' to 
0(crc is 1 bt default),
which will fail.
Next, the expected output of xfs_logprint, 018.op, is obviously wrong. 
018.op include many ops with
'START' TRANS flag, which is impossible with delayed logging enabled. 
All the log items should be
in the same checkpoint.

There are some other tests have the same issue. Maybe the problem is due 
to when delayed
logging was enabled, these tests didn't get modified as they supposed to.

Thanks
Yu Kuai



