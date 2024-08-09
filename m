Return-Path: <linux-xfs+bounces-11458-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5958A94CF71
	for <lists+linux-xfs@lfdr.de>; Fri,  9 Aug 2024 13:41:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 80AC11C20DCA
	for <lists+linux-xfs@lfdr.de>; Fri,  9 Aug 2024 11:41:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4CC8192B9F;
	Fri,  9 Aug 2024 11:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W9TH7DYq"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75E2915A848;
	Fri,  9 Aug 2024 11:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723203697; cv=none; b=WrPN89/Oj3cbpMsVnC5vsAN8vhHGg6zVnRvKNgWnLCsHfF4DJaHU0vfUgkv9w/fHQGoL0p0aN6Ra3hqvtAQr3/uSsxy+LsBGPkHlGRL75midgGVR7dA59jm21KuovR9noSlNajNipAxmjMhkw2B2wo7nDaZQwRjLvD249650mP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723203697; c=relaxed/simple;
	bh=C4OA3vkJMPDL5TF3fFgfWl6KPBzqIcnrVbLf3M+LOTc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MMaMfyXFAEDgMFP+WvOTEoUti6XABQR3rAJRZDuFMk91Kb5IdKB8ygmOBI4Oe6myloD/ZkGt4nGhQ2fzJV+Kpy2LohxfxEv97AtSQAZHr4BgvPHUT0i4T1/73Kz8BzZooDPGCexgHwTo71cK04+4h07HOAUCR3OkPRAQoPS/R24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W9TH7DYq; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C02CAC32782;
	Fri,  9 Aug 2024 11:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723203696;
	bh=C4OA3vkJMPDL5TF3fFgfWl6KPBzqIcnrVbLf3M+LOTc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=W9TH7DYqQ1xBAzU2XwbNZlsgyaIu89iCxrY3W5kfMnNfWA+VQZAidk/ffIhtWmFqL
	 p1O8q4kHT9I6p6+CCdM+440hT294VNAOJnUzEfthYvteKpq+1DM2Hx/L+F7F/zFj9f
	 mjbfjsRLSs84GXEL6FRMhusSSZYV7QjYA2EgY+AnVcBxhqIVLu1xcOMbmcujriiNyi
	 wPISbuKBsH3KcOKvvqpqWzllw1ivKUPmVctqz3Q0kGzeInzVFSX/cIMu4iZLE1gu3z
	 z5NEKj7Lb616mLSwmdeTLfkGLprKYJGWlinHocMZePgfxozKnRQBRsnS9RmjNly8/p
	 OZ6jo20p6KXxg==
Date: Fri, 9 Aug 2024 13:41:32 +0200
From: Christian Brauner <brauner@kernel.org>
To: Josef Bacik <josef@toxicpanda.com>
Cc: kernel-team@fb.com, linux-fsdevel@vger.kernel.org, jack@suse.cz, 
	amir73il@gmail.com, linux-xfs@vger.kernel.org, gfs2@lists.linux.dev, 
	linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH v2 07/16] fanotify: rename a misnamed constant
Message-ID: <20240809-sanduhr-nachverfolgen-80b6000699d0@brauner>
References: <cover.1723144881.git.josef@toxicpanda.com>
 <5d8efd2bf048544e9dcc7bb00cb9013837e3db6c.1723144881.git.josef@toxicpanda.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5d8efd2bf048544e9dcc7bb00cb9013837e3db6c.1723144881.git.josef@toxicpanda.com>

On Thu, Aug 08, 2024 at 03:27:09PM GMT, Josef Bacik wrote:
> From: Amir Goldstein <amir73il@gmail.com>
> 
> FANOTIFY_PIDFD_INFO_HDR_LEN is not the length of the header.
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---

Should probably be routed separately?
Reviewed-by: Christian Brauner <brauner@kernel.org>

