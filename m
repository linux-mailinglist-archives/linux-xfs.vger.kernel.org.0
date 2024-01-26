Return-Path: <linux-xfs+bounces-3054-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BCD2E83DB0A
	for <lists+linux-xfs@lfdr.de>; Fri, 26 Jan 2024 14:37:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 72F111F25941
	for <lists+linux-xfs@lfdr.de>; Fri, 26 Jan 2024 13:37:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCF301B81A;
	Fri, 26 Jan 2024 13:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Wdj4qddF"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ADB317721;
	Fri, 26 Jan 2024 13:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706276217; cv=none; b=Iv+e19Wf6aqRBy8rwz+jgY/wsDuQPrOwd07YCuxzswXL1LOK8o+SUVqHrTHtd3bMTv2T4fq0acPBvWIjj3PDJr2JUsLGYjLIrPF+0DSwAA5TTM81BQrPU3DUbc+40e6q1TMZsMvRazf4jcPcxINySB+t3iUZ0fGwfsPA89bYWp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706276217; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iM0r+SdWgPKyQWT6ofkjfKuzGQiQsBuCE77iAx/IWbrqHs/8vuSyPZ+edCY9vrOYAkV0Su6YTYF/cwIUwrX6kZkWRbQDk2z5JngIwQz8jhSbXCoBL2YA2i8hdzAVn/L20c3YIynNKV6qNMGlz3/JxQ4oWPH/h4TOUHelPvlUF8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Wdj4qddF; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Wdj4qddFw6kKrE43L/nNrRLlkv
	Ex0tzRiNsDZY70cRlrF3NqH+jRJgV2IHH/UdHkeSWyu1OHWQp33s0bhVw6O2dCDbBshS9zSNpA/kn
	qyV8EFp8aIWn5ojeDkHb+C4b1vA/RcCjkbwpDJZxcZKZDQe2v3m2S3/fGmIebrAW5WNZftmzsWB6e
	AghyBgYOltHXBrzdQNPza6CclYIi/FAv+ZMeAXhs/4OnsgbrEJ2qU9SY621TKGql28p0/9sr2kD2Z
	5R/Dbidv172QNwt2jvKjtBALbILz8G0eC5hAaNbtK6v94gbJFiW30Z9dT0hhBbAsjURGnrB6RaIk7
	ibo3XjsA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rTMO7-00000004Dya-3c9H;
	Fri, 26 Jan 2024 13:36:55 +0000
Date: Fri, 26 Jan 2024 05:36:55 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, guan@eryu.me, linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: Re: [PATCH 09/10] common/xfs: only pass -l in _xfs_mdrestore for v2
 metadumps
Message-ID: <ZbO1dycHqxCcqwra@infradead.org>
References: <170620924356.3283496.1996184171093691313.stgit@frogsfrogsfrogs>
 <170620924493.3283496.11650772421388432291.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170620924493.3283496.11650772421388432291.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


