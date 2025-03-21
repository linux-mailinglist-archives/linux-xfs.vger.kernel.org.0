Return-Path: <linux-xfs+bounces-20986-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 28F4CA6B434
	for <lists+linux-xfs@lfdr.de>; Fri, 21 Mar 2025 06:58:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 13CC03AEE20
	for <lists+linux-xfs@lfdr.de>; Fri, 21 Mar 2025 05:57:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21D591E9B02;
	Fri, 21 Mar 2025 05:58:03 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F1B033F6
	for <linux-xfs@vger.kernel.org>; Fri, 21 Mar 2025 05:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742536683; cv=none; b=g18XPw+9AosQCwBU0GU9PIkiB56t7yCuA6rYVRGUZwkZ5aAeFcBZ5eACZYjMjfUCAFaAvWXdFgtVzL6yIgUH7Wn5Pgy1Q8l9cf5gWbfWQ6XPya4/vFC9G84JkSQIQPsSu432ftKosQQgv8QTl/uqzGJcUhsS8YgTVo18IbpDmiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742536683; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h9tm0+9jHf0BL6Do3kD8eOqyRAOFupV2HACVqODOPyv5mdfBF4ZheAM1lv3DXbB8HMU+BXgIKldnK5lfSqKcNTq+yR2abco00DMggq3rXZN+SCDJ0phbBibUvygsZ1/X4sqrBZr+XD8g+TUUdJEBSCmDmhBg7FozU5pl73pG5QI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 210B768AA6; Fri, 21 Mar 2025 06:57:56 +0100 (CET)
Date: Fri, 21 Mar 2025 06:57:55 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] design: document the revisions to the realtime
 rmap formats
Message-ID: <20250321055755.GA2893@lst.de>
References: <20250320162836.GV89034@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250320162836.GV89034@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


