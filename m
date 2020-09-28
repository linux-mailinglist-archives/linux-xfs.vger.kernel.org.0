Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D418827B7C2
	for <lists+linux-xfs@lfdr.de>; Tue, 29 Sep 2020 01:15:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727130AbgI1XP1 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 28 Sep 2020 19:15:27 -0400
Received: from sandeen.net ([63.231.237.45]:47004 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726458AbgI1XPX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 28 Sep 2020 19:15:23 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 877D461665A;
        Mon, 28 Sep 2020 16:56:06 -0500 (CDT)
From:   Eric Sandeen <sandeen@sandeen.net>
To:     Anthony Iliopoulos <ailiop@suse.com>
Cc:     linux-xfs@vger.kernel.org
References: <20200824203724.13477-1-ailiop@suse.com>
 <20200824203724.13477-6-ailiop@suse.com>
 <cd2b2f0a-11a5-b0ff-779b-149f133605b1@sandeen.net>
Subject: Re: [PATCH 5/6] mkfs: remove redundant assignment of cli sb options
 on failure
Message-ID: <7e747122-51ec-0491-bfa6-a15ba327e925@sandeen.net>
Date:   Mon, 28 Sep 2020 16:56:49 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <cd2b2f0a-11a5-b0ff-779b-149f133605b1@sandeen.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 9/28/20 4:49 PM, Eric Sandeen wrote:
> On 8/24/20 3:37 PM, Anthony Iliopoulos wrote:
>> rmapbt and reflink are incompatible with realtime devices and mkfs bails
>> out on such configurations.  Switching them off in the cli params after
>> exit is dead code, remove it.
>>
>> Signed-off-by: Anthony Iliopoulos <ailiop@suse.com>
> 
> I'll go ahead & pull patches 5 & 6 since they're standalone fixes.
> 
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>

Whoops, Darrick's 

mkfs: fix reflink/rmap logic w.r.t. realtime devices and crc=0 support

already fixed this and a bit more, sorry for the noise.

