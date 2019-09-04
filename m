Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BCCDA9740
	for <lists+linux-xfs@lfdr.de>; Thu,  5 Sep 2019 01:39:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727741AbfIDXht (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 4 Sep 2019 19:37:49 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:46533 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726240AbfIDXht (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Sep 2019 19:37:49 -0400
Received: from dread.disaster.area (pa49-181-255-194.pa.nsw.optusnet.com.au [49.181.255.194])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 412A543C91A;
        Thu,  5 Sep 2019 09:37:47 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i5eqP-0000AH-W6; Thu, 05 Sep 2019 09:37:46 +1000
Date:   Thu, 5 Sep 2019 09:37:45 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/12] libfrog: move crc32c.h to libfrog/
Message-ID: <20190904233745.GX1119@dread.disaster.area>
References: <156757174409.1838135.8885359673458816401.stgit@magnolia>
 <156757180043.1838135.11634514432069514810.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156757180043.1838135.11634514432069514810.stgit@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0
        a=YO9NNpcXwc8z/SaoS+iAiA==:117 a=YO9NNpcXwc8z/SaoS+iAiA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=J70Eh1EUuV4A:10
        a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=YzrtGEa2EzT6gmsZrrwA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 03, 2019 at 09:36:40PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Move this header to libfrog since the code is there already.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  include/crc32c.h         |   11 -
>  include/crc32cselftest.h |  706 ----------------------------------------------
>  io/crc32cselftest.c      |    4 
>  libfrog/Makefile         |    2 
>  libfrog/crc32c.h         |   11 +
>  libfrog/crc32cselftest.h |  706 ++++++++++++++++++++++++++++++++++++++++++++++
>  libxfs/libxfs_priv.h     |    2 
>  7 files changed, 722 insertions(+), 720 deletions(-)
>  delete mode 100644 include/crc32c.h
>  delete mode 100644 include/crc32cselftest.h
>  create mode 100644 libfrog/crc32c.h
>  create mode 100644 libfrog/crc32cselftest.h

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
