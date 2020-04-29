Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CCAC1BD0F5
	for <lists+linux-xfs@lfdr.de>; Wed, 29 Apr 2020 02:20:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726348AbgD2AUv (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 28 Apr 2020 20:20:51 -0400
Received: from smtprelay0215.hostedemail.com ([216.40.44.215]:34606 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726181AbgD2AUv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Apr 2020 20:20:51 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay04.hostedemail.com (Postfix) with ESMTP id 4513B180A7348;
        Wed, 29 Apr 2020 00:20:50 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1538:1568:1593:1594:1711:1714:1730:1747:1777:1792:2198:2199:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3867:3868:3870:3871:3872:4250:4321:5007:6117:6691:7901:10004:10400:10848:11232:11658:11914:12297:12740:12760:12895:13069:13311:13357:13439:14659:21080:21433:21627:21939:30054:30060:30090:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: wire97_5e685622e423d
X-Filterd-Recvd-Size: 2113
Received: from XPS-9350.home (unknown [47.151.136.130])
        (Authenticated sender: joe@perches.com)
        by omf03.hostedemail.com (Postfix) with ESMTPA;
        Wed, 29 Apr 2020 00:20:48 +0000 (UTC)
Message-ID: <08eafcec5b92626e1ad7906b948419e7300e7684.camel@perches.com>
Subject: Re: [PATCH] xfs: Use the correct style for SPDX License Identifier
From:   Joe Perches <joe@perches.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Nishad Kamdar <nishadkamdar@gmail.com>,
        Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date:   Tue, 28 Apr 2020 17:20:47 -0700
In-Reply-To: <CAHk-=wi2bdXuYhC9bd9FShtcf_u-6RUb3Qr_aXq3XtbCxR5NGQ@mail.gmail.com>
References: <20200425133504.GA11354@nishad> <20200427155617.GY6749@magnolia>
         <20200427172959.GB3936841@kroah.com>
         <515362d10c06567f35f0d5b7c3f2e121769fb04b.camel@perches.com>
         <20200427174611.GA4035548@kroah.com>
         <791a97d5d4dfd11af533a0bbd6ae27d1a2d479ee.camel@perches.com>
         <20200427183629.GA20158@kroah.com>
         <16b209d0b0c8034db62f8d4d0a260a00f0aa5d5e.camel@perches.com>
         <CAHk-=wgN=Ox112_O=GQ-kwMxYduix9gZFsr1GXXJWLpDpNDm5g@mail.gmail.com>
         <fdcc8aa5a506ba9c6a3e6e68a7147161424985bf.camel@perches.com>
         <CAHk-=wi2bdXuYhC9bd9FShtcf_u-6RUb3Qr_aXq3XtbCxR5NGQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, 2020-04-27 at 13:46 -0700, Linus Torvalds wrote:
> There is simply no point in EVER changing "GPL-2.0" into
> "GPL-2.0-only" etc, unless the thing is then touched for some other
> reason (which it may never be).

Which is _exactly_ what is happening here.

But the reason _not_ to touch it here is there would
be a difference between the SPDX license text in the
.c and .h files in the directory.


