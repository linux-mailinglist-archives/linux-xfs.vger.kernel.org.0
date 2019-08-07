Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A19F5841BD
	for <lists+linux-xfs@lfdr.de>; Wed,  7 Aug 2019 03:45:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727823AbfHGBo7 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 6 Aug 2019 21:44:59 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:48316 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727710AbfHGBo7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Aug 2019 21:44:59 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x771iKsi087308;
        Wed, 7 Aug 2019 01:44:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=ajai3h0q8HudVrXIim8+fTSGUHmLG+uDhEzS5DeX8+w=;
 b=Wa9psrvWwH3x3a36TITwaM3EpitQeweOhrqGueKdrdtBK3CEBW7tRWUm81aywNWUkhB9
 ZDr5wJF5Iq+YRj31LpXrG5xxDPFhmjHUOoIAxqyuu/L1mPT6IHppHyPkYuoP5QBtxUoP
 08WOUkNcRqF86T4LqBLnkKaDT7uUZkSHi7+uIpoPqxOfTTcQgKbh07Qz4zvtU/2xWXJR
 zHUAi/a+dgjornFr0ItXjvaMJAvLDSeLcEjeXfMkMHEbWK/0RaZsgskdyMXWbVup9pXg
 Gjs9MOrgium+iz394YB/ofLQCzry73Uu7AarnSg3YYygIO0L9VPpHw0SRvY5e+OteXaN HA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2u51pu1fye-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 07 Aug 2019 01:44:57 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x771cJ3H036334;
        Wed, 7 Aug 2019 01:44:56 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2u7577g5t9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 07 Aug 2019 01:44:56 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x771itgf021531;
        Wed, 7 Aug 2019 01:44:55 GMT
Received: from localhost (/10.159.143.251)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 06 Aug 2019 18:44:55 -0700
Date:   Tue, 6 Aug 2019 18:44:54 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH v2 1/3] common: filter aiodio dmesg after fs/iomap.c to
 fs/iomap/ move
Message-ID: <20190807014454.GA7135@magnolia>
References: <156394156831.1850719.2997473679130010771.stgit@magnolia>
 <156394157450.1850719.464315342783936237.stgit@magnolia>
 <20190725180330.GH1561054@magnolia>
 <20190728113036.GO7943@desktop>
 <20190730005506.GC2345316@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190730005506.GC2345316@magnolia>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9341 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908070015
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9341 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908070016
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 29, 2019 at 05:55:06PM -0700, Darrick J. Wong wrote:
> On Sun, Jul 28, 2019 at 07:30:36PM +0800, Eryu Guan wrote:
> > On Thu, Jul 25, 2019 at 11:03:30AM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > Since the iomap code are moving to fs/iomap/ we have to add new entries
> > > to the aiodio dmesg filter to reflect this.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---
> > > v2: fix all the iomap regexes
> > > ---
> > >  common/filter |    9 +++++----
> > >  1 file changed, 5 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/common/filter b/common/filter
> > > index ed082d24..2e32ab10 100644
> > > --- a/common/filter
> > > +++ b/common/filter
> > > @@ -550,10 +550,10 @@ _filter_aiodio_dmesg()
> > >  	local warn2="WARNING:.*fs/xfs/xfs_file\.c:.*xfs_file_dio_aio_read.*"
> > >  	local warn3="WARNING:.*fs/xfs/xfs_file\.c:.*xfs_file_read_iter.*"
> > >  	local warn4="WARNING:.*fs/xfs/xfs_file\.c:.*xfs_file_aio_read.*"
> > > -	local warn5="WARNING:.*fs/iomap\.c:.*iomap_dio_rw.*"
> > > +	local warn5="WARNING:.*fs/iomap.*:.*iomap_dio_rw.*"
> > >  	local warn6="WARNING:.*fs/xfs/xfs_aops\.c:.*__xfs_get_blocks.*"
> > > -	local warn7="WARNING:.*fs/iomap\.c:.*iomap_dio_actor.*"
> > > -	local warn8="WARNING:.*fs/iomap\.c:.*iomap_dio_complete.*"
> > > +	local warn7="WARNING:.*fs/iomap.*:.*iomap_dio_actor.*"
> > > +	local warn8="WARNING:.*fs/iomap.*:.*iomap_dio_complete.*"
> > 
> > I don't think we need new filters anymore, as commit 5a9d929d6e13
> > ("iomap: report collisions between directio and buffered writes to
> > userspace") replaced the WARN_ON with a pr_crit(). These filters are
> > there only for old kernels.
> 
> Aaaaahh... but I /did/ write this patch because I kept hitting a WARNING
> somewhere in the iomap directio code, and you know what?  It's one of the
> warnings about a bogus iomap type in iomap_dio_actor.
> 
> I /think/ this is what happens when a buffered write sneaks in and
> creates a delalloc reservation after the directio write has zapped the
> page cache but before it actually starts iterating extents.
> Consequently iomap_dio_actor sees the delalloc extent and WARNs.
> 
> Will have to recheck this, but maybe the kernel needs to deploy that
> helper that 5a9d929d6e13 for that case.

Aha, I found it again.  The patch fixes failures in generic/446 when a
directio write through iomap encounters a delalloc extent and triggers
the WARN_ON_ONCE at the bottom of iomap_dio_actor:

WARNING: CPU: 2 PID: 1710922 at fs/iomap/direct-io.c:383 iomap_dio_actor+0x144/0x1a0

This can happen if a buffered write and a directio write race to fill a
hole and the buffered write manages to stuff a delalloc reservation into
the data mapping after the dio write has cleared the page cache.

We don't need the dio_warn_stale_pagecache() warning here because we
fail the direct write and therefore do not write anything to disk.

--D

> 
> --D
> 
> > Thanks,
> > Eryu
> > 
> > >  	local warn9="WARNING:.*fs/direct-io\.c:.*dio_complete.*"
> > >  	sed -e "s#$warn1#Intentional warnings in xfs_file_dio_aio_write#" \
> > >  	    -e "s#$warn2#Intentional warnings in xfs_file_dio_aio_read#" \
> > > @@ -563,7 +563,8 @@ _filter_aiodio_dmesg()
> > >  	    -e "s#$warn6#Intentional warnings in __xfs_get_blocks#" \
> > >  	    -e "s#$warn7#Intentional warnings in iomap_dio_actor#" \
> > >  	    -e "s#$warn8#Intentional warnings in iomap_dio_complete#" \
> > > -	    -e "s#$warn9#Intentional warnings in dio_complete#"
> > > +	    -e "s#$warn9#Intentional warnings in dio_complete#" \
> > > +	    -e "s#$warn10#Intentional warnings in iomap_dio_actor#"
> > >  }
> > >  
> > >  # We generate assert related WARNINGs on purpose and make sure test doesn't fail
