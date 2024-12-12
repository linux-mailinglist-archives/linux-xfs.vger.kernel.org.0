Return-Path: <linux-xfs+bounces-16557-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A8EB9EE7A6
	for <lists+linux-xfs@lfdr.de>; Thu, 12 Dec 2024 14:28:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 51EB2281D8A
	for <lists+linux-xfs@lfdr.de>; Thu, 12 Dec 2024 13:28:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CB7221421C;
	Thu, 12 Dec 2024 13:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PW5fQ9H7"
X-Original-To: linux-xfs@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5301E2135B8
	for <linux-xfs@vger.kernel.org>; Thu, 12 Dec 2024 13:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734010089; cv=none; b=G2nsZ7XgpsdZF+gpzKiEmDPxdJgrw7K1sjvlAaFnV8ZsjCQrWvm2thwD/QgF5GGK21jSXK4Zflk3XCMsrstEaMOlXXPq5/bfKUQWoH+Y+Cy992TdXp4xQldvo+lwQslNQTGKJ5TEKsxA2qVhpPywslLrcqVI2VwnnhMILho+tQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734010089; c=relaxed/simple;
	bh=cvjPOTd1DpEMLuCP1gjefrv8LE6PWfqZ2TNSnsCsxqU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o01sA/CEhreWSAbDlOWhxx8qYLZaKqnC70SBZSZZpHC6hjjlJNNXy4E+6zMaDhp7iKx3dur2dERimocXtM6y7nwvnv6fzLOYZ2zYZZZPXtuS5yxrKeB06h+9eagIvT2u92/cZw8NQTDvXQ0HxT2rjleVmo09sTPcxq9/xeSji4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PW5fQ9H7; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734010087;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=B8ga3Fxf0BDxyz8CsLNkt3r/yd6VG4wP4xOFplptOfc=;
	b=PW5fQ9H7RIteDbQF7VLBNTPp30JoCzof86EpR9Pu2up++E3sQdawtMfjWWw8YSfy8toVKn
	Pp+KDe0KCdVD9yCPIeoeJ3yNGsS3ryFx/1OhDBJuvU2TzcMbyYFpeNAHPOXujWd76hBFkL
	UAuTmPfQMmk+8Fy4yke0iuRoefnA9Zc=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-119-MqecxjqKOgSW0hMDXjXjzg-1; Thu,
 12 Dec 2024 08:28:03 -0500
X-MC-Unique: MqecxjqKOgSW0hMDXjXjzg-1
X-Mimecast-MFC-AGG-ID: MqecxjqKOgSW0hMDXjXjzg
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9A0341956096;
	Thu, 12 Dec 2024 13:28:01 +0000 (UTC)
Received: from bfoster (unknown [10.22.90.12])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 91DB7195606C;
	Thu, 12 Dec 2024 13:28:00 +0000 (UTC)
Date: Thu, 12 Dec 2024 08:29:47 -0500
From: Brian Foster <bfoster@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: RFC: iomap patches for zoned XFS
Message-ID: <Z1rlS6j8iAqAynsz@bfoster>
References: <20241211085420.1380396-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241211085420.1380396-1-hch@lst.de>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

On Wed, Dec 11, 2024 at 09:53:40AM +0100, Christoph Hellwig wrote:
> Hi all,
> 
> this series contains the iomap prep work to support zoned XFS.
> 
> The biggest changes are:
> 
>  - an option to reuse the ioend code for direct writes in addition to the
>    current use for buffered writeback, which allows the file system to
>    track completions on a per-bio basis instead of the current end_io
>    callback which operates on the entire I/O.
>    Note that it might make sense to split the ioend code from
>    buffered-io.c into its own file with this.  Let me know what you think
>    of that and I can include it in the next version
>  - change of the writeback_ops so that the submit_bio call can be done by
>    the file system.  Note that btrfs will also need this eventually when
>    it starts using iomap
>  - helpers to split ioend to the zone append queue_limits that plug
>    into the previous item above.
>  - a bunch of changes for slightly different merge conditions when using
>    zone append.  Note that btrfs wants something similar also for
>    compressed I/O, which might be able to share some code.  For now
>    the flags use zone append naming, but we can change that if it gets
>    used elsewhere.
>  - passing private data to a few more helper
> 
> The XFS changes to use this will be posted to the xfs list only to not
> spam fsdevel too much.
> 

Orthogonal to the couple or so questions inline, the series LGTM:

Reviewed-by: Brian Foster <bfoster@redhat.com>


