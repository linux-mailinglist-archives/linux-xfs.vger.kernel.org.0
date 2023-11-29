Return-Path: <linux-xfs+bounces-253-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 250A57FCFC6
	for <lists+linux-xfs@lfdr.de>; Wed, 29 Nov 2023 08:17:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AD4CE1F20FCF
	for <lists+linux-xfs@lfdr.de>; Wed, 29 Nov 2023 07:17:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6C1D107BE;
	Wed, 29 Nov 2023 07:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EGy9LaOS"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73F0BE57C;
	Wed, 29 Nov 2023 07:17:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7BCEC433C7;
	Wed, 29 Nov 2023 07:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701242270;
	bh=O9sdQCSFc9y3ALYHb16O8SDK2d52tGC21IOhoEe+Fho=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EGy9LaOSfrmpEi4Q3rzQZepSDb9x4u1k9kHXm4RCN1Gm1hoO2k5OfA46YbaUMPDaI
	 rdqe9R6FZnaL8+K7lHVZuZ/FbpkOG4KPYf1l9i7NFcWGQpugL2xrC2+/thS32mK+7p
	 RoC3Ahu8ALonzMHJwQguvv50LDt/5cNoITd/k9pCjo2StiVGCZHBsUMM1u6h6qPMKI
	 U9Vp5MP4SvCXFmVrbJBjDwcZ6LMtFxvq3YVuhIbhbv+yJQ7REmEL3WTvToPHoHU00p
	 3RI5w/+jyJInGwwmckJLPXBQhRgMWVXwMs+EKNcelgLzwS5O/L6NIvjudq3xlDBCyD
	 +D15a+PAqES/w==
Date: Tue, 28 Nov 2023 23:17:50 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Documentation <linux-doc@vger.kernel.org>,
	Linux XFS <linux-xfs@vger.kernel.org>,
	Linux Kernel Workflows <workflows@vger.kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Chandan Babu R <chandan.babu@oracle.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	Steve French <stfrench@microsoft.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Allison Henderson <allison.henderson@oracle.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Charles Han <hanchunchao@inspur.com>,
	Vegard Nossum <vegard.nossum@oracle.com>
Subject: Re: [PATCH RESEND v2] Documentation: xfs: consolidate XFS docs into
 its own subdirectory
Message-ID: <20231129071750.GU36211@frogsfrogsfrogs>
References: <20231128124522.28499-1-bagasdotme@gmail.com>
 <20231128163255.GV2766956@frogsfrogsfrogs>
 <20231129052400.GS4167244@frogsfrogsfrogs>
 <ZWbkbfjyDJS7jxDg@archie.me>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZWbkbfjyDJS7jxDg@archie.me>

On Wed, Nov 29, 2023 at 02:12:45PM +0700, Bagas Sanjaya wrote:
> On Tue, Nov 28, 2023 at 09:24:00PM -0800, Darrick J. Wong wrote:
> > On Tue, Nov 28, 2023 at 08:32:55AM -0800, Darrick J. Wong wrote:
> > > On Tue, Nov 28, 2023 at 07:45:22PM +0700, Bagas Sanjaya wrote:
> > > > XFS docs are currently in upper-level Documentation/filesystems.
> > > > Although these are currently 4 docs, they are already outstanding as
> > > > a group and can be moved to its own subdirectory.
> > > > 
> > > > Consolidate them into Documentation/filesystems/xfs/.
> > > > 
> > > > Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
> > > > ---
> > > > Changes since v1 [1]:
> > > > 
> > > >   * Also update references to old doc path to address kernel test robot
> > > >     warnings [2].
> > > > 
> > > > [1]: https://lore.kernel.org/linux-doc/20231121095658.28254-1-bagasdotme@gmail.com/
> > > > [2]: https://lore.kernel.org/linux-doc/a9abc5ec-f3cd-4a1a-81b9-a6900124d38b@gmail.com/
> > > > 
> > > >  Documentation/filesystems/index.rst                |  5 +----
> > > >  Documentation/filesystems/xfs/index.rst            | 14 ++++++++++++++
> > > >  .../{ => xfs}/xfs-delayed-logging-design.rst       |  0
> > > >  .../{ => xfs}/xfs-maintainer-entry-profile.rst     |  0
> > > >  .../{ => xfs}/xfs-online-fsck-design.rst           |  2 +-
> > > >  .../{ => xfs}/xfs-self-describing-metadata.rst     |  0
> > > >  .../maintainer/maintainer-entry-profile.rst        |  2 +-
> > > >  MAINTAINERS                                        |  4 ++--
> > > >  8 files changed, 19 insertions(+), 8 deletions(-)
> > > >  create mode 100644 Documentation/filesystems/xfs/index.rst
> > > >  rename Documentation/filesystems/{ => xfs}/xfs-delayed-logging-design.rst (100%)
> > > >  rename Documentation/filesystems/{ => xfs}/xfs-maintainer-entry-profile.rst (100%)
> > > >  rename Documentation/filesystems/{ => xfs}/xfs-online-fsck-design.rst (99%)
> > > >  rename Documentation/filesystems/{ => xfs}/xfs-self-describing-metadata.rst (100%)
> > > 
> > > I think the rst filename should drop the 'xfs-' prefix, e.g.
> > > 
> > > 	Documentation/filesystems/xfs/delayed-logging-design.rst
> > > 
> > > since that seems to be what most filesystems do:
> > 
> > Actually, ignore this suggestion.  I forgot that I have vim paths
> > trained on the Documentation/filesystems/ directory, which means I'll
> > lose the ability to
> > 
> > :f xfs-online-fsck-design.rst
> > 
> > and pop it open.  Not that I expect many more filesystems to grow online
> > fsck capabilities, but you get the point...
> 
> So is it OK to just move the the docs and keeping their basename intact (as I
> did here)?

Correct.

> > > > diff --git a/MAINTAINERS b/MAINTAINERS
> > > > index ea790149af7951..fd288ac57e19fb 100644
> > > > --- a/MAINTAINERS
> > > > +++ b/MAINTAINERS
> > > > @@ -23893,10 +23893,10 @@ S:	Supported
> > > >  W:	http://xfs.org/
> > > >  C:	irc://irc.oftc.net/xfs
> > > >  T:	git git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git
> > > > -P:	Documentation/filesystems/xfs-maintainer-entry-profile.rst
> > > > +P:	Documentation/filesystems/xfs/xfs-maintainer-entry-profile.rst
> > > >  F:	Documentation/ABI/testing/sysfs-fs-xfs
> > > >  F:	Documentation/admin-guide/xfs.rst
> > > > -F:	Documentation/filesystems/xfs-*
> > > > +F:	Documentation/filesystems/xfs/xfs-*
> > > 
> > > Shouldn't this be "Documentation/filesystems/xfs/*" ?
> > 
> > ...though this suggestion remains standing.
> 
> OK, will fix it up in v3.

Ok, thanks!

--D

> -- 
> An old man doll... just what I always wanted! - Clara



