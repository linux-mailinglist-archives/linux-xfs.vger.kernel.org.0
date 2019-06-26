Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0F8455F73
	for <lists+linux-xfs@lfdr.de>; Wed, 26 Jun 2019 05:18:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726594AbfFZDSE (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 25 Jun 2019 23:18:04 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:36515 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726320AbfFZDSE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Jun 2019 23:18:04 -0400
Received: by mail-pl1-f194.google.com with SMTP id k8so584970plt.3;
        Tue, 25 Jun 2019 20:18:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=4eK7HKd4lzLGB3ERFDkswwWGwTMVkxUheabbqxQhK2I=;
        b=lHQvO58BRF9cNXfog7xa9amN/jvdGwLJ08JttYU8xN1ra4AI4aNs7tq5oe1Y84YIsf
         6YAp9zhhFkSNhu4n6I+22D9n9YGavHkm+zyuhi7f7ByTAlTwAopQY9zNLb8+djaamXan
         zrO18oXeOCiSFlG+6Pc2PpB5pPGJZNDdqFnzprTuNpwg69O+9jiZ8vuq3GozDk1XJoid
         efCueHggME4Fkj91ra5hZZ3Yu1uHRjFA3qlXMVPN7wPLLMMu+OFBKpQh6iyI+j6rKRPW
         8WX2tZgdAB65im8yfrj+W1fUL4WVjVs2TliOoeaYOLzoHhoTeAga6nzA/HaFKq7MabOR
         lMlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=4eK7HKd4lzLGB3ERFDkswwWGwTMVkxUheabbqxQhK2I=;
        b=D6E1UGFTnCsmXKCpNxnZO7dcPC6TJvSVNnMcMwKjPuM4t/ZBAcySpVZcmGtCGr2pf/
         04JlVnZXWIgTRGBCdtX5C1HMfkp7NbenrhbmuEhrfLmW2EDXmoABAWpGZn6z61u7JAcr
         O9uiOHtFNxfkM/h34V7JwqbIBiy5YrflwpFxpBvbzy/WoAUf8hX6qyd+xHs2z+u/jJgN
         G2CpjqewJ4VQs2xPHgNV3OhSzHyJJ+xhxAIDYFGiud+FsZ+BBNEsYWfN37nzuI5PW/s+
         DbPtL1j3P+wF/bPLxFcYiC3tHkyz5UU+tavR8yoxZOc8alnvz7K61fcMzW7HbPvSns/4
         l3sw==
X-Gm-Message-State: APjAAAWmjKmSAIs8yonuJpkiVvSbFejchy7M5Dtm7hDb3rTCkrYIjp17
        YGkCOJQZ0I5eiqfcNOO8FAE=
X-Google-Smtp-Source: APXvYqyBHtBqapZTozTVQnwsPzRWcG1hLl2sP5AinIp29xZK1mOLV/oFEbmraYn8oh0X6olSQPjTPg==
X-Received: by 2002:a17:902:b284:: with SMTP id u4mr2561631plr.36.1561519083244;
        Tue, 25 Jun 2019 20:18:03 -0700 (PDT)
Received: from localhost ([178.128.102.47])
        by smtp.gmail.com with ESMTPSA id b3sm16437690pfp.65.2019.06.25.20.18.01
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 25 Jun 2019 20:18:02 -0700 (PDT)
Date:   Wed, 26 Jun 2019 11:17:57 +0800
From:   Eryu Guan <guaneryu@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Theodore Ts'o <tytso@mit.edu>, Christoph Hellwig <hch@lst.de>,
        fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] shared/011: run on all file system that support cgroup
 writeback
Message-ID: <20190626031757.GB7943@desktop>
References: <20190624134407.21365-1-hch@lst.de>
 <20190624150839.GB6350@mit.edu>
 <20190624151910.GJ5387@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190624151910.GJ5387@magnolia>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 24, 2019 at 08:19:10AM -0700, Darrick J. Wong wrote:
> On Mon, Jun 24, 2019 at 11:08:39AM -0400, Theodore Ts'o wrote:
> > On Mon, Jun 24, 2019 at 03:44:07PM +0200, Christoph Hellwig wrote:
> > > Run the cgroup writeback test on xfs, for which I've just posted
> > > a patch to support cgroup writeback as well as ext2 and f2fs, which
> > > have supported cgroup writeback for a while now.
> > > 
> > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > > ---
> > >  tests/shared/011 | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/tests/shared/011 b/tests/shared/011
> > > index a0ac375d..96ce9d1c 100755
> > > --- a/tests/shared/011
> > > +++ b/tests/shared/011
> > > @@ -39,7 +39,7 @@ rm -f $seqres.full
> > >  # real QA test starts here
> > >  
> > >  # Modify as appropriate.
> > > -_supported_fs ext4 btrfs
> > > +_supported_fs ext2 ext4 f2fs btrfs xfs
> > 
> > Per my comments in another e-mail thread, given how many of the
> > primary file systems support cgroup-aware writeback, maybe we should
> > just remove the _supported_fs line and move this test to generic?
> > 
> > Whether we like it or not, there are more and more userspace tools
> > which assume that cgroup-aware writeback is a thing.
> > 
> > Alternatively, maybe we should have some standardized way so the
> > kernel can signal whether or not a particular mounted file system
> > supports cgroup-aware writeback?
> 
> I prefer this second option because I'd rather the test suite do the
> work to figure out if cgroup aware writeback is enabled and therefore
> worth testing rather than making everyone's QA department to add another
> conditional known-failure entry for when they want to run new fstests on
> some old LTS/distro kernel.

Agreed, a standard way to query cgroup-aware writeback support status
would be the best.

Thanks,
Eryu

> 
> --D
> 
> > 						- Ted
