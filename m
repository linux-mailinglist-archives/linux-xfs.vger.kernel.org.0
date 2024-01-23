Return-Path: <linux-xfs+bounces-2940-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B20EE8390BE
	for <lists+linux-xfs@lfdr.de>; Tue, 23 Jan 2024 15:01:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E533B1C209E8
	for <lists+linux-xfs@lfdr.de>; Tue, 23 Jan 2024 14:01:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4ED45F841;
	Tue, 23 Jan 2024 14:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="cL5aqgHw"
X-Original-To: linux-xfs@vger.kernel.org
Received: from mail-4325.protonmail.ch (mail-4325.protonmail.ch [185.70.43.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70E2A5EE80
	for <linux-xfs@vger.kernel.org>; Tue, 23 Jan 2024 14:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.43.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706018514; cv=none; b=HdKyofwiVZLaMF/iYspVdZGo56MXUpS0fScWjLg2PJLUXpcmA52wbL2EbAQ2Zk0DPKJvY+98TayLzEztsqS2SeZI5y4qYk6PmKgyTBcN+ABHJsXB4R32vfLDdJR6KGfvKiqqNB1Y9zO/k41hUuXDz/PJsHESOp/9yWEUZxk8ALw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706018514; c=relaxed/simple;
	bh=trGOWds0fEYe1wzFted2E+1D8wQGMIpHhCKGkBqCw8g=;
	h=Date:To:From:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=mMMFAuPP+59d3NTj9LYtpsUmlmf4VLd6hZ/OrLVHMv5EP/AQ0TJgFSfKT6REvan4pafHFUca5imnQxSjt4TJWF3+n9/4D5UkZGEzeyvYiwj7/VBZOTpsuuLKJgGeh5Gc+xdVmhC53TtMlS1YDjcj6PrDp0o2fOqckCXe6fKa/Lc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com; spf=pass smtp.mailfrom=protonmail.com; dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b=cL5aqgHw; arc=none smtp.client-ip=185.70.43.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1706018503; x=1706277703;
	bh=trGOWds0fEYe1wzFted2E+1D8wQGMIpHhCKGkBqCw8g=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=cL5aqgHw5hOfrerRlUvsJLaQOvQWryIgtVB3mmVMDvE/pSj7hjHbpC7JL7SrMZe9Z
	 WoB4VHVnhNOEaGzclgDEGdoLh+VcIR3WCURA0ExNjaDbiCczqaYDouGEtiFg9z9xJy
	 HMcGjBEPZHwtmV8FrTbW72KpwdixdbK9JloawU6cjHAiIkL85jCIi5W1ITmsss4dD1
	 HkZBGcWu3LZRVgRqO/XHCktzg/urCTb5cpNesOYJtNnZ49OZmgaJmu3mdbkXn6heVB
	 0MUbhOG0iNZBJFQT3XMZRu+SMGXZ4Pn5p8LlKPhdujMm2R6cL9EsPl68NKtXSiKH5q
	 QeSNa5+g4D8yw==
Date: Tue, 23 Jan 2024 14:01:26 +0000
To: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
From: Turritopsis Dohrnii Teo En Ming <teo.en.ming@protonmail.com>
Cc: "ceo@teo-en-ming-corp.com" <ceo@teo-en-ming-corp.com>
Subject: Linux XFS Filesystem
Message-ID: <T1L4JyBQEhgUzWMIZdaEf2tUOPEpgU7rr-oBWt0xa2NIDTd25PonEgzegbKVyVMk8pC0blp-LK0B2VG5tNPDRu6sow-YsQwgERj2IWDy70g=@protonmail.com>
Feedback-ID: 39510961:user:proton
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Subject: Linux XFS Filesystem

Good day from Singapore,

Today, 23 Jan 2024 Tuesday, is the first time I have seen CentOS 7.9 Linux =
Server using XFS filesystems. All along I only know Linux distros use ext2 =
/ ext3 / ext4 filesystems only.

A major construction company in Singapore is actually using XFS filesystem =
on its CentOS 7.9 Linux server, installed with cPanel web hosting control p=
anel.

Regards,

Mr. Turritopsis Dohrnii Teo En Ming
Targeted Individual in Singapore
Blogs:
https://tdtemcerts.blogspot.com
https://tdtemcerts.wordpress.com
GIMP also stands for Government-Induced Medical Problems.






