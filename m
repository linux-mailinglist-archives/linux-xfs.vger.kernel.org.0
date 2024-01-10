Return-Path: <linux-xfs+bounces-2425-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6EE7E821A37
	for <lists+linux-xfs@lfdr.de>; Tue,  2 Jan 2024 11:43:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6DAA31C21D16
	for <lists+linux-xfs@lfdr.de>; Tue,  2 Jan 2024 10:43:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9843EDDB3;
	Tue,  2 Jan 2024 10:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="pSOa9pXC"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63D2BDDA7
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jan 2024 10:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=KjO10JUWXr2iQaKlC1USzvR0QgVVmOH8mwmcGNJ2L58=; b=pSOa9pXCDbznqbfUeXVFPG9A+m
	AouMMiSyDIfKQIVTnJJy1KjVyX7zquk/dK9Az0TQT9NMjPIuNogphZwHg9V8dm6UC94hwLELUGzWK
	gMQBgfYFFdxwTuU2iZx+2NOKvI6LbR9pOhty8IFKqjPNMgmVK6BnNHDd8SJYOx64zxNiWi2QXuR1q
	hjQ3I7ZDmHMQ39VqmgHqqMFsKGmlc7SmjLD7+5itRY5tF/fEIgCa0mzTLkJm2xaSbpAhLPMcJsuEk
	hypev7mdAMt/DLKsBtCiqaT1FP52XaBtZGNJ9NQoOWFGl6Gb7xiCVuofo7vk6B7/rPfjFIq3TjaFv
	x8D8015Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rKcFP-007dEN-0O;
	Tue, 02 Jan 2024 10:43:47 +0000
Date: Tue, 2 Jan 2024 02:43:47 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: port refcount repair to the new refcount bag
 structure
Message-ID: <ZZPo41xL8LRDcX44@infradead.org>
References: <170404830995.1749557.6135790697605021363.stgit@frogsfrogsfrogs>
 <170404831070.1749557.18013766870623858132.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170404831070.1749557.18013766870623858132.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sun, Dec 31, 2023 at 12:20:20PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Port the refcount record generating code to use the new refcount bag
> data structure.

This could again use some comments on why you're doing that.  My strong
suspicion is that it will be a lot faster and/or memory efficient, but
please document this for future readers of the commit logs.


