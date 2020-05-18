Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 741621D6E41
	for <lists+linux-xfs@lfdr.de>; Mon, 18 May 2020 02:30:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726680AbgERAaZ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 17 May 2020 20:30:25 -0400
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:50575 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726675AbgERAaZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 17 May 2020 20:30:25 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id F207FD7DDAD;
        Mon, 18 May 2020 10:30:21 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jaTfg-00018e-Ic; Mon, 18 May 2020 10:30:20 +1000
Date:   Mon, 18 May 2020 10:30:20 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/5] [RFC] xfs: per-cpu CIL lists
Message-ID: <20200518003020.GN2040@dread.disaster.area>
References: <20200512092811.1846252-1-david@fromorbit.com>
 <20200512092811.1846252-5-david@fromorbit.com>
 <20200513170237.GB45326@bfoster>
 <20200513233358.GH2040@dread.disaster.area>
 <20200514134446.GC50441@bfoster>
 <20200514224638.GM2040@dread.disaster.area>
 <20200515172649.GA55234@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200515172649.GA55234@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=kj9zAlcOel0A:10 a=sTwFKg_x9MkA:10 a=7-415B0cAAAA:8
        a=_D3LhmNpZy6Tw4pHRTMA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 15, 2020 at 01:26:49PM -0400, Brian Foster wrote:
> Ok, that might prohibit using a bitop in the commit path. I'd still like
> to see actual numbers on that, though, just to see where on the spectrum
> it lands. I'm also wondering if the fast path logic mentioned above
> could be implemented like the following (using bitops instead of the
> spinlock):
> 
> 	if (test_bit(XLOG_CIL_EMPTY, ...) &&
> 	    test_and_clear_bit(XLOG_CIL_EMPTY, ...)) {
> 		<steal CIL res>
> 	}
> 
> That type of pattern seems to be used in at least a few other places in
> the kernel (e.g. filemap_check_errors(), wb_start_writeback(),
> __blk_mq_tag_busy()), presumably for similar reasons.

Ok, that seems reasonable given that there is other code using the
same pattern to avoid atomic ops. Overhead will be no different to
the test/lock/retest pattern I've been using...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
