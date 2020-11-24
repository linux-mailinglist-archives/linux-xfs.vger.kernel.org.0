Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 152FB2C254C
	for <lists+linux-xfs@lfdr.de>; Tue, 24 Nov 2020 13:07:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732864AbgKXMFg (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 24 Nov 2020 07:05:36 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:8399 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729172AbgKXMFf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Nov 2020 07:05:35 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4CgN4p1hWqz6yHj;
        Tue, 24 Nov 2020 20:05:14 +0800 (CST)
Received: from [127.0.0.1] (10.174.178.208) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.487.0; Tue, 24 Nov 2020
 20:05:30 +0800
Subject: Re: [PATCH 1/2] xfs: check the return value of krealloc()
To:     Christoph Hellwig <hch@infradead.org>
CC:     "Darrick J . Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
References: <20201124104531.561-1-thunder.leizhen@huawei.com>
 <20201124104531.561-2-thunder.leizhen@huawei.com>
 <20201124115131.GB32060@infradead.org>
From:   "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>
Message-ID: <c3258752-4315-de2a-b0e3-3fb996fe1728@huawei.com>
Date:   Tue, 24 Nov 2020 20:05:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20201124115131.GB32060@infradead.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.208]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2020/11/24 19:51, Christoph Hellwig wrote:
> On Tue, Nov 24, 2020 at 06:45:30PM +0800, Zhen Lei wrote:
>> krealloc() may fail to expand the memory space. Add sanity checks to it,
>> and WARN() if that really happened.
> 
> What part of the __GFP_NOFAIL semantics isn't clear enough?

Oh, sorry, I didn't notice __GFP_NOFAIL flag.

> 
> 

