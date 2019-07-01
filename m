Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28A43528FC
	for <lists+linux-xfs@lfdr.de>; Tue, 25 Jun 2019 12:06:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727178AbfFYKGD (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 25 Jun 2019 06:06:03 -0400
Received: from verein.lst.de ([213.95.11.211]:33375 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726274AbfFYKGD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 25 Jun 2019 06:06:03 -0400
Received: by newverein.lst.de (Postfix, from userid 2407)
        id 4F45B68B05; Tue, 25 Jun 2019 12:05:32 +0200 (CEST)
Date:   Tue, 25 Jun 2019 12:05:32 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Subject: Re: xfs cgroup writeback support
Message-ID: <20190625100532.GE1462@lst.de>
References: <20190624134315.21307-1-hch@lst.de> <20190625032527.GF1611011@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190625032527.GF1611011@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 24, 2019 at 08:25:27PM -0700, Darrick J. Wong wrote:
> By the way, did all the things Dave complained about in last year's
> attempt[1] to add cgroup writeback support get fixed?  IIRC someone
> whose name I didn't recognise complained about log starvation due to
> REQ_META bios being charged to the wrong cgroup and other misbehavior.

As mentioned in the reference thread while the metadata throttling is
an issue, it is in existing one and not one touched by the cgroup
writeback support.  This patch just ensures that writeback takes the
cgroup information from the inode instead of the current task.  The
fact that blkcg should not even look at any cgroup information for
REQ_META is something that should be fixed entirely in core cgroup
code is orthogonal to how we pick the attached cgroup.

> Also, I remember that in the earlier 2017 discussion[2] we talked about
> a fstest to test that writeback throttling actually capped bandwidth
> usage correctly.  I haven't been following cgroupwb development since
> 2017 -- does it not ratelimit bandwidth now, or is there some test for
> that?  The only test I could find was shared/011 which only tests the
> accounting, not bandwidth.

As far as I can tell cfq could limit bandwith, but cgq is done now.
Either way all that is hiddent way below us.
