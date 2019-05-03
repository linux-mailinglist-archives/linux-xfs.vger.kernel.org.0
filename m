Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1046713500
	for <lists+linux-xfs@lfdr.de>; Fri,  3 May 2019 23:49:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726600AbfECVtf (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 3 May 2019 17:49:35 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:54884 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbfECVtf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 May 2019 17:49:35 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x43Ln9Wu190214;
        Fri, 3 May 2019 21:49:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=y/cLpihV9j7KHK4EUhwAYL39YcXgj0AVibMZxDi2XlE=;
 b=w6s3nEeOUckJ84U43ly2BzclkK9QojlhBNPF+2Hn11HIx2zEMjcsIfA6G35l5NwGsaaG
 /0vjlJv5HsmeDZSPHh76+jvIDAHlwjbjy/Mw+yeZi1iBJDUBFfhCJ9yvnL4nS2bjNUAn
 ReVlfx/x4Qd264enTfQ2ci1O+7JQz4/XyahAXCkAKdKQnxirJKvQOOfQ8/kgEXVikBmO
 57CUp4aKS4SJqI2VngIRIArsybAQboyICpQErjumPF0sgOXGjZMqkaVfZyF9N9+E3PWx
 exlDi5hP38xqher4RXfAsf7KSYewhxjsgImLteg1XuUeDl3aKvzUDlUTtsQ9PWxAn2kf 9A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2s6xj01atg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 May 2019 21:49:22 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x43LliBD050189;
        Fri, 3 May 2019 21:49:22 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2s7p8ajh63-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 May 2019 21:49:22 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x43LnKGA012724;
        Fri, 3 May 2019 21:49:21 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 03 May 2019 14:49:20 -0700
Date:   Fri, 3 May 2019 14:49:13 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Eric Sandeen <sandeen@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] mkfs: enable reflink and rmap by default
Message-ID: <20190503214913.GR5207@magnolia>
References: <20190503005717.GO5207@magnolia>
 <b406bac9-1899-1714-a14f-472fb4bbaffd@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b406bac9-1899-1714-a14f-472fb4bbaffd@sandeen.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9246 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905030139
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9246 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905030140
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 03, 2019 at 10:55:05AM -0500, Eric Sandeen wrote:
> On 5/2/19 7:57 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Enable reflink and reverse mapping by default.
> 
> Soooo until now, I thought I had understood that rmap was unlikely
> to be default ever, due to performance impacts.  Is this no longer the case?

No, it's still the case.

> Of course I can't find any emails or IRC logs to indicate I didn't
> just dream this up...
> 
> Also, at this point, remind me again what uses rmap and why it should
> be enabled now?

TBH it's most useful for enhancing xfs_scrub's powers, so there's no
reason to enable it by default until at least 5.2 when we finally land
the last of the scrubbers.  Probably.  One could make a solid argument
that we ought to wait until the scrub/health code has been stable for
~6mo before even thinking about rmap by default.

Anyway I'll break this into separate pieces and resend the reflink part
for 5.1.

--D

> 
> -Eric
> 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  mkfs/xfs_mkfs.c |    8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> > 
> > diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> > index 0862621a..3874f7dd 100644
> > --- a/mkfs/xfs_mkfs.c
> > +++ b/mkfs/xfs_mkfs.c
> > @@ -2021,14 +2021,14 @@ _("sparse inodes not supported without CRC support\n"));
> >  		}
> >  		cli->sb_feat.spinodes = false;
> >  
> > -		if (cli->sb_feat.rmapbt) {
> > +		if (cli->sb_feat.rmapbt && cli_opt_set(&mopts, M_RMAPBT)) {
> >  			fprintf(stderr,
> >  _("rmapbt not supported without CRC support\n"));
> >  			usage();
> >  		}
> >  		cli->sb_feat.rmapbt = false;
> >  
> > -		if (cli->sb_feat.reflink) {
> > +		if (cli->sb_feat.reflink && cli_opt_set(&mopts, M_REFLINK)) {
> >  			fprintf(stderr,
> >  _("reflink not supported without CRC support\n"));
> >  			usage();
> > @@ -3934,8 +3934,8 @@ main(
> >  			.dirftype = true,
> >  			.finobt = true,
> >  			.spinodes = true,
> > -			.rmapbt = false,
> > -			.reflink = false,
> > +			.rmapbt = true,
> > +			.reflink = true,
> >  			.parent_pointers = false,
> >  			.nodalign = false,
> >  			.nortalign = false,
> > 
