Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B79A354BA
	for <lists+linux-xfs@lfdr.de>; Wed,  5 Jun 2019 02:24:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726427AbfFEAYR (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 4 Jun 2019 20:24:17 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:48230 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbfFEAYR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Jun 2019 20:24:17 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x550OE41174498;
        Wed, 5 Jun 2019 00:24:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=koe/9BtrOrPmdJL4EajVRtW1laDTJbH4aFUQYuu1OB8=;
 b=KjY38xCbJJhSR3gKnbXDCjlSPocIiFz250/3q3x79ayqz3W7JGdqIEeTyuWep6/DZ9fP
 vvDh/VYEPpYRmrDwiXGS6QGPAOUMdIN/RV7qZ0Q3Dv+j19i2zgfwYref2tpQbcvDP382
 yQg61nsf8hu4S0eIOmoQU0V+5n2ALjHv2WER589BWzdK80CNVdYxdQRgcGQQizZyl99g
 m1qp1meQPcjWMZbMd/u1HtPIxNe6VcPwclyEQ9Kf9Dz0VtmK18FT8dRYn2C8r9HmHXDP
 rhyBOLmrQ52dLbjedQ3lt/742FNbAGWRQYv9d7druQasbhg+w9nb3Rzz+zSNQ02OSPHT zA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 2suevdg9us-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Jun 2019 00:24:14 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x550N3j3056199;
        Wed, 5 Jun 2019 00:24:13 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2swngkmy1e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Jun 2019 00:24:13 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x550OCWo006757;
        Wed, 5 Jun 2019 00:24:13 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 04 Jun 2019 17:24:12 -0700
Date:   Tue, 4 Jun 2019 17:24:11 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs: fix inode_cluster_size rounding mayhem
Message-ID: <20190605002411.GF1200785@magnolia>
References: <155968493259.1657505.18397791996876650910.stgit@magnolia>
 <155968495968.1657505.12432054087739349861.stgit@magnolia>
 <20190604220518.GA29573@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190604220518.GA29573@dread.disaster.area>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9278 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906050000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9278 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906050000
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 05, 2019 at 08:05:18AM +1000, Dave Chinner wrote:
> On Tue, Jun 04, 2019 at 02:49:19PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > inode_cluster_size is supposed to represent the size (in bytes) of an
> > inode cluster buffer.  We avoid having to handle multiple clusters per
> > filesystem block on filesystems with large blocks by openly rounding
> > this value up to 1 FSB when necessary.  However, we never reset
> > inode_cluster_size to reflect this new rounded value, which adds to the
> > potential for mistakes in calculating geometries.
> > 
> > Fix this by setting inode_cluster_size to reflect the rounded-up size if
> > needed, and special-case the few places in the sparse inodes code where
> > we actually need the smaller value to validate on-disk metadata.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> LGTM.
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

Thanks for the review!

--D

> 
> -- 
> Dave Chinner
> david@fromorbit.com
