Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEEE62C1ACF
	for <lists+linux-xfs@lfdr.de>; Tue, 24 Nov 2020 02:28:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729744AbgKXB0V (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 23 Nov 2020 20:26:21 -0500
Received: from sandeen.net ([63.231.237.45]:50968 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729629AbgKXB0U (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 23 Nov 2020 20:26:20 -0500
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 7A5E5B50;
        Mon, 23 Nov 2020 19:26:16 -0600 (CST)
Subject: Re: [PATCH] xfs: show the proper user quota options
From:   Eric Sandeen <sandeen@sandeen.net>
To:     xiakaixu1987@gmail.com, linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, Kaixu Xia <kaixuxia@tencent.com>
References: <1606124332-22100-1-git-send-email-kaixuxia@tencent.com>
 <9ebecd8a-2b3f-6a24-1d9d-1c9c0bf9f017@sandeen.net>
Message-ID: <403e6edc-b506-8b30-83aa-cfdde0596a59@sandeen.net>
Date:   Mon, 23 Nov 2020 19:26:19 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <9ebecd8a-2b3f-6a24-1d9d-1c9c0bf9f017@sandeen.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 11/23/20 12:36 PM, Eric Sandeen wrote:
> On 11/23/20 3:38 AM, xiakaixu1987@gmail.com wrote:
>> From: Kaixu Xia <kaixuxia@tencent.com>
>>
>> The quota option 'usrquota' should be shown if both the XFS_UQUOTA_ACCT
>> and XFS_UQUOTA_ENFD flags are set. The option 'uqnoenforce' should be
>> shown when only the XFS_UQUOTA_ACCT flag is set. The current code logic
>> seems wrong, Fix it and show proper options.
> 
> I'm failing to see the difference in the logic here.  Under the current
> code, what combination of flags yields the wrong string, and what does
> this patch change in that respect?

<djwong pointed out what I missed>

But I guess that just emphasizes the need for a test :)

Thanks,
-Eric
