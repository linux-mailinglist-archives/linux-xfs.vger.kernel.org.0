Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 449CD72CB5F
	for <lists+linux-xfs@lfdr.de>; Mon, 12 Jun 2023 18:20:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235688AbjFLQUo (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 12 Jun 2023 12:20:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235724AbjFLQUn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Jun 2023 12:20:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D624172B
        for <linux-xfs@vger.kernel.org>; Mon, 12 Jun 2023 09:19:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686586798;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LDCO0K8HODdAFd92npjPxBs4RzuiWq9P8qLQjLYAYLU=;
        b=DcLQv4z4dEK1lRPxy3i/BmTHRS5XdR23hYJwUVJhfHoK7s71qeXuGjreKzZQ6rPXNVD+NF
        QR6n+ZwlsdFvCyT0Jy/Tm/Iif9OMHlG/fSnk5YhgsXvNQ8z5tUbpeiTWOaDr8rCY5zQVyj
        2eNceo6B5PXDTUckaqrMtx4Yi2my6Lc=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-628-4Yks1KDTMS2whqIvOoVeyw-1; Mon, 12 Jun 2023 12:19:57 -0400
X-MC-Unique: 4Yks1KDTMS2whqIvOoVeyw-1
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-1b3c575f0c8so7797295ad.3
        for <linux-xfs@vger.kernel.org>; Mon, 12 Jun 2023 09:19:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686586795; x=1689178795;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LDCO0K8HODdAFd92npjPxBs4RzuiWq9P8qLQjLYAYLU=;
        b=I0WfAnIN7kwF6XZnLDqGL7N2ocMWsKTqavFII28BZmlebkL0LztE0Rb6ClAuUvwH5S
         wetuFXx97p5hemr7ikAE4YR7bM1Ag0pKuWhAbO4r/dsTTj87z1rB+4MklqPtgD1f+sqQ
         NsmH3J3izzXHsQ4GvqxLe9UMV2Zj/zsMk1EwDdpDM/N9rkyde8OVHPaxHFi7/N1VViEI
         t/tcbBgt2Sw2zVMdftVprWpZFV9873n+4hWo65CPrtTj+tTmCX2Th6zMWKXg4V23HbAY
         c2ZkidGE+zlXnUiOHJ/zWrjjqt6/PQnCxEvOIHzG5GBnc3RaNXDBxWXl2aHzTHf5aruk
         lHcA==
X-Gm-Message-State: AC+VfDwLl8E/wCfUnOQAJBFLbHSMyzxboswbVaREVkGUdcCTI26091VJ
        4yTGuP7Z9aSMtJPjbIJ4z/DmtpXB2wR7AaATAJ3lNWgA0uYoztfqANNwrpx9XgkSdPAvVLCriEk
        d7e/rNJqF7awtT3am/jCz5dJbL6KPPvD46P/r
X-Received: by 2002:a17:902:be0e:b0:1a6:46f2:4365 with SMTP id r14-20020a170902be0e00b001a646f24365mr6855072pls.30.1686586795656;
        Mon, 12 Jun 2023 09:19:55 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6y3GyAfFuWmHoPDzo6wCeBPeyUbu73Mka1gidkNWiwrSmINPzjBoEiCM9cNiXFXICBmANrXR6Qu16tE7/lCRA=
X-Received: by 2002:a17:902:be0e:b0:1a6:46f2:4365 with SMTP id
 r14-20020a170902be0e00b001a646f24365mr6855051pls.30.1686586795345; Mon, 12
 Jun 2023 09:19:55 -0700 (PDT)
MIME-Version: 1.0
References: <CAHc6FU7Hv71ujeb9oEVOD+bpddMMT0KY+KKUp881Am15u-OVvg@mail.gmail.com>
 <87ilbshf56.fsf@doe.com> <20230612161617.GE11441@frogsfrogsfrogs>
In-Reply-To: <20230612161617.GE11441@frogsfrogsfrogs>
From:   Andreas Gruenbacher <agruenba@redhat.com>
Date:   Mon, 12 Jun 2023 18:19:43 +0200
Message-ID: <CAHc6FU78K_jR3Fj6g8Eu78T8=L1xY4CirNiofs7y-n-uRcLXcg@mail.gmail.com>
Subject: Re: [PATCHv9 3/6] iomap: Add some uptodate state handling helpers for
 ifs state bitmap
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Ritesh Harjani <ritesh.list@gmail.com>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        Dave Chinner <david@fromorbit.com>,
        Brian Foster <bfoster@redhat.com>,
        Ojaswin Mujoo <ojaswin@linux.ibm.com>,
        Disha Goel <disgoel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 12, 2023 at 6:16=E2=80=AFPM Darrick J. Wong <djwong@kernel.org>=
 wrote:
> On Mon, Jun 12, 2023 at 09:00:29PM +0530, Ritesh Harjani wrote:
> > Andreas Gruenbacher <agruenba@redhat.com> writes:
> >
> > > On Sat, Jun 10, 2023 at 1:39=E2=80=AFPM Ritesh Harjani (IBM)
> > > <ritesh.list@gmail.com> wrote:
> > >> This patch adds two of the helper routines iomap_ifs_is_fully_uptoda=
te()
> > >> and iomap_ifs_is_block_uptodate() for managing uptodate state of
> > >> ifs state bitmap.
> > >>
> > >> In later patches ifs state bitmap array will also handle dirty state=
 of all
> > >> blocks of a folio. Hence this patch adds some helper routines for ha=
ndling
> > >> uptodate state of the ifs state bitmap.
> > >>
> > >> Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
> > >> ---
> > >>  fs/iomap/buffered-io.c | 28 ++++++++++++++++++++--------
> > >>  1 file changed, 20 insertions(+), 8 deletions(-)
> > >>
> > >> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> > >> index e237f2b786bc..206808f6e818 100644
> > >> --- a/fs/iomap/buffered-io.c
> > >> +++ b/fs/iomap/buffered-io.c
> > >> @@ -43,6 +43,20 @@ static inline struct iomap_folio_state *iomap_get=
_ifs(struct folio *folio)
> > >>
> > >>  static struct bio_set iomap_ioend_bioset;
> > >>
> > >> +static inline bool iomap_ifs_is_fully_uptodate(struct folio *folio,
> > >> +                                              struct iomap_folio_st=
ate *ifs)
> > >> +{
> > >> +       struct inode *inode =3D folio->mapping->host;
> > >> +
> > >> +       return bitmap_full(ifs->state, i_blocks_per_folio(inode, fol=
io));
> > >
> > > This should be written as something like:
> > >
> > > unsigned int blks_per_folio =3D i_blocks_per_folio(inode, folio);
> > > return bitmap_full(ifs->state + IOMAP_ST_UPTODATE * blks_per_folio,
> > > blks_per_folio);
> > >
> >
> > Nah, I feel it is not required... It make sense when we have the same
> > function getting use for both "uptodate" and "dirty" state.
> > Here the function anyways operates on uptodate state.
> > Hence I feel it is not required.
>
> Honestly I thought that enum-for-bits thing was excessive considering
> that ifs has only two state bits.  But, since you included it, it
> doesn't make much sense /not/ to use it here.
>
> OTOH, if you disassemble the object code and discover that the compiler
> *isn't* using constant propagation to simplify the object code, then
> yes, that would be a good reason to get rid of it.

I've checked on x86_64 earlier and there at least, the enum didn't
affect the produced code at all.

Andreas

> --D
>
> > >> +}
> > >> +
> > >> +static inline bool iomap_ifs_is_block_uptodate(struct iomap_folio_s=
tate *ifs,
> > >> +                                              unsigned int block)
> > >> +{
> > >> +       return test_bit(block, ifs->state);
> > >
> > > This function should be called iomap_ifs_block_is_uptodate(), and
> > > probably be written as follows, passing in the folio as well (this
> > > will optimize out, anyway):
> > >
> > > struct inode *inode =3D folio->mapping->host;
> > > unsigned int blks_per_folio =3D i_blocks_per_folio(inode, folio);
> > > return test_bit(block, ifs->state + IOMAP_ST_UPTODATE * blks_per_foli=
o);
> > >
> >
> > Same here.
> >
> > -ritesh
>

