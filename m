Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3D896D79F5
	for <lists+linux-xfs@lfdr.de>; Wed,  5 Apr 2023 12:40:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237825AbjDEKkE (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 5 Apr 2023 06:40:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237734AbjDEKkB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Apr 2023 06:40:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 290754ED0
        for <linux-xfs@vger.kernel.org>; Wed,  5 Apr 2023 03:39:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680691153;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sBkFB8fAWBN3smTHXDCk9Sdy8T63XJRLVaCuva4Dlh8=;
        b=IZ+80HHyflA0PA7JbWhpmorV4w26vqCt95GTbtlvNBsGt1R1wNgXV+S9kHlYM/EbLUW1p9
        gaCq4dIKPNr/PRlXUCsiQnZZM+ko1a6jwgAMCVBqJ6n9jT+5egVYiKZsJ53tz1GpGircO9
        Lp7SmEsPz5jWvo51V5SivpQin+t8f0A=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-614-2fTP_L_oOGG8OWmdzrf_aw-1; Wed, 05 Apr 2023 06:39:12 -0400
X-MC-Unique: 2fTP_L_oOGG8OWmdzrf_aw-1
Received: by mail-qk1-f200.google.com with SMTP id b142-20020ae9eb94000000b007486a8b9ae9so13357541qkg.11
        for <linux-xfs@vger.kernel.org>; Wed, 05 Apr 2023 03:39:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680691151;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sBkFB8fAWBN3smTHXDCk9Sdy8T63XJRLVaCuva4Dlh8=;
        b=PeulQM5D6U8mbxM2bHAxCrdMDmQFwxmYUrd9WRYLlgQM0pv/LLRSS/k7MzvJPBZjoH
         WY4gWFWbIesi0UVoFCOyUr/fxr10x/IujeDcb8qf/l+XEhdSQl8ETDZpagjnH6BIeV6Z
         pgUgdn0jgEUkF5H2Y9QY6WV5hZbl3ZaLUCGJ93OWvnaDDn/w4/aLm6vDmqdNMoEgHz1/
         u1uM9hn3mJSEptc1GxC0qiKSjoh9L0G0Ndh/GW+jHNihQfkKhnKd4CarKMhwTK5OwDcS
         PKwvBGMzPFb7FvK0Kks5ivJ/nzDmFhQBvVkbsRmFGPJPKETtBvacVlOsLLTk9XJFr/ks
         cKTg==
X-Gm-Message-State: AAQBX9dfLIm6AR2sjK+khCbBv2ag5b0d9rn4rYf4COemQS2O9ruY5aAL
        GdI0KegpMdofsSG74Cj7WhGoJ2JTf3LVWqWvBY/mr6DTIL+SQvwuaOmOAnXXapSKxmZzTg3Wcld
        3++K8afbCasyO9JCGdfE=
X-Received: by 2002:ac8:7e96:0:b0:3b6:323d:bcac with SMTP id w22-20020ac87e96000000b003b6323dbcacmr4150869qtj.32.1680691151322;
        Wed, 05 Apr 2023 03:39:11 -0700 (PDT)
X-Google-Smtp-Source: AKy350aYAf0v49WL6o/QofipBP4L4y6flhFYcYqZzNpajsevFC+xcPnxT0A0hb6dINwVq/YpVvvMSw==
X-Received: by 2002:ac8:7e96:0:b0:3b6:323d:bcac with SMTP id w22-20020ac87e96000000b003b6323dbcacmr4150840qtj.32.1680691150879;
        Wed, 05 Apr 2023 03:39:10 -0700 (PDT)
Received: from aalbersh.remote.csb ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id r206-20020a3744d7000000b0074a0051fcd4sm4331706qka.88.2023.04.05.03.39.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 03:39:10 -0700 (PDT)
Date:   Wed, 5 Apr 2023 12:39:04 +0200
From:   Andrey Albershteyn <aalbersh@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     djwong@kernel.org, dchinner@redhat.com, ebiggers@kernel.org,
        hch@infradead.org, linux-xfs@vger.kernel.org,
        fsverity@lists.linux.dev, rpeterso@redhat.com, agruenba@redhat.com,
        xiang@kernel.org, chao@kernel.org,
        damien.lemoal@opensource.wdc.com, jth@kernel.org,
        linux-erofs@lists.ozlabs.org, linux-btrfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        cluster-devel@redhat.com
Subject: Re: [PATCH v2 06/23] fsverity: add drop_page() callout
Message-ID: <20230405103904.2ugfxqmuuqjd7itz@aalbersh.remote.csb>
References: <20230404145319.2057051-1-aalbersh@redhat.com>
 <20230404145319.2057051-7-aalbersh@redhat.com>
 <20230404234019.GM3223426@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230404234019.GM3223426@dread.disaster.area>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Dave,

On Wed, Apr 05, 2023 at 09:40:19AM +1000, Dave Chinner wrote:
> On Tue, Apr 04, 2023 at 04:53:02PM +0200, Andrey Albershteyn wrote:
> > Allow filesystem to make additional processing on verified pages
> > instead of just dropping a reference. This will be used by XFS for
> > internal buffer cache manipulation in further patches. The btrfs,
> > ext4, and f2fs just drop the reference.
> > 
> > Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
> > ---
> >  fs/btrfs/verity.c         | 12 ++++++++++++
> >  fs/ext4/verity.c          |  6 ++++++
> >  fs/f2fs/verity.c          |  6 ++++++
> >  fs/verity/read_metadata.c |  4 ++--
> >  fs/verity/verify.c        |  6 +++---
> >  include/linux/fsverity.h  | 10 ++++++++++
> >  6 files changed, 39 insertions(+), 5 deletions(-)
> > 
> > diff --git a/fs/btrfs/verity.c b/fs/btrfs/verity.c
> > index c5ff16f9e9fa..4c2c09204bb4 100644
> > --- a/fs/btrfs/verity.c
> > +++ b/fs/btrfs/verity.c
> > @@ -804,10 +804,22 @@ static int btrfs_write_merkle_tree_block(struct inode *inode, const void *buf,
> >  			       pos, buf, size);
> >  }
> >  
> > +/*
> > + * fsverity op that releases the reference obtained by ->read_merkle_tree_page()
> > + *
> > + * @page:  reference to the page which can be released
> > + *
> > + */
> > +static void btrfs_drop_page(struct page *page)
> > +{
> > +	put_page(page);
> > +}
> > +
> >  const struct fsverity_operations btrfs_verityops = {
> >  	.begin_enable_verity     = btrfs_begin_enable_verity,
> >  	.end_enable_verity       = btrfs_end_enable_verity,
> >  	.get_verity_descriptor   = btrfs_get_verity_descriptor,
> >  	.read_merkle_tree_page   = btrfs_read_merkle_tree_page,
> >  	.write_merkle_tree_block = btrfs_write_merkle_tree_block,
> > +	.drop_page		 = &btrfs_drop_page,
> >  };
> 
> Ok, that's a generic put_page() call.
> 
> ....
> > diff --git a/fs/verity/verify.c b/fs/verity/verify.c
> > index f50e3b5b52c9..c2fc4c86af34 100644
> > --- a/fs/verity/verify.c
> > +++ b/fs/verity/verify.c
> > @@ -210,7 +210,7 @@ verify_data_block(struct inode *inode, struct fsverity_info *vi,
> >  		if (is_hash_block_verified(vi, hpage, hblock_idx)) {
> >  			memcpy_from_page(_want_hash, hpage, hoffset, hsize);
> >  			want_hash = _want_hash;
> > -			put_page(hpage);
> > +			inode->i_sb->s_vop->drop_page(hpage);
> >  			goto descend;
> 
> 			fsverity_drop_page(hpage);
> 
> static inline void
> fsverity_drop_page(struct inode *inode, struct page *page)
> {
> 	if (inode->i_sb->s_vop->drop_page)
> 		inode->i_sb->s_vop->drop_page(page);
> 	else
> 		put_page(page);
> }
> 
> And then you don't need to add the functions to each of the
> filesystems nor make an indirect call just to run put_page().

Sure, this makes more sense, thank you!

-- 
- Andrey

