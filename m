Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FCB853000
	for <lists+linux-xfs@lfdr.de>; Tue, 25 Jun 2019 12:35:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728743AbfFYKf6 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 25 Jun 2019 06:35:58 -0400
Received: from mail-yb1-f195.google.com ([209.85.219.195]:47057 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728499AbfFYKf5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Jun 2019 06:35:57 -0400
Received: by mail-yb1-f195.google.com with SMTP id p8so7190658ybo.13;
        Tue, 25 Jun 2019 03:35:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2bu5kzLpyeGkx9wL9fekyAamn8cx0mqTIQ5DK7aCeMw=;
        b=Xf8omi8dD9Qf7+NF00TsrDLbtitZFM0ekneB1R0qZArZWyCxlDkielePM/H57DzuIj
         pFt4+4DpnoPAfwBqx2nA6j+/WK9CtO65gkAYPUuTctLAFc76iScQ6LiCZevj9S/Q5dcp
         RfFMuYy4y5hWB2SbAqq0nWmmpW91hzErq+DXSDYOpjQIdJV0VsSYe2nC9yUxF/8iolhC
         aMSN1iw5Hd331498gQg2g2RunJD6DUz5Pltz1/XlBMB45lKRD3yr6hZaZOQYyBwYiV3M
         z17ETz/84XGvMXeeMOp38tSzXTg5aPzXTMT5QjrWchF1EqAldzOVKla1/yeAUH4imjhy
         pPAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2bu5kzLpyeGkx9wL9fekyAamn8cx0mqTIQ5DK7aCeMw=;
        b=NRtcue9/AoF61Nj8OSU8pB5xSaxHzXCi9U8mvx3w8LFjboCycHuA6itPac6t/Rszl3
         IIU/RoHBe58SUjQTBKvHvInV2ZwNiogDaR5zEfSbgk6ZZgnq5xGJudTj+MH+qI052Ped
         vhUKVCC8fHk9einFQCBCzoc2aqf00GsVJUTfbvINf1dptq0Cjckmyl0gAg4Q2MiKHGV/
         ILgrNnNBoFWUaZ4Z1NTqlHfWsMkxQgBmnkF8NGBiMjtxZqTQZ9bmvdcJ/2q6sye4drhF
         yl+9mT9jdMrSRD0u8e89xnrhO10JzHLB/4oJWWbQez/8lQIfpGtdU6FHgin6EHt6xICf
         fopw==
X-Gm-Message-State: APjAAAWkXHLM4yMzpBwwIsqkbDlFLWcGiw0i4zed/uq3eurb3XIut5I0
        4oYlQgllOL100cYSWRN6/dgoKzx+5yIeftTb+Yo=
X-Google-Smtp-Source: APXvYqwkje0+k7f+gSKrDpl2HJdsm40ZtsXZ1MULBoXUkFYx41yOObGGbrQslgjDT4xyWZRGSWFVcjKPe/v6lAeufvY=
X-Received: by 2002:a25:9208:: with SMTP id b8mr7684466ybo.428.1561458956906;
 Tue, 25 Jun 2019 03:35:56 -0700 (PDT)
MIME-Version: 1.0
References: <20190611153916.13360-1-amir73il@gmail.com> <20190611153916.13360-2-amir73il@gmail.com>
 <20190618090238.kmeocxasyxds7lzg@XZHOUW.usersys.redhat.com>
 <CAOQ4uxhePeTzR1t3e67xY+H0vcvh5toB3S=vdYVKm-skJrM00g@mail.gmail.com>
 <20190618150242.GA4576@mit.edu> <20190618151144.GB5387@magnolia> <5D11F781.4040906@cn.fujitsu.com>
In-Reply-To: <5D11F781.4040906@cn.fujitsu.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 25 Jun 2019 13:35:45 +0300
Message-ID: <CAOQ4uxgYApyiiSCWiCUJRgRoYYztMuON2d_mhLso-=DkqwNcbA@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] generic/554: test only copy to active swap file
To:     Yang Xu <xuyang2018.jy@cn.fujitsu.com>
Cc:     "Theodore Ts'o" <tytso@mit.edu>, darrick <darrick.wong@oracle.com>,
        Murphy Zhou <jencce.kernel@gmail.com>,
        fstests <fstests@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 25, 2019 at 1:29 PM Yang Xu <xuyang2018.jy@cn.fujitsu.com> wrote:
>
> on 2019/06/18 23:11, Darrick J. Wong  wrote:
>
> > On Tue, Jun 18, 2019 at 11:02:42AM -0400, Theodore Ts'o wrote:
> >> On Tue, Jun 18, 2019 at 12:16:45PM +0300, Amir Goldstein wrote:
> >>> On Tue, Jun 18, 2019 at 12:02 PM Murphy Zhou<jencce.kernel@gmail.com>  wrote:
> >>>> Would you mind updating sha1 after it get merged to Linus tree?
> >>>>
> >>>> That would be helpful for people tracking this issue.
> >>>>
> >>> This is the commit id in linux-next and expected to stay the same
> >>> when the fix is merged to Linus tree for 5.3.
> >> When I talked to Darrick last week, that was *not* the sense I got
> >> from him.  It's not necessarily guaranteed to be stable just yet...
> > Darrick hasn't gotten any complaints about the copy-file-range-fixes
> > branch (which has been in for-next for a week now), so he thinks that
> > commit id (a31713517dac) should be stable from here on out.
> >
> > (Note that doesn't guarantee that Linus will pull said branch...)
> >
> > --D
> Hi Amir
>
> The kernel fix commit message is right?  :-)  Because when I backport this patch into 5.2.0-rc6+ kernel,
> generic/554(553) also fails, it should be commit a5544984af4 (vfs: add missing checks to copy_file_range).
> By the way, a31713517dac ("vfs: introduce generic_file_rw_checks()") doesn't check for immutable and swap file.
>
> I think we can change this message after the fix is merged to Linus tree for 5.3.  What do you think about it?

You are right. Documented commit is wrong.
The correct commit in linux-next is:
96e6e8f4a68d ("vfs: add missing checks to copy_file_range")

(Not sure where you got a5544984af4 from?)
Let's fix that after the commit is upstream.

Obviously, you would need to backport the entire series and not just this
one commit to stable kernel.

Thanks,
Amir.
