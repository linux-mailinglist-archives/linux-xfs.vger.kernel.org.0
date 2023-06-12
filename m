Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5672D72C3E8
	for <lists+linux-xfs@lfdr.de>; Mon, 12 Jun 2023 14:23:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbjFLMXN (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 12 Jun 2023 08:23:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbjFLMXM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Jun 2023 08:23:12 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 126DF8F
        for <linux-xfs@vger.kernel.org>; Mon, 12 Jun 2023 05:23:11 -0700 (PDT)
Received: from canpemm500005.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4QfrLX3rRfz18MBQ;
        Mon, 12 Jun 2023 20:18:12 +0800 (CST)
Received: from [10.174.178.198] (10.174.178.198) by
 canpemm500005.china.huawei.com (7.192.104.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 12 Jun 2023 20:23:06 +0800
Message-ID: <c247b956-55e9-ecd1-4db0-d45d2f65e9fe@huawei.com>
Date:   Mon, 12 Jun 2023 20:23:00 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCH v2] libxcmd: add return value check for dynamic memory
 function
To:     "Darrick J. Wong" <djwong@kernel.org>
CC:     <linux-xfs@vger.kernel.org>, <hch@lst.de>, <sandeen@sandeen.net>,
        <linfeilong@huawei.com>, <liuzhiqiang26@huawei.com>
References: <20230608025146.64940-1-suweifeng1@huawei.com>
 <20230608144624.GU1325469@frogsfrogsfrogs>
From:   Weifeng Su <suweifeng1@huawei.com>
In-Reply-To: <20230608144624.GU1325469@frogsfrogsfrogs>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.198]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 canpemm500005.china.huawei.com (7.192.104.229)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Just ping, Is the merge windown open?

On 2023/6/8 22:46, Darrick J. Wong wrote:
> On Thu, Jun 08, 2023 at 10:51:46AM +0800, Weifeng Su wrote:
>> The result check was missed and It cause the coredump like:
>> 0x00005589f3e358dd in add_command (ci=0x5589f3e3f020 <health_cmd>) at command.c:37
>> 0x00005589f3e337d8 in init_commands () at init.c:37
>> init (argc=<optimized out>, argv=0x7ffecfb0cd28) at init.c:102
>> 0x00005589f3e33399 in main (argc=<optimized out>, argv=<optimized out>) at init.c:112
>>
>> Add check for realloc function to ignore this coredump and exit with
>> error output
>>
>> Signed-off-by: Weifeng Su <suweifeng1@huawei.com>
> 
> Looks good to me,
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> 
> --D
> 
>> ---
>> Changes since version 1:
>> - Modify according to review opinions, Add more string
>>
>>   libxcmd/command.c | 4 ++++
>>   1 file changed, 4 insertions(+)
>>
>> diff --git a/libxcmd/command.c b/libxcmd/command.c
>> index a76d1515..e2603097 100644
>> --- a/libxcmd/command.c
>> +++ b/libxcmd/command.c
>> @@ -34,6 +34,10 @@ add_command(
>>   	const cmdinfo_t	*ci)
>>   {
>>   	cmdtab = realloc((void *)cmdtab, ++ncmds * sizeof(*cmdtab));
>> +	if (!cmdtab) {
>> +		perror(_("adding libxcmd command"));
>> +		exit(1);
>> +	}
>>   	cmdtab[ncmds - 1] = *ci;
>>   	qsort(cmdtab, ncmds, sizeof(*cmdtab), compare);
>>   }
>> -- 
>> 2.18.0.windows.1
>>
