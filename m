Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76F091401D1
	for <lists+linux-xfs@lfdr.de>; Fri, 17 Jan 2020 03:20:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729476AbgAQCUi (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 16 Jan 2020 21:20:38 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:48054 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729113AbgAQCUi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 16 Jan 2020 21:20:38 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 3C40C41464A385DAC902;
        Fri, 17 Jan 2020 10:20:36 +0800 (CST)
Received: from [127.0.0.1] (10.173.220.96) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.439.0; Fri, 17 Jan 2020
 10:20:27 +0800
Subject: Re: [PATCH] xfs/126: fix that corrupt xattr might fail with a small
 probability
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
CC:     <guaneryu@gmail.com>, <jbacik@fusionio.com>,
        <fstests@vger.kernel.org>, <linux-xfs@vger.kernel.org>,
        <zhengbin13@huawei.com>, <yi.zhang@huawei.com>
References: <20200108092758.41363-1-yukuai3@huawei.com>
 <20200108162227.GD5552@magnolia>
 <3c7e9497-e0ed-23e4-ff9c-4b1c1a77c9fa@huawei.com>
 <20200109164615.GA8247@magnolia>
 <51e99fd5-617f-6558-7a04-c4a198139cdd@huawei.com>
 <20200116160323.GC2149943@magnolia>
From:   "yukuai (C)" <yukuai3@huawei.com>
Message-ID: <bc9afd0d-91e5-ef0a-94cb-599b8a57b136@huawei.com>
Date:   Fri, 17 Jan 2020 10:20:26 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200116160323.GC2149943@magnolia>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.220.96]
X-CFilter-Loop: Reflected
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2020/1/17 0:03, Darrick J. Wong wrote:
> Does adding "-o 4" to the blocktrash command make it work reliably?
> That should be close enough to the start of the attrleaf block that
> we'll reliably corrupt*some*  amount of stuff in the header.

Seems like a good idea!
After adding "-o 4", I tested over 200 times, and blocktrash never 
failed to corrupt xattr anymore.

Thanks!
Yu Kuai

