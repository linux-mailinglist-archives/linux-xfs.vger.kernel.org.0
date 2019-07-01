Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBD285BB72
	for <lists+linux-xfs@lfdr.de>; Mon,  1 Jul 2019 14:26:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728021AbfGAM0S (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 1 Jul 2019 08:26:18 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:59546 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726329AbfGAM0R (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Jul 2019 08:26:17 -0400
Received: from dread.disaster.area (pa49-195-139-63.pa.nsw.optusnet.com.au [49.195.139.63])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 6E3B13DC5A6;
        Mon,  1 Jul 2019 22:26:15 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1hhvMm-0008Fo-7S; Mon, 01 Jul 2019 22:25:04 +1000
Date:   Mon, 1 Jul 2019 22:25:04 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/6] mkfs: use libxfs to write out new AGs
Message-ID: <20190701122504.GM7777@dread.disaster.area>
References: <156114701371.1643538.316410894576032261.stgit@magnolia>
 <156114705924.1643538.6635085530435538461.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156114705924.1643538.6635085530435538461.stgit@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0 cx=a_idp_d
        a=fNT+DnnR6FjB+3sUuX8HHA==:117 a=fNT+DnnR6FjB+3sUuX8HHA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=0o9FgrsRnhwA:10
        a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8 a=1pkt6STEJ0tzO_72xgMA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 21, 2019 at 12:57:39PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Use the libxfs AG initialization functions to write out the new
> filesystem instead of open-coding everything.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
.....
> @@ -4087,8 +3770,16 @@ main(
>  	/*
>  	 * Initialise all the static on disk metadata.
>  	 */
> +	INIT_LIST_HEAD(&buffer_list);
>  	for (agno = 0; agno < cfg.agcount; agno++)
> -		initialise_ag_headers(&cfg, mp, sbp, agno, &worst_freelist);
> +		initialise_ag_headers(&cfg, mp, sbp, agno, &worst_freelist,
> +				&buffer_list);
> +
> +	if (libxfs_buf_delwri_submit(&buffer_list)) {
> +		fprintf(stderr, _("%s: writing AG headers failed\n"),
> +				progname);
> +		exit(1);
> +	}

The problem I came across with this "one big delwri list" construct
when adding delwri lists for batched AIO processing is that the
memory footprint for high AG count filesystems really blows out. Did
you check what happens when you create a filesystem with a few tens
of thousands of AGs? 

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
