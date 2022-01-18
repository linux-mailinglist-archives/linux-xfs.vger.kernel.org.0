Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8A80492A0A
	for <lists+linux-xfs@lfdr.de>; Tue, 18 Jan 2022 17:05:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242030AbiARQE6 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 18 Jan 2022 11:04:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241152AbiARQE5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Jan 2022 11:04:57 -0500
Received: from zeniv-ca.linux.org.uk (zeniv-ca.linux.org.uk [IPv6:2607:5300:60:148a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0414C061574;
        Tue, 18 Jan 2022 08:04:57 -0800 (PST)
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1n9qyY-002r1e-4y; Tue, 18 Jan 2022 16:04:50 +0000
Date:   Tue, 18 Jan 2022 16:04:50 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Christian Brauner <brauner@kernel.org>
Cc:     Brian Foster <bfoster@redhat.com>, Ian Kent <raven@themaw.net>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Miklos Szeredi <miklos@szeredi.hu>,
        David Howells <dhowells@redhat.com>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] vfs: check dentry is still valid in get_link()
Message-ID: <YeblIix0fyXyBipW@zeniv-ca.linux.org.uk>
References: <164180589176.86426.501271559065590169.stgit@mickey.themaw.net>
 <YeJr7/E+9stwEb3t@zeniv-ca.linux.org.uk>
 <275358741c4ee64b5e4e008d514876ed4ec1071c.camel@themaw.net>
 <YeV+zseKGNqnSuKR@bfoster>
 <YeWZRL88KPtLWlkI@zeniv-ca.linux.org.uk>
 <YeWxHPDbdSfBDtyX@zeniv-ca.linux.org.uk>
 <20220118082911.rsmv5m2pjeyt6wpg@wittgenstein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220118082911.rsmv5m2pjeyt6wpg@wittgenstein>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 18, 2022 at 09:29:11AM +0100, Christian Brauner wrote:
> On Mon, Jan 17, 2022 at 06:10:36PM +0000, Al Viro wrote:
> > On Mon, Jan 17, 2022 at 04:28:52PM +0000, Al Viro wrote:
> > 
> > > IOW, ->free_inode() is RCU-delayed part of ->destroy_inode().  If both
> > > are present, ->destroy_inode() will be called synchronously, followed
> > > by ->free_inode() from RCU callback, so you can have both - moving just
> > > the "finally mark for reuse" part into ->free_inode() would be OK.
> > > Any blocking stuff (if any) can be left in ->destroy_inode()...
> > 
> > BTW, we *do* have a problem with ext4 fast symlinks.  Pathwalk assumes that
> > strings it parses are not changing under it.  There are rather delicate
> > dances in dcache lookups re possibility of ->d_name contents changing under
> > it, but the search key is assumed to be stable.
> > 
> > What's more, there's a correctness issue even if we do not oops.  Currently
> > we do not recheck ->d_seq of symlink dentry when we dismiss the symlink from
> > the stack.  After all, we'd just finished traversing what used to be the
> > contents of a symlink that used to be in the right place.  It might have been
> > unlinked while we'd been traversing it, but that's not a correctness issue.
> > 
> > But that critically depends upon the contents not getting mangled.  If it
> > *can* be screwed by such unlink, we risk successful lookup leading to the
> 
> Out of curiosity: whether or not it can get mangled depends on the
> filesystem and how it implements fast symlinks or do fast symlinks
> currently guarantee that contents are mangled?

Not sure if I understand your question correctly...

	Filesystems should guarantee that the contents of string returned
by ->get_link() (or pointed to by ->i_link) remains unchanged for as long
as we are looking at it (until fs/namei.c:put_link() that drops it or
fs/namei.c:drop_links() in the end of pathwalk).  Fast symlinks or not -
doesn't matter.

	The only cases where that does not hold (there are two of them in
the entire kernel) happen to be fast symlinks.	Both cases are bugs.
ext4 case is actually easy to fix - the only reason it ends up mangling
the string is the way ext4_truncate() implements its check for victim
being a fast symlink (and thus needing no work).  It gets disrupted
by zeroing ->i_size, which we need to do in this case (inode removal).
That's not hard to get right.

	A plenty of other fast symlink variants (starting with ext2 ones,
BTW) do not step into anything of that sort.  IIRC, we used to have at
least some cases (orangefs, perhaps?) where revalidate on a symlink
might (with confused or malicious server) end up modifying the contents,
possibly right under somebody else walking that symlink.  Also a bug...
