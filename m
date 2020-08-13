Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E106243C6B
	for <lists+linux-xfs@lfdr.de>; Thu, 13 Aug 2020 17:24:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726292AbgHMPYN (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 13 Aug 2020 11:24:13 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:25909 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726167AbgHMPYN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Aug 2020 11:24:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597332251;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iY1AO6Cl+iX9KpbIfCZima1ku/k4HjlhP/5334joxXM=;
        b=Q0VVRWQpjXay1SxLMGFDnPbKtucNSllIttju0/UhmA0gYoNHsJz9ZPKqz7ydPXS2tFCn5t
        rk/gYvplBoR6MDj9GSo0z47hfhjttFUewlenYtvHonyfxM05uomwHGaWgWez5FBPDuYFbb
        JsdaWDnnlTG/B1ht9q/uYMHYj0DyPMQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-287-N7UB4bQ7MHauieEthZbL3Q-1; Thu, 13 Aug 2020 11:24:09 -0400
X-MC-Unique: N7UB4bQ7MHauieEthZbL3Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 083DB1DDF9;
        Thu, 13 Aug 2020 15:24:08 +0000 (UTC)
Received: from localhost (dhcp-12-102.nay.redhat.com [10.66.12.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 75BE75D990;
        Thu, 13 Aug 2020 15:24:07 +0000 (UTC)
Date:   Thu, 13 Aug 2020 23:36:59 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs_db: use correct inode to set inode type
Message-ID: <20200813153659.GQ2937@dhcp-12-102.nay.redhat.com>
Mail-Followup-To: "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
References: <20200813060324.8159-1-zlang@redhat.com>
 <20200813145616.GI6096@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200813145616.GI6096@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 13, 2020 at 07:56:16AM -0700, Darrick J. Wong wrote:
> On Thu, Aug 13, 2020 at 02:03:24PM +0800, Zorro Lang wrote:
> > A test fails as:
> >   # xfs_db -c "inode 133" -c "addr" -c "p core.size" -c "type inode" -c "addr" -c "p core.size" /dev/sdb1
> >   current
> >           byte offset 68096, length 512
> >           buffer block 128 (fsbno 16), 32 bbs
> >           inode 133, dir inode -1, type inode
> >   core.size = 123142
> >   current
> >           byte offset 65536, length 512
> >           buffer block 128 (fsbno 16), 32 bbs
> >           inode 128, dir inode 128, type inode
> >   core.size = 42
> > 
> > The "type inode" get wrong inode addr due to it trys to get the
> > beginning of an inode chunk, refer to "533d1d229 xfs_db: properly set
> > inode type".
> 
> It took me a minute to figure out what this was referring to (though it

Sorry about that :-p

> was obvious from the code change).  Might I suggest something like:
> 
> The "type inode" command accidentally moves the io cursor because it
> forgets to include the io cursor's buffer offset when it computes the
> inode number from the io cursor's location.
> 
> Fixes: 533d1d229a88 ("xfs_db: properly set inode type")

Sure, thanks for this detailed suggestion.

> 
> > We don't need to get the beginning of a chunk in set_iocur_type, due
> > to set_cur_inode(ino) will help to do all of that and make a proper
> > verification. We just need to give it a correct inode.
> > 
> > Reported-by: Jianhong Yin <jiyin@redhat.com>
> > Signed-off-by: Zorro Lang <zlang@redhat.com>
> > ---
> >  db/io.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/db/io.c b/db/io.c
> > index 6628d061..61940a07 100644
> > --- a/db/io.c
> > +++ b/db/io.c
> > @@ -591,6 +591,7 @@ set_iocur_type(
> >  	/* Inodes are special; verifier checks all inodes in the chunk */
> >  	if (type->typnm == TYP_INODE) {
> >  		xfs_daddr_t	b = iocur_top->bb;
> > +		int		bo = iocur_top->boff;
> >  		xfs_ino_t	ino;
> >  
> >  		/*
> > @@ -598,7 +599,7 @@ set_iocur_type(
> >   		 * which contains the current disk location; daddr may change.
> >   		 */
> >  		ino = XFS_AGINO_TO_INO(mp, xfs_daddr_to_agno(mp, b),
> > -			((b << BBSHIFT) >> mp->m_sb.sb_inodelog) %
> > +			(((b << BBSHIFT) + bo) >> mp->m_sb.sb_inodelog) %
> >  			XFS_AGB_TO_AGINO(mp, mp->m_sb.sb_agblocks));
> 
> /me feels like this whole thing ought to be revised into something
> involving XFS_OFFBNO_TO_AGINO to make the unit conversions easier to
> read, e.g.:
> 
> 	xfs_daddr_t	b = iocur_top->bb;
> 	xfs_agbno_t	agbno;
> 	xfs_agino_t	agino;
> 
> 	agbno = xfs_daddr_to_agbno(mp, b);
> 	agino = XFS_OFFBNO_TO_AGINO(mp, agbno,
> 			iocur_top->boff / mp->m_sb.sb_inodesize);
> 	ino = XFS_AGINO_TO_INO(mp, xfs_daddr_to_agno(mp, b), agino);

Sure, that looks clearer.

Thanks,
Zorro

> 
> --D
> 
> >  		set_cur_inode(ino);
> >  		return;
> > -- 
> > 2.20.1
> > 
> 

