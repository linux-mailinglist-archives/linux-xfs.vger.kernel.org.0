Return-Path: <linux-xfs+bounces-16827-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D3BD9F0ED0
	for <lists+linux-xfs@lfdr.de>; Fri, 13 Dec 2024 15:15:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B14B81651B9
	for <lists+linux-xfs@lfdr.de>; Fri, 13 Dec 2024 14:14:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F80C1E0E07;
	Fri, 13 Dec 2024 14:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b="LHOaLG1e"
X-Original-To: linux-xfs@vger.kernel.org
Received: from mitropoulos.debian.org (mitropoulos.debian.org [194.177.211.212])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05E331E0DFE
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 14:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=194.177.211.212
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734099227; cv=none; b=m+wvnG2bA2Sa6uzCTtrYy5bEXx+JufcSVi42BIHXVj4xapFtyc3ql1m2MW0KGsElMuVfaYr+j6Vyc/zO6o8QV8TpUyX5K8nCIJPa2fDlbswyJj8xESduOa31MY/ZkYg65suAkdBYBrrQuDqY9cym7zmsOqo8cdhB1IRKSa7KQtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734099227; c=relaxed/simple;
	bh=0u4xxslF63JbwV3EmJLfvxqhvK0SaF63o2CEnCnxvTw=;
	h=To:From:Subject:Date:Message-Id; b=aO5aj8ku+wiBh2cCg91zhfZu2zbi7bInt5zr/+/64ofror9nPsdrr+aGN3UXCMpq0pzteCrdjOiJjWvBDkxM/zwi68cSj5dV8wleUCKpFs6+GWXT33gOC06q55G9I1QGjtzfHBaUESgcAMTU+KG064g1Q3obD58BOcFgm0pTz9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ftp-master.debian.org; spf=none smtp.mailfrom=ftp-master.debian.org; dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b=LHOaLG1e; arc=none smtp.client-ip=194.177.211.212
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp-master.debian.org
Received: from usper.debian.org ([2603:400a:ffff:bb8::801f:45]:33338)
	from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=usper.debian.org,EMAIL=hostmaster@usper.debian.org (verified)
	by mitropoulos.debian.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <ftpmaster@ftp-master.debian.org>)
	id 1tM6QI-000Guu-2m
	for linux-xfs@vger.kernel.org; Fri, 13 Dec 2024 14:13:42 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=ftp-master.debian.org; s=smtpauto.usper; h=Message-Id:Date:Subject:From:To:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=DYbMHUn44BIsQiV9Xhp2TBvhMzRkUlV9NyNh8WHDRB4=; b=LHOaLG1eI93n60lHTUY+5egnjz
	RX6KF7UrNOdPAoNjmQ36sX9L6daUPYFr6N04QlctuQ277ZXdTRuWuP0DnSHfpiXEAHqsGuFq4nFWI
	7TfBQhCZeAwP1H3GhBKQtzugBBPQNMItT0oaArgOUiLD36dbZNakN+gYxCVhaXzZAOBswuTc7q6M/
	Gtf80AjZDteC060oNbx2MnaT8lo/UWzC8g73u+hk1QM0PdNMamZeOlPON7JQCI36lBC3KLOor7hj3
	4C/ITTZqMQW22WxE+wiZonVLiX0ycanTK9G589xbEBeJuclj0N6pvANcY/RWVjubzdEV3eE/r4qtX
	ODsPg1GA==;
Received: from dak-unpriv by usper.debian.org with local (Exim 4.94.2)
	(envelope-from <ftpmaster@ftp-master.debian.org>)
	id 1tM6QG-000uKZ-Go
	for linux-xfs@vger.kernel.org; Fri, 13 Dec 2024 14:13:40 +0000
To: linux-xfs@vger.kernel.org
From: Debian FTP Masters <ftpmaster@ftp-master.debian.org>
Subject: Processing of xfsprogs_6.12.0-1_source.changes
Date: Fri, 13 Dec 2024 14:13:40 +0000
X-Debian: DAK
X-DAK: DAK
Precedence: bulk
Auto-Submitted: auto-generated
X-Debian-Package: xfsprogs
Message-Id: <E1tM6QG-000uKZ-Go@usper.debian.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>

xfsprogs_6.12.0-1_source.changes uploaded successfully to localhost
along with the files:
  xfsprogs_6.12.0-1.dsc
  xfsprogs_6.12.0.orig.tar.xz
  xfsprogs_6.12.0-1.debian.tar.xz
  xfsprogs_6.12.0-1_source.buildinfo

Greetings,

	Your Debian queue daemon (running on host usper.debian.org)

