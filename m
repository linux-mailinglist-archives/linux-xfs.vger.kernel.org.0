Return-Path: <linux-xfs+bounces-23519-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AA202AEB06E
	for <lists+linux-xfs@lfdr.de>; Fri, 27 Jun 2025 09:47:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 357063B68F8
	for <lists+linux-xfs@lfdr.de>; Fri, 27 Jun 2025 07:47:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 676582CCA9;
	Fri, 27 Jun 2025 07:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=growora.pl header.i=@growora.pl header.b="PF9s+zPH"
X-Original-To: linux-xfs@vger.kernel.org
Received: from mail.growora.pl (mail.growora.pl [51.254.119.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14A9CC2FB
	for <linux-xfs@vger.kernel.org>; Fri, 27 Jun 2025 07:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=51.254.119.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751010443; cv=none; b=YwIGWUWP0pTCiomydXMdAw80fQopuYAHt4V+RYOg+qwWkaz6UiWtcyLm2gsnf91Wc8i4AQEiG5hgXv90XvDzbbcpGUi5bGBLgDv1Wz125kPQ7wef5LJrLAWJ/Qr1ZoZZiBD3rsCtQGPzZd/KQrtesgmLrSYSJcS7DfK+kGR2DZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751010443; c=relaxed/simple;
	bh=EB99enkNQ3/lKc2PdUObvM5/Gi3NF8gZrWwaTOp5KYs=;
	h=Message-ID:Date:From:To:Subject:MIME-Version:Content-Type; b=qW0oqQsjOxmwaP6/uh4QM/1P/ACJ/ZkxLBFSRS/Y4JCLxQ4pfv7/vAiTosR5g05sEmZO2kyT8hmmGAXVKA2IQ4rNXlPbcUs8b/U1HlPlo0j4txDaTCTmnhpZ57Gdwa8MbJldduzCOdvKAt/Uid3xBEEDzHkNj1iS1jUuydyC1fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=growora.pl; spf=pass smtp.mailfrom=growora.pl; dkim=pass (2048-bit key) header.d=growora.pl header.i=@growora.pl header.b=PF9s+zPH; arc=none smtp.client-ip=51.254.119.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=growora.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=growora.pl
Received: by mail.growora.pl (Postfix, from userid 1002)
	id 6247323916; Fri, 27 Jun 2025 09:46:20 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=growora.pl; s=mail;
	t=1751010433; bh=EB99enkNQ3/lKc2PdUObvM5/Gi3NF8gZrWwaTOp5KYs=;
	h=Date:From:To:Subject:From;
	b=PF9s+zPHlPv8K5FesbXzcM+Via9klKHQz5KN2ENxvqcJmA/LRjUPcCdY3LtqcTSNd
	 6FRUNZ0RKxHAD2B13NNFedqU5DK1xawmdE0u+wuuMTFykN5eFQ5/AIu+gpeIug2HPW
	 3H6brQmidH5siqNJPl+xEzkL7Ayl4wkFKajl4UZip8gdh4N+Qk3WHCLmxlO1VGkMEY
	 tiMbLsKkUs7MFvyziJgdbIJFm5x65KSBu1t4AQzr/km+/GHQUolbjy6pYA8JMTjZEd
	 8SeIvs6/y2uRdJ4X91SupSXM5t3V9gTUPnhWt4brHeQo1xT6lGG61gT3hJOiBb9BAM
	 Ln6rts7ElFH2w==
Received: by mail.growora.pl for <linux-xfs@vger.kernel.org>; Fri, 27 Jun 2025 07:45:48 GMT
Message-ID: <20250627084500-0.1.ka.21kip.0.6i4jk50dxn@growora.pl>
Date: Fri, 27 Jun 2025 07:45:48 GMT
From: "Mateusz Hopczak" <mateusz.hopczak@growora.pl>
To: <linux-xfs@vger.kernel.org>
Subject: IT bez rekrutacji
X-Mailer: mail.growora.pl
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Cze=C5=9B=C4=87,

wiem, =C5=BCe rozw=C3=B3j oprogramowania to dzi=C5=9B nie tylko kwestia t=
echnologii, ale tempa i dost=C4=99pno=C5=9Bci odpowiednich ludzi.=20

Je=C5=9Bli temat dotyczy r=C3=B3wnie=C5=BC Pa=C5=84stwa zespo=C5=82u, by=C4=
=87 mo=C5=BCe warto porozmawia=C4=87 o wsp=C3=B3=C5=82pracy, w kt=C3=B3re=
j to my przejmujemy ca=C5=82y proces tworzenia oprogramowania =E2=80=93 o=
d analizy po utrzymanie. Pracujemy elastycznie, dostosowuj=C4=85c si=C4=99=
 do wewn=C4=99trznych procedur i Waszego stacku technologicznego.

Dzia=C5=82amy tak, jakby=C5=9Bmy byli cz=C4=99=C5=9Bci=C4=85 zespo=C5=82u=
, ale bez operacyjnego ci=C4=99=C5=BCaru, ryzyka kosztownych rekrutacji, =
z elastycznym podej=C5=9Bciem i transparentnym modelem rozlicze=C5=84.

Czy jeste=C5=9Bcie Pa=C5=84stwo zainteresowani pog=C5=82=C4=99bieniem tem=
atu?


Pozdrawiam
Mateusz Hopczak

