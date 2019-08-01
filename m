Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44DDB7D9B6
	for <lists+linux-xfs@lfdr.de>; Thu,  1 Aug 2019 12:56:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728934AbfHAK4r (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 1 Aug 2019 06:56:47 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:56772 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725804AbfHAK4r (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Aug 2019 06:56:47 -0400
Received: from dread.disaster.area (pa49-195-139-63.pa.nsw.optusnet.com.au [49.195.139.63])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 1B2AC43E39B;
        Thu,  1 Aug 2019 20:56:44 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1ht8kD-0006qY-Qa; Thu, 01 Aug 2019 20:55:37 +1000
Date:   Thu, 1 Aug 2019 20:55:37 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] fs: xfs: Remove unused KM_NOSLEEP, change KM_SLEEP to 0.
Message-ID: <20190801105537.GM7777@dread.disaster.area>
References: <1564654042-9088-1-git-send-email-penguin-kernel@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1564654042-9088-1-git-send-email-penguin-kernel@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0 cx=a_idp_d
        a=fNT+DnnR6FjB+3sUuX8HHA==:117 a=fNT+DnnR6FjB+3sUuX8HHA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=FmdZ9Uzk2mMA:10
        a=7-415B0cAAAA:8 a=Qr5wyWQSrpQ28uWwRqAA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 01, 2019 at 07:07:22PM +0900, Tetsuo Handa wrote:
> Since no caller is using KM_NOSLEEP and no callee branches on KM_SLEEP,
> but removing KM_SLEEP requires modification of 97 locations, let's remove
> KM_NOSLEEP branch and (for now) change KM_SLEEP to 0.

Just remove KM_SLEEP. It's trivial to do with a couple of quick sed
scripts.

Off the top of my head, this should largely do it:

for f in `git grep -l KM_SLEEP fs/xfs`; do \
	 sed -i -e 's/KM_SLEEP | //' \
		 -e 's/KM_SLEEP|//' \
		 -e 's/KM_SLEEP)/0)/' $f; \
done


Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
