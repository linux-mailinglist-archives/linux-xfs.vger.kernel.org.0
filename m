Return-Path: <linux-xfs+bounces-32009-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iOr8Ervermm/JQIAu9opvQ
	(envelope-from <linux-xfs+bounces-32009-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Mon, 09 Mar 2026 15:52:43 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id E022523AF06
	for <lists+linux-xfs@lfdr.de>; Mon, 09 Mar 2026 15:52:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 371AA3016711
	for <lists+linux-xfs@lfdr.de>; Mon,  9 Mar 2026 14:52:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3CE23D567C;
	Mon,  9 Mar 2026 14:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="KrQsV4Z1"
X-Original-To: linux-xfs@vger.kernel.org
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E06633D5657
	for <linux-xfs@vger.kernel.org>; Mon,  9 Mar 2026 14:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773067960; cv=none; b=le7rsiIh1kTihBvzsx1PW2BKorUaPFS/4xhSoPxyMknT3bzpCyh4NBDyRNpwfMAqQsnEHczJ/iIeECqJwKtwFjgQBt50Ej7mdlNoM9Qq16LTCIFLh7zJVlHA5kSkpBnELcKUE2qwCpPn6BkpD2kCoWR91lYrJHk9dDoqawT1imo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773067960; c=relaxed/simple;
	bh=njW+dpSk10SuO1AcbH5tukD81vdWuhIyIPazhF2qfvk=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=V20fPD8ZW6PUZ6EFU+dQS9DHr5wLr9CtyWk95F55htSB72xbBMWBKi/i/BxrBKFxYOA+ntA78YyUYFkYjmpijXhuurgRfYXujchUqBjku4HZjHDgWbY2g9jdpmSisqpFyI8Xw81h1EVNOMApvNLxpmLPr5y9Pm7qTSPpAJg0deY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=KrQsV4Z1; arc=none smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-50335b926c2so105126301cf.2
        for <linux-xfs@vger.kernel.org>; Mon, 09 Mar 2026 07:52:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1773067958; x=1773672758; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M362llShL/olgkvofrhnarltpI/bzDs+ZoXPZquhvi8=;
        b=KrQsV4Z1HnvgdgqrimF/HVIwAkgper6YwqQPBBhU179xQaK/8nfR4pTwUAED/LNhgl
         63NsYsAx9O+zHoQ0+NroafKUa1BE08m1wZqPQgYv9V+K2yQOuz8B2M8x7WXsiTg8TBy5
         UtqERWpCaFMGZ9hf7mKS4UcTGuEwmMuRZJr4yKuD+ssb5EqAv5SCfUahyGCytEP3DT0Z
         XOlRVNB90LXvnpKr42vGSGENW89XVDzNoiIIipS0TO1y/xTg8LuACIgJSJtYPRDhBVdG
         z4ip2wmVtrQvsMULJw67GfW2Ic4DmkMAL5gDlOsPKn8+KfDmwI4Vtqi8z7Cd3V+uaY5s
         yCaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773067958; x=1773672758;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=M362llShL/olgkvofrhnarltpI/bzDs+ZoXPZquhvi8=;
        b=Y8NMOiaj0ZwfNAFbYL1om2ORHemVDvZkRYC9DppcBBF37g3mYx9nbaC5vsMOSQliDb
         gcnpLfr487tNqM8+o9vUWuiZ3v/OSSBdXeAEJphFl/ODwVCaiOgSmP3Zyt26Ci+kGaf3
         lWYP3WpynexMhfwCdyeprMLXf0r+XArl8lkuitjSstMMyoj/trmQSpqSujvkJ2UlwubK
         WuzdQxjVazVR4l9+Q0Z7qtebUZzOypA2UBrRRezrm3+aKqqxLEDtyHbjNGcLtazbbkPF
         dXXNZ29mth6h9kaIXnCv9KsXXPGjS+aRARuX2rOmCjdCdYtbwRcsJmwhDAPKBG5xYyTs
         6BGQ==
X-Forwarded-Encrypted: i=1; AJvYcCX4u6ZKbHe0Q9dlOY6gJoU6r9+pswHH6X3K+b152PGrqMocMWq4SHPeO0wmk9P/P4DryZ0l6zPEwbE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwD7pXKX4+JUKBKIAoRAiiPvX6H1T1tkzuK3VJkhzyZXUUHMc2h
	foNPH1NJQIPono63eo9Se5FyE6h2J4Q2+b0ZNXai1x8gXIhKvFHDARA/303OfoXBA+Q=
X-Gm-Gg: ATEYQzzeNyqxvPd4P1Ur+Ebr8gWwT0F31vCRvAc3AbJZjn92mWJXMGLmjk04YJ/oS1R
	HdkrVsET4HkyG4S58wzrWYoty99ApFennDiJ7iV+EsQSHNsEne662wfR/j//cJCOxqRosLLnkrc
	hqC+J9P0KNwlJ+/kQ+vyNH9MVMnkKOBckFs8E1De9to4Hc5EkgX+o/cwbUPNOIAtQceaNrcQ8L0
	fIzjctGZk6SD+UKKszgDkMsrPq14H2IlbFgsqAzULW4OahFDEbSHL4r782iNdrmCaPLPRTcBCcT
	BkrL3qr8oFA6lbRdJsrf73kqbhiyMVa/n98xQBiUr3ejA4b7dzUpxVnodEpEhmIheKjEPOIuKW3
	XaoEptmugTUNsZxhQxlX71mBCcioFs/MrKXdi01fTtnyjzzN1BjQtGlgwRZEAO1zGULVPwiEHMX
	tGacAtICcKd13ssN/jSkfnRpLNN6fMPvTz6p10fuDpA6ZuBxo=
X-Received: by 2002:ac8:5fd6:0:b0:4f4:de66:5901 with SMTP id d75a77b69052e-508f46c9079mr149938371cf.5.1773067957796;
        Mon, 09 Mar 2026 07:52:37 -0700 (PDT)
Received: from [127.0.0.1] ([99.196.133.212])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-508f651440dsm65793431cf.5.2026.03.09.07.52.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2026 07:52:36 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Christian Brauner <brauner@kernel.org>, Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Anuj Gupta <anuj20.g@samsung.com>, Kanchan Joshi <joshi.k@samsung.com>, 
 Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, 
 ntfs3@lists.linux.dev, linux-block@vger.kernel.org, nvdimm@lists.linux.dev, 
 linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
In-Reply-To: <20260223132021.292832-1-hch@lst.de>
References: <20260223132021.292832-1-hch@lst.de>
Subject: Re: (subset) support file system generated / verified integrity
 information v4
Message-Id: <177306794392.32482.9164747646721806111.b4-ty@kernel.dk>
Date: Mon, 09 Mar 2026 08:52:23 -0600
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3
X-Rspamd-Queue-Id: E022523AF06
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-32009-lists,linux-xfs=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,linux-xfs@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	NEURAL_HAM(-0.00)[-0.993];
	TAGGED_RCPT(0.00)[linux-xfs];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo,kernel-dk.20230601.gappssmtp.com:dkim,kernel.dk:mid]
X-Rspamd-Action: no action


On Mon, 23 Feb 2026 05:20:00 -0800, Christoph Hellwig wrote:
> this series adds support to generate and verify integrity information
> (aka T10 PI) in the file system, instead of the automatic below the
> covers support that is currently used.
> 
> There two reasons for this:
> 
>   a) to increase the protection enveloped.  Right now this is just a
>      minor step from the bottom of the block layer to the file system,
>      but it is required to support io_uring integrity data passthrough in
>      the file system similar to the currently existing support for block
>      devices, which will follow next.  It also allows the file system to
>      directly see the integrity error and act upon in, e.g. when using
>      RAID either integrated (as in btrfs) or by supporting reading
>      redundant copies through the block layer.
>   b) to make the PI processing more efficient.  This is primarily a
>      concern for reads, where the block layer auto PI has to schedule a
>      work item for each bio, and the file system them has to do it again
>      for bounce buffering.  Additionally the current iomap post-I/O
>      workqueue handling is a lot more efficient by supporting merging and
>      avoiding workqueue scheduling storms.
> 
> [...]

Applied, thanks!

[01/16] block: factor out a bio_integrity_action helper
        commit: 7ea25eaad5ae3a6c837a3df9bdb822194f002565
[02/16] block: factor out a bio_integrity_setup_default helper
        commit: a936655697cd8d1bab2fd5189e2c33dd6356a266
[03/16] block: add a bdev_has_integrity_csum helper
        commit: 7afe93946dff63aa57c6db81f5eb43ac8233364e
[04/16] block: prepare generation / verification helpers for fs usage
        commit: 3f00626832a9f85fc5a04b25898157a6d43cb236
[05/16] block: make max_integrity_io_size public
        commit: 8c56ef10150ed7650cf4105539242c94c156148c
[06/16] block: add fs_bio_integrity helpers
        commit: 0bde8a12b5540572a7fd6d2867bee6de15e4f289
[07/16] block: pass a maxlen argument to bio_iov_iter_bounce
        commit: a9aa6045abde87b94168c3ba034b953417e27272

Best regards,
-- 
Jens Axboe




