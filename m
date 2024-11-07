Return-Path: <linux-xfs+bounces-15188-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 94B739BFF2D
	for <lists+linux-xfs@lfdr.de>; Thu,  7 Nov 2024 08:34:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C76A21C24106
	for <lists+linux-xfs@lfdr.de>; Thu,  7 Nov 2024 07:34:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3114194AD5;
	Thu,  7 Nov 2024 07:34:01 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 236FE194C7A
	for <linux-xfs@vger.kernel.org>; Thu,  7 Nov 2024 07:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730964841; cv=none; b=QFC277iU7ypeU/2zEq2/XS5cRWlFukA0dMYaO8bY1Et04hUxSlhRT0XyUkaOGgoeB8dI2NmyllGik7Gt/08R3741xZmqPhutJDBgu98AwQUZI2RbDJpy00m/+DYKumPUqvXExKadUWfjHWxTjCuGAI0YiiOqG6B3uKUy5Q5yOvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730964841; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o7hFvJXozl7HR+gvEJ4ZoMwGXr0D/Z+F63YsheRZYXT8PuistdJnwENU6dZkUf73sqKRNhnQCQP/3HGDDBw7ZnlxuYGTHF9ra5pz1IlybCAYIBjwHL/DL6zp4TsIsyg/VEppNovWyhHOvTbN2UnIpKGPIOq8cn5jijo7JhWSE74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 843EA227AA8; Thu,  7 Nov 2024 08:33:57 +0100 (CET)
Date: Thu, 7 Nov 2024 08:33:56 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 4/4] design: update metadump v2 format to reflect rt
 dumps
Message-ID: <20241107073356.GH4408@lst.de>
References: <173092059696.2883258.7093773656482973762.stgit@frogsfrogsfrogs> <173092059759.2883258.10101323739690762194.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173092059759.2883258.10101323739690762194.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


