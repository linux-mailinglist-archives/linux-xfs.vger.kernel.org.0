Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4D8D4A827
	for <lists+linux-xfs@lfdr.de>; Tue, 18 Jun 2019 19:20:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729754AbfFRRUJ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 18 Jun 2019 13:20:09 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:44506 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728572AbfFRRUJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Jun 2019 13:20:09 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5IHESdj161611
        for <linux-xfs@vger.kernel.org>; Tue, 18 Jun 2019 17:20:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : mime-version : content-type; s=corp-2018-07-02;
 bh=EncWq40Q8CfqWTI+pDWX8YbOllfY/dFqLiyx42ruIy4=;
 b=Jd8P2mPFymNthJH9k93/i3pIsP1V/Al4HvBKe+nOedeIzTHYI2EaV3U3BZ9qRok/wk32
 gd1IsQJW88HVK2uhFmqjd0079OB5c0Kd8Y/x3kLZQqDYgyQjGyTD7QPUzQdQlFv1b9rp
 +TslCSee0zfDMdhlHW5qvL9oxQs6hYQfaFefvKOGwxq7CsCvdcvcTZmOMyZv2818Mf8H
 tMDcuJ7zf7z9MqCdbeHCqRPrjz9tZpJ86Ysh2hdB+3egZt+8SYZvzEhxXJY7KlGsOs5g
 M32UXMcULjEhZ2gazP0g1uNe/3UIMygJnmYVQ1Sr1y2r3aUqkYHOM9xpOplhDSPOBaDK zw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2t4rmp5uh5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 18 Jun 2019 17:20:06 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5IHJZG9117719
        for <linux-xfs@vger.kernel.org>; Tue, 18 Jun 2019 17:20:06 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2t59gdyfx3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 18 Jun 2019 17:20:06 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5IHK5Yc011069
        for <linux-xfs@vger.kernel.org>; Tue, 18 Jun 2019 17:20:05 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 18 Jun 2019 10:20:05 -0700
Date:   Tue, 18 Jun 2019 10:20:04 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfs-documentation: master updated to 3b2f427
Message-ID: <20190618172004.GF5387@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9292 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906180138
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9292 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906180138
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

The master branch of the xfs-documentation repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-documentation.git

has just been updated.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.

The new head of the master branch is commit:

3b2f427 Fix typos in xfs-documentation

New Commits:

Andrea Gelmini (1):
      [3b2f427] Fix typos in xfs-documentation


Code Diffstat:

 admin/XFS_Performance_Tuning/filesystem_tunables.asciidoc  |  6 +++---
 .../XFS_Performance_Tuning/xfs_performance_tuning.asciidoc |  4 ++--
 .../XFS_Filesystem_Structure/extended_attributes.asciidoc  |  2 +-
 design/XFS_Filesystem_Structure/journaling_log.asciidoc    |  2 +-
 design/XFS_Filesystem_Structure/magic.asciidoc             |  2 +-
 design/XFS_Filesystem_Structure/refcountbt.asciidoc        |  2 +-
 design/xfs-smr-structure.asciidoc                          | 14 +++++++-------
 7 files changed, 16 insertions(+), 16 deletions(-)
