Return-Path: <linux-xfs+bounces-11839-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 132A4959E2E
	for <lists+linux-xfs@lfdr.de>; Wed, 21 Aug 2024 15:09:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 459001C2222A
	for <lists+linux-xfs@lfdr.de>; Wed, 21 Aug 2024 13:09:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74E7E199946;
	Wed, 21 Aug 2024 13:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EaLrV0ll"
X-Original-To: linux-xfs@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D145515FA92
	for <linux-xfs@vger.kernel.org>; Wed, 21 Aug 2024 13:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724245738; cv=none; b=gV3bnuWp/NGWNmcBafAfVc8HZWvBvxS1NX89qcq1cJ5m+GfT1fxRJpiTHVtI1hpB4S4dw0/D//yul8JQOzPNuB06isur9EETWShCakhLDrLB2pTYqKXOfcK/c2yYJ1RGf4f0aicV5CJ56GMlOIhQu7EHMYoW5/LWR2GSJIgdpM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724245738; c=relaxed/simple;
	bh=ybJQR0hiEiFX55/zKRUixsPea5djDrknKPtGT0oPRGw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NsggwRfEg3OTr2OeCgDJnHle3dd9McsrdCA2ExpCIJrs/sYREdkm+Yh/hryMyTkdMRxGonHWSZFpb6LwgYrr1GUtavHc0ZAbpUSp4h2H1VhF1uvax18rhp3J847C4nSDxFQFlRfVEI9dBjSOD6z/dSOD0Pm2tUJT4j+/6E+KJSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EaLrV0ll; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724245735;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ftzy8wmPd1fIZosJOmF+YzPd6W3yB3pGQ4TDRBMo1RA=;
	b=EaLrV0llNezbE+vTRudHgSm5RK6ELw77hgcu059wFwsueiffB5on7fzVd6EPwbeuvjaLAH
	WhtTKCAOwXkJYSkmdekFoY8fsHzVz0RuyA7dvrQQOtxUGa9i9CcWkQNR1TflujyVmDAseW
	tTxdw/hyD8ThSLVfOSuFa8w5wt3ehx0=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-655-SIV7iMHCOnWkrfCYlssVvw-1; Wed,
 21 Aug 2024 09:08:51 -0400
X-MC-Unique: SIV7iMHCOnWkrfCYlssVvw-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2F5F31954B2A;
	Wed, 21 Aug 2024 13:08:48 +0000 (UTC)
Received: from bfoster (unknown [10.22.33.147])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 54F5C19560AA;
	Wed, 21 Aug 2024 13:08:45 +0000 (UTC)
Date: Wed, 21 Aug 2024 09:09:41 -0400
From: Brian Foster <bfoster@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Chandan Babu R <chandan.babu@oracle.com>,
	Jens Axboe <axboe@kernel.dk>, Jan Kara <jack@suse.cz>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Theodore Ts'o <tytso@mit.edu>, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-ext4@vger.kernel.org
Subject: Re: [PATCH 6/6] xfs: refactor xfs_file_fallocate
Message-ID: <ZsXnFYIwww-Y6JH8@bfoster>
References: <20240821063108.650126-1-hch@lst.de>
 <20240821063108.650126-7-hch@lst.de>
 <ZsXhL_pJhq2qyy-l@bfoster>
 <20240821125756.GA21319@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240821125756.GA21319@lst.de>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

On Wed, Aug 21, 2024 at 02:57:56PM +0200, Christoph Hellwig wrote:
> On Wed, Aug 21, 2024 at 08:44:31AM -0400, Brian Foster wrote:
> > > +	error = xfs_reflink_unshare(XFS_I(inode), offset, len);
> > > +	if (error)
> > > +		return error;
> > > +
> > 
> > Doesn't unshare imply alloc?
> 
> Yes, ooks like that got lost and no test noticed it
> 
> > > -	if (xfs_file_sync_writes(file))
> > > +	if (!error && xfs_file_sync_writes(file))
> > >  		error = xfs_log_force_inode(ip);
> > 
> > I'd think if you hit -ENOSPC or something after doing a partial alloc to
> > a sync inode, you'd still want to flush the changes that were made..?
> 
> Persistence behavior on error is always undefined.  And that's also
> what the current code does, as it jumps past the log force from all
> error exits.
> 

Ok, if this preserves existing behavior then I'm not too worried about
it. Thanks.

Brian


