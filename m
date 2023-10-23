Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AB5E7D2B3D
	for <lists+linux-xfs@lfdr.de>; Mon, 23 Oct 2023 09:27:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233462AbjJWH1D (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 23 Oct 2023 03:27:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233465AbjJWH1C (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Oct 2023 03:27:02 -0400
Received: from esa3.hc1455-7.c3s2.iphmx.com (esa3.hc1455-7.c3s2.iphmx.com [207.54.90.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 137E5D68
        for <linux-xfs@vger.kernel.org>; Mon, 23 Oct 2023 00:26:59 -0700 (PDT)
X-IronPort-AV: E=McAfee;i="6600,9927,10871"; a="137205735"
X-IronPort-AV: E=Sophos;i="6.03,244,1694703600"; 
   d="scan'208";a="137205735"
Received: from unknown (HELO yto-r1.gw.nic.fujitsu.com) ([218.44.52.217])
  by esa3.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2023 16:26:58 +0900
Received: from yto-m3.gw.nic.fujitsu.com (yto-nat-yto-m3.gw.nic.fujitsu.com [192.168.83.66])
        by yto-r1.gw.nic.fujitsu.com (Postfix) with ESMTP id AF02ED9DA9;
        Mon, 23 Oct 2023 16:26:54 +0900 (JST)
Received: from kws-ab3.gw.nic.fujitsu.com (kws-ab3.gw.nic.fujitsu.com [192.51.206.21])
        by yto-m3.gw.nic.fujitsu.com (Postfix) with ESMTP id 02023D21AD;
        Mon, 23 Oct 2023 16:26:54 +0900 (JST)
Received: from edo.cn.fujitsu.com (edo.cn.fujitsu.com [10.167.33.5])
        by kws-ab3.gw.nic.fujitsu.com (Postfix) with ESMTP id 7C5FA20076852;
        Mon, 23 Oct 2023 16:26:53 +0900 (JST)
Received: from [192.168.50.5] (unknown [10.167.226.34])
        by edo.cn.fujitsu.com (Postfix) with ESMTP id D96A21A0070;
        Mon, 23 Oct 2023 15:26:52 +0800 (CST)
Message-ID: <834497bc-0876-43bb-bd67-154ad7f26af3@fujitsu.com>
Date:   Mon, 23 Oct 2023 15:26:52 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15] mm, pmem, xfs: Introduce MF_MEM_PRE_REMOVE for unbind
To:     Chandan Babu R <chandanbabu@kernel.org>
Cc:     akpm@linux-foundation.org, "Darrick J. Wong" <djwong@kernel.org>,
        linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
        linux-xfs@vger.kernel.org, linux-mm@kvack.org,
        dan.j.williams@intel.com, willy@infradead.org, jack@suse.cz,
        mcgrof@kernel.org
References: <20230828065744.1446462-1-ruansy.fnst@fujitsu.com>
 <20230928103227.250550-1-ruansy.fnst@fujitsu.com>
 <875y31wr2d.fsf@debian-BULLSEYE-live-builder-AMD64>
 <20231020154009.GS3195650@frogsfrogsfrogs>
 <87msw9zvpk.fsf@debian-BULLSEYE-live-builder-AMD64>
From:   Shiyang Ruan <ruansy.fnst@fujitsu.com>
In-Reply-To: <87msw9zvpk.fsf@debian-BULLSEYE-live-builder-AMD64>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSS-9.1.0.1417-9.0.0.1002-27952.005
X-TM-AS-User-Approved-Sender: Yes
X-TMASE-Version: IMSS-9.1.0.1417-9.0.1002-27952.005
X-TMASE-Result: 10--28.189200-10.000000
X-TMASE-MatchedRID: rL1qmhkJqTSPvrMjLFD6eHchRkqzj/bEC/ExpXrHizw0tugJQ9WdwznG
        P45Axioi/yFtx9iVdmDVxQiG9mswQLROK334qTpuThuQJkjAOL59v5k7uQeUSMpj/9aYiP+hhgy
        5XeTMdJ2PqNrXxMR4yOGblErXgh8LMeIPuyyqyWwqy6shOlK/47Jyu9jGj0qnteXjSBMYnmmAI+
        pLfk3sB0Bh0sVevfs+8qJOyQU+3TGSag5+i6uYdAPZZctd3P4B+LidURF+DB2+U1asDs8Y/EHE/
        BQYbIDwO3wTUW8jWH7SG0KbgBF5jIo5z9AAPkJBCtzGvPCy/m6MhbTsXysU38MCKZLERpBPU9a6
        zfLFA1ba2H5wcV0ekF88doC4WsZaYw1f/0r5B94vz6alF1rVgzVEnbrqmBw73unRG7yMq8Vqi2X
        vg/6dOmsflbxbbYmSC6Kd+BnbGseuD0sHS7NwhHaNJ/iTxXCafS0Ip2eEHnzUHQeTVDUrIqHkM5
        YY92pZtwKUvHHyXGXdB/CxWTRRu/558CedkGIvqcoAhihTwvgXmJebktkAIA==
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



在 2023/10/23 14:40, Chandan Babu R 写道:
> 
> On Fri, Oct 20, 2023 at 08:40:09 AM -0700, Darrick J. Wong wrote:
>> On Fri, Oct 20, 2023 at 03:26:32PM +0530, Chandan Babu R wrote:
>>> On Thu, Sep 28, 2023 at 06:32:27 PM +0800, Shiyang Ruan wrote:
>>>> ====
>>>> Changes since v14:
>>>>   1. added/fixed code comments per Dan's comments
>>>> ====
>>>>
>>>> Now, if we suddenly remove a PMEM device(by calling unbind) which
>>>> contains FSDAX while programs are still accessing data in this device,
>>>> e.g.:
>>>> ```
>>>>   $FSSTRESS_PROG -d $SCRATCH_MNT -n 99999 -p 4 &
>>>>   # $FSX_PROG -N 1000000 -o 8192 -l 500000 $SCRATCH_MNT/t001 &
>>>>   echo "pfn1.1" > /sys/bus/nd/drivers/nd_pmem/unbind
>>>> ```
>>>> it could come into an unacceptable state:
>>>>    1. device has gone but mount point still exists, and umount will fail
>>>>         with "target is busy"
>>>>    2. programs will hang and cannot be killed
>>>>    3. may crash with NULL pointer dereference
>>>>
>>>> To fix this, we introduce a MF_MEM_PRE_REMOVE flag to let it know that we
>>>> are going to remove the whole device, and make sure all related processes
>>>> could be notified so that they could end up gracefully.
>>>>
>>>> This patch is inspired by Dan's "mm, dax, pmem: Introduce
>>>> dev_pagemap_failure()"[1].  With the help of dax_holder and
>>>> ->notify_failure() mechanism, the pmem driver is able to ask filesystem
>>>> on it to unmap all files in use, and notify processes who are using
>>>> those files.
>>>>
>>>> Call trace:
>>>> trigger unbind
>>>>   -> unbind_store()
>>>>    -> ... (skip)
>>>>     -> devres_release_all()
>>>>      -> kill_dax()
>>>>       -> dax_holder_notify_failure(dax_dev, 0, U64_MAX, MF_MEM_PRE_REMOVE)
>>>>        -> xfs_dax_notify_failure()
>>>>        `-> freeze_super()             // freeze (kernel call)
>>>>        `-> do xfs rmap
>>>>        ` -> mf_dax_kill_procs()
>>>>        `  -> collect_procs_fsdax()    // all associated processes
>>>>        `  -> unmap_and_kill()
>>>>        ` -> invalidate_inode_pages2_range() // drop file's cache
>>>>        `-> thaw_super()               // thaw (both kernel & user call)
>>>>
>>>> Introduce MF_MEM_PRE_REMOVE to let filesystem know this is a remove
>>>> event.  Use the exclusive freeze/thaw[2] to lock the filesystem to prevent
>>>> new dax mapping from being created.  Do not shutdown filesystem directly
>>>> if configuration is not supported, or if failure range includes metadata
>>>> area.  Make sure all files and processes(not only the current progress)
>>>> are handled correctly.  Also drop the cache of associated files before
>>>> pmem is removed.
>>>>
>>>> [1]: https://lore.kernel.org/linux-mm/161604050314.1463742.14151665140035795571.stgit@dwillia2-desk3.amr.corp.intel.com/
>>>> [2]: https://lore.kernel.org/linux-xfs/169116275623.3187159.16862410128731457358.stg-ugh@frogsfrogsfrogs/
>>>>
>>>> Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
>>>> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
>>>> Acked-by: Dan Williams <dan.j.williams@intel.com>
>>>
>>> Hi Andrew,
>>>
>>> Shiyang had indicated that this patch has been added to
>>> akpm/mm-hotfixes-unstable branch. However, I don't see the patch listed in
>>> that branch.
>>>
>>> I am about to start collecting XFS patches for v6.7 cycle. Please let me know
>>> if you have any objections with me taking this patch via the XFS tree.
>>
>> V15 was dropped from his tree on 28 Sept., you might as well pull it
>> into your own tree for 6.7.  It's been testing fine on my trees for the
>> past 3 weeks.
>>
>> https://lore.kernel.org/mm-commits/20230928172815.EE6AFC433C8@smtp.kernel.org/
> 
> Shiyang, this patch does not apply cleanly on v6.6-rc7. Can you please rebase
> the patch on v6.6-rc7 and send it to the mailing list?

Sure.  I have rebased it and sent a v15.1.  Please check it:

https://lore.kernel.org/linux-xfs/20231023072046.1626474-1-ruansy.fnst@fujitsu.com/


--
Thanks,
Ruan.

> 
