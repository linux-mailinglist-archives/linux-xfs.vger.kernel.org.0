Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF75016299A
	for <lists+linux-xfs@lfdr.de>; Tue, 18 Feb 2020 16:42:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726360AbgBRPl7 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 18 Feb 2020 10:41:59 -0500
Received: from verein.lst.de ([213.95.11.211]:38781 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726338AbgBRPl7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 18 Feb 2020 10:41:59 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id BD52168BE1; Tue, 18 Feb 2020 16:41:56 +0100 (CET)
Date:   Tue, 18 Feb 2020 16:41:56 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>,
        Chandan Rajendra <chandanrlinux@gmail.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 28/31] xfs: clean up the ATTR_REPLACE checks
Message-ID: <20200218154156.GC21780@lst.de>
References: <20200217125957.263434-1-hch@lst.de> <20200217125957.263434-29-hch@lst.de> <20200218020618.GC10776@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200218020618.GC10776@dread.disaster.area>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 18, 2020 at 01:06:18PM +1100, Dave Chinner wrote:
> If we are cleaning up this code, I'd prefer that the retval vs flags
> order was made consistent. i.e.
> 
> 	if (retval == -ENOATTR && (args->flags & ATTR_REPLACE))
> 		return retval;
> 	if (retval == -EEXIST) {
> 		 if (args->flags & ATTR_CREATE)
> 			return retval;
> 	.....
> 
> Because then it is clear we are stacking error conditions that are
> only relevant to specific operations.

Ok.
