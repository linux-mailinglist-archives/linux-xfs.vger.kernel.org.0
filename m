Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B70989249
	for <lists+linux-xfs@lfdr.de>; Sun, 11 Aug 2019 17:25:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726231AbfHKPZt (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 11 Aug 2019 11:25:49 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:37516 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726014AbfHKPZt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 11 Aug 2019 11:25:49 -0400
Received: by mail-pg1-f193.google.com with SMTP id d1so15433279pgp.4;
        Sun, 11 Aug 2019 08:25:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=aG3vF3j6P+NrbHtSDi3QMaBaH9WfE1W3eT76/hMH/x4=;
        b=SFIxDRAuTMUiAoX4M4Dq+SmxMisLCkl3HhV/GwAQBfBP7642BzmbW+2vDc3ebtUgML
         Ahn8AbxOvn/fdFoArHoJ8EddonX2CN37B8w7oC//z33tPIkcm6FS0X4rFNg0SaOnmLx9
         3XSLYN0Uhbb+6205g0rUqGXHeajplLdds+o66NMtqyM4mdxvDLUX3tRbjg2PrPziJjaI
         bALvRiHfjBCrq9kn8exFQx+5AOkhYYFLv3AU9ovxHjOht+l4x2TIxeR7Cy7NO5XPMcjk
         vW8p9P1jigmat+mILlh2YOViepQ5PR0m7I+57kNpzjw9vK4Riwotyigoyrhi0Bc3MPuP
         9LRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=aG3vF3j6P+NrbHtSDi3QMaBaH9WfE1W3eT76/hMH/x4=;
        b=YvUjg8iOHOy9sfpi1bQaKa55k8ickSakB6hrz6ztNKP1Gjfz1Idu46xPGBLuYIOFZZ
         lmRnA3wa4NxoeYpsQphTZx6C3LMvLlds8Eronh/I4+EtmpZxe5+ScQV0Z03vC64jvhMR
         pGdLbFmDpMUKtdxuTwRDSASaU9+GCz74sApq5g9ccJOh34/JX8FRMma81n3YbtyhxDlf
         KaS0Hty2fjxw9/vqmuzKQR2b3L1bLgBkf3Lg4hntug7SDTT8kQuY/h90UtAXAy30AtQf
         Am6FilDYSN+cqU8B0/vOj8WwKi8XIA/9tBIWX+ZSLvjZUJBxcfK25XHEZEdfw8reoUek
         x06g==
X-Gm-Message-State: APjAAAVDkCEQyLGRcBGfWaxamIthe4tQIPiTBDJYHVej3gtnmkctivht
        DqJi6/3J1gaqbZaGzu1/p5A=
X-Google-Smtp-Source: APXvYqytr8EyKCTQdg97yi31PZErCIbSmMAcUSY1q2NpuWzfT43J2rbmtuZyG3s49KTNiIXyd3CP7w==
X-Received: by 2002:a17:90a:8408:: with SMTP id j8mr7409424pjn.24.1565537148489;
        Sun, 11 Aug 2019 08:25:48 -0700 (PDT)
Received: from localhost ([178.128.102.47])
        by smtp.gmail.com with ESMTPSA id o130sm168143529pfg.171.2019.08.11.08.25.45
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 11 Aug 2019 08:25:47 -0700 (PDT)
Date:   Sun, 11 Aug 2019 23:25:39 +0800
From:   Eryu Guan <guaneryu@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH v2 1/3] common: filter aiodio dmesg after fs/iomap.c to
 fs/iomap/ move
Message-ID: <20190811152539.GE2665@desktop>
References: <156394156831.1850719.2997473679130010771.stgit@magnolia>
 <156394157450.1850719.464315342783936237.stgit@magnolia>
 <20190725180330.GH1561054@magnolia>
 <20190728113036.GO7943@desktop>
 <20190730005506.GC2345316@magnolia>
 <20190807014454.GA7135@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190807014454.GA7135@magnolia>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 06, 2019 at 06:44:54PM -0700, Darrick J. Wong wrote:
> On Mon, Jul 29, 2019 at 05:55:06PM -0700, Darrick J. Wong wrote:
> > On Sun, Jul 28, 2019 at 07:30:36PM +0800, Eryu Guan wrote:
> > > On Thu, Jul 25, 2019 at 11:03:30AM -0700, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > > 
> > > > Since the iomap code are moving to fs/iomap/ we have to add new entries
> > > > to the aiodio dmesg filter to reflect this.
> > > > 
> > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > > ---
> > > > v2: fix all the iomap regexes
> > > > ---
> > > >  common/filter |    9 +++++----
> > > >  1 file changed, 5 insertions(+), 4 deletions(-)
> > > > 
> > > > diff --git a/common/filter b/common/filter
> > > > index ed082d24..2e32ab10 100644
> > > > --- a/common/filter
> > > > +++ b/common/filter
> > > > @@ -550,10 +550,10 @@ _filter_aiodio_dmesg()
> > > >  	local warn2="WARNING:.*fs/xfs/xfs_file\.c:.*xfs_file_dio_aio_read.*"
> > > >  	local warn3="WARNING:.*fs/xfs/xfs_file\.c:.*xfs_file_read_iter.*"
> > > >  	local warn4="WARNING:.*fs/xfs/xfs_file\.c:.*xfs_file_aio_read.*"
> > > > -	local warn5="WARNING:.*fs/iomap\.c:.*iomap_dio_rw.*"
> > > > +	local warn5="WARNING:.*fs/iomap.*:.*iomap_dio_rw.*"
> > > >  	local warn6="WARNING:.*fs/xfs/xfs_aops\.c:.*__xfs_get_blocks.*"
> > > > -	local warn7="WARNING:.*fs/iomap\.c:.*iomap_dio_actor.*"
> > > > -	local warn8="WARNING:.*fs/iomap\.c:.*iomap_dio_complete.*"
> > > > +	local warn7="WARNING:.*fs/iomap.*:.*iomap_dio_actor.*"
> > > > +	local warn8="WARNING:.*fs/iomap.*:.*iomap_dio_complete.*"
> > > 
> > > I don't think we need new filters anymore, as commit 5a9d929d6e13
> > > ("iomap: report collisions between directio and buffered writes to
> > > userspace") replaced the WARN_ON with a pr_crit(). These filters are
> > > there only for old kernels.
> > 
> > Aaaaahh... but I /did/ write this patch because I kept hitting a WARNING
> > somewhere in the iomap directio code, and you know what?  It's one of the
> > warnings about a bogus iomap type in iomap_dio_actor.
> > 
> > I /think/ this is what happens when a buffered write sneaks in and
> > creates a delalloc reservation after the directio write has zapped the
> > page cache but before it actually starts iterating extents.
> > Consequently iomap_dio_actor sees the delalloc extent and WARNs.
> > 
> > Will have to recheck this, but maybe the kernel needs to deploy that
> > helper that 5a9d929d6e13 for that case.
> 
> Aha, I found it again.  The patch fixes failures in generic/446 when a
> directio write through iomap encounters a delalloc extent and triggers
> the WARN_ON_ONCE at the bottom of iomap_dio_actor:
> 
> WARNING: CPU: 2 PID: 1710922 at fs/iomap/direct-io.c:383 iomap_dio_actor+0x144/0x1a0

Yeah, I can hit it too when run generic/446 on XFS as well.

> 
> This can happen if a buffered write and a directio write race to fill a
> hole and the buffered write manages to stuff a delalloc reservation into
> the data mapping after the dio write has cleared the page cache.
> 
> We don't need the dio_warn_stale_pagecache() warning here because we
> fail the direct write and therefore do not write anything to disk.

IMHO, the v1 patch makes more sense in this case, as iomap_dio_actor is
the only place that could generate to-be-filtered warning now, warnings
in iomap_dio_rw and iomap_dio_complete are suppressed by commit
5a9d929d6e13.

Thanks,
Eryu

> 
> --D
> 
> > 
> > --D
> > 
> > > Thanks,
> > > Eryu
> > > 
> > > >  	local warn9="WARNING:.*fs/direct-io\.c:.*dio_complete.*"
> > > >  	sed -e "s#$warn1#Intentional warnings in xfs_file_dio_aio_write#" \
> > > >  	    -e "s#$warn2#Intentional warnings in xfs_file_dio_aio_read#" \
> > > > @@ -563,7 +563,8 @@ _filter_aiodio_dmesg()
> > > >  	    -e "s#$warn6#Intentional warnings in __xfs_get_blocks#" \
> > > >  	    -e "s#$warn7#Intentional warnings in iomap_dio_actor#" \
> > > >  	    -e "s#$warn8#Intentional warnings in iomap_dio_complete#" \
> > > > -	    -e "s#$warn9#Intentional warnings in dio_complete#"
> > > > +	    -e "s#$warn9#Intentional warnings in dio_complete#" \
> > > > +	    -e "s#$warn10#Intentional warnings in iomap_dio_actor#"
> > > >  }
> > > >  
> > > >  # We generate assert related WARNINGs on purpose and make sure test doesn't fail
