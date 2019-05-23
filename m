Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AF9628D27
	for <lists+linux-xfs@lfdr.de>; Fri, 24 May 2019 00:32:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388293AbfEWWcD (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 23 May 2019 18:32:03 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:59134 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388297AbfEWWcC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 May 2019 18:32:02 -0400
Received: from dread.disaster.area (pa49-180-144-61.pa.nsw.optusnet.com.au [49.180.144.61])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id E530243A86F;
        Fri, 24 May 2019 08:31:59 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1hTwFi-0004yx-DU; Fri, 24 May 2019 08:31:58 +1000
Date:   Fri, 24 May 2019 08:31:58 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/20] xfs: remove the never used _XBF_COMPOUND flag
Message-ID: <20190523223158.GO29573@dread.disaster.area>
References: <20190523173742.15551-1-hch@lst.de>
 <20190523173742.15551-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190523173742.15551-3-hch@lst.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=FNpr/6gs c=1 sm=1 tr=0 cx=a_idp_d
        a=8RU0RCro9O0HS2ezTvitPg==:117 a=8RU0RCro9O0HS2ezTvitPg==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=E5NmQfObTbMA:10
        a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=1XulMidWrOCKM9Q-_pYA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 23, 2019 at 07:37:24PM +0200, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_buf.h | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index d0b96e071cec..4f2c2bc43003 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -49,7 +49,6 @@ typedef enum {
>  #define _XBF_PAGES	 (1 << 20)/* backed by refcounted pages */
>  #define _XBF_KMEM	 (1 << 21)/* backed by heap memory */
>  #define _XBF_DELWRI_Q	 (1 << 22)/* buffer on a delwri queue */
> -#define _XBF_COMPOUND	 (1 << 23)/* compound buffer */
>  
>  typedef unsigned int xfs_buf_flags_t;
>  
> @@ -69,8 +68,7 @@ typedef unsigned int xfs_buf_flags_t;
>  	{ XBF_UNMAPPED,		"UNMAPPED" },	/* ditto */\
>  	{ _XBF_PAGES,		"PAGES" }, \
>  	{ _XBF_KMEM,		"KMEM" }, \
> -	{ _XBF_DELWRI_Q,	"DELWRI_Q" }, \
> -	{ _XBF_COMPOUND,	"COMPOUND" }
> +	{ _XBF_DELWRI_Q,	"DELWRI_Q" }

Guess I forgot to remove that long ago....

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
