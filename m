Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C3106E63AD
	for <lists+linux-xfs@lfdr.de>; Tue, 18 Apr 2023 14:42:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231897AbjDRMm3 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 18 Apr 2023 08:42:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231895AbjDRMm1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Apr 2023 08:42:27 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F0CB1447B
        for <linux-xfs@vger.kernel.org>; Tue, 18 Apr 2023 05:42:16 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id ud9so72608771ejc.7
        for <linux-xfs@vger.kernel.org>; Tue, 18 Apr 2023 05:42:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1681821735; x=1684413735;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=4zZaPJzshEnDWklD8XmiXWEZ2laXp6xq95Vi3BXmH3M=;
        b=Yh8+fClk+o4D4gN8FJFTMYOCEQykSAR2N3lXlhxFRH819DbCxelSwny3X6namwWRKU
         GxdHB/kxfY5kKPhXMtKtAtd/y/y32MzJB8S7woLN7Gss/q2DnFE02D3CbBe2PY+vXqyR
         0xkkpGaSKQIswmlxjMdxhpyCvsd/ciuJaVhWY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681821735; x=1684413735;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4zZaPJzshEnDWklD8XmiXWEZ2laXp6xq95Vi3BXmH3M=;
        b=Whhp2PD0/fa70E0Ii1xHm6rfUxdfKCZG6U75YkodTbVvoM+sicixIZ2yDSsnTTv0MC
         rKy+1iFeGvWniFIogw3hWhR8NrNuY224VA4Auhr/RhyccF8XTBD2hodTk/csXTC3lxwz
         dPFE6zcfo9tNoLYsV8IMH1PW8FGyzHye7NYR3j8yk2j7YjRu5EMF4qe2DIaVLdj2cmQ1
         oV90CyLaGWbOQAIcTr4YpResM0NbguPKQFLdJc6bnqZbghGLa+DZXWaMVaGlw7kETBVr
         b7N2YF3RTJN6kkW1qSYhWP9l5XTUT+t+zCHUUgqJoVGcJfzi60CFq0mch1SU8Hld/YSt
         LavA==
X-Gm-Message-State: AAQBX9fGl1qYy+Zgv2oVh3nmuvMI/wvJZAaGIbdBTbk07nyEs43F5SM6
        Ntjo1dTRX/vBnMIU9ezHYP3HBjgq6ReOinl7QNrITg==
X-Google-Smtp-Source: AKy350aIbPYzblpBDLhTaHf97THqFbwgAZLWaT7+qiwAtSmr5pAzCF+5AYXPjoVDIlMF1Xfcxyo5b02deZsR10nPfQ4=
X-Received: by 2002:a17:907:3f24:b0:94f:19b5:bafd with SMTP id
 hq36-20020a1709073f2400b0094f19b5bafdmr12536182ejc.42.1681821734894; Tue, 18
 Apr 2023 05:42:14 -0700 (PDT)
MIME-Version: 1.0
References: <20230307172015.54911-2-axboe@kernel.dk> <20230412134057.381941-1-bschubert@ddn.com>
 <CAJfpegt_ZCVodOhQCzF9OqKnCr65mKax0Gu4OTN8M51zP+8TcA@mail.gmail.com>
 <ZDjggMCGautPUDpW@infradead.org> <20230414153612.GB360881@frogsfrogsfrogs> <cfeade24-81fc-ab73-1fd9-89f12a402486@kernel.dk>
In-Reply-To: <cfeade24-81fc-ab73-1fd9-89f12a402486@kernel.dk>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Tue, 18 Apr 2023 14:42:03 +0200
Message-ID: <CAJfpegvv-SPJRjWrR_+JY-H=xmYq0pnTfAtj-N8kG7AnQvWd=w@mail.gmail.com>
Subject: Re: [PATCH 1/2] fs: add FMODE_DIO_PARALLEL_WRITE flag
To:     Jens Axboe <axboe@kernel.dk>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Bernd Schubert <bschubert@ddn.com>, io-uring@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-xfs@vger.kernel.org, dsingh@ddn.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, 15 Apr 2023 at 15:15, Jens Axboe <axboe@kernel.dk> wrote:

> Yep, that is pretty much it. If all writes to that inode are serialized
> by a lock on the fs side, then we'll get a lot of contention on that
> mutex. And since, originally, nothing supported async writes, everything
> would get punted to the io-wq workers. io_uring added per-inode hashing
> for this, so that any punt to io-wq of a write would get serialized.
>
> IOW, it's an efficiency thing, not a correctness thing.

We could still get a performance regression if the majority of writes
still trigger the exclusive locking.  The questions are:

 - how often does that happen in real life?
 - how bad the performance regression would be?

Without first attempting to answer those questions, I'd be reluctant
to add  FMODE_DIO_PARALLEL_WRITE to fuse.

Thanks,
Miklos
