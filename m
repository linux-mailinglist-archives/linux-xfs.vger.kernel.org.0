Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D939D3715E5
	for <lists+linux-xfs@lfdr.de>; Mon,  3 May 2021 15:22:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234142AbhECNXQ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 3 May 2021 09:23:16 -0400
Received: from sandeen.net ([63.231.237.45]:51790 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233592AbhECNXP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 3 May 2021 09:23:15 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id A441D16C14D;
        Mon,  3 May 2021 08:22:17 -0500 (CDT)
To:     listac@nebelschwaden.de, xfs <linux-xfs@vger.kernel.org>
References: <993c93fc-56e7-8c81-8f92-4e203b6e68dd@nebelschwaden.de>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: current maximum stripe unit size?
Message-ID: <43d4d941-e07a-9a75-daad-a9dbcae8da0e@sandeen.net>
Date:   Mon, 3 May 2021 08:22:21 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <993c93fc-56e7-8c81-8f92-4e203b6e68dd@nebelschwaden.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 4/29/21 9:10 AM, Ede Wolf wrote:
> Hello,
> 
> having found different values, as of Kernel 5.10, what is the maximum allowed size in K for stripe units?
> 
> I came across limits from 64k - 256k

Where did you read that?

> , but the documentation  always seemed quite aged.

Current mkfs limits are UINT_MAX for stripe unit and stripe width (so width is the effective limiter in most cases)

Interestingly, in the kernel the limit on swidth is INT_MAX. In any case, quite large.

(However, the /log/ stripe unit has a limit of 256; if the data stripe unit is larger, the log stripe unit will automatically be reduced.)

-Eric

> Thanks

