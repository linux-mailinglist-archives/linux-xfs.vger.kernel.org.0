Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33BA4FCF9F
	for <lists+linux-xfs@lfdr.de>; Thu, 14 Nov 2019 21:24:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbfKNUYJ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 14 Nov 2019 15:24:09 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:54791 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726474AbfKNUYJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Nov 2019 15:24:09 -0500
Received: from dread.disaster.area (pa49-181-255-80.pa.nsw.optusnet.com.au [49.181.255.80])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 3D5E743E7D2;
        Fri, 15 Nov 2019 07:24:04 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1iVLer-0002xv-KL; Fri, 15 Nov 2019 07:24:01 +1100
Date:   Fri, 15 Nov 2019 07:24:01 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        linux-nvdimm <linux-nvdimm@lists.01.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Goldwyn Rodrigues <rgoldwyn@suse.de>,
        Christoph Hellwig <hch@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        gujx@cn.fujitsu.com, qi.fuli@fujitsu.com
Subject: Re: [RFC PATCH v2 0/7] xfs: reflink & dedupe for fsdax (read/write
 path).
Message-ID: <20191114202401.GB4614@dread.disaster.area>
References: <20191030041358.14450-1-ruansy.fnst@cn.fujitsu.com>
 <e33532a2-a9e5-1578-bdd8-a83d4710a151@cn.fujitsu.com>
 <CAPcyv4ivOgMNdvWTtpXw2aaR0o7MEQZ=cDiy=_P9qhVb3QVWdQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4ivOgMNdvWTtpXw2aaR0o7MEQZ=cDiy=_P9qhVb3QVWdQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=G6BsK5s5 c=1 sm=1 tr=0
        a=XqaD5fcB6dAc7xyKljs8OA==:117 a=XqaD5fcB6dAc7xyKljs8OA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=MeAgGD-zjQ4A:10
        a=omOdbC7AAAAA:8 a=7-415B0cAAAA:8 a=LDxVRJNMUMF_87RH2osA:9
        a=CjuIK1q_8ugA:10 a=baC4JDFNLZpnPwus_NF9:22 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 07, 2019 at 07:30:32PM -0800, Dan Williams wrote:
> On Thu, Nov 7, 2019 at 7:11 PM Shiyang Ruan <ruansy.fnst@cn.fujitsu.com> wrote:
> >
> > Hi Darrick, Dave,
> >
> > Do you have any comment on this?
> 
> Christoph pointed out at ALPSS that this problem has significant
> overlap with the shared page-cache for reflink problem. So I think we
> need to solve that first and then circle back to dax reflink support.
> I'm starting to take a look at that.

I think the DAX side is somewhat simpler because it doesn't really
need to involve the page cache and we don't have to worry about
subtly breaking random filesystems. Hence I'd suggest we sort out a
solution for DAX first, then worry about page cache stuff. The
shared page cache for reflink feature is not a show stopper -
multiple references for DAX is a show stopper. Let's deal with the
DAX problem first.

Cheers,

-Dave.
-- 
Dave Chinner
david@fromorbit.com
