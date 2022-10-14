Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78F165FF376
	for <lists+linux-xfs@lfdr.de>; Fri, 14 Oct 2022 20:15:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230280AbiJNSP3 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 14 Oct 2022 14:15:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230236AbiJNSP2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 14 Oct 2022 14:15:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D809C33424;
        Fri, 14 Oct 2022 11:15:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7C9CDB82390;
        Fri, 14 Oct 2022 18:15:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D87AC433D6;
        Fri, 14 Oct 2022 18:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665771325;
        bh=2ZoHp6B1+R0scNMD4ax9z8MwHRcqBJStfQsAoDJlKog=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gxXuTAiDdyYsf2fBZUx9LIdVK+1faHQptAp4ZJyKRk92Spath66QEb94W7b9NcKOJ
         MpOX0TUht7k9Fz4VzoasI2/8PApciXaEoZXewkFRPfku8PWyytKZZpvrsRl9VxsXPE
         1QGTpL+gfkbW2z0Qvt40Lerrt0q1m0aQ4j9wp7g7TrN5x8QKdSUXLjEfokljrlEn6l
         icaYa+df8JpPMs2lXdTT4ft2OyYaFkMTFt+DKHJsgMA1ua/ti+RT31ysX37h47P1UO
         fPkvJxpEHX/CcnyN0Uot6w3DAuvImIpQePGcDSrz4+4DYy8C7UQoMwHqil4ck1qUNE
         ALQMQFwUFGotQ==
Date:   Fri, 14 Oct 2022 11:15:24 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Zorro Lang <zlang@redhat.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH v2.1 1/2] check: detect and preserve all coredumps made
 by a test
Message-ID: <Y0mnPD3bJhmo0S0K@magnolia>
References: <166553910766.422356.8069826206437666467.stgit@magnolia>
 <166553911331.422356.4424521847397525024.stgit@magnolia>
 <Y0dZpkOwJpyQ9SA9@magnolia>
 <20221013114446.346ii4nd5i3l77ar@zlang-mailbox>
 <Y0gzWbBd5PdlQWP6@magnolia>
 <20221013160326.l4s6sz4yxeul64d5@zlang-mailbox>
 <Y0g8XPzJHw6eICoK@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y0g8XPzJHw6eICoK@magnolia>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 13, 2022 at 09:27:08AM -0700, Darrick J. Wong wrote:
> On Fri, Oct 14, 2022 at 12:03:26AM +0800, Zorro Lang wrote:
> > On Thu, Oct 13, 2022 at 08:48:41AM -0700, Darrick J. Wong wrote:
> > > On Thu, Oct 13, 2022 at 07:44:46PM +0800, Zorro Lang wrote:
> > > > On Wed, Oct 12, 2022 at 05:19:50PM -0700, Darrick J. Wong wrote:
> > > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > > 
> > > > > If someone sets kernel.core_uses_pid (or kernel.core_pattern), any
> > > > > coredumps generated by fstests might have names that are longer than
> > > > > just "core".  Since the pid isn't all that useful by itself, let's
> > > > > record the coredumps by hash when we save them, so that we don't waste
> > > > > space storing identical crash dumps.
> > > > > 
> > > > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > > > ---
> > > > > v2.1: use REPORT_DIR per maintainer suggestion
> > > > > ---
> > > > 
> > > > This version looks good to me,
> > > > Reviewed-by: Zorro Lang <zlang@redhat.com>
> > > 
> > > It occurred to me overnight that ./check doesn't export REPORT_DIR, so
> > > I'll push out a v2.2 that adds that.  Currently the lack of an export
> > > doesn't affect anyone, but as soon as any tests want to call
> > > _save_coredump they're going to run into that issue.
> > 
> > Hmm... the RESULT_DIR is exported, you can use it, or use $seqres directly due
> > to it's defined in common/preamble (although is not exported).
> > 
> > ./common/preamble:42:   seqres=$RESULT_DIR/$seq
> > 
> > What do you think?
> 
> seqres is defined differently in check than in common/preamble, but I
> guess RESULT_DIR will work.

Nope, it won't, because RESULT_DIR ends up getting set to something
like /var/tmp/fstests/xfs_moocow/xfs, seqnum gets set to xfs/350, and
then you end up with garbage paths like:

/var/tmp/fstests/xfs_moocow/xfs/xfs/350.core.XXX

Soooo you were right, I should have used seqres from the start.  The
multiple definitions are confusing, but they end up resolving to the
same pathnames(!) so it's all good.

--D

> --D
> 
> > Thanks,
> > Zorro
> > 
> > > 
> > > (...and yes, I do have future fuzz tests that will call it from a test
> > > in between fuzz field cycles.)
> > > 
> > > --D
> > > 
> > > > >  check     |   26 ++++++++++++++++++++++----
> > > > >  common/rc |   16 ++++++++++++++++
> > > > >  2 files changed, 38 insertions(+), 4 deletions(-)
> > > > > 
> > > > > diff --git a/check b/check
> > > > > index d587a70546..29303db1c8 100755
> > > > > --- a/check
> > > > > +++ b/check
> > > > > @@ -923,11 +923,19 @@ function run_section()
> > > > >  			sts=$?
> > > > >  		fi
> > > > >  
> > > > > -		if [ -f core ]; then
> > > > > -			_dump_err_cont "[dumped core]"
> > > > > -			mv core $RESULT_BASE/$seqnum.core
> > > > > +		# If someone sets kernel.core_pattern or kernel.core_uses_pid,
> > > > > +		# coredumps generated by fstests might have a longer name than
> > > > > +		# just "core".  Use globbing to find the most common patterns,
> > > > > +		# assuming there are no other coredump capture packages set up.
> > > > > +		local cores=0
> > > > > +		for i in core core.*; do
> > > > > +			test -f "$i" || continue
> > > > > +			if ((cores++ == 0)); then
> > > > > +				_dump_err_cont "[dumped core]"
> > > > > +			fi
> > > > > +			_save_coredump "$i"
> > > > >  			tc_status="fail"
> > > > > -		fi
> > > > > +		done
> > > > >  
> > > > >  		if [ -f $seqres.notrun ]; then
> > > > >  			$timestamp && _timestamp
> > > > > @@ -960,6 +968,16 @@ function run_section()
> > > > >  			# of the check script itself.
> > > > >  			(_adjust_oom_score 250; _check_filesystems) || tc_status="fail"
> > > > >  			_check_dmesg || tc_status="fail"
> > > > > +
> > > > > +			# Save any coredumps from the post-test fs checks
> > > > > +			for i in core core.*; do
> > > > > +				test -f "$i" || continue
> > > > > +				if ((cores++ == 0)); then
> > > > > +					_dump_err_cont "[dumped core]"
> > > > > +				fi
> > > > > +				_save_coredump "$i"
> > > > > +				tc_status="fail"
> > > > > +			done
> > > > >  		fi
> > > > >  
> > > > >  		# Reload the module after each test to check for leaks or
> > > > > diff --git a/common/rc b/common/rc
> > > > > index d877ac77a0..2e1891180a 100644
> > > > > --- a/common/rc
> > > > > +++ b/common/rc
> > > > > @@ -4949,6 +4949,22 @@ _create_file_sized()
> > > > >  	return $ret
> > > > >  }
> > > > >  
> > > > > +_save_coredump()
> > > > > +{
> > > > > +	local path="$1"
> > > > > +
> > > > > +	local core_hash="$(_md5_checksum "$path")"
> > > > > +	local out_file="$REPORT_DIR/$seqnum.core.$core_hash"
> > > > > +
> > > > > +	if [ -s "$out_file" ]; then
> > > > > +		rm -f "$path"
> > > > > +		return
> > > > > +	fi
> > > > > +	rm -f "$out_file"
> > > > > +
> > > > > +	mv "$path" "$out_file"
> > > > > +}
> > > > > +
> > > > >  init_rc
> > > > >  
> > > > >  ################################################################################
> > > > > 
> > > > 
> > > 
> > 
