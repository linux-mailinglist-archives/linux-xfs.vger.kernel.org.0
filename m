Return-Path: <linux-xfs+bounces-682-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5975C81111E
	for <lists+linux-xfs@lfdr.de>; Wed, 13 Dec 2023 13:29:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1462F281BA1
	for <lists+linux-xfs@lfdr.de>; Wed, 13 Dec 2023 12:29:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0769B28E3D;
	Wed, 13 Dec 2023 12:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ATa2EoG7"
X-Original-To: linux-xfs@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39C80D5
	for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2023 04:28:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702470537;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pQFnI7fDR+1BAkKjvQWdPrG/WDERRoUrQCJ/FGh+Rlo=;
	b=ATa2EoG7yeXPQF7oUhItymzIaC8q9Yxx8SY5HOdQM9Brfzz+WKQhTN2dNI/Hs0u9PbzN7z
	G5ci4Fk4uhGNh0HRU+DeMc30jisY791sWu1U9H4zpjezu9raYqX3giPuxY6T55D86C4RvC
	wGGZyd0fIWKH1tTNNOfSuzvQ45FSV2c=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-445-5O6-tQb-PP2YT148se2a5g-1; Wed, 13 Dec 2023 07:28:53 -0500
X-MC-Unique: 5O6-tQb-PP2YT148se2a5g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1A11585A58A;
	Wed, 13 Dec 2023 12:28:52 +0000 (UTC)
Received: from fedora (unknown [10.72.116.126])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 80AAA1121312;
	Wed, 13 Dec 2023 12:28:42 +0000 (UTC)
Date: Wed, 13 Dec 2023 20:28:38 +0800
From: Ming Lei <ming.lei@redhat.com>
To: John Garry <john.g.garry@oracle.com>
Cc: axboe@kernel.dk, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me,
	jejb@linux.ibm.com, martin.petersen@oracle.com, djwong@kernel.org,
	viro@zeniv.linux.org.uk, brauner@kernel.org, dchinner@redhat.com,
	jack@suse.cz, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	tytso@mit.edu, jbongio@google.com, linux-scsi@vger.kernel.org,
	jaswin@linux.ibm.com, bvanassche@acm.org,
	Himanshu Madhani <himanshu.madhani@oracle.com>
Subject: Re: [PATCH v2 01/16] block: Add atomic write operations to
 request_queue limits
Message-ID: <ZXmjdnIqGHILTfQN@fedora>
References: <20231212110844.19698-1-john.g.garry@oracle.com>
 <20231212110844.19698-2-john.g.garry@oracle.com>
 <ZXkIEnQld577uHqu@fedora>
 <36ee54b4-b8d5-4b3c-81a0-cc824b6ef68e@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <36ee54b4-b8d5-4b3c-81a0-cc824b6ef68e@oracle.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3

On Wed, Dec 13, 2023 at 09:13:48AM +0000, John Garry wrote:
> > > +
> > >   What:		/sys/block/<disk>/diskseq
> > >   Date:		February 2021
> > > diff --git a/block/blk-settings.c b/block/blk-settings.c
> > > index 0046b447268f..d151be394c98 100644
> > > --- a/block/blk-settings.c
> > > +++ b/block/blk-settings.c
> > > @@ -59,6 +59,10 @@ void blk_set_default_limits(struct queue_limits *lim)
> > >   	lim->zoned = BLK_ZONED_NONE;
> > >   	lim->zone_write_granularity = 0;
> > >   	lim->dma_alignment = 511;
> > > +	lim->atomic_write_unit_min_sectors = 0;
> > > +	lim->atomic_write_unit_max_sectors = 0;
> > > +	lim->atomic_write_max_sectors = 0;
> > > +	lim->atomic_write_boundary_sectors = 0;
> > 
> > Can we move the four into single structure
> 
> There is no precedent for a similar structure in struct queue_limits. So
> would only passing a structure to the blk-settings.c API be ok?

Yes, this structure is part of the new API.

> 
> > and setup them in single
> > API? Then cross-validation can be done in this API.
> 
> I suppose so, if you think that it is better.
> 
> We rely on the driver to provide sound values. I suppose that we can
> sanitize them also (in a single API).

Please make the interface correct from beginning, and one good API is
helpful for both sides, such as isolating problems, easy to locate
bug, abstracting common logic, ...

And relying on API users is absolutely not good design.

> 
> > 
> > >   }
> > >   /**
> > > @@ -183,6 +187,62 @@ void blk_queue_max_discard_sectors(struct request_queue *q,
> > >   }
> > >   EXPORT_SYMBOL(blk_queue_max_discard_sectors);
> > > +/**
> > > + * blk_queue_atomic_write_max_bytes - set max bytes supported by
> > > + * the device for atomic write operations.
> > > + * @q:  the request queue for the device
> > > + * @size: maximum bytes supported
> > > + */
> > > +void blk_queue_atomic_write_max_bytes(struct request_queue *q,
> > > +				      unsigned int bytes)
> > > +{
> > > +	q->limits.atomic_write_max_sectors = bytes >> SECTOR_SHIFT;
> > > +}
> > > +EXPORT_SYMBOL(blk_queue_atomic_write_max_bytes);
> > 
> > What if driver doesn't call it but driver supports atomic write?
> 
> We rely on the driver to do this. Any basic level of testing will show an
> issue if they don't.

Software quality depends on good requirement analysis, design and
implementation, instead of test.

Simply you can not cover all possibilities in test.

> 
> > 
> > I guess the default max sectors should be atomic_write_unit_max_sectors
> > if the feature is enabled.
> 
> Sure. If we have a single API to set all values, then we don't need to worry
> about this (assuming the values are filled in properly).
> 
> > 
> > > +
> > > +/**
> > > + * blk_queue_atomic_write_boundary_bytes - Device's logical block address space
> > > + * which an atomic write should not cross.
> > > + * @q:  the request queue for the device
> > > + * @bytes: must be a power-of-two.
> > > + */
> > > +void blk_queue_atomic_write_boundary_bytes(struct request_queue *q,
> > > +					   unsigned int bytes)
> > > +{
> > > +	q->limits.atomic_write_boundary_sectors = bytes >> SECTOR_SHIFT;
> > > +}
> > > +EXPORT_SYMBOL(blk_queue_atomic_write_boundary_bytes);
> > 
> > Default atomic_write_boundary_sectors should be
> > atomic_write_unit_max_sectors in case of atomic write?
> 
> Having atomic_write_boundary_sectors default to
> atomic_write_unit_max_sectors is effectively same as a default of 0.
> 
> > 
> > > +
> > > +/**
> > > + * blk_queue_atomic_write_unit_min_sectors - smallest unit that can be written
> > > + * atomically to the device.
> > > + * @q:  the request queue for the device
> > > + * @sectors: must be a power-of-two.
> > > + */
> > > +void blk_queue_atomic_write_unit_min_sectors(struct request_queue *q,
> > > +					     unsigned int sectors)
> > > +{
> > > +	struct queue_limits *limits = &q->limits;
> > > +
> > > +	limits->atomic_write_unit_min_sectors = sectors;
> > > +}
> > > +EXPORT_SYMBOL(blk_queue_atomic_write_unit_min_sectors);
> > 
> > atomic_write_unit_min_sectors should be >= (physical block size >> 9)
> > given the minimized atomic write unit is physical sector for all disk.
> 
> For SCSI, we have a granularity VPD value, and when set we pay attention to
> that. If not, we use the phys block size.
> 
> For NVMe, we use the logical block size. For physical block size, that can
> be greater than the logical block size for npwg set, and I don't think it's
> suitable use that as minimum atomic write unit.

I highly suspect it is wrong to use logical block size as minimum
support atomic write unit, given physical block size is supposed to
be the minimum atomic write unit.

> 
> Anyway, I am not too keen on sanitizing this value in this way.
> 
> > 
> > > +
> > > +/*
> > > + * blk_queue_atomic_write_unit_max_sectors - largest unit that can be written
> > > + * atomically to the device.
> > > + * @q: the request queue for the device
> > > + * @sectors: must be a power-of-two.
> > > + */
> > > +void blk_queue_atomic_write_unit_max_sectors(struct request_queue *q,
> > > +					     unsigned int sectors)
> > > +{
> > > +	struct queue_limits *limits = &q->limits;
> > > +
> > > +	limits->atomic_write_unit_max_sectors = sectors;
> > > +}
> > > +EXPORT_SYMBOL(blk_queue_atomic_write_unit_max_sectors);
> > 
> > atomic_write_unit_max_sectors should be >= atomic_write_unit_min_sectors.
> > 
> 
> Again, we rely on the driver to provide sound values. However, as mentioned,
> we can sanitize.

Relying on driver to provide sound value is absolutely bad design from API
viewpoint.

Thanks,
Ming


