Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97D91788C3E
	for <lists+linux-xfs@lfdr.de>; Fri, 25 Aug 2023 17:14:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232667AbjHYPOH (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 25 Aug 2023 11:14:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233770AbjHYPNz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Aug 2023 11:13:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C24B212A
        for <linux-xfs@vger.kernel.org>; Fri, 25 Aug 2023 08:13:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 12C6F6489A
        for <linux-xfs@vger.kernel.org>; Fri, 25 Aug 2023 15:13:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7530EC433C8;
        Fri, 25 Aug 2023 15:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692976430;
        bh=vaXg9H+A3ibKQ+X/tJmIGTw/a35EFaJsT4EheHKoUqQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=b8rRdfPfkwwgUHPbc5Jpm0NFpvqPWogFuByNcYYpviLKEkVgYAfyIGRCnv+C53KTT
         48SQIAlHy2YYhVyXwF1InXZWnEbp2mgLuU/dM9CPMhqqgXrP0OeYxWGxQpY/TYV2KX
         mDopuZ/hJ+RzK+f9c8Q0rLwn180+DCDpdjxQyRIXJ7B7uvoEAhdq7H7g4zmYUxxoOV
         mP0X46rt8klBo0G8LIZQHuP6uTxg3Dd/sCvkMAEyR38+6nO1fCB++kqJCITiEaeYnj
         OmOq8Y/0aDhRbcTWcazh9mPRU5QX84wQk+w2OEBlcAO8DXrYs94gA5NMu4F+DMV1Xc
         pfdohh5w3AE9g==
Date:   Fri, 25 Aug 2023 08:13:49 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Carlos Maiolino <cem@kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>,
        Eric Sandeen <sandeen@redhat.com>,
        xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v2] xfsprogs: don't allow udisks to automount XFS
 filesystems with no prompt
Message-ID: <20230825151349.GI17912@frogsfrogsfrogs>
References: <0RzlZBn72mgpehkONADeAEUyKbeUf5ven3UyPUf4WF8XosPFXoQHsVVCJ5mx5sORNwgNX3-V8yi_p2c8gseawQ==@protonmail.internalid>
 <20230825000055.GE17912@frogsfrogsfrogs>
 <20230825122709.3n3tu5ym4f6zjmzu@andromeda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230825122709.3n3tu5ym4f6zjmzu@andromeda>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 25, 2023 at 02:27:09PM +0200, Carlos Maiolino wrote:
> On Thu, Aug 24, 2023 at 05:00:55PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > The unending stream of syzbot bug reports and overwrought filing of CVEs
> > for corner case handling (i.e. things that distract from actual user
> > complaints) in XFS has generated all sorts of of overheated rhetoric
> > about how every bug is a Serious Security Issue(tm) because anyone can
> > craft a malicious filesystem on a USB stick, insert the stick into a
> > victim machine, and mount will trigger a bug in the kernel driver that
> > leads to some compromise or DoS or something.
> > 
> > I thought that nobody would be foolish enough to automount an XFS
> > filesystem.  What a fool I was!  It turns out that udisks can be told
> > that it's okay to automount things, and then GNOME will do exactly that.
> > Including mounting mangled XFS filesystems!
> > 
> > <delete angry rant about poor decisionmaking and armchair fs developers
> > blasting us on X while not actually doing any of the work>
> > 
> > Turn off /this/ idiocy by adding a udev rule to tell udisks not to
> > automount XFS filesystems.
> > 
> > This will not stop a logged in user from unwittingly inserting a
> > malicious storage device and pressing [mount] and getting breached.
> > This is not a substitute for a thorough audit.  This is not a substitute
> > for lklfuse.  This does not solve the general problem of in-kernel fs
> > drivers being a huge attack surface.  I just want a vacation from the
> > sh*tstorm of bad ideas and threat models that I never agreed to support.
> > 
> 
> This seems great, thanks for doing it.
> 
> Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
> 
> /me wonders how long until distros/users start to complain and report problems
> their OS'es are not automounting xfs :)   /me runs

Well you don't have to include the make install steps in the fedora/rhel
xfsprogs.spec files. :)

Judging from the udisks git repo it sounds like they've mostly neutered
the automount hint to a subset of "commonly" removable devices like usb
and firewire.

--D

> 
> Carlos
> 
> > v2: Add external logs to the list too, and document the var we set
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > Reviewed-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  configure.ac           |    1 +
> >  include/builddefs.in   |    2 ++
> >  m4/package_services.m4 |   42 ++++++++++++++++++++++++++++++++++++++++++
> >  scrub/Makefile         |   11 +++++++++++
> >  scrub/xfs.rules        |   13 +++++++++++++
> >  5 files changed, 69 insertions(+)
> >  create mode 100644 scrub/xfs.rules
> > 
> > diff --git a/configure.ac b/configure.ac
> > index 58f3b8e2e90..e447121a344 100644
> > --- a/configure.ac
> > +++ b/configure.ac
> > @@ -209,6 +209,7 @@ AC_HAVE_SG_IO
> >  AC_HAVE_HDIO_GETGEO
> >  AC_CONFIG_SYSTEMD_SYSTEM_UNIT_DIR
> >  AC_CONFIG_CROND_DIR
> > +AC_CONFIG_UDEV_RULE_DIR
> > 
> >  if test "$enable_blkid" = yes; then
> >  AC_HAVE_BLKID_TOPO
> > diff --git a/include/builddefs.in b/include/builddefs.in
> > index fb8e239cab2..3318e00316c 100644
> > --- a/include/builddefs.in
> > +++ b/include/builddefs.in
> > @@ -184,6 +184,8 @@ HAVE_SYSTEMD = @have_systemd@
> >  SYSTEMD_SYSTEM_UNIT_DIR = @systemd_system_unit_dir@
> >  HAVE_CROND = @have_crond@
> >  CROND_DIR = @crond_dir@
> > +HAVE_UDEV = @have_udev@
> > +UDEV_RULE_DIR = @udev_rule_dir@
> >  HAVE_LIBURCU_ATOMIC64 = @have_liburcu_atomic64@
> >  HAVE_MEMFD_CLOEXEC = @have_memfd_cloexec@
> >  HAVE_MEMFD_NOEXEC_SEAL = @have_memfd_noexec_seal@
> > diff --git a/m4/package_services.m4 b/m4/package_services.m4
> > index f2d888a099a..a683ddb93e0 100644
> > --- a/m4/package_services.m4
> > +++ b/m4/package_services.m4
> > @@ -75,3 +75,45 @@ AC_DEFUN([AC_CONFIG_CROND_DIR],
> >  	AC_SUBST(have_crond)
> >  	AC_SUBST(crond_dir)
> >  ])
> > +
> > +#
> > +# Figure out where to put udev rule files
> > +#
> > +AC_DEFUN([AC_CONFIG_UDEV_RULE_DIR],
> > +[
> > +	AC_REQUIRE([PKG_PROG_PKG_CONFIG])
> > +	AC_ARG_WITH([udev_rule_dir],
> > +	  [AS_HELP_STRING([--with-udev-rule-dir@<:@=DIR@:>@],
> > +		[Install udev rules into DIR.])],
> > +	  [],
> > +	  [with_udev_rule_dir=yes])
> > +	AS_IF([test "x${with_udev_rule_dir}" != "xno"],
> > +	  [
> > +		AS_IF([test "x${with_udev_rule_dir}" = "xyes"],
> > +		  [
> > +			PKG_CHECK_MODULES([udev], [udev],
> > +			  [
> > +				with_udev_rule_dir="$($PKG_CONFIG --variable=udev_dir udev)/rules.d"
> > +			  ], [
> > +				with_udev_rule_dir=""
> > +			  ])
> > +			m4_pattern_allow([^PKG_(MAJOR|MINOR|BUILD|REVISION)$])
> > +		  ])
> > +		AC_MSG_CHECKING([for udev rule dir])
> > +		udev_rule_dir="${with_udev_rule_dir}"
> > +		AS_IF([test -n "${udev_rule_dir}"],
> > +		  [
> > +			AC_MSG_RESULT(${udev_rule_dir})
> > +			have_udev="yes"
> > +		  ],
> > +		  [
> > +			AC_MSG_RESULT(no)
> > +			have_udev="no"
> > +		  ])
> > +	  ],
> > +	  [
> > +		have_udev="disabled"
> > +	  ])
> > +	AC_SUBST(have_udev)
> > +	AC_SUBST(udev_rule_dir)
> > +])
> > diff --git a/scrub/Makefile b/scrub/Makefile
> > index ab9c2d14832..2b9b8d977f6 100644
> > --- a/scrub/Makefile
> > +++ b/scrub/Makefile
> > @@ -41,6 +41,11 @@ endif
> > 
> >  endif	# scrub_prereqs
> > 
> > +UDEV_RULES = xfs.rules
> > +ifeq ($(HAVE_UDEV),yes)
> > +	INSTALL_SCRUB += install-udev
> > +endif
> > +
> >  HFILES = \
> >  common.h \
> >  counter.h \
> > @@ -180,6 +185,12 @@ install-scrub: default
> >  	$(INSTALL) -m 755 $(XFS_SCRUB_ALL_PROG) $(PKG_SBIN_DIR)
> >  	$(INSTALL) -m 755 -d $(PKG_STATE_DIR)
> > 
> > +install-udev: $(UDEV_RULES)
> > +	$(INSTALL) -m 755 -d $(UDEV_RULE_DIR)
> > +	for i in $(UDEV_RULES); do \
> > +		$(INSTALL) -m 644 $$i $(UDEV_RULE_DIR)/64-$$i; \
> > +	done
> > +
> >  install-dev:
> > 
> >  -include .dep
> > diff --git a/scrub/xfs.rules b/scrub/xfs.rules
> > new file mode 100644
> > index 00000000000..c3f69b3ab90
> > --- /dev/null
> > +++ b/scrub/xfs.rules
> > @@ -0,0 +1,13 @@
> > +# SPDX-License-Identifier: GPL-2.0-or-later
> > +#
> > +# Copyright (C) 2023 Oracle.  All rights reserved.
> > +# Author: Darrick J. Wong <djwong@kernel.org>
> > +#
> > +# Don't let udisks automount XFS filesystems without even asking a user.
> > +# This doesn't eliminate filesystems as an attack surface; it only prevents
> > +# evil maid attacks when all sessions are locked.
> > +#
> > +# According to http://storaged.org/doc/udisks2-api/latest/udisks.8.html,
> > +# supplying UDISKS_AUTO=0 here changes the HintAuto property of the block
> > +# device abstraction to mean "do not automatically start" (e.g. mount).
> > +SUBSYSTEM=="block", ENV{ID_FS_TYPE}=="xfs|xfs_external_log", ENV{UDISKS_AUTO}="0"
