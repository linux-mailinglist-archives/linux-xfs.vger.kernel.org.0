Return-Path: <linux-xfs+bounces-6506-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8506389E9C5
	for <lists+linux-xfs@lfdr.de>; Wed, 10 Apr 2024 07:31:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2499E1F267A0
	for <lists+linux-xfs@lfdr.de>; Wed, 10 Apr 2024 05:31:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF4B515AF9;
	Wed, 10 Apr 2024 05:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="D+ZlDLUW"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 704EE12E73
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 05:31:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712727072; cv=none; b=LPfcl+g2y7mk2fjxG/Bzgg3AcLhy5ml/SUx1M7lTiw4FyImrk2H86T9dDXD4YaVJNj60UgKA5jBQgEQ/hILf3ZKAVx0P+ArrLVrKa6XRCPrKYV7J+NhU7kKe8fDnDS9TVRbEAzaMPp+Ha4Wi3ire+0IVy7oz4sqy3LBufWBwZyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712727072; c=relaxed/simple;
	bh=iO2bEeYGwaWVBmdpae8sRxmDLJ+R/8AEP1dc6eCIeyk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rAAwB1b6k911l1piEWZFYAsZzSkVtulBYHcAy7WJ0/Rq2KVyizsf4r92ApvlcMZmp/PVcOVCz1SpiA3qk1bHn+DQk8eiL5UzohUBt2EtsnSTXS/9VTuMFxop9Fm8Z3AYYlasDcV7YMo8bwROkJIgRO11ev5yphAILHa717ICgfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=D+ZlDLUW; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=cl+pfnXsOTwG/lcZRUdXZgYIR07K+6wmn9NZHptUeUU=; b=D+ZlDLUWYP6ZbPsVtXB5MiKrUi
	yPAAHkhG7pvJwyhM5fPGL1MYd+31Nkkxf4zyOrmq5RatNjA0povpF0xKe304biMg2L44RHTaH0Fzv
	NoXD50gD4aec8meshVOGvsPRcFwrBkt8yXCE/wNzpMsXtM5zYn94HqtUmYsdGM0CqL/wSIOYg2TM2
	jIL1BYVflrqZgAnrGt1BKgtiUJJOTsWRtB03hoQNjEUQcbmjZ+U5c5reLXVpDpZutsIA3p3vxM1mr
	ChZfKNdpO+fDdYn3E6JbP8+edz5VYAN84FJ/zjR7ywqmIWCbLIEoekQReRDVWp4lJoyEgz7xdStiB
	ZX18fUag==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ruQYA-00000005CoX-3rHn;
	Wed, 10 Apr 2024 05:31:10 +0000
Date: Tue, 9 Apr 2024 22:31:10 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Allison Henderson <allison.henderson@oracle.com>,
	catherine.hoang@oracle.com, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 14/32] xfs: add parent pointer validator functions
Message-ID: <ZhYkHh2TUmhPPdaw@infradead.org>
References: <171270969477.3631889.12488500941186994317.stgit@frogsfrogsfrogs>
 <171270969790.3631889.2339349798519269452.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171270969790.3631889.2339349798519269452.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Apr 09, 2024 at 05:57:09PM -0700, Darrick J. Wong wrote:
> From: Allison Henderson <allison.henderson@oracle.com>
> 
> Attribute names of parent pointers are not strings.

They are now.  The rest of the commit log also doesn't match the code
anymore.  The code itself looks good, though.


