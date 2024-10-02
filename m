Return-Path: <linux-xfs+bounces-13438-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E30698CC72
	for <lists+linux-xfs@lfdr.de>; Wed,  2 Oct 2024 07:44:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E34111F2418C
	for <lists+linux-xfs@lfdr.de>; Wed,  2 Oct 2024 05:44:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A99A80038;
	Wed,  2 Oct 2024 05:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="uTtnGRWw"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C86102F43;
	Wed,  2 Oct 2024 05:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727847878; cv=none; b=WOZiSpq6gBDLFSePqrFT0TfBZPFeOYlghI0AVVGMSJa2o0WO6oANY00n4xdoTO36OVDvK7xyeLRvSH8CK/DstMCIuPuPQ7nRrRJB/fdcfnvOGBdPjaIKj+qL+ZIUlNZmDUQe+1braXBuRn0njnHRNf1e/Crum3uuYrHx5t2oC8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727847878; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GWjyD8hE3CrpDtD1BbNl27Cj30l7OXEshmfIR/EHfQKZo70UgDUaiXhsE5f3HgNECm1g3KUhjqHPvCW5gKCR1qPQEKnuWfMLCRLnBkciQXIFPQJyRryggu55r9WeSw4WlVFHXV/ED2wdmTxYWNJoNrJ5x2eb4AoOYNFzsq6kbnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=uTtnGRWw; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=uTtnGRWwOizOT8LBUfLWkRRBEa
	c5jAPrsHWIA4rHSi3S0cw/sYlF2A+yuTG5iwI3+fKbpyABdcJBMNw8pysiiLHtE4idIDRwrwMwZWJ
	kHH/BpMZxZC7OZYQCjQgXeZsQ3kOivit6Bj0wxUcU4HCgpoSN3tUInMUVjMfYBbLYP4IMaYoY0DML
	I4YoPyRFXDTewwAUxVuSyyb+yTJ7pNKgqMmXRToH2DjY7Wt3El3EArKdK2yNU9hZB2fMONp2A1JL1
	pMInRRaba/AaaXF71F1liK1ajnnTK9aYRmOZNk4DxlemP26sarT5E2LP3Xx0YktHEYrJoVRSA3+OM
	tED0frGQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1svsA7-00000004rUI-2Sg3;
	Wed, 02 Oct 2024 05:44:35 +0000
Date: Tue, 1 Oct 2024 22:44:35 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, allison.henderson@oracle.com, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/1] common/populate: fix bash syntax error in _fill_fs
Message-ID: <ZvzdwzdmfI6Qhp2s@infradead.org>
References: <172780125677.3586386.15055943889531479456.stgit@frogsfrogsfrogs>
 <172780125692.3586386.8156040885377148056.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172780125692.3586386.8156040885377148056.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


