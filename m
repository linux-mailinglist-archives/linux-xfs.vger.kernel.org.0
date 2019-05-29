Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F72F2E80B
	for <lists+linux-xfs@lfdr.de>; Thu, 30 May 2019 00:20:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726311AbfE2WUI (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 29 May 2019 18:20:08 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:35189 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726018AbfE2WUI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 May 2019 18:20:08 -0400
Received: from dread.disaster.area (pa49-180-144-61.pa.nsw.optusnet.com.au [49.180.144.61])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id EED06105FEAB;
        Thu, 30 May 2019 08:20:06 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1hW6vU-0007sC-R5; Thu, 30 May 2019 08:20:04 +1000
Date:   Thu, 30 May 2019 08:20:04 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Jeffrey Baker <jwbaker@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: Recurring hand in XFS inode reclaim on 4.10
Message-ID: <20190529222004.GD29573@dread.disaster.area>
References: <CAMCX63xyxZwiPd0602im0M0m4jzSNfB3DcF1RekQ6A-03vXTmg@mail.gmail.com>
 <20190521224904.GI29573@dread.disaster.area>
 <CAMCX63zNvLCDE5ZmY-rUuF7JfL9Uauq4jvzPZuDecovUSnCLNQ@mail.gmail.com>
 <20190527033240.GA29573@dread.disaster.area>
 <CAMCX63wUkBh==QFoeRSTxFKGdoo5iDLS6hM5xcVLK8_LfVdhwg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMCX63wUkBh==QFoeRSTxFKGdoo5iDLS6hM5xcVLK8_LfVdhwg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0 cx=a_idp_d
        a=8RU0RCro9O0HS2ezTvitPg==:117 a=8RU0RCro9O0HS2ezTvitPg==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=E5NmQfObTbMA:10
        a=7-415B0cAAAA:8 a=i41yqxuNaHt4J_ERibwA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 28, 2019 at 10:16:39AM -0700, Jeffrey Baker wrote:
> On Sun, May 26, 2019 at 8:32 PM Dave Chinner <david@fromorbit.com> wrote:
> > On Fri, May 24, 2019 at 01:34:58PM -0700, Jeffrey Baker wrote:
> > > Write rates on the nvme drives are all exactly the md0 rates / 4, so
> > > that seems normal.
> >
> > Write rates aren't that important - what do the io latencies, queue
> > depths and device utilisation figures look like?
> 
> 10s of microseconds, ~zero, and ~zero respectively.

So it sounds like the devices aren't showing signs of slowness, but
the filesystem and memory reclaim is sitting there twiddling it's
thumbs waiting for IO to complete?

Perhaps it might be worthwhile running a latency trace (e.g. with
ftrace or one of the newfangled bpf tools) to find out where
everything is blocking and how long they are waiting for things to
occur. That might give some more insight into what resource we are
waiting to be released to make progress...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
