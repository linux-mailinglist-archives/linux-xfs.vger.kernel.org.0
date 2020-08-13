Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79829243C50
	for <lists+linux-xfs@lfdr.de>; Thu, 13 Aug 2020 17:16:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726334AbgHMPQW (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 13 Aug 2020 11:16:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35977 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726249AbgHMPQV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Aug 2020 11:16:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597331779;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8cXTvs1Egwhhe27GvmxyjlqaXKfZPm8Vi5j5tj00vdA=;
        b=NN6VgKem5ZJecJmAYfBqskDchRXBAGmM1AyXOqTH0bdcLeO5kTp3CLnyUAKO0aBM/zDRVK
        F2EjO8COZZX7VA2prTs4IrNyU6tbVxSRMibfkDRL5rSNXQN8WCDArc+do6kleDzGabgz+S
        CRZHenbYrjmp/5WTUeF63MU9s1Pn30o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-115-kOED2gzRN_659_F4un8EsA-1; Thu, 13 Aug 2020 11:16:17 -0400
X-MC-Unique: kOED2gzRN_659_F4un8EsA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AD89B1800D41
        for <linux-xfs@vger.kernel.org>; Thu, 13 Aug 2020 15:16:16 +0000 (UTC)
Received: from localhost (dhcp-12-102.nay.redhat.com [10.66.12.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 266D519C78;
        Thu, 13 Aug 2020 15:16:13 +0000 (UTC)
Date:   Thu, 13 Aug 2020 23:29:05 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs_db: use correct inode to set inode type
Message-ID: <20200813152905.GP2937@dhcp-12-102.nay.redhat.com>
Mail-Followup-To: Gao Xiang <hsiangkao@redhat.com>,
        linux-xfs@vger.kernel.org
References: <20200813060324.8159-1-zlang@redhat.com>
 <20200813135345.GA3176@xiangao.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200813135345.GA3176@xiangao.remote.csb>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 13, 2020 at 09:53:45PM +0800, Gao Xiang wrote:
> Hi,
> 
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
> From the kernel side, the prefered way is
> commit id ("subject")

Hi Xiang,

Thanks for your review. I'll change my commit log.

> 
> > 
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
> >  		set_cur_inode(ino);
> >  		return;
> 
> Not familar with such code, but after looking into a bit, (my premature
> thought is that) I'm wondering if we need to reverify original buffer in
> 
> if (type->fields) {
> 	...
> 	set_cur()
> }
> 
> iocur_top->typ = type;
> 
> /* verify the buffer if the type has one. */
> ...
> 
> since set_cur() already verified the buffer in
> set_cur->libxfs_buf_read->...->libxfs_readbuf_verify?
> 
> Not related to this patchset but I'm a bit curious about it now...

I'm not the one who learn about xfsprogs best:) But by looking into
set_cur_inode() -> set_cur(), I think the set_cur() does the xfs_buf
verification, so I don't think we need to do that again at the end
of set_iocur_type().

Thanks,
Zorro

> 
> Thanks,
> Gao Xiang
> 
> > -- 
> > 2.20.1
> > 
> 

