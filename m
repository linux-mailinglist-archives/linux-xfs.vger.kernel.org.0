Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CECDA57FFB8
	for <lists+linux-xfs@lfdr.de>; Mon, 25 Jul 2022 15:22:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234459AbiGYNWz (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 25 Jul 2022 09:22:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232494AbiGYNWy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Jul 2022 09:22:54 -0400
Received: from fieldses.org (fieldses.org [IPv6:2600:3c00:e000:2f7::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6518B7F9;
        Mon, 25 Jul 2022 06:22:53 -0700 (PDT)
Received: by fieldses.org (Postfix, from userid 2815)
        id BE2E05FF7; Mon, 25 Jul 2022 09:22:52 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 fieldses.org BE2E05FF7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fieldses.org;
        s=default; t=1658755372;
        bh=yDJEX2/cvBXlCfMVF9jGES/FxWBs1Wvkl/6iyGpxSBM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VrAug+UyPCOv8AvVFNrO0TgTcHqMURKlVNDKDnHHdPDAlE+sLtvqS5fS/lvRAjHb5
         Z1ROgtp7YhD/StNSxHtuQweWr5cv6Whi3H5l3zrAppqATqHzgHfZqST679FNOm/ryR
         WeZuObt/W6AfEO16M9YLXoPBymdaYrKYCj/tqGEw=
Date:   Mon, 25 Jul 2022 09:22:52 -0400
From:   Bruce Fields <bfields@fieldses.org>
To:     Chuck Lever III <chuck.lever@oracle.com>
Cc:     linux-xfs@vger.kernel.org, linux-nfs@vger.kernel.org
Subject: Re: all cel/for-rc (1197eb59 lockd: fix nlm_close_files) results
Message-ID: <20220725132252.GB17056@fieldses.org>
References: <20220724125542.89A6FA0482@home.fieldses.org>
 <20220724125848.GA14741@fieldses.org>
 <FFC9022A-B2AB-4455-870B-6801B327C5B7@oracle.com>
 <20220724163401.GA17655@fieldses.org>
 <20220724163702.GB17655@fieldses.org>
 <0CFBAAC2-1ECF-48E1-A687-75176C2F1A17@oracle.com>
 <20220725021029.GA789@fieldses.org>
 <20220725121600.GA17056@fieldses.org>
 <608CA2C9-464C-464E-B4AD-CF1B8C494A5A@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <608CA2C9-464C-464E-B4AD-CF1B8C494A5A@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Adding linux-xfs in case anyone has an idea....  I'm seeing this on an
NFS server.  I believe the client was in generic/187 or generic/460.

On Mon, Jul 25, 2022 at 01:14:27PM +0000, Chuck Lever III wrote:
> 
> 
> > On Jul 25, 2022, at 8:16 AM, Bruce Fields <bfields@fieldses.org> wrote:
> > 
> > And again:
> > 
> > [ 3987.996455] INFO: task kworker/u8:2:40 blocked for more than 120
> > seconds.
> > [ 3987.998415]       Not tainted 5.19.0-rc6-00014-g51fd2eb52c0c #3560
> > [ 3988.000005] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> > disables this message.
> > [ 3988.002131] task:kworker/u8:2    state:D stack:24784 pid:   40 ppid:
> > 2 flags:0x00004000
> > [ 3988.004628] Workqueue: xfs-cil/vdf xlog_cil_push_work
> > [ 3988.005841] Call Trace:
> > [ 3988.005968]  <TASK>
> > [ 3988.006052]  __schedule+0xb73/0x2260
> > [ 3988.006251]  ? io_schedule_timeout+0x150/0x150
> > [ 3988.006511]  schedule+0xe0/0x200
> > [ 3988.006676]  xlog_wait_on_iclog+0x435/0x600
> > [ 3988.006914]  ? xfs_log_mount+0x550/0x550
> > [ 3988.007119]  ? mark_held_locks+0x9e/0xe0
> > [ 3988.007311]  ? wake_up_q+0xf0/0xf0
> > [ 3988.007470]  ? rwlock_bug.part.0+0x90/0x90
> > [ 3988.007704]  ? kmem_cache_free.part.0+0x99/0x1a0
> > [ 3988.007977]  xlog_cil_push_work+0xcf4/0x14f0
> > [ 3988.008206]  ? xlog_cil_write_commit_record+0x310/0x310
> > [ 3988.008565]  ? lock_downgrade+0x6a0/0x6a0
> > [ 3988.008796]  ? lock_is_held_type+0xd8/0x130
> > [ 3988.009030]  process_one_work+0x7ee/0x12d0
> > [ 3988.009238]  ? lock_downgrade+0x6a0/0x6a0
> > [ 3988.009432]  ? pwq_dec_nr_in_flight+0x230/0x230
> > [ 3988.009667]  ? rwlock_bug.part.0+0x90/0x90
> > [ 3988.009896]  worker_thread+0xfc/0x1270
> > [ 3988.010259]  ? process_one_work+0x12d0/0x12d0
> > [ 3988.010591]  kthread+0x298/0x340
> > [ 3988.010754]  ? kthread_complete_and_exit+0x20/0x20
> > [ 3988.011018]  ret_from_fork+0x22/0x30
> > [ 3988.011201]  </TASK>
> > [ 3988.011298] INFO: task nfsd:23110 blocked for more than 120 seconds.
> > [ 3988.011746]       Not tainted 5.19.0-rc6-00014-g51fd2eb52c0c #3560
> > [ 3988.012232] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> > disables this message.
> > [ 3988.012828] task:nfsd            state:D stack:24400 pid:23110 ppid:
> > 2 flags:0x00004000
> > [ 3988.013426] Call Trace:
> > [ 3988.013521]  <TASK>
> > [ 3988.013636]  __schedule+0xb73/0x2260
> > [ 3988.013850]  ? io_schedule_timeout+0x150/0x150
> > [ 3988.014160]  ? reacquire_held_locks+0x4e0/0x4e0
> > [ 3988.014409]  ? do_raw_spin_lock+0x11e/0x240
> > [ 3988.014732]  schedule+0xe0/0x200
> > [ 3988.014905]  io_schedule+0xbf/0x130
> > [ 3988.015152]  folio_wait_bit_common+0x305/0x610
> > [ 3988.015387]  ? replace_page_cache_page+0xd30/0xd30
> > [ 3988.015754]  ? folio_unlock+0x70/0x70
> > [ 3988.016016]  ? lock_is_held_type+0xd8/0x130
> > [ 3988.016385]  folio_wait_writeback+0x40/0x230
> > [ 3988.016604]  __filemap_fdatawait_range+0x10a/0x290
> > [ 3988.017149]  ? file_check_and_advance_wb_err+0x270/0x270
> > [ 3988.017448]  ? lock_release+0x380/0x750
> > [ 3988.017708]  file_write_and_wait_range+0xb4/0xf0
> > [ 3988.018028]  xfs_file_fsync+0x146/0x830
> > [ 3988.018279]  ? xfs_file_read_iter+0x450/0x450
> > [ 3988.018569]  ? lock_is_held_type+0xd8/0x130
> > [ 3988.018841]  nfsd_commit+0x304/0x550 [nfsd]
> > [ 3988.019161]  ? nfsd_write+0x4f0/0x4f0 [nfsd]
> > [ 3988.019394]  ? percpu_counter_add_batch+0x77/0x130
> > [ 3988.019736]  nfsd4_proc_compound+0xcbd/0x2070 [nfsd]
> > [ 3988.020121]  nfsd_dispatch+0x4b9/0xb90 [nfsd]
> > [ 3988.020409]  svc_process_common+0xb23/0x1ac0 [sunrpc]
> > [ 3988.020781]  ? svc_create_pooled+0x4d0/0x4d0 [sunrpc]
> > [ 3988.021165]  ? nfsd_svc+0xc60/0xc60 [nfsd]
> > [ 3988.021381]  ? svc_sock_secure_port+0x2a/0x40 [sunrpc]
> > [ 3988.021746]  ? svc_recv+0x119f/0x2890 [sunrpc]
> > [ 3988.022015]  svc_process+0x32d/0x4a0 [sunrpc]
> > [ 3988.022336]  nfsd+0x2d6/0x570 [nfsd]
> > [ 3988.022564]  ? nfsd_shutdown_threads+0x290/0x290 [nfsd]
> > [ 3988.022874]  kthread+0x298/0x340
> > [ 3988.023018]  ? kthread_complete_and_exit+0x20/0x20
> > [ 3988.023332]  ret_from_fork+0x22/0x30
> > [ 3988.023513]  </TASK>
> > ...
> 
> All three call traces you've sent me show an NFSv4 COMMIT
> waiting in folio_wait_bit_common(). Should you report this
> to the XFS folks? Or maybe a little bisecting might help.

Reproducing is a little slow and not 100% reliable.  I'm not sure I'll
get to it.

--b.
