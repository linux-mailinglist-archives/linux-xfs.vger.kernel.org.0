Return-Path: <linux-xfs+bounces-6320-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CFB3589D0AB
	for <lists+linux-xfs@lfdr.de>; Tue,  9 Apr 2024 05:07:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F26701C21D80
	for <lists+linux-xfs@lfdr.de>; Tue,  9 Apr 2024 03:07:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2074D5646E;
	Tue,  9 Apr 2024 03:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zx6EH8Bz"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D155457334
	for <linux-xfs@vger.kernel.org>; Tue,  9 Apr 2024 03:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712631999; cv=none; b=Uig4IWdGo3Rg/Bh49onXzsElo4Nqp7gNZ0N9I1/4deFUAQveVbrWX40hVLHDplDfFmNAhJiMnyEM/uM0OEMPwHaFDM3FU5Zep23Vr7rgs6y1d/nBo5PmWL8NGxKDiw2oqey8mv8uq3BILyeLl7c94uzOibyn6YdPsKACId0TB/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712631999; c=relaxed/simple;
	bh=bU3GXa3y6Jn7VbDC48G9t68AXQblJXdyiawiTHGG03c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FHLTGfNJVbqbZUyADOiboTQRt6wJKuVJSNN7SJ8WotKbFHGmuyFTOn9rvhQR4BTp8ofJ7je1yczC519tiG/H1ZhfxBHaYqjbLxbwxjAOOpyhArVZft2sAytyL6yRRiESyEi1WbUWvylvFtu/dHsEggpso7aacdAqkDbAYPQR+po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zx6EH8Bz; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 399B8C433B1;
	Tue,  9 Apr 2024 03:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712631999;
	bh=bU3GXa3y6Jn7VbDC48G9t68AXQblJXdyiawiTHGG03c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Zx6EH8Bz5XhfqNJYuymwZbO0PwLg4vQUi7RDfdDW3NlFZyg1WWvwQn6vL4B/gVPLd
	 CR33CBpnUOdtBEk9USuEaiRDgj4PLLJayzvvTfC/BdMkRsfs8qQZJOAPhuenDFmS7U
	 yAki6d6hXueSp8E7Tv6SlliIYBYmUMaEoG9CNM9uRNyejdi+qqd7sadP9cGbqWEKZG
	 nWgI2JPJTnTCdq6QqqYIp222xzk4Fkrsz18vh9iWu2qHb1KfONevRz3qx7pY8YUeQu
	 8reIR2AzRPdH+RmZV44XmtkaQtgRM8D2KvOUB1F5ueZKyHj8BtoJgrv61VkTao4Zbj
	 Ol1oYkS3/Ruuw==
Date: Mon, 8 Apr 2024 20:06:38 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Shirley Ma <shirley.ma@oracle.com>
Subject: Re: [PATCH 04/15] xfs: introduce a file mapping exchange log intent
 item
Message-ID: <20240409030638.GE6390@frogsfrogsfrogs>
References: <171150380628.3216674.10385855831925961243.stgit@frogsfrogsfrogs>
 <171150380732.3216674.5999741892452595331.stgit@frogsfrogsfrogs>
 <ZhMxZdvk8Tq9WcLu@dread.disaster.area>
 <20240409011848.GT6414@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240409011848.GT6414@frogsfrogsfrogs>

On Mon, Apr 08, 2024 at 06:18:48PM -0700, Darrick J. Wong wrote:
> On Mon, Apr 08, 2024 at 09:51:01AM +1000, Dave Chinner wrote:
> > On Tue, Mar 26, 2024 at 06:53:52PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > Introduce a new intent log item to handle exchanging mappings between
> > > the forks of two files.
> > > 
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > > ---
> > >  fs/xfs/Makefile                 |    1 
> > >  fs/xfs/libxfs/xfs_log_format.h  |   42 ++++++-
> > >  fs/xfs/libxfs/xfs_log_recover.h |    2 
> > >  fs/xfs/xfs_exchmaps_item.c      |  235 +++++++++++++++++++++++++++++++++++++++
> > >  fs/xfs/xfs_exchmaps_item.h      |   59 ++++++++++
> > >  fs/xfs/xfs_log_recover.c        |    2 
> > >  fs/xfs/xfs_super.c              |   19 +++
> > >  7 files changed, 357 insertions(+), 3 deletions(-)
> > >  create mode 100644 fs/xfs/xfs_exchmaps_item.c
> > >  create mode 100644 fs/xfs/xfs_exchmaps_item.h
> > > 
> > > 
> > > diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
> > > index 2474242f5a05f..68ca9726e7b7d 100644
> > > --- a/fs/xfs/Makefile
> > > +++ b/fs/xfs/Makefile
> > > @@ -102,6 +102,7 @@ xfs-y				+= xfs_log.o \
> > >  				   xfs_buf_item.o \
> > >  				   xfs_buf_item_recover.o \
> > >  				   xfs_dquot_item_recover.o \
> > > +				   xfs_exchmaps_item.o \
> > >  				   xfs_extfree_item.o \
> > >  				   xfs_attr_item.o \
> > >  				   xfs_icreate_item.o \
> > > diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
> > > index 16872972e1e97..09024431cae9a 100644
> > > --- a/fs/xfs/libxfs/xfs_log_format.h
> > > +++ b/fs/xfs/libxfs/xfs_log_format.h
> > > @@ -117,8 +117,9 @@ struct xfs_unmount_log_format {
> > >  #define XLOG_REG_TYPE_ATTRD_FORMAT	28
> > >  #define XLOG_REG_TYPE_ATTR_NAME	29
> > >  #define XLOG_REG_TYPE_ATTR_VALUE	30
> > > -#define XLOG_REG_TYPE_MAX		30
> > > -
> > > +#define XLOG_REG_TYPE_XMI_FORMAT	31
> > > +#define XLOG_REG_TYPE_XMD_FORMAT	32
> > > +#define XLOG_REG_TYPE_MAX		32
> > >  
> > >  /*
> > >   * Flags to log operation header
> > > @@ -243,6 +244,8 @@ typedef struct xfs_trans_header {
> > >  #define	XFS_LI_BUD		0x1245
> > >  #define	XFS_LI_ATTRI		0x1246  /* attr set/remove intent*/
> > >  #define	XFS_LI_ATTRD		0x1247  /* attr set/remove done */
> > > +#define	XFS_LI_XMI		0x1248  /* mapping exchange intent */
> > > +#define	XFS_LI_XMD		0x1249  /* mapping exchange done */
> > >  
> > >  #define XFS_LI_TYPE_DESC \
> > >  	{ XFS_LI_EFI,		"XFS_LI_EFI" }, \
> > > @@ -260,7 +263,9 @@ typedef struct xfs_trans_header {
> > >  	{ XFS_LI_BUI,		"XFS_LI_BUI" }, \
> > >  	{ XFS_LI_BUD,		"XFS_LI_BUD" }, \
> > >  	{ XFS_LI_ATTRI,		"XFS_LI_ATTRI" }, \
> > > -	{ XFS_LI_ATTRD,		"XFS_LI_ATTRD" }
> > > +	{ XFS_LI_ATTRD,		"XFS_LI_ATTRD" }, \
> > > +	{ XFS_LI_XMI,		"XFS_LI_XMI" }, \
> > > +	{ XFS_LI_XMD,		"XFS_LI_XMD" }
> > >  
> > >  /*
> > >   * Inode Log Item Format definitions.
> > > @@ -878,6 +883,37 @@ struct xfs_bud_log_format {
> > >  	uint64_t		bud_bui_id;	/* id of corresponding bui */
> > >  };
> > >  
> > > +/*
> > > + * XMI/XMD (file mapping exchange) log format definitions
> > > + */
> > > +
> > > +/* This is the structure used to lay out an mapping exchange log item. */
> > > +struct xfs_xmi_log_format {
> > > +	uint16_t		xmi_type;	/* xmi log item type */
> > > +	uint16_t		xmi_size;	/* size of this item */
> > > +	uint32_t		__pad;		/* must be zero */
> > > +	uint64_t		xmi_id;		/* xmi identifier */
> > 
> > Why does this ID need to be a 64 bit ID?  If it is 32 bit, then
> > there's no need for any padding, and it doesn't seem likely to me
> > that we'd have millions of exchanges in flight at once.
> > 
> > (Edit: I see why later - I address it there....)
> > 
> > > +
> > > +	uint64_t		xmi_inode1;	/* inumber of first file */
> > > +	uint64_t		xmi_inode2;	/* inumber of second file */
> > 
> > Inode numbers are not unique identifiers. Intents get replayed after
> > everything else has been replayed, including inode unlink and
> > reallocation.
> > 
> > Without a generation number, there is no way to determine if the
> > inode number in the intent is actually pointing at the correct inode
> > when we go to replay the intent.
> > 
> > Yes, I know it's unlikely that this might occur, but I'd much prefer
> > that we fully identify inodes in the on-disk metadata so we can
> > check it at recovery time than leaving it out and just hoping we are
> > operating on the correct inode life-cycle...
> 
> I suppose I don't mind encoding the generation number, but I'm not
> thrilled that you're suggesting this after I finally got someone to
> complete the review of this patchset after 3 years.
> 
> I probably ought to use the u32 pad in the attri log format to do the
> same for parent pointers, seeing as parent pointers have their own attri
> log opcodes now anyway.

Actually, no.  This is the wrong thing to do.

Adding i_generation to log items is something that we should apply
systematically to all the log items that target files -- BUIs, ATTRIs,
and XMIs.  I don't know why I indulged this, but I looked into how to
squeeze in i_generation: I can't do BUIs without revving the
xfs_map_extents ondisk format to include a new u32 field.  I can't do
ATTRIs without expanding the size of those by u32 because there's no
space left after parent pointers used up the padding field.

Dave, I've spent years working on this code.  I've gotten it to work.
I'm not interested in yet another refactoring of this now old code, and
I'm tired of not being able to merge patches just because you had some
random idea "let's expand the scope to fix these other code smells too!"
I want to move on with merging my dev branch, because there are 200 more
patches to go to finish online repair.

Andrey wants to get fsverity moving, and I can't help him do that
because I'm stuck on this.  Christoph wants to use some of realtime
modernization patches, and I can't help him do that because I'm stuck on
this.  John wants to get forcealign and untorn writes moving and I
can't help him do that because I'm stuck on this.  Catherine wants to
learn more about the codebase and I can't help her do that because I'm
stuck on this.

As I keep saying, I want to get online repair to the point where I can
send it out for wider testing with real users to find out how it really
works.  The customers who want the feature also want this, but I can't
help them do that because I'm stuck on review.

Do you get the picture?  Many projects are stalled on ME, and I don't
like that.  I don't get the sense that everyone else is enjoying this
stat of affairs either.

I'm very worn down by this XFS mentality of "we have to clean up all
the smells as a gatekeeping condition of merging someone else's work".
No, we don't have to do that.  I don't want to have to think about how
to engineer some unrelated ondisk format cleanup into a giant pile of
code and make /that/ work seamlessly too.

That is not a reasonable thing to ask for, and I'm not going to do it.

--D

> > 
> > > +	uint64_t		xmi_startoff1;	/* block offset into file1 */
> > > +	uint64_t		xmi_startoff2;	/* block offset into file2 */
> > > +	uint64_t		xmi_blockcount;	/* number of blocks */
> > > +	uint64_t		xmi_flags;	/* XFS_EXCHMAPS_* */
> > > +	uint64_t		xmi_isize1;	/* intended file1 size */
> > > +	uint64_t		xmi_isize2;	/* intended file2 size */
> > 
> > How do these inode sizes differ from xmi_startoff{1,2} +
> > xmi_blockcount?
> 
> If the caller specifies XFS_EXCHANGE_RANGE_TO_EOF then we need to
> exchange the file sizes too so that we preserve a mid-fsblock EOF.
> 
> > 
> > > +/* Allocate and initialize an xmi item. */
> > > +STATIC struct xfs_xmi_log_item *
> > > +xfs_xmi_init(
> > > +	struct xfs_mount	*mp)
> > > +
> > > +{
> > > +	struct xfs_xmi_log_item	*xmi_lip;
> > > +
> > > +	xmi_lip = kmem_cache_zalloc(xfs_xmi_cache, GFP_KERNEL | __GFP_NOFAIL);
> > > +
> > > +	xfs_log_item_init(mp, &xmi_lip->xmi_item, XFS_LI_XMI, &xfs_xmi_item_ops);
> > > +	xmi_lip->xmi_format.xmi_id = (uintptr_t)(void *)xmi_lip;
> > 
> > OK. Encoding the pointer as the ID is a mistake we made with EFIs
> > and we should stop repeating it in all new intents. There is no
> > guarantee that the pointer is a unique identifier because these are
> > allocated out of a slab cache. Hence we can allocate an xmi, log it,
> > finish the xmds, free the xmi, then run another exchange and get
> > exactly the same XMI pointer returned to us for the new exchange
> > intent. Now we potentially have multiple exchange items in the
> > journal with the same ID.
> > 
> > Can we use a u32 and get_random_u32() for the ID here, please? We
> > already do this for checkpoint discrimination in the log (i.e. to
> > identify what checkpoint an ophdr belongs to), so we really should
> > be doing the same for all ids we use in the journal for matching
> > items.
> > 
> > Longer term, We probably should move all the intent/done identifiers
> > to a psuedo random identifier mechanism, but that's outside the
> > scope of this change....
> 
> Agreed.  I don't think it's appropriate to gate acceptance of this
> patchset on this kind of general change.
> 
> > 
> > > +/*
> > > + * This routine is called to create an in-core file mapping exchange item from
> > > + * the xmi format structure which was logged on disk.  It allocates an in-core
> > > + * xmi, copies the exchange information from the format structure into it, and
> > > + * adds the xmi to the AIL with the given LSN.
> > > + */
> > > +STATIC int
> > > +xlog_recover_xmi_commit_pass2(
> > > +	struct xlog			*log,
> > > +	struct list_head		*buffer_list,
> > > +	struct xlog_recover_item	*item,
> > > +	xfs_lsn_t			lsn)
> > > +{
> > > +	struct xfs_mount		*mp = log->l_mp;
> > > +	struct xfs_xmi_log_item		*xmi_lip;
> > > +	struct xfs_xmi_log_format	*xmi_formatp;
> > > +	size_t				len;
> > > +
> > > +	len = sizeof(struct xfs_xmi_log_format);
> > > +	if (item->ri_buf[0].i_len != len) {
> > > +		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, log->l_mp);
> > > +		return -EFSCORRUPTED;
> > > +	}
> > > +
> > > +	xmi_formatp = item->ri_buf[0].i_addr;
> > > +	if (xmi_formatp->__pad != 0) {
> > > +		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, log->l_mp);
> > > +		return -EFSCORRUPTED;
> > > +	}
> > > +
> > > +	xmi_lip = xfs_xmi_init(mp);
> > > +	memcpy(&xmi_lip->xmi_format, xmi_formatp, len);
> > 
> > Should this be validating that the structure contents are within
> > valid ranges?
> 
> That's done within _recover_work, like all the other intent items.  If
> you want to clean that up then I'll review those patches, but I am not
> going to prepend more generic cleanups.
> 
> --D
> 
> > -Dave.
> > 
> > -- 
> > Dave Chinner
> > david@fromorbit.com
> 

