Return-Path: <linux-xfs+bounces-188-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A6757FBF39
	for <lists+linux-xfs@lfdr.de>; Tue, 28 Nov 2023 17:32:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D4200282A69
	for <lists+linux-xfs@lfdr.de>; Tue, 28 Nov 2023 16:32:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8459C4D127;
	Tue, 28 Nov 2023 16:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pz7PxjXP"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AE825E0CE;
	Tue, 28 Nov 2023 16:32:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99617C433C8;
	Tue, 28 Nov 2023 16:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701189175;
	bh=VqwYFsYHgSQ8CyCGvVqeYL2Kouihl83vwFCUUepGWfI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pz7PxjXPGQGLsinMNEMBDkmAyuEpMnUG+Jm7gW6FcUO24AfwJb/D0iAk/OuIx4pU/
	 qQf9myOFtKdJwc2uV/uuafK6fvgEd+95aiAqkGk2zNNav8o0Dwku9x65PpKbXXqwKA
	 Ue2ZGVwKZVyXoc4E1TUfhPpgw9Fq/AOEAZHGoiYoRN3fAG2LA3cunU4yzAH3Xud74d
	 nKRX6z0acKx0A+PI059ekv0O4P5R1ahYnQmr9fkj1yfxC3vs/s3ciLPXKQHalVcy5q
	 DlkD1Y1ndCU+zThaemauUXEUNA1O2fQTBjvJ70WZ7+aCrkIXcFslM2Qo8rtrdutfq6
	 zK1MrgY8MECYg==
Date: Tue, 28 Nov 2023 08:32:55 -0800
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
Message-ID: <20231128163255.GV2766956@frogsfrogsfrogs>
References: <20231128124522.28499-1-bagasdotme@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231128124522.28499-1-bagasdotme@gmail.com>

On Tue, Nov 28, 2023 at 07:45:22PM +0700, Bagas Sanjaya wrote:
> XFS docs are currently in upper-level Documentation/filesystems.
> Although these are currently 4 docs, they are already outstanding as
> a group and can be moved to its own subdirectory.
> 
> Consolidate them into Documentation/filesystems/xfs/.
> 
> Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
> ---
> Changes since v1 [1]:
> 
>   * Also update references to old doc path to address kernel test robot
>     warnings [2].
> 
> [1]: https://lore.kernel.org/linux-doc/20231121095658.28254-1-bagasdotme@gmail.com/
> [2]: https://lore.kernel.org/linux-doc/a9abc5ec-f3cd-4a1a-81b9-a6900124d38b@gmail.com/
> 
>  Documentation/filesystems/index.rst                |  5 +----
>  Documentation/filesystems/xfs/index.rst            | 14 ++++++++++++++
>  .../{ => xfs}/xfs-delayed-logging-design.rst       |  0
>  .../{ => xfs}/xfs-maintainer-entry-profile.rst     |  0
>  .../{ => xfs}/xfs-online-fsck-design.rst           |  2 +-
>  .../{ => xfs}/xfs-self-describing-metadata.rst     |  0
>  .../maintainer/maintainer-entry-profile.rst        |  2 +-
>  MAINTAINERS                                        |  4 ++--
>  8 files changed, 19 insertions(+), 8 deletions(-)
>  create mode 100644 Documentation/filesystems/xfs/index.rst
>  rename Documentation/filesystems/{ => xfs}/xfs-delayed-logging-design.rst (100%)
>  rename Documentation/filesystems/{ => xfs}/xfs-maintainer-entry-profile.rst (100%)
>  rename Documentation/filesystems/{ => xfs}/xfs-online-fsck-design.rst (99%)
>  rename Documentation/filesystems/{ => xfs}/xfs-self-describing-metadata.rst (100%)

I think the rst filename should drop the 'xfs-' prefix, e.g.

	Documentation/filesystems/xfs/delayed-logging-design.rst

since that seems to be what most filesystems do:

Documentation/filesystems/caching/backend-api.rst
Documentation/filesystems/caching/cachefiles.rst
Documentation/filesystems/caching/fscache.rst
Documentation/filesystems/caching/index.rst
Documentation/filesystems/caching/netfs-api.rst
Documentation/filesystems/cifs/cifsroot.rst
Documentation/filesystems/cifs/index.rst
Documentation/filesystems/cifs/ksmbd.rst
Documentation/filesystems/ext4/about.rst
Documentation/filesystems/ext4/allocators.rst
Documentation/filesystems/ext4/attributes.rst
<snip>
Documentation/filesystems/ext4/special_inodes.rst
Documentation/filesystems/ext4/super.rst
Documentation/filesystems/ext4/verity.rst
Documentation/filesystems/nfs/client-identifier.rst
Documentation/filesystems/nfs/exporting.rst
Documentation/filesystems/nfs/index.rst
Documentation/filesystems/nfs/knfsd-stats.rst
Documentation/filesystems/nfs/nfs41-server.rst
Documentation/filesystems/nfs/pnfs.rst
Documentation/filesystems/nfs/reexport.rst
Documentation/filesystems/nfs/rpc-cache.rst
Documentation/filesystems/nfs/rpc-server-gss.rst
Documentation/filesystems/smb/cifsroot.rst
Documentation/filesystems/smb/index.rst
Documentation/filesystems/smb/ksmbd.rst
Documentation/filesystems/spufs/index.rst
Documentation/filesystems/spufs/spu_create.rst
Documentation/filesystems/spufs/spufs.rst
Documentation/filesystems/spufs/spu_run.rst

> diff --git a/Documentation/filesystems/index.rst b/Documentation/filesystems/index.rst
> index 09cade7eaefc8c..e18bc5ae3b35f8 100644
> --- a/Documentation/filesystems/index.rst
> +++ b/Documentation/filesystems/index.rst
> @@ -121,8 +121,5 @@ Documentation for filesystem implementations.
>     udf
>     virtiofs
>     vfat
> -   xfs-delayed-logging-design
> -   xfs-maintainer-entry-profile
> -   xfs-self-describing-metadata
> -   xfs-online-fsck-design
> +   xfs/index
>     zonefs
> diff --git a/Documentation/filesystems/xfs/index.rst b/Documentation/filesystems/xfs/index.rst
> new file mode 100644
> index 00000000000000..ab66c57a5d18ea
> --- /dev/null
> +++ b/Documentation/filesystems/xfs/index.rst
> @@ -0,0 +1,14 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +============================
> +XFS Filesystem Documentation
> +============================
> +
> +.. toctree::
> +   :maxdepth: 2
> +   :numbered:
> +
> +   xfs-delayed-logging-design
> +   xfs-maintainer-entry-profile
> +   xfs-self-describing-metadata
> +   xfs-online-fsck-design
> diff --git a/Documentation/filesystems/xfs-delayed-logging-design.rst b/Documentation/filesystems/xfs/xfs-delayed-logging-design.rst
> similarity index 100%
> rename from Documentation/filesystems/xfs-delayed-logging-design.rst
> rename to Documentation/filesystems/xfs/xfs-delayed-logging-design.rst
> diff --git a/Documentation/filesystems/xfs-maintainer-entry-profile.rst b/Documentation/filesystems/xfs/xfs-maintainer-entry-profile.rst
> similarity index 100%
> rename from Documentation/filesystems/xfs-maintainer-entry-profile.rst
> rename to Documentation/filesystems/xfs/xfs-maintainer-entry-profile.rst
> diff --git a/Documentation/filesystems/xfs-online-fsck-design.rst b/Documentation/filesystems/xfs/xfs-online-fsck-design.rst
> similarity index 99%
> rename from Documentation/filesystems/xfs-online-fsck-design.rst
> rename to Documentation/filesystems/xfs/xfs-online-fsck-design.rst
> index a0678101a7d02d..352516feef6ffe 100644
> --- a/Documentation/filesystems/xfs-online-fsck-design.rst
> +++ b/Documentation/filesystems/xfs/xfs-online-fsck-design.rst
> @@ -962,7 +962,7 @@ disk, but these buffer verifiers cannot provide any consistency checking
>  between metadata structures.
>  
>  For more information, please see the documentation for
> -Documentation/filesystems/xfs-self-describing-metadata.rst
> +Documentation/filesystems/xfs/xfs-self-describing-metadata.rst
>  
>  Reverse Mapping
>  ---------------
> diff --git a/Documentation/filesystems/xfs-self-describing-metadata.rst b/Documentation/filesystems/xfs/xfs-self-describing-metadata.rst
> similarity index 100%
> rename from Documentation/filesystems/xfs-self-describing-metadata.rst
> rename to Documentation/filesystems/xfs/xfs-self-describing-metadata.rst
> diff --git a/Documentation/maintainer/maintainer-entry-profile.rst b/Documentation/maintainer/maintainer-entry-profile.rst
> index 7ad4bfc2cc038a..18cee1edaecb6f 100644
> --- a/Documentation/maintainer/maintainer-entry-profile.rst
> +++ b/Documentation/maintainer/maintainer-entry-profile.rst
> @@ -105,4 +105,4 @@ to do something different in the near future.
>     ../driver-api/media/maintainer-entry-profile
>     ../driver-api/vfio-pci-device-specific-driver-acceptance
>     ../nvme/feature-and-quirk-policy
> -   ../filesystems/xfs-maintainer-entry-profile
> +   ../filesystems/xfs/xfs-maintainer-entry-profile
> diff --git a/MAINTAINERS b/MAINTAINERS
> index ea790149af7951..fd288ac57e19fb 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -23893,10 +23893,10 @@ S:	Supported
>  W:	http://xfs.org/
>  C:	irc://irc.oftc.net/xfs
>  T:	git git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git
> -P:	Documentation/filesystems/xfs-maintainer-entry-profile.rst
> +P:	Documentation/filesystems/xfs/xfs-maintainer-entry-profile.rst
>  F:	Documentation/ABI/testing/sysfs-fs-xfs
>  F:	Documentation/admin-guide/xfs.rst
> -F:	Documentation/filesystems/xfs-*
> +F:	Documentation/filesystems/xfs/xfs-*

Shouldn't this be "Documentation/filesystems/xfs/*" ?

--D

>  F:	fs/xfs/
>  F:	include/uapi/linux/dqblk_xfs.h
>  F:	include/uapi/linux/fsmap.h
> 
> base-commit: 9c235dfc3d3f901fe22acb20f2ab37ff39f2ce02
> -- 
> An old man doll... just what I always wanted! - Clara
> 
> 

