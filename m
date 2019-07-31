Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 625577C038
	for <lists+linux-xfs@lfdr.de>; Wed, 31 Jul 2019 13:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727502AbfGaLkX (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 31 Jul 2019 07:40:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6036 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727123AbfGaLkW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 31 Jul 2019 07:40:22 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 81C10308FC4B;
        Wed, 31 Jul 2019 11:40:22 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EF9D95D9C5;
        Wed, 31 Jul 2019 11:40:21 +0000 (UTC)
Date:   Wed, 31 Jul 2019 07:40:20 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs/122: add the new v5 bulkstat/inumbers ioctl
 structures
Message-ID: <20190731114019.GB34040@bfoster>
References: <156394159426.1850833.16316913520596851191.stgit@magnolia>
 <156394161274.1850833.4300015313269610610.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156394161274.1850833.4300015313269610610.stgit@magnolia>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Wed, 31 Jul 2019 11:40:22 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 23, 2019 at 09:13:32PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The new v5 bulkstat and inumbers structures are correctly padded so that
> no format changes are necessary across platforms, so add them to the
> output.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  tests/xfs/122.out |    7 +++++++
>  1 file changed, 7 insertions(+)
> 
> 
> diff --git a/tests/xfs/122.out b/tests/xfs/122.out
> index cf9ac9e2..e2f346eb 100644
> --- a/tests/xfs/122.out
> +++ b/tests/xfs/122.out
> @@ -66,6 +66,10 @@ sizeof(struct xfs_btree_block_lhdr) = 64
>  sizeof(struct xfs_btree_block_shdr) = 48
>  sizeof(struct xfs_bud_log_format) = 16
>  sizeof(struct xfs_bui_log_format) = 16
> +sizeof(struct xfs_bulk_ireq) = 64
> +sizeof(struct xfs_bulkstat) = 192
> +sizeof(struct xfs_bulkstat_req) = 64
> +sizeof(struct xfs_bulkstat_single_req) = 224
>  sizeof(struct xfs_clone_args) = 32
>  sizeof(struct xfs_cud_log_format) = 16
>  sizeof(struct xfs_cui_log_format) = 16
> @@ -89,6 +93,9 @@ sizeof(struct xfs_fsop_geom_v4) = 112
>  sizeof(struct xfs_icreate_log) = 28
>  sizeof(struct xfs_inode_log_format) = 56
>  sizeof(struct xfs_inode_log_format_32) = 52
> +sizeof(struct xfs_inumbers) = 24
> +sizeof(struct xfs_inumbers_req) = 64
> +sizeof(struct xfs_ireq) = 32

I don't see xfs_bulkstat_single_req or xfs_ireq in the latest kernel
headers. Do we still have those? Otherwise looks fine.

Brian

>  sizeof(struct xfs_log_dinode) = 176
>  sizeof(struct xfs_map_extent) = 32
>  sizeof(struct xfs_phys_extent) = 16
> 
