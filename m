Return-Path: <linux-xfs+bounces-13445-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 93B9598CC84
	for <lists+linux-xfs@lfdr.de>; Wed,  2 Oct 2024 07:49:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0F385B21631
	for <lists+linux-xfs@lfdr.de>; Wed,  2 Oct 2024 05:49:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE6282030A;
	Wed,  2 Oct 2024 05:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fDRFP4P1"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E4398002A
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 05:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727848185; cv=none; b=HfgXhIGKHhD6AkfAGqv4flZBn8NiyLsT0SsW63pFyAHJrg6DfEKm5nlEBiPTX90x6zE31O+7hT34+fuhnY2a4X+YDH79ehrHPiZzo51D95l6yEBOk1Hf+CjQmMRMyOhiD0U7H8vniqityvy2m6mdGLMEvhupOROSgKje9tTkGgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727848185; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nPmAXiifmyzmPnqfxQOd9I+c5rWu7mCxxCotHi/8K3KEviDTGP/jlGHeWooGGIVq7uRYGpSlRAQIQjNJf3FlRfSDk7h2O5yjxkQaaOW0rkK4fpFZ80OsJfPh7isGepFwL/gHUf3BKkchQT4wjHVtKUr+l0DT4TE9drhXSIvUi9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=fDRFP4P1; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=fDRFP4P1vvbmODZqQfh/YcjQZ2
	L/Zz4UVhCQFLyG2l3q7uMqbUFGNNzR5HeG+TqJsCg5WtOeBa2HHIMhRR5D/8AEZC/GaJFqcnbLeYO
	jsIRPQUQIO5HKooVoFjXap4SQvmaoCu2t+O5UmOYmPqP1M2F+Ejp1UZlyVvPVpAOvf8pP3YNgH2+O
	mPMmopN24x++HPKBkBxg0XGJj+3GL82oQbqRXlT4AC5eGKVtfiteMxSmS1CFR0HY8dvCOAd2c05Sd
	VTqQmVEFGm7UX49hPJtg7dcpV3SuA2cmWEMeHn1D9bS5faQjmBWHSMXN4emPp/AZOLxAysPKzad59
	VijpUWxw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1svsF6-00000004rx8-03M8;
	Wed, 02 Oct 2024 05:49:44 +0000
Date: Tue, 1 Oct 2024 22:49:43 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 14/64] libxfs: when creating a file in a directory, set
 the project id based on the parent
Message-ID: <Zvze92jSwt_FmsLN@infradead.org>
References: <172783101710.4036371.10020616537589726441.stgit@frogsfrogsfrogs>
 <172783101992.4036371.12940733887668033364.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172783101992.4036371.12940733887668033364.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


