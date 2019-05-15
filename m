Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3B331FBCF
	for <lists+linux-xfs@lfdr.de>; Wed, 15 May 2019 22:53:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726985AbfEOUxS (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 15 May 2019 16:53:18 -0400
Received: from mail-pg1-f170.google.com ([209.85.215.170]:38474 "EHLO
        mail-pg1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727416AbfEOUxR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 May 2019 16:53:17 -0400
Received: by mail-pg1-f170.google.com with SMTP id j26so380398pgl.5
        for <linux-xfs@vger.kernel.org>; Wed, 15 May 2019 13:53:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=CjEd0l7TQcFZybUEAgkgJ+cdKxWbTxTOyQsPQfwtUSE=;
        b=fBs1aFQiqeS+M3dJbS7JUSXpORS3D5uZSAGq/FMd0ukf3wc42DM8JnshFRc9hKWRyy
         lKhGGUsKRwbPPCVhz+gho9dbZfra241zHkGZ33/f9TxCLChQt46VFYb6j2sqK6rL6D5i
         cjg7YfIwzGLjBbh/XN1swM774ycmrOnLEPtLT0vlT7d3Vcb25ZtVU614vSfsCcqzbAfP
         IxqIbspf77/nsDuqYsqqg8w14dYxUTYQh/cvKh5ivKyTzbSL5yCxV6DCN63d45c3I/xS
         +u9boXnkO4mV+ZXdD1l+r1AJgRHBOXP+awvFJDWcNFrjqe5PCXXjTiqqeNOEFQWFXwHP
         FXCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=CjEd0l7TQcFZybUEAgkgJ+cdKxWbTxTOyQsPQfwtUSE=;
        b=S7Gmd2CrJUXBOLXn3Ob38bMLpgX5pu/ALIjHvsWAgacjlAIco4LbMcs7Vwlb5GE2D8
         UgIIQicEMDnxMXaMFgY8TSZ25GsOlIYkyWghSKVCqv5mTjeC41XxuE4JrG6uwsCUcwAc
         TDjQW4kANDeHCwc6tzfHEO9Wu702MujwIlV5uK1EGS/b9rx38Z9SitYlKvK/wKbVZROY
         a7Pw+IpScl8b8GNQi4rLlE+Dbmu+ncMoxGe/TXNlMG5gUdRNnVqlgQOku7SCW9hoXrwk
         3+RJOOr3fdJHWUL8bGJvf8fB6TfIxEuieFeu6PSIVxOLnXt2guG4BCgsdOfW28zWlSeI
         ozoA==
X-Gm-Message-State: APjAAAVoYnAJcu+GSyqn7HnTt5vblhozDwMCSMbwnzwwDukE5KyQjtt1
        ozOORPoVjh+sWF/yxGaBN5UmnA==
X-Google-Smtp-Source: APXvYqxWCS4pcsDQeKD68+mOifRP5huEkCQU6gla6luZRnemPduvc/j4L9XownpCLgCetqTLxYbgdQ==
X-Received: by 2002:a65:5c41:: with SMTP id v1mr44813861pgr.20.1557953596214;
        Wed, 15 May 2019 13:53:16 -0700 (PDT)
Received: from vader ([2620:10d:c090:180::cdd6])
        by smtp.gmail.com with ESMTPSA id y3sm3543875pge.7.2019.05.15.13.53.15
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 15 May 2019 13:53:15 -0700 (PDT)
Date:   Wed, 15 May 2019 13:53:14 -0700
From:   Omar Sandoval <osandov@osandov.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>
Subject: Re: xfsdump confused by ino's < root ino
Message-ID: <20190515205314.GA4599@vader>
References: <20190515204732.GA4466@vader>
 <f37ae69d-39a6-b2d0-1cc9-806d1d597086@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f37ae69d-39a6-b2d0-1cc9-806d1d597086@sandeen.net>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 15, 2019 at 03:51:07PM -0500, Eric Sandeen wrote:
> On 5/15/19 3:47 PM, Omar Sandoval wrote:
> > Hi,
> > 
> > We use xfsdump and xfsrestore (v3.1.7) to back up one of our storage
> > systems, and we ran into an issue where xfsdump prints the following for
> > a mount which isn't a bind mount:
> > 
> > /sbin/xfsdump: NOTE: root ino 136 differs from mount dir ino 256, bind mount?
> > 
> > Which also results in a crash from xfsrestore:
> > 
> > xfsrestore: tree.c:757: tree_begindir: Assertion `ino != persp->p_rootino || hardh == persp->p_rooth' failed.
> > 
> > Looking at [1], xfsdump uses bulkstat to get the minimum inode number on
> > the filesystem. But, at least one of our filesystems has a root inode
> > number of 256 and uses inode numbers 136-199, which tricks xfsdump into
> > thinking that the filesystem is bind mounted. Is this an invalid
> > assumption in xfsdump, or is it filesystem corruption?
> > 
> > Thanks!
> > 
> > 1: https://git.kernel.org/pub/scm/fs/xfs/xfsdump-dev.git/commit/?id=25195ebf107dc81b1b7cea1476764950e1d6cc9d
> 
> Yep, this is that heuristic going wrong.  We (I) didn't realize that we could ever
> get inode numbers allocated which were less than the root inode, but alas.
> 
> It's an invalid assumption in xfsdump.  I guess we need to find a way
> out of this ... the goal was to detect bind mounts, but apparently
> the situation you have is more common than expected (well, we expected
> it to not exist ...)
> 
> For now just using an older version of xfsdump should be a workaround,
> sorry about that.
> 
> -Eric

Great, thanks for the confirmation!
