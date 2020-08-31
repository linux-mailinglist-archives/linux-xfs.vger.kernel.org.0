Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB524257B86
	for <lists+linux-xfs@lfdr.de>; Mon, 31 Aug 2020 16:54:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727902AbgHaOy7 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 31 Aug 2020 10:54:59 -0400
Received: from sandeen.net ([63.231.237.45]:36982 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726144AbgHaOy6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 31 Aug 2020 10:54:58 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 59D617BAD;
        Mon, 31 Aug 2020 09:54:39 -0500 (CDT)
Subject: Re: [PATCH 1/4] xfs: Use variable-size array for nameval in
 xfs_attr_sf_entry
From:   Eric Sandeen <sandeen@sandeen.net>
To:     Carlos Maiolino <cmaiolino@redhat.com>, linux-xfs@vger.kernel.org
References: <20200831130423.136509-1-cmaiolino@redhat.com>
 <20200831130423.136509-2-cmaiolino@redhat.com>
 <029949dc-6f6b-7083-0dc7-85961f728776@sandeen.net>
Message-ID: <319c7184-7a58-61b1-3f5d-c73d7cd0e116@sandeen.net>
Date:   Mon, 31 Aug 2020 09:54:57 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.2.0
MIME-Version: 1.0
In-Reply-To: <029949dc-6f6b-7083-0dc7-85961f728776@sandeen.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 8/31/20 9:53 AM, Eric Sandeen wrote:
> On 8/31/20 8:04 AM, Carlos Maiolino wrote:
>>  #define XFS_ATTR_SF_ENTSIZE_MAX			/* max space for name&value */ \
>> -	((1 << (NBBY*(int)sizeof(uint8_t))) - 1)
>> +	(1 << (NBBY*(int)sizeof(uint8_t)))
> 
> This probably is not correct.  :)
> 
> This would cut the max size of attr (name+value) in half.

Whoops other way around.  ;)  this would double XFS_ATTR_SF_ENTSIZE_MAX.

In any case, just drop that change.

-Eric
