Return-Path: <linux-xfs+bounces-12611-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 35F32968DD7
	for <lists+linux-xfs@lfdr.de>; Mon,  2 Sep 2024 20:45:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 66675B21726
	for <lists+linux-xfs@lfdr.de>; Mon,  2 Sep 2024 18:45:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EA2B1C62A8;
	Mon,  2 Sep 2024 18:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UjNqQ3Xm"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 301531A3AB2
	for <linux-xfs@vger.kernel.org>; Mon,  2 Sep 2024 18:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725302657; cv=none; b=mNjJtHeE0IfZzxmuRp/sWxMRxrCSDa5JuFqUnV8OqUDx9lNZ2UWuHBZmMPuKrkdDAvglk1z61VOtQZ9y4PporzmOYLWqVEH1tkRySByBnhwT73g7UYkEXcL5VO1QHbOKZCx/ff65fj/VrWgd8EIqxbOvp6YBCHRva19vzNLyCT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725302657; c=relaxed/simple;
	bh=kA/bPUKyRTpTlTOUOgxwyAah2ztQGrqWSb8HkC1cTD0=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=nNqChTrbnPFvsK8NokwLqIu8nogkuVPb2u5FQ291C5tKEBNVs9AnGyrjADwSKQ8SpDt3nh4Qh/O4i1i60BgLaIniW75GP/ndjqEy8EafmGmMQA8X2318EXrAcqJMJSnSA6IQjtFBclAHWlVotGrgtcEXpFS+jm9AlP09CYRXH3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UjNqQ3Xm; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7FE5C4CEC2
	for <linux-xfs@vger.kernel.org>; Mon,  2 Sep 2024 18:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725302656;
	bh=kA/bPUKyRTpTlTOUOgxwyAah2ztQGrqWSb8HkC1cTD0=;
	h=Date:From:To:Subject:From;
	b=UjNqQ3XmPrBza/BnlR5rnrbgLefZT6s4x7iXyRVgCPtQrWG4bqBOASMSOGOxQVSDy
	 DcT1whPpNpxegS7iJOzQiAtID642l14t+Pnf4X1lepsOkg9PL8o1MmHT1rETXJr8H9
	 uCoJx6yl/kGz7DlmSPvLy/E/isswvwXp5EM670JHhgWGGQR/njbpFdUk6cLLQZupO9
	 bLAVzX+chsXhY15pj74WOi48UStoWWyvmEjgKyNUMdkdKbiuSKUCVySZ2smWO7459P
	 /XDcrbAV4ssqT23T1L35H6NFim44NDjMzGigqsOibeMKqW74am79hQiVI9S4tcuD9s
	 pdpFRrFkHNz1Q==
Date: Mon, 2 Sep 2024 11:44:16 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: xfs <linux-xfs@vger.kernel.org>
Subject: no office hours this week or next
Message-ID: <20240902184416.GI6257@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi everyone,

Office hours are cancelled the next two weeks; see you all Sept. 17.

--D

