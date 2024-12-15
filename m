Return-Path: <linux-xfs+bounces-16742-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 798B09F04A2
	for <lists+linux-xfs@lfdr.de>; Fri, 13 Dec 2024 07:10:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5026616A8EC
	for <lists+linux-xfs@lfdr.de>; Fri, 13 Dec 2024 06:10:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25E9418A6C4;
	Fri, 13 Dec 2024 06:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="v8aIURKj"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B57171547CC
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 06:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734070216; cv=none; b=aSDyFCLz4PY9BazemTAXWKDxLti2kR/g8NtkbMyJcBWlDkVV90d3ZWvTxK8+gxvLBRI67LP84MLjB3BnekFczqXVODum9l7mLI90nAjXEB3FlqxuL41iCXGmG3cfpD/BNRENPsat9p0RbrWuzw4bgMp5HLmruhWYALDisre276E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734070216; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eZe63/tB09SJGlijxdV/zfPHqYRAMmrqGZXdCrsI/wI/X6yO9uyAkxbZBBtCLh3/1jEXbF27wQbGIY+pfjvzO2hZGh6k3Mq9yPUf0BE2z7sGsDgFBfOOhYDG8k54KjYCkrgwOHFpIXNTj2bybKl/OBE6mQo8zCBkQTJgBV114hg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=v8aIURKj; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=v8aIURKjz8DmWPvzOSca9LGpOv
	UbQukknhvsz36KENv1aWBltmE44m7qAjH9h1wqim6Rlh6L391TTgs70CzFXd7DeSFtbkdROm9Z3PQ
	YwW+gS9tiaYFmrXB1bAzifPHnj9DmNV/9QTXuuUvn9/NCy0O9UhUvwaDXF5VUzLafgqT02xpodhvT
	/s93TyXkTQZWdQegBaH3G06AQWZpNEnWiOa0ApaoMUpQoL3svTOBP+7w9XTg8qKc5Yr6UkKrawtG6
	QC/eXcRN0l+sNTZtU7zT4MWutfbkvZbVRJg/S8jmnp/PoDGV4TDwF9CUrb/ynU7oXshf3P/HaFWId
	o0/eA5hA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tLysR-00000002qI2-1eLA;
	Fri, 13 Dec 2024 06:10:15 +0000
Date: Thu, 12 Dec 2024 22:10:15 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 8/8] xfs: support storing records in the inode core root
Message-ID: <Z1vPxz6pGwHu7zv3@infradead.org>
References: <173405122140.1180922.1477850791026540480.stgit@frogsfrogsfrogs>
 <173405122297.1180922.14475265699161663487.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173405122297.1180922.14475265699161663487.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


