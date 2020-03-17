Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A7A01891A5
	for <lists+linux-xfs@lfdr.de>; Tue, 17 Mar 2020 23:55:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbgCQWzK (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 17 Mar 2020 18:55:10 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:40709 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726476AbgCQWzK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Mar 2020 18:55:10 -0400
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 8C05E3A2EC1;
        Wed, 18 Mar 2020 09:55:06 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jEL73-0004ut-J1; Wed, 18 Mar 2020 09:55:05 +1100
Date:   Wed, 18 Mar 2020 09:55:05 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     "Ober, Frank" <frank.ober@intel.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: write atomicity with xfs ... current status?
Message-ID: <20200317225505.GU10776@dread.disaster.area>
References: <MW3PR11MB46974637E20D2ED949A7A47E8BF90@MW3PR11MB4697.namprd11.prod.outlook.com>
 <20200317191954.GA29982@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200317191954.GA29982@infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=SS2py6AdgQ4A:10
        a=7-415B0cAAAA:8 a=bYIajXiraDDfxSwi2rkA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 17, 2020 at 12:19:54PM -0700, Christoph Hellwig wrote:
> Atomic writs are still waiting for more time to finish things off.
> 
> That being said while I had a prototype to use the NVMe atomic write
> size I will never submit that to mainline in that paticular form.
> 
> NVMe does not have any flag to force atomic writes, thus a too large
> or misaligned write will be executed by the device withour errors.
> That kind of interface is way too fragile to be used in production.

I didn't realise that the NVMe standard had such a glaring flaw.
That basically makes atomic writes useless for anything that
actually requires atomicity. Has the standard been fixed yet? And
does this means that hardware with usable atomic writes is still
years away?

/me is left to wonder how the NVMe standards process screwed this
up so badly....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
