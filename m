Return-Path: <linux-xfs+bounces-21187-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B32FA7D483
	for <lists+linux-xfs@lfdr.de>; Mon,  7 Apr 2025 08:51:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4B120188AE10
	for <lists+linux-xfs@lfdr.de>; Mon,  7 Apr 2025 06:51:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7F3622539E;
	Mon,  7 Apr 2025 06:51:20 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1042322B;
	Mon,  7 Apr 2025 06:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744008680; cv=none; b=B6rrxZu7u5YCMtzetStoO9r13krJmV5EVJy422PaZxTv3FD57JBGlANF1fSC2xJvEE4YzyKhFdKbqaqHfjVjWvYtOEWFft2K3I0fA1Auprs0e6L+jagSgY4O48TeUf0FdjfhpdQIKWinhO0aEudS+y4n8sbGksHhk706TVYIi40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744008680; c=relaxed/simple;
	bh=tzBmK7cmEirE67951CjBYF7TlBQ2fFR57orfuBTWVgk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NgRMw79NHr6UQlk4I6FgqyRvEXtplcsk37ckB9aZBClFKWb/xGBNogUa3Gtp9I3hXm9uY/BJ7vkWE4A/OL2WV01MSBQli197X92l24E7hN73nBWLJujomvjbDm3LSuILvW7pxYibNnYc+bIreStrqClEOm3gUEQxpCM+dSpAgeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 540DE68BFE; Mon,  7 Apr 2025 08:51:11 +0200 (CEST)
Date: Mon, 7 Apr 2025 08:51:11 +0200
From: Christoph Hellwig <hch@lst.de>
To: John Garry <john.g.garry@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, alx@kernel.org, brauner@kernel.org,
	djwong@kernel.org, dchinner@redhat.com, linux-man@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, ojaswin@linux.ibm.com,
	ritesh.list@gmail.com, martin.petersen@oracle.com,
	linux-api@vger.kernel.org
Subject: Re: [PATCH RFC] statx.2: Add stx_atomic_write_unit_max_opt
Message-ID: <20250407065111.GA18891@lst.de>
References: <20250319114402.3757248-1-john.g.garry@oracle.com> <20250320070048.GA14099@lst.de> <c656fa4d-eb76-4caa-8a71-a8d8a2ba6206@oracle.com> <20250320141200.GC10939@lst.de> <7311545c-e169-4875-bc6c-97446eea2c45@oracle.com> <20250323064029.GA30848@lst.de> <5485c1ad-8a20-40bc-aa75-68b820de5e1c@oracle.com> <20250404090601.GA12163@lst.de> <aab0aa19-f279-42b4-9ab7-0cc6e2fa3b9f@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aab0aa19-f279-42b4-9ab7-0cc6e2fa3b9f@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Apr 04, 2025 at 10:23:09AM +0100, John Garry wrote:
>> that optimized case will not involve the usual hardware offload.
>>
>>
> stx_atomic_write_unit_max_opt it is then.
>
> Or stx_atomic_write_unit_max_optimal or stx_atomic_write_unit_max_fast. Or 
> similar..

As we've used opt in various other ABIs I'd stick to that.


