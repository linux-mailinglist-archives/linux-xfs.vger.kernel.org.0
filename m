Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DD6633EF8
	for <lists+linux-xfs@lfdr.de>; Tue,  4 Jun 2019 08:27:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726600AbfFDG1t (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 4 Jun 2019 02:27:49 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:55449 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726595AbfFDG1t (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Jun 2019 02:27:49 -0400
Received: from dread.disaster.area (pa49-180-144-61.pa.nsw.optusnet.com.au [49.180.144.61])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 6896F105F812;
        Tue,  4 Jun 2019 16:27:47 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1hY2vB-0004vc-6x; Tue, 04 Jun 2019 16:27:45 +1000
Date:   Tue, 4 Jun 2019 16:27:45 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 20/20] xfs: remove the b_io_length field in struct xfs_buf
Message-ID: <20190604062745.GU29573@dread.disaster.area>
References: <20190603172945.13819-1-hch@lst.de>
 <20190603172945.13819-21-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190603172945.13819-21-hch@lst.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0 cx=a_idp_d
        a=8RU0RCro9O0HS2ezTvitPg==:117 a=8RU0RCro9O0HS2ezTvitPg==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=dq6fvYVFJ5YA:10
        a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=bpDLqxIFO6DUTgdRLYwA:9
        a=yMs5EmyVfm0uMULE:21 a=d6Se9_zDIRC0VulK:21 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 03, 2019 at 07:29:45PM +0200, Christoph Hellwig wrote:
> This field is now always idential to b_length.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_buf.c         | 5 ++---
>  fs/xfs/xfs_buf.h         | 1 -
>  fs/xfs/xfs_log_recover.c | 9 ++++-----
>  3 files changed, 6 insertions(+), 9 deletions(-)

One less size field to confuse me.i Looks like most of the remaining
uses of that variable should have been using b_length in the first
place, so this is good to finally have cleaned up.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
