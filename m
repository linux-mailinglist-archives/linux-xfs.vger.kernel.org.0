Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B6255B23E
	for <lists+linux-xfs@lfdr.de>; Mon,  1 Jul 2019 00:37:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726040AbfF3WhS (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 30 Jun 2019 18:37:18 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:33280 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727131AbfF3WhR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 30 Jun 2019 18:37:17 -0400
Received: from dread.disaster.area (pa49-195-139-63.pa.nsw.optusnet.com.au [49.195.139.63])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 512AA3DC840;
        Mon,  1 Jul 2019 08:37:13 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1hhiQX-0003IG-LG; Mon, 01 Jul 2019 08:36:05 +1000
Date:   Mon, 1 Jul 2019 08:36:05 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Holger =?iso-8859-1?Q?Hoffst=E4tte?= 
        <holger@applied-asynchrony.com>,
        linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: Include 'xfs: speed up large directory modifications' in 5.3?
Message-ID: <20190630223605.GK7777@dread.disaster.area>
References: <56158aa8-c07a-f90f-a166-b2eeb226bb4a@applied-asynchrony.com>
 <20190630153955.GF1404256@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190630153955.GF1404256@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=FNpr/6gs c=1 sm=1 tr=0 cx=a_idp_d
        a=fNT+DnnR6FjB+3sUuX8HHA==:117 a=fNT+DnnR6FjB+3sUuX8HHA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=8nJEP1OIZ-IA:10 a=0o9FgrsRnhwA:10
        a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8 a=5ke6zQ7_2mLiwURR_LsA:9
        a=wPNLvfGTeEIA:10 a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jun 30, 2019 at 08:39:55AM -0700, Darrick J. Wong wrote:
> On Sun, Jun 30, 2019 at 01:28:09PM +0200, Holger Hoffstätte wrote:
> > Hi,
> > 
> > I have been running with Dave's series for faster directory inserts since
> > forever without any issues, and the last revision [1] still applies cleanly
> > to current5.2-rc (not sure about xfs-next though).
> > Any chance this can be included in 5.3? IMHO it would be a shame if this
> > fell through the cracks again.
> > 
> > Thanks,
> > Holger
> > 
> > [1] https://patchwork.kernel.org/project/xfs/list/?series=34713
> 
> Christoph reviewed most of the series, but it looked like he and Dave
> went back and forth a bit on the second to last patch and Dave never
> sent a v2 series or a request to just merge it as is, so I didn't take
> any action.  Hey Dave, are you still working on a resubmission for this
> series?

It's in my stack somewhere. Not for this cycle. Can't even remember
what was the issue with it.  I'm pretty sure that was about when the
whole copy file range debacle exploded in our faces, which was why
there was no followup back then...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
