Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BD5F419D7
	for <lists+linux-xfs@lfdr.de>; Wed, 12 Jun 2019 03:10:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407531AbfFLBJf (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 11 Jun 2019 21:09:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57562 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406555AbfFLBJf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 11 Jun 2019 21:09:35 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5A72C2F8BC4;
        Wed, 12 Jun 2019 01:09:35 +0000 (UTC)
Received: from ming.t460p (ovpn-8-21.pek2.redhat.com [10.72.8.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 32C43614C4;
        Wed, 12 Jun 2019 01:09:28 +0000 (UTC)
Date:   Wed, 12 Jun 2019 09:09:23 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>,
        David Gibson <david@gibson.dropbear.id.au>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-block@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: alternative take on the same page merging leak fix
Message-ID: <20190612010922.GA17522@ming.t460p>
References: <20190611151007.13625-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190611151007.13625-1-hch@lst.de>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Wed, 12 Jun 2019 01:09:35 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Christoph,

On Tue, Jun 11, 2019 at 05:10:02PM +0200, Christoph Hellwig wrote:
> Hi Jens, hi Ming,
> 
> this is the tested and split version of what I think is the better
> fix for the get_user_pages page leak, as it leaves the intelligence
> in the callers instead of in bio_try_to_merge_page.

I am fine with either one from upstream developer view, so let Jens
decide.

However:

We have to backport the fixes to -stable tree, and downstream need to
ship the fix too.

The issue is quite serious because the leak is in IO path and the whole
system ram can be used up easily on some workloads. So I think the fix
should be for 5.2, however, regression risk might be increased by
pulling cleanup & re-factor in now.

I really appreciate you may cook a fix-only patch for this issue.
Especially the change in add pc page code isn't necessary for fixing
the issue.



Thanks,
Ming
