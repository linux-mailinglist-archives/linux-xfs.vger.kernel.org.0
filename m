Return-Path: <linux-xfs+bounces-16511-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F9B59ED6FB
	for <lists+linux-xfs@lfdr.de>; Wed, 11 Dec 2024 21:06:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 32C63282F9C
	for <lists+linux-xfs@lfdr.de>; Wed, 11 Dec 2024 20:06:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 588F91D6DA4;
	Wed, 11 Dec 2024 20:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UCW7JLdb"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18E2F2594B3
	for <linux-xfs@vger.kernel.org>; Wed, 11 Dec 2024 20:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733947560; cv=none; b=plTKx3kbZr0y6WIapQ8roHtweCAEOG4ZeiERulrbCVf+CB9K7+mc/6GB/+PCH1JM0C6HwCSzxh9D1eSqNlgIg8vaIsEWq1L8eeUs0uodlwXLF6OzalePskHTK8wWf8YCyhD/Jdp89vF4g+PxyHv2xkzCyGBJS78Q959wLFEWWDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733947560; c=relaxed/simple;
	bh=yRYaUAzBal/g+gYiBBSj4Cp7iSPD5cDUKaryf4/Gf5k=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=HnDAgUO+xnOXSb/jz6aGjCT46O+08taaxM0LHDJPssfea00Jqbe7NBC6amiFsHlJflnlFeEjMB9joC45GeZzAKXeurCFfGrgFeZAHsMKpPccE5CxOsjP1Yw80XksIJ4YYpyc/iL7GsT4ASOW8XZMFmr9sNSLGK7GTF9CL20etbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UCW7JLdb; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A20EDC4CED4;
	Wed, 11 Dec 2024 20:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733947559;
	bh=yRYaUAzBal/g+gYiBBSj4Cp7iSPD5cDUKaryf4/Gf5k=;
	h=Date:From:To:Cc:Subject:From;
	b=UCW7JLdbRoSya5Kgb+JJuKg12tLWhYBPb8evnkPExOHvH265rfNeQFN4hflfTKyot
	 BNiw8C1lQn4fAmS6XKYhqjGd0KSbCLY0Sjs7kG6FFAYJXs2ib1rGD9xEre3rOeg5+g
	 lLyQbsSGAH1w95XxA55RR8I81WkXfLsQG3R2BYnCvCJmgq/82NQqzo+XaiTdV4Kcpv
	 OsV7aOKSMvPkO9phfqshu56qC90EYlqb5L1JT/zMC+6bZz+dVjppEBHUlPRlpEQGzz
	 +NNn8sl1QU0qJbzF2FsNna2gD9a6nWFD5B8+xr4vg4C9BKZVOykId4T8KoZk5DYIKh
	 Djp32ujiUNoDg==
Date: Wed, 11 Dec 2024 12:05:59 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, xfs <linux-xfs@vger.kernel.org>
Subject: [PATCHBOMB v4] xfs: proposed fixes for 6.13-rc3
Message-ID: <20241211200559.GI6678@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi everyone,

Here's a resend of last week's bugfixes series with the function comment
changes that came up during the last round of review.  Everything's
ready to go now, so there will be a pull request at the end.

--D


