Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2CF735283
	for <lists+linux-xfs@lfdr.de>; Wed,  5 Jun 2019 00:04:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726312AbfFDWEV (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 4 Jun 2019 18:04:21 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:53958 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726305AbfFDWEV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Jun 2019 18:04:21 -0400
Received: from dread.disaster.area (pa49-180-144-61.pa.nsw.optusnet.com.au [49.180.144.61])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 566B043A1E3;
        Wed,  5 Jun 2019 08:04:19 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1hYHXV-0002Sw-5e; Wed, 05 Jun 2019 08:04:17 +1000
Date:   Wed, 5 Jun 2019 08:04:17 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs: refactor inode geometry setup routines
Message-ID: <20190604220417.GZ29573@dread.disaster.area>
References: <155968493259.1657505.18397791996876650910.stgit@magnolia>
 <155968494542.1657505.5981492051798860627.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <155968494542.1657505.5981492051798860627.stgit@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=FNpr/6gs c=1 sm=1 tr=0 cx=a_idp_d
        a=8RU0RCro9O0HS2ezTvitPg==:117 a=8RU0RCro9O0HS2ezTvitPg==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=dq6fvYVFJ5YA:10
        a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=JuDxSlhT3OO6blO4plAA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 04, 2019 at 02:49:05PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Migrate all of the inode geometry setup code from xfs_mount.c into a
> single libxfs function that we can share with xfsprogs.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
