Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D31822BB3C
	for <lists+linux-xfs@lfdr.de>; Fri, 24 Jul 2020 03:09:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726284AbgGXBJF (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 23 Jul 2020 21:09:05 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:33412 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726259AbgGXBJF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Jul 2020 21:09:05 -0400
X-IronPort-AV: E=Sophos;i="5.75,388,1589212800"; 
   d="scan'208";a="96838722"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 24 Jul 2020 09:09:02 +0800
Received: from G08CNEXMBPEKD06.g08.fujitsu.local (unknown [10.167.33.206])
        by cn.fujitsu.com (Postfix) with ESMTP id CD5A64CE4BD9;
        Fri, 24 Jul 2020 09:09:01 +0800 (CST)
Received: from [10.167.220.69] (10.167.220.69) by
 G08CNEXMBPEKD06.g08.fujitsu.local (10.167.33.206) with Microsoft SMTP Server
 (TLS) id 15.0.1497.2; Fri, 24 Jul 2020 09:09:01 +0800
Message-ID: <5F1A34AC.8080505@cn.fujitsu.com>
Date:   Fri, 24 Jul 2020 09:09:00 +0800
From:   Xiao Yang <yangx.jy@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.2; zh-CN; rv:1.9.2.18) Gecko/20110616 Thunderbird/3.1.11
MIME-Version: 1.0
To:     Eric Sandeen <sandeen@sandeen.net>
CC:     Christoph Hellwig <hch@infradead.org>, <darrick.wong@oracle.com>,
        <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] io/attr.c: Disallow specifying both -D and -R options
 for chattr command
References: <20200723052723.30063-1-yangx.jy@cn.fujitsu.com> <20200723060850.GA14199@infradead.org> <5F19308A.2060109@cn.fujitsu.com> <86314935-eeb9-3c8a-5d64-7db8b36ce43d@sandeen.net>
In-Reply-To: <86314935-eeb9-3c8a-5d64-7db8b36ce43d@sandeen.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.220.69]
X-ClientProxiedBy: G08CNEXCHPEKD06.g08.fujitsu.local (10.167.33.205) To
 G08CNEXMBPEKD06.g08.fujitsu.local (10.167.33.206)
X-yoursite-MailScanner-ID: CD5A64CE4BD9.AC667
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: yangx.jy@cn.fujitsu.com
X-Spam-Status: No
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2020/7/24 6:15, Eric Sandeen wrote:
> On 7/22/20 11:39 PM, Xiao Yang wrote:
>> On 2020/7/23 14:08, Christoph Hellwig wrote:
>>> On Thu, Jul 23, 2020 at 01:27:23PM +0800, Xiao Yang wrote:
>>>> -D and -R options are mutually exclusive actually but chattr command
>>>> doesn't check it so that always applies -D option when both of them
>>>> are specified.  For example:
>>> Looks good,
>>>
>>> Reviewed-by: Christoph Hellwig<hch@lst.de>
>> Hi,
>>
>> Ah,  I have a question after sending the patch:
>> Other commands(e.g. cowextsize) including the same options seem to avoid the issue by accepting the last option, as below:
>> --------------------------------------------------------
>> io/cowextsize.c
>> 141         while ((c = getopt(argc, argv, "DR")) != EOF) {
>> 142                 switch (c) {
>> 143                 case 'D':
>> 144                         recurse_all = 0;
>> 145                         recurse_dir = 1;
>> 146                         break;
>> 147                 case 'R':
>> 148                         recurse_all = 1;
>> 149                         recurse_dir = 0;
>> 150                         break;
> Yep, I meant to look at this but hadn't gotten to it yet.  These should all
> be consistent, and I tend to agree with Dave that explicitly conflicting
> incompatible options and erroring out is better than silently accepting
> the last one specified.
>
> And indeed help specifies that they are exclusive:
>
>          cowextsize_cmd.args = _("[-D | -R] [cowextsize]");
>
> It'd be great if you want to send a V2 that makes the behavior (and
> documentation) of any/all commands that accept [-D | -R] consistent.
Hi Eric, Dave

Thanks for your suggestions.
I will send v2 patch to make the behavior consistent.

Thanks,
Xiao Yang
> Thanks,
> -Eric
>
>
> .
>



