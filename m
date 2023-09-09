Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17D6B7992F5
	for <lists+linux-xfs@lfdr.de>; Sat,  9 Sep 2023 01:58:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345340AbjIHX6m (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 8 Sep 2023 19:58:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345345AbjIHX6l (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Sep 2023 19:58:41 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0C202109
        for <linux-xfs@vger.kernel.org>; Fri,  8 Sep 2023 16:58:21 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70E36C433C8;
        Fri,  8 Sep 2023 23:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694217501;
        bh=np8/0/Kh+pd2VdS3BH9sXTOsfAM+iX0qlIONUN0gB4k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Z2SuCl1FPAC8rVETbvH6csm6GUHmWSF5j5xL0YFxrgl6LZB+hWTiHJhj8PooVox/9
         4c+5MyICw141CyYeWjqXAeJDlG53xYdVvTG2WFLnNwQL2pA73hAbSTIqkm8XCMQUZG
         D4sQ6Ba7foIfsXag9cKej/X0QqpeRGBtaIBtdUBISa/nxZcbQvBZ4qFMOtTJw2l3wV
         MSDm/QEyUkaI4xpfO7ntqNY8jHybFxn4vfIcDq0u3EsxlLkHP/iW9Wd7M2PLUbEwWU
         DrkqpsGmSse5nTgFXA+aJNyLbqt3lRf1KW9K4a+XcraBjErlFVbtxWgZW/IruEvDwS
         XNrG1v1D/eZiQ==
Date:   Fri, 8 Sep 2023 16:58:20 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Anthony Iliopoulos <ailiop@suse.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] libxfs: fix atomic64_t detection on x86 32-bit
 architectures
Message-ID: <20230908235820.GQ28202@frogsfrogsfrogs>
References: <20230905084623.24865-1-ailiop@suse.com>
 <20230905164250.GV28186@frogsfrogsfrogs>
 <ZPiYmHsqEV45DUzY@technoir>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZPiYmHsqEV45DUzY@technoir>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 06, 2023 at 05:19:52PM +0200, Anthony Iliopoulos wrote:
> On Tue, Sep 05, 2023 at 09:42:50AM -0700, Darrick J. Wong wrote:
> > On Tue, Sep 05, 2023 at 10:46:23AM +0200, Anthony Iliopoulos wrote:
> > > xfsprogs during compilation tries to detect if liburcu supports atomic
> > > 64-bit ops on the platform it is being compiled on, and if not it falls
> > > back to using pthread mutex locks.
> > > 
> > > The detection logic for that fallback relies on _uatomic_link_error()
> > > which is a link-time trick used by liburcu that will cause compilation
> > > errors on archs that lack the required support. That only works for the
> > > generic liburcu code though, and it is not implemented for the
> > > x86-specific code.
> > > 
> > > In practice this means that when xfsprogs is compiled on 32-bit x86
> > > archs will successfully link to liburcu for atomic ops, but liburcu does
> > > not support atomic64_t on those archs. It indicates this during runtime
> > > by generating an illegal instruction that aborts execution, and thus
> > > causes various xfsprogs utils to be segfaulting.
> > > 
> > > Fix this by executing the liburcu atomic64_t detection code during
> > > configure instead of only relying on the linker error, so that
> > > compilation will properly fall back to pthread mutexes on those archs.
> > > 
> > > Fixes: 7448af588a2e ("libxfs: fix atomic64_t poorly for 32-bit architectures")
> > > 
> > > Signed-off-by: Anthony Iliopoulos <ailiop@suse.com>
> > > ---
> > >  m4/package_urcu.m4 | 8 ++++++--
> > >  1 file changed, 6 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/m4/package_urcu.m4 b/m4/package_urcu.m4
> > > index ef116e0cda76..f26494a69718 100644
> > > --- a/m4/package_urcu.m4
> > > +++ b/m4/package_urcu.m4
> > > @@ -26,11 +26,15 @@ rcu_init();
> > >  #
> > >  # Make sure that calling uatomic_inc on a 64-bit integer doesn't cause a link
> > >  # error on _uatomic_link_error, which is how liburcu signals that it doesn't
> > > -# support atomic operations on 64-bit data types.
> > > +# support atomic operations on 64-bit data types for its generic
> > > +# implementation (which relies on compiler builtins). For certain archs
> > > +# where liburcu carries its own implementation (such as x86_32), it
> > > +# signals lack of support during runtime by emitting an illegal
> > > +# instruction, so we also need to execute here to detect that.
> > >  #
> > >  AC_DEFUN([AC_HAVE_LIBURCU_ATOMIC64],
> > >    [ AC_MSG_CHECKING([for atomic64_t support in liburcu])
> > > -    AC_LINK_IFELSE(
> > > +    AC_RUN_IFELSE(
> > 
> > Unfortunately, this change breaks cross compiling:
> 
> Of course.. I completely forgot about that.
> 
> > checking for umode_t... no
> > checking for atomic64_t support in liburcu... configure: error: in
> > 	`.../xfsprogs/build-aarch64':
> > configure: error: cannot run test program while cross compiling
> > See `config.log' for more details
> > 
> > (Note that this is an x64 host building aarch64)
> > 
> > Seeing as we /do/ have a (slow) workaround for 32-bit machines, perhaps
> > we should use it any time a long isn't 64-bits wide:
> > 
> > diff --git a/m4/package_urcu.m4 b/m4/package_urcu.m4
> > index ef116e0cda7..2ad4179aca2 100644
> > --- a/m4/package_urcu.m4
> > +++ b/m4/package_urcu.m4
> > @@ -34,8 +34,11 @@ AC_DEFUN([AC_HAVE_LIBURCU_ATOMIC64],
> >      [  AC_LANG_PROGRAM([[
> >  #define _GNU_SOURCE
> >  #include <urcu.h>
> > +#define BUILD_BUG_ON(condition) ((void)sizeof(char[1 - 2*!!(condition)]))
> >         ]], [[
> >  long long f = 3;
> > +
> > +BUILD_BUG_ON(CAA_BITS_PER_LONG < 64);
> >  uatomic_inc(&f);
> >         ]])
> >      ], have_liburcu_atomic64=yes
> > 
> > This will cause suboptimal performance on any 32-bit cpu that /does/
> > support atomic operations on a u64, but oh well.
> 
> I am not sure there is atomic u64 liburcu support for any 32-bit cpu
> (even if that cpu does actually support it). Everything is fenced behind
> the same conditional (#if CAA_BITS_PER_LONG == 64) in urcu headers
> already (e.g. ppc.h or pretty much anything else that falls back to
> uatomic/generic.h). So your patch may be the best way forward.

Yeah.  These days 32-bit architectures are supported but not maximally
performant. :/

--D

> Honestly I am not sure why this isn't implemented at least for x86 (e.g.
> via cmpxchg8b). There's a configure option enable-compiler-atomic-builtins
> that makes this work, but it doesn't seem to be enabled in distros
> (looks fairly new, liburcu commit 3afcf5a0407c).
> 
> Regards,
> Anthony
