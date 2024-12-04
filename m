Return-Path: <linux-xfs+bounces-16016-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F13EF9E362D
	for <lists+linux-xfs@lfdr.de>; Wed,  4 Dec 2024 10:08:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 667EA281BC7
	for <lists+linux-xfs@lfdr.de>; Wed,  4 Dec 2024 09:08:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68A551990D3;
	Wed,  4 Dec 2024 09:08:29 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C70A919068E;
	Wed,  4 Dec 2024 09:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733303309; cv=none; b=LhfhdhR463vtQ9j/J672OenTdEEU1pAFt4CX64uVAhsYDr8ZMj3gQN+oELiDOVJqTmBeHUCSzo7ZpKL54NmVMMpFhKhR+bAMHpgFB/XU8iaQFM/WDmPl9B6cM/iAO4VJoAIs4Blp/shrpWm77RVunEaZujFEtJNJqtAyKLBRIfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733303309; c=relaxed/simple;
	bh=qC35SMWN2tr9LeaniR+l4MKRsR8cafaGZgQjHvjkib4=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U+rzKlZPh09VHd4Uc2DUt2yDyGLm70JwjyB1gVGhhvu1s+JpSIaw7VsB7jznVr21Klb9HTy/lha2IScSrwnwxbFBnAV8bnnJIi1OUp1Aj0/KBjwpHueCMMu3PwkeV9a3IsjHfn+RcEAeU3QsFupCY6Hi08DdStY5GjKVr3wHRfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Y3BTC69qMz1kvH4;
	Wed,  4 Dec 2024 17:06:07 +0800 (CST)
Received: from dggpemf500017.china.huawei.com (unknown [7.185.36.126])
	by mail.maildlp.com (Postfix) with ESMTPS id 70EE9140136;
	Wed,  4 Dec 2024 17:08:24 +0800 (CST)
Received: from localhost (10.175.112.188) by dggpemf500017.china.huawei.com
 (7.185.36.126) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 4 Dec
 2024 17:08:24 +0800
Date: Wed, 4 Dec 2024 17:06:00 +0800
From: Long Li <leo.lilong@huawei.com>
To: Brian Foster <bfoster@redhat.com>, Dave Chinner <david@fromorbit.com>
CC: <brauner@kernel.org>, <djwong@kernel.org>, <cem@kernel.org>,
	<linux-xfs@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
	<yi.zhang@huawei.com>, <houtao1@huawei.com>, <yangerkun@huawei.com>
Subject: Re: [PATCH v5 1/2] iomap: fix zero padding data issue in concurrent
 append writes
Message-ID: <Z1AbeD8QVtITsvic@localhost.localdomain>
References: <20241127063503.2200005-1-leo.lilong@huawei.com>
 <Z0sVkSXzxUDReow7@localhost.localdomain>
 <Z03RlpfdJgsJ_glO@bfoster>
 <Z05oJqT7983ifKqv@dread.disaster.area>
 <Z08bsQ07cilOsUKi@bfoster>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <Z08bsQ07cilOsUKi@bfoster>
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemf500017.china.huawei.com (7.185.36.126)

On Tue, Dec 03, 2024 at 09:54:41AM -0500, Brian Foster wrote:
> Not sure I see how this is a serialization dependency given that
> writeback completion also samples i_size. But no matter, it seems a
> reasonable implementation to me to make the submission path consistent
> in handling eof.
> 
> I wonder if this could just use end_pos returned from
> iomap_writepage_handle_eof()?
> 
> Brian
> 

It seems reasonable to me, but end_pos is block-size granular. We need
to pass in a more precise byte-granular end. 

Thanks,
Long Li

