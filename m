Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A643935284
	for <lists+linux-xfs@lfdr.de>; Wed,  5 Jun 2019 00:05:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726341AbfFDWFX (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 4 Jun 2019 18:05:23 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:50595 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726305AbfFDWFW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Jun 2019 18:05:22 -0400
Received: from dread.disaster.area (pa49-180-144-61.pa.nsw.optusnet.com.au [49.180.144.61])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 1353FD0C1;
        Wed,  5 Jun 2019 08:05:21 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1hYHYU-0002T8-St; Wed, 05 Jun 2019 08:05:18 +1000
Date:   Wed, 5 Jun 2019 08:05:18 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs: fix inode_cluster_size rounding mayhem
Message-ID: <20190604220518.GA29573@dread.disaster.area>
References: <155968493259.1657505.18397791996876650910.stgit@magnolia>
 <155968495968.1657505.12432054087739349861.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <155968495968.1657505.12432054087739349861.stgit@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0 cx=a_idp_d
        a=8RU0RCro9O0HS2ezTvitPg==:117 a=8RU0RCro9O0HS2ezTvitPg==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=dq6fvYVFJ5YA:10
        a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=2bEQjfSb6pifEEiO3ZUA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 04, 2019 at 02:49:19PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> inode_cluster_size is supposed to represent the size (in bytes) of an
> inode cluster buffer.  We avoid having to handle multiple clusters per
> filesystem block on filesystems with large blocks by openly rounding
> this value up to 1 FSB when necessary.  However, we never reset
> inode_cluster_size to reflect this new rounded value, which adds to the
> potential for mistakes in calculating geometries.
> 
> Fix this by setting inode_cluster_size to reflect the rounded-up size if
> needed, and special-case the few places in the sparse inodes code where
> we actually need the smaller value to validate on-disk metadata.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

LGTM.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
