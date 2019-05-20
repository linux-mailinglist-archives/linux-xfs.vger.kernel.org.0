Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4531D24300
	for <lists+linux-xfs@lfdr.de>; Mon, 20 May 2019 23:41:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726111AbfETVl5 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 20 May 2019 17:41:57 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:45676 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725810AbfETVl5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 May 2019 17:41:57 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4KLfHt5086885;
        Mon, 20 May 2019 21:41:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=llG/C8kKdatLRhF7rfVY1Vkkgi1cpRR+okEhzdjMzYs=;
 b=fjp8ncm6pqR7T+K0VI8yW6eSR4TxavVIR/SCPm8FCILppsAiW3PClMFnDJPnYBOlK+5N
 Ga3u6SPizSsnzWqRRI545FgmoUIJs3zFGSJDtfKhzX1dmNiSopGDtNNb3hviSaHX69A1
 k5NgPTxxhTGyec6MhyD93h8YNTeHo8HXCZBL1OPM+gaWCbjN5P20ShHaZvO4KgE7S8Up
 FqFeY/0MV9Iclc0Ntfe0FKY1Mc+D/c5iUgZxMZG/pMhaVeR8EraJV/DSf3Kc2eiDcLid
 Nz+WjbFVqA4mHauCI9F0yX6LLftpURcvmmwhaQGhxT6oJZkqWiNY9H3LENJTR2DVSMK7 Fg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2sjapq9jj8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 May 2019 21:41:16 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4KLdcoP064219;
        Mon, 20 May 2019 21:41:16 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2sks1j378n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 May 2019 21:41:16 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x4KLfFRB003104;
        Mon, 20 May 2019 21:41:15 GMT
Received: from localhost (/10.159.247.197)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 20 May 2019 21:41:15 +0000
Date:   Mon, 20 May 2019 14:41:14 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: remove unused flag arguments
Message-ID: <20190520214114.GN5352@magnolia>
References: <ed89244f-cc3a-6bcf-316c-68edc8aee4cc@redhat.com>
 <20190520212139.GC5335@magnolia>
 <a0756ae7-eb4d-c25a-a567-d8d27301d12b@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a0756ae7-eb4d-c25a-a567-d8d27301d12b@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9263 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905200134
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9263 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905200134
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 20, 2019 at 04:31:08PM -0500, Eric Sandeen wrote:
> On 5/20/19 4:21 PM, Darrick J. Wong wrote:
> > On Wed, May 15, 2019 at 01:37:32PM -0500, Eric Sandeen wrote:
> >> There are several functions which take a flag argument that is
> >> only ever passed as "0," so remove these arguments.
> >>
> >> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> >> ---
> >>
> >> (motivated by simplifying userspace libxfs, TBH)
> >>
> >>  libxfs/xfs_ag.c          |    8 ++++----
> >>  libxfs/xfs_alloc.c       |    4 ++--
> >>  libxfs/xfs_attr_remote.c |    2 +-
> >>  libxfs/xfs_bmap.c        |   14 +++++++-------
> >>  libxfs/xfs_btree.c       |   30 +++++++++++-------------------
> >>  libxfs/xfs_btree.h       |   10 +++-------
> >>  libxfs/xfs_sb.c          |    2 +-
> >>  scrub/repair.c           |    2 +-
> >>  xfs_bmap_util.c          |    6 +++---
> >>  xfs_buf.h                |    5 ++---
> > 
> > Do you have an accompanying xfsprogs patch up your sleeve somewhere too?
> > :)
> 
> yeah it's on the list, trying to decide if I want to wait and
> libxfs-merge this or just do it since IIRC it's kind of in the way
> of my other xfsprogs patches...

I'd prefer you wait so that we don't have xfsprogs out of sync with
kernel for a release.

--D

> -Eric
> 
