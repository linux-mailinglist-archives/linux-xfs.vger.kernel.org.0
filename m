Return-Path: <linux-xfs+bounces-22857-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C2DE8ACEEF2
	for <lists+linux-xfs@lfdr.de>; Thu,  5 Jun 2025 14:09:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 80DE717285C
	for <lists+linux-xfs@lfdr.de>; Thu,  5 Jun 2025 12:09:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC53D218580;
	Thu,  5 Jun 2025 12:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="I0osl0hl"
X-Original-To: linux-xfs@vger.kernel.org
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D34FF211711
	for <linux-xfs@vger.kernel.org>; Thu,  5 Jun 2025 12:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749125361; cv=none; b=fvarib/HJvg2BN1lz6M7c+hunH/SNGLGh5HxCIbs2w5nXKkmnNQzeTC1xzS2hLNKHLNUg/MOoU2SgwgGWMSw0qRHFQ5xJvVjTuuK1vKZEVv6yQMA64eq0QVnx5Ftb2DLxj1RUbx54kJpa+++kfN3RM2AwviAFG4dsHY/x47KvCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749125361; c=relaxed/simple;
	bh=68ST4wWru6aYFudYB/AR3+klXokvG7WPyNYVacGmxco=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hbhSqqohQsUIQu7/iBdxUmwia8ps++LWIgDx+6AwoiCftjQ/c6vLs59znzMMmlcLPKCCt9c+T1sKzB1iBKyYD8gnsSTP6K6t6vTN2Ni7W0mmWHKgd2utftjYWb1Zrw7SoZ66abRC9+OTwAmFjcQjMhShlOW0pAt2WbvrwCxSh7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=I0osl0hl; arc=none smtp.client-ip=209.85.219.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-6fad4a1dc33so9608686d6.1
        for <linux-xfs@vger.kernel.org>; Thu, 05 Jun 2025 05:09:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1749125359; x=1749730159; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UNA1AqJPiuiUBzCeRC8bK1nu38f0qCHlYuwt9uDWl+g=;
        b=I0osl0hlt4Wb/cImSyn7xpSmr1foyB4eyd+a5FZJdcMpmq0atJGB7StBZyENYtbAjo
         bW9cIyQRYLE53n7QdQ0yCDv19KXYNITb/IYQrJjtsgDwbvT6v3/Lw3PgwRTn5tPV3kYt
         A7XvI7/W8ynRihhAmKIuK0j+T4HbrSOTDRAopm1PiPY75dAyj0Jn90+7bfFi3b7yO4Qn
         bgCJIxdvpy3cwdSFVbvKNbb3SLTQRJ2NzhraEow1wJZzkTTPkccKIRfm6Qkfx47gBD69
         xzE4vscJt+NJLa9s5APp6AdsiUhZpUTeUHLdl91VJIXOafhwkbWfRRJTmPFHWGE9BXem
         aijw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749125359; x=1749730159;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UNA1AqJPiuiUBzCeRC8bK1nu38f0qCHlYuwt9uDWl+g=;
        b=gJRRFDrEQWbzIc/zqiKxz5oik7Mp90t/4nFuvD9y7sw16lXz4Ez+ODl5BRNAnklbLx
         AfHfHdhrlqk9NT4A1kZR9HKi5Qj+Fo7EvaCEHefg8HrtLfgDHsqhyZEx5vDvXDMdlaeY
         5v5qTZjQdOneyT7fBT7IK/xtiy4c6RsMYpEccUK9aIVTJ/1zsoZEfRkwKjVAdSlo32cO
         u3DuXY5BehInGOLV6bsg8t2+xj/jGBO7v9LdBDDc1Th47EiTsbKboAarP/xAG1hvfjiw
         0hwGpV0IZg290I7LpNXpC99E5Po/zsGKChSVPjRLiarWCCQE+EzxCxl2sAoAENK4wLOn
         R5DA==
X-Forwarded-Encrypted: i=1; AJvYcCXLdPwX8RW5/L/bNJ2gdAS1jTdGpHU4bw2ygFe/vHykcN+yjoidc8OSF2KrqKhh2KmzAMBEFt0AkvU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxp/zv7ujwbKF/TCOyPV9vMCdanCKL5tZAjrYvWluiFValevLVi
	sXCUOQlZ9bRoDqUIqJBa73/Mg+o9rmW+kWKnsi9Bk9yiOT6TYNh7aDYWJssDe6ci1sc=
X-Gm-Gg: ASbGncufNaiL4KXH03fZnoWfrFKp2GZY9DGGShJOhg7gCXyfSv4t1hSZOvwcRpevMNR
	MV2M0c6KMugSATRpigIJ5g6FFuqTG7O8VNcWtwzKoQuPKUqZ7/d6ZZNZfLO5ORSAHZh35NKMiJ4
	7y1KKi3NYVlmQ+yCYixRiJP3fyOScPfYmw6WhdARo8zBAJ9RvCNhJs8k7FmXHS2caUD67C6PMTF
	1Apcu6G43kDYQkUKQTjD8ty+QQCezAufQtWkMInVOxDKD2l/AlDYWDpqVk100OgYNxAAEniNhqs
	6evMiaYojYzCvSaUdT0W57v7VOo32+cMRntF9CsGifPT6BU3cfAvKpWhy73xTx0A8/j3Hev5o16
	+R/vNkVo2YdLULOZdWSqVyyOiteE=
X-Google-Smtp-Source: AGHT+IGoKm/5U4/UM2uM64qO2HBitYJapsKbuDFJlmk9byEyE/W8ROsmev/IR9V9jeal6LfHAI1O8g==
X-Received: by 2002:a05:6214:224d:b0:6fa:c512:c401 with SMTP id 6a1803df08f44-6faf70163f2mr115317766d6.37.1749125350351;
        Thu, 05 Jun 2025 05:09:10 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-167-56-70.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.167.56.70])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6fac6d4c7d8sm120604836d6.36.2025.06.05.05.09.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jun 2025 05:09:09 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1uN9PB-00000000EdT-18gz;
	Thu, 05 Jun 2025 09:09:09 -0300
Date: Thu, 5 Jun 2025 09:09:09 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
	gerald.schaefer@linux.ibm.com, willy@infradead.org,
	david@redhat.com, linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
	jhubbard@nvidia.com, hch@lst.de, zhang.lyra@gmail.com,
	debug@rivosinc.com, bjorn@kernel.org, balbirs@nvidia.com,
	lorenzo.stoakes@oracle.com, linux-arm-kernel@lists.infradead.org,
	loongarch@lists.linux.dev, linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org, linux-cxl@vger.kernel.org,
	dri-devel@lists.freedesktop.org, John@groves.net
Subject: Re: [PATCH 07/12] mm: Remove redundant pXd_devmap calls
Message-ID: <20250605120909.GA44681@ziepe.ca>
References: <cover.541c2702181b7461b84f1a6967a3f0e823023fcc.1748500293.git-series.apopple@nvidia.com>
 <2ee5a64581d2c78445e5c4180d7eceed085825ca.1748500293.git-series.apopple@nvidia.com>
 <6841026c50e57_249110022@dwillia2-xfh.jf.intel.com.notmuch>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6841026c50e57_249110022@dwillia2-xfh.jf.intel.com.notmuch>

On Wed, Jun 04, 2025 at 07:35:24PM -0700, Dan Williams wrote:

> If all dax pages are special, then vm_normal_page() should never find
> them and gup should fail.
> 
> ...oh, but vm_normal_page_p[mu]d() is not used in the gup path, and
> 'special' is not set in the pte path.

That seems really suboptimal?? Why would pmd and pte be different?

> I think for any p[mu]d where p[mu]d_page() is ok to use should never set
> 'special', right?

There should be dedicated functions for installing pages and PFNs,
only the PFN one would set the special bit.

And certainly your tests *should* be failing as special entries should
never ever be converted to struct page.

Jason

