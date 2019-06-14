Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 258DE4542C
	for <lists+linux-xfs@lfdr.de>; Fri, 14 Jun 2019 07:45:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725891AbfFNFpn (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 14 Jun 2019 01:45:43 -0400
Received: from verein.lst.de ([213.95.11.211]:44066 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725808AbfFNFpn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 14 Jun 2019 01:45:43 -0400
Received: by newverein.lst.de (Postfix, from userid 2407)
        id 9EDEB68B02; Fri, 14 Jun 2019 07:45:14 +0200 (CEST)
Date:   Fri, 14 Jun 2019 07:45:14 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        David Gibson <david@gibson.dropbear.id.au>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-block@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: alternative take on the same page merging leak fix v2
Message-ID: <20190614054514.GB6722@lst.de>
References: <20190613095529.25005-1-hch@lst.de> <00c908ad-ca33-164d-3741-6c67813c1f0d@kernel.dk> <20190614011946.GB14436@ming.t460p>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190614011946.GB14436@ming.t460p>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 14, 2019 at 09:19:47AM +0800, Ming Lei wrote:
> On Thu, Jun 13, 2019 at 04:04:03AM -0600, Jens Axboe wrote:
> > On 6/13/19 3:55 AM, Christoph Hellwig wrote:
> > > Hi Jens, hi Ming,
> > > 
> > > this is the tested and split version of what I think is the better
> > > fix for the get_user_pages page leak, as it leaves the intelligence
> > > in the callers instead of in bio_try_to_merge_page.
> > > 
> > > Changes since v1:
> > >   - drop patches not required for 5.2
> > >   - added Reviewed-by tags
> > 
> > Applied for 5.2, thanks.
> 
> Hi Jens & Christoph,
> 
> Looks the following change is missed in patch 1, otherwise kernel oops
> is triggered during kernel booting:

Ok, true, sorry.

Reviewed-by: Christoph Hellwig <hch@lst.de>

and you probably want to cook it up for Jens with a proper changelog.
