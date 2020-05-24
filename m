Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC5801E03E0
	for <lists+linux-xfs@lfdr.de>; Mon, 25 May 2020 01:23:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388582AbgEXXXV (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 24 May 2020 19:23:21 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:60900 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388508AbgEXXXU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 24 May 2020 19:23:20 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 763E4820C24;
        Mon, 25 May 2020 09:23:17 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jczxb-0000wi-DR; Mon, 25 May 2020 09:23:15 +1000
Date:   Mon, 25 May 2020 09:23:15 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: Replace one-element arrays with flexible-array
 members
Message-ID: <20200524232315.GQ2040@dread.disaster.area>
References: <20200522215542.GA18898@embeddedor>
 <202005221606.A1647A0@keescook>
 <20200523202149.GI29907@embeddedor>
 <20200524022555.GA252930@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200524022555.GA252930@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QIgWuTDL c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=kj9zAlcOel0A:10 a=sTwFKg_x9MkA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=M_HKgq8_zpmGVr2XFqYA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, May 23, 2020 at 07:25:55PM -0700, Darrick J. Wong wrote:
> Please always cc linux-xfs when you're changing fs/xfs code.
> 
> *Especially* when it involves changes to ondisk structures.

I can't find this patch in lkml or -fsdevel on lore.kernel.org, so I
have no idea where this patch even came from. Which means I can't
even check what the structure change is because it wasn't quoted in
full.

So, NACK on this until the entire patch is resent to linux-xfs and
run through all the shutdown and error recovery tests in fstests....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
