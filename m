Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28B6680783
	for <lists+linux-xfs@lfdr.de>; Sat,  3 Aug 2019 19:46:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728371AbfHCRq6 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sat, 3 Aug 2019 13:46:58 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:35444 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728368AbfHCRq6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 3 Aug 2019 13:46:58 -0400
Received: by mail-lj1-f195.google.com with SMTP id x25so75817901ljh.2
        for <linux-xfs@vger.kernel.org>; Sat, 03 Aug 2019 10:46:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/p+KPdle0DrLRp9FDoP7922eNS2fl3+QvM+XMS49p18=;
        b=SfAIEP8dYPvPxBXGvQBzqUS9lK22Y5MDsLVnm8uG4aK+sHOgyUCamno+GINWxdqYox
         8nP56Kmrezz8GMbb+krCpuO2OAGa7SarLxIt6fujzohWqRlBdyC8WVFvnZaITEJHRhl0
         Bo0ewzFOwjQdmm1f+brtrHDR/gGM2HxyYU5/A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/p+KPdle0DrLRp9FDoP7922eNS2fl3+QvM+XMS49p18=;
        b=JUu3WGAVCyzwdspSvYHjrIApFp8fT9Am91/L72cU4y2g8uDFrBJmk17D3mnjEd7cgX
         uEiJY45vomUMeRfDCvoQaBET3QYjlczF3OmRho0C5Yzt9XZVxbjeK/TfvmuGrH7ljWti
         5I1sO2jgngEnAp9x1ERTswF5Atji4sZFiv8NXVFA1j/y6eyuiekIHWesfHqD9xDsclb1
         K1I04hXBCO9a9iZZ0acE6AEv0LZevdUr+YaMvIK3SYsaD9Cj+4eSZGgPxZ1m9PjvgsD4
         6lJouXtS1Eo7iXrPGWnYiUsl2GpnJe8HdwQzWDChnkje2Cg5RPLPp+Hma7fEIlHcNGFi
         qOuQ==
X-Gm-Message-State: APjAAAWcrkbuU6VBHpSr/j7eQtgHEtdeT8ES+k9A9WOFzHf8SY4K61/Y
        2Q0m44ugnvhGeGNAA1Ax0RTqkDcafoM=
X-Google-Smtp-Source: APXvYqzOm15zec8OlZnjerRJ7raoWSTzRrqkTOapIj3EcTS4b65HRkzaPuy1lLf6R1DEOQlDL1uhqA==
X-Received: by 2002:a2e:2c14:: with SMTP id s20mr12686415ljs.54.1564854415814;
        Sat, 03 Aug 2019 10:46:55 -0700 (PDT)
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com. [209.85.167.48])
        by smtp.gmail.com with ESMTPSA id j23sm13495473lfb.93.2019.08.03.10.46.54
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Sat, 03 Aug 2019 10:46:55 -0700 (PDT)
Received: by mail-lf1-f48.google.com with SMTP id s19so55119414lfb.9
        for <linux-xfs@vger.kernel.org>; Sat, 03 Aug 2019 10:46:54 -0700 (PDT)
X-Received: by 2002:a19:641a:: with SMTP id y26mr65259782lfb.29.1564854414577;
 Sat, 03 Aug 2019 10:46:54 -0700 (PDT)
MIME-Version: 1.0
References: <20190803163312.GK7138@magnolia>
In-Reply-To: <20190803163312.GK7138@magnolia>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 3 Aug 2019 10:46:38 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgg8Y=KxZaHy66BdOKKtDzQ_XN4sR6YWa00+v+06azt4A@mail.gmail.com>
Message-ID: <CAHk-=wgg8Y=KxZaHy66BdOKKtDzQ_XN4sR6YWa00+v+06azt4A@mail.gmail.com>
Subject: Re: [GIT PULL] xfs: cleanups for 5.3-rc3
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Linux List Kernel Mailing <linux-kernel@vger.kernel.org>,
        Eric Sandeen <sandeen@sandeen.net>,
        Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Aug 3, 2019 at 9:33 AM Darrick J. Wong <djwong@kernel.org> wrote:
>
> Here are a couple more bug fixes that trickled in since -rc1.  It's
> survived the usual xfstests runs and merges cleanly with this morning's
> master.  Please let me know if anything strange happens.

Hmm. This was tagged, but not signed like your usual tags are.

I've pulled it (I don't _require_ signed tags from kernel.org), but
would generally be much happier if I saw the signing too...

Thanks,

                 Linus
