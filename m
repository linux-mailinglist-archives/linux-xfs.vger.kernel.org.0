Return-Path: <linux-xfs+bounces-14449-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 466059A340E
	for <lists+linux-xfs@lfdr.de>; Fri, 18 Oct 2024 07:09:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 07BCC285076
	for <lists+linux-xfs@lfdr.de>; Fri, 18 Oct 2024 05:09:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4FDE17279E;
	Fri, 18 Oct 2024 05:09:15 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 202AB51C4A;
	Fri, 18 Oct 2024 05:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729228155; cv=none; b=egGJA7w8hcxS0p+pLN9xuaBqPuNZwGK9NFLnmVfWNxj892SAGc6xtwyN0JvcEnAb70blTombsbVVxESri+6EWWI1+rkLJbIk7lLry+sYbSLoVBuwPGqXw7eqEjNaUtv3YAR0Ju0RrQKzafbgg2/78qdmISmR18p8ieP+0T+3mkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729228155; c=relaxed/simple;
	bh=7qQFn0tKPfXcsfOpOj81yXYL0NPH7ut8AJMTPCpUnYA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gBRN9W6rShJTLSIxQkroJ72vLjRRMOuceH94CON/TCtw2dFhTkvHwqIkBxg0AtMinpPNofRpz3QRT+RE1OgyN3f5SbxPAwWKVkGT/NvSyX0vfolRs8F1KxJPh792yYLiyAujNMaeDXLl5TW9ZJi08ObY0Wr9O/YaOeVe4uUEfPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id AF6F1227A8E; Fri, 18 Oct 2024 07:09:09 +0200 (CEST)
Date: Fri, 18 Oct 2024 07:09:09 +0200
From: Christoph Hellwig <hch@lst.de>
To: Brian Foster <bfoster@redhat.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org, djwong@kernel.org,
	hch@lst.de
Subject: Re: [PATCH 0/2] fstests/xfs: a couple growfs log recovery tests
Message-ID: <20241018050909.GA19831@lst.de>
References: <20241017163405.173062-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241017163405.173062-1-bfoster@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Oct 17, 2024 at 12:34:03PM -0400, Brian Foster wrote:
> I believe you reproduced a problem with your customized realtime variant
> of the initial test. I've not been able to reproduce any test failures
> with patch 2 here, though I have tried to streamline the test a bit to
> reduce unnecessary bits (patch 1 still reproduces the original
> problems). I also don't tend to test much with rt, so it's possible my
> config is off somehow or another. Otherwise I _think_ I've included the
> necessary changes for rt support in the test itself.
> 
> Thoughts? I'd like to figure out what might be going on there before
> this should land..

Darrick mentioned that was just with his rt group patchset, which
make sense as we don't have per-group metadata without that.

Anyway, the series looks good to me, and I think it supersedes my
more targeted hand crafted reproducer.


