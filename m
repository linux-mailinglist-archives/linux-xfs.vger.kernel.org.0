Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0E9328DB7
	for <lists+linux-xfs@lfdr.de>; Fri, 24 May 2019 01:25:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388006AbfEWXZQ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 23 May 2019 19:25:16 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:53680 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387693AbfEWXZQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 May 2019 19:25:16 -0400
Received: from dread.disaster.area (pa49-180-144-61.pa.nsw.optusnet.com.au [49.180.144.61])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 3DFCE43A8BB;
        Fri, 24 May 2019 09:25:13 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1hTx5D-0005IM-R4; Fri, 24 May 2019 09:25:11 +1000
Date:   Fri, 24 May 2019 09:25:11 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/20] xfs: factor out iclog size calculation from
 xlog_sync
Message-ID: <20190523232511.GV29573@dread.disaster.area>
References: <20190523173742.15551-1-hch@lst.de>
 <20190523173742.15551-10-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190523173742.15551-10-hch@lst.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=FNpr/6gs c=1 sm=1 tr=0 cx=a_idp_d
        a=8RU0RCro9O0HS2ezTvitPg==:117 a=8RU0RCro9O0HS2ezTvitPg==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=E5NmQfObTbMA:10
        a=7-415B0cAAAA:8 a=BU6hO_rib3nWVP12ED0A:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 23, 2019 at 07:37:31PM +0200, Christoph Hellwig wrote:
> Split out another self-contained bit of code from xlog_sync.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_log.c | 64 ++++++++++++++++++++++++++++--------------------
>  1 file changed, 38 insertions(+), 26 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 885470f08554..e2c9f74f86f3 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1830,6 +1830,36 @@ xlog_split_iclog(
>  	return split_offset;
>  }
>  
> +static int
> +xlog_calc_iclog_size(
> +	struct xlog		*log,
> +	struct xlog_in_core	*iclog,
> +	uint32_t		*roundoff)
> +{
> +	bool			v2 = xfs_sb_version_haslogv2(&log->l_mp->m_sb);
> +	uint32_t		count_init, count;
> +
> +	/* Add for LR header */
> +	count_init = log->l_iclog_hsize + iclog->ic_offset;
> +
> +	/* Round out the log write size */
> +	if (v2 && log->l_mp->m_sb.sb_logsunit > 1) {

Hmmm, seeing as this is a now a standalone function, perhaps it
would make more sense to precalculate this whole check like so:

	bool			use_lsunit;

	use_lsunit = xfs_sb_version_haslogv2(&log->l_mp->m_sb) &&
			log->l_mp->m_sb.sb_logsunit > 1;

	if (use_lsunit) {
> +		/* we have a v2 stripe unit to use */
> +		count = XLOG_LSUNITTOB(log, XLOG_BTOLSUNIT(log, count_init));
> +	} else {
> +		count = BBTOB(BTOBB(count_init));
> +	}

Otherwise the patch looks good.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
