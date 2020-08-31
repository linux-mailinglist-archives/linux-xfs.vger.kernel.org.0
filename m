Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A962257B85
	for <lists+linux-xfs@lfdr.de>; Mon, 31 Aug 2020 16:53:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728156AbgHaOxY (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 31 Aug 2020 10:53:24 -0400
Received: from sandeen.net ([63.231.237.45]:36872 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727902AbgHaOxX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 31 Aug 2020 10:53:23 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 677513248;
        Mon, 31 Aug 2020 09:53:03 -0500 (CDT)
Subject: Re: [PATCH 1/4] xfs: Use variable-size array for nameval in
 xfs_attr_sf_entry
To:     Carlos Maiolino <cmaiolino@redhat.com>, linux-xfs@vger.kernel.org
References: <20200831130423.136509-1-cmaiolino@redhat.com>
 <20200831130423.136509-2-cmaiolino@redhat.com>
From:   Eric Sandeen <sandeen@sandeen.net>
Message-ID: <029949dc-6f6b-7083-0dc7-85961f728776@sandeen.net>
Date:   Mon, 31 Aug 2020 09:53:21 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.2.0
MIME-Version: 1.0
In-Reply-To: <20200831130423.136509-2-cmaiolino@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 8/31/20 8:04 AM, Carlos Maiolino wrote:
>  #define XFS_ATTR_SF_ENTSIZE_MAX			/* max space for name&value */ \
> -	((1 << (NBBY*(int)sizeof(uint8_t))) - 1)
> +	(1 << (NBBY*(int)sizeof(uint8_t)))

This probably is not correct.  :)

This would cut the max size of attr (name+value) in half.

-Eric
