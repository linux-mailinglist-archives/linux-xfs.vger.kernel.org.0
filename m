Return-Path: <linux-xfs+bounces-2573-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 92D958247DF
	for <lists+linux-xfs@lfdr.de>; Thu,  4 Jan 2024 18:59:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 38C25286E65
	for <lists+linux-xfs@lfdr.de>; Thu,  4 Jan 2024 17:59:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2FDF28DB3;
	Thu,  4 Jan 2024 17:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VlKa8l+v"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDE2B28DA9
	for <linux-xfs@vger.kernel.org>; Thu,  4 Jan 2024 17:59:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83C02C433C8;
	Thu,  4 Jan 2024 17:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704391162;
	bh=m3IEAzJoi9nPMhidUIqWN0JNs9K7Kt2G+nBXQPdMklE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VlKa8l+vxqh4Rq5Pn3JdQb2fTjmdL07v3UQ+UbGJ50kS3Q88BYEINamPoJo8G6VRh
	 U3g8PmwURcwfcks1/QW+qfXKffqeIJL9vw7cGcyfERSTeqyZFsLCSeQRWoMoHq4eU0
	 6Wo924sg1WLXCjMV7niIn7Yu7+gXHcbKpdgTMxlg7o0wNkxO7Xbx1SGq81h0VAy6Rj
	 KMXtr7jRbTKrgbNVrQs3dHJ2envMAwIKyr7+v71mBX7cxi/ArZMg9uYKIDqZyinikx
	 Y8tBGIAxTTV1VuLOTyatdCArwDqSQNuXfiDiLMwXq3CrBA369ZXQrS7hirtMi/HH9R
	 r2olP9ZFa6W/w==
Date: Thu, 4 Jan 2024 09:59:21 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfile: implement write caching
Message-ID: <20240104175921.GH361584@frogsfrogsfrogs>
References: <170404837590.1754104.3601847870577015044.stgit@frogsfrogsfrogs>
 <170404837645.1754104.3271871045806193458.stgit@frogsfrogsfrogs>
 <ZZUfVVJSkvDRHZsp@infradead.org>
 <20240104013356.GP361584@frogsfrogsfrogs>
 <ZZZOMiqT8MoKhba7@infradead.org>
 <20240104072050.GA361584@frogsfrogsfrogs>
 <ZZZeFU9784rD5XsD@infradead.org>
 <20240104073412.GF361584@frogsfrogsfrogs>
 <ZZZgzneOKn/trcUX@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZZZgzneOKn/trcUX@infradead.org>

On Wed, Jan 03, 2024 at 11:39:58PM -0800, Christoph Hellwig wrote:
> On Wed, Jan 03, 2024 at 11:34:12PM -0800, Darrick J. Wong wrote:
> > Ok, I'll do that.  Were you planning to send that first series to
> > Chandan for 6.8?
> 
> If you're fine with that and I get reviews from Hugh for the small shmem
> bits I'd like to get it included ASAP.

Ok by me, though I also would like to hear from Hugh that the shmem.c
modifications make sense.

--D

