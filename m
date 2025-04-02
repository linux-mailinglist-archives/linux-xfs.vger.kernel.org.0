Return-Path: <linux-xfs+bounces-21154-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D064A790AC
	for <lists+linux-xfs@lfdr.de>; Wed,  2 Apr 2025 16:06:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 597E73A71D9
	for <lists+linux-xfs@lfdr.de>; Wed,  2 Apr 2025 14:01:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B3B617BA9;
	Wed,  2 Apr 2025 14:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="b3uOIkjv"
X-Original-To: linux-xfs@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8C741096F
	for <linux-xfs@vger.kernel.org>; Wed,  2 Apr 2025 14:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743602472; cv=none; b=gDUufH/4MFX3q87S6hJODW9m7yk5GwakC7PNqJ7RkpkzZ70x2zoQFTH8rMWFYolfOmqxGskSWYvitVQIjcwHAgMTaECf4YhAvimJjbwnlPi82S1HCcQEtPcjClnrtb7JJf7waXtcLpLD2MzN+LgGp9UQt1tjqrOv2pjpV6g4zvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743602472; c=relaxed/simple;
	bh=qY3yZ5QUWrP/1C7VW+88fXuEgS5kBQMlyL6vev95evU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Dj7b9+7Y0M4fY3kgUGleUi9+kBh3IvhgD4g+gs7QRShtdSgJB0z1JWplKqfrgjpTkIGpmgNU+77gjNbYdIhCF9nkh89w7+n54CfTFvRjrzAuH26rDpbp1lV7CTHXBtcXTd08M2tzPAwfa4igUZ6KzPw+aBlNCafnixzUVgMTBJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=b3uOIkjv; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743602468;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WbXcDLWRTl9fAG+lzPvP2crtpKyf0CyNPPmsufND+kY=;
	b=b3uOIkjvrK46TAK9woy4EWjKmPHuz4svWOWbIV082TwF0vUqAoYIBjkK8L+ZPpvzxGBdUt
	9TKbtuMvR4T+FquUJyJV4hleKqI6UuwYQwL7vZwAOsP9Bi1z5/tu/fIlj8mOb+M5a+/I26
	utzEcNvqSqNIPB2AYchzoEcG8UZEKoU=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-83-7FsyzLp_MiWH6_Pu0SpaBQ-1; Wed,
 02 Apr 2025 10:01:04 -0400
X-MC-Unique: 7FsyzLp_MiWH6_Pu0SpaBQ-1
X-Mimecast-MFC-AGG-ID: 7FsyzLp_MiWH6_Pu0SpaBQ_1743602463
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C228C1956089;
	Wed,  2 Apr 2025 14:01:03 +0000 (UTC)
Received: from redhat.com (unknown [10.22.88.187])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8732D1828AAD;
	Wed,  2 Apr 2025 14:01:02 +0000 (UTC)
Date: Wed, 2 Apr 2025 09:00:59 -0500
From: Bill O'Donnell <bodonnel@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCHSET] xfsprogs: localize the python programs
Message-ID: <dc2ikn3ukghh4rr54bpokhxgfnkk777krpi7qlnj4iawazpmhb@jkyhiqolbacr>
References: <20250321212508.GH4001511@frogsfrogsfrogs>
 <174351857556.2774496.13689449454739654191.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <174351857556.2774496.13689449454739654191.stgit@frogsfrogsfrogs>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On Tue, Apr 01, 2025 at 07:43:25AM -0700, Darrick J. Wong wrote:
> Hi all,
> 
> We ship two Python programs in the main xfsprogs package, but neither of
> them actually participate in gettext, which means that the output is
> always English no matter what user's locale settings are.  Fix that by
> adding them to the autogenerated message catalog.
> 
> If you're going to start using this code, I strongly recommend pulling
> from my git trees, which are linked below.
> 
> With a bit of luck, this should all go splendidly.
> Comments and questions are, as always, welcome.
> 
> --D
> 
> xfsprogs git tree:
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=localization
> ---
> Commits in this patchset:
>  * xfs_protofile: rename source code to .py.in
>  * xfs_scrub_all: rename source code to .py.in
>  * Makefile: inject package name/version/bugreport into pot file
>  * xfs_protofile: add messages to localization catalog
>  * xfs_scrub_all: localize the strings in the program
> ---

For the series...
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>


>  configure.ac              |    3 +-
>  include/builddefs.in      |    1 +
>  include/buildrules        |    9 ++++++-
>  libfrog/Makefile          |   18 ++++++++++++-
>  libfrog/gettext.py.in     |   12 +++++++++
>  mkfs/Makefile             |   11 +++++---
>  mkfs/xfs_protofile.py.in  |   21 +++++++++------
>  scrub/Makefile            |   11 +++++---
>  scrub/xfs_scrub_all.py.in |   62 +++++++++++++++++++++++++++------------------
>  9 files changed, 103 insertions(+), 45 deletions(-)
>  create mode 100644 libfrog/gettext.py.in
>  rename mkfs/{xfs_protofile.in => xfs_protofile.py.in} (85%)
>  rename scrub/{xfs_scrub_all.in => xfs_scrub_all.py.in} (89%)
> 
> 


