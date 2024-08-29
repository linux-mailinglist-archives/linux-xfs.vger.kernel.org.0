Return-Path: <linux-xfs+bounces-12466-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E61C9642F2
	for <lists+linux-xfs@lfdr.de>; Thu, 29 Aug 2024 13:27:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 05848B24505
	for <lists+linux-xfs@lfdr.de>; Thu, 29 Aug 2024 11:27:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5018E1917D7;
	Thu, 29 Aug 2024 11:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="pqDh+9ax"
X-Original-To: linux-xfs@vger.kernel.org
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31CF47E59A
	for <linux-xfs@vger.kernel.org>; Thu, 29 Aug 2024 11:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724930814; cv=none; b=ZEKchyQ8448+RUW93GUJR9OP9ki/WIf/92/P24skRTsBlPuGZEzqoDbMXeYhuWPIDYthY6YyRqBoaAXCEKCcmZQOq+ph8dIWDmrPpubpaGDVyI5Bb4oGsD/hBU7teJNjaywRloVsPI9HbCwR0xBS7sp5kxF6FNN3zQh5H6y12kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724930814; c=relaxed/simple;
	bh=Y+B5km99YPVm29mtxzC/gh4SydowuGm+EA1JK8Z3kW4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mG4mUarr9ftDsH5hQPYWX3oC2wjoEYe+VGGtqiHIUE9QKQn+rvwdNHgNVWRSAjV/AygjZ2K+NoMpBwXUx5Z3S3H0WrKrJq+++yXbwAVl1XiYH0R6lyKqeOd5IMxtvd2rVIhXm07IwicgohO+WOh9yvxm5WvduexJgewy/I434Rw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=pqDh+9ax; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 29 Aug 2024 07:26:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724930809;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MAsc263Wcw45dgdq27pEPB5wCPxiVZqJ/sXfhtkn/JY=;
	b=pqDh+9axWna7Fo3dWS+XmOMowCMJDZnOyWnD9kGLFfZgQfEbeA0KrHh/ctrxOrcQVwU+ra
	RescOXF98Ykom8q34kMaih+lGV/mSSX9YFDiHUtTKh1LvT8jsq+4cdSgVG+Trx2+/q83fO
	MyBK4pF/ow/uUEa5sOu5DpWR4K5lvaM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Jan Kara <jack@suse.cz>
Cc: Josef Bacik <josef@toxicpanda.com>, kernel-team@fb.com, 
	linux-fsdevel@vger.kernel.org, amir73il@gmail.com, brauner@kernel.org, 
	linux-xfs@vger.kernel.org, gfs2@lists.linux.dev, linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH v4 14/16] bcachefs: add pre-content fsnotify hook to fault
Message-ID: <zzlv7xb76hkojmilxsvrsrhsh7yzglvrwofxcavjo4nluhjbdu@cl2c4iscmfg2>
References: <cover.1723670362.git.josef@toxicpanda.com>
 <9627e80117638745c2f4341eb8ac94f63ea9acee.1723670362.git.josef@toxicpanda.com>
 <20240829111055.hyc4eke7a5e26z7r@quack3>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240829111055.hyc4eke7a5e26z7r@quack3>
X-Migadu-Flow: FLOW_OUT

On Thu, Aug 29, 2024 at 01:10:55PM GMT, Jan Kara wrote:
> On Wed 14-08-24 17:25:32, Josef Bacik wrote:
> > bcachefs has its own locking around filemap_fault, so we have to make
> > sure we do the fsnotify hook before the locking.  Add the check to emit
> > the event before the locking and return VM_FAULT_RETRY to retrigger the
> > fault once the event has been emitted.
> > 
> > Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> 
> Looks good to me. Would be nice to get ack from bcachefs guys. Kent?

I said I wanted the bcachefs side tested, and offered Josef CI access
for that - still waiting to hear from him.

