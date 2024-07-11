Return-Path: <linux-xfs+bounces-10548-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B923692DF63
	for <lists+linux-xfs@lfdr.de>; Thu, 11 Jul 2024 07:20:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5A5B2B217AD
	for <lists+linux-xfs@lfdr.de>; Thu, 11 Jul 2024 05:20:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E6CE481D0;
	Thu, 11 Jul 2024 05:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WZqOA3NN"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D8A41C3D;
	Thu, 11 Jul 2024 05:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720675246; cv=none; b=GxBt44l83e/0xEiM/0zVh5dAhkmjmiMGgBorPNfPJfqpKTag9jLiVE8Zrvci1QENMmtjSF8nuNoGJ6MVd2P2c2OtyDNEfEdOiJlIJqRpBTzp5gh8PF5+lGy6ovDZuUa9HYRC2aZT5O5zga6eSjwZe2M/mFsDziH1ULn5VOp4Rj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720675246; c=relaxed/simple;
	bh=aSNxE3Xll7MWeaRzcJnR2/P7JxUky4COV+pcf6yolUc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=kBTZKTTX/RkSojwU9GleIbwG4S/h4Tbqz8VQrT8zyIvhQgRkQQzdzHdSI5PdGSziKtGwWdEColtB1T+4zn6Dal9iiO4KGp0oP9MyvjyziwFoP83GRBXIM0Fgi+y+DT7PJTjIbcQSaaESgtZGbedtYyDuR3KUMwM86JFhzGKl0Us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WZqOA3NN; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E7F8C116B1;
	Thu, 11 Jul 2024 05:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720675245;
	bh=aSNxE3Xll7MWeaRzcJnR2/P7JxUky4COV+pcf6yolUc=;
	h=From:To:Cc:Subject:Date:From;
	b=WZqOA3NNnpegKNCLyHHv6jSoorganWkPYNwqoNZDv+Q2uA0jI6uPeApUJLn3a8XSc
	 0hCwDi5FSr+0VmaK298H60zH2zpFefdjsIIsUPdKAzH82tk2dAgTA6gu06dStMZOx6
	 MbYNh1tEBQTGqbr0yI0s1ITNcPGLwxkGDaoAXMg3K/DWktS5cIKk3V4DR+gSKhjSfv
	 t5FO9Dt72xqDKcoIW8pRRINJC8XHvNsziMQZ7PZeRSr/PMELrGcvBC6iqpsymB9FM7
	 w9NG9yhuc7QdZgqiSeDpNA/bgTwZfyh0xDcJ6Q8GPAm1JzutMgg3D6IwCD261n7lXa
	 aisrE3gZpHsFQ==
User-agent: mu4e 1.10.8; emacs 29.2
From: Chandan Babu R <chandanbabu@kernel.org>
To: chandanbabu@kernel.org
Cc: djwong@kernel.org,hch@lst.de,linux-fsdevel@vger.kernel.org,linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next updated to 2bf6e353542d
Date: Thu, 11 Jul 2024 10:48:56 +0530
Message-ID: <874j8wa4ic.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Hi folks,

The for-next branch of the xfs-linux repository at:

	https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been updated.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.

The new head of the for-next branch is commit:

2bf6e353542d xfs: fix rtalloc rotoring when delalloc is in use

1 new commit:

Christoph Hellwig (1):
      [2bf6e353542d] xfs: fix rtalloc rotoring when delalloc is in use

Code Diffstat:

 fs/xfs/xfs_rtalloc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

