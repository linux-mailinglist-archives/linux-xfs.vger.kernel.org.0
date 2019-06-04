Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55AEE34C32
	for <lists+linux-xfs@lfdr.de>; Tue,  4 Jun 2019 17:27:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727901AbfFDP1c (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 4 Jun 2019 11:27:32 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:34038 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727843AbfFDP1c (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Jun 2019 11:27:32 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x54FOPLw130975
        for <linux-xfs@vger.kernel.org>; Tue, 4 Jun 2019 15:27:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : mime-version : content-type; s=corp-2018-07-02;
 bh=KPGJm6TfzronfH3PfzL1kkNhuIkJge6USusOPA8Rq0Y=;
 b=1F8IHz0vtsvRRCUo6cKR8orpGra0LTHxtRlqYKOhnpwAtSDIiZT9QYmeyy00vy6POiWI
 z53x3k4lQlkknGsUBij6EoT+r8YQGRj1PVv7oQBFZ0kLTVdGRYd66u/PiV/pt4GVPt2P
 FkHfq4B5qRr74MttcKtLhkplbuAD8uuJ8v8Do+HBx4OKznga+lZJfZfRiTnVljG1ytys
 LW/3W4T1FHB0hMr1FF4ajL4Nt2SbHEO1erh86WXVj1aTANJGV1CX5asVfjGmDxXx8mAX
 h6uBu66fWSOjS3vnmwHouo7Lavdv5VTEDI3IQ7bYoohM/UXPgCNwcNgFWmjyhIHPzayq Lw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2sugstdu0w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 04 Jun 2019 15:27:30 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x54FQjCw182604
        for <linux-xfs@vger.kernel.org>; Tue, 4 Jun 2019 15:27:30 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2swngkdp59-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 04 Jun 2019 15:27:30 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x54FRTLe032316
        for <linux-xfs@vger.kernel.org>; Tue, 4 Jun 2019 15:27:29 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 04 Jun 2019 08:27:29 -0700
Date:   Tue, 4 Jun 2019 08:27:28 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfs-linux: for-next updated to 025197ebb08a
Message-ID: <20190604152728.GA1200817@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9278 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906040100
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9278 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906040101
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
the next update.  FWIW these are only bugfixes for 5.2.

The new head of the for-next branch is commit:

025197ebb08a xfs: inode btree scrubber should calculate im_boffset correctly

New Commits:

Darrick J. Wong (2):
      [d31d718528dd] xfs: fix broken log reservation debugging
      [025197ebb08a] xfs: inode btree scrubber should calculate im_boffset correctly


Code Diffstat:

 fs/xfs/scrub/ialloc.c |  3 ++-
 fs/xfs/xfs_log.c      | 11 +++++++++--
 2 files changed, 11 insertions(+), 3 deletions(-)
