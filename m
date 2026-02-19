Return-Path: <linux-xfs+bounces-31111-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GCoPGOM7l2l2vwIAu9opvQ
	(envelope-from <linux-xfs+bounces-31111-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Thu, 19 Feb 2026 17:35:47 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id B67C7160B8E
	for <lists+linux-xfs@lfdr.de>; Thu, 19 Feb 2026 17:35:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6CBE730166E1
	for <lists+linux-xfs@lfdr.de>; Thu, 19 Feb 2026 16:35:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95F1821A444;
	Thu, 19 Feb 2026 16:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gZd+YGby"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7142C3EBF2E;
	Thu, 19 Feb 2026 16:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771518944; cv=none; b=JBzpLAFqjm9Wqiv7CxufEh1isuCqN3mdfgyz2hD7d7sEv1Uk3m3/hqg36AbQq1KTc4mluSvLw7DgE6bVh+ruUicxmZfECvXgQD+KNJFgDcLmIinjh9OHsqfG5mAnFd/2e49MlLvciIfIni5fJbIIcCaE4bKJVwwlkCyjkhwfPF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771518944; c=relaxed/simple;
	bh=YPrvkVaJt23Q927cNV1urRTMpZUQ2dGUVLzgjku0Da4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Dd8UKmo7mYtDJEG/lpsO9mpsDga5i9KjofemkVOsRec4BplIgYDkqir59t4vmMvTbB9MssXHwaXYEZN8pgEj/8hrFCzuYyaHZ6WGPk2VVNNQ8hsK7GXeH2xPyln7EoyeA7zwOTOOUkD+L0JmRkHMlM7O5Fz+W5agmao5phbHT5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gZd+YGby; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D51CC4CEF7;
	Thu, 19 Feb 2026 16:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771518944;
	bh=YPrvkVaJt23Q927cNV1urRTMpZUQ2dGUVLzgjku0Da4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gZd+YGby7+Qt3UW+rFEIzdo29MnSvcfVn7EdaZvXGEhynrbyqQOmRyKjP6yaFcLL/
	 2dcipxUivBPfzmYj6o/Y1lZg7ZzsTJO96SMZH64luYaYnSTZ01rF0SIaLQM0sfMaH0
	 zng+DDGj24xXr/G8aHOLogJ+MNt0w6PeSfjfZbQtZk0G+alUbYDws9Q/KUl+FE2GAk
	 1Z+GbE/OeU/WKZY2kGxfj/JRSdwHWFk5yXR5X4cAF+sKb3ElGgWlMsl2cMiYAnTW0J
	 Vzg2g8avKVUYBjKfzPBRxVq90q2NKMwriAJ2ksosOg9cIVHtbLBo2X3KV6JhcBl6m+
	 VqLSCVYlAfrrQ==
Date: Thu, 19 Feb 2026 17:35:38 +0100
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>, 
	"Nirjhar Roy (IBM)" <nirjhar@linux.ibm.com>, hch@infradead.org, david@fromorbit.com, zlang@kernel.org, 
	linux-xfs@vger.kernel.org, fstests@vger.kernel.org, ritesh.list@gmail.com, 
	ojaswin@linux.ibm.com, hsiangkao@linux.alibaba.com
Subject: Re: [PATCH v1 0/7] Add multi rtgroup grow and shrink tests
Message-ID: <aZc7pCdmIH3num0Q@nidhogg.toxiclabs.cc>
References: <20260219055737.769860-1-nirjhar@linux.ibm.com>
 <cover.1771425357.git.nirjhar.roy.lists@gmail.com>
 <aZcIEd9DY_bQGJ9L@nidhogg.toxiclabs.cc>
 <dd1b584b-987c-4dce-b84c-c9fe74687e95@gmail.com>
 <aZci9Fz8NgXhrUSa@nidhogg.toxiclabs.cc>
 <20260219154936.GF6490@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260219154936.GF6490@frogsfrogsfrogs>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-31111-lists,linux-xfs=lfdr.de];
	FREEMAIL_CC(0.00)[gmail.com,linux.ibm.com,infradead.org,fromorbit.com,kernel.org,vger.kernel.org,linux.alibaba.com];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[cem@kernel.org,linux-xfs@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-xfs];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,nidhogg.toxiclabs.cc:mid]
X-Rspamd-Queue-Id: B67C7160B8E
X-Rspamd-Action: no action

On Thu, Feb 19, 2026 at 07:49:36AM -0800, Darrick J. Wong wrote:
> On Thu, Feb 19, 2026 at 03:55:02PM +0100, Carlos Maiolino wrote:
> > On Thu, Feb 19, 2026 at 08:10:50PM +0530, Nirjhar Roy (IBM) wrote:
> > > 
> > > On 2/19/26 18:25, Carlos Maiolino wrote:
> > > > On Thu, Feb 19, 2026 at 06:10:48AM +0000, Nirjhar Roy (IBM) wrote:
> > > > > From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
> > > > > 
> > > > > This series adds several tests to validate the XFS realtime fs growth and
> > > > > shrink functionality.
> > > > > It begins with the introduction of some preconditions and helper
> > > > > functions, then some tests that validate realtime group growth, followed
> > > > > by realtime group shrink/removal tests and ends with a test that
> > > > > validates both growth and shrink functionality together.
> > > > > Individual patches have the details.
> > > > Please don't send new versions in reply to the old one, it just make
> > > > hard to pull patches from the list. b4 usually doesn't handle it
> > > > gracefully.
> > > 
> > > This entire series is new i.e, the kernel changes, fstests and the xfsprogs
> > > changes. Can you please explain as to what do you mean by the old version?
> > > Which old are version are you referring to?
> > 
> > Sure, I said 'old version' but the same applies to sending them in reply
> > to other series/patches.
> > 
> > This series was sent:
> > 
> > In-Reply-To: <20260219055737.769860-1-nirjhar@linux.ibm.com>
> > 
> > which is:
> > 
> > Subject: xfs: Add support for multi rtgroup shrink+removal
> > 
> > 
> > In better wording, please don't nest series under other series/patches,
> > or things like that. It works in some point cases, but in general it
> > just makes my life difficult to pull them from the list.
> 
> Pull requests, perhaps?
> 
> Or is the problem here that you're using b4/korgalore/etc to download
> patchmails so that you can read them outside of a MUA?

Yup, b4. Andrey mentioned there is a way to break threads, but that bit
me once pulling weird stuff.

> 
> ((Again, I'll express a wish that people push their branches to
> git.kernel.org and send a link in the cover letter; that's much easier
> for me to pull and examine than reading emails or prying individual
> maybe-MTA-corrupted emails out of mutt into applyable form...))
> 
> --D
> 
> > 
> > > 
> > > --NR
> > > 
> > > > 
> > > > > Nirjhar Roy (IBM) (7):
> > > > >    xfs: Introduce _require_realtime_xfs_{shrink,grow} pre-condition
> > > > >    xfs: Introduce helpers to count the number of bitmap and summary
> > > > >      inodes
> > > > >    xfs: Add realtime group grow tests
> > > > >    xfs: Add multi rt group grow + shutdown + recovery tests
> > > > >    xfs: Add realtime group shrink tests
> > > > >    xfs: Add multi rt group shrink + shutdown + recovery tests
> > > > >    xfs: Add parallel back to back grow/shrink tests
> > > > > 
> > > > >   common/xfs        |  65 +++++++++++++++-
> > > > >   tests/xfs/333     |  95 +++++++++++++++++++++++
> > > > >   tests/xfs/333.out |   5 ++
> > > > >   tests/xfs/539     | 190 ++++++++++++++++++++++++++++++++++++++++++++++
> > > > >   tests/xfs/539.out |  19 +++++
> > > > >   tests/xfs/611     |  97 +++++++++++++++++++++++
> > > > >   tests/xfs/611.out |   5 ++
> > > > >   tests/xfs/654     |  90 ++++++++++++++++++++++
> > > > >   tests/xfs/654.out |   5 ++
> > > > >   tests/xfs/655     | 151 ++++++++++++++++++++++++++++++++++++
> > > > >   tests/xfs/655.out |  13 ++++
> > > > >   11 files changed, 734 insertions(+), 1 deletion(-)
> > > > >   create mode 100755 tests/xfs/333
> > > > >   create mode 100644 tests/xfs/333.out
> > > > >   create mode 100755 tests/xfs/539
> > > > >   create mode 100644 tests/xfs/539.out
> > > > >   create mode 100755 tests/xfs/611
> > > > >   create mode 100644 tests/xfs/611.out
> > > > >   create mode 100755 tests/xfs/654
> > > > >   create mode 100644 tests/xfs/654.out
> > > > >   create mode 100755 tests/xfs/655
> > > > >   create mode 100644 tests/xfs/655.out
> > > > > 
> > > > > -- 
> > > > > 2.34.1
> > > > > 
> > > > > 
> > > -- 
> > > Nirjhar Roy
> > > Linux Kernel Developer
> > > IBM, Bangalore
> > > 
> > 
> 

