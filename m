Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07A373101DD
	for <lists+linux-xfs@lfdr.de>; Fri,  5 Feb 2021 01:51:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232086AbhBEAvn (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 4 Feb 2021 19:51:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:59226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232083AbhBEAvm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 4 Feb 2021 19:51:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ADAFA64F51;
        Fri,  5 Feb 2021 00:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612486261;
        bh=48oXFnU2W1ESwt6xX6RiNefLV1vvd+Gz+GpbNCnuVzw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Z/ZKzfcZiIEdg4S2gECMiEgXvTkAnSvcCwTJHJ3BEGQxEUDFA6PU+O1fDizXwpKOe
         BgRgFbxI0vklt//UMoUiAuLurFCbR1OgUrQ0iWhANDx7rxulbuyQ4yJiBH2nUuWHpF
         jvK+nFnlthS6ygaoFlhN7U2cz6B1okdkmnRM6qxKIyvpfejfpJ1bdJfoqwZnawUynb
         J8GH/EB8OfSpvBhrQRBQ6SrSMfhHDoLLh08Xfj9/SaKCCFyaQUK3V+BN8loSLWGyBA
         DygunJMptoI6ggWwVgJeDvA0etKWIsINhSbtto8nxr7wxjZLmIiPnzTdFoKAEzEsfg
         30kAoGMhv46OA==
Date:   Thu, 4 Feb 2021 16:51:00 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Bastian Germann <bastiangermann@fishpost.de>
Cc:     linux-xfs@vger.kernel.org, Helmut Grohne <helmut@subdivi.de>
Subject: Re: [PATCH 1/3] debian: Drop unused dh-python from Build-Depends
Message-ID: <20210205005100.GK7193@magnolia>
References: <20210205003125.24463-1-bastiangermann@fishpost.de>
 <20210205003125.24463-2-bastiangermann@fishpost.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210205003125.24463-2-bastiangermann@fishpost.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Feb 05, 2021 at 01:31:23AM +0100, Bastian Germann wrote:
> xfsprogs participates in dependency loops relevant to architecture
> bootstrap. Identifying easily droppable dependencies, it was found
> that xfsprogs does not use dh-python in any way.

scrub/xfs_scrub_all.in and tools/xfsbuflock.py are the only python
scripts in xfsprogs.  We ship the first one as-is in the xfsprogs
package and we don't ship the second one at all (it's a debugger tool).

AFAICT neither of them really use dh-python, right?

--D

> 
> Reported-by: Helmut Grohne <helmut@subdivi.de>
> Signed-off-by: Bastian Germann <bastiangermann@fishpost.de>
> ---
>  debian/changelog | 6 ++++++
>  debian/control   | 2 +-
>  2 files changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/debian/changelog b/debian/changelog
> index ce4a224d..7b0120c2 100644
> --- a/debian/changelog
> +++ b/debian/changelog
> @@ -1,3 +1,9 @@
> +xfsprogs (5.10.0-3) unstable; urgency=medium
> +
> +  * Drop unused dh-python from Build-Depends (Closes: #981361)
> +
> + -- Bastian Germann <bastiangermann@fishpost.de>  Fri, 05 Feb 2021 00:18:31 +0100
> +
>  xfsprogs (5.10.0-2) unstable; urgency=low
>  
>    * Team upload
> diff --git a/debian/control b/debian/control
> index b0eb1566..8975bd13 100644
> --- a/debian/control
> +++ b/debian/control
> @@ -3,7 +3,7 @@ Section: admin
>  Priority: optional
>  Maintainer: XFS Development Team <linux-xfs@vger.kernel.org>
>  Uploaders: Nathan Scott <nathans@debian.org>, Anibal Monsalve Salazar <anibal@debian.org>, Bastian Germann <bastiangermann@fishpost.de>
> -Build-Depends: libinih-dev, uuid-dev, dh-autoreconf, debhelper (>= 5), gettext, libtool, libedit-dev, libblkid-dev (>= 2.17), linux-libc-dev, libdevmapper-dev, libattr1-dev, libicu-dev, dh-python, pkg-config
> +Build-Depends: libinih-dev, uuid-dev, dh-autoreconf, debhelper (>= 5), gettext, libtool, libedit-dev, libblkid-dev (>= 2.17), linux-libc-dev, libdevmapper-dev, libattr1-dev, libicu-dev, pkg-config
>  Standards-Version: 4.0.0
>  Homepage: https://xfs.wiki.kernel.org/
>  
> -- 
> 2.30.0
> 
