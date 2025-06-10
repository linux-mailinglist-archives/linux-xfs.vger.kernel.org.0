Return-Path: <linux-xfs+bounces-22956-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F45FAD2C28
	for <lists+linux-xfs@lfdr.de>; Tue, 10 Jun 2025 05:37:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F2F053B0822
	for <lists+linux-xfs@lfdr.de>; Tue, 10 Jun 2025 03:36:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB8A921A43C;
	Tue, 10 Jun 2025 03:36:58 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15A352110;
	Tue, 10 Jun 2025 03:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749526618; cv=none; b=WhTZ4Fh9nqEeGs/zPJ+iH7ei7s7XYNWEusxZKKPRBMqJHw38M4MQX9DXRurQYjdQXaBk9QxQcdnCEHJlS4qiyiApGmJgnoBaUIMVFU9W5fpa6vHRbRR8Mo5srjjIWUdu2MXkNcZUUkutve0grJaZGb62ZuYHE9/qjrnMuVPSkHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749526618; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qgL7oooDLUPx80XD4vupFJpJfK0z5prBREEXFdrJLATqWgT04+C8e5DMycUA2EFLzTX7Sq1Nv1Ihz2ZSjfaUHY28itEEIZUvjfBa7xaYKIV7z3F81o6h2dychViV8iOUu1WiHEGWB7yTQG9XgcAKv5I3WSRvGgyFuCDekxujtYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3186468C4E; Tue, 10 Jun 2025 05:36:50 +0200 (CEST)
Date: Tue, 10 Jun 2025 05:36:50 +0200
From: hch <hch@lst.de>
To: Hans Holmberg <Hans.Holmberg@wdc.com>
Cc: Zorro Lang <zlang@kernel.org>, hch <hch@lst.de>,
	"tytso@mit.edu" <tytso@mit.edu>,
	"djwong@kernel.org" <djwong@kernel.org>,
	"fstests@vger.kernel.org" <fstests@vger.kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH 1/2] xfs: add mount test for read only rt devices
Message-ID: <20250610033649.GA23813@lst.de>
References: <20250609110307.17455-1-hans.holmberg@wdc.com> <20250609110307.17455-2-hans.holmberg@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250609110307.17455-2-hans.holmberg@wdc.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


