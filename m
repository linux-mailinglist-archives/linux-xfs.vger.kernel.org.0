Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 780AA1E81F
	for <lists+linux-xfs@lfdr.de>; Wed, 15 May 2019 08:07:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725871AbfEOGHw (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 15 May 2019 02:07:52 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:39173 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725857AbfEOGHw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 May 2019 02:07:52 -0400
Received: from dread.disaster.area (pa49-181-171-240.pa.nsw.optusnet.com.au [49.181.171.240])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 28F66C635;
        Wed, 15 May 2019 16:07:51 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1hQn4w-0002Xl-CF; Wed, 15 May 2019 16:07:50 +1000
Date:   Wed, 15 May 2019 16:07:50 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/11] libxfs: create new file trans_buf.c
Message-ID: <20190515060750.GY29573@dread.disaster.area>
References: <1557519510-10602-1-git-send-email-sandeen@redhat.com>
 <1557519510-10602-7-git-send-email-sandeen@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1557519510-10602-7-git-send-email-sandeen@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0 cx=a_idp_d
        a=LhzQONXuMOhFZtk4TmSJIw==:117 a=LhzQONXuMOhFZtk4TmSJIw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=E5NmQfObTbMA:10
        a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=U5vq_KSk0mvsL3eZgggA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 10, 2019 at 03:18:25PM -0500, Eric Sandeen wrote:
> Pull functions out of libxfs/*.c into trans_buf.c, if they roughly match
> the kernel's xfs_trans_buf.c file.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

So I have no problems with this, but I'm not sure what the eventual
goal is? Just sharing code, or is there some functionality that
requires a more complete transaction subsystem in userspace?

I'm asking because if the goal is eventual unification with the
kernel code, then we probably should name the files the same as the
kernel code so we don't have to rename them again when we do the
unification. That will make history searching a bit easier - less
file names to follow across and git blame works a whole lot better...

> +int
> +xfs_trans_read_buf_map(
> +	xfs_mount_t		*mp,
> +	xfs_trans_t		*tp,
> +	struct xfs_buftarg	*btp,
> +	struct xfs_buf_map	*map,
> +	int			nmaps,
> +	uint			flags,
> +	xfs_buf_t		**bpp,
> +	const struct xfs_buf_ops *ops)

Hmmmm. Will there be any follow-up to de-typedef these new files?

/me would love to just have a flag day that de-typedefs all of the
userspace code.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
