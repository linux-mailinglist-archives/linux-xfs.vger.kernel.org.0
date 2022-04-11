Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BDA14FB656
	for <lists+linux-xfs@lfdr.de>; Mon, 11 Apr 2022 10:51:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234364AbiDKIxN (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 11 Apr 2022 04:53:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232178AbiDKIxM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Apr 2022 04:53:12 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EFC542AD3
        for <linux-xfs@vger.kernel.org>; Mon, 11 Apr 2022 01:50:58 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-233-190.pa.vic.optusnet.com.au [49.186.233.190])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id DC505535D9E;
        Mon, 11 Apr 2022 18:50:57 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ndplA-00GMtq-Qg; Mon, 11 Apr 2022 18:50:56 +1000
Date:   Mon, 11 Apr 2022 18:50:56 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Alli <allison.henderson@oracle.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [5.19 cycle] Planning and goals
Message-ID: <20220411085056.GB1544202@dread.disaster.area>
References: <20220405020312.GU1544202@dread.disaster.area>
 <20220407031106.GB27690@magnolia>
 <20220407054939.GJ1544202@dread.disaster.area>
 <ff1aa185470226b5dac3b8e914277137a88e97e6.camel@oracle.com>
 <20220411015023.GV1544202@dread.disaster.area>
 <20220411035935.GZ1544202@dread.disaster.area>
 <20220411073121.GA1544202@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220411073121.GA1544202@dread.disaster.area>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=6253ebf2
        a=bHAvQTfMiaNt/bo4vVGwyA==:117 a=bHAvQTfMiaNt/bo4vVGwyA==:17
        a=kj9zAlcOel0A:10 a=z0gMJWrwH1QA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=BYcE8iGT8nFtQk1LvOkA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 11, 2022 at 05:31:21PM +1000, Dave Chinner wrote:
> On Mon, Apr 11, 2022 at 01:59:35PM +1000, Dave Chinner wrote:
> > On Mon, Apr 11, 2022 at 11:50:23AM +1000, Dave Chinner wrote:
> > > On Thu, Apr 07, 2022 at 03:40:08PM -0700, Alli wrote:
> > > > On Thu, 2022-04-07 at 15:49 +1000, Dave Chinner wrote:
> > > > > On Wed, Apr 06, 2022 at 08:11:06PM -0700, Darrick J. Wong wrote:
> > > > > > On Tue, Apr 05, 2022 at 12:03:12PM +1000, Dave Chinner wrote:
> > > > > > > - Logged attributes V28 (Allison)
> > > > > > > 	- I haven't looked at this since V24, so I'm not sure what
> > > > > > > 	  the current status is. I will do that discovery later in
> > > > > > > 	  the week.
> > > > > > > 	- Merge criteria and status:
> > > > > > > 		- review complete: Not sure
> > > > So far each patch in v29 has at least 2 rvbs I think
> > > 
> > > OK.
> > > 
> > > > > > > 		- no regressions when not enabled: v24 was OK
> > > > > > > 		- no major regressions when enabled: v24 had issues
> > > > > > > 	- Open questions:
> > > > > > > 		- not sure what review will uncover
> > > > > > > 		- don't know what problems testing will show
> > > > > > > 		- what other log fixes does it depend on?
> > > > If it goes on top of whiteouts, it will need some modifications to
> > > > follow the new log item changes that the whiteout set makes.
> > > > 
> > > > Alternately, if the white out set goes in after the larp set, then it
> > > > will need to apply the new log item changes to xfs_attr_item.c as well
> > > 
> > > I figured as much, thanks for confirming!
> > 
> > Ok, so I've just gone through the process of merging the two
> > branches to see where we stand. The modifications to the log code
> > that are needed for the larp code - changes to log iovec processing
> > and padding - are out of date in the LARP v29 patchset.
> > 
> > That is, the versions that are in the intent whiteout patchset are
> > much more sophisticated and cleanly separated. The version of the
> > "avoid extra transactions when no intents" patch in the LARP v29
> > series is really only looking at whether the transaction is dirty,
> > not whether there are intents in the transactions, which is what we
> > really need to know when deciding whether to commit the transaction
> > or not.
> > 
> > There are also a bunch of log iovec changes buried in patch 4 of the
> > LARP patchset which is labelled as "infrastructure". Those changes
> > are cleanly split out as patch 1 in the intent whiteout patchset and
> > provide the xlog_calc_vec_len() function that the LARP code needs.
> > 
> > As such, the RVBs on the patches in the LARPv29 series don't carry
> > over to the patches in the intent whiteout series - they are just
> > too different for that to occur.
> > 
> > The additional changes needed to support intent whiteouts are
> > relatively straight forward for the attri/attrd items, so at this
> > point I'd much prefer that the two patchsets are ordered "intent
> > whiteouts" then "LARP".
> > 
> > I've pushed the compose I just processed to get most of the pending
> > patchsets as they stand into topic branches and onto test machines
> > out to kernel.org. Have a look at:
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git xfs-5.19-compose
> > 
> > to see how I merged everything and maybe give it a run through your
> > test cycle to see if there's anything I broke when LARP is enabled....
> 
> generic/642 producded this splat:
> 
>  XFS: Assertion failed: !list_empty(&cil->xc_cil), file: fs/xfs/xfs_log_cil.c, line: 1274
>  ------------[ cut here ]------------
>  kernel BUG at fs/xfs/xfs_message.c:102!
>  invalid opcode: 0000 [#1] PREEMPT SMP
>  CPU: 1 PID: 2187772 Comm: fsstress Not tainted 5.18.0-rc2-dgc+ #1108
>  Call Trace:
>   <TASK>
>   xlog_cil_commit+0xa5a/0xad0
>   __xfs_trans_commit+0xb8/0x330
>   xfs_trans_commit+0x10/0x20
>   xfs_attr_set+0x3e2/0x4c0
>   xfs_xattr_set+0x8d/0xe0
>   __vfs_setxattr+0x6b/0x90
>   __vfs_setxattr_noperm+0x76/0x220
>   __vfs_setxattr_locked+0xdf/0x100
>   vfs_setxattr+0x94/0x170
>   setxattr+0x110/0x200
>   ? __might_fault+0x22/0x30
>   ? strncpy_from_user+0x23/0x170
>   ? getname_flags.part.0+0x4c/0x1b0
>   ? kmem_cache_free+0x1fc/0x380
>   ? __might_sleep+0x43/0x70
>   path_setxattr+0xbf/0xe0
>   __x64_sys_setxattr+0x2b/0x30
>   do_syscall_64+0x35/0x80
>   entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> Which implies a dirty transaction with nothing in it at the end of
> a run through xfs_attr_set_iter() without LARP enabled. It raced
> with a CIL push, so when the empty dirty transaction tries to push
> the CIL, it assert fails because the CIL is empty....
> 
> I don't know how this happens yet, but there are no intents involved
> here so it doesn't appear to have anything to do with intent logging
> or intent whiteouts at this point.

100% reproducable, and yup, there it is:

STATIC int
xfs_xattri_finish_update(
        struct xfs_attr_item            *attr,
        struct xfs_attrd_log_item       *attrdp,
        uint32_t                        op_flags)
{
.....
        switch (op) {
        case XFS_ATTR_OP_FLAGS_SET:
                error = xfs_attr_set_iter(attr);
                break;
.....
        /*
         * Mark the transaction dirty, even on error. This ensures the
         * transaction is aborted, which:
         *
         * 1.) releases the ATTRI and frees the ATTRD
         * 2.) shuts down the filesystem
         */
        args->trans->t_flags |= XFS_TRANS_DIRTY;
....

Ok, so the problem path is a create that ends up being a pure leaf
add operation. The trace looks like (trimmed for readability):

# trace-cmd record -e xfs_attr\* -e xfs_defer\* -e printk
....

 xfs_attr_leaf_lookup:		ino 0x99a name x11 namelen 3 valuelen 28 hashval 0x1e18b1 filter  flags  op_flags ADDNAME|OKNOENT
 xfs_defer_finish:		tp 0xffff888802e27138 caller __xfs_trans_commit+0x144
 xfs_defer_create_intent:	optype 5 intent (nil) committed 0 nr 1
 xfs_defer_pending_finish:	optype 5 intent (nil) committed 0 nr 1
 xfs_attr_leaf_lookup:		ino 0x99a name x11 namelen 3 valuelen 28 hashval 0x1e18b1 filter  flags  op_flags ADDNAME|OKNOENT
 xfs_attr_leaf_add:		ino 0x99a name x11 namelen 3 valuelen 28 hashval 0x1e18b1 filter  flags  op_flags ADDNAME|OKNOENT
 xfs_attr_leaf_add_work:	ino 0x99a name x11 namelen 3 valuelen 28 hashval 0x1e18b1 filter  flags  op_flags ADDNAME|OKNOENT
 xfs_attr_leaf_addname_return:	state change 4 ino 0x99a
 xfs_defer_trans_roll:		tp 0xffff888802e27138 caller xfs_defer_finish_noroll+0x2a5
 xfs_defer_pending_finish:	optype 5 intent (nil) committed 0 nr 1
 xfs_defer_finish_done:		tp 0xffff888802e273f0 caller __xfs_trans_commit+0x144
 console:			[   94.219375] XFS: Assertion failed: !list_empty(&cil->xc_cil), file: fs/xfs/

So we have a create/set operation here. THe first lookup is to check
that xattr exists or not. Gets -ENOENT so it sets the transaction
to deferred and commits it. That gets us into xfs_defer_finish()
where we process the xattri. We don't create an intent (because larp
is false), then we finish it. This calls into:

xfs_xattri_finish_update()
  xfs_attr_set_iter()
    case XFS_DAS_UNINIT:
      xfs_attr_leaf_addname()
        xfs_attr_leaf_try_add()
	  xfs_attr3_leaf_add()
	    xfs_attr3_leaf_add_work()
        attr->xattri_dela_state = XFS_DAS_FOUND_LBLK;
	trace_xfs_attr_leaf_addname_return()
	  state change 4, XFS_DAS_FOUND_LBLK == 4
	return -EAGAIN;

args->trans->t_flags |= XFS_TRANS_DIRTY;

Now we return -EAGAIN to xfs_defer_finish_one(), which requeues
the defered item onto the deferred work, which then returns to
xfs_defer_finish_noroll() and we go around the loop again.
We roll the dirty transaction that contained the dirty leaf buffer,
committing it, then run the loop again.

This time however, we run:

xfs_xattri_finish_update
  xfs_attr_set_iter
    case XFS_DAS_FOUND_LBLK:
      <tries to set up and copy remote xattr val>  <XXX - why?>
      <no remote xattr, nothing dirtied>
      <not a RENAME op>
        <no remote blocks, nothing dirtied>
      return 0;

args->trans->t_flags |= XFS_TRANS_DIRTY;

So, at this point, we now have a dirty transaction with no modified
objects in it. All we need to do how is have some other thread flush
the CIL and then for this task to win the race to be the first
transaction to commit once the push switches to a new, empty
context and unlocks the context lock....

And then xlog_cil_commit() trips over an empty CIL because we had a
dirty transaction with no dirty items attached to it.

So, the code snippet I pointed to above that unconditionally makes
the xattr transaction dirty is invalid. We should only be setting
the transaction dirty when we attach dirty an item attached to the
transaction. If we need to abort because of an unrecoverable error,
we need to shut down the log here. That will cause the transaction
to be aborted when it returns to the core defer/commit code.

In debugging this, there are several things I've noticed that need
correcting/fixing. Rather than go around the review circle to try to
get them all understood and fixed, I think I'm just going to writing
patches and send them out for review as I get them done and tested.
The faster we knock out the problems, the sooner we get this stuff
merged.

I'll start on this tomorrow morning....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
