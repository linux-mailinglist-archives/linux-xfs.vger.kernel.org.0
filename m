Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A8FA3C818E
	for <lists+linux-xfs@lfdr.de>; Wed, 14 Jul 2021 11:28:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238308AbhGNJaw (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 14 Jul 2021 05:30:52 -0400
Received: from mga03.intel.com ([134.134.136.65]:19138 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238189AbhGNJaw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 14 Jul 2021 05:30:52 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10044"; a="210358873"
X-IronPort-AV: E=Sophos;i="5.84,238,1620716400"; 
   d="scan'208";a="210358873"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2021 02:27:58 -0700
X-IronPort-AV: E=Sophos;i="5.84,238,1620716400"; 
   d="scan'208";a="494390723"
Received: from rongch2-mobl.ccr.corp.intel.com (HELO [10.249.169.74]) ([10.249.169.74])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2021 02:27:56 -0700
Subject: Re: [PATCH v4][next] xfs: Replace one-element arrays with
 flexible-array members
To:     Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <djwong@kernel.org>
Cc:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
References: <20210412135611.GA183224@embeddedor>
 <20210412152906.GA1075717@infradead.org> <20210412154808.GA1670408@magnolia>
 <20210413165313.GA1430582@infradead.org>
From:   "Chen, Rong A" <rong.a.chen@intel.com>
Message-ID: <f074c562-774d-fb35-b6a2-01c3873bb6ec@intel.com>
Date:   Wed, 14 Jul 2021 17:27:54 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210413165313.GA1430582@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 4/14/2021 12:53 AM, Christoph Hellwig wrote:
> On Mon, Apr 12, 2021 at 08:48:08AM -0700, Darrick J. Wong wrote:
>> A couple of revisions ago I specifically asked Gustavo to create these
>> 'silly' sizeof helpers to clean up...
>>
>>>> -					(sizeof(struct xfs_efd_log_item) +
>>>> -					(XFS_EFD_MAX_FAST_EXTENTS - 1) *
>>>> -					sizeof(struct xfs_extent)),
>>>> -					0, 0, NULL);
>>>> +					 struct_size((struct xfs_efd_log_item *)0,
>>>> +					 efd_format.efd_extents,
>>>> +					 XFS_EFD_MAX_FAST_EXTENTS),
>>
>> ...these even uglier multiline statements.  I was also going to ask for
>> these kmem cache users to get cleaned up.  I'd much rather look at:
>>
>> 	xfs_efi_zone = kmem_cache_create("xfs_efi_item",
>> 				sizeof_xfs_efi(XFS_EFI_MAX_FAST_EXTENTS), 0);
>> 	if (!xfs_efi_zone)
>> 		goto the_drop_zone;
>>
>> even if it means another static inline.
> 
> Which doesn't really work with struct_size or rather leads to a mess
> like the above as struct_size really wants a variable and not just a
> type.  Making it really nasty for both allocations and creating slab
> caches.  I tried to find a workaround for that, but that makes the
> compiler unhappy based its inlining heuristics.
> 
> Anyway, a lot of the helpers are pretty silly as they duplicate stuff
> without cleaning up the underlying mess.  I tried to sort much of this
> out here, still WIP:
> 
> http://git.infradead.org/users/hch/xfs.git/shortlog/refs/heads/xfs-array-size
> 

Hi xfs maintainers,

Kindly ping, is there any new progress on this patch series?

Best Regards,
Rong Chen
