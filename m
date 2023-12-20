Return-Path: <linux-xfs+bounces-1007-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BCF281A5F4
	for <lists+linux-xfs@lfdr.de>; Wed, 20 Dec 2023 18:06:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9C63B1C21D5B
	for <lists+linux-xfs@lfdr.de>; Wed, 20 Dec 2023 17:06:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07B7047774;
	Wed, 20 Dec 2023 17:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VA9nEuxV"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C81B847771
	for <linux-xfs@vger.kernel.org>; Wed, 20 Dec 2023 17:06:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C1C2C433C7;
	Wed, 20 Dec 2023 17:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1703092002;
	bh=vaKwrj+ybBpuDodIKXbYUl4wBcF0gLjxTWBEXjpyT48=;
	h=Date:From:To:Cc:Subject:From;
	b=VA9nEuxVsuVZfJ43TDO04jVzUD/wFhLHsxohWZi/rEXTSTKJW8S7PXW+2JvpwAg0+
	 wePEwOfbvqWHnf0JCfdsHD1BSeH650C4ZULzMt8lYr9pKuCeir2HRf+4UYdKprMCCZ
	 UbJElivq1Y2WdsBnLrdakfKXRWGGt5yE2T8hJJCesqLGpouTK+SRN+dkfDmqsiOgA6
	 8Tcn4bAqGZf27oh1sGomUt5R/c2yAE8RXy2568xQ91gs+VUI7LIx/8DCKpFt4q0exW
	 vpTwQGO0yi1LMkEp+UE5EmJpDPKpQz5At5RMLn8FQhPq9pvEkvQdc+K6NFH7tb/dfZ
	 JdVltMt+M0uhA==
Date: Wed, 20 Dec 2023 09:06:41 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <carlos@maiolino.me>,
	Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCHBOMB] xfsprogs: pending changes for 6.6
Message-ID: <20231220170641.GQ361584@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

Here are all the pending bugfixes and new code that I have staged for
6.6.  Can we get the unreviewed ones through review, and the reviewed
ones merged into for-next, please?

Unreviewed patches:

patchset 1: 3, 4, and 5
patchset 2: 6
patchset 3: 1-4

Fully rewiewed:
patchset 4:

--D

