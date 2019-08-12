Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EEB38A7A5
	for <lists+linux-xfs@lfdr.de>; Mon, 12 Aug 2019 21:57:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726679AbfHLT5l (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 12 Aug 2019 15:57:41 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:48084 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726200AbfHLT5l (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Aug 2019 15:57:41 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7CJE9K9126044
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 19:57:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=QjaWWznT7dTusSZ0bNHM0OxTAwvGolxxsm+BWp3y7F4=;
 b=jigIwSsie2ljPa94K1FMltDsucvjzvQxgMXCgCVwTwGT7UZFlHPpmf+t7w17FXgy1qHS
 npPJZK+FSIsJLk7Jh4gRZO/KTlu8lMhT0g+46waNBBsq5FyN29Voeq3f5uTuarOVvQOI
 3Nc3fGXT3epwthde/cNRSJ2JYTrF8/A/0+jcDUtpKRM+wgmcziBm/75vtS2S6+W7wGdw
 UMwtkwMGm6O2iEUNsLjvql0GZ5oCV7CoedwHFmuLb9HztOWC0YLAPTUu+fW75AcZJO6l
 bSMss/QR8aSfLqA6ZoqWRl5skpJnik888Ym2dd1TWoSmUpECPOUkehMnZEQVS1d7mHuB Dg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : mime-version : content-type; s=corp-2018-07-02;
 bh=QjaWWznT7dTusSZ0bNHM0OxTAwvGolxxsm+BWp3y7F4=;
 b=fqEGkSbI20Qwm1dIkf+GuegAulIrS3H6rcmMIiwRrghy8fQqzQBcBusx57vVL4oIEuwC
 3C42k8r0TC2ZQoe/GujU3pG1oY61zLk8Sr+tKhbBO/ZsJ32ptaSRgk4LkD21mW5mAD3b
 kBeLiEIJE7dfUNbtxYd/NsvqKYZtmLu6GwaHzE8pMGA7UiC0JKMbnqHppY4+v3IjgROa
 QegIqL/CyCt/OSnEuj0UNxvVDpPsLnMVoTN3s4qiI9eq0njkAeLV1UngUzA2DaongRNw
 a8H5mA9/UPB9sJErMpiCCh8U75nMMv3hUxpLvH6C+2BYGRpL5gU7Z8SgcgBNJNqIkdeO bA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2u9nvp1vcs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 19:57:39 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7CJCch8137781
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 19:55:38 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2u9k1vkq92-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 19:55:38 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7CJtctx021221
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 19:55:38 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 12 Aug 2019 12:55:37 -0700
Date:   Mon, 12 Aug 2019 12:55:37 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfs-linux: for-next updated to 8612de3f7ba6
Message-ID: <20190812195537.GL7138@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9347 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908120198
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9347 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908120198
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

The for-next branch of the xfs-linux repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been updated.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.

The new head of the for-next branch is commit:

8612de3f7ba6 xfs: don't crash on null attr fork xfs_bmapi_read

New Commits:

Darrick J. Wong (2):
      [858b44dc62a1] xfs: remove more ondisk directory corruption asserts
      [8612de3f7ba6] xfs: don't crash on null attr fork xfs_bmapi_read

Tetsuo Handa (1):
      [294fc7a4c8ec] fs: xfs: xfs_log: Don't use KM_MAYFAIL at xfs_log_reserve().


Code Diffstat:

 fs/xfs/libxfs/xfs_bmap.c      | 29 +++++++++++++++++++++--------
 fs/xfs/libxfs/xfs_da_btree.c  | 19 ++++++++++++-------
 fs/xfs/libxfs/xfs_dir2_node.c |  3 ++-
 fs/xfs/xfs_log.c              |  5 +----
 4 files changed, 36 insertions(+), 20 deletions(-)
