Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC0427C04C
	for <lists+linux-xfs@lfdr.de>; Wed, 31 Jul 2019 13:43:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727267AbfGaLnk (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 31 Jul 2019 07:43:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59902 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725935AbfGaLnk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 31 Jul 2019 07:43:40 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5730A60CC;
        Wed, 31 Jul 2019 11:43:40 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C712A60852;
        Wed, 31 Jul 2019 11:43:39 +0000 (UTC)
Date:   Wed, 31 Jul 2019 07:43:38 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs/122: mask wonky ioctls
Message-ID: <20190731114337.GE34040@bfoster>
References: <156394159426.1850833.16316913520596851191.stgit@magnolia>
 <156394160665.1850833.14349327556274532970.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156394160665.1850833.14349327556274532970.stgit@magnolia>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Wed, 31 Jul 2019 11:43:40 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 23, 2019 at 09:13:26PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Don't check the structure size of the inogrp/bstat/fsop_bulkreq
> structures because they're incorrectly padded.  When we remove the
> old typdefs the old filter stops working.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  tests/xfs/122 |    3 +++
>  1 file changed, 3 insertions(+)
> 
> 
> diff --git a/tests/xfs/122 b/tests/xfs/122
> index 89a39a23..64b63cb1 100755
> --- a/tests/xfs/122
> +++ b/tests/xfs/122
> @@ -148,12 +148,15 @@ xfs_growfs_data_t
>  xfs_growfs_rt_t
>  xfs_bstime_t
>  xfs_bstat_t
> +struct xfs_bstat
>  xfs_fsop_bulkreq_t
> +struct xfs_fsop_bulkreq
>  xfs_icsb_cnts_t
>  xfs_icdinode_t
>  xfs_ictimestamp_t
>  xfs_inobt_rec_incore_t
>  xfs_inogrp_t
> +struct xfs_inogrp
>  xfs_fid2_t
>  xfs_fsop_handlereq_t
>  xfs_fsop_setdm_handlereq_t
> 
