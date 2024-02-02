Return-Path: <linux-xfs+bounces-3410-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F25B847504
	for <lists+linux-xfs@lfdr.de>; Fri,  2 Feb 2024 17:38:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B20291C26942
	for <lists+linux-xfs@lfdr.de>; Fri,  2 Feb 2024 16:38:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8413514A095;
	Fri,  2 Feb 2024 16:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VGtjuQEj"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 452CB14A08E
	for <linux-xfs@vger.kernel.org>; Fri,  2 Feb 2024 16:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706891864; cv=none; b=r/DMHXlUZ+WsPmbZrkULozbqmEJG6cyleOr9IxT4AU24MpLm7leM45vNH4jjWbdVSFjV3WYsicH4siUXSu210A6bhl2EPSL1MQgIYSbNUlqNUyMIbPL/DCS8r9OwPlmcIp7J6D6WlWllcyFVkDDvyCmr0Oo049Jjx5P5XCFI3TM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706891864; c=relaxed/simple;
	bh=l9DV2O7+mB8F/AW8QSG6FOFaWyVEencNmp1AYS9YD94=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E8S0AoEGpH1q58FKA2xpzwnSYu235lCtb3Br1FOl+jcaETmjIPpSJQii37SNO97nBKeMB8uFkfvZirvB3nClSoQv1mwUgzXajshf6LWtFDX4M6nygxECK95ePoeqmQ6VrM/N4LzsjKdxlV5tD78m8hPBGYSoc4xrXLCPG5o5+UQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VGtjuQEj; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9EBBC433F1;
	Fri,  2 Feb 2024 16:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706891863;
	bh=l9DV2O7+mB8F/AW8QSG6FOFaWyVEencNmp1AYS9YD94=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VGtjuQEjEtFp4CpAJymRKW0xOFeSSw1rj1QiA4sBho6FZ2PsgkmovKcHEtzjDXNm/
	 MpiwFR8KSLS5DW5HWsgmF8jNzdKdO10+8accxDR28jxUHJpN17s7HUkaWSvrvI0jWg
	 onze2SFRJTluNVwLzoCOr65CYNqBwPdH0DwDd9TYqQhvuofHprdZ8IVr2kadMONa6c
	 IeWL7PsUL2GlgeOOy+xu7f+AIlxf4iOCnkuxT9xuiM7rTbGVVuQu3xJBZTm/sTzUfg
	 91wkaaEJCyILhfeYPb+Kmsk6yNZSKZLegIQZ5jK1RBk0k4uI1ne/j+ACm0GTaKedEE
	 Ou79QrGdL6mxw==
Date: Fri, 2 Feb 2024 08:37:43 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/27] xfs: make fake file forks explicit
Message-ID: <20240202163743.GI616564@frogsfrogsfrogs>
References: <170681334718.1605438.17032954797722239513.stgit@frogsfrogsfrogs>
 <170681334995.1605438.15565130234166131675.stgit@frogsfrogsfrogs>
 <ZbyKvrEQgNvrz-iN@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZbyKvrEQgNvrz-iN@infradead.org>

On Thu, Feb 01, 2024 at 10:25:02PM -0800, Christoph Hellwig wrote:
> Looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!  I'm going to s/fake/staging/ on the subject line.

--D

