Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B036168254
	for <lists+linux-xfs@lfdr.de>; Fri, 21 Feb 2020 16:52:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728379AbgBUPvy (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 21 Feb 2020 10:51:54 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:58752 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728235AbgBUPvy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Feb 2020 10:51:54 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01LFhUEr106506;
        Fri, 21 Feb 2020 15:51:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=WTS+WmIAeD+wLWwkAW6o6vZpM/h7nUa2W9tl1LuI3bs=;
 b=C3E45d1mm9FHvgeJRq5kts/+klh8rU+Ud/gLKw9fl5bjdHfdl2cWz8Mm1q68vTiiWRot
 4FyELsm70+zs7NB2hHU6aXdaYik0MVqs6J16+lydbobhUPZLUfDeJK9EoiWdeVScQTSM
 GYGcPMNrojDAIlk273U/Q2kD+fVPFoBNuRUGLd7NqVxGsHjOHdELY8EkRrxOr8eQwHv5
 n7z+p/ep1imhohlcVwvMMBbdxoGhiP7a1YjMEp1PdJrn2LUKZ709dmCjOPZykv5biA55
 BCaxEDVLs2iiV6OvtENLCXulWd6bnme7xSMxlyfi99DmerJgJl1xtIgNptQ8Tzt9Lk5B Zg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2y8uddhbf5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Feb 2020 15:51:49 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01LFgmBW126807;
        Fri, 21 Feb 2020 15:51:48 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2y8udfdcb4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Feb 2020 15:51:48 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01LFpldj010587;
        Fri, 21 Feb 2020 15:51:48 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 21 Feb 2020 07:51:47 -0800
Date:   Fri, 21 Feb 2020 07:51:46 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/18] libxlog: use uncached buffers instead of
 open-coding them
Message-ID: <20200221155146.GR9506@magnolia>
References: <158216295405.602314.2094526611933874427.stgit@magnolia>
 <158216302373.602314.13809511355239867956.stgit@magnolia>
 <20200221144959.GI15358@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200221144959.GI15358@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9537 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002210119
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9537 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 mlxscore=0 suspectscore=0
 priorityscore=1501 bulkscore=0 adultscore=0 spamscore=0 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002210119
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Feb 21, 2020 at 06:49:59AM -0800, Christoph Hellwig wrote:
> On Wed, Feb 19, 2020 at 05:43:43PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Use the new uncached buffer functions to manage buffers instead of
> > open-coding the logic.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Isn't xfs_log_recover.c supposed to be partially shared with the kernel?
> I guess I need to port over my changes to the buffer handling there,
> which would mean implementing xfs_rw_bdev using preadv/pwritev.

It ought to be, but the file has fallen very far out of sync with the
kernel and I didn't want to launch a log recovery reconstruction
project.  This patch is useful to get us to the point of having one
buffer api and using it consistently, but that's about it...

--D
