Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2309635D81
	for <lists+linux-xfs@lfdr.de>; Wed,  5 Jun 2019 15:08:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727954AbfFENIX (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 5 Jun 2019 09:08:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32800 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727601AbfFENIX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 5 Jun 2019 09:08:23 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DC39C3001809
        for <linux-xfs@vger.kernel.org>; Wed,  5 Jun 2019 13:08:22 +0000 (UTC)
Received: from redhat.com (ovpn-124-91.rdu2.redhat.com [10.10.124.91])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7155A5B68E;
        Wed,  5 Jun 2019 13:08:19 +0000 (UTC)
Date:   Wed, 5 Jun 2019 08:08:12 -0500
From:   Bill O'Donnell <billodo@redhat.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] include WARN, REPAIR build options in XFS_BUILD_OPTIONS
Message-ID: <20190605130812.GA9823@redhat.com>
References: <15ed3957-d4f5-01a0-3d2e-d8a69cc435ce@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15ed3957-d4f5-01a0-3d2e-d8a69cc435ce@redhat.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Wed, 05 Jun 2019 13:08:22 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 04, 2019 at 06:23:25PM -0500, Eric Sandeen wrote:
> The XFS_BUILD_OPTIONS string, shown at module init time and 
> in modinfo output, does not currently include all available
> build options.  So, add in CONFIG_XFS_WARN and CONFIG_XFS_REPAIR.
> 
> It has been suggested in some quarters
> That this is not enough.
> Well ... 

I saw what you did there ;)

Reviewed-by: Bill O'Donnell <billodo@redhat.com>

> 
> Anybody who would like to see this in a sysfs file can send
> a patch.  :)
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> I might send that patch, but would like to have the string
> advertising build options be complete, for now.
> 
> diff --git a/fs/xfs/xfs_super.h b/fs/xfs/xfs_super.h
> index 21cb49a..763e43d 100644
> --- a/fs/xfs/xfs_super.h
> +++ b/fs/xfs/xfs_super.h
> @@ -38,6 +38,18 @@
>  # define XFS_SCRUB_STRING
>  #endif
>  
> +#ifdef CONFIG_XFS_ONLINE_REPAIR
> +# define XFS_REPAIR_STRING	"repair, "
> +#else
> +# define XFS_REPAIR_STRING
> +#endif
> +
> +#ifdef CONFIG_XFS_WARN
> +# define XFS_WARN_STRING	"verbose warnings, "
> +#else
> +# define XFS_WARN_STRING
> +#endif
> +
>  #ifdef DEBUG
>  # define XFS_DBG_STRING		"debug"
>  #else
> @@ -49,6 +61,8 @@
>  				XFS_SECURITY_STRING \
>  				XFS_REALTIME_STRING \
>  				XFS_SCRUB_STRING \
> +				XFS_REPAIR_STRING \
> +				XFS_WARN_STRING \
>  				XFS_DBG_STRING /* DBG must be last */
>  
>  struct xfs_inode;
> 
