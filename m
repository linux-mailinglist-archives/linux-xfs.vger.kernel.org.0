Return-Path: <linux-xfs+bounces-26106-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id C1112BB9589
	for <lists+linux-xfs@lfdr.de>; Sun, 05 Oct 2025 12:37:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 82ADB4E247C
	for <lists+linux-xfs@lfdr.de>; Sun,  5 Oct 2025 10:37:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F030026C3BF;
	Sun,  5 Oct 2025 10:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gUN9Anrr"
X-Original-To: linux-xfs@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F415C23815D
	for <linux-xfs@vger.kernel.org>; Sun,  5 Oct 2025 10:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759660627; cv=none; b=ZcrwZBZrdZZ2fohCk0oLx04okWMflTNGVrBV7MKZfGKHnzEw+GNn/j1C6Psbk5PTbi3f6DJG3uYvloC+CvU5eQu3elXc8nOVAKmTc6tVOZxbz469mO+UhKnxvbFXCBbjW5Wh8efgbCXimDUotQx0I5N7WU6XNCbhGRkIVH/C9Xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759660627; c=relaxed/simple;
	bh=6LIHPOQPLDWrr6EbSN7wwdKPe2nDjZ08h3rW+KOWZrw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RgOC05PVvbX1kjccRwV96tAL9/ICCnXpit56KEpZlge5/DnfVmscu8iN5kZO7zoO8IMjc3SgMGKcwVBmM/xpCnwKMenTxUt4yIH/QF+xyUvS8NvCrGoJLrGKFsADEA3pS7fD1XbCRTS8oLqRoyrisMqNRNZYswmiO33B7hffWpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gUN9Anrr; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759660624;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cXE+Do4eiYEQpRMZRWtP81SSjx9Cj+R+tBIOazUtRqs=;
	b=gUN9Anrr0iQVvomA4xAn4cpGcv3Kh/0Y/0KXb5L2D47t9JroSbVzWxpC6u+gxd1rOdJaUQ
	0UH7c50Paxe9zSmPYyv3vxX6lQFGeXS8si1wI8uUtaE+z0mu4dB60EafILqPLtptc07goc
	wWfT60ILpIXaTiokwSL3p4PYC/hjV90=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-94-ktlcY23fOSG6av9xm_JDog-1; Sun, 05 Oct 2025 06:37:03 -0400
X-MC-Unique: ktlcY23fOSG6av9xm_JDog-1
X-Mimecast-MFC-AGG-ID: ktlcY23fOSG6av9xm_JDog_1759660622
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-334b0876195so3984293a91.1
        for <linux-xfs@vger.kernel.org>; Sun, 05 Oct 2025 03:37:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759660622; x=1760265422;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cXE+Do4eiYEQpRMZRWtP81SSjx9Cj+R+tBIOazUtRqs=;
        b=YErTW2XAEL+cunKnMIXBUb+lbhfCD0NAu2bkIdODsq4Tlmq4idQyofgIDIBP78tjIw
         W734uncaJEKHbm+xCDgnmEvzXE4ehNdxl1NORQzN2lA3V7amvDHUNd0u+/Kaa5G2BR2Q
         NoZmn8hhJYB9NoVAYrMlxj5CT3yWddUVthARycx9ZRsbxegZyExQWjX/NCqlStXzEeNh
         wkdCjNE2OFRsJBvs3i1ETDft6iFohmhlAEv0WEkhYpJn0gWkf9EceBGR+E1nws7u8Qe0
         nod8u8D3+t/QZraKBJA0m63RhXoWUDvkOJyz+3SMLwiESVZe5B9mWcASWjFsJkw2JFuA
         UFdg==
X-Forwarded-Encrypted: i=1; AJvYcCV7d4nHGR/6uVsog5iA3Pg9xmXO7pgEL653FTa48z75ge6XyWqIop6mX9Xx2vyMaaptPmyIaA0PSe0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyAccIE7hpsvtye+2H3wQGxL+bDPWRhtpAaal9KFVnudeEOSbkl
	RC9FQ3MGYvDP5/+QxuAWfBeK2wK6Xp4WZBGNMOak+X/Y9XvNEwSlv7r5d/xVYt39Hc0EOdHp6Xy
	sxb57wb1Gxr/2/17Htvh83EI492nidofCLFiH+2M25KOSZsJpoeJrDKdMOmPI3Q==
X-Gm-Gg: ASbGncu2KA2/bKNpw+WhItaEQvN581l4wf9J3lbg5wy9sUkIURtkTDOtFPLF8h7i09y
	QaHe3SAaJNIcRi/7VCxtAHrydlTxEbnNg8IJKg3sLwQoDOSZTwbvwjioGSNKVy3a0Xnpa1lL8B6
	mej91/AVG9vpObHS0TEal0ODphxvxAF42NFduTi7Gjs0rKVQpyFmBZ6clwQuktixSBcyKzTDHnj
	OgUpCifI3r2S8bxXpyn0tDN7yL1PklVRYnyslvaKKkJSsSqU4O8MBhqS8nHLfZUmtRKi0iblJUP
	MrTedtOBHP/VmRGwq8Zmj4Q7jR24FSAkIH4X5LePbvJK7kJzme6u/jpdDl8MILBSp1HaaAB4kmW
	7wN21/QIuVw==
X-Received: by 2002:a17:90b:1b48:b0:327:ba77:a47 with SMTP id 98e67ed59e1d1-339c2782afbmr12219255a91.15.1759660621780;
        Sun, 05 Oct 2025 03:37:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFm83AyjS7X4hJtAl1cFaaDJwlNM/NB1MMUPpV8cEk9b8Sb3eLjy4T+3C65MTyp4EHmOdh1hA==
X-Received: by 2002:a17:90b:1b48:b0:327:ba77:a47 with SMTP id 98e67ed59e1d1-339c2782afbmr12219225a91.15.1759660621290;
        Sun, 05 Oct 2025 03:37:01 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b6099d4d324sm9665636a12.27.2025.10.05.03.36.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Oct 2025 03:37:00 -0700 (PDT)
Date: Sun, 5 Oct 2025 18:36:56 +0800
From: Zorro Lang <zlang@redhat.com>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: fstests@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org, Andrey Albershteyn <aalbersh@kernel.org>
Subject: Re: [PATCH v4 1/3] file_attr: introduce program to set/get fsxattr
Message-ID: <20251005103656.5qu3lmjvlcjkwjx4@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20251003-xattrat-syscall-v4-0-1cfe6411c05f@kernel.org>
 <20251003-xattrat-syscall-v4-1-1cfe6411c05f@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251003-xattrat-syscall-v4-1-1cfe6411c05f@kernel.org>

On Fri, Oct 03, 2025 at 11:32:44AM +0200, Andrey Albershteyn wrote:
> This programs uses newly introduced file_getattr and file_setattr
> syscalls. This program is partially a test of invalid options. This will
> be used further in the test.
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> ---

[snap]

> +	if (!path1 && optind < argc)
> +		path1 = argv[optind++];
> +	if (!path2 && optind < argc)
> +		path2 = argv[optind++];
> +
> +	if (at_fdcwd) {
> +		fd = AT_FDCWD;
> +		path = path1;
> +	} else if (!path2) {
> +		error = stat(path1, &status);
> +		if (error) {
> +			fprintf(stderr,
> +"Can not get file status of %s: %s\n", path1, strerror(errno));
> +			return error;
> +		}
> +
> +		if (SPECIAL_FILE(status.st_mode)) {
> +			fprintf(stderr,
> +"Can not open special file %s without parent dir: %s\n", path1, strerror(errno));
> +			return errno;
> +		}
> +
> +		fd = open(path1, O_RDONLY);
> +		if (fd == -1) {
> +			fprintf(stderr, "Can not open %s: %s\n", path1,
> +					strerror(errno));
> +			return errno;
> +		}
> +	} else {
> +		fd = open(path1, O_RDONLY);
> +		if (fd == -1) {
> +			fprintf(stderr, "Can not open %s: %s\n", path1,
> +					strerror(errno));
> +			return errno;
> +		}
> +		path = path2;
> +	}
> +
> +	if (!path)
> +		at_flags |= AT_EMPTY_PATH;
> +
> +	error = file_getattr(fd, path, &fsx, fa_size,
> +			at_flags);
> +	if (error) {
> +		fprintf(stderr, "Can not get fsxattr on %s: %s\n", path,
> +				strerror(errno));
> +		return error;
> +	}

We should have a _require_* helper to _notrun your generic and xfs test cases,
when system doesn't support the file_getattr/setattr feature. Or we always hit
something test errors like below on old system:

  +Can not get fsxattr on ./fifo: Operation not supported

Maybe check if the errno is "Operation not supported", or any better idea?


Thanks,
Zorro

> +	if (action) {
> +		fsx.fa_xflags |= (fa_xflags | unknwon_fa_flag);
> +
> +		error = file_setattr(fd, path, &fsx, fa_size,
> +				at_flags);
> +		if (error) {
> +			fprintf(stderr, "Can not set fsxattr on %s: %s\n", path,
> +					strerror(errno));
> +			return error;
> +		}
> +	} else {
> +		if (path2)
> +			print_xflags(fsx.fa_xflags, 0, 1, path, 0, 1);
> +		else
> +			print_xflags(fsx.fa_xflags, 0, 1, path1, 0, 1);
> +	}
> +
> +	return error;
> +
> +usage:
> +	printf("Usage: %s [options]\n", argv[0]);
> +	printf("Options:\n");
> +	printf("\t--get, -g\t\tget filesystem inode attributes\n");
> +	printf("\t--set, -s\t\tset filesystem inode attributes\n");
> +	printf("\t--at-cwd, -a\t\topen file at current working directory\n");
> +	printf("\t--no-follow, -n\t\tdon't follow symlinks\n");
> +	printf("\t--set-nodump, -d\t\tset FS_XFLAG_NODUMP on an inode\n");
> +	printf("\t--invalid-at, -i\t\tUse invalid AT_* flag\n");
> +	printf("\t--too-big-arg, -b\t\tSet fsxattr size bigger than PAGE_SIZE\n");
> +	printf("\t--too-small-arg, -m\t\tSet fsxattr size to 19 bytes\n");
> +	printf("\t--new-fsx-flag, -x\t\tUse unknown fa_flags flag\n");
> +
> +	return 1;
> +}
> 
> -- 
> 2.50.1
> 


