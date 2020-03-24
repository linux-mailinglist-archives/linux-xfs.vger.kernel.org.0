Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61635190271
	for <lists+linux-xfs@lfdr.de>; Tue, 24 Mar 2020 01:09:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727290AbgCXAJT (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 23 Mar 2020 20:09:19 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:55621 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727354AbgCXAJT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Mar 2020 20:09:19 -0400
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 48C197EA7A0;
        Tue, 24 Mar 2020 11:09:16 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jGX86-00056Y-Ve; Tue, 24 Mar 2020 11:09:14 +1100
Date:   Tue, 24 Mar 2020 11:09:14 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/9] xfs: split xlog_ticket_done
Message-ID: <20200324000914.GX10776@dread.disaster.area>
References: <20200323130706.300436-1-hch@lst.de>
 <20200323130706.300436-5-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200323130706.300436-5-hch@lst.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=LYdCFQXi c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=SS2py6AdgQ4A:10
        a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=oSTFhaBxNrwNz6lSSF4A:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 23, 2020 at 02:07:01PM +0100, Christoph Hellwig wrote:
> Split the regrant case out of xlog_ticket_done and into a new
> xlog_ticket_regrant helper.  Merge both functions with the low-level
> functions implementing the actual functionality and adjust the
> tracepoints.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_log.c      | 84 ++++++++++++++-----------------------------
>  fs/xfs/xfs_log_cil.c  |  9 +++--
>  fs/xfs/xfs_log_priv.h |  4 +--
>  fs/xfs/xfs_trace.h    | 14 ++++----
>  fs/xfs/xfs_trans.c    |  9 +++--
>  5 files changed, 47 insertions(+), 73 deletions(-)

Nice. That unwinds it quite well.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
