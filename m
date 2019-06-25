Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6D7751F6E
	for <lists+linux-xfs@lfdr.de>; Tue, 25 Jun 2019 02:01:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729066AbfFYAB0 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 24 Jun 2019 20:01:26 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:56953 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726631AbfFYAB0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jun 2019 20:01:26 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 7F48422427;
        Mon, 24 Jun 2019 20:01:25 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 24 Jun 2019 20:01:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=
        message-id:subject:from:to:cc:date:in-reply-to:references
        :content-type:mime-version:content-transfer-encoding; s=fm3; bh=
        oMTIpDAv9E9HPOewMsIquSZASPMh4UOuRsX2qp0LmVs=; b=D4lL2anlPAuZwWoQ
        /hWYeYKWcNhkRv1vdOxf59zy5vPB1PvXtAak/zH1c8Ilr3qj8wcIxcXA4eFlK7yb
        L6D9f2TNKdeTNtCvaMwC0C2I+sb2x/76YrLWdjASXrfqOEpYJ2KuPVpj1hWNpY1g
        khQqDAJBZcIbSmWo6EK90GPrvE8ICEtggtEcgKwiQBgd+ysFED65IteuAApdPy3c
        Kv5R6VTyMhwmdhEiA4X3I7kAEjZTA/JO5uSwyCxcjCMpbe8zj3oK122wvD0cXnzm
        GTO0SJOO4KezhiTIed3CsqISii+6rah+YIhChQpBYBL7GW1kHfT4hXBJdkV2nGh+
        edamjQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=oMTIpDAv9E9HPOewMsIquSZASPMh4UOuRsX2qp0Lm
        Vs=; b=FzaaDJs2l1PuB0zmE/akmZz0V9/JDDdmRVDBstuvkR0OM24r5WSdOhDRr
        H2VUkE4XvMTnfXRSf1twmDqWpiArJODcCgRXD4hLEajTKxw1KAfU/xwyDy4uL+7m
        XiXl/cOnwv0UinGOTFo5AXXFnXApzIFXdKE1NvcynDKiR6pyrQmClBNO/zUNxNH7
        ImHnWu23HxCXvNK/yDYkh/058D1SM0Zn+xhxS8d42ZjtsfoSlPHtK6ZoNB1bAjcN
        rkQliVZ9MKsfJMgIHtUowZCtuCF182xU/zgzj+Fjq7exavU79yDVTYuMPHq3jJY1
        i74EDl5L9srmGlWfGFORKFqYygu3w==
X-ME-Sender: <xms:VGQRXS0lqAsdchIGc18e-7Q1-TQB7a07s9p6JGd5mAb1Mzi22vE-dA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudefgdeffecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefkuffhvfffjghftggfggfgsehtjeertddtreejnecuhfhrohhmpefkrghnucfm
    vghnthcuoehrrghvvghnsehthhgvmhgrfidrnhgvtheqnecukfhppeduudekrddvtdekrd
    dujeefrdehfeenucfrrghrrghmpehmrghilhhfrhhomheprhgrvhgvnhesthhhvghmrgif
    rdhnvghtnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:VGQRXX-kBUI040Wmw7uUqj9gEGE8Pg7RPxiUVYnilQ7pSEoTkiqcbw>
    <xmx:VGQRXbvDuNYFH41hMMkZytwc6VMftiP6IiCPpm43mDcFJVlS6fOq7A>
    <xmx:VGQRXVoupjh0bKUqsXRBdhaqY5JoeYn6K3TE2jqx3vyGK_U9EFUn2A>
    <xmx:VWQRXX7APuakKpX2wnx0OSQt657jiUZVJH3Ioji5O5yVFM5ZDXVPrA>
Received: from pluto.themaw.net (unknown [118.208.173.53])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7AB3E80059;
        Mon, 24 Jun 2019 20:01:24 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by pluto.themaw.net (Postfix) with ESMTP id 590FB1C0114;
        Tue, 25 Jun 2019 08:01:21 +0800 (AWST)
Message-ID: <85355779e58e1aad41d078327eb9b693fae56eea.camel@themaw.net>
Subject: Re: [PATCH 07/10] xfs: mount-api - add xfs_fc_free()
From:   Ian Kent <raven@themaw.net>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Date:   Tue, 25 Jun 2019 08:01:21 +0800
In-Reply-To: <20190624175627.GY5387@magnolia>
References: <156134510205.2519.16185588460828778620.stgit@fedora-28>
         <156134514204.2519.9597800141023778002.stgit@fedora-28>
         <20190624175627.GY5387@magnolia>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, 2019-06-24 at 10:56 -0700, Darrick J. Wong wrote:
> On Mon, Jun 24, 2019 at 10:59:02AM +0800, Ian Kent wrote:
> > Add the fs_context_operations method .free that performs fs
> > context cleanup on context release.
> > 
> > Signed-off-by: Ian Kent <raven@themaw.net>
> > ---
> >  fs/xfs/xfs_super.c |   23 +++++++++++++++++++++++
> >  1 file changed, 23 insertions(+)
> > 
> > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > index 7326b21b32d1..0a771e1390e7 100644
> > --- a/fs/xfs/xfs_super.c
> > +++ b/fs/xfs/xfs_super.c
> > @@ -2413,10 +2413,33 @@ static const struct super_operations
> > xfs_super_operations = {
> >  	.free_cached_objects	= xfs_fs_free_cached_objects,
> >  };
> >  
> > +static void xfs_fc_free(struct fs_context *fc)
> > +{
> > +	struct xfs_fs_context	*ctx = fc->fs_private;
> > +	struct xfs_mount	*mp = fc->s_fs_info;
> > +
> > +	if (mp) {
> > +		/*
> > +		 * If an error occurs before ownership the xfs_mount
> > +		 * info struct is passed to xfs by the VFS (by assigning
> > +		 * it to sb->s_fs_info and clearing the corresponding
> > +		 * fs_context field, done before calling fill super via
> > +		 * .get_tree()) there may be some strings to cleanup.
> > +		 */
> > +		if (mp->m_logname)
> > +			kfree(mp->m_logname);
> 
> Doesn't kfree handle null parameters gracefully?

It does, old habits die hard, will fix, ;)

> 
> --D
> 
> > +		if (mp->m_rtname)
> > +			kfree(mp->m_rtname);
> > +		kfree(mp);
> > +	}
> > +	kfree(ctx);
> > +}
> > +
> >  static const struct fs_context_operations xfs_context_ops = {
> >  	.parse_param = xfs_parse_param,
> >  	.get_tree    = xfs_get_tree,
> >  	.reconfigure = xfs_reconfigure,
> > +	.free	     = xfs_fc_free,
> >  };
> >  
> >  static struct file_system_type xfs_fs_type = {
> > 

