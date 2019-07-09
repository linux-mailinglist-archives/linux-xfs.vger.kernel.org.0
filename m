Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE8AF63DE0
	for <lists+linux-xfs@lfdr.de>; Wed, 10 Jul 2019 00:28:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726922AbfGIW21 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 9 Jul 2019 18:28:27 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:53678 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726133AbfGIW21 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Jul 2019 18:28:27 -0400
Received: from dread.disaster.area (pa49-195-139-63.pa.nsw.optusnet.com.au [49.195.139.63])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 0626843C503;
        Wed, 10 Jul 2019 08:28:24 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1hkyZt-0000Y8-ON; Wed, 10 Jul 2019 08:27:13 +1000
Date:   Wed, 10 Jul 2019 08:27:13 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: chain bios the right way around in xfs_rw_bdev
Message-ID: <20190709222713.GK7689@dread.disaster.area>
References: <20190709152352.27465-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190709152352.27465-1-hch@lst.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0 cx=a_idp_d
        a=fNT+DnnR6FjB+3sUuX8HHA==:117 a=fNT+DnnR6FjB+3sUuX8HHA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=0o9FgrsRnhwA:10
        a=7-415B0cAAAA:8 a=24W-yYZutWLP8mgOdAMA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 09, 2019 at 08:23:52AM -0700, Christoph Hellwig wrote:
> We need to chain the earlier bios to the later ones, so that
> submit_bio_wait waits on the bio that all the completions are
> dispatched to.
> 
> Fixes: 6ad5b3255b9e ("xfs: use bios directly to read and write the log recovery buffers")
> Reported-by: Dave Chinner <david@fromorbit.com>

Reported-and-Tested-by: Dave Chinner <david@fromorbit.com>

-- 
Dave Chinner
david@fromorbit.com
