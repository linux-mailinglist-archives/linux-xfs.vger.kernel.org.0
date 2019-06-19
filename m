Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B13474AF53
	for <lists+linux-xfs@lfdr.de>; Wed, 19 Jun 2019 03:07:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726238AbfFSBHf (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 18 Jun 2019 21:07:35 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:39890 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726158AbfFSBHf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Jun 2019 21:07:35 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5J14Rm2007932;
        Wed, 19 Jun 2019 01:07:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=HKOgCqNmOVF3Ofjl+vRNUE9BKquS65v47Jcw/mBpaII=;
 b=D4tEomW8fq4p8RI8zN3dCJ/ri+xEThpdoEBYjibJqsG5yihBubDwhT7fw2gsAMwuIKzH
 xYAC51M1O2ZyUr5vk7cbGxfGOphS4AVPtND3/erSpabIw5O6ejuShaDQAbycrpBAUzrP
 2XHBtCsGUsTbflpfPal1qVicXyflP/55FG9dDdUnDNDHWaGL/JRqOAPOvyH2RhIZXDrS
 0a86B1IfeejzTT7bzECzAs81ldXi5pVQ8ycL/rGuQVN6rQAXakPeHQqbX7Yk8KgMiD46
 br4FDTc5xH1aDAJ2KpNhtHE1Sg1YJ+EO3CgyzUCS8X+F0dWdLZ+d4QhRxMYerYSg++cV og== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2t78098ftn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Jun 2019 01:07:09 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5J16WPg111767;
        Wed, 19 Jun 2019 01:07:09 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2t77ynhy7a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Jun 2019 01:07:08 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5J175ah004947;
        Wed, 19 Jun 2019 01:07:05 GMT
Received: from localhost (/10.159.145.69)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 18 Jun 2019 18:07:05 -0700
Date:   Tue, 18 Jun 2019 18:07:04 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH] xfs: move xfs_ino_geometry to xfs_mount.h
Message-ID: <20190619010704.GA5402@magnolia>
References: <20190618205935.GS5387@magnolia>
 <20190619004041.GA26375@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190619004041.GA26375@dread.disaster.area>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9292 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906190006
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9292 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906190007
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 19, 2019 at 10:40:41AM +1000, Dave Chinner wrote:
> On Tue, Jun 18, 2019 at 01:59:36PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > The inode geometry structure isn't related to ondisk format; it's
> > support for the mount structure.  Move it to xfs_mount.h.
> 
> That means we have to duplicate it in userspace - xfs_mount.h is not
> shared. I'd suggest that libxfs/xfs_shared.h would be a better place
> for it.

Well that will make the patch wayyy bigger since now every file has to
include xfs_shared.h (right now 26 of them do not)...

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
