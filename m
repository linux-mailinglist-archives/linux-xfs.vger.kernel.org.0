Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC42F20198
	for <lists+linux-xfs@lfdr.de>; Thu, 16 May 2019 10:48:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727028AbfEPIsI (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 16 May 2019 04:48:08 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:52185 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726999AbfEPIsI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 May 2019 04:48:08 -0400
Received: from dread.disaster.area (pa49-181-171-240.pa.nsw.optusnet.com.au [49.181.171.240])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id C650C3DC06B;
        Thu, 16 May 2019 18:48:05 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1hRC3Y-0003xo-LG; Thu, 16 May 2019 18:48:04 +1000
Date:   Thu, 16 May 2019 18:48:04 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs: merge xfs_buf_zero and xfs_buf_iomove
Message-ID: <20190516084804.GB29573@dread.disaster.area>
References: <20190516083050.19610-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190516083050.19610-1-hch@lst.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0 cx=a_idp_d
        a=LhzQONXuMOhFZtk4TmSJIw==:117 a=LhzQONXuMOhFZtk4TmSJIw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=E5NmQfObTbMA:10
        a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=2dOUnKLb34hNH3mULEIA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 16, 2019 at 10:30:50AM +0200, Christoph Hellwig wrote:
> xfs_buf_zero is the only caller of xfs_buf_iomove.  Remove support
> for copying from or to the buffer in xfs_buf_iomove and merge the
> two functions.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
