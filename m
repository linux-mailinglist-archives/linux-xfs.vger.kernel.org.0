Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1689884D8
	for <lists+linux-xfs@lfdr.de>; Fri,  9 Aug 2019 23:38:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728041AbfHIViR (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 9 Aug 2019 17:38:17 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:56290 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726125AbfHIViR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Aug 2019 17:38:17 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x79LZ7nE093158
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:38:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2019-08-05;
 bh=aKXNL2JFu1YeZQ77Dt6Emwen3sUEO5C+/W+aPLB4RxE=;
 b=KT99o6UbJljYdDTGkPgyq+YDZzmLP+kKmSC+ZUkN/72QUL1L1BN5c0PNuXWhKc011NjC
 JKVoF5AE4u9qglcZl+raZrVYuXU0T1jtJjOinVwYALG2MvCchXlvFFgkdoQutxSxnHwj
 zqVYtTmFt5NDsMMRfooM7EcdhmvavqvO5Of4MKhmRzSe3MXUqI6ryfimqGVGIBtNZ775
 HjlszoFtoxMoNIBRjGIm8F4loOJhrZ+tcavnBe3Pb5WkigYZh19yGZnQLh9Pd3XJdpq5
 v2gkK3HIaEMhsgn+DP0svnCdUbLDtcNFnxHmimiCcNETuy1Vz2rd58DogqIKc3uyfgxh tQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2018-07-02;
 bh=aKXNL2JFu1YeZQ77Dt6Emwen3sUEO5C+/W+aPLB4RxE=;
 b=jHJcYd7PMnBeITgTlXatmT0yU2VkGhVL1pjGFmFBnR+p08W+DWbY4DcfxkBPHo0e3Hi0
 1phJGNPxA2Mgw8ZfW9W/4VbYnhQpDe1B/cTBboElz60HiB5nlZ8YSANxhERX+ocBLz7X
 QNUVEPrAzoKecFPxwcrS+QyrwksTc4eeT1/+QPyPYzI3MEzYYqwxo5iiyrtSUxc9XltL
 LD4agk87Ap91w8HFEpipw1WZWQYnzGtuRai/gGOET8i4e/U2QkR0GDm63IuWc1ImB2eN
 Q975IkCRSfjh11S7+UAFc84Z1LIlrtbwePCqQWILdvsuVflTLiEZTOXTfh7sLni2eDYO EQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2u8hasj99t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 09 Aug 2019 21:38:15 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x79LNLMX071982
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:38:15 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2u8x9fxk86-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 09 Aug 2019 21:38:15 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x79LcERJ002112
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:38:14 GMT
Received: from localhost.localdomain (/70.176.225.12)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 09 Aug 2019 14:38:14 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v1 00/19] Delayed Attributes
Date:   Fri,  9 Aug 2019 14:37:45 -0700
Message-Id: <20190809213804.32628-1-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9344 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908090207
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9344 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908090208
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This set applies the corresponding changes for delayed attributes to xfsprogs.  
The goal of the set is to provide basic utilities to replay and print the new
attribute log entries.

The first 18 patches synchronize libxfs with changes seen the kernel space
patches. The last patch adds routines for journal replay and printing. I will 
pick up the reviews from the kernel side series and mirror them here.  

Thanks all!
Allison

Allison Collins (18):
  xfsprogs: Remove all strlen in all xfs_attr_* functions for attr
    names.
  xfsprog: Replace attribute parameters with struct xfs_name
  xfsprogs: Set up infastructure for deferred attribute operations
  xfsprogs: Add xfs_attr_set_deferred and xfs_attr_remove_deferred
  xfsprogs: Add xfs_has_attr and subroutines
  xfsprogs: Factor out new helper functions xfs_attr_rmtval_set
  xfsprogs: Factor up trans handling in xfs_attr3_leaf_flipflags
  xfsprogs: Factor out xfs_attr_leaf_addname helper
  xfsprogs: Factor up commit from xfs_attr_try_sf_addname
  xfsprogs: Factor up trans roll from xfs_attr3_leaf_setflag
  xfsprogs: Add xfs_attr3_leaf helper functions
  xfsprogs: Factor out xfs_attr_rmtval_remove_value
  xfsprogs: Factor up trans roll in xfs_attr3_leaf_clearflag
  xfsprogs: Add delay context to xfs_da_args
  xfsprogs: Add delayed attribute routines
  xfsprogs: Roll delayed attr operations by returning EAGAIN
  xfsprogs: Enable delayed attributes
  xfsprogs: Add delayed attributes error tag

Allison Henderson (1):
  xfsprogs: Add log item printing for ATTRI and ATTRD

 db/attrset.c             |   13 +-
 io/inject.c              |    1 +
 libxfs/defer_item.c      |  174 ++++++-
 libxfs/libxfs_priv.h     |   12 +-
 libxfs/xfs_attr.c        | 1145 +++++++++++++++++++++++++++++++++++++++++-----
 libxfs/xfs_attr.h        |   49 +-
 libxfs/xfs_attr_leaf.c   |  167 +++++--
 libxfs/xfs_attr_leaf.h   |    4 +
 libxfs/xfs_attr_remote.c |   98 +++-
 libxfs/xfs_attr_remote.h |    5 +-
 libxfs/xfs_da_btree.h    |   23 +
 libxfs/xfs_defer.c       |    1 +
 libxfs/xfs_defer.h       |    3 +
 libxfs/xfs_errortag.h    |    4 +-
 libxfs/xfs_log_format.h  |   44 +-
 libxfs/xfs_types.h       |    1 +
 logprint/log_misc.c      |   31 +-
 logprint/log_print_all.c |   12 +
 logprint/log_redo.c      |  189 ++++++++
 logprint/logprint.h      |    7 +
 20 files changed, 1783 insertions(+), 200 deletions(-)

-- 
2.7.4

