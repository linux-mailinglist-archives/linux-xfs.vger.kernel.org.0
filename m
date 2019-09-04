Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B43EDA976C
	for <lists+linux-xfs@lfdr.de>; Thu,  5 Sep 2019 02:01:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730565AbfIDX7p (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 4 Sep 2019 19:59:45 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:58674 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730196AbfIDX7o (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Sep 2019 19:59:44 -0400
Received: from dread.disaster.area (pa49-181-255-194.pa.nsw.optusnet.com.au [49.181.255.194])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id D8D0743DD73;
        Thu,  5 Sep 2019 09:59:42 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i5fBe-0000ND-6y; Thu, 05 Sep 2019 09:59:42 +1000
Date:   Thu, 5 Sep 2019 09:59:42 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs_spaceman: embed struct xfs_fd in struct fileio
Message-ID: <20190904235942.GB1119@dread.disaster.area>
References: <156757189636.1838733.8025635445292375382.stgit@magnolia>
 <156757191522.1838733.5801986036398693019.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156757191522.1838733.5801986036398693019.stgit@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0
        a=YO9NNpcXwc8z/SaoS+iAiA==:117 a=YO9NNpcXwc8z/SaoS+iAiA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=J70Eh1EUuV4A:10
        a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=xW22f8ycVdI3M_VZDJ8A:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 03, 2019 at 09:38:35PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Replace the open-coded fd and geometry fields of struct fileio with a
> single xfs_fd, which will enable us to use it natively throughout
> xfs_spaceman in upcoming patches.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  spaceman/file.c     |   31 +++++++++++--------------------
>  spaceman/freesp.c   |   30 +++++++++++++++++-------------
>  spaceman/info.c     |   19 +++----------------
>  spaceman/init.c     |   11 +++++++----
>  spaceman/prealloc.c |   15 ++++++++-------
>  spaceman/space.h    |    9 +++++----
>  spaceman/trim.c     |   40 +++++++++++++++++++++-------------------
>  7 files changed, 72 insertions(+), 83 deletions(-)

Nice! Really starts to simplify the file and geometry handling.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
