Return-Path: <linux-xfs+bounces-4414-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2311F86B364
	for <lists+linux-xfs@lfdr.de>; Wed, 28 Feb 2024 16:41:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D3D961F2A47C
	for <lists+linux-xfs@lfdr.de>; Wed, 28 Feb 2024 15:41:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7076815DBB5;
	Wed, 28 Feb 2024 15:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="uWe6SaHK"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E50B715D5CF;
	Wed, 28 Feb 2024 15:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709134831; cv=none; b=MnOCGQTNPqBfqq1dc/Y/RmGFnxfRJztfX7w6ccTGCXKmWFi1d/EGXJ1Cjl9WUpT8PRc7+e0cfCdLlmDqv0NXbS95ftdpp3mboGc2S3usm9qeEKRsaiUC8PM7Llw63Lu75fwyY36cgkiEPSOy328EEfJrLygejdeKsNeZ/djKNW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709134831; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MEQMPd8e0A9pV0+pDlw7gNXB7al1OJdXMpTaNsjL+Y5JSTLYbakYuhofTz0NaoxHb/MIHG/2jm2vkRDsd7MLZGEcjwx6qJrYB4xu94E752AhSU0C589LMn4PAIkEmFIek2Oi6f2h9TAq4lXqhuoFPRQ+SdHigT0RANvk0mVNLBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=uWe6SaHK; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=uWe6SaHKAGUjIS94diB3z5psvl
	1B4HRZioAVuW/FpvjuybXlQEGEoEsiS8CkoyvIOdE7hg8/+fDNOAt7ecgXDaxgwLNNlem6qd58LKG
	Rhh7x4F40e0PcOq4igcGhVusoxpe3lp/iMU5fVRWoSn3FEp/zv6Ptwv7uNeVbGqnggNcK5yqk/apL
	xxDwJxmVj+kJpmhNB5hUpMFFYbMW9L7ywf7VdYG9eAGEcHY5FXRr1eApprnXi0KfvIjOB8n9zF2H3
	RyuZczFmLDInvh9LKPyRDlfJEQ9qxeZZtfezLb0SEVb5UZpIbjKyeyklu/OvaVRMU4Dmy6fkG8wur
	0uB/xBbQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rfM2n-00000009vru-22gd;
	Wed, 28 Feb 2024 15:40:29 +0000
Date: Wed, 28 Feb 2024 07:40:29 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 01/14] vfs: export remap and write check helpers
Message-ID: <Zd9T7at-pDQBvRbj@infradead.org>
References: <170900011604.938268.9876750689883987904.stgit@frogsfrogsfrogs>
 <170900011656.938268.17556267059591974055.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170900011656.938268.17556267059591974055.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

