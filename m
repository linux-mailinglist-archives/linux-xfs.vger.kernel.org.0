Return-Path: <linux-xfs+bounces-11369-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DBB194ADC5
	for <lists+linux-xfs@lfdr.de>; Wed,  7 Aug 2024 18:11:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E49141F22322
	for <lists+linux-xfs@lfdr.de>; Wed,  7 Aug 2024 16:11:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC53412C473;
	Wed,  7 Aug 2024 16:10:09 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7260913A25F;
	Wed,  7 Aug 2024 16:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723047009; cv=none; b=lmnEqinfiyENmer+oDaF+8dSrFherbfaQkjQzetpwTI26YlH3h7z2WScQac6vRcxp+CvyFNYFOmlaJwqka6uC2O6X2F7triP5GP58Jdld8DFNEQCbyVQBgVKTJ993BMbUPfDfVaZ22M99RAYKZ5mqqJySRXyqSULVgvwj9Ii1pM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723047009; c=relaxed/simple;
	bh=CuofLq6vdo0Apif1bCFm+YmYNBBPGMBzX7OhJAxEaGA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Nm4CCW499B638WSFu8vHlTCVu+TRqFOaXeX/aroGUIT3WLF/d6jSQpgsXTpIFPRjrMZZimQwl9jG3po4SVLrtkxAvP/+gEtLWtL2WYapvR9jJ0xtACagrXSsRmNyO4RAVU7g+p9uR2/qygs+hM9DNJYD1l7jDxUdL2Li+Ge3OQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 653C968BFE; Wed,  7 Aug 2024 18:10:04 +0200 (CEST)
Date: Wed, 7 Aug 2024 18:10:04 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, Christoph Hellwig <hch@lst.de>,
	Dave Chinner <dchinner@redhat.com>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/7] xfs_db: improve getting and setting extended
 attributes
Message-ID: <20240807161004.GB9745@lst.de>
References: <172296825181.3193059.14803487307894313362.stgit@frogsfrogsfrogs> <172296825234.3193059.7895487674250550849.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172296825234.3193059.7895487674250550849.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Aug 06, 2024 at 11:20:06AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Add an attr_get command to retrieve the value of an xattr from a file;
> and extend the attr_set command to allow passing of string values.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>Reviewed-by: Christoph Hellwig <hch@lst.de>

Missing newline here again (not going to say this again if it shows
up on more patches..)


