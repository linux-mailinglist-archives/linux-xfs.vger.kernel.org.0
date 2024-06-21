Return-Path: <linux-xfs+bounces-9767-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 97CDB912CF8
	for <lists+linux-xfs@lfdr.de>; Fri, 21 Jun 2024 20:07:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4E12F1F2531B
	for <lists+linux-xfs@lfdr.de>; Fri, 21 Jun 2024 18:07:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAB4D178CFD;
	Fri, 21 Jun 2024 18:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jbQhDrJu"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B67254FB5
	for <linux-xfs@vger.kernel.org>; Fri, 21 Jun 2024 18:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718993253; cv=none; b=h0eqwk4Z0rssEpeiT8/oe5GA4I5hG7eFkLoJO+affUjF/hH6JymWaAp6fvMmeDeUmxiKV5krAeQ7RA7PONGHTenJW/ijPk/zbYAaE/6QUdagL7e8jg2mDne3q6r8PjxdhDMx8wDpON/IMKqwAraEJofKCfW0zKiVqw8VP7mDuSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718993253; c=relaxed/simple;
	bh=7nO16Npb3ZPbB96xXaEbsCBlsvmljubtM3ARAZoLi7E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c+0WBuaKI+gwSqPbpEvK20EYv8/y/Z188Mmk2kM6WdRbG+EXFy3GJnC6ppldALhvvg6xZhFVfYA3nmu4O19/4F9wsRdJ0bqC4NojDYpvyzlcJDH2+gKx7t91ZSrpsCyqGyYLZ/fEiJpDdEja4JlXARyswtMelsaPM9eDzGR7FXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jbQhDrJu; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A635C32781;
	Fri, 21 Jun 2024 18:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718993252;
	bh=7nO16Npb3ZPbB96xXaEbsCBlsvmljubtM3ARAZoLi7E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jbQhDrJuudk6Loe9sIlpyC4ll9EmtnZ1JT/KeQzmwdgGiTwQxCPUMYtRxdX2Bnkix
	 yJbfQq0NxY+AGs41TWcmQAQ6AHGQHQpPRdhavXJeH94RPW/0BOi/g3I54qUUBaBSWa
	 2p8QcuUUza6mQuyOjvXRNtkwsnXDpdDB6L4mXZkOsXULc6mArIbF0i82E8iFvV0qvy
	 SgYObfmW3CX7pkJ+APDxMYWHBfYmYGdT/CHez9ZSCsf7Plv82w1wLgHGJBrySuy+hX
	 csl6KUNnxIS98d+ihGz+8CnKTH4JP44ty/qfahQ49zyfZUb4c3F3Xw3I0L9tj4kN9w
	 UTcSxybX4fLaw==
Date: Fri, 21 Jun 2024 11:07:31 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 2/9] xfs: prepare rmap btree tracepoints for widening
Message-ID: <20240621180731.GI3058325@frogsfrogsfrogs>
References: <171892419209.3184396.10441735798864910501.stgit@frogsfrogsfrogs>
 <171892419266.3184396.5637689260987491987.stgit@frogsfrogsfrogs>
 <ZnUGbRS3bTMgo9Q7@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZnUGbRS3bTMgo9Q7@infradead.org>

On Thu, Jun 20, 2024 at 09:49:49PM -0700, Christoph Hellwig wrote:
> If find the widening term a bit odd here and would have said:
> 
> "xfs: pass btree cursors to rmap btree tracepoints"
> 
> But except for that this looks good to me:

Done.  I think the subject line is left over from the really old days
when there was one rmap btree for the entire rt device and we actually
had to handle 64-bit values.

> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

--D

