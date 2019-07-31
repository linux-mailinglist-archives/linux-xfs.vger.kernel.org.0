Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFA6B7C830
	for <lists+linux-xfs@lfdr.de>; Wed, 31 Jul 2019 18:08:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730037AbfGaQIz (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 31 Jul 2019 12:08:55 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:43228 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726526AbfGaQIz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 31 Jul 2019 12:08:55 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6VFYdAt076938;
        Wed, 31 Jul 2019 16:08:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=fm60scPY1Ghy61LIIlqIoZVY0TLxIxfzCh9t9sy/Vj8=;
 b=P3ZPJsbK4Hy/fiPOvIKxMHruHAowfzdglDeaLI+p4YM0VoMoFuFpzgFXWFGMNu+EEiXY
 46AarsDsBjxAU+PhS+tAWWIfRoQSsuM40L4dzAXonxt2QspZQcs58gHs8GsREktPqbVm
 tH6kLuNzANpQL26Cz5K0EVz3Vo9QNoYCXAVWMKV7BiCkAHVK+lznd/Q7NJU1bD7Jhr1e
 zAQo4vQJvJmZUnWuHktis5MNUFdzfbku3eLI8gCJJQYyN67YfcPsumMv/88hPPfC5lvm
 59t9IdjrDy9JJsyjqmPEw6cRGJeAuy39mcvKWO5DyTj7Z/mjDIhcdJmdnSXYTvjzkVNa Pg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2u0ejpp8n8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 31 Jul 2019 16:08:38 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6VG8MWX023727;
        Wed, 31 Jul 2019 16:08:37 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2u349d1xvp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 31 Jul 2019 16:08:37 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x6VG8XiM000943;
        Wed, 31 Jul 2019 16:08:33 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 31 Jul 2019 09:08:33 -0700
Date:   Wed, 31 Jul 2019 09:08:32 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs/122: add the new v5 bulkstat/inumbers ioctl
 structures
Message-ID: <20190731160832.GT1561054@magnolia>
References: <156394159426.1850833.16316913520596851191.stgit@magnolia>
 <156394161274.1850833.4300015313269610610.stgit@magnolia>
 <20190731114019.GB34040@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190731114019.GB34040@bfoster>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9335 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1907310160
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9335 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1907310158
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 31, 2019 at 07:40:20AM -0400, Brian Foster wrote:
> On Tue, Jul 23, 2019 at 09:13:32PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > The new v5 bulkstat and inumbers structures are correctly padded so that
> > no format changes are necessary across platforms, so add them to the
> > output.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  tests/xfs/122.out |    7 +++++++
> >  1 file changed, 7 insertions(+)
> > 
> > 
> > diff --git a/tests/xfs/122.out b/tests/xfs/122.out
> > index cf9ac9e2..e2f346eb 100644
> > --- a/tests/xfs/122.out
> > +++ b/tests/xfs/122.out
> > @@ -66,6 +66,10 @@ sizeof(struct xfs_btree_block_lhdr) = 64
> >  sizeof(struct xfs_btree_block_shdr) = 48
> >  sizeof(struct xfs_bud_log_format) = 16
> >  sizeof(struct xfs_bui_log_format) = 16
> > +sizeof(struct xfs_bulk_ireq) = 64
> > +sizeof(struct xfs_bulkstat) = 192
> > +sizeof(struct xfs_bulkstat_req) = 64
> > +sizeof(struct xfs_bulkstat_single_req) = 224
> >  sizeof(struct xfs_clone_args) = 32
> >  sizeof(struct xfs_cud_log_format) = 16
> >  sizeof(struct xfs_cui_log_format) = 16
> > @@ -89,6 +93,9 @@ sizeof(struct xfs_fsop_geom_v4) = 112
> >  sizeof(struct xfs_icreate_log) = 28
> >  sizeof(struct xfs_inode_log_format) = 56
> >  sizeof(struct xfs_inode_log_format_32) = 52
> > +sizeof(struct xfs_inumbers) = 24
> > +sizeof(struct xfs_inumbers_req) = 64
> > +sizeof(struct xfs_ireq) = 32
> 
> I don't see xfs_bulkstat_single_req or xfs_ireq in the latest kernel
> headers. Do we still have those? Otherwise looks fine.

Ooops, I forgot to remove those, will fix.

--D

> Brian
> 
> >  sizeof(struct xfs_log_dinode) = 176
> >  sizeof(struct xfs_map_extent) = 32
> >  sizeof(struct xfs_phys_extent) = 16
> > 
