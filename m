Return-Path: <linux-xfs+bounces-4741-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E8ACF877286
	for <lists+linux-xfs@lfdr.de>; Sat,  9 Mar 2024 18:51:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8A1211F21495
	for <lists+linux-xfs@lfdr.de>; Sat,  9 Mar 2024 17:51:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1A45250E0;
	Sat,  9 Mar 2024 17:51:45 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from mail.karlsbakk.net (mail.karlsbakk.net [46.30.189.78])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20BB11F951
	for <linux-xfs@vger.kernel.org>; Sat,  9 Mar 2024 17:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.30.189.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710006705; cv=none; b=JMjbMBv1FQM/6yDwG+2L3X6aYCDAD8MFLMC3sVvLu0tT0DMlVVTSDw01FQTOyko4o6mkqpJ5IpvyFi7Lgy+Mp/wGl5f7sbbj0D1iX8VxVk2LV0uj+1IMx9tOJ/EXLNouxF1i2pUGyELXOYtL+JjfJdqx6FHnPA7aG4uyN5cuMtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710006705; c=relaxed/simple;
	bh=YEk4oSJCPVHiX/perL0f/xe2W8ud/xa+/GmLO18/j74=;
	h=From:Content-Type:Mime-Version:Subject:Message-Id:Date:To; b=KutWkJMSmHFnC+bDbbjVju3dSk7KSKJ73TxG1lFPp/2rU65wDxlJW87rKOAzjd2cfl0vWbI9vKXDEBctBmj2sU1rBjHhKObc/vUsMi8v0msUmWu/JPzv1QeEKx8LIjgldqIuGOsvj7AGUg800ohDyB/ohtf9Mia41OirM0nSjKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=karlsbakk.net; spf=pass smtp.mailfrom=karlsbakk.net; arc=none smtp.client-ip=46.30.189.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=karlsbakk.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=karlsbakk.net
Received: from mail.karlsbakk.net (localhost [IPv6:::1])
	by mail.karlsbakk.net (Postfix) with ESMTP id 7B1E2376
	for <linux-xfs@vger.kernel.org>; Sat,  9 Mar 2024 18:51:41 +0100 (CET)
Received: from smtpclient.apple ([2a01:79c:cebe:d8d0:b47e:3023:674f:4d79])
	by mail.karlsbakk.net with ESMTPSA
	id 71nKG62h7GUKGBMAVNCnFw
	(envelope-from <roy@karlsbakk.net>)
	for <linux-xfs@vger.kernel.org>; Sat, 09 Mar 2024 18:51:41 +0100
From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Content-Type: text/plain;
	charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3774.400.31\))
Subject: Shrinking
Message-Id: <8E09083B-5A8A-4E6C-81AC-3F49A9EF266E@karlsbakk.net>
Date: Sat, 9 Mar 2024 18:51:30 +0100
To: linux-xfs@vger.kernel.org
X-Mailer: Apple Mail (2.3774.400.31)

Hi all

As the docs say, "currently, xfs cannot be shrunk=E2=80=A6". It's been =
saying that for 20 years or so, but I thought I read something about =
works in progress on this. Is this right or was it something in the =
vicinity of https://xkcd.com/806/?

roy=

