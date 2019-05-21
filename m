Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B2AD2563F
	for <lists+linux-xfs@lfdr.de>; Tue, 21 May 2019 18:58:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727946AbfEUQ6H (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 21 May 2019 12:58:07 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:51770 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726900AbfEUQ6H (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 May 2019 12:58:07 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4LGmqVl005150;
        Tue, 21 May 2019 16:58:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=gDDqdmZqw4yDM3JlzCB8ro/MB08gSfEL9nVqI7oDjMk=;
 b=4G3gbkzkEKrzVoyu2YbEWTGhQtOTIYvji+3gfKTGRaVWh8G9ToyaHTgtfsPpHU9TRFJk
 GZN6ppeLMnPDkz9GDdM8y+RhWGwGVYFOqQeNyina6vCPANGOGY68M3kEKNWXakEWChGt
 S9xsaTYp7SmVKI+hhoVlLdoZh/ubmV1byeNsmNcKXxjX1LZyf62CyjuyuMEagInKNv+f
 Yk5aMjUborR1qo1TqfdU3EOEL9KXpFH9S6jjdTmm6ixANGAy2SkO+P9zu8ciqCu50wqN
 yL2y5R/C/a/6cfXdd8hIWpGArPk8aImD1esobK8SDm7Ux6zDGHTJyUwXxkBNkXZhfYJz hQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2sjapqepm3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 May 2019 16:58:04 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4LGvbqV141561;
        Tue, 21 May 2019 16:58:04 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2skudbgg3k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 May 2019 16:58:03 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x4LGw2i5010942;
        Tue, 21 May 2019 16:58:03 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 21 May 2019 16:58:02 +0000
Date:   Tue, 21 May 2019 09:58:01 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/12] libxfs: refactor online geometry queries
Message-ID: <20190521165801.GB5141@magnolia>
References: <155839420081.68606.4573219764134939943.stgit@magnolia>
 <155839422001.68606.12869125311562128404.stgit@magnolia>
 <67eb11a7-d468-4b14-ab6d-714bd1de1f72@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <67eb11a7-d468-4b14-ab6d-714bd1de1f72@sandeen.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9264 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905210104
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9264 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905210103
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 21, 2019 at 11:38:56AM -0500, Eric Sandeen wrote:
> On 5/20/19 6:17 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Refactor all the open-coded XFS_IOC_FSGEOMETRY queries into a single
> > helper that we can use to standardize behaviors across mixed xfslibs
> > versions.  This is the prelude to introducing a new FSGEOMETRY version
> > in 5.2 and needing to fix the (relatively few) client programs.
> 
> Ok, helper is nice, but... libhandle?  I don't see how a geometry ioctl
> wrapper is related to libhandle.  Would this make more sense in libfrog/ ?

Secret goal here : I'd also like to convert xfsdump and xfstests to use
these helpers instead of forcing everyone to write their own graceful
degradation gluecode if they want to keep up with the new FSGEOMETRY
ioctl we're introducing in 5.2.

At the same time, putting it in libhandle means we need a better prefix
than xfs_ since that's for libxfs stuff.  Uh, maybe I'll redo this patch
with xfrog_ instead of xfs_ ?

--D

> -Eric
> 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  Makefile            |    9 +++++----
> >  fsr/xfs_fsr.c       |   25 +++----------------------
> >  growfs/Makefile     |    5 +++--
> >  growfs/xfs_growfs.c |   24 ++++++++----------------
> >  include/linux.h     |    5 +++++
> >  io/bmap.c           |    2 +-
> >  io/fsmap.c          |    2 +-
> >  io/open.c           |    2 +-
> >  io/stat.c           |    4 ++--
> >  libhandle/Makefile  |    2 +-
> >  libhandle/ioctl.c   |   26 ++++++++++++++++++++++++++
> >  quota/Makefile      |    4 ++--
> >  quota/free.c        |    5 ++---
> >  repair/Makefile     |    6 +++---
> >  repair/xfs_repair.c |    4 ++--
> >  rtcp/Makefile       |    3 +++
> >  rtcp/xfs_rtcp.c     |    6 +++---
> >  scrub/phase1.c      |    2 +-
> >  spaceman/Makefile   |    4 ++--
> >  spaceman/file.c     |    2 +-
> >  spaceman/info.c     |   24 +++++++-----------------
> >  21 files changed, 82 insertions(+), 84 deletions(-)
> >  create mode 100644 libhandle/ioctl.c
> > 
> > 
> > diff --git a/Makefile b/Makefile
> > index 9204bed8..b72a9209 100644
> > --- a/Makefile
> > +++ b/Makefile
> > @@ -99,14 +99,15 @@ $(LIB_SUBDIRS) $(TOOL_SUBDIRS): include libfrog
> >  $(DLIB_SUBDIRS) $(TOOL_SUBDIRS): libxfs
> >  db logprint: libxlog
> >  fsr: libhandle
> > -growfs: libxcmd
> > +growfs: libxcmd libhandle
> >  io: libxcmd libhandle
> > -quota: libxcmd
> > -repair: libxlog libxcmd
> > +quota: libxcmd libhandle
> > +repair: libxlog libxcmd libhandle
> >  copy: libxlog
> >  mkfs: libxcmd
> > -spaceman: libxcmd
> > +spaceman: libxcmd libhandle
> >  scrub: libhandle libxcmd
> > +rtcp: libhandle
> >  
> >  ifeq ($(HAVE_BUILDDEFS), yes)
> >  include $(BUILDRULES)
> 
> ...
