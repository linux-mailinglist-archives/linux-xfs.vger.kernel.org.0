Return-Path: <linux-xfs+bounces-11785-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 67C669573C0
	for <lists+linux-xfs@lfdr.de>; Mon, 19 Aug 2024 20:44:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9B5E11C23A04
	for <lists+linux-xfs@lfdr.de>; Mon, 19 Aug 2024 18:44:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C0B418A957;
	Mon, 19 Aug 2024 18:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JdzT1jup"
X-Original-To: linux-xfs@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05EB9189B94
	for <linux-xfs@vger.kernel.org>; Mon, 19 Aug 2024 18:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724092863; cv=none; b=Kt5Vwbwq+nftrwO1+sz9ZzSnUgqR8V4bQcNhVg52zCz7Im49Ov5Ppz7lgKWhnUIwq4Ego2B34nol1kIXdr1kqyVJqcZSpwm/n1evSp2sweKPEIvTAmEZ6esVinm49H0hOcm/RHGSkZ/F0ktRDAWlYuQUv9KTgKDFBTGPaVAF8Os=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724092863; c=relaxed/simple;
	bh=EtHp0dvkqJP1sIWbjWPhI++PNyQPPV2egKwaGek1UNk=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=jcrO+5+CC4++zBUZsOq1ia5EALQdsMA6Q3FY/lz7T8yRfw+5xIiDdOOsUe0W/lQZb98uohU824MzWds+tJ9BZf4ZgYvO8DPmDrHNRyfhZnTvtihWeXK4b4+PfZanUFJM/+yTO7KaoXYbI9oW+Apkdpw70+Ud8AmO+iM8gZlJNrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JdzT1jup; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724092861;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EtHp0dvkqJP1sIWbjWPhI++PNyQPPV2egKwaGek1UNk=;
	b=JdzT1jupWKSWntXwomPkFydc+F7hNtuzI0QGWTqwVo0EcG4LrEyELJvbRN1DuWDAy/ZpaM
	OWg1Las6HW69J12GhC/E3aF16JwD+lgRhYUlPMYj4SdYzfgAD8oVs3m2Ud7oi+RRWIz2e4
	MN2IA1V6+g+lKGrO427+JztBaX5bU1g=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-416-p-6e9FU6NQGsc8zERXSyNQ-1; Mon,
 19 Aug 2024 14:40:55 -0400
X-MC-Unique: p-6e9FU6NQGsc8zERXSyNQ-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8547D1955D42;
	Mon, 19 Aug 2024 18:40:51 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.30])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B149619560AD;
	Mon, 19 Aug 2024 18:40:45 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20240819163938.qtsloyko67cqrmb6@quentin>
References: <20240819163938.qtsloyko67cqrmb6@quentin> <20240818165124.7jrop5sgtv5pjd3g@quentin> <20240815090849.972355-1-kernel@pankajraghav.com> <2924797.1723836663@warthog.procyon.org.uk> <3402933.1724068015@warthog.procyon.org.uk>
To: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
Cc: dhowells@redhat.com, brauner@kernel.org, akpm@linux-foundation.org,
    chandan.babu@oracle.com, linux-fsdevel@vger.kernel.org,
    djwong@kernel.org, hare@suse.de, gost.dev@samsung.com,
    linux-xfs@vger.kernel.org, hch@lst.de, david@fromorbit.com,
    Zi Yan <ziy@nvidia.com>, yang@os.amperecomputing.com,
    linux-kernel@vger.kernel.org, linux-mm@kvack.org,
    willy@infradead.org, john.g.garry@oracle.com,
    cl@os.amperecomputing.com, p.raghav@samsung.com, mcgrof@kernel.org,
    ryan.roberts@arm.com
Subject: Re: [PATCH v12 00/10] enable bs > ps in XFS
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3458346.1724092844.1@warthog.procyon.org.uk>
Date: Mon, 19 Aug 2024 19:40:44 +0100
Message-ID: <3458347.1724092844@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

Pankaj Raghav (Samsung) <kernel@pankajraghav.com> wrote:

> I tried this code on XFS, and it is working as expected (I am getting
> xxxx).

XFS doesn't try to use mapping_set_release_always().

David


