Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C1625FDDEC
	for <lists+linux-xfs@lfdr.de>; Thu, 13 Oct 2022 18:03:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbiJMQDi (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 13 Oct 2022 12:03:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229994AbiJMQDg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Oct 2022 12:03:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EE3B1119C4
        for <linux-xfs@vger.kernel.org>; Thu, 13 Oct 2022 09:03:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665677013;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=e93vqJ23RYx44/ECvLt0VpML/YmZi4QGBHib1Tp67Ic=;
        b=aT52xWMwyLO6UYGpqy6pcKx3MA56WXRbtklObsn5Q2VSHnxiApMOLS/JOQRqENOrtuzqbZ
        7xuV8DShhEV8/K/aRy4Rr7+6yWVhnBSVkgsaAB8XcPwJ3jyU+26CcUZc0MdUulIbKm0qfv
        X80MvgswbLd7Wkwnhvetwv8m+EEcWcU=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-529-M4G11yQQOWytCoZ7ICsKkw-1; Thu, 13 Oct 2022 12:03:32 -0400
X-MC-Unique: M4G11yQQOWytCoZ7ICsKkw-1
Received: by mail-qv1-f71.google.com with SMTP id ma6-20020a0562145b0600b004b49a5037aeso925000qvb.18
        for <linux-xfs@vger.kernel.org>; Thu, 13 Oct 2022 09:03:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e93vqJ23RYx44/ECvLt0VpML/YmZi4QGBHib1Tp67Ic=;
        b=YnP8iMnHo5WkKaqoh+9rxs7AzdVj4noDLiV0QL3acSgi7vaQnNwXvehyjIK+f9+gP1
         KLi37FMUxq8arJTvASAXIDT0As7SYZ1bG7EMe3GyXg8dIYI+/a700jMnFL/leBDpZO+H
         qXS4C8u+dLj6KGdiIMKAMjZ5CDeVbwOv4AblMqUWOZQvhi4kPMvLv7J+V3pmy1X42hWg
         jrwJDSvZuBcUg5v6FQm2n4QDHcDn51n8IXQDhacuYQMdh7HYKBsOgXc6s5lrCv2qSBau
         GH/9/tkQgsRC/cEUY+q3YP2O4tKKiVcFyZZso531XkTmG2YM+hPdgLEuQyB0AU2dbSDU
         Ti7w==
X-Gm-Message-State: ACrzQf364LUx14792VtGfDPO4IS2cial0b80ailRBsn973CIlp+cOMY+
        zKBmTh0pMLahfI84rGoBqIaTIl3jvJMOVbP3NZXpGVYqk7RewZ7Nh9tyTLudHtf1wUrZvayKEKO
        HKiGSUsAxim1ydjZesVjK
X-Received: by 2002:a05:6214:2626:b0:4b1:d285:33b1 with SMTP id gv6-20020a056214262600b004b1d28533b1mr274562qvb.39.1665677011484;
        Thu, 13 Oct 2022 09:03:31 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM54fy6UXaq67EMDjg8yPJAda44Fy1syJLGNC3kgjTmmfsWLT11YEFGp1YNbfmZL4pYMjqU0oA==
X-Received: by 2002:a05:6214:2626:b0:4b1:d285:33b1 with SMTP id gv6-20020a056214262600b004b1d28533b1mr274528qvb.39.1665677011110;
        Thu, 13 Oct 2022 09:03:31 -0700 (PDT)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id r1-20020a05620a298100b006e2a1999263sm71081qkp.62.2022.10.13.09.03.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Oct 2022 09:03:30 -0700 (PDT)
Date:   Fri, 14 Oct 2022 00:03:26 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH v2.1 1/2] check: detect and preserve all coredumps made
 by a test
Message-ID: <20221013160326.l4s6sz4yxeul64d5@zlang-mailbox>
References: <166553910766.422356.8069826206437666467.stgit@magnolia>
 <166553911331.422356.4424521847397525024.stgit@magnolia>
 <Y0dZpkOwJpyQ9SA9@magnolia>
 <20221013114446.346ii4nd5i3l77ar@zlang-mailbox>
 <Y0gzWbBd5PdlQWP6@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y0gzWbBd5PdlQWP6@magnolia>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 13, 2022 at 08:48:41AM -0700, Darrick J. Wong wrote:
> On Thu, Oct 13, 2022 at 07:44:46PM +0800, Zorro Lang wrote:
> > On Wed, Oct 12, 2022 at 05:19:50PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > If someone sets kernel.core_uses_pid (or kernel.core_pattern), any
> > > coredumps generated by fstests might have names that are longer than
> > > just "core".  Since the pid isn't all that useful by itself, let's
> > > record the coredumps by hash when we save them, so that we don't waste
> > > space storing identical crash dumps.
> > > 
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > ---
> > > v2.1: use REPORT_DIR per maintainer suggestion
> > > ---
> > 
> > This version looks good to me,
> > Reviewed-by: Zorro Lang <zlang@redhat.com>
> 
> It occurred to me overnight that ./check doesn't export REPORT_DIR, so
> I'll push out a v2.2 that adds that.  Currently the lack of an export
> doesn't affect anyone, but as soon as any tests want to call
> _save_coredump they're going to run into that issue.

Hmm... the RESULT_DIR is exported, you can use it, or use $seqres directly due
to it's defined in common/preamble (although is not exported).

./common/preamble:42:   seqres=$RESULT_DIR/$seq

What do you think?

Thanks,
Zorro

> 
> (...and yes, I do have future fuzz tests that will call it from a test
> in between fuzz field cycles.)
> 
> --D
> 
> > >  check     |   26 ++++++++++++++++++++++----
> > >  common/rc |   16 ++++++++++++++++
> > >  2 files changed, 38 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/check b/check
> > > index d587a70546..29303db1c8 100755
> > > --- a/check
> > > +++ b/check
> > > @@ -923,11 +923,19 @@ function run_section()
> > >  			sts=$?
> > >  		fi
> > >  
> > > -		if [ -f core ]; then
> > > -			_dump_err_cont "[dumped core]"
> > > -			mv core $RESULT_BASE/$seqnum.core
> > > +		# If someone sets kernel.core_pattern or kernel.core_uses_pid,
> > > +		# coredumps generated by fstests might have a longer name than
> > > +		# just "core".  Use globbing to find the most common patterns,
> > > +		# assuming there are no other coredump capture packages set up.
> > > +		local cores=0
> > > +		for i in core core.*; do
> > > +			test -f "$i" || continue
> > > +			if ((cores++ == 0)); then
> > > +				_dump_err_cont "[dumped core]"
> > > +			fi
> > > +			_save_coredump "$i"
> > >  			tc_status="fail"
> > > -		fi
> > > +		done
> > >  
> > >  		if [ -f $seqres.notrun ]; then
> > >  			$timestamp && _timestamp
> > > @@ -960,6 +968,16 @@ function run_section()
> > >  			# of the check script itself.
> > >  			(_adjust_oom_score 250; _check_filesystems) || tc_status="fail"
> > >  			_check_dmesg || tc_status="fail"
> > > +
> > > +			# Save any coredumps from the post-test fs checks
> > > +			for i in core core.*; do
> > > +				test -f "$i" || continue
> > > +				if ((cores++ == 0)); then
> > > +					_dump_err_cont "[dumped core]"
> > > +				fi
> > > +				_save_coredump "$i"
> > > +				tc_status="fail"
> > > +			done
> > >  		fi
> > >  
> > >  		# Reload the module after each test to check for leaks or
> > > diff --git a/common/rc b/common/rc
> > > index d877ac77a0..2e1891180a 100644
> > > --- a/common/rc
> > > +++ b/common/rc
> > > @@ -4949,6 +4949,22 @@ _create_file_sized()
> > >  	return $ret
> > >  }
> > >  
> > > +_save_coredump()
> > > +{
> > > +	local path="$1"
> > > +
> > > +	local core_hash="$(_md5_checksum "$path")"
> > > +	local out_file="$REPORT_DIR/$seqnum.core.$core_hash"
> > > +
> > > +	if [ -s "$out_file" ]; then
> > > +		rm -f "$path"
> > > +		return
> > > +	fi
> > > +	rm -f "$out_file"
> > > +
> > > +	mv "$path" "$out_file"
> > > +}
> > > +
> > >  init_rc
> > >  
> > >  ################################################################################
> > > 
> > 
> 

