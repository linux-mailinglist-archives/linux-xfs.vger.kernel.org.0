Return-Path: <linux-xfs+bounces-5197-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1037787ED9E
	for <lists+linux-xfs@lfdr.de>; Mon, 18 Mar 2024 17:35:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 074BC1C2172A
	for <lists+linux-xfs@lfdr.de>; Mon, 18 Mar 2024 16:35:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40CF154794;
	Mon, 18 Mar 2024 16:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="STFrEHOh"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC3FD25745;
	Mon, 18 Mar 2024 16:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710779715; cv=none; b=Li+e+1eSWvfXbDSN9zsozZqyrHFRLqJvhIvXGH7qgOt3ANfk2/BbliyrpgLTGKhmfxq2t+/UBLvqJ3jEIO1m3NpCzklf0CysRmMaQNC9PXeQIr0H07zmorBXgIMA4FKLBU6psNKbmVyokEUJMGCNWopTRsyjXgB1Llq3g6TlyHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710779715; c=relaxed/simple;
	bh=ryLkEWzLxnT2FaDjkiDt1GL9RabpKJpDIqG7E9rjqxI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Xg3KF0z9APNsmKBeRgizoc0wu8Gg7gozGk9BltJSClWHAls04fcSJHvYiGzs+KI0Mj0QFNnmFeICZIZN2CVIigz+3AGzX56lVYe5OWuCyhyuy+Db4nqEd214/h9sEpXhDtM7sfJ1dbZM2ZY4qag7WjWqoRkGHJyyMSLqkxu4sMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=STFrEHOh; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48050C433F1;
	Mon, 18 Mar 2024 16:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710779714;
	bh=ryLkEWzLxnT2FaDjkiDt1GL9RabpKJpDIqG7E9rjqxI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=STFrEHOhAlB2jd5os10vg002ldDs69KPA8peRQsIEsSMqdAnqCSvcY6nbbVJaT5MI
	 TECthM9u6W6rgnDKQo4Xlo64PgoRORjNJiccUjwbsKp6ALeoLvqh2+gORUjjtX9kOi
	 6H0T+Pq9pYyUlu0/jB93+W+5JAw2u/pnahadNfPWDncH04Yc0MF9sc9Z5Av60c6FvB
	 QM1J60jV2e9nu1iRnSrpkH5X7apYziQXxIqYhWhGL+X5Vd/m3rKRtBAHbFZW4SZ8DM
	 tbIQVc9QSh6+xgMl2wXRN5QPsdFRJkjEQL3RgYrDKWDQ4DjuH1dljq562Kf0Jz0iOo
	 MOd5/FDKdJgWg==
Date: Mon, 18 Mar 2024 09:35:12 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@redhat.com, Mark Tinguely <tinguely@sgi.com>,
	Allison Henderson <allison.henderson@oracle.com>,
	Christoph Hellwig <hch@lst.de>, Dave Chinner <dchinner@redhat.com>,
	linux-fsdevel@vger.kernel.org, fsverity@lists.linux.dev,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCHSET v5.3] fs-verity support for XFS
Message-ID: <20240318163512.GB1185@sol.localdomain>
References: <20240317161954.GC1927156@frogsfrogsfrogs>
 <171069245829.2684506.10682056181611490828.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171069245829.2684506.10682056181611490828.stgit@frogsfrogsfrogs>

On Sun, Mar 17, 2024 at 09:22:52AM -0700, Darrick J. Wong wrote:
> Hi all,
> 
> From Darrick J. Wong:
> 
> This v5.3 patchset builds upon v5.2 of Andrey's patchset to implement
> fsverity for XFS.

Is this ready for me to review, or is my feedback on v5 still being worked on?
From a quick glance, not everything from my feedback has been addressed.

- Eric

