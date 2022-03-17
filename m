Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A7DC4DBD5C
	for <lists+linux-xfs@lfdr.de>; Thu, 17 Mar 2022 04:08:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233130AbiCQDJs (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 16 Mar 2022 23:09:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbiCQDJq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Mar 2022 23:09:46 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4619D21242
        for <linux-xfs@vger.kernel.org>; Wed, 16 Mar 2022 20:08:30 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-150-27.pa.vic.optusnet.com.au [49.186.150.27])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 812D910E46BA;
        Thu, 17 Mar 2022 14:08:29 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nUgV2-006OGF-P5; Thu, 17 Mar 2022 14:08:28 +1100
Date:   Thu, 17 Mar 2022 14:08:28 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Manfred Spraul <manfred@colorfullife.com>
Cc:     linux-xfs@vger.kernel.org,
        "Spraul Manfred (XC/QMM21-CT)" <Manfred.Spraul@de.bosch.com>
Subject: Re: Metadata CRC error detected at
 xfs_dir3_block_read_verify+0x9e/0xc0 [xfs], xfs_dir3_block block 0x86f58
Message-ID: <20220317030828.GZ3927073@dread.disaster.area>
References: <613af505-7646-366c-428a-b64659e1f7cf@colorfullife.com>
 <20220313224624.GJ3927073@dread.disaster.area>
 <8024317e-07be-aa3d-9aa3-2f835aaa1278@colorfullife.com>
 <3242ad20-0039-2579-b125-b7a9447a7230@colorfullife.com>
 <20220317024705.GY3927073@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220317024705.GY3927073@dread.disaster.area>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=6232a62d
        a=sPqof0Mm7fxWrhYUF33ZaQ==:117 a=sPqof0Mm7fxWrhYUF33ZaQ==:17
        a=kj9zAlcOel0A:10 a=o8Y5sQTvuykA:10 a=7-415B0cAAAA:8
        a=tctxP7Ghy1wDT3JLoegA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 17, 2022 at 01:47:05PM +1100, Dave Chinner wrote:
> On Wed, Mar 16, 2022 at 09:55:04AM +0100, Manfred Spraul wrote:
> > Hi Dave,
> > 
> > On 3/14/22 16:18, Manfred Spraul wrote:
> > > Hi Dave,
> > > 
> > > On 3/13/22 23:46, Dave Chinner wrote:
> > > > OK, this test is explicitly tearing writes at the storage level.
> > > > When there is an update to multiple sectors of the metadata block,
> > > > the metadata will be inconsistent on disk while those individual
> > > > sector writes are replayed.
> > > 
> > > Thanks for the clarification.
> > > 
> > > I'll modify the test application to never tear write operations and
> > > retry.
> > > 
> > > If there are findings, then I'll distribute them.
> > > 
> > I've modified the test app, and with 4000 simulated power failures I have
> > not seen any corruptions.
> > 
> > 
> > Thus:
> > 
> > - With teared write operations: 2 corruptions from ~800 simulated power
> > failures
> > 
> > - Without teared write operations: no corruptions from ~4000 simulated power
> > failures.
> 
> Good to hear.
> 
> > But:
> > 
> > I've checked the eMMC specification, and the spec allows that teared write
> > happen:
> 
> Yes, most storage only guarantees that sector writes are atomic and
> so multi-sector writes have no guarantees of being written
> atomically.  IOWs, all storage technologies that currently exist are
> allowed to tear multi-sector writes.
> 
> However, FUA writes are guaranteed to be whole on persistent storage
> regardless of size when the hardware signals completion. And any
> write that the hardware has signalled as complete before a cache
> flush is received is also guaranteed to be whole on persistent
> storage when the cache flush is signalled as complete by the
> hardware. These mechanisms provide protection against torn writes.
> 
> IOWs, it's up to filesystems to guarantee data is on stable storage
> before they trust it fully. Filesystems are pretty good at using
> REQ_FLUSH, REQ_FUA and write completion ordering to ensure that
> anything they need whole and complete on stable storage is actually
> whole and complete.
> 
> In the cases where torn writes occur because that haven't been
> covered by a FUA or cache flush guarantee (such as your test),
> filesystems need mechanisms in their metadata to detect such events.
> CRCs are the prime mechanism for this - that's what XFS uses, and it
> was XFS reporting a CRC failure when reading torn metadata that
> started this whole thread.
> 
> > Is my understanding correct that XFS support neither eMMC nor NVM devices?
> > (unless there is a battery backup that exceeds the guarantees from the spec)
> 
> Incorrect.
> 
> They are supported just fine because flush/FUA semantics provide
> guarantees against torn writes in normal operation. IOWs, torn
> writes are something that almost *never* happen in real life, even
> when power fails suddenly. Despite this, XFS can detect it has
> occurred (because broken storage is all too common!), and if it
> can't recovery automatically, it will shut down and ask the user to
> correct the problem.
> 
> BTRFS and ZFS can also detect torn writes, and if you use the
> (non-default) ext4 option "metadata_csum" it will also detect torn

Correction - metadata_csum is ienabled by default, I just ran the
wrong mkfs command when I tested it a few moments ago.

-Dave.

> writes to metadata via CRC failures. There are other filesystems
> that can detect and correct torn writes, too.
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

-- 
Dave Chinner
david@fromorbit.com
