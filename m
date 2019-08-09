Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACD8F87482
	for <lists+linux-xfs@lfdr.de>; Fri,  9 Aug 2019 10:46:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726233AbfHIIqV (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 9 Aug 2019 04:46:21 -0400
Received: from mx2.suse.de ([195.135.220.15]:43118 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726054AbfHIIqV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 9 Aug 2019 04:46:21 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C5105AF3F;
        Fri,  9 Aug 2019 08:46:19 +0000 (UTC)
Subject: Re: [PATCH] mm, vmscan: Do not special-case slab reclaim when
 watermarks are boosted
To:     Mel Gorman <mgorman@techsingularity.net>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Dave Chinner <david@fromorbit.com>,
        Michal Hocko <mhocko@kernel.org>, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20190808182946.GM2739@techsingularity.net>
From:   Vlastimil Babka <vbabka@suse.cz>
Openpgp: preference=signencrypt
Autocrypt: addr=vbabka@suse.cz; prefer-encrypt=mutual; keydata=
 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
Message-ID: <7c39799f-ce00-e506-ef3b-4cd8fbff643c@suse.cz>
Date:   Fri, 9 Aug 2019 10:46:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190808182946.GM2739@techsingularity.net>
Content-Type: text/plain; charset=iso-8859-15
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 8/8/19 8:29 PM, Mel Gorman wrote:

...

> Removing the special casing can still indirectly help fragmentation by

I think you mean e.g. 'against fragmentation'?

> avoiding fragmentation-causing events due to slab allocation as pages
> from a slab pageblock will have some slab objects freed.  Furthermore,
> with the special casing, reclaim behaviour is unpredictable as kswapd
> sometimes examines slab and sometimes does not in a manner that is tricky
> to tune or analyse.
> 
> This patch removes the special casing. The downside is that this is not a
> universal performance win. Some benchmarks that depend on the residency
> of data when rereading metadata may see a regression when slab reclaim
> is restored to its original behaviour. Similarly, some benchmarks that
> only read-once or write-once may perform better when page reclaim is too
> aggressive. The primary upside is that slab shrinker is less surprising
> (arguably more sane but that's a matter of opinion), behaves consistently
> regardless of the fragmentation state of the system and properly obeys
> VM sysctls.
> 
> A fsmark benchmark configuration was constructed similar to
> what Dave reported and is codified by the mmtest configuration
> config-io-fsmark-small-file-stream.  It was evaluated on a 1-socket machine
> to avoid dealing with NUMA-related issues and the timing of reclaim. The
> storage was an SSD Samsung Evo and a fresh trimmed XFS filesystem was
> used for the test data.
> 
> This is not an exact replication of Dave's setup. The configuration
> scales its parameters depending on the memory size of the SUT to behave
> similarly across machines. The parameters mean the first sample reported
> by fs_mark is using 50% of RAM which will barely be throttled and look
> like a big outlier. Dave used fake NUMA to have multiple kswapd instances
> which I didn't replicate.  Finally, the number of iterations differ from
> Dave's test as the target disk was not large enough.  While not identical,
> it should be representative.
> 
> fsmark
>                                    5.3.0-rc3              5.3.0-rc3
>                                      vanilla          shrinker-v1r1
> Min       1-files/sec     4444.80 (   0.00%)     4765.60 (   7.22%)
> 1st-qrtle 1-files/sec     5005.10 (   0.00%)     5091.70 (   1.73%)
> 2nd-qrtle 1-files/sec     4917.80 (   0.00%)     4855.60 (  -1.26%)
> 3rd-qrtle 1-files/sec     4667.40 (   0.00%)     4831.20 (   3.51%)
> Max-1     1-files/sec    11421.50 (   0.00%)     9999.30 ( -12.45%)
> Max-5     1-files/sec    11421.50 (   0.00%)     9999.30 ( -12.45%)
> Max-10    1-files/sec    11421.50 (   0.00%)     9999.30 ( -12.45%)
> Max-90    1-files/sec     4649.60 (   0.00%)     4780.70 (   2.82%)
> Max-95    1-files/sec     4491.00 (   0.00%)     4768.20 (   6.17%)
> Max-99    1-files/sec     4491.00 (   0.00%)     4768.20 (   6.17%)
> Max       1-files/sec    11421.50 (   0.00%)     9999.30 ( -12.45%)
> Hmean     1-files/sec     5004.75 (   0.00%)     5075.96 (   1.42%)
> Stddev    1-files/sec     1778.70 (   0.00%)     1369.66 (  23.00%)
> CoeffVar  1-files/sec       33.70 (   0.00%)       26.05 (  22.71%)
> BHmean-99 1-files/sec     5053.72 (   0.00%)     5101.52 (   0.95%)
> BHmean-95 1-files/sec     5053.72 (   0.00%)     5101.52 (   0.95%)
> BHmean-90 1-files/sec     5107.05 (   0.00%)     5131.41 (   0.48%)
> BHmean-75 1-files/sec     5208.45 (   0.00%)     5206.68 (  -0.03%)
> BHmean-50 1-files/sec     5405.53 (   0.00%)     5381.62 (  -0.44%)
> BHmean-25 1-files/sec     6179.75 (   0.00%)     6095.14 (  -1.37%)
> 
>                    5.3.0-rc3   5.3.0-rc3
>                      vanillashrinker-v1r1
> Duration User         501.82      497.29
> Duration System      4401.44     4424.08
> Duration Elapsed     8124.76     8358.05
> 
> This is showing a slight skew for the max result representing a
> large outlier for the 1st, 2nd and 3rd quartile are similar indicating
> that the bulk of the results show little difference. Note that an
> earlier version of the fsmark configuration showed a regression but
> that included more samples taken while memory was still filling.
> 
> Note that the elapsed time is higher. Part of this is that the
> configuration included time to delete all the test files when the test
> completes -- the test automation handles the possibility of testing fsmark
> with multiple thread counts. Without the patch, many of these objects
> would be memory resident which is part of what the patch is addressing.
> 
> There are other important observations that justify the patch.
> 
> 1. With the vanilla kernel, the number of dirty pages in the system
>    is very low for much of the test. With this patch, dirty pages
>    is generally kept at 10% which matches vm.dirty_background_ratio
>    which is normal expected historical behaviour.
> 
> 2. With the vanilla kernel, the ratio of Slab/Pagecache is close to
>    0.95 for much of the test i.e. Slab is being left alone and dominating
>    memory consumption. With the patch applied, the ratio varies between
>    0.35 and 0.45 with the bulk of the measured ratios roughly half way
>    between those values. This is a different balance to what Dave reported
>    but it was at least consistent.
> 
> 3. Slabs are scanned throughout the entire test with the patch applied.
>    The vanille kernel has periods with no scan activity and then relatively
>    massive spikes.
> 
> 4. Without the patch, kswapd scan rates are very variable. With the patch,
>    the scan rates remain quite stead.
> 
> 4. Overall vmstats are closer to normal expectations
> 
> 	                                5.3.0-rc3      5.3.0-rc3
> 	                                  vanilla  shrinker-v1r1
>     Ops Direct pages scanned             99388.00      328410.00
>     Ops Kswapd pages scanned          45382917.00    33451026.00
>     Ops Kswapd pages reclaimed        30869570.00    25239655.00
>     Ops Direct pages reclaimed           74131.00        5830.00
>     Ops Kswapd efficiency %                 68.02          75.45
>     Ops Kswapd velocity                   5585.75        4002.25
>     Ops Page reclaim immediate         1179721.00      430927.00
>     Ops Slabs scanned                 62367361.00    73581394.00
>     Ops Direct inode steals               2103.00        1002.00
>     Ops Kswapd inode steals             570180.00     5183206.00
> 
> 	o Vanilla kernel is hitting direct reclaim more frequently,
> 	  not very much in absolute terms but the fact the patch
> 	  reduces it is interesting
> 	o "Page reclaim immediate" in the vanilla kernel indicates
> 	  dirty pages are being encountered at the tail of the LRU.
> 	  This is generally bad and means in this case that the LRU
> 	  is not long enough for dirty pages to be cleaned by the
> 	  background flush in time. This is much reduced by the
> 	  patch.
> 	o With the patch, kswapd is reclaiming 10 times more slab
> 	  pages than with the vanilla kernel. This is indicative
> 	  of the watermark boosting over-protecting slab
> 
> A more complete set of tests were run that were part of the basis
> for introducing boosting and while there are some differences, they
> are well within tolerances.
> 
> Bottom line, the special casing kswapd to avoid slab behaviour is
> unpredictable and can lead to abnormal results for normal workloads. This
> patch restores the expected behaviour that slab and page cache is
> balanced consistently for a workload with a steady allocation ratio of
> slab/pagecache pages. It also means that if there are workloads that
> favour the preservation of slab over pagecache that it can be tuned via
> vm.vfs_cache_pressure where as the vanilla kernel effectively ignores
> the parameter when boosting is active.
> 
> Fixes: 1c30844d2dfe ("mm: reclaim small amounts of memory when an external fragmentation event occurs")
> Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> Cc: stable@vger.kernel.org # v5.0+

Acked-by: Vlastimil Babka <vbabka@suse.cz>
