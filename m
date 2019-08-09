Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DACD876CE
	for <lists+linux-xfs@lfdr.de>; Fri,  9 Aug 2019 11:59:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726195AbfHIJ7X (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 9 Aug 2019 05:59:23 -0400
Received: from outbound-smtp38.blacknight.com ([46.22.139.221]:43464 "EHLO
        outbound-smtp38.blacknight.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727063AbfHIJ7X (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Aug 2019 05:59:23 -0400
Received: from mail.blacknight.com (unknown [81.17.254.17])
        by outbound-smtp38.blacknight.com (Postfix) with ESMTPS id F1E96D19
        for <linux-xfs@vger.kernel.org>; Fri,  9 Aug 2019 10:59:21 +0100 (IST)
Received: (qmail 20186 invoked from network); 9 Aug 2019 09:59:21 -0000
Received: from unknown (HELO techsingularity.net) (mgorman@techsingularity.net@[84.203.18.93])
  by 81.17.254.9 with ESMTPSA (AES256-SHA encrypted, authenticated); 9 Aug 2019 09:59:21 -0000
Date:   Fri, 9 Aug 2019 10:59:19 +0100
From:   Mel Gorman <mgorman@techsingularity.net>
To:     Vlastimil Babka <vbabka@suse.cz>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>,
        Michal Hocko <mhocko@kernel.org>, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm, vmscan: Do not special-case slab reclaim when
 watermarks are boosted
Message-ID: <20190809095919.GN2739@techsingularity.net>
References: <20190808182946.GM2739@techsingularity.net>
 <7c39799f-ce00-e506-ef3b-4cd8fbff643c@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <7c39799f-ce00-e506-ef3b-4cd8fbff643c@suse.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 09, 2019 at 10:46:19AM +0200, Vlastimil Babka wrote:
> On 8/8/19 8:29 PM, Mel Gorman wrote:
> 
> ...
> 
> > Removing the special casing can still indirectly help fragmentation by
> 
> I think you mean e.g. 'against fragmentation'?
> 

Yes.

> > Fixes: 1c30844d2dfe ("mm: reclaim small amounts of memory when an external fragmentation event occurs")
> > Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
> > Reviewed-by: Dave Chinner <dchinner@redhat.com>
> > Cc: stable@vger.kernel.org # v5.0+
> 
> Acked-by: Vlastimil Babka <vbabka@suse.cz>

Thanks!

-- 
Mel Gorman
SUSE Labs
