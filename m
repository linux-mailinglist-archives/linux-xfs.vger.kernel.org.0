Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9D0075682
	for <lists+linux-xfs@lfdr.de>; Thu, 25 Jul 2019 20:02:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728099AbfGYSCT (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 25 Jul 2019 14:02:19 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:58336 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726645AbfGYSCT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Jul 2019 14:02:19 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6PHx6Pe142917;
        Thu, 25 Jul 2019 18:02:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=aOS0W3y4VOWubkWgP9G+z98Iz6V1V0J/7/UhSnyv57A=;
 b=YarkSZJ94Bv4nrDAslqefoAOpU4Bd1CJU8LW78WRXSrZVOQVpcq/lX5cRtBg1pO4VAQv
 haqwHIZHXN+5ma8tauSaqov2CHzZRnkcgjDfli1CEh/SauSkD6XuxQ5bOCxQFw1PEEfP
 xpqOsHptK/ksQbHwxFMTFjd5KARRosTaTgoBwshgMFFSa5JQ+ys/rAJpTci8DqYUsRz+
 W0+obM+lB7SqWmQMCQ8tmb5Z8wl3AtdWs6unYvQJ7kfS43VZHnaZygKaOyZwWTKq9GCa
 eWZuqjpUkvANUKNwAldfQPdM2lTU900ahFizYlJwwCraWwECWMSlYbuDHiWM73bjTvv2 0Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2tx61c5nxd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Jul 2019 18:02:16 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6PHwOll108152;
        Thu, 25 Jul 2019 18:02:16 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2tx60xyck7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Jul 2019 18:02:16 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x6PI2FLM005106;
        Thu, 25 Jul 2019 18:02:15 GMT
Received: from localhost (/10.144.111.83)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 25 Jul 2019 11:02:14 -0700
Date:   Thu, 25 Jul 2019 11:02:13 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 1/3] common: filter aiodio dmesg after fs/iomap.c to
 fs/iomap/ move
Message-ID: <20190725180213.GG1561054@magnolia>
References: <156394156831.1850719.2997473679130010771.stgit@magnolia>
 <156394157450.1850719.464315342783936237.stgit@magnolia>
 <20190724232117.GB7777@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190724232117.GB7777@dread.disaster.area>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9329 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1907250212
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9329 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1907250212
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 25, 2019 at 09:21:17AM +1000, Dave Chinner wrote:
> On Tue, Jul 23, 2019 at 09:12:54PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Since the iomap code are moving to fs/iomap/ we have to add new entries
> > to the aiodio dmesg filter to reflect this.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  common/filter |    4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > 
> > diff --git a/common/filter b/common/filter
> > index ed082d24..26fc2132 100644
> > --- a/common/filter
> > +++ b/common/filter
> > @@ -555,6 +555,7 @@ _filter_aiodio_dmesg()
> >  	local warn7="WARNING:.*fs/iomap\.c:.*iomap_dio_actor.*"
> >  	local warn8="WARNING:.*fs/iomap\.c:.*iomap_dio_complete.*"
> 
> There's two different warnings that need capturing here.

DOH, missed that.

> >  	local warn9="WARNING:.*fs/direct-io\.c:.*dio_complete.*"
> > +	local warn10="WARNING:.*fs/iomap/direct-io\.c:.*iomap_dio_actor.*"
> >  	sed -e "s#$warn1#Intentional warnings in xfs_file_dio_aio_write#" \
> >  	    -e "s#$warn2#Intentional warnings in xfs_file_dio_aio_read#" \
> >  	    -e "s#$warn3#Intentional warnings in xfs_file_read_iter#" \
> > @@ -563,7 +564,8 @@ _filter_aiodio_dmesg()
> >  	    -e "s#$warn6#Intentional warnings in __xfs_get_blocks#" \
> >  	    -e "s#$warn7#Intentional warnings in iomap_dio_actor#" \
> >  	    -e "s#$warn8#Intentional warnings in iomap_dio_complete#" \
> > -	    -e "s#$warn9#Intentional warnings in dio_complete#"
> > +	    -e "s#$warn9#Intentional warnings in dio_complete#" \
> > +	    -e "s#$warn10#Intentional warnings in iomap_dio_actor#"
> 
> Why not just change the regex in warn7/warn8 just to catch anything
> under fs/iomap rather than explictly specifying fs/iomap.c?

Ok I'll do that.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
