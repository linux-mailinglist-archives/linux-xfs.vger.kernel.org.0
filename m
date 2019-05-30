Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E89962F7D9
	for <lists+linux-xfs@lfdr.de>; Thu, 30 May 2019 09:20:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727702AbfE3HUe (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 30 May 2019 03:20:34 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:36778 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727680AbfE3HUc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 May 2019 03:20:32 -0400
Received: by mail-pf1-f193.google.com with SMTP id u22so3384426pfm.3;
        Thu, 30 May 2019 00:20:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=5bQZx0lTD0Wp8nRxyWlda6WLRYv3keCk0Iag4Fad1eE=;
        b=Db36g+eBk7FkMnTHpNoxRl+QmI5ocwFtIrKBAY1wvZT7JSLGXsb9s9At6tlS4E9yOM
         aXWlaOFDWkhmWB733XmG50XrWUVb6BnZqjoq598NzrRSEs5zIzgcVCKcKO5Z46Nvqp3J
         bKWSf7IE6B96oowZR8uMfoCw1+42/63Q35YkR++SDdkHDmmDXuf5BkHrS+7EzrLFJfah
         tzhukMAWgxog2TwQ/YmIHCmbapHThFgCpN+KwUsUHFnXIYLG4lYxsNstUz8cFR/Qce2D
         q1xRM7j9jQAe4WQS0wsxH0K8RYoX8QvUcONW0Rr6rS4vIQ4fKb1KkKlck+mUsD5SoWUJ
         H4Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=5bQZx0lTD0Wp8nRxyWlda6WLRYv3keCk0Iag4Fad1eE=;
        b=mcoqvh90fet83/iRRtcPN7OS9sFUtVttEMmq0EGmE1urStpqedGIkDdz+kUyIPt+D3
         lgonxTPjjZjrwQpxdQtlJ4b7r2OeyZlWpYUz0n5B36FPoR1DwW42If5k7yTZaQ2loOcu
         o5Md60UG9Sss9Oh3pzPyZ+UregzU38hdCYY3h1xHxnUjdt129HANS2LrDBWiRq36KjcT
         C3Ky8sncgZjUIGpWwQ80bC/SCIBe3FVR+pwgTQ6IzlaQIVIelCbGzknMAXfnTdo1s0U+
         IfhlSzUhHtPfI+RX2prEKEj+fnGQpmKC/g+bBlwAesV0+4cYwID+6YPZ3y+md4Ks+e7p
         UWlg==
X-Gm-Message-State: APjAAAV//fshkhaj1+TxzP8tMbJsuUfChhWwPTxY13BFm9GUPL8e1W23
        xIBGOmZUgDxrJdHuu/PTTlcBFomE+wE=
X-Google-Smtp-Source: APXvYqzxMwt+pIBAqmg5KiusiWoAVktQsqkpIxUmOoaki31LsUlh+ISvdUWF1CwHpgTzBKTmFqkfUQ==
X-Received: by 2002:a63:e50c:: with SMTP id r12mr2436448pgh.284.1559200831543;
        Thu, 30 May 2019 00:20:31 -0700 (PDT)
Received: from localhost ([128.199.137.77])
        by smtp.gmail.com with ESMTPSA id h3sm3440781pfq.66.2019.05.30.00.20.28
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 30 May 2019 00:20:30 -0700 (PDT)
Date:   Thu, 30 May 2019 15:20:23 +0800
From:   Eryu Guan <guaneryu@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH ] xfs: check for COW overflows in i_delayed_blks
Message-ID: <20190530072023.GR15846@desktop>
References: <155839150599.62947.16097306072591964009.stgit@magnolia>
 <155839151219.62947.9627045046429149685.stgit@magnolia>
 <20190526142735.GP15846@desktop>
 <20190528170132.GA5231@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190528170132.GA5231@magnolia>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 28, 2019 at 10:01:32AM -0700, Darrick J. Wong wrote:
> On Sun, May 26, 2019 at 10:27:35PM +0800, Eryu Guan wrote:
> > On Mon, May 20, 2019 at 03:31:52PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > With the new copy on write functionality it's possible to reserve so
> > > much COW space for a file that we end up overflowing i_delayed_blks.
> > > The only user-visible effect of this is to cause totally wrong i_blocks
> > > output in stat, so check for that.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > I hit xfs_db killed by OOM killer (2 vcpu, 8G memory kvm guest) when
> > trying this test and the test takes too long time (I changed the fs size
> > from 300T to 300G and tried a test run), perhaps that's why you don't
> > put it in auto group?
> 
> Oh.  Right.  I forget that I patched out xfs_db from
> check_xfs_filesystem on my dev tree years ago.
> 
> Um... do we want to remove xfs_db from the check function?  Or just open
> code a call to xfs_repair $SCRATCH_MNT/a.img at the end of the test?

If XFS maintainer removes the xfs_check call in _check_xfs_filesystem(),
I'd say I like to see it being removed :)

> 
> As for the 300T size, the reason I picked that is to force the
> filesystem to have large enough AGs to support the maximum cowextsize
> hint.  I'll see if it still works with a 4TB filesystem.

After removeing the xfs_db call, I can finish the test within 20s on the
same test vm, and a.img only takes 159MB space on $SCRATCH_DEV, so I
think 300T fs size is fine.

Thanks,
Eryu
