Return-Path: <linux-xfs+bounces-6021-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 887A6891251
	for <lists+linux-xfs@lfdr.de>; Fri, 29 Mar 2024 05:10:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B68D31C23642
	for <lists+linux-xfs@lfdr.de>; Fri, 29 Mar 2024 04:10:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B97439FFD;
	Fri, 29 Mar 2024 04:10:49 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58ADD1DA4D
	for <linux-xfs@vger.kernel.org>; Fri, 29 Mar 2024 04:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711685449; cv=none; b=ec5Afchp4Zof1xAFsh0x/GOahqeMAajK2gKPvA/jRiW1KxzwIi/Frvjx5oQWu6TgbMhl/2HyLrhvCm5ohJy730INQJwIHnGhEAHMklwGT4COZoDzoeFdvOMgFULYjSSgKD7QEg2jLppakmoL6C/Q0LPryBztpYjeKm68HN1whmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711685449; c=relaxed/simple;
	bh=v9Dh9SJx6v1aNpsr+80u1V0SsoK58OhXK2LbaHxNVO4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U9WXBvIAVYr6Xxjm2c64/onYwu4EjU5EouhQBy+lt5sGhAyC0HpiAYqKNwQ+6fsCExcElR3ghN/wCpbW55w35iXeWCejb7z7U+BtLiMlihRPmf/xHd8ybegVpK7+pk2OiiuXLJpeGf+ceJ1mZfEkgYCMiuKpnPvt9mDJuEUurH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9CA7068B05; Fri, 29 Mar 2024 05:10:43 +0100 (CET)
Date: Fri, 29 Mar 2024 05:10:43 +0100
From: Christoph Hellwig <hch@lst.de>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/6] xfs: simplify iext overflow checking and upgrade
Message-ID: <20240329041043.GA18807@lst.de>
References: <20240328070256.2918605-1-hch@lst.de> <20240328070256.2918605-5-hch@lst.de> <ZgXpewa/XiT7w4wY@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZgXpewa/XiT7w4wY@dread.disaster.area>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Mar 29, 2024 at 09:04:43AM +1100, Dave Chinner wrote:
> IIUC, testing the error tag twice won't always give the same result.

Yeah.

> I think this will be more reliable, and it self-documents the error
> injection case better:

Yes, now that we have the opportunity it probably makes sense to only test
it once.


