Return-Path: <linux-xfs+bounces-11332-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C8E13949C7C
	for <lists+linux-xfs@lfdr.de>; Wed,  7 Aug 2024 01:52:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7DB53284EFC
	for <lists+linux-xfs@lfdr.de>; Tue,  6 Aug 2024 23:52:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7567B17625B;
	Tue,  6 Aug 2024 23:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="apxW+At4"
X-Original-To: linux-xfs@vger.kernel.org
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8FB3A59
	for <linux-xfs@vger.kernel.org>; Tue,  6 Aug 2024 23:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722988331; cv=none; b=qcwCBJ28zrVo7AP2dGCFfOUGVZ/HX6u1Yytu6IrgNtrIJ2S7u5KE83/Rkmb8hyv5ni3xd1ZNJzfqiHMaURFQC4VK5fQSzRA5hQYYbEomzLIhVx7inBSCHwqSXKd6SO/ToX+PwpVDJVZOY5KJW3bG2KeLqt/FUDhORqOW+yQgF24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722988331; c=relaxed/simple;
	bh=Jm0hEY8j/SV1FZh0Si8hSb56li35/Yiw0KWeIoYQwDs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MEYcYTnVDQlMQr6g7wIYByvGUCpuvGJDCR1ZgwwdGZ8JisnpKAxAWhAREQmP4fCfmDAU8qq7lREYqEEEAoztVD1hv/gkTQfV6kJVAvKwQOlTlBd+geZJz1yJDiSNTq6QuO9DFVaqN6UuuAG94PP5sxYMSPSQ2LHNwvLhBFMynWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=apxW+At4; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-6e7b121be30so893755a12.1
        for <linux-xfs@vger.kernel.org>; Tue, 06 Aug 2024 16:52:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1722988329; x=1723593129; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8tZQszvaJQblmvSb0R2v/S/W6bOUtf6jVNBKsq5aGLs=;
        b=apxW+At4gLABa6FPd0XyfA1IkAtf/NTEUlu3OIuE9dhrd3mHQ2iBOTW2QJSFuiknx7
         CsJauPR7I6CXqUx6+OaQwjMxI9+zHnLDHU0yobmPDbdC8DoYV+bCk+Pfjz6YK1RFkH5Q
         RKf6unjGRCUqEg+Tb2Semt5SCwFGak7d9XMoRKh2elWcJwpGkfMG6BYmbPdBcyDW3g7i
         R5m9oQegKAf0RTebnQULlyT9p5vjpn9xSdY4Wf/OQ0YLb8KKxGaajSxGXswonxn4ugoZ
         ZCb7Lq1sNkQam8OY0sjKlb66sfCucDfCEf0ibMzY1s8IW/8z+YAsoIpxmB2H8FkM7gvl
         pxiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722988329; x=1723593129;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8tZQszvaJQblmvSb0R2v/S/W6bOUtf6jVNBKsq5aGLs=;
        b=bUT0EyZkDgSrXNe1/zXKSJbvy5zXwpYwU7tgqzTa4ROLs6QcQAlTak796rkPB8V6dE
         u5It2KJ0vA2uo0x+nuJT8a13y2RxNnArRB09qIjnzH3z4z61BFB69VbXYAoskhrdHYN+
         TyZwcvwWF9UdDl7zQrpQbopTFP7TNR7i2c5D/tuq9ZXG82aEhiYvpLjf4nhnpUGi6mF7
         VAauCCxRGR1GH6O7lFlg3UMvXCZEB2nnxo9yRsjtFY811x31umk1T6MK+5rmkdfO03rB
         fUiG4zMGjzfLGjktW8lsPetQ7BJAQIuno7ilCLhapY6CHv1QlN5bPX0TYta5BNtKAgnI
         lpMw==
X-Forwarded-Encrypted: i=1; AJvYcCWfJX+Fw7dJ7r5Xe2AqDDHr5FgrV6ykjMVkYTMkFjk4dAcruPXWe/m96yZaFXmAmBTxYL6WVWKcY+CoQstqu7daw5GpNhdvARhQ
X-Gm-Message-State: AOJu0YxkyuObp3o+u+3FKeGrQMQ8OK8y7NxsWHdAZ/CMOi086Wn+yMmc
	S3xHJCceZk7rfBxlBwXFKCRDZqK+mVd/VtfVwy9TIMy/RbHNs2YjElDqf7qP7vA=
X-Google-Smtp-Source: AGHT+IGBYb0LD4iC+TEAspjupwGRwPAVKKGDnI1zPxc9eT9Lb/x4//+gafjrnfO+hOaZOVpc0GM7sQ==
X-Received: by 2002:a05:6a21:3389:b0:1c4:819f:8e0c with SMTP id adf61e73a8af0-1c69954a469mr17927330637.6.1722988328986;
        Tue, 06 Aug 2024 16:52:08 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-47-239.pa.nsw.optusnet.com.au. [49.181.47.239])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7109d5e0318sm3274086b3a.121.2024.08.06.16.52.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Aug 2024 16:52:08 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sbTyI-007vNT-0N;
	Wed, 07 Aug 2024 09:52:06 +1000
Date: Wed, 7 Aug 2024 09:52:06 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: John Garry <john.g.garry@oracle.com>, chandan.babu@oracle.com,
	dchinner@redhat.com, hch@lst.de, viro@zeniv.linux.org.uk,
	brauner@kernel.org, jack@suse.cz, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	catherine.hoang@oracle.com, martin.petersen@oracle.com
Subject: Re: [PATCH v3 03/14] xfs: simplify extent allocation alignment
Message-ID: <ZrK3JlJIV5j4h44F@dread.disaster.area>
References: <20240801163057.3981192-1-john.g.garry@oracle.com>
 <20240801163057.3981192-4-john.g.garry@oracle.com>
 <20240806185651.GG623936@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240806185651.GG623936@frogsfrogsfrogs>

On Tue, Aug 06, 2024 at 11:56:51AM -0700, Darrick J. Wong wrote:
> On Thu, Aug 01, 2024 at 04:30:46PM +0000, John Garry wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > We currently align extent allocation to stripe unit or stripe width.
> > That is specified by an external parameter to the allocation code,
> > which then manipulates the xfs_alloc_args alignment configuration in
> > interesting ways.
> > 
> > The args->alignment field specifies extent start alignment, but
> > because we may be attempting non-aligned allocation first there are
> > also slop variables that allow for those allocation attempts to
> > account for aligned allocation if they fail.
> > 
> > This gets much more complex as we introduce forced allocation
> > alignment, where extent size hints are used to generate the extent
> > start alignment. extent size hints currently only affect extent
> > lengths (via args->prod and args->mod) and so with this change we
> > will have two different start alignment conditions.
> > 
> > Avoid this complexity by always using args->alignment to indicate
> > extent start alignment, and always using args->prod/mod to indicate
> > extent length adjustment.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > [jpg: fixup alignslop references in xfs_trace.h and xfs_ialloc.c]
> > Signed-off-by: John Garry <john.g.garry@oracle.com>
> 
> Going back to the 6/21 posting[1], what were the answers to the
> questions I posted?  Did I correctly figure out what alignslop refers
> to?

Hard to say.

alignslop is basically an temporary accounting mechanism used to
prevent filesystem shutdowns when the AG is near ENOSPC and exact
BNO allocation is attempted and fails because there isn't an exact
free space available. This exact bno allocation attempt can dirty
the AGFL, and before we dirty the transaction *we must guarantee the
allocation will succeed*. If the allocation fails after we've
started modifying metadata (for whatever reason) we will cancel a
dirty transaction and shut down the filesystem.

Hence the first allocation done from the xfs_bmap_btalloc() context
needs to account for every block the specific allocation and all the
failure fallback attempts *may require* before it starts modifying
metadata. The contiguous exact bno allocation case isn't an aligned
allocation, but it will be followed by an aligned allocation attempt
if it fails and so it must take into account the space requirements
of aligned allocation even though it is not an aligned allocation
itself.

args->alignslop allows xfs_alloc_space_available() to take this
space requirement into account for any allocation that has lesser
alignment requirements than any subsequent allocation attempt that
may follow if this specific allocation attempt fails.

IOWs, args->alignslop is similar to args->minleft and args->total in
purpose, but it only affects the accounting for this specific
allocation attempt rather than defining the amount of space
that needs to remain available at the successful completion of this
allocation for future allocations within this transaction context.

-Dave.
-- 
Dave Chinner
david@fromorbit.com

