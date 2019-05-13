Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BC631BA51
	for <lists+linux-xfs@lfdr.de>; Mon, 13 May 2019 17:46:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728288AbfEMPqN (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 13 May 2019 11:46:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42316 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728224AbfEMPqN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 13 May 2019 11:46:13 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0EABF19CBF7;
        Mon, 13 May 2019 15:46:13 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AC1555C225;
        Mon, 13 May 2019 15:46:12 +0000 (UTC)
Date:   Mon, 13 May 2019 11:46:10 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/6] xfs: refactor by-size extent allocation mode
Message-ID: <20190513154610.GF61135@bfoster>
References: <20190509165839.44329-1-bfoster@redhat.com>
 <20190509165839.44329-6-bfoster@redhat.com>
 <20190510173413.GD18992@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190510173413.GD18992@infradead.org>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Mon, 13 May 2019 15:46:13 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 10, 2019 at 10:34:13AM -0700, Christoph Hellwig wrote:
> > @@ -724,8 +723,6 @@ xfs_alloc_ag_vextent(
> >  	args->wasfromfl = 0;
> >  	switch (args->type) {
> >  	case XFS_ALLOCTYPE_THIS_AG:
> > -		error = xfs_alloc_ag_vextent_size(args);
> > -		break;
> >  	case XFS_ALLOCTYPE_NEAR_BNO:
> >  	case XFS_ALLOCTYPE_THIS_BNO:
> >  		error = xfs_alloc_ag_vextent_type(args);
> > @@ -817,6 +814,8 @@ xfs_alloc_cur_setup(
> >  
> >  	if (args->agbno != NULLAGBLOCK)
> >  		agbno = args->agbno;
> > +	if (args->type == XFS_ALLOCTYPE_THIS_AG)
> > +		acur->cur_len += args->alignment - 1;
> 
> At this point we can just kill that switch, or even better
> merge xfs_alloc_ag_vextent_type and xfs_alloc_ag_vextent.

Yeah, we can probably replace that switch with a simple assert on the
allocation type.

WRT to merging the functions, I'm a little concerned about the result
being too large. What do you think about folding in _vextent_type() but
at the same time factoring out the rmap/counter/resv post alloc bits
into an xfs_alloc_ag_vextent_accounting() helper or some such?

Brian
