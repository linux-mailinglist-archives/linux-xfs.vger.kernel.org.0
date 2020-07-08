Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C764217CDA
	for <lists+linux-xfs@lfdr.de>; Wed,  8 Jul 2020 03:56:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728479AbgGHBzu (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 7 Jul 2020 21:55:50 -0400
Received: from smtprelay0188.hostedemail.com ([216.40.44.188]:54202 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728191AbgGHBzu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Jul 2020 21:55:50 -0400
X-Greylist: delayed 437 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Jul 2020 21:55:49 EDT
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
        by smtpgrave04.hostedemail.com (Postfix) with ESMTP id 599AB18010607
        for <linux-xfs@vger.kernel.org>; Wed,  8 Jul 2020 01:48:33 +0000 (UTC)
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay03.hostedemail.com (Postfix) with ESMTP id 2656A837F24C;
        Wed,  8 Jul 2020 01:48:32 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:968:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1538:1593:1594:1711:1714:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3350:3622:3865:3867:3868:3871:3872:4321:5007:10004:10400:10450:10455:10848:11232:11658:11914:12297:12740:12760:12895:13069:13311:13357:13439:14659:14721:19904:19999:21080:21627:30054:30090:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: hand52_200294f26eb9
X-Filterd-Recvd-Size: 1327
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf20.hostedemail.com (Postfix) with ESMTPA;
        Wed,  8 Jul 2020 01:48:31 +0000 (UTC)
Message-ID: <96f58df8a489093fb239cea8d36768b921269056.camel@perches.com>
Subject: Re: [PATCH] xfs: Use fallthrough pseudo-keyword
From:   Joe Perches <joe@perches.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Tue, 07 Jul 2020 18:48:29 -0700
In-Reply-To: <20200707205036.GL7606@magnolia>
References: <20200707200504.GA4796@embeddedor>
         <20200707205036.GL7606@magnolia>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.3-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, 2020-07-07 at 13:50 -0700, Darrick J. Wong wrote:
> On Tue, Jul 07, 2020 at 03:05:04PM -0500, Gustavo A. R. Silva wrote:
> > Replace the existing /* fall through */ comments and its variants with
> > the new pseudo-keyword macro fallthrough[1]. Also, remove unnecessary
> > fall-through markings when it is the case.
[]
> I don't get it, what's the point?  Are gcc/clang
> refusing to support -Wimplicit-fallthrough=[1-4] past a certain date?

clang doesn't support comments


