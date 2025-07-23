Return-Path: <linux-xfs+bounces-24179-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D946BB0EA24
	for <lists+linux-xfs@lfdr.de>; Wed, 23 Jul 2025 07:42:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1ADF15625FC
	for <lists+linux-xfs@lfdr.de>; Wed, 23 Jul 2025 05:42:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1905523D287;
	Wed, 23 Jul 2025 05:42:07 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C7F6F9E8;
	Wed, 23 Jul 2025 05:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753249326; cv=none; b=EwGhfgC6GuJcivg0dpLxqc3oNSmRaxHEBrbP4KlmyKYIHhaoEq87s1H4Gt8I+9autQKHrfMAONfRZmuF1ljOnT/KqBRviensu4z1d53yJgFbK8y+HPEeKSbOF3unPGyQoHaZA17lZ0EaCAmg4ZOI5oj0qiW+dfmrruuMdGtKzD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753249326; c=relaxed/simple;
	bh=2uBmacd6RGywj2DsFLPLnn/etS/SLOsr4DP//+Sg09k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rawcem2wjELYAvwrQ3mBb99X7ci+yt4z4TDA7jaRlhzl3itLNrlOh9zVm51HlW07oLnb8QFXd2aD0co8jdqa2i0+UZLxRFb5tuvrpYjtmjpp0nIaTHNElPBV5G5vs/WV2HPFaDGoZYX4fm0V8qonVSpzF8TpxoA666xASWFYTn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 39A3E67373; Wed, 23 Jul 2025 07:41:59 +0200 (CEST)
Date: Wed, 23 Jul 2025 07:41:58 +0200
From: Christoph Hellwig <hch@lst.de>
To: Steven Rostedt <rostedt@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Carlos Maiolino <cem@kernel.org>, Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [PATCH 0/4] xfs: more unused events from linux-next
Message-ID: <20250723054158.GA18464@lst.de>
References: <20250722201907.886429445@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250722201907.886429445@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

The entire series looks good to me:

Reviewed-by: Christoph Hellwig <hch@lst.de>


