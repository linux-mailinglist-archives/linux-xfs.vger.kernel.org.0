Return-Path: <linux-xfs+bounces-11379-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A167894AE51
	for <lists+linux-xfs@lfdr.de>; Wed,  7 Aug 2024 18:43:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 59E7B1F24653
	for <lists+linux-xfs@lfdr.de>; Wed,  7 Aug 2024 16:43:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C47E5137776;
	Wed,  7 Aug 2024 16:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QEz+XPmK"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F9ED5BAF0;
	Wed,  7 Aug 2024 16:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723048991; cv=none; b=Lika9YuXhQDj9EPJwTY+LaoU9XheyIjUudTdHs/6OYIxLIYX7gJvQ1BJGR/SCPkzqNsHbcb30RzS+XzmfoYrivTEJsikdUhdP4V6Rn9IjiH1zi5rNplEHC2QXOxA/MmATjKvs2poIpwtK4I6dq8FkAawo3qWnfv1ogHigblUWBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723048991; c=relaxed/simple;
	bh=n1Pd3oR8KNQpzL8XsP7ZLOgfQSAyvQjo8vMjZeOO9O0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E3XtNLn6uIrELCZouRH2L6fbn7qhj5+c+pgNQt9bkAX3j8GIg689w9Zuss9xEr7qmOpU0y6Py04ToUUWCZ/oub2Pt4kOqyvkk5xNB7btvrGFrRzksMpY8WCAK0Kiza8G701u3JNBo0zqtO0xzfXTx3Oj9MhgfdADcFQDIyNk9nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QEz+XPmK; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE267C32781;
	Wed,  7 Aug 2024 16:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723048991;
	bh=n1Pd3oR8KNQpzL8XsP7ZLOgfQSAyvQjo8vMjZeOO9O0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QEz+XPmKILUGKHt44O+qzD51YeyLC+RzkHuCpO8bA4kAdClykUWCF/E3sEX3NjC77
	 1CemyMWtbxmdpWx3gd9Er48wFzMfnmf0PwgCPZ7vpp1nUE1IapIultDEs48cs+QUz8
	 0hNY2Aj2WQYcS0aGcs/Cih9xyq83yvndwDvhRguYjfpG37OhtLhhGMkgN2yrMMo4GZ
	 v8UGqTJ4wMbwcMTXNnYmBFaJAFBkLzEATW5+k5Qvm5/+XTl0jgBrSdGlKrXEebJ6Fa
	 HTfTDsbmU5UNyIwPW6eCpncNtKBP9q3yCQQhmjCG+wKzSyQqUYS29zrKZA2pkRNYsP
	 fQEm9TMOtapZQ==
Date: Wed, 7 Aug 2024 09:43:10 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>,
	"@magnolia.djwong.org"@web.codeaurora.org
Cc: cem@kernel.org, Dave Chinner <dchinner@redhat.com>,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/7] xfs_db: improve getting and setting extended
 attributes
Message-ID: <20240807164310.GK6051@frogsfrogsfrogs>
References: <172296825181.3193059.14803487307894313362.stgit@frogsfrogsfrogs>
 <172296825234.3193059.7895487674250550849.stgit@frogsfrogsfrogs>
 <20240807161004.GB9745@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240807161004.GB9745@lst.de>

On Wed, Aug 07, 2024 at 06:10:04PM +0200, Christoph Hellwig wrote:
> On Tue, Aug 06, 2024 at 11:20:06AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Add an attr_get command to retrieve the value of an xattr from a file;
> > and extend the attr_set command to allow passing of string values.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> Missing newline here again (not going to say this again if it shows
> up on more patches..)

Yeah, I don't know why that happened.  Something went wrong in my text
processing scripts.

--D

