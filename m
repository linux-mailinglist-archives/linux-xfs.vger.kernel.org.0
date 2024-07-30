Return-Path: <linux-xfs+bounces-10861-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 49C189401E6
	for <lists+linux-xfs@lfdr.de>; Tue, 30 Jul 2024 02:10:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E6A581F22DA5
	for <lists+linux-xfs@lfdr.de>; Tue, 30 Jul 2024 00:10:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A56DC173;
	Tue, 30 Jul 2024 00:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OcifG2Yy"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63664621
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722298222; cv=none; b=BHc+KM8UTh98BVduRk30nuU+xrUvQVBEOjb4tyxXIfWhuLWdDoypoAJEHzL3TVENAHTti8NcD58WhwJ4OK+nUxLXwzHRPvVVXlTC3+m6nLmhakuvzBUV5yNykgWhnEZQcLZTy3a6uTMCAtW23+iXsaF8lm5alP5QAfevcV9+j6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722298222; c=relaxed/simple;
	bh=FR8IM2GYn6FUryg5C6nciHNJYHmyFQEQ5ftzwTq+yZY=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=dfU5Ev6ba2uQ37dJlfskEMHmGzGi9LNG7bpZJwCbCw+bNYf1tTwTSNzbtVEu6tf3O4fA5KgIPgUYg1W4W4JJH/s/ae8eDHDqMIeDdUakJA4jPl+WOkkmxXKjQFgpy3QjzL1AkPQjeWDCgqne9uWnF6rNaMe925jdY+piWMT8Yaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OcifG2Yy; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36DFFC32786;
	Tue, 30 Jul 2024 00:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722298222;
	bh=FR8IM2GYn6FUryg5C6nciHNJYHmyFQEQ5ftzwTq+yZY=;
	h=Date:From:To:Cc:Subject:From;
	b=OcifG2YySHX3Gg37FoTRnAnp9+lwpkZvhR53Vq5EdzUTY1ievkwPGJYuQd724fuzE
	 oatpnZfvoyPIJVpwYbNWj2X8fm2uYyKjCAM0P29Jo6/TACUh1pRVAVRxjDyOCv2NKd
	 yFfZPCV+epC/TIdRksjNdOT4GAYn2nlmv1YgZ+Mzcjsd3JE1DM0ETqQLDdpREDCFZA
	 Wf/SxGZtUqOctdQZuw4/WOAXk1W5TeNM61vQWPvy6lpFuJk7yy5l8ypswAb0Lw7DQt
	 mfhZh6i0YSl3/2Kd9Gd8Rfg7UESpNSICmd4AN3IuGX39DR/sHfQIdgUJb/QoeqA2t3
	 8952/C4QrjBcw==
Date: Mon, 29 Jul 2024 17:10:21 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: xfs <linux-xfs@vger.kernel.org>
Subject: [PATCHBOMB v2] xfsprogs: catch us up to 6.10
Message-ID: <20240730001021.GD6352@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Carlos,

For archival purposes, this is a resend of every patch that I have
queued (+ reviewed) for xfsprogs 6.10.  This will be followed by a pile
of pull requests for all that work.

v2: apply reviewed by tags, accumulate bugfixes

--Darrick

