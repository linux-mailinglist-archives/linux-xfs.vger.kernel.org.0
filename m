Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79C06180B8C
	for <lists+linux-xfs@lfdr.de>; Tue, 10 Mar 2020 23:29:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbgCJW27 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 10 Mar 2020 18:28:59 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:39707 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727506AbgCJW27 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Mar 2020 18:28:59 -0400
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 366547E97E9;
        Wed, 11 Mar 2020 09:28:57 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jBnMu-0004n3-JX; Wed, 11 Mar 2020 09:28:56 +1100
Date:   Wed, 11 Mar 2020 09:28:56 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/7] xfs: remove the unused return value from
 xfs_log_unmount_write
Message-ID: <20200310222856.GR10776@dread.disaster.area>
References: <20200306143137.236478-1-hch@lst.de>
 <20200306143137.236478-2-hch@lst.de>
 <20200306160917.GD2773@bfoster>
 <20200309080252.GA31481@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200309080252.GA31481@lst.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=SS2py6AdgQ4A:10
        a=7-415B0cAAAA:8 a=FYngU7YRcIdBeTn2k04A:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 09, 2020 at 09:02:52AM +0100, Christoph Hellwig wrote:
> On Fri, Mar 06, 2020 at 11:09:17AM -0500, Brian Foster wrote:
> > On Fri, Mar 06, 2020 at 07:31:31AM -0700, Christoph Hellwig wrote:
> > > Remove the ignored return value from xfs_log_unmount_write, and also
> > > remove a rather pointless assert on the return value from xfs_log_force.
> > > 
> > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > > ---
> > 
> > I guess there's going to be obvious conflicts with Dave's series and
> > some of these changes. I'm just going to ignore that and you guys can
> > figure it out. :)
> 
> I'm glad to rebase this on top of the parts of his series that I think
> make sense.  Just wanted to send this out for now to show what I have
> in mind in this area.

FWIW, I'm typing limited at the moment because of a finger injury.

I was planning to rebase mine on the first 6 patches of this series
(i.e. all but the IOERROR removal patch) a couple of days ago, but
I'm really slow at getting stuff done at the moment. So if Darrick
is happy with this patchset, don't let my cleanup hold it up.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
