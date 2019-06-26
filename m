Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 228B356EEF
	for <lists+linux-xfs@lfdr.de>; Wed, 26 Jun 2019 18:38:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726320AbfFZQih (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 26 Jun 2019 12:38:37 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:50596 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726307AbfFZQih (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Jun 2019 12:38:37 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5QGYxf9014718
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jun 2019 16:38:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : mime-version : content-type; s=corp-2018-07-02;
 bh=hc5gmhBVBSG5tH0+OKMExW+5PL5pHmWou9E6R1utfm8=;
 b=ptmaUDbhDvENLUsrp+pO6FJ473xvMcDM+zNA1Fq+4YAkeeCMJsQfQu90kzAvbdWKh7o0
 W7h6BgABE49qBu2pwwBcHbF1T9+VH6mtJ8gS54/nD42f6Efx0y4IkHBSbvQalODG5Dti
 BkD/SmTx2AwT1WEMJDnez6vB8JRZc/5pmA9O+0ZZQ96Dg2UTUcEI7qFYrTxeHOpHQZCl
 qEOpAslERmyKM3x2S5TA5ldvHjd2lE5b6AXeIpmN0khXWHY4xOd8zvsEQZsYzFOCUAdy
 jgVucdXBwgoqbSNqYdotu+DCo3D3iFWN59HIHHaY8jxE2StXLMhBD4jvGRzhRcMDjjR3 AA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2t9cyqkd1f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jun 2019 16:38:36 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5QGcBpP026169
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jun 2019 16:38:35 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2t99f4jgn2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jun 2019 16:38:35 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5QGcZa6006793
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jun 2019 16:38:35 GMT
Received: from localhost (/10.159.137.246)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 26 Jun 2019 09:38:34 -0700
Date:   Wed, 26 Jun 2019 09:38:34 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfs-linux: for-next updated to c0546224d7e9
Message-ID: <20190626163834.GG5171@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9300 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906260195
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9300 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906260194
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

c0546224d7e9 xfs: implement cgroup aware writeback

New Commits:

Christoph Hellwig (2):
      [7f72216dc9a3] xfs: simplify xfs_chain_bio
      [c0546224d7e9] xfs: implement cgroup aware writeback

Darrick J. Wong (2):
      [8069dcc20df1] xfs: refactor free space btree record initialization
      [eef36088357e] xfs: account for log space when formatting new AGs


Code Diffstat:

 fs/xfs/libxfs/xfs_ag.c | 94 ++++++++++++++++++++++++++++++++++++++++++++------
 fs/xfs/xfs_aops.c      | 37 ++++++++++----------
 fs/xfs/xfs_super.c     |  2 ++
 3 files changed, 104 insertions(+), 29 deletions(-)
