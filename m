Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F20DF219668
	for <lists+linux-xfs@lfdr.de>; Thu,  9 Jul 2020 05:00:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726119AbgGIDA7 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 8 Jul 2020 23:00:59 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:51110 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726107AbgGIDA7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Jul 2020 23:00:59 -0400
Received: from dread.disaster.area (pa49-180-53-24.pa.nsw.optusnet.com.au [49.180.53.24])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 768D35EED46;
        Thu,  9 Jul 2020 13:00:55 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jtMnu-0002Ri-Eb; Thu, 09 Jul 2020 13:00:54 +1000
Date:   Thu, 9 Jul 2020 13:00:54 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Carlos Maiolino <cmaiolino@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: remove xfs_zone_{alloc,zalloc} helpers
Message-ID: <20200709030054.GV2005@dread.disaster.area>
References: <20200708125608.155645-1-cmaiolino@redhat.com>
 <20200708125608.155645-5-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200708125608.155645-5-cmaiolino@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QIgWuTDL c=1 sm=1 tr=0
        a=moVtWZxmCkf3aAMJKIb/8g==:117 a=moVtWZxmCkf3aAMJKIb/8g==:17
        a=kj9zAlcOel0A:10 a=_RQrkK6FrEwA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=Vt2hdyRRZuE0I09j3OsA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 08, 2020 at 02:56:08PM +0200, Carlos Maiolino wrote:
> All their users have been converted to use MM API directly, no need to
> keep them around anymore.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>

Looks good. :)

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
