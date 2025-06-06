Return-Path: <linux-xfs+bounces-22876-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3997CACFAB3
	for <lists+linux-xfs@lfdr.de>; Fri,  6 Jun 2025 03:25:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9246A3AF74F
	for <lists+linux-xfs@lfdr.de>; Fri,  6 Jun 2025 01:24:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCE692629F;
	Fri,  6 Jun 2025 01:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="Dz+p4f2U"
X-Original-To: linux-xfs@vger.kernel.org
Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F25917BCE;
	Fri,  6 Jun 2025 01:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749173098; cv=pass; b=V0YFfJAWzt42Oepprkbjmz7haJFVnFYA7ijB2eYS37oIC1WlMOWmJdAWikQQybNzsCCwvBAVcI79WVrd5YT+kjWvcpvAFATxG0Rbu1PWUslvxrYW4TEYO5tkn63W7fsVfz/CfcDeyseZrmbiYkrg9CeSpTju/otosZ+JAMGL4f8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749173098; c=relaxed/simple;
	bh=9NDWXfTVhM6lUQ/jG3bXQ3J0pFW1hx259ALkU1you9I=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type; b=F/EgFXUNAlmTFl8jc0otZHpklHkOsNXVYzttcOrzuSMOYuquqPYnH1mk2o2puvEpGSs6Q0mOfJDCOYrfvzmfyusvhBYhS1IljACfcjHdIWkyEb9w3SOIbSC53I9HFkDpmKMLdU5E+dfgHKqqXnPUzgGYK5IhqljvW4swOAft9R8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=Dz+p4f2U; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
ARC-Seal: i=1; a=rsa-sha256; t=1749173089; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=B2oKUMtO4nyG7duDLwxw9dwXNSoa3pIZuxZy6hf2fe4cdXhbYEX8YrFMDnBrO5ek65ySYT+FoKa0LOO1OfIqKsuWGIUvIyJxctOWsofYGUkuo8rnJIkA/Tlvmtbf4TapCOWn7knuhfXP1Lzjr2AXHZBn1GuQ3EnuZXb23Jhy6gE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1749173089; h=Content-Type:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=4UJsbGaIU8caWqiDrlwUCjpL3ff9m8HZ0BxZTE1fkc0=; 
	b=RrvVyNit3SYUmvG6VXv6fckkWtH6DcgwF5WiT0wTeXigY+E8yOCmxqaAyO89VPtNRAvJV2sCioHz0FPgEpMOQDYaBu/s8fpdajcHBgwxOJ9+FEYUijt6ZNKfLdE2gfkraYbyPgXPAYJClyr4StY/Wq89MCDygPkIHtN/wKCjP0Y=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1749173089;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=Date:Date:Message-ID:From:From:To:To:Cc:Cc:Subject:Subject:In-Reply-To:References:MIME-Version:Content-Type:Message-Id:Reply-To;
	bh=4UJsbGaIU8caWqiDrlwUCjpL3ff9m8HZ0BxZTE1fkc0=;
	b=Dz+p4f2Uxn8bUTxVA9CXnVJXcb5ENfZm+gfFh1Jk+TVmEZkgAJyMqO+t27kTr4rn
	mm+rxPsgmmM6e09L6iifUkulIutMlLMpKJCAdCGgbPdmxihIbEtu0i/lOQrktDf7ATS
	sd4lHpTkmtrc0gIh8xODtBKLmojRApAm27alMnes=
Received: by mx.zohomail.com with SMTPS id 1749173085655640.7830819937315;
	Thu, 5 Jun 2025 18:24:45 -0700 (PDT)
Date: Fri, 06 Jun 2025 09:24:42 +0800
Message-ID: <87a56lpspx.wl-me@linux.beauty>
From: Li Chen <me@linux.beauty>
To: Zorro Lang <zlang@redhat.com>
Cc: Li Chen <me@linux.beauty>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] generic/738: warn & lazy-umount if thaw hangs on buggy XFS
In-Reply-To: <20250605154947.bddkusxeryj2emzb@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20250601070059.341669-1-me@linux.beauty>
	<20250605154947.bddkusxeryj2emzb@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
User-Agent: Wanderlust/2.15.9 (Almost Unreal) SEMI-EPG/1.14.7 (Harue)
 FLIM-LB/1.14.9 (=?ISO-8859-4?Q?Goj=F2?=) APEL-LB/10.8 EasyPG/1.0.0
 Emacs/30.1 (x86_64-pc-linux-gnu) MULE/6.0 (HANACHIRUSATO)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=ISO-2022-JP
X-ZohoMailClient: External

Hi Zorro,

On Thu, 05 Jun 2025 23:49:47 +0800,
Zorro Lang wrote:
> 
> On Sun, Jun 01, 2025 at 03:00:59PM +0800, Li Chen wrote:
> > From: Li Chen <chenl311@chinatelecom.cn>
> > 
> > If `xfs_freeze -u` goes D-state (because of freeze-reclaim deadlock)
> > the test never finishes and the harness stalls.
> > Run thaw in background, wait 10 s, and when it$B!G(Bs still alive:
> > 
> >   * emit a warning plus the fixing commit
> >       ab23a7768739  $B!H(Bxfs: per-cpu deferred inode inactivation queues$B!I(B
> >   * `umount -l` the scratch FS so the rest of xfstests can proceed
> >   * skip any `wait` that would block on the hung tasks.
> > 
> > Fixed kernels behave as before; broken ones no longer wedge the run.
> > 
> > The hung task call trace would be as below:
> > [   20.535519]       Not tainted 5.14.0-rc4+ #27
> > [   20.537855] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > [   20.539420] task:738             state:D stack:14544 pid: 7124 ppid:   753 flags:0x00004002
> > [   20.540892] Call Trace:
> > [   20.541424]  __schedule+0x22d/0x6c0
> > [   20.542128]  schedule+0x3f/0xa0
> > [   20.542751]  percpu_rwsem_wait+0x100/0x130
> > [   20.543516]  ? percpu_free_rwsem+0x30/0x30
> > [   20.544259]  __percpu_down_read+0x44/0x50
> > [   20.545002]  xfs_trans_alloc+0x19a/0x1f0
> > [   20.545747]  xfs_free_eofblocks+0x47/0x100
> > [   20.546519]  xfs_inode_mark_reclaimable+0x115/0x160
> > [   20.547398]  destroy_inode+0x36/0x70
> > [   20.548077]  prune_icache_sb+0x79/0xb0
> > [   20.548789]  super_cache_scan+0x159/0x1e0
> > [   20.549536]  shrink_slab.constprop.0+0x1b1/0x370
> > [   20.550363]  drop_slab_node+0x1d/0x40
> > [   20.551041]  drop_slab+0x30/0x70
> > [   20.551600]  drop_caches_sysctl_handler+0x6b/0x80
> > [   20.552311]  proc_sys_call_handler+0x12b/0x250
> > [   20.552931]  new_sync_write+0x117/0x1b0
> > [   20.553462]  vfs_write+0x1bd/0x250
> > [   20.553914]  ksys_write+0x5a/0xd0
> > [   20.554381]  do_syscall_64+0x3b/0x90
> > [   20.554854]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> > [   20.555481] RIP: 0033:0x7f90928d3300
> > [   20.555946] RSP: 002b:00007ffc2b50b998 EFLAGS: 00000202 ORIG_RAX: 0000000000000001
> > [   20.556853] RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 00007f90928d3300
> > [   20.557686] RDX: 0000000000000002 RSI: 000055a5d6c47750 RDI: 0000000000000001
> > [   20.558524] RBP: 000055a5d6c47750 R08: 0000000000000007 R09: 0000000000000073
> > [   20.559335] R10: 0000000000000000 R11: 0000000000000202 R12: 0000000000000002
> > [   20.560154] R13: 00007f90929ae760 R14: 0000000000000002 R15: 00007f90929a99e0
> > 
> > localhost login: [   30.773559] INFO: task 738:7124 blocked for more than 20 seconds.
> > [   30.775236]       Not tainted 5.14.0-rc4+ #27
> > [   30.777449] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > [   30.779729] task:738             state:D stack:14544 pid: 7124 ppid:   753 flags:0x00004002
> > [   30.781267] Call Trace:
> > [   30.781850]  __schedule+0x22d/0x6c0
> > [   30.782618]  schedule+0x3f/0xa0
> > [   30.783297]  percpu_rwsem_wait+0x100/0x130
> > [   30.784110]  ? percpu_free_rwsem+0x30/0x30
> > [   30.785085]  __percpu_down_read+0x44/0x50
> > [   30.786071]  xfs_trans_alloc+0x19a/0x1f0
> > [   30.786877]  xfs_free_eofblocks+0x47/0x100
> > [   30.787727]  xfs_inode_mark_reclaimable+0x115/0x160
> > [   30.788708]  destroy_inode+0x36/0x70
> > [   30.789395]  prune_icache_sb+0x79/0xb0
> > [   30.790056]  super_cache_scan+0x159/0x1e0
> > [   30.790712]  shrink_slab.constprop.0+0x1b1/0x370
> > [   30.791381]  drop_slab_node+0x1d/0x40
> > [   30.791924]  drop_slab+0x30/0x70
> > [   30.792469]  drop_caches_sysctl_handler+0x6b/0x80
> > [   30.793328]  proc_sys_call_handler+0x12b/0x250
> > [   30.793948]  new_sync_write+0x117/0x1b0
> > [   30.794471]  vfs_write+0x1bd/0x250
> > [   30.794941]  ksys_write+0x5a/0xd0
> > [   30.795414]  do_syscall_64+0x3b/0x90
> > [   30.795928]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> > [   30.796595] RIP: 0033:0x7f90928d3300
> > [   30.797090] RSP: 002b:00007ffc2b50b998 EFLAGS: 00000202 ORIG_RAX: 0000000000000001
> > [   30.798033] RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 00007f90928d3300
> > [   30.798852] RDX: 0000000000000002 RSI: 000055a5d6c47750 RDI: 0000000000000001
> > [   30.799703] RBP: 000055a5d6c47750 R08: 0000000000000007 R09: 0000000000000073
> > [   30.800833] R10: 0000000000000000 R11: 0000000000000202 R12: 0000000000000002
> > [   30.801764] R13: 00007f90929ae760 R14: 0000000000000002 R15: 00007f90929a99e0
> > [   30.802628] INFO: task xfs_io:7130 blocked for more than 10 seconds.
> > [   30.803421]       Not tainted 5.14.0-rc4+ #27
> > [   30.803985] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > [   30.804979] task:xfs_io          state:D stack:13712 pid: 7130 ppid:  7127 flags:0x00000002
> > [   30.806013] Call Trace:
> > [   30.806399]  __schedule+0x22d/0x6c0
> > [   30.806867]  schedule+0x3f/0xa0
> > [   30.807334]  rwsem_down_write_slowpath+0x1d8/0x510
> > [   30.808018]  thaw_super+0xd/0x20
> > [   30.808748]  __x64_sys_ioctl+0x5d/0xb0
> > [   30.809292]  do_syscall_64+0x3b/0x90
> > [   30.809797]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> > [   30.810454] RIP: 0033:0x7ff1b48c5d1b
> > [   30.810943] RSP: 002b:00007fff0bf88ac0 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> > [   30.811874] RAX: ffffffffffffffda RBX: 000055b93ae5fc40 RCX: 00007ff1b48c5d1b
> > [   30.812743] RDX: 00007fff0bf88b2c RSI: ffffffffc0045878 RDI: 0000000000000003
> > [   30.813583] RBP: 000055b93ae60fe0 R08: 0000000000000000 R09: 0000000000000000
> > [   30.814497] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000001
> > [   30.815413] R13: 000055b93a3a94e9 R14: 0000000000000000 R15: 000055b93ae61150
> > ---
> >  tests/generic/738 | 20 ++++++++++++++++++--
> >  1 file changed, 18 insertions(+), 2 deletions(-)
> > 
> > diff --git a/tests/generic/738 b/tests/generic/738
> > index 6f1ea7f8..9a90eefa 100755
> > --- a/tests/generic/738
> > +++ b/tests/generic/738
> > @@ -11,8 +11,24 @@ _begin_fstest auto quick freeze
> >  
> >  _cleanup()
> >  {
> > -	xfs_freeze -u $SCRATCH_MNT 2>/dev/null
> > -	wait
> > +    # Thaw may dead-lock on unfixed XFS kernels.  Run it in background,
> > +    # wait a tiny bit, then decide whether it is stuck.
> > +    xfs_freeze -u $SCRATCH_MNT 2>/dev/null &
> > +    _thaw_pid=$!
> > +
> > +    sleep 8
> > +
> > +    if [ -e "/proc/$_thaw_pid" ]; then
> > +            # still running $B"*(B stuck in D-state
> > +            if [ "$FSTYP" = "xfs" ]; then
> > +                    echo "generic/738: known XFS freeze-reclaim deadlock; " \
> > +                         "fixed by kernel commit ab23a7768739 " \
> > +                         '"xfs: per-cpu deferred inode inactivation queues"' \
> 
> If want to mark a known fix, you can add below line to this case:
> 
> _fixed_by_kernel_commit ab23a7768739 \
> 	"xfs: per-cpu deferred inode inactivation queues"

I have already tried that way, but it doesn't have any chance to output the fixd commit
because it already hang inside xfs_freeze, that's why I change to run this
command in background then sleep.

> 
> But for this patch, I don't think we should do this for a bug. If it blocks your
> testing on someone downstream system, you can skip this test. CC xfs list if you
> need more review points for this xfs bug.

Without this patch, users will not know the cause of the hang easily from the stdout/stderr.
I have already bisected and confirms this patch resolves the issue.

Regards,
Li

