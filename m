Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F31F464C19E
	for <lists+linux-xfs@lfdr.de>; Wed, 14 Dec 2022 02:04:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236731AbiLNBEF (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 13 Dec 2022 20:04:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237473AbiLNBEB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Dec 2022 20:04:01 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54D98642F
        for <linux-xfs@vger.kernel.org>; Tue, 13 Dec 2022 17:04:00 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id t11-20020a17090a024b00b0021932afece4so5456806pje.5
        for <linux-xfs@vger.kernel.org>; Tue, 13 Dec 2022 17:04:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zpUmdOuAvPLOXWGLYtoeozqDtZuDJ0T7JGbSJUQF3s0=;
        b=w8fNmYnh+h0hOxp0QP+B2r1PGviUfYD7Ji6odwgkRaS/3X8U3LXIZsh0RoIifjvqKy
         AZRDrRwXRdJHUD+Rzis2omEeMSfr+g3xkuKkPLJUmwkEFDecZ4bojz0ahoSTCu9Xy6rn
         29IVb7a3O1agDYwccPCL+FI4qEuyDtUzj+xsTSuRRJai6C22a9RqzegDsP/DxauYl70I
         idfPOhbf/OSo7m78CLlK1FIlS1VV1O2/VSGgDjFy1uwvbi1cpO6ttEWDdRCuFhPC4PSH
         z0mIxHD6SUpP8Bjcxui4xmBlA4n48wTqGMSM37Oy1b+isTJBdJVbPwP34S/BTS0v5mHQ
         kbUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zpUmdOuAvPLOXWGLYtoeozqDtZuDJ0T7JGbSJUQF3s0=;
        b=sMDYjaOLj9Hkyel7XsXJqaep3bVmAtLNZQerrBMNhz8rQz/HcnXf0KEHYEngjT2eCX
         rihN2YvJbwHYBBj7C1UU7DAq3KRa9f7ebYoZ7aCNTGGP2PCVcxbGafMHwmIkDdLLW+DU
         Zs5fdCJ49Q8WW1eQ10IunhmhNeMjaWzytxyvh3BnTo6yPQ1vBay0hvP6v3p6iAKTp+eT
         paq1Pi7h/w8aBekFjL8tsIh7Cb5X3o5Ik5VRqSIPKW30zFqZsPGFlCgG0upWpv3fUbA5
         hmnFlkklapBkMETckfi8tNv1ylWRqHcGJDzKoLjUt8SkGdlz97DP8LUZsqldeIAiivHE
         licA==
X-Gm-Message-State: ANoB5pmH0bthz/vyzg2NjHSutwGcBzEE3YGoZGUZhYdxu1DUTZ2SVYUD
        NBX3tINkpfpctCx0NnVFGA+VH6j4Ou2cxyoB
X-Google-Smtp-Source: AA0mqf7rAVl4WzMknooT99JjC0M0vKLT4ko1CgBWNeqep8OjR2PYpf+ZiORN7jKrVMH9M3T8UgpFdA==
X-Received: by 2002:a17:902:c3cd:b0:189:d3dc:a9c4 with SMTP id j13-20020a170902c3cd00b00189d3dca9c4mr21879575plj.36.1670979839841;
        Tue, 13 Dec 2022 17:03:59 -0800 (PST)
Received: from dread.disaster.area (pa49-181-138-158.pa.nsw.optusnet.com.au. [49.181.138.158])
        by smtp.gmail.com with ESMTPSA id 73-20020a63064c000000b0047915d582ccsm7335057pgg.20.2022.12.13.17.03.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Dec 2022 17:03:59 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1p5GBg-0089ay-Eh; Wed, 14 Dec 2022 12:03:56 +1100
Date:   Wed, 14 Dec 2022 12:03:56 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     Andrey Albershteyn <aalbersh@redhat.com>,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [RFC PATCH 03/11] xfs: add attribute type for fs-verity
Message-ID: <20221214010356.GC3600936@dread.disaster.area>
References: <20221213172935.680971-1-aalbersh@redhat.com>
 <20221213172935.680971-4-aalbersh@redhat.com>
 <733b882c-30fc-eea0-db01-55d25f272d92@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <733b882c-30fc-eea0-db01-55d25f272d92@redhat.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 13, 2022 at 11:43:42AM -0600, Eric Sandeen wrote:
> On 12/13/22 11:29 AM, Andrey Albershteyn wrote:
> > The Merkle tree pages and descriptor are stored in the extended
> > attributes of the inode. Add new attribute type for fs-verity
> > metadata. Skip fs-verity attributes for getfattr as it can not parse
> > binary page names.
> > 
> > Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
> 
> 
> >  DECLARE_EVENT_CLASS(xfs_attr_list_class,
> > diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
> > index 5b57f6348d630..acbfa29d04af0 100644
> > --- a/fs/xfs/xfs_xattr.c
> > +++ b/fs/xfs/xfs_xattr.c
> > @@ -237,6 +237,9 @@ xfs_xattr_put_listent(
> >  	if (flags & XFS_ATTR_PARENT)
> >  		return;
> >  
> > +	if (flags & XFS_ATTR_VERITY)
> > +		return;
> > +
> 
> Just a nitpick, but now that there are already 2 cases like this, I wonder
> if it would be wise to #define something like an XFS_ATTR_VISIBLE_MASK
> (or maybe XFS_ATTR_INTERNAL_MASK) and use that to decide, rather than
> testing each one individually?

Seems like a good idea to me.

There's also a couple of other spots that a comment about internal
vs externally visible xattr namespaces might be appropriate. e.g
xfs_attr_filter() in the ioctl code should never have internal xattr
namespaces added to it, and similarly a comment at the top of
fs/xfs/xfs_xattr.c that the interfaces implemented in the file are
only for exposing externally visible xattr namespaces to users.

That way it becomes more obvious that we handle internal vs external
xattr namespaces very differently.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
