Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7E26BEB27
	for <lists+linux-xfs@lfdr.de>; Thu, 26 Sep 2019 06:22:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732599AbfIZEWP (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 26 Sep 2019 00:22:15 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:54017 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728648AbfIZEWP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 Sep 2019 00:22:15 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 3AC8C64A;
        Thu, 26 Sep 2019 00:22:14 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Thu, 26 Sep 2019 00:22:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=
        message-id:subject:from:to:cc:date:in-reply-to:references
        :content-type:mime-version:content-transfer-encoding; s=fm1; bh=
        hmyFx6KOq39MUmKub56qVzinGN55DCypJ6gHNodi83w=; b=1nppSTJsNcdMwL0u
        83CUrZSwvYAdnT8JO7gvhSjX1QQR1glHNgJtMVHBERKJ/YqrSo5n6epaU93yivRQ
        pFM/m+zEHlMFHxbZEPko1Ziyztcj6gV6b7+EU1Q8Ie7czERBU8BgLZLYoG6LTwt6
        dkfCFmd4zE6MBXqcg45/ZtA1f//k9gV6YZSZib/XrYhFx18kKN33b5zShWK/t8FD
        pvb7Y6u5RIq04BFyMZFLBCD768xHS4TN6dYrzMxckYMnS4SfrJAqF0c0O2ajo77s
        Noc4+wK1AOkSKLoy0BnfE9ZoAucicvGiN219/Gl/Lz/NTW7RuSmoHmNM/dCgB5ER
        IuhSrg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=hmyFx6KOq39MUmKub56qVzinGN55DCypJ6gHNodi8
        3w=; b=pN9TpUkn4ls77Sh0CfrVXfiE0OrTvD7GR9+zc/efhLRvOQmQ8Ix/4en4Q
        9jMwWyTnUkNSycD+Kq2qVpe0aoSu/nBovix6YIDgYSPz3pYwjWRXtwBjFh54Xia/
        CO1GWhrzSCB7BmOm6u942S0cHoccwVanM1Q77bZLv0+Glf3pLNxrrO7CYMSY1HQJ
        kaAdzrjXzEL4xFZcQt4iCZVP7kSfaaq7ViqjORRZSdr3o9qgYNea+925bSAq6XrB
        FFsinRx8ynFy5nE6j91MHzMq5R1/xv8WxVewVYjqTAhmg/oOIO95Sf86oWm4AVuq
        aVELjDSXaovXf0NyzoCimQT11fawg==
X-ME-Sender: <xms:9TyMXZt11jeohDVyrDqxSxP3k7liweD2g8QE_sbGrkIMtioM6fS66w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrfeefgdekvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefkuffhvfffjghftggfggfgsehtjeertddtreejnecuhfhrohhmpefkrghnucfm
    vghnthcuoehrrghvvghnsehthhgvmhgrfidrnhgvtheqnecuffhomhgrihhnpehsohhurh
    gtvgdrhhhmnecukfhppeduudekrddvtdelrdduieekrddvieenucfrrghrrghmpehmrghi
    lhhfrhhomheprhgrvhgvnhesthhhvghmrgifrdhnvghtnecuvehluhhsthgvrhfuihiivg
    eptd
X-ME-Proxy: <xmx:9TyMXS7re47Z6g3wHgKAsTrngMlGKEERRh741cL9PGc3go955to98g>
    <xmx:9TyMXTq5SI3hFp_AVpvdXNNkESyR-ualWrdU1Lhtn1V1ol-lG3Hs3g>
    <xmx:9TyMXWdp7OJBth1Q1uGXUPqp9cJ2aH4xGPYoVO3ky_pWJDkH1vIdHQ>
    <xmx:9TyMXatFDkUAV4TlAlFSVOLf_tBMTZBlUZM5t1NKZEKPVFmfi2_A4Q>
Received: from mickey.themaw.net (unknown [118.209.168.26])
        by mail.messagingengine.com (Postfix) with ESMTPA id BC9938005B;
        Thu, 26 Sep 2019 00:22:10 -0400 (EDT)
Message-ID: <f3238635ac226be0cc7306a1f8330311ae4ac0e1.camel@themaw.net>
Subject: Re: [REPOST PATCH v3 06/16] xfs: mount-api - make xfs_parse_param()
 take context .parse_param() args
From:   Ian Kent <raven@themaw.net>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Eric Sandeen <sandeen@sandeen.net>
Date:   Thu, 26 Sep 2019 12:22:06 +0800
In-Reply-To: <4ffaefd2ec14ea2379feb7aa78d8e29a872efc70.camel@themaw.net>
References: <156933112949.20933.12761540130806431294.stgit@fedora-28>
         <156933135322.20933.2166438700224340142.stgit@fedora-28>
         <20190924143725.GA17688@bfoster>
         <b9906ced64736b043b6537c61ce60182d92d63e8.camel@themaw.net>
         <20190925143309.GD21991@bfoster>
         <4ffaefd2ec14ea2379feb7aa78d8e29a872efc70.camel@themaw.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, 2019-09-26 at 10:57 +0800, Ian Kent wrote:
> On Wed, 2019-09-25 at 10:33 -0400, Brian Foster wrote:
> > On Wed, Sep 25, 2019 at 08:20:25AM +0800, Ian Kent wrote:
> > > On Tue, 2019-09-24 at 10:37 -0400, Brian Foster wrote:
> > > > On Tue, Sep 24, 2019 at 09:22:33PM +0800, Ian Kent wrote:
> > > > > Make xfs_parse_param() take arguments of the fs context
> > > > > operation
> > > > > .parse_param() in preparation for switching to use the file
> > > > > system
> > > > > mount context for mount.
> > > > > 
> > > > > The function fc_parse() only uses the file system context (fc
> > > > > here)
> > > > > when calling log macros warnf() and invalf() which in turn
> > > > > check
> > > > > only the fc->log field to determine if the message should be
> > > > > saved
> > > > > to a context buffer (for later retrival by userspace) or
> > > > > logged
> > > > > using printk().
> > > > > 
> > > > > Also the temporary function match_kstrtoint() is now unused,
> > > > > remove
> > > > > it.
> > > > > 
> > > > > Signed-off-by: Ian Kent <raven@themaw.net>
> > > > > ---
> > > > >  fs/xfs/xfs_super.c |  137 +++++++++++++++++++++++++++++++---
> > > > > --
> > > > > ----
> > > > > ------------
> > > > >  1 file changed, 81 insertions(+), 56 deletions(-)
> > > > > 
> > > > > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > > > > index b04aebab69ab..6792d46fa0be 100644
> > > > > --- a/fs/xfs/xfs_super.c
> > > > > +++ b/fs/xfs/xfs_super.c
> > > > > @@ -191,57 +191,60 @@ suffix_kstrtoint(const char *s,
> > > > > unsigned
> > > > > int
> > > > > base, int *res)
> > > > >  	return ret;
> > > > >  }
> > > > >  
> > > > ...
> > > > >  
> > > > >  STATIC int
> > > > >  xfs_parse_param(
> > > > ...
> > > > > -	switch (token) {
> > > > > +	opt = fs_parse(fc, &xfs_fs_parameters, param, &result);
> > > > > +	if (opt < 0) {
> > > > > +		/*
> > > > > +		 * If fs_parse() returns -ENOPARAM and the
> > > > > parameter
> > > > > +		 * is "source" the VFS needs to handle this
> > > > > option
> > > > > +		 * in order to boot otherwise use the default
> > > > > case
> > > > > +		 * below to handle invalid options.
> > > > > +		 */
> > > > > +		if (opt != -ENOPARAM ||
> > > > > +		    strcmp(param->key, "source") == 0)
> > > > > +			return opt;
> > > > 
> > > > Same question as before on this bit..
> > > 
> > > Your comment was:
> > > Why is this not something that is handled in core mount-api code?
> > > Every
> > > filesystem needs this logic in order to be a rootfs..?
> > > 
> > > I looked at the VFS code and was tempted to change it but it's
> > > all
> > > too
> > > easy to prevent the system from booting.
> > > 
> > 
> > Ok, so I'm not terribly familiar with the core mount code in the
> > first
> > place. Can you elaborate a bit on the where the whole "source"
> > thing
> > comes from and why/how it's necessary to boot?
> 
> Your not alone.
> 
> I've pondered over the VFS mount code fairly often over the years
> and I've not seen it before either.
> 
> About all I know is it's needed for rootfs, so I guess it's needed
> to resolve the boot device when no file system is yet mounted and
> a normal path walk can't be done.
> 
> > > The way the VFS looks to me it needs to give the file system a
> > > chance
> > > to handle the "source" option, if the file system ->parse_param()
> > > doesn't handle the option it "must" return -ENOPARAM so the VFS
> > > will
> > > test for and handle the "source" option.
> > > 
> > 
> > Do any existing filesystems handle this option? By handle, I mean
> > actually have to make some change, set some option, etc.
> 
> AFAIK very few file systems handle the option (and I suspect
> virtually none until perhaps recently) as David mentioned a
> couple that do yesterday on IRC.
> 
> Apparently there are a couple of file systems that want to
> take a non-standard mount source and resolve it to a kernel
> usable source for mounting.
> 
> I'm really not familiar with the details either so I'm making
> assumptions which might not be correct.
> 
> > > Having returned -ENOPARAM either the option is "source" or it's a
> > > real unknown option.
> > > 
> > > The choices are:
> > > 1) If it is the "source" option we will get a false positive
> > > unknown
> > > parameter message logged by our ->parse_param().
> > > 2) if it isn't the "source" option we will get an unknown
> > > parameter
> > > message from our ->parse_param() and an additional inconsistent
> > > format unknown parameter message from the VFS.
> > > 3) Check for the "source" parameter in our ->parse_param() and
> > > return without issuing a message so the VFS can handle the
> > > option,
> > > no duplicate message and no inconsistent logging.
> > > 
> > 
> > Hmm.. so we definitely don't want spurious unknown parameter
> > messages,
> > but I don't see how that leaves #3 as the only other option.
> 
> My reading of the the code (the mount-api code) is that if the
> .parse_param() method is defined it gives it a chance to handle
> the parameter whatever it is. Then .parase_param() must return
> -ENOPARAM for the VFS parameter handling function to then check
> for the "source" parameter, handle it or issue an unknown parameter
> message.
> 
> So, in order to return something other than -ENOPARAM, thereby
> avoiding the extra message, that must be done only if the parameter
> is not "source".
> 
> The problem is most file systems won't handle that parameter and
> can reasonably be expected to issue an error message when they
> encounter it but there are a couple that will want to handle it
> so .parse_param() must be given a chance to do so.
> 
> So it's not a problem specific to xfs.

But let's not forget why this is being done.

The reason is the "XFS: <message>" vs. "xfs: <message>" inconsistency
and the lack of kernel log messages if the fsxxx() system calls are
being used to perform the mount.

The other possibility is to do:
opt = fs_parse(fc, &xfs_fs_parameters, param, &result);
if (opt < 0)
	return opt;

and accept that the "default:" case that issues an error message for
an unknown parameter will never be reached and unknown parameter
messages will use fs_type ->name (lower case) for the log message.
And also accept that if the fsxxx() system calls are being used to
perform the mount parameter parsing messages won't be logged to
the kernel log at all.

The gfs2 mount-api code does this.

> 
> > Is param-key already filled in at that point? If so, couldn't we
> > set
> > a
> > flag or something on the context structure to signal that we don't
> > care
> > about the source option, so let the vfs handle it however it needs
> > to?
> 
> Maybe.
> 
> > If not, another option could be to define a helper function or
> > something
> > that the fs can call to determine whether an -ENOPARAM key is some
> > global option to be handled by a higher layer and so to not throw a
> > warning or whatever. That has the same logic as this patch, but is
> > still
> > better than open-coding "source" key checks all over the place
> > IMO. 
> 
> Maybe an additional fs_context_purpose needs to be defined, maybe
> FS_CONTEXT_FOR_ROOTFS for example.
> 
> That's probably the cleanest way to handle it, not sure it would
> properly cover the cases though.
> 
> That wouldn't be an entirely trivial change so David and Al would
> likely need to get involved and Linus would need to be willing to
> accept it.
> 
> > BTW, this all implies there is some reason for an fs to handle the
> > "source" option, so what happens if one actually does? ISTM the
> > ->parse_param() callout would return 0 and vfs_parse_fs_param()
> > would
> > skip its own update of fc->source. Hm?
> 
> As I understand it that's not a problem because the file system
> will need to have converted the parameter value to some "source"
> value usable by the kernel.
> 
> > Brian
> > 
> > > Suggestions on how to handle this better, a VFS patch perhaps?
> > > Suggestions David, Al?
> > > 
> > > > ...
> > > > > @@ -373,10 +374,16 @@ xfs_parseargs(
> > > > >  {
> > > > >  	const struct super_block *sb = mp->m_super;
> > > > >  	char			*p;
> > > > > -	substring_t		args[MAX_OPT_ARGS];
> > > > > -	int			dsunit = 0;
> > > > > -	int			dswidth = 0;
> > > > > -	uint8_t			iosizelog = 0;
> > > > > +	struct fs_context	fc;
> > > > > +	struct xfs_fs_context	context;
> > > > > +	struct xfs_fs_context	*ctx;
> > > > > +	int			ret;
> > > > > +
> > > > > +	memset(&fc, 0, sizeof(fc));
> > > > > +	memset(&context, 0, sizeof(context));
> > > > > +	fc.fs_private = &context;
> > > > > +	ctx = &context;
> > > > 
> > > > I think you mentioned this ctx/context pattern would be removed
> > > > from
> > > > v2..?
> > > 
> > > Except that, to minimise code churn the ctx variable is needed
> > > because it will be used in the end result.
> > > 
> > > I don't much like prefixing those references with &context even
> > > if some happen to go away later on, the additional local variable
> > > is clearer to read and provides usage consistency for the reader
> > > over the changes.
> > > 
> > > Ian
> > > > Brian
> > > > 
> > > > > +	fc.s_fs_info = mp;
> > > > >  
> > > > >  	/*
> > > > >  	 * set up the mount name first so all the errors will
> > > > > refer to
> > > > > the
> > > > > @@ -413,16 +420,33 @@ xfs_parseargs(
> > > > >  		goto done;
> > > > >  
> > > > >  	while ((p = strsep(&options, ",")) != NULL) {
> > > > > -		int		token;
> > > > > -		int		ret;
> > > > > +		struct fs_parameter	param;
> > > > > +		char			*value;
> > > > >  
> > > > >  		if (!*p)
> > > > >  			continue;
> > > > >  
> > > > > -		token = match_token(p, tokens, args);
> > > > > -		ret = xfs_parse_param(token, p, args, mp,
> > > > > -				      &dsunit, &dswidth,
> > > > > &iosizelog);
> > > > > -		if (ret)
> > > > > +		param.key = p;
> > > > > +		param.type = fs_value_is_string;
> > > > > +		param.string = NULL;
> > > > > +		param.size = 0;
> > > > > +
> > > > > +		value = strchr(p, '=');
> > > > > +		if (value) {
> > > > > +			*value++ = 0;
> > > > > +			param.size = strlen(value);
> > > > > +			if (param.size > 0) {
> > > > > +				param.string =
> > > > > kmemdup_nul(value,
> > > > > +							   para
> > > > > m.size,
> > > > > +							   GFP_
> > > > > KERNEL);
> > > > > +				if (!param.string)
> > > > > +					return -ENOMEM;
> > > > > +			}
> > > > > +		}
> > > > > +
> > > > > +		ret = xfs_parse_param(&fc, &param);
> > > > > +		kfree(param.string);
> > > > > +		if (ret < 0)
> > > > >  			return ret;
> > > > >  	}
> > > > >  
> > > > > @@ -435,7 +459,8 @@ xfs_parseargs(
> > > > >  		return -EINVAL;
> > > > >  	}
> > > > >  
> > > > > -	if ((mp->m_flags & XFS_MOUNT_NOALIGN) && (dsunit ||
> > > > > dswidth)) {
> > > > > +	if ((mp->m_flags & XFS_MOUNT_NOALIGN) &&
> > > > > +	    (ctx->dsunit || ctx->dswidth)) {
> > > > >  		xfs_warn(mp,
> > > > >  	"sunit and swidth options incompatible with the noalign
> > > > > option");
> > > > >  		return -EINVAL;
> > > > > @@ -448,28 +473,28 @@ xfs_parseargs(
> > > > >  	}
> > > > >  #endif
> > > > >  
> > > > > -	if ((dsunit && !dswidth) || (!dsunit && dswidth)) {
> > > > > +	if ((ctx->dsunit && !ctx->dswidth) || (!ctx->dsunit &&
> > > > > ctx-
> > > > > > dswidth)) {
> > > > >  		xfs_warn(mp, "sunit and swidth must be
> > > > > specified
> > > > > together");
> > > > >  		return -EINVAL;
> > > > >  	}
> > > > >  
> > > > > -	if (dsunit && (dswidth % dsunit != 0)) {
> > > > > +	if (ctx->dsunit && (ctx->dswidth % ctx->dsunit != 0)) {
> > > > >  		xfs_warn(mp,
> > > > >  	"stripe width (%d) must be a multiple of the stripe
> > > > > unit (%d)",
> > > > > -			dswidth, dsunit);
> > > > > +			ctx->dswidth, ctx->dsunit);
> > > > >  		return -EINVAL;
> > > > >  	}
> > > > >  
> > > > >  done:
> > > > > -	if (dsunit && !(mp->m_flags & XFS_MOUNT_NOALIGN)) {
> > > > > +	if (ctx->dsunit && !(mp->m_flags & XFS_MOUNT_NOALIGN))
> > > > > {
> > > > >  		/*
> > > > >  		 * At this point the superblock has not been
> > > > > read
> > > > >  		 * in, therefore we do not know the block size.
> > > > >  		 * Before the mount call ends we will convert
> > > > >  		 * these to FSBs.
> > > > >  		 */
> > > > > -		mp->m_dalign = dsunit;
> > > > > -		mp->m_swidth = dswidth;
> > > > > +		mp->m_dalign = ctx->dsunit;
> > > > > +		mp->m_swidth = ctx->dswidth;
> > > > >  	}
> > > > >  
> > > > >  	if (mp->m_logbufs != -1 &&
> > > > > @@ -491,18 +516,18 @@ xfs_parseargs(
> > > > >  		return -EINVAL;
> > > > >  	}
> > > > >  
> > > > > -	if (iosizelog) {
> > > > > -		if (iosizelog > XFS_MAX_IO_LOG ||
> > > > > -		    iosizelog < XFS_MIN_IO_LOG) {
> > > > > +	if (ctx->iosizelog) {
> > > > > +		if (ctx->iosizelog > XFS_MAX_IO_LOG ||
> > > > > +		    ctx->iosizelog < XFS_MIN_IO_LOG) {
> > > > >  			xfs_warn(mp, "invalid log iosize: %d
> > > > > [not %d-
> > > > > %d]",
> > > > > -				iosizelog, XFS_MIN_IO_LOG,
> > > > > +				ctx->iosizelog, XFS_MIN_IO_LOG,
> > > > >  				XFS_MAX_IO_LOG);
> > > > >  			return -EINVAL;
> > > > >  		}
> > > > >  
> > > > >  		mp->m_flags |= XFS_MOUNT_DFLT_IOSIZE;
> > > > > -		mp->m_readio_log = iosizelog;
> > > > > -		mp->m_writeio_log = iosizelog;
> > > > > +		mp->m_readio_log = ctx->iosizelog;
> > > > > +		mp->m_writeio_log = ctx->iosizelog;
> > > > >  	}
> > > > >  
> > > > >  	return 0;
> > > > > 

