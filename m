Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37ACC60AB7
	for <lists+linux-xfs@lfdr.de>; Fri,  5 Jul 2019 19:04:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726505AbfGEREM (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 5 Jul 2019 13:04:12 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:48584 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725681AbfGEREM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Jul 2019 13:04:12 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x65H3el0060350;
        Fri, 5 Jul 2019 17:03:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=cf48QVOut6jCpMcFoHvOMwmiSKSdZUy7UEBub3Io2vg=;
 b=A2u3Wd887PAcUScC+NsLloRI30lTwAAVCmsR0qSrrTyB8FBp6IMZpvBQl1FuGOWxZMT7
 tnPsaclD3jeie+5I31Kt62jrTSRgQW2WEzRIXQRw4dsH/YmYRWv72U55y5P23djZTgYu
 bHG36CbH47rmkE4ceKw3ErGP3gH540KgRuVDAeMwRZs96+552Ieh82RwIF1UQfQzSyZJ
 I9woIqu73QoKcfa/eVdyC0FKUBge6dgK80B8cwPMzAySYRi/LhRIYrwm6bxpx0y5fi4u
 EgeRNuqBPBGFXik2AekA7APxrcYd/Wyv3pMecWzfX58aeW1vz/Dl30n11gfFL3k4O7LR Gg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2te5tc3wuc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Jul 2019 17:03:48 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x65H2OlO033344;
        Fri, 5 Jul 2019 17:03:47 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2th5qmkvv8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Jul 2019 17:03:47 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x65H3kfd008085;
        Fri, 5 Jul 2019 17:03:46 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 05 Jul 2019 10:03:46 -0700
Date:   Fri, 5 Jul 2019 10:03:45 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/6] xfs: remove more ondisk directory corruption asserts
Message-ID: <20190705170345.GH1404256@magnolia>
References: <156158199378.495944.4088787757066517679.stgit@magnolia>
 <156158199994.495944.4584531696054696463.stgit@magnolia>
 <20190705144904.GC37448@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190705144904.GC37448@bfoster>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9309 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907050210
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9309 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907050210
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 05, 2019 at 10:49:05AM -0400, Brian Foster wrote:
> On Wed, Jun 26, 2019 at 01:46:40PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Continue our game of replacing ASSERTs for corrupt ondisk metadata with
> > EFSCORRUPTED returns.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_da_btree.c  |   19 ++++++++++++-------
> >  fs/xfs/libxfs/xfs_dir2_node.c |    3 ++-
> >  2 files changed, 14 insertions(+), 8 deletions(-)
> > 
> > 
> ...
> > diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
> > index 16731d2d684b..f7f3fb458019 100644
> > --- a/fs/xfs/libxfs/xfs_dir2_node.c
> > +++ b/fs/xfs/libxfs/xfs_dir2_node.c
> > @@ -743,7 +743,8 @@ xfs_dir2_leafn_lookup_for_entry(
> >  	ents = dp->d_ops->leaf_ents_p(leaf);
> >  
> >  	xfs_dir3_leaf_check(dp, bp);
> > -	ASSERT(leafhdr.count > 0);
> > +	if (leafhdr.count <= 0)
> > +		return -EFSCORRUPTED;
> 
> This error return bubbles up to xfs_dir2_leafn_lookup_int() and
> xfs_da3_node_lookup_int(). The latter has a direct return value as well
> as a *result return parameter, which unconditionally carries the return
> value from xfs_dir2_leafn_lookup_int(). xfs_da3_node_lookup_int() has
> multiple callers, but a quick look at one (xfs_attr_node_addname())
> suggests we might not handle corruption errors properly via the *result
> parameter. Perhaps we also need to fix up xfs_da3_node_lookup_int() to
> return particular errors directly?

It would be a good idea to clean up the whole return value/*retval mess
in that function (and xfs_da3_path_shift where *retval came from) but
that quickly turned into a bigger cleanup of magic values and dual
returns, particularly since the dabtree shrinking code turns the
_path_shift *retval into yet another series of magic int numbers...

...so in the meantime this at least fixes the asserts I see when running
fuzz testing.  I'll look at the broader cleanup for 5.4.

--D

> 
> Brian
> 
> >  
> >  	/*
> >  	 * Look up the hash value in the leaf entries.
> > 
