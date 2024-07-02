Return-Path: <linux-xfs+bounces-10228-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8808691EF0E
	for <lists+linux-xfs@lfdr.de>; Tue,  2 Jul 2024 08:36:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A0E8A1C21B31
	for <lists+linux-xfs@lfdr.de>; Tue,  2 Jul 2024 06:36:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E43B523D;
	Tue,  2 Jul 2024 06:35:59 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C896B60BBE
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 06:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719902159; cv=none; b=JYU1vOHfzJRJM5X/5WRgbnUzV2l5xfbQBRPCx12eOY6TkxbK7IoXIDEM1ZiAbR0YZgA3Wx5wEO6kohpKUtqWR9WoOrNQDMl1uq3KnEAYIXN2gmOG6cpHPjboLLnGkJnqMzgBhp/sew3yJ/z8aUZ8Zh0UZp5n1URgP4dm/D6EWBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719902159; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F6Ho3YTu96ZogV2EUiXucAmbZsgiNOKpfS8bo6/Jhbc6Up5jEYSt6qp0xgaiZDNQdl9xXNtnDfnvq75/rtBAiF/W/z/3AOhZQSPpbWSTVHjusyiRf8XJ2HODCN0tiYAeWWsceFNc4o+cFNIZlCYnOQPTtgXWZ8kJEID+HcDlUQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id E047E68B05; Tue,  2 Jul 2024 08:35:54 +0200 (CEST)
Date: Tue, 2 Jul 2024 08:35:54 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
	allison.henderson@oracle.com, hch@lst.de
Subject: Re: [PATCH 18/24] xfs_db: add a parents command to list the
 parents of a file
Message-ID: <20240702063554.GB24549@lst.de>
References: <171988121023.2009260.1161835936170460985.stgit@frogsfrogsfrogs> <171988121341.2009260.989865979378157675.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988121341.2009260.989865979378157675.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

