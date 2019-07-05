Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B52406085E
	for <lists+linux-xfs@lfdr.de>; Fri,  5 Jul 2019 16:52:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727238AbfGEOwD (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 5 Jul 2019 10:52:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42554 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726568AbfGEOwD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 5 Jul 2019 10:52:03 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 599C730842AC;
        Fri,  5 Jul 2019 14:52:03 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 032BB1B46C;
        Fri,  5 Jul 2019 14:52:02 +0000 (UTC)
Date:   Fri, 5 Jul 2019 10:52:01 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/6] xfs: refactor extended attribute buffer pointer
 functions
Message-ID: <20190705145200.GE37448@bfoster>
References: <156158199378.495944.4088787757066517679.stgit@magnolia>
 <156158201207.495944.13195054394247388623.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156158201207.495944.13195054394247388623.stgit@magnolia>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Fri, 05 Jul 2019 14:52:03 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 26, 2019 at 01:46:52PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Replace the open-coded attribute buffer pointer calculations with helper
> functions to make it more obvious what we're doing with our freeform
> memory allocation w.r.t. either storing xattr values or computing btree
> block free space.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/scrub/attr.c |   15 +++++-------
>  fs/xfs/scrub/attr.h |   65 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 72 insertions(+), 8 deletions(-)
>  create mode 100644 fs/xfs/scrub/attr.h
> 
> 
...
> diff --git a/fs/xfs/scrub/attr.h b/fs/xfs/scrub/attr.h
> new file mode 100644
> index 000000000000..88bb5e29c60c
> --- /dev/null
> +++ b/fs/xfs/scrub/attr.h
> @@ -0,0 +1,65 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> +/*
> + * Copyright (C) 2019 Oracle.  All Rights Reserved.
> + * Author: Darrick J. Wong <darrick.wong@oracle.com>
> + */
> +#ifndef __XFS_SCRUB_ATTR_H__
> +#define __XFS_SCRUB_ATTR_H__
> +
> +/*
> + * Temporary storage for online scrub and repair of extended attributes.
> + */
> +struct xchk_xattr_buf {
> +	/*
> +	 * Memory buffer -- either used for extracting attr values while
> +	 * walking the attributes; or for computing attr block bitmaps when
> +	 * checking the attribute tree.
> +	 *
> +	 * Each bitmap contains enough bits to track every byte in an attr
> +	 * block (rounded up to the size of an unsigned long).  The attr block
> +	 * used space bitmap starts at the beginning of the buffer; the free
> +	 * space bitmap follows immediately after; and we have a third buffer
> +	 * for storing intermediate bitmap results.
> +	 */
> +	uint8_t			buf[0];
> +};
> +
> +/* A place to store attribute values. */
> +static inline uint8_t *
> +xchk_xattr_valuebuf(
> +	struct xfs_scrub	*sc)
> +{
> +	struct xchk_xattr_buf	*ab = sc->buf;
> +

I was a little confused by this at first because it seemed unnecessary
to inject the structure in this type conversion from a void pointer. I
see that the next patch adds another field, however, so this looks fine:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> +	return ab->buf;
> +}
> +
> +/* A bitmap of space usage computed by walking an attr leaf block. */
> +static inline unsigned long *
> +xchk_xattr_usedmap(
> +	struct xfs_scrub	*sc)
> +{
> +	struct xchk_xattr_buf	*ab = sc->buf;
> +
> +	return (unsigned long *)ab->buf;
> +}
> +
> +/* A bitmap of free space computed by walking attr leaf block free info. */
> +static inline unsigned long *
> +xchk_xattr_freemap(
> +	struct xfs_scrub	*sc)
> +{
> +	return xchk_xattr_usedmap(sc) +
> +			BITS_TO_LONGS(sc->mp->m_attr_geo->blksize);
> +}
> +
> +/* A bitmap used to hold temporary results. */
> +static inline unsigned long *
> +xchk_xattr_dstmap(
> +	struct xfs_scrub	*sc)
> +{
> +	return xchk_xattr_freemap(sc) +
> +			BITS_TO_LONGS(sc->mp->m_attr_geo->blksize);
> +}
> +
> +#endif	/* __XFS_SCRUB_ATTR_H__ */
> 
