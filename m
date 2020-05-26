Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61C971BABA5
	for <lists+linux-xfs@lfdr.de>; Mon, 27 Apr 2020 19:48:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726342AbgD0Rsz (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 27 Apr 2020 13:48:55 -0400
Received: from smtprelay0230.hostedemail.com ([216.40.44.230]:60996 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726223AbgD0Rsz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Apr 2020 13:48:55 -0400
X-Greylist: delayed 413 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 Apr 2020 13:48:54 EDT
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
        by smtpgrave05.hostedemail.com (Postfix) with ESMTP id D5F0218029148
        for <linux-xfs@vger.kernel.org>; Mon, 27 Apr 2020 17:42:02 +0000 (UTC)
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay02.hostedemail.com (Postfix) with ESMTP id ED6CD3CF6;
        Mon, 27 Apr 2020 17:42:00 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:421:599:960:967:973:982:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2393:2525:2553:2560:2563:2682:2685:2693:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3354:3622:3865:3866:3867:3870:3871:3872:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4250:4321:5007:6117:6119:7809:7901:7903:7904:9025:10004:10400:10450:10455:10848:11026:11232:11657:11658:11914:12043:12048:12297:12555:12740:12760:12895:13439:14096:14097:14181:14659:14721:19904:19999:21080:21433:21627:21788:21939:21990:30054:30090:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: bee19_2e797eea40b41
X-Filterd-Recvd-Size: 3336
Received: from XPS-9350.home (unknown [47.151.136.130])
        (Authenticated sender: joe@perches.com)
        by omf09.hostedemail.com (Postfix) with ESMTPA;
        Mon, 27 Apr 2020 17:41:59 +0000 (UTC)
Message-ID: <515362d10c06567f35f0d5b7c3f2e121769fb04b.camel@perches.com>
Subject: Re: [PATCH] xfs: Use the correct style for SPDX License Identifier
From:   Joe Perches <joe@perches.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kate Stewart <kstewart@linuxfoundation.org>
Cc:     Nishad Kamdar <nishadkamdar@gmail.com>,
        Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Mon, 27 Apr 2020 10:41:58 -0700
In-Reply-To: <20200427172959.GB3936841@kroah.com>
References: <20200425133504.GA11354@nishad> <20200427155617.GY6749@magnolia>
         <20200427172959.GB3936841@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, 2020-04-27 at 19:29 +0200, Greg Kroah-Hartman wrote:
> On Mon, Apr 27, 2020 at 08:56:18AM -0700, Darrick J. Wong wrote:
> > On Sat, Apr 25, 2020 at 07:05:09PM +0530, Nishad Kamdar wrote:
> > > This patch corrects the SPDX License Identifier style in
> > > header files related to XFS File System support.
> > > For C header files Documentation/process/license-rules.rst
> > > mandates C-like comments (opposed to C source files where
> > > C++ style should be used).
> > > 
> > > Changes made by using a script provided by Joe Perches here:
> > > https://lkml.org/lkml/2019/2/7/46.
[]
> > > diff --git a/fs/xfs/libxfs/xfs_ag_resv.h b/fs/xfs/libxfs/xfs_ag_resv.h
[]
> > > @@ -1,4 +1,4 @@
> > > -// SPDX-License-Identifier: GPL-2.0+
> > > +/* SPDX-License-Identifier: GPL-2.0+ */
> > 
> > I thought we were supposed to use 'GPL-2.0-or-newer' because 'GPL-2.0+'
> > is deprecated in some newer version of the SPDX standard?
> > 
> > <shrug>
> 
> The kernel follows the "older" SPDX standard, but will accept either,
> it's up to the author.  It is all documented in LICENSES/ if people
> really want to make sure.

I think the kernel should prefer the "newer" SPDX standard
for any/all changes to these lines.
---
 LICENSES/preferred/GPL-2.0 | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/LICENSES/preferred/GPL-2.0 b/LICENSES/preferred/GPL-2.0
index ff0812..c50f93 100644
--- a/LICENSES/preferred/GPL-2.0
+++ b/LICENSES/preferred/GPL-2.0
@@ -8,13 +8,13 @@ Usage-Guide:
   tag/value pairs into a comment according to the placement
   guidelines in the licensing rules documentation.
   For 'GNU General Public License (GPL) version 2 only' use:
-    SPDX-License-Identifier: GPL-2.0
-  or
     SPDX-License-Identifier: GPL-2.0-only
+  or the deprecated alternative
+    SPDX-License-Identifier: GPL-2.0
   For 'GNU General Public License (GPL) version 2 or any later version' use:
-    SPDX-License-Identifier: GPL-2.0+
-  or
     SPDX-License-Identifier: GPL-2.0-or-later
+  or the deprecated alternative
+    SPDX-License-Identifier: GPL-2.0+
 License-Text:
 
 		    GNU GENERAL PUBLIC LICENSE


