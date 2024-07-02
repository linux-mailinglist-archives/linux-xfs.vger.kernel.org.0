Return-Path: <linux-xfs+bounces-10219-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CE3C891EEFA
	for <lists+linux-xfs@lfdr.de>; Tue,  2 Jul 2024 08:27:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0D6D61C219C2
	for <lists+linux-xfs@lfdr.de>; Tue,  2 Jul 2024 06:27:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BB7A77119;
	Tue,  2 Jul 2024 06:27:12 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFB482AD17
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 06:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719901632; cv=none; b=SGJI2Y7zMLdOdgKbJmIGsFE5hLqE5KGbsyifyj5jrSe3qeYw770NuBwa4PLdsKu7NVitwPMszW6QGf3SNxqarB3Dr6GZhnpfwbJNAMvXF6rr68wB5biblAnBncSVtpObHrG0Cv8o9hOWoDf9JPXC3MLfXP1li/n3Vci0E4g+pdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719901632; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cSwVEJlPpzAth6UNraRKJbv6BMYqKFDD03a1NRj6woR/AC7GjBh+2sam0YyF2X33lkA9WmkZmq9wFW/gqr21zl+xlZ57qf/cnb7FFRe5Me3bFsrl11a1SqRFk51thY6r2lnEvBAjNB+OPj90xbdukyjafMh/XMMElEXTpFYw7w8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 2C3CC68B05; Tue,  2 Jul 2024 08:27:08 +0200 (CEST)
Date: Tue, 2 Jul 2024 08:27:08 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, Allison Henderson <allison.henderson@oracle.com>,
	catherine.hoang@oracle.com, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 09/24] xfs_logprint: decode parent pointers in ATTRI
 items fully
Message-ID: <20240702062708.GI24089@lst.de>
References: <171988121023.2009260.1161835936170460985.stgit@frogsfrogsfrogs> <171988121202.2009260.6158755392578479304.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988121202.2009260.6158755392578479304.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

