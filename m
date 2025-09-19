Return-Path: <linux-xfs+bounces-25815-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 70500B8833A
	for <lists+linux-xfs@lfdr.de>; Fri, 19 Sep 2025 09:38:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EC0B6B61023
	for <lists+linux-xfs@lfdr.de>; Fri, 19 Sep 2025 07:36:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C0FC2D1926;
	Fri, 19 Sep 2025 07:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="IVyHIPov"
X-Original-To: linux-xfs@vger.kernel.org
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ACDD2C0270
	for <linux-xfs@vger.kernel.org>; Fri, 19 Sep 2025 07:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758267260; cv=none; b=px/FxJ+/ztf+qj9IU++f1z2ORiPiG6gdUfCEuq2EGrRRvEer+wevOHn848OrpWS6gPUMNy0ain6TYj0/uoYSqUvz+GNarsIMT/XdozH9v94kvcG167op58Y9yW9ix8YiqS6i6IlcC6KsqrH0+s6NiccOkDVoj63/rrZylxwsvbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758267260; c=relaxed/simple;
	bh=UDbgq5I7/fiN9GyHTHOeYNojRIjPFBceV29A28/FmKM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ObH6yq0V1NAyyo4yj63+HkOQtTDCYzrS8Vuj6CiwgB0EGTyzZ+qGLce6FhLQWyGKGt6aPpy7b0dW0a/G8+Ybg12wEiPntvq1jWWj4YivxMvlfVE1tOSkW8HvK5b09gHW1QeZFovUb/bOLbpLrnaUZeFk+c5zhdZNTzlIScWdT5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=IVyHIPov; arc=none smtp.client-ip=209.85.222.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-826fe3b3e2bso190464685a.0
        for <linux-xfs@vger.kernel.org>; Fri, 19 Sep 2025 00:34:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1758267257; x=1758872057; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=1RChfYMo6l3NlpB1CtytFiCPlXnFT8/eeYYewFlQyV0=;
        b=IVyHIPovg6fIybeWuYJk3D6SVydMvkoKvdKP2HGgSJbeuqsLPHKEHK1zaxocvpapHD
         LH4/tLRdB7jOOkOs35t21z/rss58mqp8vXqemb/bHZqnmmdkT/rKssfDWRj4ToCAgQqV
         hQZbSI/HO4zq9Z86UU8aIuokWmbqo9VBDKBCQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758267257; x=1758872057;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1RChfYMo6l3NlpB1CtytFiCPlXnFT8/eeYYewFlQyV0=;
        b=A88phvdHper3mLCcTma1g7uitculMJBkvgbOyNqbjkDt0mzPQB/nkcQmtIIzjqZsPZ
         8nHX0BfxYMHricQPmulTAlaT8DCRJrDa8sHRl72tfXTFLgB/NR8m0aujRbNp1gIBwgoO
         WklGe78T1pNAAeoaZXLXOdH/TTw5wCAhFgCKtcWQcCW+W4NgoCXRfWW7scW7kmxAe9US
         tMuxt5zB+qXM72bQsVZl7Mr/TQ9gGj5vnN5/jQfxEwWHQSTKpwa79lVv+daTcrTplIda
         bOuxhrx6+KfhlbusZt0OwbU475SgkOwlZwFqdmr5DkAX+1wpEdC1CIpG4isIip8u3Ayv
         xVFQ==
X-Forwarded-Encrypted: i=1; AJvYcCXKgQIX06pAcxn/DobNo05j9MrJ8ElE4JV9Y2n7sRVodDE8QqYLu4/slsu7i/UKkrRme0hDTf4JnLE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy2o4w1kVraI1uLlXwOCjdISJ5GrZF/y7FXHrplsJNmQtG424DC
	p9npjrMokJRu4b6Y1z36BhNLkKdpUTDXMPVJKGvWtLW4ZzPXv0p8sfUSnx9WIpm+oKDUEoKjnAi
	m8ircxF9Q0bPLRVSlhLn8yj2eQtARDgaMsjMeylB/nw==
X-Gm-Gg: ASbGncvDnPPkg66+5OBr7Wh6A+yUy01WbPmRqToICr6mi5AYcpA6iWaUbLP4pLzL+Xs
	b3T9SfL9tCZm/Yi+Awkt81bjfJDNq8HTJ2ziDGBJBy3i/niVt4Vg9YS2ZXENyWFKsR14vvK6CLN
	ET+2zbi0emw3E/8HOj0f/33WDI84KTFV2nt/GuRIAkrX4dy90u9FqmmB/x+uq4x+mB6pEZ0iofq
	VKJYrJyhBhBzJhmGtP9+EIlS9U3ZlM7DX7plgzaglI9dOqLiQ==
X-Google-Smtp-Source: AGHT+IFH6/yIRQX6FHwVT74Oelgtb0ePNHcn9mX2qFQVBfBdaPpXLeRzP/soCW4TNqD+cygmZmF7/8DbipcgqrdjYnY=
X-Received: by 2002:a05:620a:4b48:b0:817:d6c5:41ea with SMTP id
 af79cd13be357-83babfe7d1amr196695285a.51.1758267257515; Fri, 19 Sep 2025
 00:34:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <175798150680.382479.9087542564560468560.stgit@frogsfrogsfrogs>
 <175798150773.382479.13993075040890328659.stgit@frogsfrogsfrogs>
 <CAOQ4uxigBL4pCDXjRYX0ftCMyQibRPuRJP7+KhC7Jr=yEM=DUw@mail.gmail.com> <20250918180226.GZ8117@frogsfrogsfrogs>
In-Reply-To: <20250918180226.GZ8117@frogsfrogsfrogs>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 19 Sep 2025 09:34:06 +0200
X-Gm-Features: AS18NWDnMUFDnNKztB29fevuAtOKBB3TGWjBAViz5bbTsRot9HiaHDnPQnmtPns
Message-ID: <CAJfpegsN32gJohjiqdqKqLqwnu7BOchfqrjJEKVo33M1gMgmgg@mail.gmail.com>
Subject: Re: [PATCH 3/5] fuse: move the passthrough-specific code back to passthrough.c
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Amir Goldstein <amir73il@gmail.com>, bernd@bsbernd.com, linux-xfs@vger.kernel.org, 
	John@groves.net, linux-fsdevel@vger.kernel.org, neal@gompa.dev, 
	joannelkoong@gmail.com
Content-Type: text/plain; charset="UTF-8"

On Thu, 18 Sept 2025 at 20:02, Darrick J. Wong <djwong@kernel.org> wrote:
>
> On Wed, Sep 17, 2025 at 04:47:19AM +0200, Amir Goldstein wrote:

> > I think at this point in time FUSE_PASSTHROUGH and
> > FUSE_IOMAP should be mutually exclusive and
> > fuse_backing_ops could be set at fc level.
> > If we want to move them for per fuse_backing later
> > we can always do that when the use cases and tests arrive.
>
> With Miklos' ok I'll constrain fuse not to allow passthrough and iomap
> files on the same filesystem, but as it is now there's no technical
> reason to make it so that they can't coexist.

Is there a good reason to add the restriction?   If restricting it
doesn't simplify anything or even makes it more complex, then I'd opt
for leaving it more general, even if it doesn't seem to make sense.

Thanks,
Miklos

