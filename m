Return-Path: <linux-xfs+bounces-10279-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 02947923CBB
	for <lists+linux-xfs@lfdr.de>; Tue,  2 Jul 2024 13:44:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ACD7A289238
	for <lists+linux-xfs@lfdr.de>; Tue,  2 Jul 2024 11:44:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 764C715B984;
	Tue,  2 Jul 2024 11:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jEXTQq+s"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E60B15B551;
	Tue,  2 Jul 2024 11:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719920663; cv=none; b=K8STbtv6tXJqoGhkA7tIBWdOpuergFOvCa0Wwzjo20aJv3Dnl+ZCfuHGgXWAdK1ZzfweDfLI3dUXTA5xTRh2VM2ZZKsUq79rW3KCY4eHDJTIEbymkuoeQOVLqHB6al7kUQOKyoaKjev8dI80xolw7MoZDIXBk64sbdOrkA37lfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719920663; c=relaxed/simple;
	bh=UmZsE+AjLizDxKJ5HHWqPFuIGQkriS5+xN/E/9SwgFA=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Zl+oGPSrlLFQHg6EJpYvuE4XOOPo5lG/y8F3mJqnYu6m3TirmQFlf2/hdcFfIw+amF/jsZK2lNir/pxUgXx6Qijnb5WoiNVgZLg2HJ+qvhZW4ufJQPquS6bQIN9Snng6LHyvx5RG4CXymR0RNUSFKN/wfFBvkQL+BOxbvSwwXd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jEXTQq+s; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 897E5C2BD10;
	Tue,  2 Jul 2024 11:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719920662;
	bh=UmZsE+AjLizDxKJ5HHWqPFuIGQkriS5+xN/E/9SwgFA=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=jEXTQq+spItmIkVuPduP7ABviELlqAVWHGYfIwe6yHHIjBdbX/143Vh2POZJBHUJo
	 ZAVl59Xue5b0EBBYo11uGB99dEkpQr29hlvVLh+agnVVG+QuPTdR9sb3QAXyeHdNW+
	 EEiwJz0aUWSzA5SQ1Qu8hoMFthjUIhJo9SE03BSN4BfOui4Hv8dwNbKyrWBfjGKUNK
	 QF82JSrZ6u1ug0i1JQDShW3qP7rECXRhORRzj3udENPWAJVuJuicfdq+GjZc3NilSJ
	 eAcCd5cvD3fqSvq2RXton8T9qaT25F/1Plbej8xLKD9edamvu59g1P8q3sAVtjOzjA
	 Niw0aHng+j7Pg==
Message-ID: <958080f6de517cf9d0a1994e3ca500f23599ca33.camel@kernel.org>
Subject: Re: [PATCH 01/10] fs: turn inode ctime fields into a single ktime_t
From: Jeff Layton <jlayton@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, "Darrick J. Wong"
 <djwong@kernel.org>,  Alexander Viro <viro@zeniv.linux.org.uk>, Christian
 Brauner <brauner@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, Masami
 Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers
 <mathieu.desnoyers@efficios.com>, Chandan Babu R <chandan.babu@oracle.com>,
 Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>,
 Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>, David Sterba
 <dsterba@suse.com>,  Hugh Dickins <hughd@google.com>, Andrew Morton
 <akpm@linux-foundation.org>, kernel-team@fb.com, 
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
 linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-mm@kvack.org,  linux-nfs@vger.kernel.org
Date: Tue, 02 Jul 2024 07:44:19 -0400
In-Reply-To: <20240702101902.qcx73xgae2sqoso7@quack3>
References: <20240626-mgtime-v1-0-a189352d0f8f@kernel.org>
	 <20240626-mgtime-v1-1-a189352d0f8f@kernel.org>
	 <20240701224941.GE612460@frogsfrogsfrogs>
	 <3042db2f803fbc711575ec4f1c4a273912a50904.camel@kernel.org>
	 <ZoOuSxRlvEQ5rOqn@infradead.org>
	 <d91a29f0e600793917b73ac23175e02dafd56beb.camel@kernel.org>
	 <20240702101902.qcx73xgae2sqoso7@quack3>
Autocrypt: addr=jlayton@kernel.org; prefer-encrypt=mutual;
 keydata=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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.4 (3.50.4-1.fc39) 
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Tue, 2024-07-02 at 12:19 +0200, Jan Kara wrote:
> On Tue 02-07-24 05:56:37, Jeff Layton wrote:
> > On Tue, 2024-07-02 at 00:37 -0700, Christoph Hellwig wrote:
> > > On Mon, Jul 01, 2024 at 08:22:07PM -0400, Jeff Layton wrote:
> > > > 2) the filesystem has been altered (fuzzing? deliberate doctoring?)=
.
> > > >=20
> > > > None of these seem like legitimate use cases so I'm arguing that we
> > > > shouldn't worry about them.
> > >=20
> > > Not worry seems like the wrong answer here.=C2=A0 Either we decide th=
ey
> > > are legitimate enough and we preserve them, or we decide they are
> > > bogus and refuse reading the inode.=C2=A0 But we'll need to conscious=
ly
> > > deal with the case.
> > >=20
> >=20
> > Is there a problem with consciously dealing with it by clamping the
> > time at KTIME_MAX? If I had a fs with corrupt timestamps, the last
> > thing I'd want is the filesystem refusing to let me at my data because
> > of them.
>=20
> Well, you could also view it differently: If I have a fs that corrupts ti=
me
> stamps, the last thing I'd like is that the kernel silently accepts it
> without telling me about it :)
>=20

Fair enough.

> But more seriously, my filesystem development experience shows that if th=
e
> kernel silently tries to accept and fixup the breakage, it is nice in the
> short term (no complaining users) but it tends to get ugly in the long te=
rm
> (where tend people come up with nasty cases where it was wrong to fix it
> up). So I think Christoph's idea of refusing to load inodes with ctimes o=
ut
> of range makes sense. Or at least complain about it if nothing else (whic=
h
> has some precedens in the year 2038 problem).

Complaining about it is fairly simple. We could just throw a pr_warn in
inode_set_ctime_to_ts when the time comes back as KTIME_MAX. This might
also be what we need to do for filesystems like NFS, where a future
ctime on the server is not necessarily a problem for the client.

Refusing to load the inode on disk-based filesystems is harder, but is
probably possible. There are ~90 calls to inode_set_ctime_to_ts in the
kernel, so we'd need to vet the places that are loading times from disk
images or the like and fix them to return errors in this situation.

Is warning acceptable, or do we really need to reject inodes that have
corrupt timestamps like this?
--=20
Jeff Layton <jlayton@kernel.org>

