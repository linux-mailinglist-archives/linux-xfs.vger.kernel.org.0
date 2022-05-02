Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F120517AB4
	for <lists+linux-xfs@lfdr.de>; Tue,  3 May 2022 01:27:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229454AbiEBXai (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 2 May 2022 19:30:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233568AbiEBX31 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 May 2022 19:29:27 -0400
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8AF6B2408B
        for <linux-xfs@vger.kernel.org>; Mon,  2 May 2022 16:25:47 -0700 (PDT)
Received: from [10.0.0.146] (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 9BE92335031;
        Mon,  2 May 2022 18:24:36 -0500 (CDT)
Message-ID: <1730046a-b76d-ea71-687d-1c6b57a9b14c@sandeen.net>
Date:   Mon, 2 May 2022 18:25:06 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.1
Subject: Re: [PATCH v2 1/1] debian: Generate .gitcensus instead of .census
 (Closes: #999743)
Content-Language: en-US
To:     Bastian Germann <bage@debian.org>, linux-xfs@vger.kernel.org
Cc:     "Darrick J . Wong" <djwong@kernel.org>
References: <20211207122110.1448-1-bage@debian.org>
 <20211207122110.1448-2-bage@debian.org>
 <b51a775f-5fcd-a569-6a23-e9c91ab43c5f@debian.org>
From:   Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <b51a775f-5fcd-a569-6a23-e9c91ab43c5f@debian.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 4/17/22 5:00 AM, Bastian Germann wrote:
> Hi!
> 
> Am 07.12.21 um 13:21 schrieb Bastian Germann:
>> Fix the Debian build outside a git tree (e.g., Debian archive builds) by
>> creating an empty .gitcensus instead of .census file on config.
>>
>> Signed-off-by: Bastian Germann <bage@debian.org>
>> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> 
> 2nd friendly ping on this.
> For the last few Debian releases, I applied this.

Very sorry for the delay. Does this need magic in debian/changelog
to auto-close the bug?

I have the change itself staged for 5.16.0 now.

-Eric
