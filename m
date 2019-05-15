Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 889C01F6C0
	for <lists+linux-xfs@lfdr.de>; Wed, 15 May 2019 16:42:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727337AbfEOOma (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 15 May 2019 10:42:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34546 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726084AbfEOOma (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 May 2019 10:42:30 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4F36530A01B1;
        Wed, 15 May 2019 14:42:30 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E8A6A63B8B;
        Wed, 15 May 2019 14:42:29 +0000 (UTC)
Date:   Wed, 15 May 2019 10:42:28 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/6] xfs: refactor by-size extent allocation mode
Message-ID: <20190515144227.GE2898@bfoster>
References: <20190509165839.44329-1-bfoster@redhat.com>
 <20190509165839.44329-6-bfoster@redhat.com>
 <20190510173413.GD18992@infradead.org>
 <20190513154610.GF61135@bfoster>
 <20190515081016.GJ29211@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190515081016.GJ29211@infradead.org>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Wed, 15 May 2019 14:42:30 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 15, 2019 at 01:10:16AM -0700, Christoph Hellwig wrote:
> > WRT to merging the functions, I'm a little concerned about the result
> > being too large. What do you think about folding in _vextent_type() but
> > at the same time factoring out the rmap/counter/resv post alloc bits
> > into an xfs_alloc_ag_vextent_accounting() helper or some such?
> 
> Sounds good to me.  I've looked at the function and another nice thing
> to do would be to not pass the ret bno to xfs_alloc_ag_vextent_agfl,
> but let that function fill out the args structure return value itself.
> 

I believe that's what the existing xfs_alloc_ag_vextent_small() function
does if it happens to allocate from the AGFL. I initially found that
inconsistent, but looking at the additional refactoring with the _type()
function folded away and whatnot I think it's actually better. I'll push
the args update back down into the AGFL helper.

> Also for the trace piints that still say near in them - maybe we should
> change that near to ag?

Yeah, I need to make another pass over the tracepoints...

Brian
