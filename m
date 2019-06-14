Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B33564550B
	for <lists+linux-xfs@lfdr.de>; Fri, 14 Jun 2019 08:52:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725837AbfFNGwy (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 14 Jun 2019 02:52:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41872 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725834AbfFNGwy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 14 Jun 2019 02:52:54 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5399D307CDF2;
        Fri, 14 Jun 2019 06:52:53 +0000 (UTC)
Received: from ming.t460p (ovpn-8-17.pek2.redhat.com [10.72.8.17])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A97722CE56;
        Fri, 14 Jun 2019 06:52:46 +0000 (UTC)
Date:   Fri, 14 Jun 2019 14:52:40 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>,
        David Gibson <david@gibson.dropbear.id.au>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-block@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: alternative take on the same page merging leak fix v2
Message-ID: <20190614065239.GA24393@ming.t460p>
References: <20190613095529.25005-1-hch@lst.de>
 <00c908ad-ca33-164d-3741-6c67813c1f0d@kernel.dk>
 <20190614011946.GB14436@ming.t460p>
 <20190614054514.GB6722@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190614054514.GB6722@lst.de>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Fri, 14 Jun 2019 06:52:54 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 14, 2019 at 07:45:14AM +0200, Christoph Hellwig wrote:
> On Fri, Jun 14, 2019 at 09:19:47AM +0800, Ming Lei wrote:
> > On Thu, Jun 13, 2019 at 04:04:03AM -0600, Jens Axboe wrote:
> > > On 6/13/19 3:55 AM, Christoph Hellwig wrote:
> > > > Hi Jens, hi Ming,
> > > > 
> > > > this is the tested and split version of what I think is the better
> > > > fix for the get_user_pages page leak, as it leaves the intelligence
> > > > in the callers instead of in bio_try_to_merge_page.
> > > > 
> > > > Changes since v1:
> > > >   - drop patches not required for 5.2
> > > >   - added Reviewed-by tags
> > > 
> > > Applied for 5.2, thanks.
> > 
> > Hi Jens & Christoph,
> > 
> > Looks the following change is missed in patch 1, otherwise kernel oops
> > is triggered during kernel booting:
> 
> Ok, true, sorry.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> and you probably want to cook it up for Jens with a proper changelog.

This one can be wrapped into the patch 1 given it is just at top of
for-linus, so I guess Jens may do it.

Thanks,
Ming
