Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8569A5A3423
	for <lists+linux-xfs@lfdr.de>; Sat, 27 Aug 2022 05:19:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237928AbiH0DLv (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 26 Aug 2022 23:11:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231216AbiH0DLu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 Aug 2022 23:11:50 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D10E5B1ED;
        Fri, 26 Aug 2022 20:11:48 -0700 (PDT)
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4MF1sR44KMzGpqY;
        Sat, 27 Aug 2022 11:10:03 +0800 (CST)
Received: from kwepemm600003.china.huawei.com (7.193.23.202) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Sat, 27 Aug 2022 11:11:46 +0800
Received: from [127.0.0.1] (10.174.177.249) by kwepemm600003.china.huawei.com
 (7.193.23.202) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Sat, 27 Aug
 2022 11:11:45 +0800
Subject: Re: [PATCH] xfs: donot need to check return value of xlog_kvmalloc()
To:     "Darrick J. Wong" <djwong@kernel.org>, <linux-xfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     linfeilong <linfeilong@huawei.com>,
        wuguanghao <wuguanghao3@huawei.com>
References: <514e5e4b-e7c8-365f-8459-75974c067993@huawei.com>
From:   Zhiqiang Liu <liuzhiqiang26@huawei.com>
Message-ID: <c90c6f86-dc0f-07bd-2abe-77d31716ee91@huawei.com>
Date:   Sat, 27 Aug 2022 11:11:44 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <514e5e4b-e7c8-365f-8459-75974c067993@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.174.177.249]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemm600003.china.huawei.com (7.193.23.202)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

friendly ping..

On 2022/8/22 19:46, Zhiqiang Liu wrote:
> In xfs_attri_log_nameval_alloc(), xlog_kvmalloc() is called
> to alloc memory, which will always return
> successfully, so we donot need to check return value.
>
> Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
> ---
>  fs/xfs/xfs_attr_item.c | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
> index 5077a7ad5646..667e151a2bca 100644
> --- a/fs/xfs/xfs_attr_item.c
> +++ b/fs/xfs/xfs_attr_item.c
> @@ -86,8 +86,6 @@ xfs_attri_log_nameval_alloc(
>  	 */
>  	nv = xlog_kvmalloc(sizeof(struct xfs_attri_log_nameval) +
>  					name_len + value_len);
> -	if (!nv)
> -		return nv;
>
>  	nv->name.i_addr = nv + 1;
>  	nv->name.i_len = name_len;

