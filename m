Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4D237383A5
	for <lists+linux-xfs@lfdr.de>; Wed, 21 Jun 2023 14:23:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230448AbjFUMXb (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 21 Jun 2023 08:23:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229803AbjFUMXa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Jun 2023 08:23:30 -0400
Received: from mail.itouring.de (mail.itouring.de [85.10.202.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 047D21BF9
        for <linux-xfs@vger.kernel.org>; Wed, 21 Jun 2023 05:23:03 -0700 (PDT)
Received: from tux.applied-asynchrony.com (p5ddd7b2c.dip0.t-ipconnect.de [93.221.123.44])
        by mail.itouring.de (Postfix) with ESMTPSA id 4A173E0;
        Wed, 21 Jun 2023 14:22:54 +0200 (CEST)
Received: from [192.168.100.221] (hho.applied-asynchrony.com [192.168.100.221])
        by tux.applied-asynchrony.com (Postfix) with ESMTP id 14591F01608;
        Wed, 21 Jun 2023 14:22:54 +0200 (CEST)
Subject: Re: [PATCH] po/de.po: Fix possible typo which makes gettext-0.22
 unhappy
To:     Lars Wendler <polynomial-c@gmx.de>
Cc:     linux-xfs@vger.kernel.org
References: <20230621105520.17560-1-polynomial-c@gmx.de>
 <a08995aa-2003-be8f-dab1-6d8ed6687e12@applied-asynchrony.com>
 <20230621135608.25db01bb@chagall.paradoxon.rec>
From:   =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Organization: Applied Asynchrony, Inc.
Message-ID: <19e2d366-ecbf-1310-a02a-27884b9b5efe@applied-asynchrony.com>
Date:   Wed, 21 Jun 2023 14:22:54 +0200
MIME-Version: 1.0
In-Reply-To: <20230621135608.25db01bb@chagall.paradoxon.rec>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2023-06-21 13:56, Lars Wendler wrote:
> Am Wed, 21 Jun 2023 13:29:03 +0200
> schrieb Holger Hoffstätte <holger@applied-asynchrony.com>:
> 
>> On 2023-06-21 12:55, Lars Wendler wrote:
>>> diff --git a/po/de.po b/po/de.po
>>> index 944b0e91..a6f8fde1 100644
>>> --- a/po/de.po
>>> +++ b/po/de.po
>>> @@ -3084,7 +3084,7 @@ msgstr "%llu Spezialdateien\n"
>>>    #: .././estimate/xfs_estimate.c:191
>>>    #, c-format
>>>    msgid "%s will take about %.1f megabytes\n"
>>> -msgstr "%s wird etwa %.lf Megabytes einnehmen\n"
>>> +msgstr "%s wird etwa %.1f Megabytes einnehmen\n"
>>
>> I don't see the difference..?
>> Both the added and removed line are the same.
>>
>> -h
> 
> I suppose depending on the font, it's quite hard to distinguish the two
> lines.
> The removed line contains "%.lf" with a lowercase letter L.
> The added line contains "%.1f" where the lowercase letter L was replaced
> with the digit 1.

Ahh..of course! Zooming in did the trick, I see the difference now.
Thanks!

-h
