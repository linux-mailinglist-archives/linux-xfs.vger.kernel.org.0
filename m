Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE092608C7
	for <lists+linux-xfs@lfdr.de>; Fri,  5 Jul 2019 17:11:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725730AbfGEPLE (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 5 Jul 2019 11:11:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59929 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725497AbfGEPLD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 5 Jul 2019 11:11:03 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 64BDE2F8BF9;
        Fri,  5 Jul 2019 15:10:48 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 257B980A31;
        Fri,  5 Jul 2019 15:10:47 +0000 (UTC)
Date:   Fri, 5 Jul 2019 11:10:45 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Yafang Shao <laoar.shao@gmail.com>
Cc:     Michal Hocko <mhocko@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux MM <linux-mm@kvack.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        Shakeel Butt <shakeelb@google.com>,
        Yafang Shao <shaoyafang@didiglobal.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH] mm, memcg: support memory.{min, low} protection in
 cgroup v1
Message-ID: <20190705151045.GI37448@bfoster>
References: <1562310330-16074-1-git-send-email-laoar.shao@gmail.com>
 <20190705090902.GF8231@dhcp22.suse.cz>
 <CALOAHbAw5mmpYJb4KRahsjO-Jd0nx1CE+m0LOkciuL6eJtavzQ@mail.gmail.com>
 <20190705111043.GJ8231@dhcp22.suse.cz>
 <CALOAHbA3PL6-sBqdy-sGKC8J9QGe_vn4-QU8J1HG-Pgn60WFJA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALOAHbA3PL6-sBqdy-sGKC8J9QGe_vn4-QU8J1HG-Pgn60WFJA@mail.gmail.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Fri, 05 Jul 2019 15:11:03 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

cc linux-xfs

On Fri, Jul 05, 2019 at 10:33:04PM +0800, Yafang Shao wrote:
> On Fri, Jul 5, 2019 at 7:10 PM Michal Hocko <mhocko@kernel.org> wrote:
> >
> > On Fri 05-07-19 17:41:44, Yafang Shao wrote:
> > > On Fri, Jul 5, 2019 at 5:09 PM Michal Hocko <mhocko@kernel.org> wrote:
> > [...]
> > > > Why cannot you move over to v2 and have to stick with v1?
> > > Because the interfaces between cgroup v1 and cgroup v2 are changed too
> > > much, which is unacceptable by our customer.
> >
> > Could you be more specific about obstacles with respect to interfaces
> > please?
> >
> 
> Lots of applications will be changed.
> Kubernetes, Docker and some other applications which are using cgroup v1,
> that will be a trouble, because they are not maintained by us.
> 
> > > It may take long time to use cgroup v2 in production envrioment, per
> > > my understanding.
> > > BTW, the filesystem on our servers is XFS, but the cgroup  v2
> > > writeback throttle is not supported on XFS by now, that is beyond my
> > > comprehension.
> >
> > Are you sure? I would be surprised if v1 throttling would work while v2
> > wouldn't. As far as I remember it is v2 writeback throttling which
> > actually works. The only throttling we have for v1 is reclaim based one
> > which is a huge hammer.
> > --
> 
> We did it in cgroup v1 in our kernel.
> But the upstream still don't support it in cgroup v2.
> So my real question is why upstream can't support such an import file system ?
> Do you know which companies  besides facebook are using cgroup v2  in
> their product enviroment?
> 

I think the original issue with regard to XFS cgroupv2 writeback
throttling support was that at the time the XFS patch was proposed,
there wasn't any test coverage to prove that the code worked (and the
original author never followed up). That has since been resolved and
Christoph has recently posted a new patch [1], which appears to have
been accepted by the maintainer.

Brian

[1] https://marc.info/?l=linux-xfs&m=156138379906141&w=2

> Thanks
> Yafang
> 
