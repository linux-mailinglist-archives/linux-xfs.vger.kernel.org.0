Return-Path: <linux-xfs+bounces-13299-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 445CD98B785
	for <lists+linux-xfs@lfdr.de>; Tue,  1 Oct 2024 10:50:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E9D1B28158F
	for <lists+linux-xfs@lfdr.de>; Tue,  1 Oct 2024 08:50:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C73A19DFA2;
	Tue,  1 Oct 2024 08:48:30 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C64419DF9A;
	Tue,  1 Oct 2024 08:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727772509; cv=none; b=EdmoAtcyvZS9Jxkh3sC5lxiO68gqrvjjxvbru9NwY+uL4DzmxwxZnFwy/TN1jM0sHt124PqU4J/ufpt5UX3nLxGoBBasFO7yuyRs3fGarWAdVn9+bnIPisbvV74Ue4trh6qi5CIOWrq+Z0Nc/9L5CBudWOnjXo9tJHQpmQX5/7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727772509; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=csilEM9JUcGhRWJ/43elaWD7AaATYPhqrhFQv1ssWcvE3gtrgS0L4ozHRl/brEBiPQO+qzgquaN+kh17eRY0YNLUD6olDG7h78cGwqtic3pcUU8nZ6TafRbvq99/U71y99O4PqyVZU/Ct+hx6/i1Fz44lxZ1fc9nlbAkCLEq8Xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 10C4C227A87; Tue,  1 Oct 2024 10:39:12 +0200 (CEST)
Date: Tue, 1 Oct 2024 10:39:11 +0200
From: Christoph Hellwig <hch@lst.de>
To: John Garry <john.g.garry@oracle.com>
Cc: axboe@kernel.dk, brauner@kernel.org, djwong@kernel.org,
	viro@zeniv.linux.org.uk, jack@suse.cz, dchinner@redhat.com,
	hch@lst.de, cem@kernel.org, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, hare@suse.de,
	martin.petersen@oracle.com, catherine.hoang@oracle.com,
	mcgrof@kernel.org, ritesh.list@gmail.com, ojaswin@linux.ibm.com
Subject: Re: [PATCH v6 1/7] block/fs: Pass an iocb to
 generic_atomic_write_valid()
Message-ID: <20241001083911.GA20648@lst.de>
References: <20240930125438.2501050-1-john.g.garry@oracle.com> <20240930125438.2501050-2-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240930125438.2501050-2-john.g.garry@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


