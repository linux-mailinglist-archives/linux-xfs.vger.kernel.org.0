Return-Path: <linux-xfs+bounces-15187-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F52C9BFF29
	for <lists+linux-xfs@lfdr.de>; Thu,  7 Nov 2024 08:33:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6110C1C2155D
	for <lists+linux-xfs@lfdr.de>; Thu,  7 Nov 2024 07:33:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69E851922CC;
	Thu,  7 Nov 2024 07:33:38 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09DA114293
	for <linux-xfs@vger.kernel.org>; Thu,  7 Nov 2024 07:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730964818; cv=none; b=AxCW1efE7f+Hj0H/Ndqs6B4HzPdPExXEtBH+TRCgPFOb1kV8d5OciY7GzrXooCF3ZAXObWwxmRssDIokkDCpG7+6M7UxL5FT+K0GtJt2bT/VdJFBxmYEbGVd8WfidFS596j7GO2b9PI9VTNcLIEtrja5eXSPWbO433JM5GOvajA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730964818; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aAJf8s9SRpKhtVg+3tCQoKxMCrwHptYto8sv3jb3eF3F5GlWuG6C5vQnepDpJshUfdl/Zem5v7n73P33Tbxwcq354xSEl7BKMUiutWDR+hriB0VuLhehrCD03sxYcxeZztLdd58tI5PwJfns0HKbRBcpStcItMQ1VErTa78wOBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 337B5227AA8; Thu,  7 Nov 2024 08:33:34 +0100 (CET)
Date: Thu, 7 Nov 2024 08:33:33 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 3/4] design: document metadata directory tree quota
 changes
Message-ID: <20241107073333.GG4408@lst.de>
References: <173092059696.2883258.7093773656482973762.stgit@frogsfrogsfrogs> <173092059744.2883258.7281058243421376662.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173092059744.2883258.7281058243421376662.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


