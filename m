Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2373A80F93
	for <lists+linux-xfs@lfdr.de>; Mon,  5 Aug 2019 02:23:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726709AbfHEAXa (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 4 Aug 2019 20:23:30 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:59042 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726621AbfHEAX3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 4 Aug 2019 20:23:29 -0400
Received: from dread.disaster.area (pa49-181-167-148.pa.nsw.optusnet.com.au [49.181.167.148])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id A7108438EAC;
        Mon,  5 Aug 2019 10:23:25 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1huQkw-00050c-Nc; Mon, 05 Aug 2019 10:21:42 +1000
Date:   Mon, 5 Aug 2019 10:21:42 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
Cc:     Goldwyn Rodrigues <rgoldwyn@suse.de>, linux-xfs@vger.kernel.org,
        linux-nvdimm@lists.01.org, darrick.wong@oracle.com,
        linux-kernel@vger.kernel.org, gujx@cn.fujitsu.com,
        qi.fuli@fujitsu.com, caoj.fnst@cn.fujitsu.com
Subject: Re: [RFC PATCH 0/7] xfs: add reflink & dedupe support for fsdax.
Message-ID: <20190805002142.GV7777@dread.disaster.area>
References: <20190731114935.11030-1-ruansy.fnst@cn.fujitsu.com>
 <20190731203324.7vjwlejmwpghpvqi@fiona>
 <800ff77a-7cd1-5fa1-fcf7-e41264a3f189@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <800ff77a-7cd1-5fa1-fcf7-e41264a3f189@cn.fujitsu.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0 cx=a_idp_d
        a=gu9DDhuZhshYSb5Zs/lkOA==:117 a=gu9DDhuZhshYSb5Zs/lkOA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=FmdZ9Uzk2mMA:10
        a=7-415B0cAAAA:8 a=5uzjyc-vXknmC19CI-UA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 01, 2019 at 09:37:04AM +0800, Shiyang Ruan wrote:
> 
> 
> On 8/1/19 4:33 AM, Goldwyn Rodrigues wrote:
> > On 19:49 31/07, Shiyang Ruan wrote:
> > > This patchset aims to take care of this issue to make reflink and dedupe
> > > work correctly in XFS.
> > > 
> > > It is based on Goldwyn's patchsets: "v4 Btrfs dax support" and "Btrfs
> > > iomap".  I picked up some patches related and made a few fix to make it
> > > basically works fine.
> > > 
> > > For dax framework:
> > >    1. adapt to the latest change in iomap.
> > > 
> > > For XFS:
> > >    1. report the source address and set IOMAP_COW type for those write
> > >       operations that need COW.
> > >    2. update extent list at the end.
> > >    3. add file contents comparison function based on dax framework.
> > >    4. use xfs_break_layouts() to support dax.
> > 
> > Shiyang,
> > 
> > I think you used the older patches which does not contain the iomap changes
> > which would call iomap_begin() with two iomaps. I have it in the btrfs-iomap
> 
> Oh, Sorry for my carelessness.  This patchset is built on your "Btrfs
> iomap".  I didn't point it out in cover letter.
> 
> > branch and plan to update it today. It is built on v5.3-rcX, so it should
> > contain the changes which moves the iomap code to the different directory.
> > I will build the dax patches on top of that.
> > However, we are making a big dependency chain here
> Don't worry.  It's fine for me.  I'll follow your updates.

Hi Shiyang,

I'll wait for you to update your patches on top of the latest btrfs
patches before looking at this any futher. it would be good to get
a set of iomap infrastructure patches separated from the btrfs
patchsets so could have them both built from a common patchset.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
