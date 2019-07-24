Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 596F9741EE
	for <lists+linux-xfs@lfdr.de>; Thu, 25 Jul 2019 01:22:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729109AbfGXXW2 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 24 Jul 2019 19:22:28 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:53751 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726314AbfGXXW2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Jul 2019 19:22:28 -0400
Received: from dread.disaster.area (pa49-195-139-63.pa.nsw.optusnet.com.au [49.195.139.63])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id DA5732AD0F3;
        Thu, 25 Jul 2019 09:22:25 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1hqQZR-0006QK-Vs; Thu, 25 Jul 2019 09:21:17 +1000
Date:   Thu, 25 Jul 2019 09:21:17 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 1/3] common: filter aiodio dmesg after fs/iomap.c to
 fs/iomap/ move
Message-ID: <20190724232117.GB7777@dread.disaster.area>
References: <156394156831.1850719.2997473679130010771.stgit@magnolia>
 <156394157450.1850719.464315342783936237.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156394157450.1850719.464315342783936237.stgit@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0 cx=a_idp_d
        a=fNT+DnnR6FjB+3sUuX8HHA==:117 a=fNT+DnnR6FjB+3sUuX8HHA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=0o9FgrsRnhwA:10
        a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8 a=sn25pJRDoJBzixySWP4A:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 23, 2019 at 09:12:54PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Since the iomap code are moving to fs/iomap/ we have to add new entries
> to the aiodio dmesg filter to reflect this.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  common/filter |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/common/filter b/common/filter
> index ed082d24..26fc2132 100644
> --- a/common/filter
> +++ b/common/filter
> @@ -555,6 +555,7 @@ _filter_aiodio_dmesg()
>  	local warn7="WARNING:.*fs/iomap\.c:.*iomap_dio_actor.*"
>  	local warn8="WARNING:.*fs/iomap\.c:.*iomap_dio_complete.*"

There's two different warnings that need capturing here.

>  	local warn9="WARNING:.*fs/direct-io\.c:.*dio_complete.*"
> +	local warn10="WARNING:.*fs/iomap/direct-io\.c:.*iomap_dio_actor.*"
>  	sed -e "s#$warn1#Intentional warnings in xfs_file_dio_aio_write#" \
>  	    -e "s#$warn2#Intentional warnings in xfs_file_dio_aio_read#" \
>  	    -e "s#$warn3#Intentional warnings in xfs_file_read_iter#" \
> @@ -563,7 +564,8 @@ _filter_aiodio_dmesg()
>  	    -e "s#$warn6#Intentional warnings in __xfs_get_blocks#" \
>  	    -e "s#$warn7#Intentional warnings in iomap_dio_actor#" \
>  	    -e "s#$warn8#Intentional warnings in iomap_dio_complete#" \
> -	    -e "s#$warn9#Intentional warnings in dio_complete#"
> +	    -e "s#$warn9#Intentional warnings in dio_complete#" \
> +	    -e "s#$warn10#Intentional warnings in iomap_dio_actor#"

Why not just change the regex in warn7/warn8 just to catch anything
under fs/iomap rather than explictly specifying fs/iomap.c?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
